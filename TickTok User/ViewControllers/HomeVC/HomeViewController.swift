//
//  HomeViewController.swift
//  TickTok User
//
//  Created by Excellent Webworld on 26/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
//import SideMenu
import SocketIO
import SDWebImage
import NVActivityIndicatorView
import M13Checkbox

//let BaseURL = "http://54.206.55.185:8080"

protocol FavouriteLocationDelegate {
    func didEnterFavouriteDestination(Source: [String: AnyObject])
}

protocol CompleterTripInfoDelegate {
    func didRatingCompleted()
}

protocol addCardFromHomeVCDelegate {
    func didAddCardFromHomeVC()
}

var isSocketConnected = false


class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, GMSAutocompleteViewControllerDelegate, FavouriteLocationDelegate, UIPickerViewDelegate, UIPickerViewDataSource, NVActivityIndicatorViewable, UIGestureRecognizerDelegate, FloatRatingViewDelegate, CompleterTripInfoDelegate, ARCarMovementDelegate, GMSMapViewDelegate, addCardFromHomeVCDelegate {
    
    let baseURLDirections = "https://maps.googleapis.com/maps/api/directions/json?"
    let baseUrlForGetAddress = "https://maps.googleapis.com/maps/api/geocode/json?"
    let baseUrlForAutocompleteAddress = "https://maps.googleapis.com/maps/api/place/autocomplete/json?"
    
    let apikey = googlPlacesApiKey //"AIzaSyCKEP5WGD7n5QWtCopu0QXOzM9Qec4vAfE"
    
    let socket = SocketIOClient(socketURL: URL(string: SocketData.kBaseURL)!, config: [.log(false), .compress])
    
    //    let socket = (UIApplication.shared.delegate as! AppDelegate).SocketManager
    
    var moveMent: ARCarMovement!
    var driverMarker: GMSMarker!
    
    var timer = Timer()
    var timerToGetDriverLocation : Timer!
    var aryCards = [[String:AnyObject]]()
    var aryCompleterTripData = [Any]()
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView = GMSMapView()
    var placesClient = GMSPlacesClient()
    var zoomLevel: Float = 17.0
    var likelyPlaces: [GMSPlace] = []
    var selectedPlace: GMSPlace?
    var defaultLocation = CLLocation(latitude: 23.0733308, longitude: 72.5145669)
    var arrNumberOfAvailableCars = NSMutableArray()
    var arrTotalNumberOfCars = NSMutableArray()
    var arrNumberOfOnlineCars = NSMutableArray()
    //    var dictCars = NSMutableDictionary()
    var strCarModelClass = String()
    
    var aryRequestAcceptedData = NSArray()
    
    var strCarModelID = String()
    var strCarModelIDIfZero = String()
    var strNavigateCarModel = String()
    var aryEstimateFareDataOfOnlineCars: [[String:Any]]! //= []
    //    var aryEstimateFareDataOfOnlineCars2 : [[String:AnyObject]]! //= []

    //     var aryEstimateFareData: [[String:Any]]! //= []
    //    {
    //        didSet {
    //            print("aryEstimateFareData called: \(self.aryEstimateFareData.count)")
    //            self.collectionViewCars.reloadData()
    //        }
    //    }
    
    var strSelectedCarMarkerIcon = String()
    var ratingToDriver = Float()
    var commentToDriver = String()
    
    var currentLocationMarkerText = String()
    var destinationLocationMarkerText = String()
    
    var timerForEmitEstimateFare: Timer!
    
    //-------------------------------------------------------------
    // MARK: - Final Rating View
    //-------------------------------------------------------------
    
    
    @IBOutlet weak var MarkerCurrntLocation: UIButton!
    
    @IBOutlet weak var viewMainFinalRating: UIView!
    @IBOutlet weak var viewSubFinalRating: UIView!
    @IBOutlet weak var txtFeedbackFinal: UITextField!
    
    @IBOutlet weak var giveRating: FloatRatingView!
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        
        giveRating.rating = rating
        ratingToDriver = giveRating.rating
        
    }
    
    @IBAction func btnSubmitFinalRating(_ sender: UIButton) {
        //        BookingId,Rating,Comment,BookingType(BookNow,BookLater)
        
        CancellationFee = ""
        
        var param = [String:AnyObject]()
        param["BookingId"] = SingletonClass.sharedInstance.bookingId as AnyObject
        param["Rating"] = ratingToDriver as AnyObject
        param["Comment"] = txtFeedbackFinal.text as AnyObject
        param["BookingType"] = strBookingType as AnyObject
        
        webserviceForRatingAndComment(param as AnyObject) { (result, status) in
            
            if (status) {
                //       print(result)
                
                self.txtFeedbackFinal.text = ""
                self.ratingToDriver = 0
                
                self.completeTripInfo()
                
            }
            else {
                //      print(result)
                
                if let res = result as? String {
                    UtilityClass.setCustomAlert(title: "", message: res) { (index, title) in
                    }
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.setCustomAlert(title: "", message: resDict.object(forKey: "message") as! String) { (index, title) in
                    }
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.setCustomAlert(title: "", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                    }
                }
            }
        }
    }
    
    func didRatingCompleted() {
        
        openRatingView()
        
        //        self.completeTripInfo()
        
    }
    
    // ----------------------------------------------------------------------
    //MARK:- Driver Details
    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var lblDriverEmail: UILabel!
    @IBOutlet weak var lblDriverPhoneNumber: UILabel!
    @IBOutlet weak var imgDriverImage: UIImageView!
    @IBOutlet weak var viewDriverInformation: UIView!
    @IBOutlet weak var viewTripActions: UIView!
    
    @IBOutlet weak var btnCancelStartedTrip: UIButton!
    
    
    //MARK:-
    @IBOutlet weak var viewCarLists: UIView!
    @IBOutlet weak var viewShareRideView: UIView!
    @IBOutlet weak var imgIsShareRideON: UIImageView!
    
    /// if intShareRide = 1 than ON and if intShareRide = 0 OFF
    var intShareRide:Int = 0
    
    var isShareRideON = Bool()
    
    @IBAction func btnShareRide(_ sender: UIButton) {
        isShareRideON = !isShareRideON
        
        if (isShareRideON) {
            imgIsShareRideON.image = UIImage(named: "iconGreen")
            intShareRide = 1
            SingletonClass.sharedInstance.isShareRide = 1
        }
        else {
            imgIsShareRideON.image = UIImage(named: "iconRed")
            intShareRide = 0
            SingletonClass.sharedInstance.isShareRide = 0
        }
        
        postPickupAndDropLocationForEstimateFare()
        
    }
    
    @IBOutlet weak var constantLeadingOfShareRideButton: NSLayoutConstraint! // 10 or -150
    @IBOutlet weak var btnShareRideToggle: UIButton!
    
    @IBAction func btnShareRideToggle(_ sender: UIButton) {
        
        if sender.currentImage == UIImage(named: "iconRightArraw") {
            
            sender.setImage(UIImage(named: "iconArrowSmall"), for: .normal)
            constantLeadingOfShareRideButton.constant = 10
            
            UIView.animate(withDuration: 0.5) {
                self.viewShareRideView.layoutIfNeeded()
            }
        }
        else {
            
            sender.setImage(UIImage(named: "iconRightArraw"), for: .normal)
            constantLeadingOfShareRideButton.constant = -150
            
            UIView.animate(withDuration: 0.5) {
                self.viewShareRideView.layoutIfNeeded()
            }
        }
        
    }
    
    
    
    
    //PassengerId,ModelId,PickupLocation,DropoffLocation,PickupLat,PickupLng,DropOffLat,DropOffLon
    
    var strModelId = String()
    var strPickupLocation = String()
    var strDropoffLocation = String()
    var doublePickupLat = Double()
    var doublePickupLng = Double()
    var doubleUpdateNewLat = Double()
    var doubleUpdateNewLng = Double()
    var doubleDropOffLat = Double()
    var doubleDropOffLng = Double()
    var arrDataAfterCompletetionOfTrip = NSMutableArray()
    var selectedIndexPath: IndexPath?
    var strSpecialRequest = String()
    var strSpecialRequestFareCharge = String()
    
    var strPickUpLatitude = String()
    var strPickUpLongitude = String()
    
    
    @IBOutlet weak var ConstantViewCarListsHeight: NSLayoutConstraint! // 170
    @IBOutlet weak var constraintTopSpaceViewDriverInfo: NSLayoutConstraint!
    
    @IBOutlet weak var viewForMainFavourite: UIView!
    @IBOutlet weak var viewForFavourite: UIView!
    
    var loadingView: NVActivityIndicatorView!
    //---------------
    
    var sumOfFinalDistance = Double()
    
    var selectedRoute: Dictionary<String, AnyObject>!
    var overviewPolyline: Dictionary<String, AnyObject>!
    
    var originCoordinate: CLLocationCoordinate2D!
    var destinationCoordinate: CLLocationCoordinate2D!
    
    
    
    //---------------
    @IBOutlet var HomeViewGrandParentView: UIView!
    
    @IBOutlet weak var viewDestinationLocation: UIView!
    @IBOutlet weak var viewCurrentLocation: UIView!
    @IBOutlet weak var txtDestinationLocation: UITextField!
    @IBOutlet weak var txtCurrentLocation: UITextField!
    @IBOutlet weak var viewMap: UIView!
    @IBOutlet weak var collectionViewCars: UICollectionView!
    @IBOutlet weak var btnBookLater: UIButton!
    var indexPaths: [NSIndexPath] = []

    var dropoffLat = Double()
    var dropoffLng = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webservicOfGetCarList()
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.setLocationFromBarAndClub(_:)), name: NotificationBookNow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.setBookLaterDestinationAddress(_:)), name: NotificationBookLater, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.webserviceOfRunningTripTrack), name: NotificationTrackRunningTrip, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.newBooking(_:)), name: NotificationForBookingNewTrip, object: nil)
        
        self.stackViewNumberOfPassenger.isHidden = true
        
        self.btnDoneForLocationSelected.isHidden = true
        // bhavesh change - self.ConstantViewCarListsHeight.constant = 0
        self.viewCarLists.isHidden = true
        //        self.viewShareRideView.isHidden = true
        
        currentLocationMarkerText = "Current Location"
        destinationLocationMarkerText = "Destination Location"
        
        //        imgIsShareRideON.image = UIImage(named: "iconRed")
        
        currentLocationMarker.isDraggable = true
        destinationLocationMarker.isDraggable = true
        
        moveMent = ARCarMovement()
        moveMent.delegate = self
        
        mapView.delegate = self
        
        self.setupGoogleMap()
        
        sortCarListFirstTime()
        webserviceOfCurrentBooking()
        setPaymentType()
        
        viewMainFinalRating.isHidden = true
        btnDriverInfo.layer.cornerRadius = 5
        btnDriverInfo.layer.masksToBounds = true
        btnRequest.layer.cornerRadius = 5
        btnRequest.layer.masksToBounds = true
        btnCurrentLocation.layer.cornerRadius = 5
        btnCurrentLocation.layer.masksToBounds = true
        
        self.btnCancelStartedTrip.isHidden = true
        
        giveRating.delegate = self
        
        ratingToDriver = 0.0
        
        paymentType = "cash"
        
        self.viewBookNow.isHidden = true
        stackViewOfPromocode.isHidden = true
        
        viewMainActivityIndicator.isHidden = true
        
        viewActivity.type = .ballPulse
        viewActivity.color = themeYellowColor
        
        
        viewHavePromocode.tintColor = themeYellowColor
        viewHavePromocode.stateChangeAnimation = .fill
        viewHavePromocode.boxType = .square
        
        viewTripActions.isHidden = true
        
        webserviceOfCardList()
        
        viewForMainFavourite.isHidden = true
        
        viewForFavourite.layer.cornerRadius = 5
        viewForFavourite.layer.masksToBounds = true
        
        SingletonClass.sharedInstance.isFirstTimeDidupdateLocation = true;
        self.view.bringSubview(toFront: btnFavourite)
        
        callToWebserviceOfCardListViewDidLoad()
        
        currentLocationAction()
        
        
        
        self.arrTotalNumberOfCars = NSMutableArray(array: SingletonClass.sharedInstance.arrCarLists)
        self.setData()
        
        //
        //        // Do any additional setup after loading the view.
        //         
        //
        //        viewCurrentLocation.layer.shadowOpacity = 0.3
        //        viewCurrentLocation.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        //
        //        viewDestinationLocation.layer.shadowOpacity = 0.3
        //        viewDestinationLocation.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        //
        //        self.setupSideMenu()
        ////        webserviceCallForGettingCarLists()
        //

        
    }
    @IBOutlet weak var viewHeaderHeightConstant: NSLayoutConstraint!
    
    func setHeaderForIphoneX() {
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2436:
                
                viewHeaderHeightConstant.constant = 80

            case  2688 :
                viewHeaderHeightConstant.constant = 80

            default:
                print("")
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.btnDoneForLocationSelected.isHidden = true
        //        setupGoogleMap()
        
        //        viewTripActions.isHidden = true
        
        // This is For Book Later Address
        if (SingletonClass.sharedInstance.isFromNotificationBookLater) {
            
            if strCarModelID == "" {
                
                UtilityClass.setCustomAlert(title: "", message: "Select Car") { (index, title) in
                }
            }
            else if strDestinationLocationForBookLater != "" {
                let profileData = SingletonClass.sharedInstance.dictProfile
                
                let next = self.storyboard?.instantiateViewController(withIdentifier: "BookLaterViewController") as! BookLaterviewController
                
                SingletonClass.sharedInstance.isFromNotificationBookLater = false
                
                next.strModelId = strCarModelID
                next.strCarModelURL = strNavigateCarModel
                next.strCarName = strCarModelClass
                
                next.strFullname = profileData.object(forKey: "Fullname") as! String
                next.strMobileNumber = profileData.object(forKey: "MobileNo") as! String
                
                
                
                next.strDropoffLocation = strDestinationLocationForBookLater
                next.doubleDropOffLat = dropOffLatForBookLater
                next.doubleDropOffLng = dropOffLngForBookLater
                
                self.navigationController?.pushViewController(next, animated: true)
            }
            else {
                
                UtilityClass.setCustomAlert(title: "", message: "We did not get proper address") { (index, title) in
                }
            }
            
        }
        
        viewSubFinalRating.layer.cornerRadius = 5
        viewSubFinalRating.layer.masksToBounds = true
        
        viewSelectPaymentOption.layer.borderWidth = 1.0
        viewSelectPaymentOption.layer.borderColor = UIColor.gray.cgColor
        viewSelectPaymentOption.layer.cornerRadius = 5
        viewSelectPaymentOption.layer.masksToBounds = true
        
        viewSelectPaymentOptionParent.layer.cornerRadius = 5
        viewSelectPaymentOptionParent.layer.masksToBounds = true
        
        
        if(locationManager != nil)
        {
            locationManager.startUpdatingLocation()
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //
        //
        
        //        if (self.mapView != nil)
        //        {
        //
        //        self.mapView.clear()
        ////        self.mapView.stopRendering()
        ////        self.mapView.removeFromSuperview()
        ////        self.mapView = nil
        //        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        setHeaderForIphoneX()
        
        self.arrTotalNumberOfCars = NSMutableArray(array: SingletonClass.sharedInstance.arrCarLists.filtered(using: NSPredicate(format: "CategoryId contains[c] %@", "\(normalBookingOrTruckBooking)")))
        
        
        //        let cat = SingletonClass.sharedInstance.arrCarLists.filtered(using: NSPredicate(format: "CategoryId contains[c] %@", "\(normalBookingOrTruckBooking)"))
        
        
        
        //        self.setupGoogleMap()
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Notification Center Methods
    //-------------------------------------------------------------
    
    
    @objc func setLocationFromBarAndClub(_ notification: NSNotification) {
        
        print("Notification Data : \(notification)")
        
        if let Address = notification.userInfo?["Address"] as? String {
            // do something with your image
            txtDestinationLocation.text = Address
            strDropoffLocation = Address
            
            if let lat = notification.userInfo?["lat"] as? Double {
                
                if lat != 0 {
                    doubleDropOffLat = Double(lat)
                }
            }
            
            if let lng = notification.userInfo?["lng"] as? Double {
                
                if lng != 0 {
                    doubleDropOffLng = Double(lng)
                }
            }
        }
        
    }
    
    var strDestinationLocationForBookLater = String()
    var dropOffLatForBookLater = Double()
    var dropOffLngForBookLater = Double()
    
    @objc func setBookLaterDestinationAddress(_ notification: NSNotification) {
        
        print("Notification Data : \(notification)")
        
        if let Address = notification.userInfo?["Address"] as? String {
            // do something with your image
            strDestinationLocationForBookLater = Address
            
            if let lat = notification.userInfo?["lat"] as? Double {
                
                if lat != 0 {
                    dropOffLatForBookLater = Double(lat)
                }
            }
            
            if let lng = notification.userInfo?["lng"] as? Double {
                
                if lng != 0 {
                    dropOffLngForBookLater = Double(lng)
                }
            }
            
        }
    }
    
    
    //-------------------------------------------------------------
    // MARK: - setMap and Location Methods
    //-------------------------------------------------------------
    
    
    @IBOutlet weak var btnDoneForLocationSelected: UIButton!
    @IBAction func btnDoneForLocationSelected(_ sender: UIButton) {
        
        clearMap()
        self.routePolyline.map = nil
        self.updateCounting()
        if strLocationType == currentLocationMarkerText {
            
            btnDoneForLocationSelected.isHidden = true
            if txtDestinationLocation.text?.count != 0 {
                txtDestinationLocation.becomeFirstResponder()
            }
        }
        else if strLocationType == destinationLocationMarkerText {
            
            btnDoneForLocationSelected.isHidden = true
        }
        
        if txtCurrentLocation.text != "" && txtDestinationLocation.text != "" {
            
            setupBothCurrentAndDestinationMarkerAndPolylineOnMap()
            


            
            btnDoneForLocationSelected.isHidden = true
            self.viewCarLists.isHidden = false
            //            self.viewShareRideView.isHidden = false
            // bhavesh change - self.ConstantViewCarListsHeight.constant =  170 // 150
            //            self.postPickupAndDropLocationForEstimateFare()

            self.collectionViewCars.reloadData()
            //            self.collectionViewCars.collectionViewLayout.invalidateLayout()
            //            self.collectionViewCars.layoutSubviews()
        }
        else {
            // bhavesh change - self.ConstantViewCarListsHeight.constant = 0
            self.viewCarLists.isHidden = true
            //            self.viewShareRideView.isHidden = true
        }
        
        
        if txtCurrentLocation.text != "" && txtDestinationLocation.text != "" && stackViewOfTruckBooking.isHidden {
            if timerForEmitEstimateFare != nil {
                timerForEmitEstimateFare.invalidate()
            }
            
            timerForEmitEstimateFare = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.callEmitForGetEstimateFare), userInfo: nil, repeats: true)
        }
        
    }
    
    @objc func callEmitForGetEstimateFare() {
        
        //        if (SingletonClass.sharedInstance.onlineCars as NSArray != self.aryEstimateFareDataOfOnlineCars as NSArray) {
        self.postPickupAndDropLocationForEstimateFare()
        //        }
        
    }
    
    
    @IBOutlet weak var btnCurrentLocation: UIButton!
    var currentLocationMarker = GMSMarker()
    var destinationLocationMarker = GMSMarker()
    
    var routePolyline = GMSPolyline()
    var demoPolylineOLD = GMSPolyline()
    
    var setDummyLineIndex = 0
    var dummyTimer = Timer()
    
    
    @IBAction func btnCurrentLocation(_ sender: UIButton)
    {
        //        self.getDummyDataLinedata()
        //        dummyTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(dummyCarMovement), userInfo: nil, repeats: true)
        
        currentLocationAction()
    }
    
    @objc func dummyCarMovement() {
        
        self.setDummyLine(index: setDummyLineIndex)
        setDummyLineIndex += 1
        
        if setDummyLineIndex == aryDummyLineData.count {
            setDummyLineIndex = 0
            self.setDummyLine(index: setDummyLineIndex)
        }

    }
    
    func currentLocationAction() {
        
        clearMap()
        
        txtDestinationLocation.text = ""
        strDropoffLocation = ""
        doubleDropOffLat = 0
        doubleDropOffLng = 0
        self.destinationLocationMarker.map = nil
        self.currentLocationMarker.map = nil
        self.strLocationType = self.currentLocationMarkerText
        // bhavesh change - self.ConstantViewCarListsHeight.constant = 0
        self.viewCarLists.isHidden = true
        //        self.viewShareRideView.isHidden = true
        
        mapView.delegate = self
        
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: 17.5)
        
        mapView.camera = camera
        
        self.MarkerCurrntLocation.isHidden = false
        //        self.btnDoneForLocationSelected.isHidden = false
        self.btnDoneForLocationSelected.isHidden = true // Just for checking
        
        self.doublePickupLat = (defaultLocation.coordinate.latitude)
        self.doublePickupLng = (defaultLocation.coordinate.longitude)
        
        stackViewOfTruckBooking.isHidden = false
        
        //        let strLati: String = "\(self.doublePickupLat)"
        //        let strlongi: String = "\(self.doublePickupLng)"
        //
        //        getAddressForLatLng(latitude: strLati, longitude: strlongi, markerType: currentLocationMarkerText)
        
        //        let position = CLLocationCoordinate2D(latitude: defaultLocation.coordinate.latitude, longitude: defaultLocation.coordinate.longitude)
        //        currentLocationMarker = GMSMarker(position: position)
        //        currentLocationMarker.map = self.mapView
        //        currentLocationMarker.snippet = currentLocationMarkerText // "Current Location"
        //        currentLocationMarker.icon = UIImage(named: "iconCurrentLocation")
        //        currentLocationMarker.isDraggable = true
    }
    
    
    @IBOutlet weak var stackViewOfTruckBooking: UIStackView!
    @IBOutlet weak var btnBookNow: UIButton!
    
    var normalBookingOrTruckBooking = 1
    
    @IBAction func btnNormalCarBooking(_ sender: UIButton) {
        self.btnDoneForLocationSelected.isHidden = false
        self.stackViewOfTruckBooking.isHidden = true
        normalBookingOrTruckBooking = 1
        self.arrTotalNumberOfCars = NSMutableArray(array: SingletonClass.sharedInstance.arrCarLists.filtered(using: NSPredicate(format: "CategoryId contains[c] %@", "\(normalBookingOrTruckBooking)")))
        self.setData()
        btnBookNow.isHidden = false
        self.btnBookLater.setTitle("Book Later", for: .normal)
        
        
        if txtCurrentLocation.text != "" && txtDestinationLocation.text != "" && btnDoneForLocationSelected.isHidden {
            if timerForEmitEstimateFare != nil {
                timerForEmitEstimateFare.invalidate()
            }
            timerForEmitEstimateFare = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.callEmitForGetEstimateFare), userInfo: nil, repeats: true)
        }
    }
    
    @IBAction func btnTruckBooking(_ sender: UIButton) {
        
        self.btnDoneForLocationSelected.isHidden = false
        self.stackViewOfTruckBooking.isHidden = true
        normalBookingOrTruckBooking = 2
        self.arrTotalNumberOfCars = NSMutableArray(array: SingletonClass.sharedInstance.arrCarLists.filtered(using: NSPredicate(format: "CategoryId contains[c] %@", "\(normalBookingOrTruckBooking)")))
        self.setData()
        if normalBookingOrTruckBooking == 2 {
            btnBookNow.isHidden = true
            self.btnBookLater.setTitle("Booking Request", for: .normal)
        }
        

        
        //        if Connectivity.isConnectedToInternet() {
        //
        //            let profileData = SingletonClass.sharedInstance.dictProfile
        //
        //            // This is For Book Later Address
        //
        //            let next = self.storyboard?.instantiateViewController(withIdentifier: "BookLaterViewController") as! BookLaterviewController
        //
        ////            next.strModelId = strCarModelID
        ////            next.strCarModelURL = strNavigateCarModel
        ////            next.strCarName = strCarModelClass
        //
        //            next.isTruckSelected = true
        //
        //            next.strPickupLocation = strPickupLocation
        //            next.doublePickupLat = doublePickupLat
        //            next.doublePickupLng = doublePickupLng
        //
        //            next.strDropoffLocation = strDropoffLocation
        //            next.doubleDropOffLat = doubleDropOffLat
        //            next.doubleDropOffLng = doubleDropOffLng
        //
        //            next.strFullname = profileData.object(forKey: "Fullname") as! String
        //            next.strMobileNumber = profileData.object(forKey: "MobileNo") as! String
        //
        //            self.navigationController?.pushViewController(next, animated: true)
        //
        //        }
        //        else {
        //            UtilityClass.showAlert("", message: "Internet connection not available", vc: self)
        //        }
    }
    
    
    let geocoder = GMSGeocoder()
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
        //        self.btnDoneForLocationSelected.isHidden = true
    }
    
    var strLocationType = String()
    
    func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
        
        if stackViewOfTruckBooking.isHidden == true {
            
        }
        
        self.btnDoneForLocationSelected.isHidden = true
        if Connectivity.isConnectedToInternet() {
            
            if MarkerCurrntLocation.isHidden == false {
                
                //                geocoder.reverseGeocodeCoordinate(cameraPosition.target) { (response, error) in
                //                    guard error == nil else {
                //                        return
                //                    }
                //                }
                
                if self.strLocationType != "" {
                    
                    //                     UtilityClass.showACProgressHUD()
                    
                    
                    if stackViewOfTruckBooking.isHidden == true {
                        self.btnDoneForLocationSelected.isHidden = false
                    }
                    
                    //                    self.btnDoneForLocationSelected.isHidden = false
                    
                    if self.strLocationType == self.currentLocationMarkerText {
                        
                        self.doublePickupLat = cameraPosition.target.latitude
                        self.doublePickupLng = cameraPosition.target.longitude
                        
                        getAddressForLatLng(latitude: "\(cameraPosition.target.latitude)", longitude: "\(cameraPosition.target.longitude)", markerType: strLocationType)
                        
                        
                    }
                    else if self.strLocationType == self.destinationLocationMarkerText {
                        
                        self.doubleDropOffLat = cameraPosition.target.latitude
                        self.doubleDropOffLng = cameraPosition.target.longitude
                        
                        getAddressForLatLng(latitude: "\(cameraPosition.target.latitude)", longitude: "\(cameraPosition.target.longitude)", markerType: strLocationType)
                        
                        
                    }
                    
                    if txtCurrentLocation.text?.count != 0 && txtDestinationLocation.text?.count != 0 && self.btnDoneForLocationSelected.isHidden != false && self.stackViewOfTruckBooking.isHidden == true {
                        self.strLocationType = ""
                        
                        //                        UtilityClass.hideHUD()
                    }
                }
                
                //                getAddressForLatLng(latitude: "\(cameraPosition.target.latitude)", longitude: "\(cameraPosition.target.longitude)", markerType: strLocationType) // currentLocationMarkerText
            }
        }
        else {
            UtilityClass.showAlert("", message: "Internet connection not available", vc: self)
        }
    }
    
    
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        
        print("didBeginDragging")
        
    }
    
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        print("didDrag")
        
        //        currentLocationMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: marker.position.latitude, longitude: marker.position.longitude))
        //        currentLocationMarker.map = self.mapView
        //        currentLocationMarker.snippet = currentLocationMarkerText // "Current Location"
        //        currentLocationMarker.icon = UIImage(named: "iconCurrentLocation")
        
    }
    
    func mapView(_ mapView: GMSMapView, did position: GMSCameraPosition) {
        
        print("did position: \(position)")
    }
    
    
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        //        print("didChange position: \(position)")
        
        
        //        print("\(position.target.latitude) \(position.target.longitude)")
        
        //        currentLocationMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: position.target.latitude, longitude: position.target.longitude))
        //        currentLocationMarker.map = self.mapView
        //        currentLocationMarker.snippet = currentLocationMarkerText // "Current Location"
        //        currentLocationMarker.icon = UIImage(named: "iconCurrentLocation")
        //
        //        let latitude = mapView.camera.target.latitude
        //        let longitude = mapView.camera.target.longitude
        
        //        let locat = CLLocation(latitude: latitude, longitude: longitude)
        /*
         if self.strLocationType != "" {
         
         if self.strLocationType == self.currentLocationMarkerText {
         
         self.doublePickupLat = position.target.latitude
         self.doublePickupLng = position.target.longitude
         
         getAddressForLatLng(latitude: "\(position.target.latitude)", longitude: "\(position.target.longitude)", markerType: strLocationType)
         }
         else if self.strLocationType == self.destinationLocationMarkerText {
         
         self.doubleDropOffLat = position.target.latitude
         self.doubleDropOffLng = position.target.longitude
         
         getAddressForLatLng(latitude: "\(position.target.latitude)", longitude: "\(position.target.longitude)", markerType: strLocationType)
         }
         
         if txtCurrentLocation.text?.count != 0 && txtDestinationLocation.text?.count != 0 && btnDoneForLocationSelected.isHidden != false {
         self.strLocationType = ""
         }
         }
         */
        
        /*
         
         let ceo = CLGeocoder()
         let loc = CLLocation(latitude: position.target.latitude, longitude: position.target.longitude)
         print("Locations : \(loc)")
         //----------------------------------------------------------------------
         
         // ----------------------------------------------------------------------
         ceo.reverseGeocodeLocation(loc) { (placemarks, error) in
         
         if placemarks != nil {
         let placemark = placemarks![0] as? CLPlacemark
         
         let address = (placemark?.addressDictionary?["FormattedAddressLines"] as! [String]).joined(separator: ", ")
         
         if self.strLocationType == self.currentLocationMarkerText {
         
         print("Address: \(address)")
         self.txtCurrentLocation.text = address
         self.strPickupLocation = address
         self.doublePickupLat = (placemark?.location?.coordinate.latitude)!
         self.doublePickupLng = (placemark?.location?.coordinate.longitude)!
         }
         else if self.strLocationType == self.destinationLocationMarkerText {
         
         print("Address: \(address)")
         self.txtDestinationLocation.text = address
         self.strDropoffLocation = address
         self.doubleDropOffLat = (placemark?.location?.coordinate.latitude)!
         self.doubleDropOffLng = (placemark?.location?.coordinate.longitude)!
         }
         
         print("didEndDragging")
         }
         }
         */
    }
    
    func getAddressForLatLng(latitude: String, longitude: String, markerType: String) {
        
        if markerType == currentLocationMarkerText {
            let url = NSURL(string: "\(baseUrlForGetAddress)latlng=\(latitude),\(longitude)&key=\(apikey)")
            
            let autoCompleteHTTPs = NSURL(string: "\(baseUrlForAutocompleteAddress)input=35&location=\(latitude),\(longitude)&radius=1000&sensor=true&key=\(apikey)&components=&language=en")
            print("autoCompleteHTTPs Link is : \(autoCompleteHTTPs)")
            
            print("Link is : \(url)")
            
            //            do {
            //                let data = NSData(contentsOf: autoCompleteHTTPs as! URL)
            //                if data != nil {
            //                    if let json = try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary {
            //                        if let result = json["predictions"] as? [[String:AnyObject]] {
            //                            if result != nil {
            //                                if result.count > 0 {
            //                                    if result.first != nil && result.first?.count != 0 {
            //                                        self.txtCurrentLocation.text = result.first?["description"] as? String
            //                                        self.strPickupLocation = result.first!["description"] as! String
            //                                        self.btnDoneForLocationSelected.isHidden = false
            //                                    }
            //                                }
            //                            }
            //                        }
            //                    }
            //                }
            //            }
            

            do {
                let data = NSData(contentsOf: url! as URL)
                if data != nil {
                    let json = try! JSONSerialization.jsonObject(with: data as! Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                    if let result = json["results"] as? [[String:AnyObject]] {
                        if result.count > 0 {
                            
                            if let resString = result[0]["formatted_address"] as? String {
                                
                                self.txtCurrentLocation.text = resString
                                self.strPickupLocation = resString
                                //                                btnDoneForLocationSelected.isHidden = false
                                if stackViewOfTruckBooking.isHidden == true {
                                    self.btnDoneForLocationSelected.isHidden = false
                                }
                            }
                            else if let address = result[0]["address_components"] as? [[String:AnyObject]] {
                                
                                if address.count > 1 {
                                    
                                    var streetNumber = String()
                                    var streetStreet = String()
                                    var streetCity = String()
                                    var streetState = String()
                                    
                                    for i in 0..<address.count {
                                        
                                        if i == 0 {
                                            if let number = address[i]["long_name"] as? String {
                                                streetNumber = number
                                            }
                                        }
                                        else if i == 1 {
                                            if let street = address[i]["long_name"] as? String {
                                                streetStreet = street
                                            }
                                        }
                                        else if i == 2 {
                                            if let city = address[i]["long_name"] as? String {
                                                streetCity = city
                                            }
                                        }
                                        else if i == 3 {
                                            if let state = address[i]["long_name"] as? String {
                                                streetState = state
                                            }
                                        }
                                        else if i == 4 {
                                            if let city = address[i]["long_name"] as? String {
                                                streetCity = city
                                            }
                                        }
                                    }
                                    
                                    //                    let zip = address[6]["short_name"] as? String
                                    print("\n\(streetNumber) \(streetStreet), \(streetCity), \(streetState)")
                                    
                                    
                                    self.txtCurrentLocation.text = "\(streetNumber) \(streetStreet), \(streetCity), \(streetState)"
                                    self.strPickupLocation = "\(streetNumber) \(streetStreet), \(streetCity), \(streetState)"
                                    //                                    btnDoneForLocationSelected.isHidden = false
                                    
                                    if stackViewOfTruckBooking.isHidden == true {
                                        self.btnDoneForLocationSelected.isHidden = false
                                    }
                                    //                                UtilityClass.hideHUD()
                                }
                            }
                        }
                    }
                }
                
            }
            catch {
                print("Not Geting Address")
            }
        }
        else if markerType == destinationLocationMarkerText {
            let url = NSURL(string: "\(baseUrlForGetAddress)latlng=\(latitude),\(longitude)&key=\(apikey)")
            
            print("Link is : \(url)")
            do {
                let data = NSData(contentsOf: url! as URL)
                if data != nil {
                    let json = try! JSONSerialization.jsonObject(with: data as! Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                    if let result = json["results"] as? [[String:AnyObject]] {
                        if result.count > 0 {
                            
                            if let resString = result[0]["formatted_address"] as? String {
                                
                                self.txtDestinationLocation.text = resString
                                self.strDropoffLocation = resString
                                if stackViewOfTruckBooking.isHidden == true {
                                    self.btnDoneForLocationSelected.isHidden = false
                                }
                                //                                btnDoneForLocationSelected.isHidden = false
                            }
                            else if let address = result[0]["address_components"] as? [[String:AnyObject]] {
                                
                                if address.count > 1 {
                                    
                                    var streetNumber = String()
                                    var streetStreet = String()
                                    var streetCity = String()
                                    var streetState = String()
                                    
                                    
                                    for i in 0..<address.count {
                                        
                                        if i == 0 {
                                            if let number = address[i]["long_name"] as? String {
                                                streetNumber = number
                                            }
                                        }
                                        else if i == 1 {
                                            if let street = address[i]["long_name"] as? String {
                                                streetStreet = street
                                            }
                                        }
                                        else if i == 2 {
                                            if let city = address[i]["long_name"] as? String {
                                                streetCity = city
                                            }
                                        }
                                        else if i == 3 {
                                            if let state = address[i]["long_name"] as? String {
                                                streetState = state
                                            }
                                        }
                                        else if i == 4 {
                                            if let city = address[i]["long_name"] as? String {
                                                streetCity = city
                                            }
                                        }
                                    }
                                    /*
                                     if address.count == 4 {
                                     if let number = address[0]["short_name"] as? String {
                                     streetNumber = number
                                     }
                                     if let street = address[1]["short_name"] as? String {
                                     streetStreet = street
                                     }
                                     if let city = address[2]["short_name"] as? String {
                                     streetCity = city
                                     }
                                     if let state = address[3]["short_name"] as? String {
                                     streetState = state
                                     }
                                     }
                                     else {
                                     
                                     if let number = address[0]["short_name"] as? String {
                                     streetNumber = number
                                     }
                                     if let street = address[1]["short_name"] as? String {
                                     streetStreet = street
                                     }
                                     if let city = address[2]["short_name"] as? String {
                                     streetCity = city
                                     }
                                     if let state = address[4]["short_name"] as? String {
                                     streetState = state
                                     }
                                     }
                                     */
                                    //                    let zip = address[6]["short_name"] as? String
                                    print("\n\(streetNumber) \(streetStreet), \(streetCity), \(streetState)")
                                    
                                    self.txtDestinationLocation.text = "\(streetNumber) \(streetStreet), \(streetCity), \(streetState)"
                                    self.strDropoffLocation = "\(streetNumber) \(streetStreet), \(streetCity), \(streetState)"
                                    //                                    btnDoneForLocationSelected.isHidden = false
                                    if stackViewOfTruckBooking.isHidden == true {
                                        self.btnDoneForLocationSelected.isHidden = false
                                    }
                                    //                                UtilityClass.hideHUD()
                                }
                            }
                        }
                    }
                }
                
            }
            catch {
                print("Not Geting Address")
            }
        }
        //   btnDoneForLocationSelected.isHidden = false
        
    }
    
    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        print("didEndDragging")
        /*
         if (marker.snippet == currentLocationMarkerText) {
         let ceo = CLGeocoder()
         var loc = CLLocation(latitude: marker.position.latitude, longitude: marker.position.longitude)
         ceo.reverseGeocodeLocation(loc) { (placemarks, error) in
         
         if placemarks != nil {
         
         let placemark = placemarks![0] as? CLPlacemark
         
         //            print(placemark?.addressDictionary ?? "")
         
         //            print("placemark \(String(describing: placemark))")
         //            //String to hold address
         //            var locatedAt: String? = (placemark?.addressDictionary?["FormattedAddressLines"] as AnyObject).joined(separator: ", ")
         //            print("addressDictionary \(String(describing: placemark?.addressDictionary) ?? "")")
         
         let address = (placemark?.addressDictionary?["FormattedAddressLines"] as! [String]).joined(separator: ", ")
         
         self.strPickupLocation = address
         self.doublePickupLat = (placemark?.location?.coordinate.latitude)!
         self.doublePickupLng = (placemark?.location?.coordinate.longitude)!
         
         let strLati: String = "\(self.doublePickupLat)"
         let strlongi: String = "\(self.doublePickupLng)"
         
         if (marker.snippet != nil) {
         self.getAddressForLatLng(latitude: strLati, longitude: strlongi, markerType: marker.snippet!)
         }
         
         }
         
         print("didEndDragging")
         }
         }
         else if (marker.snippet == destinationLocationMarkerText) {
         let ceo = CLGeocoder()
         var loc = CLLocation(latitude: marker.position.latitude, longitude: marker.position.longitude)
         ceo.reverseGeocodeLocation(loc) { (placemarks, error) in
         
         if placemarks != nil {
         
         let placemark = placemarks![0] as? CLPlacemark
         
         //            print(placemark?.addressDictionary ?? "")
         
         //            print("placemark \(String(describing: placemark))")
         //            //String to hold address
         //            var locatedAt: String? = (placemark?.addressDictionary?["FormattedAddressLines"] as AnyObject).joined(separator: ", ")
         //            print("addressDictionary \(String(describing: placemark?.addressDictionary) ?? "")")
         
         let address = (placemark?.addressDictionary?["FormattedAddressLines"] as! [String]).joined(separator: ", ")
         
         self.strDropoffLocation = address
         self.doubleDropOffLat = (placemark?.location?.coordinate.latitude)!
         self.doubleDropOffLng = (placemark?.location?.coordinate.longitude)!
         
         let strLati: String = "\(self.doubleDropOffLat)"
         let strlongi: String = "\(self.doubleDropOffLng)"
         
         if marker.snippet != nil {
         self.getAddressForLatLng(latitude: strLati, longitude: strlongi, markerType: marker.snippet!)
         }
         
         }
         
         print("didEndDragging")
         }
         }
         
         */
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        //        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
    }
    
    
    @IBOutlet weak var btnFavourite: UIButton!
    @IBAction func btnFavourite(_ sender: UIButton) {
        
        if txtDestinationLocation.text!.count == 0 {
            
            UtilityClass.setCustomAlert(title: "", message: "Enter destination address") { (index, title) in
            }
        }
        else {
            UIView.transition(with: viewForMainFavourite, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
                self.viewForMainFavourite.isHidden = false
            }) { _ in }
            
        }
        
    }
    @IBOutlet weak var btnCall: UIButton!
    @IBAction func btCallClicked(_ sender: UIButton)
    {
        
        let contactNumber = helpLineNumber
        
        if contactNumber == "" {
            
            UtilityClass.setCustomAlert(title: "\(appName)", message: "Contact number is not available") { (index, title) in
            }
        }
        else
        {
            callNumber(phoneNumber: contactNumber)
        }
    }
    
    private func callNumber(phoneNumber:String) {
        
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    func setPaymentType() {
        
        pickerView.selectRow(0, inComponent: 0, animated: true)
        
        imgPaymentType.image = UIImage(named: "iconCashBlack")
        txtSelectPaymentOption.text = "cash"
        
    }
    
    func setHideAndShowTopViewWhenRequestAcceptedAndTripStarted(status: Bool) {
        
        viewCurrentLocation.isHidden = status
        viewDestinationLocation.isHidden = status
        btnCurrentLocation.isHidden = status
    }
    
    
    //Mark - Webservice Call For Miss Booking Request
    func webserviceCallForMissBookingRequest()
    {
        
        var dictParam = [String:AnyObject]()
        dictParam["PassengerId"] = SingletonClass.sharedInstance.strPassengerID as AnyObject
        dictParam["ModelId"] = strCarModelIDIfZero as AnyObject
        dictParam["PickupLocation"] = self.strPickupLocation as AnyObject
        dictParam["DropoffLocation"] = self.strDropoffLocation as AnyObject
        dictParam["PickupLat"] = doublePickupLat as AnyObject
        dictParam["PickupLng"] = doublePickupLng as AnyObject
        dictParam["DropOffLat"] = doubleDropOffLat as AnyObject
        dictParam["DropOffLon"] = doubleDropOffLng as AnyObject
        dictParam["Notes"] = "" as AnyObject
        
        webserviceForMissBookingRequest(dictParam as AnyObject) { (result, status) in
            
        }
    }
    
    
    //MARK:- Webservice Call for Booking Requests
    func webserviceCallForBookingCar()
    {
        
        //PassengerId,ModelId,PickupLocation,DropoffLocation,PickupLat,PickupLng,DropOffLat,DropOffLon
        //,PromoCode,Notes,PaymentType,CardId(If paymentType is card)
        
        let dictParams = NSMutableDictionary()
        dictParams.setObject(SingletonClass.sharedInstance.strPassengerID, forKey: "PassengerId" as NSCopying)
        dictParams.setObject(strModelId, forKey: SubmitBookingRequest.kModelId as NSCopying)
        if(strModelId == "")
        {
            dictParams.setObject(strCarModelIDIfZero, forKey: SubmitBookingRequest.kModelId as NSCopying)
            
        }
        dictParams.setObject(strPickupLocation, forKey: SubmitBookingRequest.kPickupLocation as NSCopying)
        dictParams.setObject(strDropoffLocation, forKey: SubmitBookingRequest.kDropoffLocation as NSCopying)
        
        dictParams.setObject(doublePickupLat, forKey: SubmitBookingRequest.kPickupLat as NSCopying)
        dictParams.setObject(doublePickupLng, forKey: SubmitBookingRequest.kPickupLng as NSCopying)
        
        dictParams.setObject(doubleDropOffLat, forKey: SubmitBookingRequest.kDropOffLat as NSCopying)
        dictParams.setObject(doubleDropOffLng, forKey: SubmitBookingRequest.kDropOffLon as NSCopying)
        
        dictParams.setObject(txtNote.text!, forKey: SubmitBookingRequest.kNotes as NSCopying)
        dictParams.setObject(strSpecialRequest, forKey: SubmitBookingRequest.kSpecial as NSCopying)
        
        if paymentType == "" {
        }
        else {
            dictParams.setObject(paymentType, forKey: SubmitBookingRequest.kPaymentType as NSCopying)
        }
        
        if txtHavePromocode.text == "" {
            
        }
        else {
            dictParams.setObject(txtHavePromocode.text!, forKey: SubmitBookingRequest.kPromoCode as NSCopying)
        }
        
        if CardID == "" {
            
        }
        else {
            dictParams.setObject(CardID, forKey: SubmitBookingRequest.kCardId as NSCopying)
        }
        
        if intShareRide == 1 {
            dictParams.setObject(intShareRide, forKey: SubmitBookingRequest.kShareRide as NSCopying)
            dictParams.setObject(intNumberOfPassengerOnShareRiding, forKey: SubmitBookingRequest.kNoOfPassenger as NSCopying)
            
        }
        
        
        self.view.bringSubview(toFront: self.viewMainActivityIndicator)
        self.viewMainActivityIndicator.isHidden = false
        webserviceForTaxiRequest(dictParams) { (result, status) in
            
            if (status) {
                //      print(result)
                
                SingletonClass.sharedInstance.bookedDetails = (result as! NSDictionary)
                
                if let bookingId = ((result as! NSDictionary).object(forKey: "details") as! NSDictionary).object(forKey: "BookingId") as? Int {
                    SingletonClass.sharedInstance.bookingId = "\(bookingId)"
                }
                
                self.strBookingType = "BookNow"
                self.viewBookNow.isHidden = true
                self.viewActivity.startAnimating()
                
                
            }
            else {
                //    print(result)
                
                self.viewBookNow.isHidden = true
                self.viewMainActivityIndicator.isHidden = true
                
                if let res = result as? String {
                    UtilityClass.setCustomAlert(title: "", message: res) { (index, title) in
                    }
                }
                else if let resDict = result as? NSDictionary {
                    if((resDict.object(forKey: "message") as? NSArray) != nil)
                    {
                        UtilityClass.setCustomAlert(title: "", message: (resDict.object(forKey: "message") as! NSArray).object(at: 0) as! String) { (index, title) in
                        }
                    }
                    else
                    {
                        UtilityClass.setCustomAlert(title: "", message: resDict.object(forKey: "message") as! String) { (index, title) in
                        }
                    }
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.setCustomAlert(title: "", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                    }
                }
            }
        }
    }
    
    //-------------------------------------------------------------
    // MARK: - View Book Now
    //-------------------------------------------------------------
    
    @IBAction func tapToDismissActivityIndicator(_ sender: UITapGestureRecognizer) {
        viewMainActivityIndicator.isHidden = true
        
        //        socketMethodForCancelRequestTrip()
        
    }
    @IBOutlet weak var viewMainActivityIndicator: UIView!
    @IBOutlet weak var viewActivity: NVActivityIndicatorView!
    
    @IBOutlet weak var viewBookNow: UIView!
    
    @IBOutlet weak var viewSelectPaymentOptionParent: UIView!
    @IBOutlet weak var viewSelectPaymentOption: UIView!
    @IBOutlet weak var txtSelectPaymentOption: UITextField!
    
    @IBOutlet weak var viewHavePromocode: M13Checkbox!
    @IBOutlet weak var stackViewOfPromocode: UIStackView!
    @IBOutlet weak var stackViewNumberOfPassenger: UIStackView!
    
    @IBOutlet weak var txtNumberOfPassengers: UITextField!
    
    
    @IBOutlet weak var imgPaymentType: UIImageView!
    @IBOutlet weak var txtHavePromocode: UITextField!
    @IBOutlet weak var txtNote: UITextField!
    var boolIsSelected = Bool()
    
    var pickerView = UIPickerView()
    var pickerViewForNoOfPassenger = UIPickerView()
    
    var CardID = String()
    var paymentType = String()
    
    var intNumberOfPassengerOnShareRiding = Int()
    
    @IBAction func btnPromocode(_ sender: UIButton) {
        
        boolIsSelected = !boolIsSelected
        
        if (boolIsSelected) {
            stackViewOfPromocode.isHidden = false
            viewHavePromocode.checkState = .checked
            viewHavePromocode.stateChangeAnimation = .fill
        }
        else {
            txtHavePromocode.text = ""
            stackViewOfPromocode.isHidden = true
            viewHavePromocode.checkState = .unchecked
            viewHavePromocode.stateChangeAnimation = .fill
        }
        
    }
    
    @IBAction func viewHavePromocode(_ sender: M13Checkbox) {
        
        //        boolIsSelected = !boolIsSelected
        //
        //        if (boolIsSelected) {
        //            stackViewOfPromocode.isHidden = false
        //        }
        //        else {
        //            stackViewOfPromocode.isHidden = true
        //
        //        }
    }
    @IBAction func tapToDismissBookNowView(_ sender: UITapGestureRecognizer) {
        viewBookNow.isHidden = true
        
        
    }
    
    @IBAction func txtPaymentOption(_ sender: UITextField) {
        pickerView.delegate = self
        pickerView.dataSource = self
        
        txtSelectPaymentOption.inputView = pickerView
    }
    
    @IBAction func txtNumberOfPassenger(_ sender: UITextField) {
        
        pickerViewForNoOfPassenger.delegate = self
        pickerViewForNoOfPassenger.dataSource = self
        //        pickerViewForNoOfPassenger.sc
        
        txtNumberOfPassengers.inputView = pickerViewForNoOfPassenger
        
    }
    
    
    
    
    
    @IBAction func btnRequestNow(_ sender: UIButton) {
        
        self.webserviceCallForBookingCar()
    }
    
    
    
    // ----------------------------------------------------------------------
    
    
    //-------------------------------------------------------------
    // MARK: - PickerView Methods
    //-------------------------------------------------------------
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == pickerViewForNoOfPassenger {
            return 2
        }
        return cardData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        if pickerView == pickerViewForNoOfPassenger {
            return 120
        }
        return 60
    }
    
    //    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    //
    //    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        if pickerView == pickerViewForNoOfPassenger {
            
            let myView = UIView(frame: CGRect(x:0, y:0, width: pickerViewForNoOfPassenger.frame.size.width, height: pickerViewForNoOfPassenger.frame.size.height))
            
            let myImageView = UIImageView(frame: CGRect(x:myView.center.x - 50, y:myView.center.y - 50, width:100, height:100))
            var rowString = String()
            switch row {
                
            case 0:
                myImageView.image = UIImage(named: "circle.png")
                rowString = "1"
            case 1:
                myImageView.image = UIImage(named: "circle.png")
                rowString = "2"
            default:
                print("something wrong")
            }
            
            let myLabel = UILabel(frame: CGRect(x:myImageView.center.x-10, y:myImageView.center.y-25, width:50, height:50 ))
            myLabel.font = UIFont.systemFont(ofSize: 30)
            myLabel.text = rowString
            

            myView.addSubview(myImageView)
            myView.addSubview(myLabel)
            
            return myView
        }
        
        let data = cardData[row]
        
        let myView = UIView(frame: CGRect(x:0, y:0, width: pickerView.bounds.width - 30, height: 60))
        
        let myImageView = UIImageView(frame: CGRect(x:0, y:15, width:30, height:30))
        
        var rowString = String()
        
        
        switch row {
            
        case 0:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 1:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 2:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 3:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 4:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 5:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 6:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 7:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 8:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 9:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 10:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        default:
            rowString = "Error: too many rows"
            myImageView.image = nil
        }
        let myLabel = UILabel(frame: CGRect(x:60, y:0, width:pickerView.bounds.width - 90, height:60 ))
        //        myLabel.font = UIFont(name:some, font, size: 18)
        myLabel.text = rowString
        
        myView.addSubview(myLabel)
        myView.addSubview(myImageView)
        
        return myView
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == pickerViewForNoOfPassenger {
            
            if row == 0 {
                intNumberOfPassengerOnShareRiding = 1

            } else if row == 1 {
                intNumberOfPassengerOnShareRiding = 2
            }
            txtNumberOfPassengers.text = "\(intNumberOfPassengerOnShareRiding)"
            
        }
        else {
            
            let data = cardData[row]
            
            imgPaymentType.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
            txtSelectPaymentOption.text = data["CardNum2"] as? String
            
            let type = data["CardNum"] as! String
            
            if type  == "wallet" {
                paymentType = "wallet"
            }
            else if type == "cash" {
                paymentType = "cash"
            }
            else {
                paymentType = "card"
            }
            
            if paymentType == "card" {
                CardID = data["Id"] as! String
            }
            
        }
        
        // do something with selected row
    }
    
    func setCardIcon(str: String) -> String {
        //        visa , mastercard , amex , diners , discover , jcb , other
        var CardIcon = String()
        
        switch str {
        case "visa":
            CardIcon = "Visa"
            return CardIcon
        case "mastercard":
            CardIcon = "MasterCard"
            return CardIcon
        case "amex":
            CardIcon = "Amex"
            return CardIcon
        case "diners":
            CardIcon = "Diners Club"
            return CardIcon
        case "discover":
            CardIcon = "Discover"
            return CardIcon
        case "jcb":
            CardIcon = "JCB"
            return CardIcon
        case "iconCashBlack":
            CardIcon = "iconCashBlack"
            return CardIcon
        case "iconWalletBlack":
            CardIcon = "iconWalletBlack"
            return CardIcon
        case "other":
            CardIcon = "iconDummyCard"
            return CardIcon
        default:
            return ""
        }
        
    }
    
    
    // ----------------------------------------------------------------------
    //-------------------------------------------------------------
    // MARK: - Webservice For Find Cards List Available
    //-------------------------------------------------------------
    
    func callToWebserviceOfCardListViewDidLoad() {
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.reloadWebserviceOfCardList), name: NSNotification.Name(rawValue: "CardListReload"), object: nil)
        
    }
    
    var isReloadWebserviceOfCardList = Bool()
    
    @objc func reloadWebserviceOfCardList() {
        
        
        self.webserviceOfCardList()
        isReloadWebserviceOfCardList = true
        
        self.paymentOptions()
        viewBookNow.isHidden = true
        
    }
    
    var aryCardsListForBookNow = [[String:AnyObject]]()
    
    func webserviceOfCardList() {
        
        webserviceForCardList(SingletonClass.sharedInstance.strPassengerID as AnyObject) { (result, status) in
            
            if (status) {
                //        print(result)
                
                if let res = result as? [String:AnyObject] {
                    if let cards = res["cards"] as? [[String:AnyObject]] {
                        self.aryCardsListForBookNow = cards
                    }
                }
                
                var dict = [String:AnyObject]()
                dict["CardNum"] = "cash" as AnyObject
                dict["CardNum2"] = "cash" as AnyObject
                dict["Type"] = "iconCashBlack" as AnyObject
                
                var dict2 = [String:AnyObject]()
                dict2["CardNum"] = "wallet" as AnyObject
                dict2["CardNum2"] = "wallet" as AnyObject
                dict2["Type"] = "iconWalletBlack" as AnyObject
                
                
                self.aryCardsListForBookNow.append(dict)
                self.aryCardsListForBookNow.append(dict2)
                
                SingletonClass.sharedInstance.CardsVCHaveAryData = (result as! NSDictionary).object(forKey: "cards") as! [[String:AnyObject]]
                
                
                
                self.pickerView.reloadAllComponents()
                
                //                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "CardListReload"), object: nil)
                
                
                
                
                
                /*
                 {
                 cards =     (
                 {
                 Alias = visa;
                 CardNum = 4639251002213023;
                 CardNum2 = "xxxx xxxx xxxx 3023";
                 Id = 59;
                 Type = visa;
                 }
                 );
                 status = 1;
                 }
                 */
                
                
            }
            else {
                //    print(result)
                if let res = result as? String {
                    UtilityClass.setCustomAlert(title: "", message: res) { (index, title) in
                    }
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.setCustomAlert(title: "", message: resDict.object(forKey: "message") as! String) { (index, title) in
                    }
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.setCustomAlert(title: "", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                    }
                }
            }
        }
    }
    
    
    //MARK:- SideMenu Methods
    
    @IBOutlet weak var openSideMenu: UIButton!
    @IBAction func openSideMenu(_ sender: Any) {
        
        sideMenuController?.toggle()
        
    }
    
    
    func onGetEstimateFare() {
        
        self.socket.on(SocketData.kReceiveGetEstimateFare, callback: { (data, ack) in
            print("onkReceiveGetEstimateFare is called")
            

            if (((data as NSArray).firstObject as? NSDictionary) != nil) {
                var estimateData = (data as! [[String:AnyObject]])
                estimateData =  estimateData[0]["estimate_fare"] as! [[String:AnyObject]]
                
                var sortedArray = estimateData.sorted {($0["sort"] as! Int) < ($1["sort"] as! Int)} as [[String:AnyObject]]
                //                if (self.aryEstimateFareData != nil)
                //                {
                
                /*
                 if !(self.aryEstimateFareData).map({($0 as NSDictionary) == $0 as NSDictionary}).contains(false) {

                 let ary1 = self.aryEstimateFareData
                 let ary2 = sortedArray

                 for i in 0..<self.aryEstimateFareData.count {

                 let dict1 = ary1[i] as NSDictionary
                 let dict2 = ary2[i] as NSDictionary

                 if dict1 != dict2 {

                 //                            UIView.performWithoutAnimation {
                 self.collectionViewCars.reloadData()
                 //                            }
                 }
                 }
                 }*/

                //                }
                //                if (SingletonClass.sharedInstance.onlineCars as NSArray != sortedArray as NSArray) {
                //                   self.postPickupAndDropLocationForEstimateFare()
                //
                //                }

                
                
                self.aryEstimateFareDataOfOnlineCars = sortedArray // NSMutableArray(array: sortedArray).mutableCopy() as? NSMutableArray
                SingletonClass.sharedInstance.onlineCars = sortedArray as [[String:AnyObject]]
                
                if(SingletonClass.sharedInstance.isFirstTimeReloadCarList == true && SingletonClass.sharedInstance.onlineCars.isEmpty != false)
                {
                    SingletonClass.sharedInstance.isFirstTimeReloadCarList = false
                    self.collectionViewCars.reloadData()

                }
                
                if(SingletonClass.sharedInstance.onlineCars.isEmpty == false)
                {
                    DispatchQueue.main.async(execute: {
                        self.indexPaths.removeAll()
                        for i in 0..<self.collectionViewCars!.numberOfItems(inSection: 0) {
                            self.indexPaths.append(NSIndexPath(item: i, section: 0))
                        }

                        //                        self.collectionViewCars!.reloadItems(at: self.indexPaths as [IndexPath])

                        self.collectionViewCars.reloadData()
                        
                    })
                    
                }
                //                DispatchQueue.main.async(execute: {
                //  self.collectionViewCars.reloadData()

                //                })
                


                sortedArray = [[String:AnyObject]]()
                var count = Int()
                for i in 0..<self.arrNumberOfOnlineCars.count
                {
                    let dictOnlineCarData = (self.arrNumberOfOnlineCars.object(at: i) as! NSDictionary)
                    count = count + (dictOnlineCarData["carCount"] as! Int)
                    if (count == 0)
                    {
                        
                        if(self.arrNumberOfOnlineCars.count == 0)
                        {
                            
                            let alert = UIAlertController(title: "",
                                                          message: "Book Now cars not available. Please click OK to Book Later.",
                                                          preferredStyle: UIAlertControllerStyle.alert)
                            
                            
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                self.btnBookLater((Any).self)
                            }))
                            
                            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
                            }))
                            
                            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
                        }
                    }
                }
                
                //                UIView.performWithoutAnimation {
                
                //                DispatchQueue.main.async(execute: {
                //                    self.collectionViewCars.reloadData()
                //
                //                })//                }
            }
            
            

        })
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods for Add Address to Favourite
    //-------------------------------------------------------------
    
    func webserviceOfAddAddressToFavourite(type: String) {
        //        PassengerId,Type,Address,Lat,Lng
        
        var param = [String:AnyObject]()
        param["PassengerId"] = SingletonClass.sharedInstance.strPassengerID as AnyObject
        param["Type"] = type as AnyObject
        param["Address"] = txtDestinationLocation.text as AnyObject
        param["Lat"] = doubleDropOffLat as AnyObject  // SingletonClass.sharedInstance.currentLatitude as AnyObject
        param["Lng"] = doubleDropOffLng as AnyObject  // SingletonClass.sharedInstance.currentLongitude as AnyObject
        
        webserviceForAddAddress(param as AnyObject) { (result, status) in
            
            if (status) {
                //  print(result)
                
                if let res = result as? String {
                    
                    UtilityClass.setCustomAlert(title: appName, message: res) { (index, title) in
                    }
                }
                else if let res = result as? NSDictionary {
                    
                    let alert = UIAlertController(title: nil, message: res.object(forKey: "message") as? String, preferredStyle: .alert)
                    let OK = UIAlertAction(title: "OK", style: .default, handler: { ACTION in
                        
                        UIView.transition(with: self.viewForMainFavourite, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
                            self.viewForMainFavourite.isHidden = true
                        }) { _ in }
                    })
                    alert.addAction(OK)
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
            }
            else {
                //     print(result)
            }
        }
    }
    
    //MARK: - Setup Google Maps
    func setupGoogleMap()
    {
        // Initialize the location manager.
        //        locationManager = CLLocationManager()
        //        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestAlwaysAuthorization()
        //        locationManager.distanceFilter = 0.1
        //        locationManager.delegate = self
        //        locationManager.startUpdatingLocation()
        //        locationManager.startUpdatingHeading()
        
        locationManager.delegate = self
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            
            if (locationManager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization)) || locationManager.responds(to: #selector(CLLocationManager.requestAlwaysAuthorization)))
            {
                if locationManager.location != nil
                {
                    locationManager.startUpdatingLocation()
                    
                }
                
            }
        }
        
        
        placesClient = GMSPlacesClient.shared()
        
        mapView.delegate = self
        
        // Create a map.
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: 17)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        
        mapView.camera = camera
        
        self.mapView.settings.rotateGestures = false
        self.mapView.settings.tiltGestures = false
        
        
        //        let position = CLLocationCoordinate2D(latitude: defaultLocation.coordinate.latitude, longitude: defaultLocation.coordinate.longitude)
        //        let marker = GMSMarker(position: position)
        //        marker.map = self.mapView
        //        marker.isDraggable = true
        //        marker.icon = UIImage(named: "iconCurrentLocation")
        
        
        //        mapView.settings.myLocationButton = false
        //        mapView.isMyLocationEnabled = true
        
        
        
        //        self.mapView.padding = UIEdgeInsets(top:txtDestinationLocation.frame.size.height + txtDestinationLocation.frame.origin.y, left: 0, bottom: 0, right: 0)
        
        viewMap.addSubview(mapView)
        mapView.isHidden = true
        
    }
    
    func getPlaceFromLatLong()
    {
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                //                return
            }
            
            //            self.txtCurrentLocation.text = "No current place"
            self.txtCurrentLocation.text = ""
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    self.strPickupLocation = place.formattedAddress!
                    self.doublePickupLat = place.coordinate.latitude
                    self.doublePickupLng = place.coordinate.longitude
                    self.txtCurrentLocation.text = place.formattedAddress?.components(separatedBy: ", ")
                        .joined(separator: "\n")
                    self.strLocationType = self.currentLocationMarkerText
                    
                }
            }
        })
    }
    
    //MARK:- IBActions
    var cardData = [[String:AnyObject]]()
    
    @objc func newBooking(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "New Booking", message: "This will clear old trip details on map for temporary now.", preferredStyle: .alert)
        let OK = UIAlertAction(title: "OK", style: .default, handler: { ACTION in
            self.clearSetupMapForNewBooking()
        })
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { ACTION in

        })
        alert.addAction(OK)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnCollectionViewScrollRight(_ sender: Any) {
        if (arrTotalNumberOfCars.count <= 5) {
            
            //            self.collectionViewCars.scrollToItem(at: NSIndexPath(row: 0, section: 0) as IndexPath, at: .right, animated: true)
        }
        else {
            
            if self.collectionViewCars!.contentSize.width >= 150 {
                self.collectionViewCars.scrollToItem(at: NSIndexPath(row: arrTotalNumberOfCars.count, section: 0) as IndexPath, at: .right, animated: true)
            }
        }
    }
    
    @IBAction func btnCollectionViewScrollLeft(_ sender: Any) {
        
        self.collectionViewCars.scrollToItem(at: NSIndexPath(row: 0, section: 0) as IndexPath, at: .left, animated: true)
    }
    
    
    @IBAction func btnBookNow(_ sender: Any) {
        if Connectivity.isConnectedToInternet()
        {
            
            if intShareRide == 1 {
                self.stackViewNumberOfPassenger.isHidden = false
                txtNumberOfPassengers.text = "1"
            }
            else {
                self.stackViewNumberOfPassenger.isHidden = true
                txtNumberOfPassengers.text = ""
            }
            
            if SingletonClass.sharedInstance.strPassengerID == "" || strModelId == "" || strPickupLocation == "" || strDropoffLocation == "" || doublePickupLat == 0 || doublePickupLng == 0 || doubleDropOffLat == 0 || doubleDropOffLng == 0 || strCarModelID == ""
            {
                if txtCurrentLocation.text!.count == 0 {
                    
                    UtilityClass.setCustomAlert(title: "", message: "Please enter your pickup location again") { (index, title) in
                    }
                }
                else if txtDestinationLocation.text!.count == 0 {
                    
                    UtilityClass.setCustomAlert(title: "", message: "Please enter your destination again") { (index, title) in
                    }
                }
                else if strModelId == "" {
                    
                    //                    UtilityClass.setCustomAlert(title: appName, message: "There are no cars available. Do you want to pay extra chareges?") { (index, title) in
                    //                    }
                    
                    let alert = UIAlertController(title: appName, message: "There are no vehicles available within 5 kms and do u want to pay additional \(currencySign) \(strSpecialRequestFareCharge) and make a booking?", preferredStyle: .alert)
                    let OK = UIAlertAction(title: "Yes", style: .default, handler: { ACTION in
                        self.strSpecialRequest = "1"
                        self.bookingRequest()
                        self.webserviceCallForMissBookingRequest()
                        
                    })
                    let Cancel = UIAlertAction(title: "No", style: .destructive, handler: { ACTION in
                        
                        self.webserviceCallForMissBookingRequest()
                        
                    })
                    
                    
                    alert.addAction(OK)
                    alert.addAction(Cancel)
                    self.present(alert, animated: true, completion: nil)
                    
                }
                else {
                    
                    UtilityClass.setCustomAlert(title: "", message: "Locations or select available car") { (index, title) in
                    }
                }
                
            }
            else {
                strSpecialRequest = "0"
                bookingRequest()
                
                //                if (SingletonClass.sharedInstance.CardsVCHaveAryData.count == 0) && self.aryCardsListForBookNow.count == 2 {
                //                    //                UtilityClass.showAlert("", message: "There is no card, If you want to add card than choose payment options to add card.", vc: self)
                //
                //                    let alert = UIAlertController(title: nil, message: "Do you want to add card.", preferredStyle: .alert)
                //                    let OK = UIAlertAction(title: "OK", style: .default, handler: { ACTION in
                //
                //                        let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
                //
                //                        next.delegateAddCardFromHomeVC = self
                //
                //                        self.navigationController?.present(next, animated: true, completion: nil)
                //
                //                    })
                //                    let Cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { ACTION in
                //                        self.paymentOptions()
                //                    })
                //                    alert.addAction(OK)
                //                    alert.addAction(Cancel)
                //                    self.present(alert, animated: true, completion: nil)
                //
                //                }
                //                else {
                //                    self.paymentOptions()
                //                }
            }
            
        }
        else {
            UtilityClass.showAlert("", message: "Internet connection not available", vc: self)
        }
    }
    
    
    func bookingRequest()
    {
        
        if (SingletonClass.sharedInstance.CardsVCHaveAryData.count == 0) && self.aryCardsListForBookNow.count == 2 {
            //                UtilityClass.showAlert("", message: "There is no card, If you want to add card than choose payment options to add card.", vc: self)
            
            let alert = UIAlertController(title: nil, message: "Do you want to add card.", preferredStyle: .alert)
            let OK = UIAlertAction(title: "OK", style: .default, handler: { ACTION in
                
                let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
                
                next.delegateAddCardFromHomeVC = self
                
                self.navigationController?.present(next, animated: true, completion: nil)
                
            })
            let Cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { ACTION in
                self.paymentOptions()
            })
            alert.addAction(OK)
            alert.addAction(Cancel)
            self.present(alert, animated: true, completion: nil)
            
        }
        else {
            self.paymentOptions()
        }
        
        
    }
    
    func paymentOptions() {
        
        if SingletonClass.sharedInstance.CardsVCHaveAryData.count != 0 {
            
            cardData = SingletonClass.sharedInstance.CardsVCHaveAryData
            
            for i in 0..<aryCardsListForBookNow.count {
                cardData.append(aryCardsListForBookNow[i])
            }
            
            if self.aryCardsListForBookNow.count != 0 {
                cardData = self.aryCardsListForBookNow
            }
            
        }
        else {
            cardData.removeAll()
            
            for i in 0..<aryCardsListForBookNow.count {
                cardData.append(aryCardsListForBookNow[i])
            }
        }
        self.pickerView.reloadAllComponents()
        
        let data = cardData[0]
        
        imgPaymentType.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        txtSelectPaymentOption.text = data["CardNum2"] as? String
        
        let type = data["CardNum"] as! String
        
        if type  == "wallet" {
            paymentType = "wallet"
        }
        else if type == "cash" {
            paymentType = "cash"
        }
        else {
            paymentType = "card"
        }
        
        if paymentType == "card" {
            CardID = data["Id"] as! String
        }
        
        viewBookNow.isHidden = false
        stackViewOfTruckBooking.isHidden = true
    }
    
    func didAddCardFromHomeVC() {
        
        paymentOptions()
    }
    
    @IBAction func btnBookLater(_ sender: Any) {
        
        if Connectivity.isConnectedToInternet() {
            
            let profileData = SingletonClass.sharedInstance.dictProfile
            
            // This is For Book Later Address
            if (SingletonClass.sharedInstance.isFromNotificationBookLater) {
                
                if strCarModelID == "" {
                    
                    UtilityClass.setCustomAlert(title: "", message: "Select Car") { (index, title) in
                    }
                }
                else {
                    let next = self.storyboard?.instantiateViewController(withIdentifier: "BookLaterViewController") as! BookLaterviewController
                    
                    if normalBookingOrTruckBooking == 2 {
                        next.isTruckSelected = true
                        next.truckDetails = truckDetails

                    }
                    
                    
                    SingletonClass.sharedInstance.isFromNotificationBookLater = false
                    
                    next.strModelId = strCarModelID
                    next.strCarModelURL = strNavigateCarModel
                    next.strCarName = strCarModelClass
                    
                    next.strFullname = profileData.object(forKey: "Fullname") as! String
                    next.strMobileNumber = profileData.object(forKey: "MobileNo") as! String
                    
                    next.strPickupLocation = strPickupLocation
                    next.doublePickupLat = doublePickupLat
                    next.doublePickupLng = doublePickupLng
                    
                    next.strDropoffLocation = strDropoffLocation
                    next.doubleDropOffLat = doubleDropOffLat
                    next.doubleDropOffLng = doubleDropOffLng
                    
                    self.navigationController?.pushViewController(next, animated: true)
                }
            }
            else {
                
                if strCarModelID == "" && strCarModelIDIfZero == ""{
                    UtilityClass.setCustomAlert(title: "", message: "Select Car") { (index, title) in
                    }
                }
                else {
                    let next = self.storyboard?.instantiateViewController(withIdentifier: "BookLaterViewController") as! BookLaterviewController
                    
                    if normalBookingOrTruckBooking == 2 {
                        next.isTruckSelected = true
                        next.truckDetails = truckDetails
                    }
                    
                    next.strModelId = strCarModelID
                    next.strCarModelURL = strNavigateCarModel
                    next.strCarName = strCarModelClass
                    
                    next.strPickupLocation = strPickupLocation
                    next.doublePickupLat = doublePickupLat
                    next.doublePickupLng = doublePickupLng
                    
                    next.strDropoffLocation = strDropoffLocation
                    next.doubleDropOffLat = doubleDropOffLat
                    next.doubleDropOffLng = doubleDropOffLng
                    
                    next.strFullname = profileData.object(forKey: "Fullname") as! String
                    next.strMobileNumber = profileData.object(forKey: "MobileNo") as! String
                    
                    self.navigationController?.pushViewController(next, animated: true)
                    
                }
            }
        }
        else {
            UtilityClass.showAlert("", message: "Internet connection not available", vc: self)
        }
        
        
    }
    
    @IBAction func btnGetFareEstimate(_ sender: Any) {
        
        if txtCurrentLocation.text == "" || txtDestinationLocation.text == "" {
            
            
            UtilityClass.setCustomAlert(title: "", message: "Please enter both address.") { (index, title) in
            }
        }
            
        else {
            
            self.postPickupAndDropLocationForEstimateFare()
        }
    }
    
    @IBOutlet weak var btnRequest: UIButton!
    @IBAction func btnRequest(_ sender: UIButton)
    {
        
        let alert = UIAlertController(title: appName, message: "Are you sure to cancel this trip", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Yes", style: .default) { (ACTION) in
            
            if self.CancellationFee != "" {
                
                let alertCancellationFee = UIAlertController(title: appName, message: "If you cancel the trip you will be partially charged.", preferredStyle: .alert)
                
                let OkCancellationFee = UIAlertAction(title: "Yes", style: .default) { (ACTION) in
                    
                    if self.strBookingType == "BookLater" {
                        self.CancelBookLaterTripAfterDriverAcceptRequest()
                    }
                    else {
                        self.socketMethodForCancelRequestTrip()
                    }
                    
                    self.clearMap()
                    
                    self.txtCurrentLocation.text = ""
                    self.txtDestinationLocation.text = ""
                    
                    self.clearDataAfteCompleteTrip()
                    
                    self.getPlaceFromLatLong()
                    
                    //        UtilityClass.setCustomAlert(title: "\(appName)", message: "Request Cancelled") { (index, title) in
                    //        }
                    
                    self.viewTripActions.isHidden = true
                    self.viewCarLists.isHidden = true
                    // bhavesh change - self.ConstantViewCarListsHeight.constant = 170 // 150
                    //        self.constraintTopSpaceViewDriverInfo.constant = 170
                    //        self.viewShareRideView.isHidden = true
                }
                let CancelCancellationFee = UIAlertAction(title: "No", style: .default, handler: nil)
                
                alertCancellationFee.addAction(OkCancellationFee)
                alertCancellationFee.addAction(CancelCancellationFee)
                
                self.present(alertCancellationFee, animated: true, completion: nil)
            }
            else {
                
                if self.strBookingType == "BookLater" {
                    self.CancelBookLaterTripAfterDriverAcceptRequest()
                }
                else {
                    self.socketMethodForCancelRequestTrip()
                }
                
                
                self.clearMap()
                
                self.txtCurrentLocation.text = ""
                self.txtDestinationLocation.text = ""
                
                self.clearDataAfteCompleteTrip()
                
                self.getPlaceFromLatLong()
                
                
                //        UtilityClass.setCustomAlert(title: "\(appName)", message: "Request Cancelled") { (index, title) in
                //        }
                
                self.viewTripActions.isHidden = true
                self.viewCarLists.isHidden = true
                // bhavesh change - self.ConstantViewCarListsHeight.constant = 170 // 150
                //        self.constraintTopSpaceViewDriverInfo.constant = 170
                //        self.viewShareRideView.isHidden = true
            }
            
        }
        let cancel = UIAlertAction(title: "No", style: .default, handler: nil)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
        
        
        
    }
    
    @IBOutlet weak var btnDriverInfo: UIButton!
    @IBAction func btnDriverInfo(_ sender: UIButton) {
        
        let DriverInfo = ((self.aryRequestAcceptedData.object(at: 0) as! NSDictionary).object(forKey: "DriverInfo") as! NSArray).object(at: 0) as! NSDictionary
        let carInfo = ((self.aryRequestAcceptedData.object(at: 0) as! NSDictionary).object(forKey: "CarInfo") as! NSArray).object(at: 0) as! NSDictionary
        let bookingInfo = ((self.aryRequestAcceptedData.object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as! NSArray).object(at: 0) as! NSDictionary
        
        showDriverInfo(bookingInfo: bookingInfo, DriverInfo: DriverInfo, carInfo: carInfo)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func swipDownDriverInfo(_ sender: UISwipeGestureRecognizer) {
        
        //        constraintTopSpaceViewDriverInfo.constant = 170
        
    }
    
    @IBAction func TapToDismissGesture(_ sender: UITapGestureRecognizer) {
        
        
        UIView.transition(with: viewForMainFavourite, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
            self.viewForMainFavourite.isHidden = true
        }) { _ in }
        
        
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        
        
        //        self.dismiss(animated: true, completion: nil)
    }
    
    // function which is triggered when handleTap is called
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        print("Hello World")
        
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
    
    @IBAction func btnCancelStartedTrip(_ sender: UIButton) {
        
        
        UtilityClass.showAlert("", message: "Currently this feature is not available.", vc: self)
    }
    
    
    
    //-------------------------------------------------------------
    // MARK: - Favourite Delegate Methods
    //-------------------------------------------------------------
    
    func didEnterFavouriteDestination(Source: [String:AnyObject]) {
        
        txtDestinationLocation.text = Source["Address"] as? String
        strDropoffLocation = Source["Address"] as! String
        doubleDropOffLat = Double(Source["Lat"] as! String)!
        doubleDropOffLng = Double(Source["Lng"] as! String)!
    }
    
    //-------------------------------------------------------------
    // MARK: - Favourites Actions
    //-------------------------------------------------------------
    
    @IBAction func btnHome(_ sender: UIButton) {
        
        webserviceOfAddAddressToFavourite(type: "Home")
    }
    
    @IBAction func btnOffice(_ sender: UIButton) {
        
        webserviceOfAddAddressToFavourite(type: "Office")
    }
    
    @IBAction func btnAirport(_ sender: UIButton) {
        
        webserviceOfAddAddressToFavourite(type: "Airport")
    }
    
    @IBAction func btnOthers(_ sender: UIButton) {
        
        webserviceOfAddAddressToFavourite(type: "Others")
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Sound Implement Methods
    //-------------------------------------------------------------
    
    var audioPlayer:AVAudioPlayer!
    
    //    RequestConfirm.m4a
    //    ringTone.mp3
    
    
    func playSound(fileName: String, extensionType: String) {
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: extensionType) else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            audioPlayer.numberOfLoops = 1
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    func stopSound(fileName: String, extensionType: String) {
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: extensionType) else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            audioPlayer.stop()
            audioPlayer = nil
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    //MARK:- Collectionview Delegate and Datasource methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if self.arrNumberOfOnlineCars.count == 0 {
            return 6
        }
        //        print("numberOfItemsInSection section: \(section) and arrNumberOfOnlineCars.count = \(self.arrNumberOfOnlineCars.count)")
        return self.arrNumberOfOnlineCars.count
        
        

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        //        print("Cell Current Row: \(indexPath.row) and arrNumberOfOnlineCars.count = \(self.arrNumberOfOnlineCars.count)")
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarsCollectionViewCell", for: indexPath as IndexPath) as! CarsCollectionViewCell
        
        cell.viewOfImage.layer.cornerRadius = cell.viewOfImage.frame.width / 2
        cell.viewOfImage.layer.borderWidth = 3.0
        if selectedIndexPath == indexPath {
            cell.viewOfImage.layer.borderColor = themeYellowColor.cgColor
            cell.viewOfImage.layer.masksToBounds = true
        }
        else {
            cell.viewOfImage.layer.borderColor = themeGrayColor.cgColor
            cell.viewOfImage.layer.masksToBounds = true
        }
        
        if self.arrNumberOfOnlineCars.count == 0 {
            cell.imgCars.sd_setIndicatorStyle(.gray)
            cell.imgCars.sd_setShowActivityIndicatorView(true)//binal
            
        }
        else if (self.arrNumberOfOnlineCars.count != 0 && indexPath.row < self.arrNumberOfOnlineCars.count)
        {
            let dictOnlineCarData = (arrNumberOfOnlineCars.object(at: indexPath.row) as! [String : AnyObject])
            let imageURL = dictOnlineCarData["Image"] as! String
            //
            cell.imgCars.sd_setIndicatorStyle(.gray)
            cell.imgCars.sd_setShowActivityIndicatorView(true)//binal

            if imageURL != "" {
                cell.imgCars.sd_setImage(with: URL(string: imageURL), completed: { (image, error, cacheType, url) in
                    cell.imgCars.sd_setShowActivityIndicatorView(false)
                })//binal
            }

            cell.lblCarName.text = dictOnlineCarData["Name"] as? String
            
            if normalBookingOrTruckBooking == 1 {
                
                cell.lblMinutes.isHidden = false
                cell.lblPrices.isHidden = false
                cell.constraintHeightOfMinutes.constant = 13
                cell.constraintHeightOfPrice.constant = 13

                cell.lblMinutes.text =  "0 min" //"Loading..."
                cell.lblPrices.text = "\(currencySign) 0.00"//"Loading..."//
                
                if dictOnlineCarData["carCount"] as! Int != 0 {
                    
                    if ( SingletonClass.sharedInstance.onlineCars != nil) {

                        if  SingletonClass.sharedInstance.onlineCars.count != 0 {
                            
                            //                            if ((self.aryEstimateFareData?.object(at: indexPath.row) as! NSDictionary).object(forKey: "duration") as? NSNull) != nil {
                            //
                            //                                cell.lblMinutes.text = "\(0.00) min" //"Loading..."
                            //                            }
                            //                            else if let minute = (self.aryEstimateFareData?.object(at: indexPath.row) as! NSDictionary).object(forKey: "duration") as? Double {
                            //                                cell.lblMinutes.text =  "\(minute) min"  //"Loading"
                            //                            }
                            //
                            //                            if ((self.aryEstimateFareData?.object(at: indexPath.row) as! NSDictionary).object(forKey: "total") as? NSNull) != nil {
                            //
                            //                                cell.lblPrices.text = "\(currencySign) \(0)"
                            //                            }
                            //                            else if let price = (self.aryEstimateFareData?.object(at: indexPath.row) as! NSDictionary).object(forKey: "total") as? Double {
                            //
                            //                                cell.lblPrices.text = "\(currencySign) \(price)"
                            //                            }
                            
                            if let durationString = SingletonClass.sharedInstance.onlineCars[indexPath.row]["duration"] as? String {
                                cell.lblMinutes.text = "\(durationString) min"
                            }
                            else if let durationDouble = SingletonClass.sharedInstance.onlineCars[indexPath.row]["duration"] as? Double {
                                cell.lblMinutes.text = "\(durationDouble) min"
                            }
                            else {
                                cell.lblMinutes.text = "\(0.00) min"
                            }
                            
                            if let priceString = SingletonClass.sharedInstance.onlineCars[indexPath.row]["total"] as? String {
                                cell.lblPrices.text = "\(currencySign) \(priceString)"
                            }
                            else if let priceDouble = SingletonClass.sharedInstance.onlineCars[indexPath.row]["total"] as? Double {
                                cell.lblPrices.text = "\(currencySign) \(priceDouble)"
                            }
                            else {
                                cell.lblPrices.text = "\(currencySign) \(0)"
                            }
                            
                            
                            
                            
                            
                            
                            //                    if (intShareRide == 1) {
                            //
                            //                        if let ride = (self.aryEstimateFareData.object(at: indexPath.row) as! NSDictionary).object(forKey: "share_ride") as? String {
                            //
                            //                            if ride == "1" {
                            //                                cell.contentView.isUserInteractionEnabled = true
                            //                            }
                            //                            else if ride == "0" {
                            //
                            //                            }
                            //                        }
                            //                    }
                            
                        }
                    }
                }
            }
            else {
                cell.constraintHeightOfMinutes.constant = 0
                cell.constraintHeightOfPrice.constant = 0
                cell.lblMinutes.isHidden = true
                cell.lblPrices.isHidden = true
            }
            
        }
        //        else
        //        {
        //            cell.imgCars.image = UIImage(named: "iconPackage")
        //            cell.lblMinutes.text = "Packages"
        //            cell.lblPrices.text = ""
        //
        //        }//binal
        
        return cell
        
        // Maybe for future testing ///////
        
        
    }
    
    var markerOnlineCars = GMSMarker()
    var aryMarkerOnlineCars = [GMSMarker]()
    
    var truckDetails = (name: "", height: "", width: "", capacity: "", image: "", desc: "")
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        MarkerCurrntLocation.isHidden = true
        
        if self.arrNumberOfOnlineCars.count == 0 {
            // do nothing here
        }
        else if (arrNumberOfOnlineCars.count != 0 && indexPath.row < self.arrNumberOfOnlineCars.count)
        {
            
            let dictOnlineCarData = (arrNumberOfOnlineCars.object(at: indexPath.row) as! NSDictionary)
            strSpecialRequestFareCharge = dictOnlineCarData.object(forKey: "SpecialExtraCharge") as? String ?? ""
            
            if normalBookingOrTruckBooking == 2 {
                
                if let heightString = dictOnlineCarData.object(forKey: "Height") as? String {
                    truckDetails.height = heightString
                }
                else if let heightInt = dictOnlineCarData.object(forKey: "Height") as? Int {
                    truckDetails.height = "\(heightInt)"
                }
                
                if let WidthString = dictOnlineCarData.object(forKey: "Width") as? String {
                    truckDetails.width = WidthString
                }
                else if let WidthInt = dictOnlineCarData.object(forKey: "Width") as? Int {
                    truckDetails.width = "\(WidthInt)"
                }
                
                if let CapacityString = dictOnlineCarData.object(forKey: "Capacity") as? String {
                    truckDetails.capacity = CapacityString
                }
                else if let CapacityInt = dictOnlineCarData.object(forKey: "Capacity") as? Int {
                    truckDetails.capacity = "\(CapacityInt)"
                }
                
                truckDetails.name = dictOnlineCarData.object(forKey: "Name") as? String ?? ""
                truckDetails.image = dictOnlineCarData.object(forKey: "ModelSizeImage") as? String ?? ""
                truckDetails.desc = dictOnlineCarData.object(forKey: "Description") as? String ?? ""
            }
            
            
            if dictOnlineCarData.object(forKey: "carCount") as! Int != 0 {

                self.markerOnlineCars.map = nil
                
                for i in 0..<self.aryMarkerOnlineCars.count {
                    
                    self.aryMarkerOnlineCars[i].map = nil
                }
                
                self.aryMarkerOnlineCars.removeAll()
                
                let available = dictOnlineCarData.object(forKey: "carCount") as! Int
                let checkAvailabla = String(available)
                
                
                var lati = dictOnlineCarData.object(forKey: "Lat") as! Double
                var longi = dictOnlineCarData.object(forKey: "Lng") as! Double
                //
                //                let camera = GMSCameraPosition.camera(withLatitude: lati,
                //                                                      longitude: longi,
                //                                                      zoom: 17.5)
                //
                //                self.mapView.camera = camera
                
                let locationsArray = (dictOnlineCarData.object(forKey: "locations") as! [[String:AnyObject]])
                
                for i in 0..<locationsArray.count
                {
                    if( (locationsArray[i]["CarType"] as! String) == (dictOnlineCarData.object(forKey: "Id") as! String))
                    {
                        lati = (locationsArray[i]["Location"] as! [AnyObject])[0] as! Double
                        longi = (locationsArray[i]["Location"] as! [AnyObject])[1] as! Double
                        let position = CLLocationCoordinate2D(latitude: lati, longitude: longi)
                        self.markerOnlineCars = GMSMarker(position: position)
                        //                        self.markerOnlineCars.tracksViewChanges = false
                        //                        self.strSelectedCarMarkerIcon = self.markertIcon(index: indexPath.row)
                        self.strSelectedCarMarkerIcon = self.setCarImage(modelId: dictOnlineCarData.object(forKey: "Id") as! String)
                        //                        self.markerOnlineCars.icon = UIImage(named: self.markertIcon(index: indexPath.row)) // iconCurrentLocation
                        
                        self.aryMarkerOnlineCars.append(self.markerOnlineCars)
                        
                        //                        self.markerOnlineCars.map = nil
                        //                    self.markerOnlineCars.map = self.mapView

                    }
                }
                
                // Show Nearest Driver from Passenger
                if self.aryMarkerOnlineCars.count != 0 {
                    if self.aryMarkerOnlineCars.first != nil {
                        if let nearestDriver = self.aryMarkerOnlineCars.first {
                            
                            let camera = GMSCameraPosition.camera(withLatitude: nearestDriver.position.latitude, longitude: nearestDriver.position.longitude, zoom: 17.5)
                            self.mapView.camera = camera
                        }
                    }
                }
                
                for i in 0..<self.aryMarkerOnlineCars.count {
                    
                    self.aryMarkerOnlineCars[i].position = self.aryMarkerOnlineCars[i].position
                    self.aryMarkerOnlineCars[i].icon = UIImage(named: self.setCarImage(modelId: dictOnlineCarData.object(forKey: "Id") as! String))
                    self.aryMarkerOnlineCars[i].map = self.mapView
                }
                
                let carModelID = dictOnlineCarData.object(forKey: "Id") as? String
                let carModelIDConverString: String = carModelID!
                
                let strCarName: String = dictOnlineCarData.object(forKey: "Name") as! String
                
                strCarModelClass = strCarName
                strCarModelID = carModelIDConverString
                
                selectedIndexPath = indexPath
                
                let cell = collectionView.cellForItem(at: indexPath) as! CarsCollectionViewCell
                cell.viewOfImage.layer.borderColor = themeYellowColor.cgColor
                
                let imageURL = dictOnlineCarData.object(forKey: "Image") as! String
                strNavigateCarModel = imageURL
                strCarModelIDIfZero = ""
                if checkAvailabla != "0" {
                    strModelId = dictOnlineCarData.object(forKey: "Id") as! String
                }
                else {
                    strModelId = "0"
                }
            }
            else {
                
                for i in 0..<self.aryMarkerOnlineCars.count {
                    
                    self.aryMarkerOnlineCars[i].map = nil
                }
                
                self.aryMarkerOnlineCars.removeAll()
                
                
                let carModelID = dictOnlineCarData.object(forKey: "Id") as? String
                let carModelIDConverString: String = carModelID!
                
                let strCarName: String = dictOnlineCarData.object(forKey: "Name") as! String
                
                strCarModelClass = strCarName
                strCarModelID = carModelIDConverString

                let cell = collectionView.cellForItem(at: indexPath) as! CarsCollectionViewCell
                cell.viewOfImage.layer.borderColor = themeGrayColor.cgColor
                
                selectedIndexPath = indexPath
                
                let imageURL = dictOnlineCarData.object(forKey: "Image") as! String
                
                strNavigateCarModel = imageURL
                //                strCarModelID = ""
                strCarModelIDIfZero = carModelIDConverString
                
                let available = dictOnlineCarData.object(forKey: "carCount") as! Int
                let checkAvailabla = String(available)
                
                if checkAvailabla != "0" {
                    strModelId = dictOnlineCarData.object(forKey: "Id") as! String
                }
                else {
                    strModelId = ""
                }
                
            }
            //            let carModelID = dictOnlineCarData.object(forKey: "Id") as? String
            //            let carModelIDConverString: String = carModelID!
            //
            //            let strCarName: String = dictOnlineCarData.object(forKey: "Name") as! String
            //
            //            strCarModelClass = strCarName
            //            strCarModelID = carModelIDConverString
            //
            //
            //            selectedIndexPath = indexPath
            //
            //            let cell = collectionView.cellForItem(at: indexPath) as! CarsCollectionViewCell
            //            //                cell.viewOfImage.layer.borderColor = UIColor.red.cgColor
            //
            //            cell.imgCars.image = UIImage.init(named: "selectedCar")
            //            cell.lblPrices.textColor = ThemePinkColor
            //            cell.lblMinutes.textColor = UIColor.black
            //            let imageURL = dictOnlineCarData.object(forKey: "Image") as! String
            //            strNavigateCarModel = imageURL
            //
            //            collectionViewCars.reloadData()
        }
        else
        {
            
            clearMap()
            /*
             let lati = dictOnlineCarData.object(forKey: "Lat") as! Double
             let longi = dictOnlineCarData.object(forKey: "Lng") as! Double
             
             DispatchQueue.main.async {
             let position = CLLocationCoordinate2D(latitude: lati, longitude: longi)
             let marker = GMSMarker(position: position)
             marker.tracksViewChanges = false
             marker.icon = UIImage(named: "") // iconCurrentLocation
             marker.map = self.mapView
             }
             */
            //            let carModelID = dictOnlineCarData.object(forKey: "Id") as? String
            //            let carModelIDConverString: String = carModelID!
            //
            //            let strCarName: String = dictOnlineCarData.object(forKey: "Name") as! String
            //
            //            strCarModelClass = strCarName
            //
            //            let cell = collectionView.cellForItem(at: indexPath) as! CarsCollectionViewCell
            //            //                cell.viewOfImage.layer.borderColor = UIColor.red.cgColor
            //
            //            cell.imgCars.isHidden = true
            //            cell.imgCars.image = UIImage.init(named: "selectedCar")
            //            cell.lblPrices.textColor = ThemePinkColor
            //            cell.lblMinutes.textColor = UIColor.black
            //            selectedIndexPath = indexPath
            //
            //            let imageURL = dictOnlineCarData.object(forKey: "Image") as! String
            //
            //            strNavigateCarModel = imageURL
            //
            //            strCarModelID = carModelIDConverString
            


            //            let PackageVC = self.storyboard?.instantiateViewController(withIdentifier: "PackageViewController")as! PackageViewController
            //            let navController = UINavigationController(rootViewController: PackageVC) // Creating a navigation controller with VC1 at the root of the navigation stack.
            //
            //            PackageVC.strPickupLocation = strPickupLocation
            //            PackageVC.doublePickupLat = doublePickupLat
            //            PackageVC.doublePickupLng = doublePickupLng
            //
            //            self.present(navController, animated:true, completion: nil)
        }
        collectionViewCars.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath as IndexPath) as! CarsCollectionViewCell
        cell.viewOfImage.layer.borderColor = themeGrayColor.cgColor
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        //        print("collectionViewLayout: \(indexPath.row)")
        return CGSize(width: self.view.frame.size.width/3, height: self.collectionViewCars.frame.size.height)
    }
    
    
    // ----------------------------------------------------
    // MARK: - Share ride selection list
    // ----------------------------------------------------

    //    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    //
    //        if (intShareRide == 1) {
    //
    //            if (self.aryEstimateFareData.count) != 0 {
    //                if self.aryEstimateFareData.object(at: indexPath.row) as? NSDictionary != nil {
    //
    //                    if let ride = (self.aryEstimateFareData.object(at: indexPath.row) as! NSDictionary).object(forKey: "share_ride") as? String {
    //
    //                        if ride == "1" {
    //                            return true
    //                        }
    //                        else if ride == "0" {
    //                            return false
    //                        }
    //                    }
    //                }
    //            }
    //        }
    //
    //        return true
    //    }
    
    var carLocationsLat = Double()
    var carLocationsLng = Double()
    
    //MARK - Set car icons
    func setData()
    {
        var k = 0 as Int
        self.arrNumberOfOnlineCars.removeAllObjects()
        
        aryTempOnlineCars = NSMutableArray()
        
        for j in 0..<self.arrTotalNumberOfCars.count
        {

            if ((self.arrTotalNumberOfCars[j] as! [String:AnyObject])["Status"] as! String) == "1" {
                
                k = 0
                let tempAryLocationOfDriver = NSMutableArray()
                
                let totalCarsAvailableCarTypeID = (self.arrTotalNumberOfCars.object(at: j) as! NSDictionary).object(forKey: "Id") as! String
                for i in 0..<self.arrNumberOfAvailableCars.count
                {
                    let dictLocation = NSMutableDictionary()
                    
                    let carType = (self.arrNumberOfAvailableCars.object(at: i) as! NSDictionary).object(forKey: "CarType") as! String
                    
                    if (totalCarsAvailableCarTypeID == carType)
                    {
                        k = k+1
                    }
                    
                    carLocationsLat = ((self.arrNumberOfAvailableCars.object(at: i) as! NSDictionary).object(forKey: "Location") as! NSArray).object(at: 0) as! Double
                    carLocationsLng = ((self.arrNumberOfAvailableCars.object(at: i) as! NSDictionary).object(forKey: "Location") as! NSArray).object(at: 1) as! Double
                    dictLocation.setDictionary(((self.arrNumberOfAvailableCars.object(at: i) as! NSDictionary) as! [AnyHashable : Any]))
                    tempAryLocationOfDriver.add(dictLocation)
                    
                }

                let tempDict =  NSMutableDictionary(dictionary: (self.arrTotalNumberOfCars.object(at: j) as! NSDictionary))
                tempDict.setObject(k, forKey: "carCount" as NSCopying)
                tempDict.setObject(carLocationsLat, forKey: "Lat" as NSCopying)
                tempDict.setObject(carLocationsLng, forKey: "Lng" as NSCopying)
                tempDict.setObject(tempAryLocationOfDriver, forKey: "locations" as NSCopying)

                aryTempOnlineCars.add(tempDict)
            }

        }
        
        SortIdOfCarsType()
        
    }
    
    var aryTempOnlineCars = NSMutableArray()
    var checkTempData = NSArray()
    
    var aryOfOnlineCarsIds = [String]()
    var aryOfTempOnlineCarsIds = [String]()
    
    func SortIdOfCarsType() {
        
        
        
        //        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
        
        let sortedArray = (self.aryTempOnlineCars as NSArray).sortedArray(using: [NSSortDescriptor(key: "Sort", ascending: true)]) as! [[String:AnyObject]]

        self.arrNumberOfOnlineCars = NSMutableArray(array: sortedArray)

        if self.checkTempData.count == 0 {

            SingletonClass.sharedInstance.isFirstTimeReloadCarList = true
            self.checkTempData = self.aryTempOnlineCars as NSArray

            self.collectionViewCars.reloadData()
        }
        else {

            for i in 0..<self.aryTempOnlineCars.count {

                let arySwif = self.aryTempOnlineCars.object(at: i) as! NSDictionary

                if (self.checkTempData.object(at: i) as! NSDictionary) == arySwif {

                    if SingletonClass.sharedInstance.isFirstTimeReloadCarList == true && SingletonClass.sharedInstance.onlineCars.isEmpty == false {
                        SingletonClass.sharedInstance.isFirstTimeReloadCarList = false

                        if self.txtCurrentLocation.text!.count != 0 && self.txtDestinationLocation.text!.count != 0 && self.aryOfOnlineCarsIds.count != 0 {
                            self.postPickupAndDropLocationForEstimateFare()
                        }
                        self.collectionViewCars.reloadData()

                    }
                }
                else {
                    self.checkTempData = self.aryTempOnlineCars as NSArray
                    // ----------------------------------------------------
                    // MARK: - Change before production
                    // ----------------------------------------------------
                    //                        if self.txtCurrentLocation.text!.count != 0 && self.txtDestinationLocation.text!.count != 0 && self.aryOfOnlineCarsIds.count != 0 {
                    //                            self.postPickupAndDropLocationForEstimateFare()
                    //                        }

                    //                        DispatchQueue.main.async {
                    //                            self.collectionViewCars.reloadData()
                    //                        }

                }
            }
        }
        //        })
        
    }
    
    //    func markertIcon(index: Int) -> String {
    //
    //        switch index {
    //        case 0: // "1":
    //            return "imgTaxi"
    //        case 1: // "2":
    //            return "imgTaxi"
    //        case 2: // "3":
    //            return "imgTaxi"
    //        case 3: // "4":
    //            return "imgTaxi"
    //        case 4: // "5":
    //            return "imgTaxi"
    //        case 5: // "6":
    //            return "imgTaxi"
    //        case 6: // "7":
    //            return "imgTaxi"
    //            //        case "8":
    //            //            return "imgTaxi"
    //            //        case "9":
    //            //            return "imgTaxi"
    //            //        case "10":
    //            //            return "imgTaxi"
    //            //        case "11":
    //        //            return "imgTaxi"
    //        default:
    //            return "imgTaxi"
    //        }
    
    func setCarImage(modelId : String) -> String {
        
        var CarModel = String()
        
        switch modelId {
        case "1":
            CarModel = "imgBusinessClass"
            return CarModel
        case "2":
            CarModel = "imgMIni"
            return CarModel
        case "3":
            CarModel = "imgVan"
            return CarModel
        case "4":
            CarModel = "imgNano"
            return CarModel
        case "5":
            CarModel = "imgTukTuk"
            return CarModel
        case "6":
            CarModel = "imgBreakdown"
            return CarModel
        default:
            CarModel = "imgBus"
            return CarModel
        }
    }
    
    /*/
     switch index {
     case 0: // "1":
     return "iconNano"
     case 1: // "2":
     return "iconPremium"
     case 2: // "3":
     return "iconBreakdownServices"
     case 3: // "4":
     return "iconVan"
     case 4: // "5":
     return "iconTukTuk"
     case 5: // "6":
     return "iconMiniCar"
     case 6: // "7":
     return "iconBusRed"
     //        case "8":
     //            return "Motorbike"
     //        case "9":
     //            return "Car Delivery"
     //        case "10":
     //            return "Van / Trays"
     //        case "11":
     //            return "3T truck"
     default:
     return "imgTaxi"
     }
     */
    
    //        switch index {
    //        case 0:
    //            return "imgFirstClass"
    //        case 1:
    //            return "imgBusinessClass"
    //        case 2:
    //            return "imgEconomy"
    //        case 3:
    //            return "imgTaxi"
    //        case 4:
    //            return "imgLUXVAN"
    //        case 5:
    //            return "imgDisability"
    //        default:
    //            return ""
    //        }
    
    
    func uniq<S : Sequence, T : Hashable>(source: S) -> [T] where S.Iterator.Element == T {
        var buffer = [T]()
        var added = Set<T>()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "seguePresentTripDetails")
        {
            let drinkViewController = segue.destination as! TripDetailsViewController
            drinkViewController.arrData = arrDataAfterCompletetionOfTrip as NSMutableArray
            drinkViewController.delegate = self
            
        }
        
        if(segue.identifier == "segueDriverInfo")
        {
            //            let deiverInfo = segue.destination as! DriverInfoViewController
        }
        if(segue.identifier == "showRating")
        {
            
            let GiveRatingVC = segue.destination as! GiveRatingViewController
            GiveRatingVC.strBookingType = self.strBookingType
            //            GiveRatingVC.delegate = self
        }
    }
    
    
    func BookingConfirmed(dictData : NSDictionary)
    {
        
        let DriverInfo = ((self.aryRequestAcceptedData.object(at: 0) as! NSDictionary).object(forKey: "DriverInfo") as! NSArray).object(at: 0) as! NSDictionary
        let carInfo = ((self.aryRequestAcceptedData.object(at: 0) as! NSDictionary).object(forKey: "CarInfo") as! NSArray).object(at: 0) as! NSDictionary
        let bookingInfo = ((self.aryRequestAcceptedData.object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as! NSArray).object(at: 0) as! NSDictionary
        
        
        //        showDriverInfo(bookingInfo: bookingInfo, DriverInfo: DriverInfo, carInfo: carInfo)
        
    }
    
    //MARK: - Socket Methods
    
    
    func socketMethods()
    {
        
        socket.on(clientEvent: .disconnect) { (data, ack) in
            print ("socket is disconnected please reconnect")
        }
        
        socket.on(clientEvent: .reconnect) { (data, ack) in
            print ("socket is reconnected")
        }
        
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            
            self.methodsAfterConnectingToSocket()
            
            if self.socket.status != .connected {
                
                print("socket.status != .connected")
            }
            
            if (isSocketConnected == false) {
                isSocketConnected = true
                print("socket ON methods called")
                
                self.socketMethodForGettingBookingAcceptNotification()  // Accept Now Req
                self.socketMethodForGettingBookingRejectNotification()  // Reject Now Req
                self.socketMethodForGettingPickUpNotification()         // Start Now Req
                self.socketMethodForGettingTripCompletedNotification()  // CompleteTrip Now Req
                self.onTripHoldingNotificationForPassengerLater()       // Hold Trip Later
                self.onReceiveDriverLocationToPassenger()               // Driver Location Receive
                self.socketMethodForGettingBookingRejectNotificatioByDriver()   // Reject By Driver
                self.onAcceptBookLaterBookingRequestNotification()              // Accept Later Req
                self.onRejectBookLaterBookingRequestNotification()              // Reject Later Req
                self.onPickupPassengerByDriverInBookLaterRequestNotification()
                self.onTripHoldingNotificationForPassenger()                    // Hold Trip Now
                self.onBookingDetailsAfterCompletedTrip()                       // Booking Details After Complete Trip
                self.onGetEstimateFare()                                        // Get Estimate
                self.onAdvanceTripInfoBeforeStartTrip()                         // Start Later Req
                self.onReceiveNotificationWhenDriverAcceptRequest()
                
            }
            
            self.socket.on(SocketData.kNearByDriverList, callback: { (data, ack) in
                //                print("SocketData.kNearByDriverList, is \(data)")
                
                var lat : Double!
                var long : Double!
                
                self.arrNumberOfAvailableCars = NSMutableArray(array: ((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "driver") as! NSArray)
                self.setData()
                
                if (((data as NSArray).object(at: 0) as! NSDictionary).count != 0)
                {
                    for i in 0..<(((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "driver") as! NSArray).count
                    {
                        
                        let arrayOfCoordinte = ((((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "driver") as! NSArray).object(at: i) as! NSDictionary).object(forKey: "Location") as! NSArray
                        lat = arrayOfCoordinte.object(at: 0) as! Double
                        long = arrayOfCoordinte.object(at: 1) as! Double
                        
                        let DriverId = ((((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "driver") as! NSArray).object(at: i) as! NSDictionary).object(forKey: "DriverId") as! String
                        
                        self.aryOfTempOnlineCarsIds.append(DriverId)
                        //                        self.aryOfOnlineCarsIds = self.uniq(source: self.aryOfTempOnlineCarsIds) // 8-OCT-2018
                        
                    }
                    self.aryOfOnlineCarsIds = self.uniq(source: self.aryOfTempOnlineCarsIds)
                }
                // Make change before production
                //                if self.txtCurrentLocation.text?.count != 0 && self.txtDestinationLocation.text?.count != 0 {
                //                    self.postPickupAndDropLocationForEstimateFare()
                //                }
                

            })
            
        }
        
        socket.connect()
    }
    
    var timesOfAccept = Int()
    @objc func bookingAcceptNotificationMethodCallInTimer() {
        timesOfAccept += 1
        print("ACCCEPT by Timer: \(timesOfAccept)")
        
        self.socketMethodForGettingBookingAcceptNotification()
    }
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
        
    }
    
    
    @objc func updateCounting(){
        let myJSON = ["PassengerId" : SingletonClass.sharedInstance.strPassengerID, "Lat": doublePickupLat, "Long": doublePickupLng, "Token" : SingletonClass.sharedInstance.deviceToken, "ShareRide": SingletonClass.sharedInstance.isShareRide] as [String : Any]
        //        print("Update Location : \(myJSON)")
        socket.emit(SocketData.kUpdatePassengerLatLong , with: [myJSON])
        
    }
    
    func methodsAfterConnectingToSocket()
    {
        scheduledTimerWithTimeInterval()
    }
    
    
    func socketMethodForGettingBookingAcceptNotification()
    {
        // Socket Accepted
        self.socket.on(SocketData.kAcceptBookingRequestNotification, callback: { (data, ack) in
            print("AcceptBooking data is \(data)")
            
            self.locationManager.startUpdatingLocation()
            
            
            // TODO: Please uncomment

            if let getInfoFromData = data as? [[String:AnyObject]] {
                
                if let infoData = getInfoFromData[0] as? [String:AnyObject] {
                    if let bookingInfo = infoData["BookingInfo"] as? [[String:AnyObject]] {
                        var bookingIdIs = String()
                        if let nowBookingID: Int = (bookingInfo[0])["Id"] as? Int {
                            bookingIdIs = "\(nowBookingID)"
                        }
                        else if let nowBookingID: String = (bookingInfo[0])["Id"] as? String {
                            bookingIdIs = nowBookingID
                        }
                        print("bookingIdIs: \(bookingIdIs)")
                        
                        if let moreInfo = infoData["ModelInfo"] as? [[String:Any]] {
                            if moreInfo.count != 0 {
                                if let intCancellationFee = moreInfo[0]["CancellationFee"] as? Int {
                                    self.CancellationFee = "\(intCancellationFee)"
                                }
                                else if let strCancellationFee = moreInfo[0]["CancellationFee"] as? String {
                                    self.CancellationFee = strCancellationFee
                                }
                            }
                        }
                        
                        if SingletonClass.sharedInstance.bookingId != "" {
                            if SingletonClass.sharedInstance.bookingId == bookingIdIs {
                                self.DriverInfoAndSetToMap(driverData: NSArray(array: data))
                            }
                        }
                        else {
                            self.DriverInfoAndSetToMap(driverData: NSArray(array: data))
                        }
                    }
                    
                }
            }

        })
    }
    
    func DriverInfoAndSetToMap(driverData: NSArray) {
        
        if timerForEmitEstimateFare != nil {
            timerForEmitEstimateFare.invalidate()
        }
        
        //        DispatchQueue.global(qos: .utility).async {
        DispatchQueue.main.async {
            print(#function)
            self.setHideAndShowTopViewWhenRequestAcceptedAndTripStarted(status: true)

            //        SingletonClass.sharedInstance.isTripContinue = true
            self.btnDoneForLocationSelected.isHidden = true
            self.MarkerCurrntLocation.isHidden = true

            self.viewTripActions.isHidden = false
            // bhavesh change - self.ConstantViewCarListsHeight.constant = 0
            self.viewCarLists.isHidden = true
            //        self.viewShareRideView.isHidden = true

            self.viewActivity.stopAnimating()

            self.viewMainActivityIndicator.isHidden = true
            self.btnRequest.isHidden = false
            self.btnCancelStartedTrip.isHidden = true

            self.stackViewOfTruckBooking.isHidden = true
        }
        //        }
        
        
        //        self.view.layoutIfNeeded()
        
        self.aryRequestAcceptedData = NSArray(array: driverData)

        let bookingInfo : NSDictionary!
        let DriverInfo: NSDictionary!
        let carInfo: NSDictionary!
        
        if((((self.aryRequestAcceptedData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "DriverInfo") as? NSDictionary) == nil)
        {
            // print ("Yes its  array ")
            DriverInfo = (((self.aryRequestAcceptedData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "DriverInfo") as! NSArray).object(at: 0) as! NSDictionary
        }
        else {
            // print ("Yes its dictionary")
            DriverInfo = (((self.aryRequestAcceptedData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "DriverInfo") as! NSDictionary)
        }
        
        if((((self.aryRequestAcceptedData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as? NSDictionary) == nil)
        {
            // print ("Yes its  array ")
            bookingInfo = (((self.aryRequestAcceptedData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as! NSArray).object(at: 0) as! NSDictionary
        }
        else
        {
            // print ("Yes its dictionary")
            bookingInfo = (((self.aryRequestAcceptedData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as! NSDictionary) //.object(at: 0) as! NSDictionary
        }
        
        if((((self.aryRequestAcceptedData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "CarInfo") as? NSDictionary) == nil)
        {
            // print ("Yes its  array ")
            carInfo = (((self.aryRequestAcceptedData as NSArray).object(at: 0) as? NSDictionary)?.object(forKey: "CarInfo") as? NSArray)?.object(at: 0) as? NSDictionary
        }
        else
        {
            // print ("Yes its dictionary")
            carInfo = (((self.aryRequestAcceptedData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "CarInfo") as! NSDictionary) //.object(at: 0) as! NSDictionary
        }
        
        if let passengerType = bookingInfo.object(forKey: "PassengerType") as? String {
            
            if passengerType == "other" || passengerType == "others" {
                
                SingletonClass.sharedInstance.passengerTypeOther = true
            }
        }
        
        SingletonClass.sharedInstance.dictDriverProfile = DriverInfo
        SingletonClass.sharedInstance.dictCarInfo = (carInfo as? [String: AnyObject])!
        //        showDriverInfo(bookingInfo: bookingInfo, DriverInfo: DriverInfo, carInfo: carInfo)
        
        
        self.sendPassengerIDAndDriverIDToGetLocation(driverID: String(describing: DriverInfo.object(forKey: "Id")!) , passengerID: String(describing: bookingInfo.object(forKey: "PassengerId")!))
        
        
        self.BookingConfirmed(dictData: (driverData[0] as! NSDictionary) )
        
        let driverInfo = (((self.aryRequestAcceptedData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as! NSArray).object(at: 0) as! NSDictionary
        //        let details = (((self.aryRequestAcceptedData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "Details") as! NSArray).object(at: 0) as! NSDictionary
        
        if let bookID =  bookingInfo.object(forKey: SocketDataKeys.kBookingIdNow) as? String {
            SingletonClass.sharedInstance.bookingId = bookID
        }
        else if let bookID = bookingInfo.object(forKey: "Id") as? String {
            SingletonClass.sharedInstance.bookingId = bookID
        }
        else if let bookID = bookingInfo.object(forKey: "Id") as? Int {
            SingletonClass.sharedInstance.bookingId = "\(bookID)"
        }
        
        txtCurrentLocation.text = bookingInfo.object(forKey: "PickupLocation") as? String
        txtDestinationLocation.text = bookingInfo.object(forKey: "DropoffLocation") as? String
        
        
        //        let PickupLat = defaultLocation.coordinate.latitude
        //        let PickupLng =  defaultLocation.coordinate.longitude
        
        let PickupLat = bookingInfo.object(forKey: "PickupLat") as! String
        let PickupLng =  bookingInfo.object(forKey: "PickupLng") as! String
        
        //        let DropOffLat = driverInfo.object(forKey: "PickupLat") as! String
        //        let DropOffLon = driverInfo.object(forKey: "PickupLng") as! String
        
        let DropOffLat = DriverInfo.object(forKey: "Lat") as! String
        let DropOffLon = DriverInfo.object(forKey: "Lng") as! String
        
        
        let dummyLatitude = Double(PickupLat)! - Double(DropOffLat)!
        let dummyLongitude = Double(PickupLng)! - Double(DropOffLon)!
        
        let waypointLatitude = Double(PickupLat)! - dummyLatitude
        let waypointSetLongitude = Double(PickupLng)! - dummyLongitude
        
        let originalLoc: String = "\(PickupLat),\(PickupLng)"
        let destiantionLoc: String = "\(DropOffLat),\(DropOffLon)"
        
        strPickUpLatitude = PickupLat
        strPickUpLongitude = DropOffLon
        
        let camera = GMSCameraPosition.camera(withLatitude: Double(DropOffLat)!,
                                              longitude: Double(DropOffLon)!,
                                              zoom: 18)
        
        mapView.camera = camera
        
        self.getDirectionsAcceptRequest(origin: originalLoc, destination: destiantionLoc, waypoints: ["\(waypointLatitude),\(waypointSetLongitude)"], travelMode: nil) { (index, title) in
        }
        // TODO: uncomment if needed
        //        updatePolyLineToMapFromDriverLocation()
        
        NotificationCenter.default.post(name: NotificationForAddNewBooingOnSideMenu, object: nil)
        
    }
    
    func methodAfterStartTrip(tripData: NSArray) {
        
        //        DispatchQueue.global(qos: .utility).async {
        
        if self.timerForEmitEstimateFare != nil {
            self.timerForEmitEstimateFare.invalidate()
        }
        self.destinationCordinate = CLLocationCoordinate2D(latitude: self.dropoffLat, longitude: self.dropoffLng)

        DispatchQueue.main.async {

            print(#function)
            self.MarkerCurrntLocation.isHidden = true

            SingletonClass.sharedInstance.isTripContinue = true

            self.setHideAndShowTopViewWhenRequestAcceptedAndTripStarted(status: true)

            self.viewTripActions.isHidden = false
            // bhavesh change - self.ConstantViewCarListsHeight.constant = 0
            self.viewCarLists.isHidden = true
            //        self.viewShareRideView.isHidden = true

            self.viewActivity.stopAnimating()
            self.viewMainActivityIndicator.isHidden = true
            //            self.viewMainActivityIndicator.layoutIfNeeded()
            self.btnRequest.isHidden = true
            self.btnCancelStartedTrip.isHidden = true
            self.stackViewOfTruckBooking.isHidden = true

            self.view.subviews.map{$0.layoutIfNeeded()}

        }

        let bookingInfo : NSDictionary!
        let DriverInfo: NSDictionary!
        let carInfo: NSDictionary!

        if self.aryRequestAcceptedData.count != 0 {

            if((((self.aryRequestAcceptedData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "DriverInfo") as? NSDictionary) == nil)
            {
                // print ("Yes its  array ")
                DriverInfo = (((self.aryRequestAcceptedData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "DriverInfo") as! NSArray).object(at: 0) as! NSDictionary
            }
            else {
                // print ("Yes its dictionary")
                DriverInfo = (((self.aryRequestAcceptedData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "DriverInfo") as! NSDictionary)
            }

            if((((self.aryRequestAcceptedData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as? NSDictionary) == nil)
            {
                // print ("Yes its  array ")
                bookingInfo = (((self.aryRequestAcceptedData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as! NSArray).object(at: 0) as! NSDictionary
            }
            else
            {
                // print ("Yes its dictionary")
                bookingInfo = (((self.aryRequestAcceptedData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as! NSDictionary) //.object(at: 0) as! NSDictionary
            }

            if((((self.aryRequestAcceptedData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "CarInfo") as? NSDictionary) == nil)
            {
                // print ("Yes its  array ")
                carInfo = (((self.aryRequestAcceptedData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "CarInfo") as! NSArray).object(at: 0) as! NSDictionary
            }
            else
            {
                // print ("Yes its dictionary")
                carInfo = (((self.aryRequestAcceptedData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "CarInfo") as! NSDictionary) //.object(at: 0) as! NSDictionary
            }

            SingletonClass.sharedInstance.dictDriverProfile = DriverInfo
            SingletonClass.sharedInstance.dictCarInfo = carInfo as! [String: AnyObject]
            //        showDriverInfo(bookingInfo: bookingInfo, DriverInfo: DriverInfo, carInfo: carInfo)


            self.sendPassengerIDAndDriverIDToGetLocation(driverID: String(describing: DriverInfo.object(forKey: "Id")!) , passengerID: String(describing: bookingInfo.object(forKey: "PassengerId")!))

            // ------------------------------------------------------------
            let DropOffLat = bookingInfo.object(forKey: "DropOffLat") as! String
            let DropOffLon = bookingInfo.object(forKey: "DropOffLon") as! String

            let picklat = bookingInfo.object(forKey: "PickupLat") as! String
            let picklng = bookingInfo.object(forKey: "PickupLng") as! String

            self.dropoffLat = Double(DropOffLat)!
            self.dropoffLng = Double(DropOffLon)!

            self.txtDestinationLocation.text = bookingInfo.object(forKey: "DropoffLocation") as? String
            self.txtCurrentLocation.text = bookingInfo.object(forKey: "PickupLocation") as? String

            let PickupLat = self.defaultLocation.coordinate.latitude
            let PickupLng = self.defaultLocation.coordinate.longitude

            //        let PickupLat = Double(picklat)
            //        let PickupLng = Double(picklng)


            let dummyLatitude = Double(PickupLat) - Double(DropOffLat)!
            let dummyLongitude = Double(PickupLng) - Double(DropOffLon)!

            let waypointLatitude = self.defaultLocation.coordinate.latitude - dummyLatitude
            let waypointSetLongitude = self.defaultLocation.coordinate.longitude - dummyLongitude


            let originalLoc: String = "\(PickupLat),\(PickupLng)"
            let destiantionLoc: String = "\(DropOffLat),\(DropOffLon)"

            let bounds = GMSCoordinateBounds(coordinate: CLLocationCoordinate2D(latitude: Double(picklat)!, longitude: Double(picklng)!), coordinate: CLLocationCoordinate2D(latitude: Double(DropOffLat)!, longitude: Double(DropOffLon)!))

            let update = GMSCameraUpdate.fit(bounds, withPadding: CGFloat(100))

            self.mapView.animate(with: update)

            self.mapView.moveCamera(update)

            self.getDirectionsSeconMethod(origin: originalLoc, destination: destiantionLoc, waypoints: ["\(waypointLatitude),\(waypointSetLongitude)"], travelMode: nil, completionHandler: nil)

            NotificationCenter.default.post(name: NotificationForAddNewBooingOnSideMenu, object: nil)
        }

        //        }

        
    }
    
    //MARK:- Show Driver Information
    
    func showDriverInfo(bookingInfo : NSDictionary, DriverInfo: NSDictionary, carInfo : NSDictionary) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "DriverInfoViewController") as! DriverInfoViewController
        
        next.strDriverName = DriverInfo.object(forKey: "Fullname") as! String
        next.strPickupLocation = "Pickup Location : \(bookingInfo.object(forKey: "PickupLocation") as! String)"
        next.strDropoffLocation = "Dropoff Location : \(bookingInfo.object(forKey: "DropoffLocation") as! String)"
        if let carClass = carInfo.object(forKey: "Model") as? NSDictionary {
            next.strCarClass = carClass.object(forKey: "Name") as! String // String(describing: carInfo.object(forKey: "VehicleModel")!)
        }
        else {
            next.strCarClass = String(describing: carInfo.object(forKey: "VehicleModel")!)
        }
        
        if let carPlateNumber = carInfo.object(forKey: "VehicleRegistrationNo") as? String {
            next.strCarPlateNumber = carPlateNumber
        }
        
        next.strCareName = carInfo.object(forKey: "Company") as! String
        next.strDriverImage = WebserviceURLs.kImageBaseURL + (DriverInfo.object(forKey: "Image") as! String)
        next.strCarImage = WebserviceURLs.kImageBaseURL + (carInfo.object(forKey: "VehicleImage") as! String)
        
        //        if (SingletonClass.sharedInstance.passengerTypeOther) {
        //            next.strPassengerMobileNumber = bookingInfo.object(forKey: "PassengerContact") as! String
        //        }
        //        else {
        next.strPassengerMobileNumber = DriverInfo.object(forKey: "MobileNo") as! String
        //        }
        
        
        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(next, animated: true, completion: nil)
    }
    
    
    func socketMethodForGettingBookingRejectNotification()
    {
        // Socket Accepted
        self.socket.on(SocketData.kRejectBookingRequestNotification, callback: { (data, ack) in
            print("socketMethodForGettingBookingRejectNotification() is \(data)")
            
            
            var bookingId = String()
            
            if let bookingInfoData = (data as! [[String:AnyObject]])[0] as? [String:AnyObject] {
                if let bookingInfo = bookingInfoData["BookingId"] as? Int {
                    bookingId = "\(bookingInfo)"
                }
                else if let bookingInfo = bookingInfoData["BookingId"] as? String {
                    bookingId = bookingInfo
                }
                
                if SingletonClass.sharedInstance.bookingId != "" {
                    if SingletonClass.sharedInstance.bookingId == bookingId {
                        self.viewActivity.stopAnimating()
                        self.viewMainActivityIndicator.isHidden = true
                        UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0]["message"]! as! String, completionHandler: { (index, title) in
                            
                        })
                    }
                }
                else {
                    self.viewActivity.stopAnimating()
                    self.viewMainActivityIndicator.isHidden = true
                    UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0]["message"]! as! String, completionHandler: { (index, title) in
                        
                    })
                }
            }
            
            //            self.viewActivity.stopAnimating()
            //            self.viewMainActivityIndicator.isHidden = true
            //            UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0]["message"]! as! String, completionHandler: { (index, title) in
            //
            //            })
            
            /*
             [{
             BookingId = 7623;
             message = "Your Booking request has been canceled";
             type = BookingRequest;
             }]
             */
            
            
        })
    }
    
    
    
    func socketMethodForGettingBookingRejectNotificatioByDriver()
    {
        // Socket Accepted
        self.socket.on(SocketData.kCancelTripByDriverNotficication, callback: { (data, ack) in
            print("socketMethodForGettingBookingRejectNotificatioByDriver() is \(data)")
            
            self.CancellationFee = ""
            var bookingId = String()
            
            if let bookingInfoData = (data as! [[String:AnyObject]])[0]["BookingInfo"] as? [[String:AnyObject]] {
                if let bookingInfo = bookingInfoData[0]["Id"] as? Int {
                    bookingId = "\(bookingInfo)"
                }
                else if let bookingInfo = bookingInfoData[0]["Id"] as? String {
                    bookingId = bookingInfo
                }
                
                if SingletonClass.sharedInstance.bookingId != "" {
                    if SingletonClass.sharedInstance.bookingId == bookingId {
                        self.viewActivity.stopAnimating()
                        self.viewMainActivityIndicator.isHidden = true
                        self.currentLocationAction()
                        self.getPlaceFromLatLong()
                        self.clearDataAfteCompleteTrip()
                        self.currentLocationAction()
                        self.setHideAndShowTopViewWhenRequestAcceptedAndTripStarted(status: false)
                        
                        self.viewTripActions.isHidden = true
                        SingletonClass.sharedInstance.passengerTypeOther = false
                        self.setHideAndShowTopViewWhenRequestAcceptedAndTripStarted(status: false)
                        UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0]["message"]! as! String, completionHandler: { (index, title) in
                            
                        })
                    }
                } else {
                    self.viewActivity.stopAnimating()
                    self.viewMainActivityIndicator.isHidden = true
                    self.currentLocationAction()
                    self.getPlaceFromLatLong()
                    self.clearDataAfteCompleteTrip()
                    self.currentLocationAction()
                    self.setHideAndShowTopViewWhenRequestAcceptedAndTripStarted(status: false)
                    
                    self.viewTripActions.isHidden = true
                    SingletonClass.sharedInstance.passengerTypeOther = false
                    self.setHideAndShowTopViewWhenRequestAcceptedAndTripStarted(status: false)
                    UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0]["message"]! as! String, completionHandler: { (index, title) in
                        
                    })
                }
            }
        })
    }
    
    func socketMethodForGettingPickUpNotification()
    {
        self.socket.on(SocketData.kPickupPassengerNotification, callback: { (data, ack) in
            print("socketMethodForGettingPickUpNotification() is \(data)")
            //            self.stopTimer()
            /*
             [{
             BookingId = 7625;
             DriverId = 70;
             message = "Your trip has now started.";
             }]
             */
            var bookingIdIs = String()
            
            if let bookingData = data as? [[String:AnyObject]] {
                if let id = bookingData[0]["BookingId"] as? String {
                    bookingIdIs = id
                }
                else if let id = bookingData[0]["BookingId"] as? Int {
                    bookingIdIs = "\(id)"
                }
                
                if SingletonClass.sharedInstance.bookingId != "" {
                    if SingletonClass.sharedInstance.bookingId == bookingIdIs {
                        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                        UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0]["message"]! as! String, completionHandler: { (index, title) in
                            self.viewMainActivityIndicator.isHidden = true
                        })
                        
                        self.btnRequest.isHidden = true
                        self.btnCancelStartedTrip.isHidden = true
                        
                        self.methodAfterStartTrip(tripData: NSArray(array: data))
                    }
                }
                else {
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                    UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0]["message"]! as! String, completionHandler: { (index, title) in
                        self.viewMainActivityIndicator.isHidden = true
                    })
                    
                    self.btnRequest.isHidden = true
                    self.btnCancelStartedTrip.isHidden = true
                    
                    self.methodAfterStartTrip(tripData: NSArray(array: data))
                }
                
            }
            
            
            //            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            //            UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0]["message"]! as! String, completionHandler: { (index, title) in
            //
            //            })
            //
            //            self.btnRequest.isHidden = true
            //            self.btnCancelStartedTrip.isHidden = true
            //
            //            self.methodAfterStartTrip(tripData: NSArray(array: data))
            
        })
    }
    
    func socketMethodForGettingTripCompletedNotification()
    {
        self.socket.on(SocketData.kBookingCompletedNotification, callback: { (data, ack) in
            print("socketMethodForGettingTripCompletedNotification() is \(data)")
            
            SingletonClass.sharedInstance.isTripContinue = false
            self.aryCompleterTripData = data
            
            if let getInfoFromData = data as? [[String:AnyObject]] {
                
                if let infoData = getInfoFromData[0] as? [String:AnyObject] {
                    if let bookingInfo = infoData["Info"] as? [[String:AnyObject]] {
                        var bookingIdIs = String()
                        if let nowBookingID: Int = (bookingInfo[0])["Id"] as? Int {
                            bookingIdIs = "\(nowBookingID)"
                        }
                        else if let nowBookingID: String = (bookingInfo[0])["Id"] as? String {
                            bookingIdIs = nowBookingID
                        }
                        print("bookingIdIs: \(bookingIdIs)")
                        
                        if SingletonClass.sharedInstance.bookingId != "" {
                            if SingletonClass.sharedInstance.bookingId == bookingIdIs {
                                if (SingletonClass.sharedInstance.passengerTypeOther) {
                                    
                                    SingletonClass.sharedInstance.passengerTypeOther = false
                                    self.completeTripInfo()
                                }
                                else {
                                    self.completeTripInfo()
                                    //                self.performSegue(withIdentifier: "showRating", sender: nil)
                                }
                            }
                        }
                    }
                }
            }
            
            /*
             
             let bookingId = ((((data as! [[String:AnyObject]])[0] as! [String:AnyObject])["Info"] as! [[String:AnyObject]])[0] as! [String:AnyObject])["Id"]
             
             //            self.viewMainFinalRating.isHidden = false
             
             if (SingletonClass.sharedInstance.passengerTypeOther) {
             
             SingletonClass.sharedInstance.passengerTypeOther = false
             self.completeTripInfo()
             }
             else {
             
             self.completeTripInfo()
             //                self.performSegue(withIdentifier: "showRating", sender: nil)
             }
             
             //            let next = self.storyboard?.instantiateViewController(withIdentifier: "GiveRatingViewController") as! GiveRatingViewController
             //            next.strBookingType = self.strBookingType
             //            next.delegate = self
             //            next.modalPresentationStyle = .overCurrentContext
             //            self.present(next, animated: true, completion: nil)
             */
            
        })
    }
    
    
    func completeTripInfo() {
        
        timer.invalidate()
        
        clearMap()
        self.stopTimer()
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        self.scheduledTimerWithTimeInterval()
        UtilityClass.showAlertWithCompletion("Your trip has been completed", message: "", vc: self, completionHandler: { (status) in
            
            if (status == true)
            {
                print(#function)
                self.setHideAndShowTopViewWhenRequestAcceptedAndTripStarted(status: false)
                
                self.dismiss(animated: true, completion: nil)
                //                    self.socket.off(SocketData.kBookingCompletedNotification)
                self.arrDataAfterCompletetionOfTrip = NSMutableArray(array: (self.aryCompleterTripData[0] as! NSDictionary).object(forKey: "Info") as! NSArray)
                
                self.viewTripActions.isHidden = true
                self.viewCarLists.isHidden = false
                //                self.viewShareRideView.isHidden = false
                // bhavesh change - self.ConstantViewCarListsHeight.constant = 170 // 150
                //                    self.constraintTopSpaceViewDriverInfo.constant = 170
                self.viewMainFinalRating.isHidden = true
                SingletonClass.sharedInstance.passengerTypeOther = false
                self.currentLocationAction()
                self.getPlaceFromLatLong()
                
                self.getRaringNotification()
                
                self.clearDataAfteCompleteTrip()
                
                self.performSegue(withIdentifier: "seguePresentTripDetails", sender: nil)
                
                
                
                //                if (SingletonClass.sharedInstance.passengerTypeOther) {
                //                }
                //                else {
                //
                //                    self.openRatingView()
                //                }
                
                
            }
        })
        
    }
    
    func clearSetupMapForNewBooking() {
        
        self.setHideAndShowTopViewWhenRequestAcceptedAndTripStarted(status: false)
        clearMap()
        self.currentLocationAction()
        self.viewTripActions.isHidden = true
        //        self.viewCarLists.isHidden = false
        //        self.ConstantViewCarListsHeight.constant = 150
        clearDataAfteCompleteTrip()
    }
    
    func clearDataAfteCompleteTrip() {
        
        self.MarkerCurrntLocation.isHidden = false
        selectedIndexPath = nil
        self.collectionViewCars.reloadData()
        self.txtCurrentLocation.text = ""
        self.txtDestinationLocation.text = ""
        self.dropoffLat = 0
        self.doublePickupLng = 0
        
        //        SingletonClass.sharedInstance.strPassengerID = ""
        
        self.strModelId = ""
        self.strPickupLocation = ""
        self.strDropoffLocation = ""
        self.doublePickupLat = 0
        self.doublePickupLng = 0
        self.doubleDropOffLat = 0
        self.doubleDropOffLng = 0
        self.strModelId = ""
        self.txtNote.text = ""
        self.txtFeedbackFinal.text = ""
        self.txtHavePromocode.text = ""
        self.txtSelectPaymentOption.text = ""
        SingletonClass.sharedInstance.isTripContinue = false
        
        
        
    }
    
    func getRaringNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.openRatingView), name: Notification.Name("CallToRating"), object: nil)
    }
    
    @objc func openRatingView() {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "GiveRatingViewController") as! GiveRatingViewController
        next.strBookingType = self.strBookingType
        //        next.delegate = self
        //            self.presentingViewController?.modalPresentationStyle
        self.present(next, animated: true, completion: nil)
    }
    
    func socketMethodForCancelRequestTrip()
    {
        
        let myJSON = [SocketDataKeys.kBookingIdNow : SingletonClass.sharedInstance.bookingId] as [String : Any]
        socket.emit(SocketData.kCancelTripByPassenger , with: [myJSON])
        print("CancelTripByPassenger")
        stopTimer()
        self.setHideAndShowTopViewWhenRequestAcceptedAndTripStarted(status: false)
        self.viewCarLists.isHidden = true
        //        self.viewShareRideView.isHidden = true
        CancellationFee = ""
        
    }
    // ------------------------------------------------------------
    
    func onAcceptBookLaterBookingRequestNotification() {
        
        self.socket.on(SocketData.kAcceptAdvancedBookingRequestNotification, callback: { (data, ack) in
            print("onAcceptBookLaterBookingRequestNotification() is \(data)")
            
            //            self.playSound(fileName: "RequestConfirm", extensionType: "mp3")
            
            //            UtilityClass.showAlertWithCompletion("", message: "Your request has been Accepted.", vc: self, completionHandler: { ACTION in
            //
            //                self.stopSound(fileName: "RequestConfirm", extensionType: "mp3")
            //            })
            
            var bookingId = String()
            
            if let bookingInfoData = (data as! [[String:AnyObject]])[0]["BookingInfo"] as? [[String:AnyObject]] {
                if let bookingInfo = bookingInfoData[0]["Id"] as? Int {
                    bookingId = "\(bookingInfo)"
                }
                else if let bookingInfo = bookingInfoData[0]["Id"] as? String {
                    bookingId = bookingInfo
                }
                
                if SingletonClass.sharedInstance.bookingId != "" {
                    if SingletonClass.sharedInstance.bookingId == bookingId {
                        
                        UtilityClass.setCustomAlert(title: "\(appName)", message: "Your request has been Accepted.") { (index, title) in
                            //               self.stopSound(fileName: "RequestConfirm", extensionType: "mp3")
                        }
                        self.strBookingType = "BookLater"
                        self.DriverInfoAndSetToMap(driverData: NSArray(array: data))
                    }
                }
                else {
                    UtilityClass.setCustomAlert(title: "\(appName)", message: "Your request has been Accepted.") { (index, title) in
                        //               self.stopSound(fileName: "RequestConfirm", extensionType: "mp3")
                    }
                    self.strBookingType = "BookLater"
                    self.DriverInfoAndSetToMap(driverData: NSArray(array: data))
                }
            }
            
            if let moreInfo = (data as! [[String:Any]])[0]["ModelInfo"] as? [[String:Any]] {
                if moreInfo.count != 0 {
                    if let intCancellationFee = moreInfo[0]["CancellationFee"] as? Int {
                        self.CancellationFee = "\(intCancellationFee)"
                    }
                    else if let strCancellationFee = moreInfo[0]["CancellationFee"] as? String {
                        self.CancellationFee = strCancellationFee
                    }
                }
            }
        })
    }
    
    func onRejectBookLaterBookingRequestNotification() {
        
        self.socket.on(SocketData.kRejectAdvancedBookingRequestNotification, callback: { (data, ack) in
            print("onRejectBookLaterBookingRequestNotification() is \(data)")
            
            //            self.playSound(fileName: "PickNGo", extensionType: "mp3")
            
            let alert = UIAlertController(title: nil, message: "Your request has been rejected.", preferredStyle: .alert)
            let OK = UIAlertAction(title: "OK", style: .default, handler: { (ACTION) in
                //                self.stopSound(fileName: "PickNGo", extensionType: "mp3")
            })
            alert.addAction(OK)
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
            
        })
    }
    
    func onPickupPassengerByDriverInBookLaterRequestNotification() {
        
        self.socket.on(SocketData.kAdvancedBookingPickupPassengerNotification, callback: { (data, ack) in
            print("onPickupPassengerByDriverInBookLaterRequestNotification() is \(data)")
            
            var bookingId = String()
            
            if let bookingInfoData = (data as! [[String:AnyObject]])[0]["BookingInfo"] as? [[String:AnyObject]] {
                if let bookingInfo = bookingInfoData[0]["Id"] as? Int {
                    bookingId = "\(bookingInfo)"
                }
                else if let bookingInfo = bookingInfoData[0]["Id"] as? String {
                    bookingId = bookingInfo
                }
                
                if SingletonClass.sharedInstance.bookingId != "" {
                    
                    if SingletonClass.sharedInstance.bookingId == bookingId {
                        self.strBookingType = "BookLater"
                        let alert = UIAlertController(title: nil, message: "Your trip has now started.", preferredStyle: .alert)
                        let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(OK)
                        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
                        
                        self.btnRequest.isHidden = true
                        self.btnCancelStartedTrip.isHidden = true
                        //            SingletonClass.sharedInstance.isTripContinue = true
                        self.methodAfterStartTrip(tripData: NSArray(array: data))
                        
                    }
                }
                else {
                    self.strBookingType = "BookLater"
                    let alert = UIAlertController(title: nil, message: "Your trip has now started.", preferredStyle: .alert)
                    let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(OK)
                    (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
                    
                    self.btnRequest.isHidden = true
                    self.btnCancelStartedTrip.isHidden = true
                    //            SingletonClass.sharedInstance.isTripContinue = true
                    self.methodAfterStartTrip(tripData: NSArray(array: data))
                }
            }
            
        })
    }
    
    func onTripHoldingNotificationForPassenger() {
        
        self.socket.on(SocketData.kReceiveHoldingNotificationToPassenger, callback: { (data, ack) in
            print("onTripHoldingNotificationForPassenger() is \(data)")
            
            var message = String()
            message = "Trip on Hold"
            
            if let resAry = NSArray(array: data) as? NSArray {
                message = (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String
                //                UtilityClass.showAlert("", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
            }
            
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(OK)
            
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
            
        })
    }
    
    func onTripHoldingNotificationForPassengerLater() {
        
        self.socket.on(SocketData.kAdvancedBookingTripHoldNotification, callback: { (data, ack) in
            print("onTripHoldingNotificationForPassengerLater() is \(data)")
            
            var message = String()
            message = "Trip on Hold"
            
            if let resAry = NSArray(array: data) as? NSArray {
                message = (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String
                //                UtilityClass.showAlert("", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
            }
            
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(OK)
            
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
            
            
        })
    }
    
    func onReceiveDriverLocationToPassenger() {
        
        self.socket.on(SocketData.kReceiveDriverLocationToPassenger, callback: { (data, ack) in
            print("onReceiveDriverLocationToPassenger() is \(data)")
            
            SingletonClass.sharedInstance.driverLocation = (data as NSArray).object(at: 0) as! [String : AnyObject]
            
            var DoubleLat = Double()
            var DoubleLng = Double()
            
            if let lat = SingletonClass.sharedInstance.driverLocation["Location"]! as? [Double] {
                DoubleLat = lat[0]
                DoubleLng = lat[1]
            }
            else if let lat = SingletonClass.sharedInstance.driverLocation["Location"]! as? [String] {
                DoubleLat = Double(lat[0])!
                DoubleLng = Double(lat[1])!
            }
            
            var DriverCordinate = CLLocationCoordinate2D(latitude: DoubleLat , longitude: DoubleLng)
            
            
            //            var DriverCordinate = CLLocationCoordinate2D(latitude: Double("23.076701577176262")! , longitude: Double("72.51612203357585")!)
            
            DriverCordinate = CLLocationCoordinate2DMake(DriverCordinate.latitude, DriverCordinate.longitude)
            
            if(self.destinationCordinate == nil)
            {
                self.destinationCordinate = CLLocationCoordinate2DMake(DriverCordinate.latitude, DriverCordinate.longitude)
            }
            
            if self.driverMarker == nil {
                
                self.driverMarker = GMSMarker(position: DriverCordinate) // self.originCoordinate
                
                self.driverMarker.map = self.mapView
                var vehicleID = Int()
                if let vID = SingletonClass.sharedInstance.dictCarInfo["VehicleModel"] as? Int {
                    
                    if vID == 0 {
                        vehicleID = 7
                    }
                    else {
                        vehicleID = vID
                    }
                }
                else if let sID = SingletonClass.sharedInstance.dictCarInfo["VehicleModel"] as? String
                {
                    
                    if sID == "" {
                        vehicleID = 7
                    }
                    else {
                        vehicleID = Int(sID)!
                    }
                }
                
                self.driverMarker.icon = UIImage(named: self.markerCarIconName(modelId: vehicleID))
            }
            //            self.moveMent.ARCarMovement(marker: self.driverMarker, oldCoordinate: self.destinationCordinate, newCoordinate: DriverCordinate, mapView: self.mapView, bearing: Float(SingletonClass.sharedInstance.floatBearing))
            
            let newCordinate = DriverCordinate
            
            self.driverMarker.position = DriverCordinate// = GMSMarker(position: DriverCordinate) // self.originCoordinate
            self.driverMarker.map = self.mapView
            var vehicleID = Int()
            if let vID = SingletonClass.sharedInstance.dictCarInfo["VehicleModel"] as? Int {
                
                if vID == 0 {
                    vehicleID = 7
                }
                else {
                    vehicleID = vID
                }
            }
            else if let sID = SingletonClass.sharedInstance.dictCarInfo["VehicleModel"] as? String
            {
                
                if sID == "" {
                    vehicleID = 7
                }
                else {
                    vehicleID = Int(sID)!
                }
            }
            self.driverMarker.icon = UIImage(named: self.markerCarIconName(modelId: vehicleID))
            
            self.destinationCordinate = DriverCordinate
            self.MarkerCurrntLocation.isHidden = true
            // ----------------------------------------------------------------------
            
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.5)
            CATransaction.setValue(Int(2.0), forKey: kCATransactionAnimationDuration)
            CATransaction.setCompletionBlock({() -> Void in
                
                if self.driverMarker != nil {
                    self.driverMarker.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
                }
                
                
                //New bearing value from backend after car movement is done
            })
            
            UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: {
                if self.driverMarker != nil {
                    self.driverMarker.position = newCordinate
                    self.driverMarker.map = self.mapView
                }
                
                
                // TODO: Uncomment if neeeded
                //                self.updatePolyLineToMapFromDriverLocation()
            })
            
            CATransaction.commit()
            // ----------------------------------------------------------------------
            
            
        })
        
        
    }
    
    var driverIDTimer : String!
    var passengerIDTimer : String!
    func sendPassengerIDAndDriverIDToGetLocation(driverID : String , passengerID: String) {
        
        
        driverIDTimer = driverID
        passengerIDTimer = passengerID
        if timerToGetDriverLocation == nil {
            timerToGetDriverLocation = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(HomeViewController.getDriverLocation), userInfo: nil, repeats: true)
        }
        
    }
    
    func stopTimer() {
        if timerToGetDriverLocation != nil {
            timerToGetDriverLocation.invalidate()
            timerToGetDriverLocation = nil
        }
    }
    
    @objc func getDriverLocation()
    {
        let pID: String = passengerIDTimer
        let dID: String = driverIDTimer
        
        let myJSON = ["PassengerId" : pID,  "DriverId" : dID] as [String : Any]
        socket.emit(SocketData.kSendDriverLocationRequestByPassenger , with: [myJSON])
        print("SendDriverLocationRequestByPassenger: \(myJSON)")
    }
    
    
    func postPickupAndDropLocationForEstimateFare()
    {
        let driverID = aryOfOnlineCarsIds.compactMap{ $0 }.joined(separator: ",")
        
        //        if driverID != "" {
        let myJSON = ["PassengerId" : SingletonClass.sharedInstance.strPassengerID,
                      "PickupLocation" : strPickupLocation ,
                      "PickupLat" :  self.doublePickupLat ,
                      "PickupLong" :  self.doublePickupLng,
                      "DropoffLocation" : strDropoffLocation,
                      "DropoffLat" : self.doubleDropOffLat,
                      "DropoffLon" : self.doubleDropOffLng,
                      "Ids" : driverID,
                      "ShareRiding": intShareRide ] as [String : Any]


        //        if(strDropoffLocation.count == 0)
        //        {
        //            myJSON = ["PassengerId" : SingletonClass.sharedInstance.strPassengerID,
        //                      "PickupLocation" : strPickupLocation ,
        //                      "PickupLat" :  self.doublePickupLat ,
        //                      "PickupLong" :  self.doublePickupLng,
        //                      "DropoffLocation" : strPickupLocation,
        //                      "DropoffLat" : self.doubleDropOffLat,
        //                      "DropoffLon" : self.doubleDropOffLng,
        //                      "Ids" : driverID,
        //                      "ShareRiding": intShareRide] as [String : Any]
        //        }

        socket.emit(SocketData.kSendRequestForGetEstimateFare , with: [myJSON])

        print("EstimateFare : \(myJSON)")
        //        }
        
    }
    
    func onBookingDetailsAfterCompletedTrip() {
        
        self.socket.on(SocketData.kAdvancedBookingDetails, callback: { (data, ack) in
            print("onBookingDetailsAfterCompletedTrip() is \(data)")
            
            SingletonClass.sharedInstance.isTripContinue = false
            
            self.aryCompleterTripData = data
            
            //            self.viewMainFinalRating.isHidden = false
            
            var bookingId = String()
            if let bookingData = data as? [[String:AnyObject]] {
                
                if let info = bookingData[0]["Info"] as? [[String:AnyObject]] {
                    
                    if let infoId = info[0]["Id"] as? String {
                        bookingId = infoId
                    }
                    else if let infoId = info[0]["Id"] as? Int {
                        bookingId = "\(infoId)"
                    }
                    
                    if SingletonClass.sharedInstance.bookingId != "" {
                        if SingletonClass.sharedInstance.bookingId == bookingId {
                            
                            if (SingletonClass.sharedInstance.passengerTypeOther) {
                                
                                SingletonClass.sharedInstance.passengerTypeOther = false
                                self.completeTripInfo()
                            }
                            else {
                                self.completeTripInfo()
                                //                let next = self.storyboard?.instantiateViewController(withIdentifier: "GiveRatingViewController") as! GiveRatingViewController
                                //                next.strBookingType = self.strBookingType
                                //                next.delegate = self
                                //                //            self.presentingViewController?.modalPresentationStyle
                                //                self.present(next, animated: true, completion: nil)
                            }
                        }
                    }
                    
                }
                
            }
        })
    }
    
    func CancelBookLaterTripAfterDriverAcceptRequest() {
        
        let myJSON = [SocketDataKeys.kBookingIdNow : SingletonClass.sharedInstance.bookingId] as [String : Any]
        socket.emit(SocketData.kAdvancedBookingCancelTripByPassenger , with: [myJSON])
        
        self.setHideAndShowTopViewWhenRequestAcceptedAndTripStarted(status: false)
        
        clearDataAfteCompleteTrip()
        
    }
    
    func onAdvanceTripInfoBeforeStartTrip() {
        
        self.socket.on(SocketData.kInformPassengerForAdvancedTrip, callback: { (data, ack) in
            print("onAdvanceTripInfoBeforeStartTrip() is \(data)")
            
            var message = String()
            message = "Trip on Hold"
            
            if let resAry = NSArray(array: data) as? NSArray {
                message = (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String
                
            }
            
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(OK)
            
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
            
        })
        
    }
    
    func onReceiveNotificationWhenDriverAcceptRequest() {
        
        self.socket.on(SocketData.kAcceptAdvancedBookingRequestNotify, callback: { (data, ack) in
            print("onReceiveNotificationWhenDriverAcceptRequest is \(data)")
            
            var bookingId = String()
            
            if let bookingInfoData = (data as! [[String:AnyObject]])[0]["BookingInfo"] as? [[String:AnyObject]] {
                if let bookingInfo = bookingInfoData[0]["Id"] as? Int {
                    bookingId = "\(bookingInfo)"
                }
                else if let bookingInfo = bookingInfoData[0]["Id"] as? String {
                    bookingId = bookingInfo
                }
                
                if SingletonClass.sharedInstance.bookingId != "" {
                    
                    if SingletonClass.sharedInstance.bookingId == bookingId {
                        var message = String()
                        message = "Trip on Hold"
                        
                        if let resAry = NSArray(array: data) as? NSArray {
                            message = (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String
                        }
                        
                        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                        let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(OK)
                        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
                    }
                }
                else {
                    var message = String()
                    message = "Trip on Hold"
                    
                    if let resAry = NSArray(array: data) as? NSArray {
                        message = (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String
                    }
                    
                    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                    let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(OK)
                    (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
                }
            }
            
        })
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Auto Suggession on Google Map
    //-------------------------------------------------------------
    
    var BoolCurrentLocation = Bool()
    
    
    @IBAction func txtDestinationLocation(_ sender: UITextField) {
        
        let visibleRegion = mapView.projection.visibleRegion()
        let bounds = GMSCoordinateBounds(coordinate: visibleRegion.farLeft, coordinate: visibleRegion.nearRight)
        
        setNavigationFontBlack()
        
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        acController.autocompleteBounds = bounds
        
        BoolCurrentLocation = false
        
        present(acController, animated: true, completion: nil)
        
    }
    
    @IBAction func txtCurrentLocation(_ sender: UITextField) {
        
        
        let visibleRegion = mapView.projection.visibleRegion()
        let bounds = GMSCoordinateBounds(coordinate: visibleRegion.farLeft, coordinate: visibleRegion.nearRight)
        
        setNavigationFontBlack()
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        acController.autocompleteBounds = bounds
        
        BoolCurrentLocation = true
        
        
        acController.navigationController?.navigationBar.backgroundColor = themeYellowColor
        //        acController.navigationController?.navigationItem.
        present(acController, animated: true, completion: nil)
    }
    
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        self.MarkerCurrntLocation.isHidden = false
        
        
        if BoolCurrentLocation {
            
            self.strLocationType = currentLocationMarkerText
            // bhavesh change - self.ConstantViewCarListsHeight.constant = 0
            self.viewCarLists.isHidden = true
            //            self.viewShareRideView.isHidden = true
            
            txtCurrentLocation.text = place.name + " " + place.formattedAddress! // place.formattedAddress
            strPickupLocation = place.name + " " + place.formattedAddress! // place.formattedAddress!
            doublePickupLat = place.coordinate.latitude
            doublePickupLng = place.coordinate.longitude
            
            currentLocationMarker.map = nil
            
            _ = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
            
            let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude,longitude: place.coordinate.longitude, zoom: 17.5)
            self.mapView.camera = camera
            mapView.animate(to: camera)
            
        }
        else {
            
            strLocationType = destinationLocationMarkerText
            self.strLocationType = destinationLocationMarkerText
            // bhavesh change - self.ConstantViewCarListsHeight.constant = 0
            self.viewCarLists.isHidden = true
            //            self.viewShareRideView.isHidden = true
            
            txtDestinationLocation.text = place.name + " " + place.formattedAddress! // place.formattedAddress
            strDropoffLocation = place.name + " " + place.formattedAddress! // place.formattedAddress!
            doubleDropOffLat = place.coordinate.latitude
            doubleDropOffLng = place.coordinate.longitude
            
            destinationLocationMarker.map = nil
            
            _ = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
            
            
            let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude,longitude: place.coordinate.longitude, zoom: 17.5)
            self.mapView.camera = camera
            mapView.animate(to: camera)
            
        }
        
        if txtCurrentLocation.text!.count != 0 && txtDestinationLocation.text!.count != 0 && aryOfOnlineCarsIds.count != 0 {
            postPickupAndDropLocationForEstimateFare()
        }
        
        if stackViewOfTruckBooking.isHidden == true {
            self.btnDoneForLocationSelected.isHidden = false
        }
        
        setNavigationClear() 
        dismiss(animated: true, completion: nil)
    }
    
    func setupBothCurrentAndDestinationMarkerAndPolylineOnMap() {
        
        if  txtCurrentLocation.text != "" && txtDestinationLocation.text != "" {
            
            MarkerCurrntLocation.isHidden = true
            
            var PickupLat = doublePickupLat
            var PickupLng = doublePickupLng
            
            if(SingletonClass.sharedInstance.isTripContinue)
            {
                PickupLat = doubleUpdateNewLat
                PickupLng = doubleUpdateNewLng
            }
            
            
            let DropOffLat = doubleDropOffLat
            let DropOffLon = doubleDropOffLng
            
            let dummyLatitude = Double(PickupLat) - Double(DropOffLat)
            let dummyLongitude = Double(PickupLng) - Double(DropOffLon)
            
            let waypointLatitude = Double(PickupLat) - dummyLatitude
            let waypointSetLongitude = Double(PickupLng) - dummyLongitude
            
            let originalLoc: String = "\(PickupLat),\(PickupLng)"
            let destiantionLoc: String = "\(DropOffLat),\(DropOffLon)"
            
            
            let bounds = GMSCoordinateBounds(coordinate: CLLocationCoordinate2D(latitude: PickupLat, longitude: PickupLng), coordinate: CLLocationCoordinate2D(latitude: DropOffLat, longitude: DropOffLon))
            
            let update = GMSCameraUpdate.fit(bounds, withPadding: CGFloat(100))
            
            self.mapView.animate(with: update)
            
            self.mapView.moveCamera(update)
            
            setDirectionLineOnMapForSourceAndDestinationShow(origin: originalLoc, destination: destiantionLoc, waypoints: ["\(waypointLatitude),\(waypointSetLongitude)"], travelMode: nil, completionHandler: nil)
            
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        //print("Error: \(error)")
        setNavigationClear()
        dismiss(animated: true, completion: nil)
    }
    
    // User cancelled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        //print("Autocomplete was cancelled.")
        setNavigationClear()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnClearPickupLocation(_ sender: UIButton) {
        //        txtCurrentLocation.text = ""
        clearMap()
        clearCurrentLocation()
    }
    
    @IBAction func btnClearDropOffLocation(_ sender: UIButton) {
        //        txtDestinationLocation.text = ""
        clearMap()
        clearDestinationLocation()
    }
    
    func clearCurrentLocation() {
        
        MarkerCurrntLocation.isHidden = false
        txtCurrentLocation.text = ""
        strPickupLocation = ""
        doublePickupLat = 0
        doublePickupLng = 0
        self.currentLocationMarker.map = nil
        self.destinationLocationMarker.map = nil
        self.strLocationType = self.currentLocationMarkerText
        self.routePolyline.map = nil
        
        //        self.btnDoneForLocationSelected.isHidden = false
        // bhavesh change - self.ConstantViewCarListsHeight.constant = 0
        self.viewCarLists.isHidden = true
        //        self.viewShareRideView.isHidden = true
        
        self.btnDoneForLocationSelected.isHidden = true // Just for checking
        stackViewOfTruckBooking.isHidden = false
    }
    
    func clearDestinationLocation() {
        
        MarkerCurrntLocation.isHidden = false
        txtDestinationLocation.text = ""
        strDropoffLocation = ""
        doubleDropOffLat = 0
        doubleDropOffLng = 0
        self.destinationLocationMarker.map = nil
        self.currentLocationMarker.map = nil
        self.strLocationType = self.destinationLocationMarkerText
        self.routePolyline.map = nil
        
        self.btnDoneForLocationSelected.isHidden = false
        // bhavesh change - self.ConstantViewCarListsHeight.constant = 0
        self.viewCarLists.isHidden = true
        //        self.viewShareRideView.isHidden = true
    }
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    
    let aryDummyLineData = [[23.073178, 72.514223], [23.073104, 72.514438], [23.073045, 72.514604], [23.073052, 72.514700], [23.072985, 72.514826],
                            [23.073000, 72.514885], [23.072985, 72.514944], [23.072931, 72.514949], [23.072896, 72.514960], [23.072875, 72.514959],
                            [23.072791, 72.514941], [23.072722, 72.514920], [23.072554, 72.514807], [23.072416, 72.514716], [23.071898, 72.514432],
                            [23.071641, 72.514282], [23.071365, 72.514110], [23.071329, 72.514090], [23.071299, 72.514085], [23.071262, 72.514176],
                            [23.071195, 72.514350], [23.071121, 72.514508]]
    
    var dummyOriginCordinate = CLLocationCoordinate2D()
    var dummyDestinationCordinate = CLLocationCoordinate2D()
    
    var dummyOriginCordinateMarker: GMSMarker!
    var dummyDestinationCordinateMarker: GMSMarker!
    
    func getDummyDataLinedata() {
        
        for index in 0..<aryDummyLineData.count {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.setDummyLine(index: index)
            }
        }
    }
    
    func setDummyLine(index: Int) {

        let dt = aryDummyLineData[index]
        
        let PickupLat = "\(dt[0])"
        let PickupLng = "\(dt[1])"

        let DropOffLat = "\(aryDummyLineData.last![0])"
        let DropOffLon = "\(aryDummyLineData.last![1])"
        
        
        let dummyLatitude = Double(PickupLat)! - Double(DropOffLat)!
        let dummyLongitude = Double(PickupLng)! - Double(DropOffLon)!
        
        let waypointLatitude = Double(PickupLat)! - dummyLatitude
        let waypointSetLongitude = Double(PickupLng)! - dummyLongitude
        
        let originalLoc: String = "\(PickupLat),\(PickupLng)"
        let destiantionLoc: String = "\(DropOffLat),\(DropOffLon)"

        //        changePolyLine(origin: originalLoc, destination: destiantionLoc, waypoints: ["\(waypointLatitude),\(waypointSetLongitude)"], travelMode: nil, completionHandler: nil)
        
        DispatchQueue.global(qos: .background).async {
            self.getDirectionsChangedPolyLine(origin: originalLoc, destination: destiantionLoc, waypoints: ["\(waypointLatitude),\(waypointSetLongitude)"], travelMode: nil, completionHandler: nil)
        }
    }

    func updatePolyLineToMapFromDriverLocation() {
        
        var DoubleLat = Double()
        var DoubleLng = Double()
        
        if !SingletonClass.sharedInstance.driverLocation.isEmpty {

            if let lat = SingletonClass.sharedInstance.driverLocation["Location"]! as? [Double] {
                DoubleLat = lat[0]
                DoubleLng = lat[1]
            }
            else if let lat = SingletonClass.sharedInstance.driverLocation["Location"]! as? [String] {
                DoubleLat = Double(lat[0])!
                DoubleLng = Double(lat[1])!
            }

            //            DoubleLat = defaultLocation.coordinate.latitude
            //            DoubleLng = defaultLocation.coordinate.longitude

            if strPickUpLatitude != "" {

                let PickupLat = "\(DoubleLat)" // strPickUpLatitude // "\(DoubleLat)" // "\(pickUpLat)"
                let PickupLng = "\(DoubleLng)" // strPickUpLongitude // "\(DoubleLng)"  // pickupLng
                
                //        let DropOffLat = driverInfo.object(forKey: "PickupLat") as! String
                //        let DropOffLon = driverInfo.object(forKey: "PickupLng") as! String
                
                let DropOffLat = strPickUpLatitude // "23.008183" // strPickUpLatitude // "\(DoubleLat)" // dropOffLat
                let DropOffLon = strPickUpLongitude // "72.513819" // strPickUpLongitude // "\(DoubleLng)" // dropOfLng
                
                let dummyLatitude = Double(PickupLat)! - Double(DropOffLat)! // 23.008183, 72.513819
                let dummyLongitude = Double(PickupLng)! - Double(DropOffLon)!
                
                let waypointLatitude = Double(PickupLat)! - dummyLatitude
                let waypointSetLongitude = Double(PickupLng)! - dummyLongitude
                
                let originalLoc: String = "\(PickupLat),\(PickupLng)"
                let destiantionLoc: String = "\(DropOffLat),\(DropOffLon)"


                DispatchQueue.global(qos: .background).async {
                    self.getDirectionsChangedPolyLine(origin: originalLoc, destination: destiantionLoc, waypoints: ["\(waypointLatitude),\(waypointSetLongitude)"], travelMode: nil, completionHandler: nil)
                }


            }
        }
        //
    }
    
    //-------------------------------------------------------------
    // MARK: - Map Draw Line
    //-------------------------------------------------------------
    
    func setLineData() {
        
        let singletonData = SingletonClass.sharedInstance.dictIsFromPrevious
        
        txtCurrentLocation.text = singletonData.object(forKey: "PickupLocation") as? String
        txtDestinationLocation.text = singletonData.object(forKey: "DropoffLocation") as? String
        
        let DropOffLat = singletonData.object(forKey: "DropOffLat") as! Double
        let DropOffLon = singletonData.object(forKey: "DropOffLon") as! Double
        
        let PickupLat = singletonData.object(forKey: "PickupLat") as! Double
        let PickupLng = singletonData.object(forKey: "PickupLng")as! Double
        
        let dummyLatitude: Double = Double(PickupLat) - Double(DropOffLat)
        let dummyLongitude: Double = Double(PickupLng) - Double(DropOffLon)
        
        let waypointLatitude = PickupLat - dummyLatitude
        let waypointSetLongitude = PickupLng - dummyLongitude
        
        let originalLoc: String = "\(PickupLat),\(PickupLng)"
        let destiantionLoc: String = "\(DropOffLat),\(DropOffLon)"
        
        self.getDirectionsSeconMethod(origin: originalLoc, destination: destiantionLoc, waypoints: ["\(waypointLatitude),\(waypointSetLongitude)"], travelMode: nil, completionHandler: nil)
        
    }
    
    func clearMap() {
        
        self.mapView.clear()
        self.driverMarker = nil
        self.mapView.delegate = self
        
        self.destinationLocationMarker.map = nil
        
        //        self.mapView.stopRendering()
        //        self.mapView = nil
    }
    
    
    
    
    // ------------------------------------------------------------
    func getDirectionsSeconMethod(origin: String!, destination: String!, waypoints: Array<String>!, travelMode: AnyObject!, completionHandler: ((_ status:   String, _ success: Bool) -> Void)?)
    {
        
        clearMap()
        
        MarkerCurrntLocation.isHidden = true
        
        UtilityClass.showACProgressHUD()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            
            
            if let originLocation = origin {
                if let destinationLocation = destination {
                    var directionsURLString = self.baseURLDirections + "origin=" + originLocation + "&destination=" + destinationLocation + "&key=" + googlApiKey
                    if let routeWaypoints = waypoints {
                        directionsURLString += "&waypoints=optimize:true"
                        
                        for waypoint in routeWaypoints {
                            directionsURLString += "|" + waypoint
                        }
                    }
                    
                    // .addingPercentEscapes(using: String.Encoding.utf8)!
                    
                    // print("directionsURLString: \(directionsURLString)")
                    
                    directionsURLString = directionsURLString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                    
                    
                    // .addingPercentEscapes(using: String.Encoding.utf8)!
                    let directionsURL = NSURL(string: directionsURLString)
                    DispatchQueue.main.async( execute: { () -> Void in
                        let directionsData = NSData(contentsOf: directionsURL! as URL)
                        if directionsData != nil {
                            do{
                                let dictionary: Dictionary<String, AnyObject> = try JSONSerialization.jsonObject(with: directionsData as! Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, AnyObject>
                                
                                let status = dictionary["status"] as! String
                                
                                if status == "OK" {
                                    self.selectedRoute = (dictionary["routes"] as! Array<Dictionary<String, AnyObject>>)[0]
                                    self.overviewPolyline = self.selectedRoute["overview_polyline"] as! Dictionary<String, AnyObject>
                                    
                                    let legs = self.selectedRoute["legs"] as! Array<Dictionary<String, AnyObject>>
                                    
                                    let startLocationDictionary = legs[0]["start_location"] as! Dictionary<String, AnyObject>
                                    self.originCoordinate = CLLocationCoordinate2DMake(startLocationDictionary["lat"] as! Double, startLocationDictionary["lng"] as! Double)
                                    
                                    let endLocationDictionary = legs[legs.count - 1]["end_location"] as! Dictionary<String, AnyObject>
                                    self.destinationCoordinate = CLLocationCoordinate2DMake(endLocationDictionary["lat"] as! Double, endLocationDictionary["lng"] as! Double)
                                    
                                    self.locationManager.startUpdatingLocation()
                                    
                                    let originAddress = legs[0]["start_address"] as! String
                                    let destinationAddress = legs[legs.count - 1]["end_address"] as! String
                                    //                                if(SingletonClass.sharedInstance.isTripContinue)
                                    //                                {
                                    if self.driverMarker == nil {
                                        
                                        self.driverMarker = GMSMarker(position: self.originCoordinate) // self.originCoordinate
                                        self.driverMarker.map = self.mapView
                                        var vehicleID = Int()
                                        //                                    var vehicleID = Int()
                                        if let vID = SingletonClass.sharedInstance.dictCarInfo["VehicleModel"] as? Int {
                                            
                                            if vID == 0 {
                                                vehicleID = 7
                                            }
                                            else {
                                                vehicleID = vID
                                            }
                                        }
                                        else if let sID = SingletonClass.sharedInstance.dictCarInfo["VehicleModel"] as? String
                                        {
                                            
                                            if sID == "" {
                                                vehicleID = 7
                                            }
                                            else {
                                                vehicleID = Int(sID)!
                                            }
                                        }
                                        
                                        self.driverMarker.icon = UIImage(named: self.markerCarIconName(modelId: vehicleID))
                                        
                                        self.driverMarker.title = originAddress
                                    }
                                    
                                    let destinationMarker = GMSMarker(position: self.destinationCoordinate)// self.destinationCoordinate  // self.destinationCoordinate
                                    destinationMarker.map = self.mapView
                                    destinationMarker.icon = GMSMarker.markerImage(with: UIColor.red)
                                    destinationMarker.title = destinationAddress
                                    
                                    
                                    var aryDistance = [String]()
                                    var finalDistance = Double()
                                    
                                    
                                    for i in 0..<legs.count
                                    {
                                        let legsData = legs[i]
                                        let distanceKey = legsData["distance"] as! Dictionary<String, AnyObject>
                                        let distance = distanceKey["text"] as! String
                                        //                                    print(distance)
                                        
                                        let stringDistance = distance.components(separatedBy: " ")
                                        //                                    print(stringDistance)
                                        
                                        if stringDistance[1] == "m"
                                        {
                                            finalDistance += Double(stringDistance[0])! / 1000
                                        }
                                        else
                                        {
                                            finalDistance += Double(stringDistance[0].replacingOccurrences(of: ",", with: ""))!
                                        }
                                        
                                        aryDistance.append(distance)
                                        
                                    }
                                    
                                    if finalDistance == 0 {
                                        
                                    }
                                    else
                                    {
                                        self.sumOfFinalDistance = finalDistance
                                        
                                        
                                    }
                                    
                                    let route = self.overviewPolyline["points"] as! String
                                    let path: GMSPath = GMSPath(fromEncodedPath: route)!
                                    let routePolyline = GMSPolyline(path: path)
                                    routePolyline.map = self.mapView
                                    routePolyline.strokeColor = themeYellowColor
                                    routePolyline.strokeWidth = 3.0
                                    
                                    
                                    
                                    UtilityClass.hideACProgressHUD()
                                    
                                    //                                UtilityClass.showAlert("", message: "Line Drawn", vc: self)
                                    
                                    //  print("Line Drawn")
                                    
                                }
                                else {
                                    //                                    print("status")
                                    
                                    self.getDirectionsSeconMethod(origin: origin, destination: destination, waypoints: waypoints, travelMode: nil, completionHandler: nil)
                                    //                                print("OVER_QUERY_LIMIT")
                                }
                            }
                            catch {
                                print("catch")
                                
                                
                                UtilityClass.hideACProgressHUD()
                                
                                UtilityClass.setCustomAlert(title: "\(appName)", message: "Not able to get location data, please restart app") { (index, title) in
                                }
                                // completionHandler(status: "", success: false)
                            }
                        }
                        else {
                            UtilityClass.hideACProgressHUD()
                        }
                        
                    })
                }
                else {
                    print("Destination is nil.")
                    
                    UtilityClass.hideACProgressHUD()
                    
                    UtilityClass.setCustomAlert(title: "\(appName)", message: "Not able to get location Destination, please restart app") { (index, title) in
                    }
                    //completionHandler(status: "Destination is nil.", success: false)
                }
            }
            else {
                print("Origin is nil")
                
                UtilityClass.hideACProgressHUD()
                
                UtilityClass.setCustomAlert(title: "\(appName)", message: "Not able to get location Origin, please restart app") { (index, title) in
                }
                //completionHandler(status: "Origin is nil", success: false)
            }
        }
    }
    
    var demoPolyline = GMSPolyline()
    //    var demoPolylineOLD = GMSPolyline()
    
    func getDirectionsChangedPolyLine(origin: String!, destination: String!, waypoints: Array<String>!, travelMode: AnyObject!, completionHandler: ((_ status:   String, _ success: Bool) -> Void)?)
    {
        
        //        clearMap()
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            
            if let originLocation = origin {
                if let destinationLocation = destination {
                    var directionsURLString = self.baseURLDirections + "origin=" + originLocation + "&destination=" + destinationLocation
                    if let routeWaypoints = waypoints {
                        directionsURLString += "&waypoints=optimize:true"
                        
                        for waypoint in routeWaypoints {
                            directionsURLString += "|" + waypoint
                        }
                    }
                    
                    directionsURLString = directionsURLString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                    
                    let directionsURL = NSURL(string: directionsURLString)
                    DispatchQueue.main.async( execute: { () -> Void in
                        let directionsData = NSData(contentsOf: directionsURL! as URL)
                        if directionsData != nil {
                            do{
                                let dictionary: Dictionary<String, AnyObject> = try JSONSerialization.jsonObject(with: directionsData as! Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, AnyObject>
                                
                                let status = dictionary["status"] as! String
                                if status == "OK" {
                                    
                                    self.selectedRoute = (dictionary["routes"] as! Array<Dictionary<String, AnyObject>>)[0]
                                    self.overviewPolyline = self.selectedRoute["overview_polyline"] as! Dictionary<String, AnyObject>
                                    
                                    let legs = self.selectedRoute["legs"] as! Array<Dictionary<String, AnyObject>>
                                    let startLocationDictionary = legs[0]["start_location"] as! Dictionary<String, AnyObject>
                                    self.originCoordinate = CLLocationCoordinate2DMake(startLocationDictionary["lat"] as! Double, startLocationDictionary["lng"] as! Double)
                                    let endLocationDictionary = legs[legs.count - 1]["end_location"] as! Dictionary<String, AnyObject>
                                    self.destinationCoordinate = CLLocationCoordinate2DMake(endLocationDictionary["lat"] as! Double, endLocationDictionary["lng"] as! Double)
                                    self.locationManager.startUpdatingLocation()
                                    
                                    let route = self.overviewPolyline["points"] as! String
                                    let path: GMSPath = GMSPath(fromEncodedPath: route)!
                                    
                                    
                                    
                                    //                                self.dummyOriginCordinateMarker = self.dummyDestinationCordinateMarker
                                    //
                                    //                                self.dummyDestinationCordinateMarker = nil
                                    
                                    //                                if self.dummyDestinationCordinateMarker == nil {
                                    //                                    self.dummyDestinationCordinateMarker = GMSMarker(position: self.originCoordinate)
                                    //                                }
                                    //
                                    //                                self.dummyDestinationCordinateMarker.map = self.mapView
                                    //                                self.dummyDestinationCordinateMarker.icon = GMSMarker.markerImage(with: UIColor.green)
                                    //                                self.dummyOriginCordinateMarker = self.dummyDestinationCordinateMarker
                                    //
                                    //                                self.dummyDestinationCordinateMarker.map = nil
                                    //                                self.dummyDestinationCordinateMarker.map = self.mapView
                                    ////
                                    //
                                    //
                                    //                                UIView.animate(withDuration: 5, delay: 0, options: .curveLinear, animations: {
                                    //
                                    //                                    if self.dummyOriginCordinateMarker == nil {
                                    //                                        self.dummyOriginCordinateMarker = GMSMarker(position: self.originCoordinate)
                                    //                                        self.dummyOriginCordinateMarker.map = self.mapView
                                    //                                        self.dummyOriginCordinateMarker.icon = GMSMarker.markerImage(with: UIColor.green)
                                    ////                                        self.dummyDestinationCordinateMarker = self.dummyOriginCordinateMarker
                                    ////
                                    ////                                    self.dummyOriginCordinateMarker.map = nil
                                    ////                                    self.dummyOriginCordinateMarker.map = self.mapView
                                    //
                                    //                                    }
                                    //                                }, completion: nil)
                                    //
                                    //
                                    
                                    //                                    self.demoPolylineOLD = self.demoPolyline
                                    //                                    self.demoPolylineOLD.strokeColor = themeYellowColor
                                    //                                    self.demoPolylineOLD.strokeWidth = 3.0
                                    //                                    self.demoPolylineOLD.map = self.mapView
                                    //                                    self.demoPolyline.map = nil
                                    //
                                    //
                                    //                                self.demoPolyline = GMSPolyline(path: path)
                                    //                                self.demoPolyline.map = self.mapView
                                    //                                self.demoPolyline.strokeColor = themeYellowColor
                                    //                                self.demoPolyline.strokeWidth = 3.0
                                    //                                self.demoPolylineOLD.map = nil
                                    
                                    //                                if self.driverMarker == nil {
                                    //
                                    //                                    self.driverMarker = GMSMarker(position: self.defaultLocation.coordinate) // self.originCoordinate
                                    //                                    self.driverMarker.map = self.mapView
                                    //                                    self.driverMarker.icon = UIImage(named: "dummyCar")
                                    //
                                    //                                }
                                    
                                    DispatchQueue.main.async {
                                        
                                        self.demoPolylineOLD = self.demoPolyline
                                        self.demoPolylineOLD.strokeColor = themeYellowColor
                                        self.demoPolylineOLD.strokeWidth = 3.0
                                        self.demoPolylineOLD.map = self.mapView
                                        self.demoPolyline.map = nil
                                        
                                        self.demoPolyline = GMSPolyline(path: path)
                                        self.demoPolyline.map = self.mapView
                                        self.demoPolyline.strokeColor = themeYellowColor
                                        self.demoPolyline.strokeWidth = 3.0
                                        self.demoPolylineOLD.map = nil
                                        
                                    }
                                    
                                    
                                    
                                    //                                if GMSGeometryIsLocationOnPath(self.destinationCoordinate, path, true) {
                                    //                                    print("GMSGeometryIsLocationOnPath")
                                    //                                } else {
                                    //                                    print("Else")
                                    //                                }
                                    
                                    
                                    //                                UIView.animate(withDuration: 3.0, delay: 0, options: .curveLinear, animations: {
                                    //                                    self.demoPolyline = GMSPolyline(path: path)
                                    //                                    self.demoPolyline.map = self.mapView
                                    //                                    self.demoPolyline.strokeColor = themeYellowColor
                                    //                                    self.demoPolyline.strokeWidth = 3.0
                                    //                                    self.demoPolylineOLD.map = nil
                                    //                                }, completion: { (status) in
                                    //
                                    //                                })
                                    
                                    
                                    print("Line Drawn")
                                    
                                    
                                    UtilityClass.hideACProgressHUD()
                                } else {
                                    UtilityClass.hideACProgressHUD()
                                    self.getDirectionsChangedPolyLine(origin: origin, destination: destination, waypoints: waypoints, travelMode: travelMode, completionHandler: completionHandler)
                                }
                            } catch {
                                UtilityClass.hideACProgressHUD()
                                self.getDirectionsChangedPolyLine(origin: origin, destination: destination, waypoints: waypoints, travelMode: travelMode, completionHandler: completionHandler)
                            }
                        }
                        else {
                            UtilityClass.hideACProgressHUD()
                        }

                    })
                } else {
                    UtilityClass.hideACProgressHUD()
                    self.getDirectionsChangedPolyLine(origin: origin, destination: destination, waypoints: waypoints, travelMode: travelMode, completionHandler: completionHandler)
                }
            } else {
                UtilityClass.hideACProgressHUD()
                self.getDirectionsChangedPolyLine(origin: origin, destination: destination, waypoints: waypoints, travelMode: travelMode, completionHandler: completionHandler)
            }
        }
    }
    
    
    
    func changePolyLine(origin: String!, destination: String!, waypoints: Array<String>!, travelMode: AnyObject!, completionHandler: ((_ status:   String, _ success: Bool) -> Void)?)
    {
        
        if let originLocation = origin {
            if let destinationLocation = destination {
                var directionsURLString = self.baseURLDirections + "origin=" + originLocation + "&destination=" + destinationLocation + "&key=" + googlApiKey
                if let routeWaypoints = waypoints {
                    directionsURLString += "&waypoints=optimize:true"
                    
                    for waypoint in routeWaypoints {
                        directionsURLString += "|" + waypoint
                    }
                }
                
                directionsURLString = directionsURLString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                
                let directionsURL = NSURL(string: directionsURLString)
                DispatchQueue.main.async( execute: { () -> Void in
                    let directionsData = NSData(contentsOf: directionsURL! as URL)
                    if directionsData != nil {
                        do{
                            let dictionary: Dictionary<String, AnyObject> = try JSONSerialization.jsonObject(with: directionsData as! Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, AnyObject>
                            
                            let status = dictionary["status"] as! String
                            
                            if status == "OK" {
                                
                                self.locationManager.startUpdatingLocation()
                                
                                self.selectedRoute = (dictionary["routes"] as! Array<Dictionary<String, AnyObject>>)[0]
                                self.overviewPolyline = self.selectedRoute["overview_polyline"] as! Dictionary<String, AnyObject>
                                
                                let legs = self.selectedRoute["legs"] as! Array<Dictionary<String, AnyObject>>
                                
                                let startLocationDictionary = legs[0]["start_location"] as! Dictionary<String, AnyObject>
                                self.dummyOriginCordinate = CLLocationCoordinate2DMake(startLocationDictionary["lat"] as! Double, startLocationDictionary["lng"] as! Double)
                                
                                let endLocationDictionary = legs[legs.count - 1]["end_location"] as! Dictionary<String, AnyObject>
                                self.dummyDestinationCordinate = CLLocationCoordinate2DMake(endLocationDictionary["lat"] as! Double, endLocationDictionary["lng"] as! Double)
                                
                                self.locationManager.startUpdatingLocation()
                                
                                if self.dummyOriginCordinateMarker == nil {
                                    self.dummyOriginCordinateMarker = GMSMarker(position: self.dummyOriginCordinate)// self.destinationCoordinate  // self.destinationCoordinate
                                    self.dummyOriginCordinateMarker.map = self.mapView
                                    self.dummyOriginCordinateMarker.icon = GMSMarker.markerImage(with: UIColor.green)
                                    //                            destinationMarker.title = destinationAddres
                                    
                                    //                                let route = self.overviewPolyline["points"] as! String
                                    //                                let path: GMSPath = GMSPath(fromEncodedPath: route)!
                                    //                                self.routePolyline = GMSPolyline(path: path)
                                    //                                self.routePolyline.map = self.mapView
                                    //                                self.routePolyline.strokeColor = UIColor.blue // themeYellowColor
                                    //                                self.routePolyline.strokeWidth = 3.0
                                    //                                self.demoPolylineOLD.map = nil
                                }
                                
                                if self.dummyDestinationCordinateMarker == nil {
                                    self.dummyDestinationCordinateMarker = GMSMarker(position: self.dummyDestinationCordinate)// self.destinationCoordinate  // self.destinationCoordinate
                                    self.dummyDestinationCordinateMarker.map = self.mapView
                                    self.dummyDestinationCordinateMarker.icon = GMSMarker.markerImage(with: UIColor.blue)
                                }
                                
                                //                            if self.routePolyline.map == nil {
                                //                                self.demoPolylineOLD = self.routePolyline
                                //                                self.demoPolylineOLD.map = self.mapView
                                //                                self.demoPolylineOLD.strokeColor = themeYellowColor
                                //                                self.demoPolylineOLD.strokeWidth = 5.0
                                //                               self.routePolyline.map = nil
                                
                                
                                
                                //                                let route = self.overviewPolyline["points"] as! String
                                //                                let path: GMSPath = GMSPath(fromEncodedPath: route)!
                                //                                self.routePolyline = GMSPolyline(path: path)
                                //                                self.routePolyline.map = self.mapView
                                //                                self.routePolyline.strokeColor = UIColor.blue // themeYellowColor
                                //                                self.routePolyline.strokeWidth = 3.0
                                //                                self.demoPolylineOLD.map = nil
                                
                                
                                // ----------------------------------------------------------------------
                                //                            self.demoPolylineOLD = self.routePolyline
                                //                            self.demoPolylineOLD.map = self.mapView
                                //
                                //                            self.demoPolylineOLD.strokeColor = UIColor.green
                                //                            self.demoPolylineOLD.strokeWidth = 3.0
                                //                            self.routePolyline.map = nil
                                
                                let route = self.overviewPolyline["points"] as! String
                                let path: GMSPath = GMSPath(fromEncodedPath: route)!
                                
                                self.routePolyline = GMSPolyline(path: path)
                                self.routePolyline.map = self.mapView
                                self.routePolyline.strokeColor = UIColor.blue
                                self.routePolyline.strokeWidth = 3.0
                                self.demoPolylineOLD.map = nil
                                // ----------------------------------------------------------------------
                                
                                
                                print("Line Drawn")
                                
                            }
                            else {
                                //                                print("status")
                                
                                self.changePolyLine(origin: origin, destination: destination, waypoints: waypoints, travelMode: nil, completionHandler: nil)
                                print("changePolyLine OVER_QUERY_LIMIT")
                            }
                        }
                        catch {
                            print("catch")
                            
                            
                            UtilityClass.hideACProgressHUD()
                            
                            UtilityClass.setCustomAlert(title: "\(appName)", message: "Not able to get location data, please restart app") { (index, title) in
                                self.changePolyLine(origin: origin, destination: destination, waypoints: waypoints, travelMode: nil, completionHandler: nil)
                            }
                            // completionHandler(status: "", success: false)
                        }
                    }
                    else {
                        UtilityClass.hideACProgressHUD()
                    }
                    
                })
            }
            else {
                print("Destination is nil.")
                
                UtilityClass.hideACProgressHUD()
                
                UtilityClass.setCustomAlert(title: "\(appName)", message: "Not able to get location Destination, please restart app") { (index, title) in
                    self.changePolyLine(origin: origin, destination: destination, waypoints: waypoints, travelMode: nil, completionHandler: nil)
                }
                //completionHandler(status: "Destination is nil.", success: false)
            }
        }
        else {
            print("Origin is nil")
            
            UtilityClass.hideACProgressHUD()
            
            UtilityClass.setCustomAlert(title: "\(appName)", message: "Not able to get location Origin, please restart app") { (index, title) in
                self.changePolyLine(origin: origin, destination: destination, waypoints: waypoints, travelMode: nil, completionHandler: nil)
            }
            //completionHandler(status: "Origin is nil", success: false)
        }
    }
    
    func getDirectionsAcceptRequest(origin: String!, destination: String!, waypoints: Array<String>!, travelMode: AnyObject!, completionHandler: ((_ status:   String, _ success: Bool) -> Void)?)
    {
        
        clearMap()
        
        MarkerCurrntLocation.isHidden = true
        
        //        UtilityClass.showACProgressHUD()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            
            
            if let originLocation = origin {
                if let destinationLocation = destination {
                    var directionsURLString = self.baseURLDirections + "origin=" + originLocation + "&destination=" + destinationLocation + "&key=" + googlApiKey
                    if let routeWaypoints = waypoints {
                        directionsURLString += "&waypoints=optimize:true"
                        
                        for waypoint in routeWaypoints {
                            directionsURLString += "|" + waypoint
                        }
                    }
                    
                    // .addingPercentEscapes(using: String.Encoding.utf8)!
                    
                    // print("directionsURLString: \(directionsURLString)")
                    
                    directionsURLString = directionsURLString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                    
                    
                    // .addingPercentEscapes(using: String.Encoding.utf8)!
                    let directionsURL = NSURL(string: directionsURLString)
                    DispatchQueue.main.async( execute: { () -> Void in
                        let directionsData = NSData(contentsOf: directionsURL! as URL)
                        if directionsData != nil {
                            do{
                                let dictionary: Dictionary<String, AnyObject> = try JSONSerialization.jsonObject(with: directionsData as! Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, AnyObject>
                                
                                let status = dictionary["status"] as! String
                                
                                if status == "OK" {
                                    self.selectedRoute = (dictionary["routes"] as! Array<Dictionary<String, AnyObject>>)[0]
                                    self.overviewPolyline = self.selectedRoute["overview_polyline"] as! Dictionary<String, AnyObject>
                                    
                                    let legs = self.selectedRoute["legs"] as! Array<Dictionary<String, AnyObject>>
                                    
                                    
                                    
                                    let startLocationDictionary = legs[0]["start_location"] as! Dictionary<String, AnyObject>
                                    self.originCoordinate = CLLocationCoordinate2DMake(startLocationDictionary["lat"] as! Double, startLocationDictionary["lng"] as! Double)
                                    
                                    let endLocationDictionary = legs[legs.count - 1]["end_location"] as! Dictionary<String, AnyObject>
                                    self.destinationCoordinate = CLLocationCoordinate2DMake(endLocationDictionary["lat"] as! Double, endLocationDictionary["lng"] as! Double)
                                    
                                    self.locationManager.startUpdatingLocation()
                                    
                                    let originAddress = legs[0]["start_address"] as! String
                                    let destinationAddress = legs[legs.count - 1]["end_address"] as! String
                                    if(SingletonClass.sharedInstance.isTripContinue)
                                    {
                                        if self.driverMarker == nil {
                                            
                                            self.driverMarker = GMSMarker(position: self.destinationCoordinate) // self.originCoordinate
                                            self.driverMarker.map = self.mapView
                                            var vehicleID = Int()
                                            //                                    var vehicleID = Int()
                                            if let vID = SingletonClass.sharedInstance.dictCarInfo["VehicleModel"] as? Int {
                                                
                                                if vID == 0 {
                                                    vehicleID = 7
                                                }
                                                else {
                                                    vehicleID = vID
                                                }
                                            }
                                            else if let sID = SingletonClass.sharedInstance.dictCarInfo["VehicleModel"] as? String
                                            {
                                                
                                                if sID == "" {
                                                    vehicleID = 7
                                                }
                                                else {
                                                    vehicleID = Int(sID)!
                                                }
                                            }
                                            
                                            self.driverMarker.icon = UIImage(named: self.markerCarIconName(modelId: vehicleID))
                                            
                                            self.driverMarker.title = originAddress
                                        }
                                        
                                    }
                                    
                                    let destinationMarker = GMSMarker(position: self.originCoordinate)// self.destinationCoordinate  // self.destinationCoordinate
                                    destinationMarker.map = self.mapView
                                    destinationMarker.icon = GMSMarker.markerImage(with: UIColor.red)
                                    destinationMarker.title = destinationAddress
                                    
                                    
                                    var aryDistance = [String]()
                                    var finalDistance = Double()
                                    
                                    
                                    for i in 0..<legs.count
                                    {
                                        let legsData = legs[i]
                                        let distanceKey = legsData["distance"] as! Dictionary<String, AnyObject>
                                        let distance = distanceKey["text"] as! String
                                        //                                    print(distance)
                                        
                                        let stringDistance = distance.components(separatedBy: " ")
                                        //                                    print(stringDistance)
                                        
                                        if stringDistance[1] == "m"
                                        {
                                            finalDistance += Double(stringDistance[0])! / 1000
                                        }
                                        else
                                        {
                                            finalDistance += Double(stringDistance[0].replacingOccurrences(of: ",", with: ""))!
                                        }
                                        
                                        aryDistance.append(distance)
                                    }
                                    
                                    if finalDistance == 0 {
                                    }
                                    else {
                                        self.sumOfFinalDistance = finalDistance
                                    }
                                    
                                    //                                let route = self.overviewPolyline["points"] as! String
                                    //                                let path: GMSPath = GMSPath(fromEncodedPath: route)!
                                    //                                let routePolyline = GMSPolyline(path: path)
                                    //                                routePolyline.map = self.mapView
                                    //                                routePolyline.strokeColor = themeYellowColor
                                    //                                routePolyline.strokeWidth = 3.0
                                    
                                    UtilityClass.hideACProgressHUD()
                                    
                                    //                                UtilityClass.showAlert("", message: "Line Drawn", vc: self)
                                    
                                    print("Line Drawn")
                                    
                                }
                                else {
                                    //                                    print("status")
                                    
                                    self.getDirectionsAcceptRequest(origin: origin, destination: destination, waypoints: waypoints, travelMode: nil, completionHandler: nil)
                                    //                                print("OVER_QUERY_LIMIT")
                                }
                            }
                            catch {
                                print("catch")
                                
                                
                                UtilityClass.hideACProgressHUD()
                                
                                UtilityClass.setCustomAlert(title: "\(appName)", message: "Not able to get location data, please restart app") { (index, title) in
                                }
                                // completionHandler(status: "", success: false)
                            }
                        }
                        else {
                            UtilityClass.hideACProgressHUD()
                        }
                        
                    })
                }
                else {
                    print("Destination is nil.")
                    
                    UtilityClass.hideACProgressHUD()
                    
                    UtilityClass.setCustomAlert(title: "\(appName)", message: "Not able to get Destination location, please restart app") { (index, title) in
                    }
                    //completionHandler(status: "Destination is nil.", success: false)
                }
            }
            else {
                print("Origin is nil")
                
                UtilityClass.hideACProgressHUD()
                
                UtilityClass.setCustomAlert(title: "\(appName)", message: "Not able to get  Origin location, please restart app") { (index, title) in
                }
                //completionHandler(status: "Origin is nil", success: false)
            }
        }
    }
    
    func setDirectionLineOnMapForSourceAndDestinationShow(origin: String!, destination: String!, waypoints: Array<String>!, travelMode: AnyObject!, completionHandler: ((_ status:   String, _ success: Bool) -> Void)?)
    {
        //        clearMap()
        //        UtilityClass.showACProgressHUD()
        //
        //        self.routePolyline.map = nil
        
        DispatchQueue.global(qos: .background).async {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                
                if let originLocation = origin {
                    if let destinationLocation = destination {
                        var directionsURLString = self.baseURLDirections + "origin=" + originLocation + "&destination=" + destinationLocation + "&key=" + googlApiKey
                        if let routeWaypoints = waypoints {
                            directionsURLString += "&waypoints=optimize:true"
                            
                            for waypoint in routeWaypoints {
                                directionsURLString += "|" + waypoint
                            }
                        }
                        
                        directionsURLString = directionsURLString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                        
                        let directionsURL = NSURL(string: directionsURLString)
                        DispatchQueue.main.async( execute: { () -> Void in
                            let directionsData = NSData(contentsOf: directionsURL! as URL)
                            if directionsData != nil {
                                do{
                                    let dictionary: Dictionary<String, AnyObject> = try JSONSerialization.jsonObject(with: directionsData as! Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, AnyObject>
                                    
                                    let status = dictionary["status"] as! String
                                    
                                    if status == "OK" {
                                        self.selectedRoute = (dictionary["routes"] as! Array<Dictionary<String, AnyObject>>)[0]
                                        self.overviewPolyline = self.selectedRoute["overview_polyline"] as! Dictionary<String, AnyObject>
                                        
                                        let legs = self.selectedRoute["legs"] as! Array<Dictionary<String, AnyObject>>
                                        
                                        let startLocationDictionary = legs[0]["start_location"] as! Dictionary<String, AnyObject>
                                        self.originCoordinate = CLLocationCoordinate2DMake(startLocationDictionary["lat"] as! Double, startLocationDictionary["lng"] as! Double)
                                        
                                        let endLocationDictionary = legs[legs.count - 1]["end_location"] as! Dictionary<String, AnyObject>
                                        self.destinationCoordinate = CLLocationCoordinate2DMake(endLocationDictionary["lat"] as! Double, endLocationDictionary["lng"] as! Double)
                                        
                                        self.locationManager.startUpdatingLocation()
                                        
                                        //                                if SingletonClass.sharedInstance.isTripContinue {
                                        
                                        
                                        // Set currentLocationMarker
                                        self.currentLocationMarker = GMSMarker(position: self.originCoordinate) // destinationCoordinate
                                        self.currentLocationMarker.map = self.mapView
                                        self.currentLocationMarker.snippet = self.currentLocationMarkerText
                                        self.currentLocationMarker.icon = UIImage(named: "iconCurrentLocation")
                                        //                                self.currentLocationMarker.isDraggable = true
                                        
                                        // Set destinationLocationMarker
                                        self.destinationLocationMarker = GMSMarker(position: self.destinationCoordinate) // originCoordinate
                                        self.destinationLocationMarker.map = self.mapView
                                        self.destinationLocationMarker.snippet = self.destinationLocationMarkerText
                                        self.destinationLocationMarker.icon = UIImage(named: "iconCurrentLocation")
                                        
                                        //                                     }
                                        
                                        let route = self.overviewPolyline["points"] as! String
                                        let path: GMSPath = GMSPath(fromEncodedPath: route)!
                                        self.routePolyline = GMSPolyline(path: path)
                                        self.routePolyline.map = self.mapView
                                        self.routePolyline.strokeColor = themeYellowColor
                                        self.routePolyline.strokeWidth = 3.0
                                        
                                        
                                        UtilityClass.hideACProgressHUD()
                                        
                                        print("Line Drawn")
                                        
                                    }
                                    else {
                                        //                                    print("status")
                                        //completionHandler(status: status, success: false)
                                        
                                        self.setDirectionLineOnMapForSourceAndDestinationShow(origin: origin, destination: destination, waypoints: waypoints, travelMode: nil, completionHandler: nil)
                                        //                                print("OVER_QUERY_LIMIT")
                                    }
                                }
                                catch {
                                    print("catch")
                                    
                                    
                                    UtilityClass.hideACProgressHUD()
                                    
                                    UtilityClass.setCustomAlert(title: "\(appName)", message: "Not able to get location data, please restart app") { (index, title) in
                                    }
                                    // completionHandler(status: "", success: false)
                                }
                            }
                            else {
                                UtilityClass.hideACProgressHUD()
                            }
                        })
                    }
                    else {
                        print("Destination is nil.")
                        
                        UtilityClass.hideACProgressHUD()
                        
                        UtilityClass.setCustomAlert(title: "\(appName)", message: "Not able to get Destination location, please restart app") { (index, title) in
                        }
                        //completionHandler(status: "Destination is nil.", success: false)
                    }
                }
                else {
                    print("Origin is nil")
                    
                    UtilityClass.hideACProgressHUD()
                    
                    UtilityClass.setCustomAlert(title: "\(appName)", message: "Not able to get  Origin location, please restart app") { (index, title) in
                    }
                    //completionHandler(status: "Origin is nil", success: false)
                }
            }
        }
        

    }
    
    
    //-------------------------------------------------------------
    // MARK: - Webservice Current Booking Methods
    //-------------------------------------------------------------
    
    var dictCurrentBookingInfoData = NSDictionary()
    var dictCurrentDriverInfoData = NSDictionary()
    var aryCurrentBookingData = NSMutableArray()
    var checkBookingType = String()
    
    var bookingIDNow = String()
    var advanceBookingID = String()
    var passengerId = String()
    
    var strBookingType = String()
    var CancellationFee = String()
    
    func webserviceOfCurrentBooking() {
        
        if let Token = UserDefaults.standard.object(forKey: "Token") as? String {
            SingletonClass.sharedInstance.deviceToken = Token
            print("SingletonClass.sharedInstance.deviceToken : \(SingletonClass.sharedInstance.deviceToken)")
        }
        
        let param = SingletonClass.sharedInstance.strPassengerID + "/" + SingletonClass.sharedInstance.deviceToken
        
        webserviceForCurrentTrip(param as AnyObject) { (result, status) in
            
            if (status) {
                // print(result)
                
                self.clearMap()
                
                
                let resultData = (result as! NSDictionary)
                
                SingletonClass.sharedInstance.passengerRating = resultData.object(forKey: "rating") as! String
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "rating"), object: nil)
                
                self.aryCurrentBookingData.add(resultData)
                self.aryRequestAcceptedData = self.aryCurrentBookingData
                
                if self.aryCurrentBookingData.count != 0 {
                    if let dictCurrentData = self.aryCurrentBookingData.object(at: 0) as? [String:Any] {
                        if let CarInfo = dictCurrentData["CarInfo"] as? [[String:Any]] {
                            if CarInfo.count != 0 {
                                if let CarInfoFirst = CarInfo.first {
                                    if let model = CarInfoFirst["Model"] as? [String:Any] {
                                        
                                        if let IntCncelltionFeeIs = model["CancellationFee"] as? Int {
                                            self.CancellationFee = "\(IntCncelltionFeeIs)"
                                        }
                                        else if let strCancelltionFeeIs = model["CancellationFee"] as? String {
                                            self.CancellationFee = strCancelltionFeeIs
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                
                let bookingType = (self.aryCurrentBookingData.object(at: 0) as! NSDictionary).object(forKey: "BookingType") as! String
                
                if bookingType != "" {
                    
                    
                    self.MarkerCurrntLocation.isHidden = true
                    self.btnDoneForLocationSelected.isHidden = true
                    self.stackViewOfTruckBooking.isHidden = true
                    
                    if bookingType == "BookNow" {
                        
                        
                        self.dictCurrentBookingInfoData = ((resultData).object(forKey: "BookingInfo") as! NSArray).object(at: 0) as! NSDictionary
                        let statusOfRequest = self.dictCurrentBookingInfoData.object(forKey: "Status") as! String
                        
                        self.strBookingType = bookingType
                        
                        if statusOfRequest == "accepted" {
                            
                            self.bookingIDNow = self.dictCurrentBookingInfoData.object(forKey: "Id") as! String
                            self.passengerId = SingletonClass.sharedInstance.strPassengerID
                            SingletonClass.sharedInstance.bookingId = self.bookingIDNow
                            
                            self.bookingTypeIsBookNowAndAccepted()
                            
                        }
                        else if statusOfRequest == "traveling" {
                            self.bookingIDNow = self.dictCurrentBookingInfoData.object(forKey: "Id") as! String
                            self.passengerId = SingletonClass.sharedInstance.strPassengerID
                            SingletonClass.sharedInstance.bookingId = self.bookingIDNow
                            
                            SingletonClass.sharedInstance.isTripContinue = true
                            
                            self.bookingTypeIsBookNowAndTraveling()
                        }
                        
                    }
                    else if bookingType == "BookLater" {
                        
                        self.stackViewOfTruckBooking.isHidden = true
                        
                        self.dictCurrentBookingInfoData = ((resultData).object(forKey: "BookingInfo") as! NSArray).object(at: 0) as! NSDictionary
                        let statusOfRequest = self.dictCurrentBookingInfoData.object(forKey: "Status") as! String
                        
                        self.strBookingType = bookingType
                        
                        if statusOfRequest == "accepted" {
                            
                            self.bookingIDNow = self.dictCurrentBookingInfoData.object(forKey: "Id") as! String
                            self.passengerId = SingletonClass.sharedInstance.strPassengerID
                            SingletonClass.sharedInstance.bookingId = self.bookingIDNow
                            
                            self.bookingTypeIsBookNowAndAccepted()
                            
                        }
                        else if statusOfRequest == "traveling" {
                            self.bookingIDNow = self.dictCurrentBookingInfoData.object(forKey: "Id") as! String
                            self.passengerId = SingletonClass.sharedInstance.strPassengerID
                            SingletonClass.sharedInstance.bookingId = self.bookingIDNow
                            
                            SingletonClass.sharedInstance.isTripContinue = true
                            
                            self.bookingTypeIsBookNowAndTraveling()
                        }
                    }
                    
                    NotificationCenter.default.post(name: NotificationForAddNewBooingOnSideMenu, object: nil)
                    
                }
            }
            else {
                
                let resultData = (result as! NSDictionary)
                
                SingletonClass.sharedInstance.passengerRating = resultData.object(forKey: "rating") as! String
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "rating"), object: nil)
                
            }
        }
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods Running TripTrack
    //-------------------------------------------------------------
    
    @objc func webserviceOfRunningTripTrack() {
        
        
        webserviceForTrackRunningTrip(SingletonClass.sharedInstance.bookingId as AnyObject) { (result, status) in
            
            if (status) {
                // print(result)
                
                self.clearMap()
                
                let resultData = (result as! NSDictionary)
                
                //                SingletonClass.sharedInstance.passengerRating = resultData.object(forKey: "rating") as! String
                //                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "rating"), object: nil)
                self.aryCurrentBookingData.removeAllObjects()
                self.aryCurrentBookingData.add(resultData)
                self.aryRequestAcceptedData = self.aryCurrentBookingData
                
                let bookingType = (self.aryCurrentBookingData.object(at: 0) as! NSDictionary).object(forKey: "BookingType") as! String
                
                if bookingType != "" {
                    
                    self.MarkerCurrntLocation.isHidden = true
                    
                    if bookingType == "BookNow" {
                        
                        self.dictCurrentBookingInfoData = ((resultData).object(forKey: "BookingInfo") as! NSArray).object(at: 0) as! NSDictionary
                        let statusOfRequest = self.dictCurrentBookingInfoData.object(forKey: "Status") as! String
                        
                        self.strBookingType = bookingType
                        
                        if statusOfRequest == "accepted" {
                            
                            self.bookingIDNow = self.dictCurrentBookingInfoData.object(forKey: "Id") as! String
                            self.passengerId = SingletonClass.sharedInstance.strPassengerID
                            SingletonClass.sharedInstance.bookingId = self.bookingIDNow
                            
                            self.bookingTypeIsBookNowAndAccepted()
                            
                        }
                        else if statusOfRequest == "traveling" {
                            self.bookingIDNow = self.dictCurrentBookingInfoData.object(forKey: "Id") as! String
                            self.passengerId = SingletonClass.sharedInstance.strPassengerID
                            SingletonClass.sharedInstance.bookingId = self.bookingIDNow
                            
                            SingletonClass.sharedInstance.isTripContinue = true
                            
                            self.bookingTypeIsBookNowAndTraveling()
                        }
                        
                    }
                    else if bookingType == "BookLater" {
                        
                        self.dictCurrentBookingInfoData = ((resultData).object(forKey: "BookingInfo") as! NSArray).object(at: 0) as! NSDictionary
                        let statusOfRequest = self.dictCurrentBookingInfoData.object(forKey: "Status") as! String
                        
                        self.strBookingType = bookingType
                        
                        if statusOfRequest == "accepted" {
                            
                            self.bookingIDNow = self.dictCurrentBookingInfoData.object(forKey: "Id") as! String
                            self.passengerId = SingletonClass.sharedInstance.strPassengerID
                            SingletonClass.sharedInstance.bookingId = self.bookingIDNow
                            
                            self.bookingTypeIsBookNowAndAccepted()
                            
                        }
                        else if statusOfRequest == "traveling" {
                            self.bookingIDNow = self.dictCurrentBookingInfoData.object(forKey: "Id") as! String
                            self.passengerId = SingletonClass.sharedInstance.strPassengerID
                            SingletonClass.sharedInstance.bookingId = self.bookingIDNow
                            
                            SingletonClass.sharedInstance.isTripContinue = true
                            
                            self.bookingTypeIsBookNowAndTraveling()
                        }
                    }
                }
            }
            else {
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
                let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(OK)
                self.present(alert, animated: true, completion: nil)
                
            }
        }
    }
    
    func webservicOfGetCarList() {

        webserviceForGetCarList("" as AnyObject) { (result, status) in
            
            if status {
                
                if let res = result as? [String:Any] {
                    if let carList = res["car_class"] as? [[String:Any]] {
                        if carList.count != 0 {
                            SingletonClass.sharedInstance.arrCarLists = NSMutableArray(array: carList)  // carList as! NSMutableArray
                            
                            self.arrTotalNumberOfCars = NSMutableArray(array: SingletonClass.sharedInstance.arrCarLists)
                            self.setData()
                        }
                    }
                }
            }
            else {
                print("something went wrong")
            }
        }

    }
    
    // ----------------------------------------------------------------------
    
    // ----------------------------------------------------------------------
    // Book Now Accept Request
    // ----------------------------------------------------------------------
    func bookingTypeIsBookNowAndAccepted() {
        
        
        if let vehicleModelId = (((aryCurrentBookingData.object(at: 0) as? NSDictionary)?.object(forKey: "CarInfo") as? NSArray)?.object(at: 0) as? NSDictionary)?.object(forKey: "VehicleModel") as? String {
            
            for i in 0..<self.arrTotalNumberOfCars.count {
                
                let indexOfCar = self.arrTotalNumberOfCars.object(at: i) as! NSDictionary
                if vehicleModelId == indexOfCar.object(forKey: "Id") as! String {
                    strSelectedCarMarkerIcon = markertIconName(carType: indexOfCar.object(forKey: "Name") as! String)
                }
            }
        }
        
        //        SingletonClass.sharedInstance.isTripContinue = true
        self.DriverInfoAndSetToMap(driverData: NSArray(array: aryCurrentBookingData))
        
    }
    
    func bookingTypeIsBookNowAndTraveling() {
        
        //        clearMap()
        
        if let vehicleModelId = (((aryCurrentBookingData.object(at: 0) as! NSDictionary).object(forKey: "CarInfo") as! NSArray).object(at: 0) as! NSDictionary).object(forKey: "VehicleModel") as? String {
            
            for i in 0..<self.arrTotalNumberOfCars.count {
                
                let indexOfCar = self.arrTotalNumberOfCars.object(at: i) as! NSDictionary
                if vehicleModelId == indexOfCar.object(forKey: "Id") as! String {
                    strSelectedCarMarkerIcon = markertIconName(carType: indexOfCar.object(forKey: "Name") as! String)
                }
            }
        }
        
        self.methodAfterStartTrip(tripData: NSArray(array: aryCurrentBookingData))
    }
    
    func markertIconName(carType: String) -> String {
        
        switch carType {
        case "First Class":
            return "iconFirstClass"
        case "Business Class":
            return "iconBusinessClass"
        case "Economy":
            return "iconEconomy"
        case "Taxi":
            return "iconTaxi"
        case "LUX-VAN":
            return "iconLuxVan"
        case "Disability":
            return "iconDisability"
        default:
            return "dummyCar"
        }
        
    }
    
    //    func markerCarIconName(modelId: Int) -> String {
    //
    //        var CarModel = String()
    //
    //        switch modelId {
    //        case 1:
    //            CarModel = "imgBusinessClass"
    //            return CarModel
    //        case 2:
    //            CarModel = "imgMIni"
    //            return CarModel
    //        case 3:
    //            CarModel = "imgVan"
    //            return CarModel
    //        case 4:
    //            CarModel = "imgNano"
    //            return CarModel
    //        case 5:
    //            CarModel = "imgTukTuk"
    //            return CarModel
    //        case 6:
    //            CarModel = "imgBreakdown"
    //            return CarModel
    //        default:
    //            CarModel = "dummyCar"
    //            return CarModel
    //        }
    //
    //    }
    
    func markerCarIconName(modelId: Int) -> String {
        
        var CarModel = String()
        
        switch modelId {
        case 1:
            CarModel = "imgBusinessClass"
            return CarModel
        case 2:
            CarModel = "imgMIni"
            return CarModel
        case 3:
            CarModel = "imgVan"
            return CarModel
        case 4:
            CarModel = "imgNano"
            return CarModel
        case 5:
            CarModel = "imgTukTuk"
            return CarModel
        case 6:
            CarModel = "imgBreakdown"
            return CarModel
        default:
            CarModel = "dummyCar"
            return CarModel
        }
        
    }
    
    func sortCarListFirstTime() {
        
        let sortedArray = (aryTempOnlineCars as NSArray).sortedArray(using: [NSSortDescriptor(key: "Sort", ascending: true)]) as! [[String:AnyObject]]
        arrNumberOfOnlineCars = NSMutableArray(array: sortedArray)
        self.collectionViewCars.reloadData()
    }
    
    //-------------------------------------------------------------
    // MARK: - ARCar Movement Delegate Method
    //-------------------------------------------------------------
    func ARCarMovementMoved(_ Marker: GMSMarker) {
        driverMarker = Marker
        driverMarker.map = mapView
    }
    
    var destinationCordinate: CLLocationCoordinate2D!
    
    
}


// Delegates to handle events for the location manager.
extension HomeViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        //        print("Location: \(location)")
        
        defaultLocation = location
        
        SingletonClass.sharedInstance.currentLatitude = "\(location.coordinate.latitude)"
        SingletonClass.sharedInstance.currentLongitude = "\(location.coordinate.longitude)"
        
        
        if(SingletonClass.sharedInstance.isFirstTimeDidupdateLocation)
        {
            SingletonClass.sharedInstance.isFirstTimeDidupdateLocation = false
        }
        
        if SingletonClass.sharedInstance.isTripContinue {
            let currentCordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            
            if(destinationCordinate == nil)
            {
                destinationCordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            }
            
            
            if driverMarker == nil {
                driverMarker = GMSMarker(position: destinationCordinate)
                
                var vehicleID = Int()
                //                                    var vehicleID = Int()
                if SingletonClass.sharedInstance.dictCarInfo.count != 0 {
                    if let vID = SingletonClass.sharedInstance.dictCarInfo["VehicleModel"] as? Int {
                        
                        if vID == 0 {
                            vehicleID = 7
                        }
                        else {
                            vehicleID = vID
                        }
                    }
                    else if let sID = SingletonClass.sharedInstance.dictCarInfo["VehicleModel"] as? String
                    {
                        
                        if sID == "" {
                            vehicleID = 7
                        }
                        else {
                            vehicleID = Int(sID)!
                        }
                    }
                    self.driverMarker.icon = UIImage(named: self.markerCarIconName(modelId: vehicleID))
                    
                }
                else {
                    driverMarker.icon = UIImage(named: "iconActiveDriver")
                }
                
                
                driverMarker.map = mapView
            }
            
            //            self.moveMent.ARCarMovement(marker: driverMarker, oldCoordinate: destinationCordinate, newCoordinate: currentCordinate, mapView: mapView, bearing: Float(SingletonClass.sharedInstance.floatBearing))
            destinationCordinate = currentCordinate
            self.MarkerCurrntLocation.isHidden = true
        }
        
        
        if mapView.isHidden {
            mapView.isHidden = false
            self.getPlaceFromLatLong()
            self.socketMethods()
            
            mapView.delegate = self
            
            let position = CLLocationCoordinate2D(latitude: defaultLocation.coordinate.latitude, longitude: defaultLocation.coordinate.longitude)
            
            MarkerCurrntLocation.isHidden = false
            
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,longitude: location.coordinate.longitude, zoom: 17)
            mapView.animate(to: camera)
            
            
        }
        
        let latitude: CLLocationDegrees = (location.coordinate.latitude)
        let longitude: CLLocationDegrees = (location.coordinate.longitude)
        
        let locations = CLLocation(latitude: latitude, longitude: longitude) //changed!!!
        CLGeocoder().reverseGeocodeLocation(locations, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                //                return
            }else if let _ = placemarks?.first?.country,
                let city = (placemarks?.first?.addressDictionary as! [String : AnyObject])["City"] {
                
                SingletonClass.sharedInstance.strCurrentCity = city as! String
            }
            else {
            }
        })
        
        //        if txtCurrentLocation.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" && txtDestinationLocation.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" && self.viewCarLists.isHidden == false {
        //
        //            self.postPickupAndDropLocationForEstimateFare()
        //        }
        
        
        //        updatePolyLineToMapFromDriverLocation()
        
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = true
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways:
            mapView.isHidden = false
            locationManager.startUpdatingLocation()
            
        case .authorizedWhenInUse:
            mapView.isHidden = true
            locationManager.startUpdatingLocation()
            
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        return touch.view == gestureRecognizer.view
    }
    
}


extension UILabel {
    func setSizeFont (sizeFont: Double) {
        self.font =  UIFont(name: self.font.fontName, size: CGFloat(sizeFont))!
        self.sizeToFit()
    }
}

