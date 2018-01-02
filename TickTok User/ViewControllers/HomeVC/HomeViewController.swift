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

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, GMSAutocompleteViewControllerDelegate, FavouriteLocationDelegate, UIPickerViewDelegate, UIPickerViewDataSource, NVActivityIndicatorViewable, UIGestureRecognizerDelegate, FloatRatingViewDelegate, CompleterTripInfoDelegate, ARCarMovementDelegate, GMSMapViewDelegate {
    
    let baseURLDirections = "https://maps.googleapis.com/maps/api/directions/json?"
    
    let socket = SocketIOClient(socketURL: URL(string: SocketData.kBaseURL)!, config: [.log(false), .compress])
    
    //    let socket = (UIApplication.shared.delegate as! AppDelegate).SocketManager
    
    var moveMent: ARCarMovement!
    var driverMarker: GMSMarker!
    
    var timer = Timer()
    
    var aryCards = [[String:AnyObject]]()
    var aryCompleterTripData = [Any]()
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView = GMSMapView()
    var placesClient = GMSPlacesClient()
    var zoomLevel: Float = 17.0
    var likelyPlaces: [GMSPlace] = []
    var selectedPlace: GMSPlace?
    var defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)
    var arrNumberOfAvailableCars = NSMutableArray()
    var arrTotalNumberOfCars = NSMutableArray()
    var arrNumberOfOnlineCars = NSMutableArray()
    var dictCars = NSMutableDictionary()
    var strCarModelClass = String()
    
    var aryRequestAcceptedData = NSArray()
    
    var strCarModelID = String()
    
    var strNavigateCarModel = String()
    
    var aryEstimateFareData = NSArray()
    
    var strSelectedCarMarkerIcon = String()
    var ratingToDriver = Float()
    var commentToDriver = String()
    
    
    //-------------------------------------------------------------
    // MARK: - Final Rating View
    //-------------------------------------------------------------
    
    
    
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
                    UtilityClass.showAlert("", message: res, vc: self)
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.showAlert("", message: resDict.object(forKey: "message") as! String, vc: self)
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.showAlert("", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
                }
            }
        }
        
    }
    
    func didRatingCompleted() {
        
        self.completeTripInfo()
        
    }
    
    // ----------------------------------------------------------------------
    //MARK:- Driver Details
    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var lblDriverEmail: UILabel!
    @IBOutlet weak var lblDriverPhoneNumber: UILabel!
    @IBOutlet weak var imgDriverImage: UIImageView!
    @IBOutlet weak var viewDriverInformation: UIView!
    @IBOutlet weak var viewTripActions: UIView!
    
    //MARK:-
    @IBOutlet weak var viewCarLists: UIView!
    //PassengerId,ModelId,PickupLocation,DropoffLocation,PickupLat,PickupLng,DropOffLat,DropOffLon
    
    var strModelId = String()
    var strPickupLocation = String()
    var strDropoffLocation = String()
    var doublePickupLat = Double()
    var doublePickupLng = Double()
    var doubleDropOffLat = Double()
    var doubleDropOffLng = Double()
    var arrDataAfterCompletetionOfTrip = NSMutableArray()
    var selectedIndexPath: IndexPath?
    
    
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
    
    @IBOutlet weak var viewDestinationLocation: UIView!
    @IBOutlet weak var viewCurrentLocation: UIView!
    @IBOutlet weak var txtDestinationLocation: UITextField!
    @IBOutlet weak var txtCurrentLocation: UITextField!
    @IBOutlet weak var viewMap: UIView!
    @IBOutlet weak var collectionViewCars: UICollectionView!
    
    override func loadView() {
        super.loadView()
        if(SingletonClass.sharedInstance.isUserLoggedIN)
        {
            
            let next = self.storyboard?.instantiateViewController(withIdentifier: "AllDriversOnMapViewController") as! AllDriversOnMapViewController
            self.navigationController?.present(next, animated: true, completion: nil)
            //            self.performSegue(withIdentifier: "loadAllDriverList", sender: nil)
        }
    }
    
    var dropoffLat = Double()
    var dropoffLng = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentLocationMarker.isDraggable = true
        
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
        
        giveRating.delegate = self
        
        ratingToDriver = 0.0
        
        paymentType = "cash"
        
        self.viewBookNow.isHidden = true
        stackViewOfPromocode.isHidden = true
        
        viewMainActivityIndicator.isHidden = true
        
        viewActivity.type = .ballPulse
        viewActivity.color = UIColor.red
        
        
        viewHavePromocode.tintColor = UIColor.init(red: 204/255, green: 3/255, blue: 0, alpha: 1.0)
        viewHavePromocode.stateChangeAnimation = .fill
        viewHavePromocode.boxType = .square
        
        viewTripActions.isHidden = true
        
        webserviceOfCardList()
        
        webserviceOfCurrentTrip()
        
        
        
        viewForMainFavourite.isHidden = true
        
        viewForFavourite.layer.cornerRadius = 5
        viewForFavourite.layer.masksToBounds = true
        
        SingletonClass.sharedInstance.isFirstTimeDidupdateLocation = true;
        self.view.bringSubview(toFront: btnFavourite)
        
        
        //
        //        // Do any additional setup after loading the view.
        //        UIApplication.shared.statusBarStyle = .default
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //        setupGoogleMap()
        
        //        viewTripActions.isHidden = true
        
        viewSubFinalRating.layer.cornerRadius = 5
        viewSubFinalRating.layer.masksToBounds = true
        
        viewSelectPaymentOption.layer.borderWidth = 1.0
        viewSelectPaymentOption.layer.borderColor = UIColor.gray.cgColor
        viewSelectPaymentOption.layer.cornerRadius = 5
        viewSelectPaymentOption.layer.masksToBounds = true
        
        viewSelectPaymentOptionParent.layer.cornerRadius = 5
        viewSelectPaymentOptionParent.layer.masksToBounds = true
        
        
        // Do any additional setup after loading the view.
        UIApplication.shared.statusBarStyle = .default
        
        viewCurrentLocation.layer.shadowOpacity = 0.3
        viewCurrentLocation.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        
        viewDestinationLocation.layer.shadowOpacity = 0.3
        viewDestinationLocation.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        
        //        self.setupSideMenu()
        //        webserviceCallForGettingCarLists()
        //         btnClose.isHidden = true
        
        //        if SingletonClass.sharedInstance.boolIsFromPrevious {
        ////            setLineData()
        //
        //            viewTripActions.isHidden = true
        //            viewCarLists.isHidden = true
        //            viewDestinationLocation.isHidden = true
        //            viewCurrentLocation.isHidden = true
        //
        ////            btnClose.isHidden = false
        //
        //            SingletonClass.sharedInstance.boolIsFromPrevious = false
        //        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
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
        self.arrTotalNumberOfCars = NSMutableArray(array: SingletonClass.sharedInstance.arrCarLists)
        
        //        self.setupGoogleMap()
        
        
        
    }
    
    @IBOutlet weak var btnCurrentLocation: UIButton!
    var currentLocationMarker = GMSMarker()
    @IBAction func btnCurrentLocation(_ sender: UIButton) {
        
       currentLocationAction()
      
    }
    
    func currentLocationAction() {
        
        clearMap()
        
        mapView.delegate = self
        
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: 17)
        
        mapView.camera = camera
        
        let position = CLLocationCoordinate2D(latitude: defaultLocation.coordinate.latitude, longitude: defaultLocation.coordinate.longitude)
        currentLocationMarker = GMSMarker(position: position)
        currentLocationMarker.map = self.mapView
        currentLocationMarker.snippet = "Current Location"
        currentLocationMarker.icon = UIImage(named: "iconCurrentLocation")
        currentLocationMarker.isDraggable = true
    }
    
    let geocoder = GMSGeocoder()
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
       
    }
    
    func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
        geocoder.reverseGeocodeCoordinate(cameraPosition.target) { (response, error) in
            guard error == nil else {
                return
            }
            
//            if let result = response?.firstResult() {
//                let marker = GMSMarker()
//                marker.position = cameraPosition.target
//                marker.title = result.lines?[0]
//                marker.snippet = result.lines?[1]
//                marker.map = mapView
//            }
        }
    }

    
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        
        print("didBeginDragging")
        
    }
    
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        print("didDrag")
        
    }
    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        
        let ceo = CLGeocoder()
        
        var loc = CLLocation(latitude: marker.position.latitude, longitude: marker.position.longitude)
       
        ceo.reverseGeocodeLocation(loc) { (placemarks, error) in
            
            let placemark = placemarks![0] as? CLPlacemark
            
//            print(placemark?.addressDictionary ?? "")
            
//            print("placemark \(String(describing: placemark))")
//            //String to hold address
//            var locatedAt: String? = (placemark?.addressDictionary?["FormattedAddressLines"] as AnyObject).joined(separator: ", ")
//            print("addressDictionary \(String(describing: placemark?.addressDictionary) ?? "")")

            let address = (placemark?.addressDictionary?["FormattedAddressLines"] as! [String]).joined(separator: ", ")
            
            
            self.txtCurrentLocation.text = address
            self.strPickupLocation = address
            self.doublePickupLat = (placemark?.location?.coordinate.latitude)!
            self.doublePickupLng = (placemark?.location?.coordinate.longitude)!
            
            
            print("didEndDragging")
        }
    
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
    }
    
    
    @IBOutlet weak var btnFavourite: UIButton!
    @IBAction func btnFavourite(_ sender: UIButton) {
        
        if txtDestinationLocation.text!.count == 0 {
            UtilityClass.showAlert("", message: "Enter Destination Address", vc: self)
        }
        else {
            UIView.transition(with: viewForMainFavourite, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
                self.viewForMainFavourite.isHidden = false
            }) { _ in }
            
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
    
    
    
    
    //    //MARK:- Webservice Call for Get Car lists
    //    func webserviceCallForGettingCarLists()
    //    {
    //        UtilityClass.showHUD()
    //        webserviceForCarList { (result, status) in
    //            if(result.object(forKey: "status") as! Int == 1)
    //            {
    //            }
    //            UtilityClass.hideHUD()
    ////            self.setupGoogleMap()
    //        }
    //    }
    
    //MARK:- Webservice Call for Booking Requests
    func webserviceCallForBookingCar()
    {
        
        //PassengerId,ModelId,PickupLocation,DropoffLocation,PickupLat,PickupLng,DropOffLat,DropOffLon
        //,PromoCode,Notes,PaymentType,CardId(If paymentType is card)
        
        let dictParams = NSMutableDictionary()
        dictParams.setObject(SingletonClass.sharedInstance.strPassengerID, forKey: "PassengerId" as NSCopying)
        dictParams.setObject(strModelId, forKey: SubmitBookingRequest.kModelId as NSCopying)
        
        dictParams.setObject(strPickupLocation, forKey: SubmitBookingRequest.kPickupLocation as NSCopying)
        dictParams.setObject(strDropoffLocation, forKey: SubmitBookingRequest.kDropoffLocation as NSCopying)
        
        dictParams.setObject(doublePickupLat, forKey: SubmitBookingRequest.kPickupLat as NSCopying)
        dictParams.setObject(doublePickupLng, forKey: SubmitBookingRequest.kPickupLng as NSCopying)
        
        dictParams.setObject(doubleDropOffLat, forKey: SubmitBookingRequest.kDropOffLat as NSCopying)
        dictParams.setObject(doubleDropOffLng, forKey: SubmitBookingRequest.kDropOffLon as NSCopying)
        
        dictParams.setObject(txtNote.text!, forKey: SubmitBookingRequest.kNotes as NSCopying)
        
        
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
        
        
        
        webserviceForTaxiRequest(dictParams) { (result, status) in
            
            if (status) {
                //      print(result)
                
                SingletonClass.sharedInstance.bookedDetails = (result as! NSDictionary)
                
                if let bookingId = ((result as! NSDictionary).object(forKey: "details") as! NSDictionary).object(forKey: "BookingId") as? Int {
                    SingletonClass.sharedInstance.bookingId = "\(bookingId)"
                }
                
                self.strBookingType = "BookNow"
                
                
                //                let activityData = ActivityData(size: CGSize(width: self.view.frame.width, height: 70), message: "Your request is pending...", messageFont: UIFont.systemFont(ofSize: 34, weight: UIFont.Weight.regular), type: .ballBeat, color: .red, padding: 2.0, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: .white, textColor: .black)
                
                self.viewBookNow.isHidden = true
                
                
                self.viewActivity.startAnimating()
                self.view.bringSubview(toFront: self.viewMainActivityIndicator)
                self.viewMainActivityIndicator.isHidden = false
                
                //                self.startAnimation()
                
                //                NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
                
                //                self.socketMethodForGettingBookingAcceptNotification()
                //                self.socketMethodForGettingBookingRejectNotification()
                //                self.socketMethodForGettingPickUpNotification()
                //                self.socketMethodForGettingTripCompletedNotification()
            }
            else {
                //    print(result)
                
                self.viewBookNow.isHidden = true
                
                if let res = result as? String {
                    UtilityClass.showAlert("", message: res, vc: self)
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.showAlert("", message: resDict.object(forKey: "message") as! String, vc: self)
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.showAlert("", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
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
    
    @IBOutlet weak var imgPaymentType: UIImageView!
    @IBOutlet weak var txtHavePromocode: UITextField!
    @IBOutlet weak var txtNote: UITextField!
    var boolIsSelected = Bool()
    
    var pickerView = UIPickerView()
    
    var CardID = String()
    var paymentType = String()
    
    @IBAction func btnPromocode(_ sender: UIButton) {
        
        boolIsSelected = !boolIsSelected
        
        if (boolIsSelected) {
            stackViewOfPromocode.isHidden = false
            viewHavePromocode.checkState = .checked
            viewHavePromocode.stateChangeAnimation = .fill
        }
        else {
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
        return aryCardsListForBookNow.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    //    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    //
    //    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let data = aryCardsListForBookNow[row]
        
        let myView = UIView(frame: CGRect(x:0, y:0, width: pickerView.bounds.width - 30, height: 60))
        
        let myImageView = UIImageView(frame: CGRect(x:0, y:0, width:50, height:50))
        
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
        
        let data = aryCardsListForBookNow[row]
        
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
                
                self.pickerView.reloadAllComponents()
                
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
                    UtilityClass.showAlert("", message: res, vc: self)
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.showAlert("", message: resDict.object(forKey: "message") as! String, vc: self)
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.showAlert("", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
                }
            }
        }
    }
    
    
    //MARK:- SideMenu Methods
    
    @IBOutlet weak var openSideMenu: UIButton!
    @IBAction func openSideMenu(_ sender: Any) {
        
        sideMenuController?.toggle()
        
    }
    
    // webservice for Get Estimate Fare
    func webserviceOfGetEstimateFare() {
        //        PickupLocation,DropoffLocation,Ids,PickupLat,PickupLong
        
        let driverID = aryOfOnlineCarsIds.flatMap{ $0 }.joined(separator: ",")
        
        var param = [String:AnyObject]()
        param["PickupLocation"] = txtCurrentLocation.text as AnyObject
        param["DropoffLocation"] = txtDestinationLocation.text as AnyObject
        param["Ids"] = driverID as AnyObject
        param["PickupLat"] = doublePickupLat as AnyObject
        param["PickupLong"] = doublePickupLng as AnyObject
        
        
        webserviceForGetEstimateFare(param as AnyObject) { (result, status) in
            
            if (status) {
                //   print(result)
                
                let estimateData = (result as! [String:AnyObject])["estimate_fare"] as! [[String:AnyObject]]
                
                let sortedArray = estimateData.sorted {($0["sort"] as! Int) < ($1["sort"] as! Int)}
                
                //   print(sortedArray)
                
                self.aryEstimateFareData = sortedArray as NSArray
                self.collectionViewCars.reloadData()
                
            }
            else {
                
                //     print(result)
            }
        }
        
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
        param["Lat"] = SingletonClass.sharedInstance.currentLatitude as AnyObject
        param["Lng"] = SingletonClass.sharedInstance.currentLongitude as AnyObject
        
        webserviceForAddAddress(param as AnyObject) { (result, status) in
            
            if (status) {
                //  print(result)
                
                if let res = result as? String {
                    UtilityClass.showAlert("", message: res, vc: self)
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
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods For Current Trip Status
    //-------------------------------------------------------------
    
    func webserviceOfCurrentTrip() {
        
        webserviceForCurrentTrip(SingletonClass.sharedInstance.strPassengerID as AnyObject) { (result, status) in
            
            if (status) {
                
                //    print(result)
                
                if let res = result as? [String:AnyObject] {
                    if let cards = res["cards"] as? [[String:AnyObject]] {
                        self.aryCards = cards
                        SingletonClass.sharedInstance.CardsVCHaveAryData = cards
                        
                    }
                }
                
            }
            else {
                //   print(result)
                
                if let res = result as? [String:AnyObject] {
                    if let cards = res["cards"] as? [[String:AnyObject]] {
                        self.aryCards = cards
                        SingletonClass.sharedInstance.CardsVCHaveAryData = cards
                        
                    }
                }
                //                if let res = result as? String {
                //                    UtilityClass.showAlert("", message: res, vc: self)
                //                }
                //                else if let resDict = result as? NSDictionary {
                //                    UtilityClass.showAlert("", message: resDict.object(forKey: "message") as! String, vc: self)
                //                }
                //                else if let resAry = result as? NSArray {
                //                    UtilityClass.showAlert("", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
                //                }
            }
        }
    }
    
    
    /*
     fileprivate func setupSideMenu() {
     // Define the menus
     SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
     SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
     SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
     SideMenuManager.default.menuPresentMode = .menuSlideIn
     SideMenuManager.default.menuFadeStatusBar = true
     SideMenuManager.default.menuWidth = self.view.frame.size.width - 120
     SideMenuManager.default.menuEnableSwipeGestures = false
     SideMenuManager.default.menuPresentingViewControllerUserInteractionEnabled = false
     SideMenuManager.default.menuAllowPushOfSameClassTwice = false
     //        SideMenuManager.default.
     // Set up a cool background image for demo purposes
     }
     */
    //MARK: - Setup Google Maps
    func setupGoogleMap()
    {
        // Initialize the location manager.
        //        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 0.1
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()
        
        mapView.delegate = self
        
        // Create a map.
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: 17)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        
       
        mapView.camera = camera
        
        let position = CLLocationCoordinate2D(latitude: defaultLocation.coordinate.latitude, longitude: defaultLocation.coordinate.longitude)
        let marker = GMSMarker(position: position)
        marker.map = self.mapView
        marker.isDraggable = true
        marker.icon = UIImage(named: "iconCurrentLocation")
        
        
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
                return
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
                }
            }
        })
    }
    
    //MARK:- IBActions
    
    @IBAction func btnBookNow(_ sender: Any) {
        
        if SingletonClass.sharedInstance.strPassengerID == "" || strModelId == "" || strPickupLocation == "" || strDropoffLocation == "" || doublePickupLat == 0 || doublePickupLng == 0 || doubleDropOffLat == 0 || doubleDropOffLng == 0 || strModelId == "0"
        {
            UtilityClass.showAlert("", message: "Locations or select available car", vc: self)
            
        }
        else {
            
            
            let data = aryCardsListForBookNow[0]
            
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
            
            
            
            // btnRequestNow
            
            
            //            txtNote.becomeFirstResponder()
            
            //            self.webserviceCallForBookingCar()
        }
        
    }
    
    @IBAction func btnBookLater(_ sender: Any) {
        
        
        let profileData = SingletonClass.sharedInstance.dictProfile
        
        if strCarModelID == "" {
            UtilityClass.showAlert("", message: "Select Car", vc: self)
        }
        else {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "BookLaterViewController") as! BookLaterViewController
            
            next.strModelId = strCarModelID
            next.strCarModelURL = strNavigateCarModel
            next.strCarName = strCarModelClass
            
            next.strFullname = profileData.object(forKey: "Fullname") as! String
            next.strMobileNumber = profileData.object(forKey: "MobileNo") as! String
            
            self.navigationController?.pushViewController(next, animated: true)
            
        }
        
    }
    @IBAction func btnGetFareEstimate(_ sender: Any) {
        
        if txtCurrentLocation.text == "" || txtCurrentLocation.text == "" {
            
            UtilityClass.showAlert("Missing", message: "Please enter both address.", vc: self)
        }
            
        else {
            
            self.webserviceOfGetEstimateFare()
        }
    }
    
    @IBOutlet weak var btnRequest: UIButton!
    @IBAction func btnRequest(_ sender: UIButton) {
        
        socketMethodForCancelRequestTrip()
        
        self.clearMap()
        
        txtCurrentLocation.text = ""
        txtDestinationLocation.text = ""
        
        self.getPlaceFromLatLong()
        
        UtilityClass.showAlert("", message: "Request Canceled", vc: self)
        
        self.viewTripActions.isHidden = true
        self.viewCarLists.isHidden = false
        self.ConstantViewCarListsHeight.constant = 150
        //        self.constraintTopSpaceViewDriverInfo.constant = 170
        
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
    
    
    
    //MARK:- Collectionview Delegate and Datasource methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if (self.arrNumberOfOnlineCars.count == 0)
        {
            return 6
        }
        return self.arrNumberOfOnlineCars.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarsCollectionViewCell", for: indexPath as IndexPath) as! CarsCollectionViewCell
        
        cell.imgCars.image = UIImage(named: "iconCar")
        cell.lblAvailableCars.text = "Avail 0"
        cell.viewOfImage.layer.cornerRadius = cell.viewOfImage.frame.width / 2
        cell.viewOfImage.layer.borderWidth = 3.0
        if selectedIndexPath == indexPath {
            
            cell.viewOfImage.layer.borderColor = UIColor.red.cgColor
            cell.viewOfImage.layer.masksToBounds = true
        }
        else {
            //            cell.viewOfImage.layer.cornerRadius = cell.viewOfImage.frame.width / 2
            //            cell.viewOfImage.layer.borderWidth = 2.0
            cell.viewOfImage.layer.borderColor = UIColor.black.cgColor
            cell.viewOfImage.layer.masksToBounds = true
            
        }
        
        if (self.arrNumberOfOnlineCars.count != 0)
        {
            let dictOnlineCarData = (arrNumberOfOnlineCars.object(at: indexPath.row) as! NSDictionary)
            cell.lblAvailableCars.text = "Avail \(String(describing: dictOnlineCarData.object(forKey: "carCount")!))"
            let imageURL = (self.arrNumberOfOnlineCars.object(at: indexPath.row) as! NSDictionary).object(forKey: "Image") as! String
            
            cell.imgCars.sd_addActivityIndicator()
            cell.imgCars.sd_setShowActivityIndicatorView(true)
            cell.imgCars.sd_showActivityIndicatorView()
            cell.imgCars.sd_setIndicatorStyle(.gray)
            
            //            if self.aryEstimateFareData.count != 0 {
            //
            //                cell.lblMinutes.text = "\((self.aryEstimateFareData.object(at: indexPath.row) as! NSDictionary).object(forKey: "duration") as! Double) min"
            //                cell.lblPrices.text = "$\((self.aryEstimateFareData.object(at: indexPath.row) as! NSDictionary).object(forKey: "total") as! Double)"
            //            }
            
            cell.imgCars.sd_setImage(with: URL(string: imageURL), completed: { (image, error, cacheType, url) in
                cell.imgCars.sd_setShowActivityIndicatorView(false)
            })
            
            cell.lblMinutes.text = "0 min"
            cell.lblPrices.text = "$0.00"
            
            if dictOnlineCarData.object(forKey: "carCount") as! Int != 0 {
                
                if self.aryEstimateFareData.count != 0 {
                    
                    cell.lblMinutes.text = "\((self.aryEstimateFareData.object(at: indexPath.row) as! NSDictionary).object(forKey: "duration") as! Double) min"
                    cell.lblPrices.text = "$\((self.aryEstimateFareData.object(at: indexPath.row) as! NSDictionary).object(forKey: "total") as! Double)"
                }
                
                //                let id = dictOnlineCarData.object(forKey: "Id") as! String
                //                aryOfTempOnlineCarsIds.append(id)
                //                aryOfOnlineCarsIds = uniq(source: aryOfTempOnlineCarsIds)
                
            }
            if txtDestinationLocation.text!.count != 0 && txtCurrentLocation.text!.count != 0 && aryOfTempOnlineCarsIds.count != 0 {
                
                
            }
            
            
        }
        else
        {
            
            let imageURL = (self.arrTotalNumberOfCars.object(at: indexPath.row) as! NSDictionary).object(forKey: "Image") as! String
            
            cell.imgCars.sd_addActivityIndicator()
            cell.imgCars.sd_setShowActivityIndicatorView(true)
            cell.imgCars.sd_showActivityIndicatorView()
            cell.imgCars.sd_setIndicatorStyle(.gray)
            
            cell.imgCars.sd_setImage(with: URL(string: imageURL), completed: { (image, error, cacheType, url) in
                cell.imgCars.sd_setShowActivityIndicatorView(false)
            })
            
        }
        
        
        
        
        
        return cell
        
        // Maybe for future testing ///////
        
        //            if(dictData.object(forKey: "CarType") as! Int == 1)
        //            {
        //                //  Name = "Business Class";
        //            }
        //            else if(dictData.object(forKey: "CarType") as! Int == 2)
        //            {
        //                //  Name = Disability;
        //            }
        //            else if(dictData.object(forKey: "CarType") as! Int == 3)
        //            {
        //             //   Name = Taxi;
        //            }
        //            else if(dictData.object(forKey: "CarType") as! Int == 4)
        //            {
        //                //  Name = "First Class";
        ////                cell.lblAvailableCars.text =
        //            }
        //            else if(dictData.object(forKey: "CarType") as! Int == 5)
        //            {
        //                //  Name = "LUX-VAN";
        //            }
        //            else  if(dictData.object(forKey: "CarType") as! Int == 6)
        //            {
        //                //  Name = Economy;
        //            }
        //            print(dictData)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if (arrNumberOfOnlineCars.count != 0)
        {
            
            let dictOnlineCarData = (arrNumberOfOnlineCars.object(at: indexPath.row) as! NSDictionary)
            
            if dictOnlineCarData.object(forKey: "carCount") as! Int != 0 {
                
                //       print("dictOnlineCarData: \(dictOnlineCarData)")
                
                let available = dictOnlineCarData.object(forKey: "carCount") as! Int
                let checkAvailabla = String(available)
                
                let carModelID = dictOnlineCarData.object(forKey: "Id") as? String
                let carModelIDConverString: String = carModelID!
                
                let strCarName: String = dictOnlineCarData.object(forKey: "Name") as! String
                
                strCarModelClass = strCarName
                strCarModelID = carModelIDConverString
                
                let lati = dictOnlineCarData.object(forKey: "Lat") as! Double
                let longi = dictOnlineCarData.object(forKey: "Lng") as! Double
                
                DispatchQueue.main.async {
                    self.clearMap()
                    
                    let camera = GMSCameraPosition.camera(withLatitude: lati,
                                                          longitude: longi,
                                                          zoom: 15)
                    
                    self.mapView.camera = camera
                    
                    let position = CLLocationCoordinate2D(latitude: lati, longitude: longi)
                    let marker = GMSMarker(position: position)
                    marker.tracksViewChanges = false
                    self.strSelectedCarMarkerIcon = self.markertIcon(index: indexPath.row)
                    marker.icon = UIImage(named: self.markertIcon(index: indexPath.row)) // iconCurrentLocation
                    marker.map = self.mapView
                }
                
                
                selectedIndexPath = indexPath
                
                let cell = collectionView.cellForItem(at: indexPath) as! CarsCollectionViewCell
                cell.viewOfImage.layer.borderColor = UIColor.red.cgColor
                
                let imageURL = dictOnlineCarData.object(forKey: "Image") as! String
                strNavigateCarModel = imageURL
                
                if checkAvailabla != "0" {
                    strModelId = dictOnlineCarData.object(forKey: "Id") as! String
                }
                else {
                    strModelId = "0"
                }
                
                
                
            }
            else {
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
                let carModelID = dictOnlineCarData.object(forKey: "Id") as? String
                let carModelIDConverString: String = carModelID!
                
                let strCarName: String = dictOnlineCarData.object(forKey: "Name") as! String
                
                strCarModelClass = strCarName
                
                let cell = collectionView.cellForItem(at: indexPath) as! CarsCollectionViewCell
                cell.viewOfImage.layer.borderColor = UIColor.red.cgColor
                
                selectedIndexPath = indexPath
                
                let imageURL = dictOnlineCarData.object(forKey: "Image") as! String
                
                strNavigateCarModel = imageURL
                
                strCarModelID = carModelIDConverString
                
            }
            collectionViewCars.reloadData()
        }
        /*        else
         {
         if let dictOnlineCarData = arrNumberOfOnlineCars.object(at: indexPath.row) as? NSDictionary {
         
         print("dictOnlineCarData: \(dictOnlineCarData)")
         
         //        let available = dictOnlineCarData.object(forKey: "Status") as! Int
         //            let checkAvailabla: String = dictOnlineCarData.object(forKey: "Status") as! String
         
         let lati = dictOnlineCarData.object(forKey: "Lat") as! Double
         let longi = dictOnlineCarData.object(forKey: "Lng") as! Double
         
         
         DispatchQueue.main.async {
         let position = CLLocationCoordinate2D(latitude: lati, longitude: longi)
         let marker = GMSMarker(position: position)
         marker.tracksViewChanges = false
         marker.icon = UIImage(named: "") // iconCurrentLocation
         marker.map = self.mapView
         }
         
         let carModelID = dictOnlineCarData.object(forKey: "Id") as? String
         let carModelIDConverString: String = carModelID!
         
         let strCarName: String = dictOnlineCarData.object(forKey: "Name") as! String
         
         strCarModelClass = strCarName
         
         let cell = collectionView.cellForItem(at: indexPath) as! CarsCollectionViewCell
         cell.viewOfImage.layer.borderColor = UIColor.black.cgColor
         
         selectedIndexPath = indexPath
         
         let imageURL = dictOnlineCarData.object(forKey: "Image") as! String
         
         strNavigateCarModel = imageURL
         
         strCarModelID = carModelIDConverString
         
         /*
         if checkAvailabla != "0" {
         strModelId = dictOnlineCarData.object(forKey: "Id") as! String
         
         }
         else {
         strModelId = "0"
         
         }
         */
         
         }
         }
         */
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath as IndexPath) as! CarsCollectionViewCell
        cell.viewOfImage.layer.borderColor = UIColor.black.cgColor
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: self.view.frame.size.width/6, height: self.collectionViewCars.frame.size.height)
    }
    
    var carLocationsLat = Double()
    var carLocationsLng = Double()
    
    func setData()
    {
        var k = 0 as Int
        self.arrNumberOfOnlineCars.removeAllObjects()
        
        aryTempOnlineCars = NSMutableArray()
        
        
        for j in 0..<self.arrTotalNumberOfCars.count - 6
        {
            //            if (j <= 5)
            //            {
            k = 0
            let totalCarsAvailableCarTypeID = (self.arrTotalNumberOfCars.object(at: j) as! NSDictionary).object(forKey: "Id") as! String
            for i in 0..<self.arrNumberOfAvailableCars.count
            {
                
                let carType = (self.arrNumberOfAvailableCars.object(at: i) as! NSDictionary).object(forKey: "CarType") as! String
                
                if (totalCarsAvailableCarTypeID == carType)
                {
                    k = k+1
                }
                
                carLocationsLat = ((self.arrNumberOfAvailableCars.object(at: i) as! NSDictionary).object(forKey: "Location") as! NSArray).object(at: 0) as! Double
                carLocationsLng = ((self.arrNumberOfAvailableCars.object(at: i) as! NSDictionary).object(forKey: "Location") as! NSArray).object(at: 1) as! Double
                //                    carLocations = (self.arrNumberOfAvailableCars.object(at: j) as! NSDictionary)
                
            }
            //                print("The number of cars available is \(String(describing: (self.arrTotalNumberOfCars.object(at: j) as! NSDictionary).object(forKey: "Name")!)) and the count is \(k)")
            
            
            dictCars.setObject((self.arrTotalNumberOfCars.object(at: j) as! NSDictionary).object(forKey: "Sort")!, forKey: "SordId" as NSCopying)
            dictCars.setObject((self.arrTotalNumberOfCars.object(at: j) as! NSDictionary).object(forKey: "Name")!, forKey: "carName" as NSCopying)
            dictCars.setObject(k, forKey: "carCount" as NSCopying)
            dictCars.setObject((self.arrTotalNumberOfCars.object(at: j) as! NSDictionary).object(forKey: "Id")!, forKey: "Id" as NSCopying)
            
            let tempDict =  NSMutableDictionary(dictionary: (self.arrTotalNumberOfCars.object(at: j) as! NSDictionary))
            tempDict.setObject(k, forKey: "carCount" as NSCopying)
            tempDict.setObject(carLocationsLat, forKey: "Lat" as NSCopying)
            tempDict.setObject(carLocationsLng, forKey: "Lng" as NSCopying)
            
            
            aryTempOnlineCars.add(tempDict)
            
            //            }
        }
        
        SortIdOfCarsType()
        
    }
    
    var aryTempOnlineCars = NSMutableArray()
    var checkTempData = NSArray()
    
    var aryOfOnlineCarsIds = [String]()
    var aryOfTempOnlineCarsIds = [String]()
    
    func SortIdOfCarsType() {
        
        let sortedArray = (aryTempOnlineCars as NSArray).sortedArray(using: [NSSortDescriptor(key: "Sort", ascending: true)]) as! [[String:AnyObject]]
        
        arrNumberOfOnlineCars = NSMutableArray(array: sortedArray)
        
        //        print(arrNumberOfOnlineCars)
        
        if checkTempData.count == 0 {
            
            SingletonClass.sharedInstance.isFirstTimeReloadCarList = true
            
            checkTempData = aryTempOnlineCars as NSArray
            
        }
        else {
            
            for i in 0..<aryTempOnlineCars.count {
                
                let arySwif = aryTempOnlineCars.object(at: i) as! NSDictionary
                
                if (checkTempData.object(at: i) as! NSDictionary) == arySwif {
                    
                    //                    self.aryOfOnlineCarsIds.append(String((checkTempData.object(at: i) as! NSDictionary).object(forKey: "carCount") as! Int))
                    if SingletonClass.sharedInstance.isFirstTimeReloadCarList == true {
                        SingletonClass.sharedInstance.isFirstTimeReloadCarList = false
                        
                        if txtCurrentLocation.text!.count != 0 && txtDestinationLocation.text!.count != 0 && aryOfOnlineCarsIds.count != 0 {
                            webserviceOfGetEstimateFare()
                        }
                        
                        self.collectionViewCars.reloadData()
                    }
                    
                }
                else {
                    checkTempData = aryTempOnlineCars as NSArray
                    
                    if txtCurrentLocation.text!.count != 0 && txtDestinationLocation.text!.count != 0 && aryOfOnlineCarsIds.count != 0 {
                        webserviceOfGetEstimateFare()
                    }
                    
                    
                    self.collectionViewCars.reloadData()
                }
            }
            
        }
        
        
    }
    
    func markertIcon(index: Int) -> String {
        
        switch index {
        case 0:
            return "iconFirstClass"
        case 1:
            return "iconBusinessClass"
        case 2:
            return "iconEconomy"
        case 3:
            return "iconTaxi"
        case 4:
            return "iconLuxVan"
        case 5:
            return "iconDisability"
        default:
            return ""
        }
        
    }
    
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
            
        }
        
        if(segue.identifier == "segueDriverInfo")
        {
            //            let deiverInfo = segue.destination as! DriverInfoViewController
        }
        if(segue.identifier == "showRating")
        {
            
            let GiveRatingVC = segue.destination as! GiveRatingViewController
            GiveRatingVC.strBookingType = self.strBookingType
            GiveRatingVC.delegate = self
        }
    }
    
    
    func BookingConfirmed(dictData : NSDictionary)
    {
        
        let DriverInfo = ((self.aryRequestAcceptedData.object(at: 0) as! NSDictionary).object(forKey: "DriverInfo") as! NSArray).object(at: 0) as! NSDictionary
        let carInfo = ((self.aryRequestAcceptedData.object(at: 0) as! NSDictionary).object(forKey: "CarInfo") as! NSArray).object(at: 0) as! NSDictionary
        let bookingInfo = ((self.aryRequestAcceptedData.object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as! NSArray).object(at: 0) as! NSDictionary
        
        
        showDriverInfo(bookingInfo: bookingInfo, DriverInfo: DriverInfo, carInfo: carInfo)
        
    }
    
    //MARK: - Socket Methods
    func socketMethods()
    {
        
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            
            self.methodsAfterConnectingToSocket()
            
            
            self.socket.on(SocketData.kNearByDriverList, callback: { (data, ack) in
                //                print("data is \(data)")
                
                var lat : Double!
                var long : Double!
                
                self.arrNumberOfAvailableCars = NSMutableArray(array: ((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "driver") as! NSArray)
                self.setData()
                
                //                self.collectionViewCars.reloadData()
                if (((data as NSArray).object(at: 0) as! NSDictionary).count != 0)
                {
                    for i in 0..<(((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "driver") as! NSArray).count
                    {
                        
                        let arrayOfCoordinte = ((((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "driver") as! NSArray).object(at: i) as! NSDictionary).object(forKey: "Location") as! NSArray
                        lat = arrayOfCoordinte.object(at: 0) as! Double
                        long = arrayOfCoordinte.object(at: 1) as! Double
                        
                        let DriverId = ((((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "driver") as! NSArray).object(at: i) as! NSDictionary).object(forKey: "DriverId") as! String
                        
                        self.aryOfTempOnlineCarsIds.append(DriverId)
                        self.aryOfOnlineCarsIds = self.uniq(source: self.aryOfTempOnlineCarsIds)
                        
                        /*
                         DispatchQueue.main.async
                         {
                         let position = CLLocationCoordinate2D(latitude: lat, longitude: long)
                         let marker = GMSMarker(position: position)
                         marker.tracksViewChanges = false
                         marker.icon = UIImage(named: "iconCar") // iconCurrentLocation
                         marker.map = self.mapView
                         }
                         */
                    }
                }
            })
            
            
            self.socketMethodForGettingBookingAcceptNotification()
            self.socketMethodForGettingBookingRejectNotification()
            self.socketMethodForGettingPickUpNotification()
            self.socketMethodForGettingTripCompletedNotification()
            self.onTripHoldingNotificationForPassengerLater()
            
            self.onAcceptBookLaterBookingRequestNotification()
            self.onRejectBookLaterBookingRequestNotification()
            self.onPickupPassengerByDriverInBookLaterRequestNotification()
            self.onTripHoldingNotificationForPassenger()
            self.onBookingDetailsAfterCompletedTrip()
            
            self.onAdvanceTripInfoBeforeStartTrip()
            self.onReceiveNotificationWhenDriverAcceptRequest()
            
        }
        
        socket.connect()
    }
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
        
    }
    
    
    @objc func updateCounting(){
        let myJSON = ["PassengerId" : SingletonClass.sharedInstance.strPassengerID, "Lat": defaultLocation.coordinate.latitude, "Long": defaultLocation.coordinate.longitude, "Token" : SingletonClass.sharedInstance.deviceToken] as [String : Any]
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
            //  print("AcceptBooking data is \(data)")
            
            //            self.clearMap()
            
            self.DriverInfoAndSetToMap(driverData: NSArray(array: data))
            
        })
    }
    
    func DriverInfoAndSetToMap(driverData: NSArray) {
        
        self.setHideAndShowTopViewWhenRequestAcceptedAndTripStarted(status: true)
        
        self.viewTripActions.isHidden = false
        self.ConstantViewCarListsHeight.constant = 0
        self.viewCarLists.isHidden = true
        
        self.viewActivity.stopAnimating()
        self.viewMainActivityIndicator.isHidden = true
        self.btnRequest.isHidden = false
        
        
        self.aryRequestAcceptedData = NSArray(array: driverData)
        
        //        let DriverInfo = ((self.aryRequestAcceptedData.object(at: 0) as! NSDictionary).object(forKey: "DriverInfo") as! NSArray).object(at: 0) as! NSDictionary
        ////        let Details = ((self.aryRequestAcceptedData.object(at: 0) as! NSDictionary).object(forKey: "Details") as! NSArray).object(at: 0) as! NSDictionary
        //        let carInfo = ((self.aryRequestAcceptedData.object(at: 0) as! NSDictionary).object(forKey: "CarInfo") as! NSArray).object(at: 0) as! NSDictionary
        //        let bookingInfo = ((self.aryRequestAcceptedData.object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as! NSArray).object(at: 0) as! NSDictionary
        
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
            carInfo = (((self.aryRequestAcceptedData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "CarInfo") as! NSArray).object(at: 0) as! NSDictionary
        }
        else
        {
            // print ("Yes its dictionary")
            carInfo = (((self.aryRequestAcceptedData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "CarInfo") as! NSDictionary) //.object(at: 0) as! NSDictionary
        }
        
        
        showDriverInfo(bookingInfo: bookingInfo, DriverInfo: DriverInfo, carInfo: carInfo)
        
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
        
        
        let PickupLat = defaultLocation.coordinate.latitude
        let PickupLng =  defaultLocation.coordinate.longitude
        
        let DropOffLat = driverInfo.object(forKey: "PickupLat") as! String
        let DropOffLon = driverInfo.object(forKey: "PickupLng") as! String
        
        let dummyLatitude = Double(PickupLat) - Double(DropOffLat)!
        let dummyLongitude = Double(PickupLng) - Double(DropOffLon)!
        
        let waypointLatitude = Double(PickupLat) - dummyLatitude
        let waypointSetLongitude = Double(PickupLng) - dummyLongitude
        
        let originalLoc: String = "\(PickupLat),\(PickupLng)"
        let destiantionLoc: String = "\(DropOffLat),\(DropOffLon)"
        
        
        let camera = GMSCameraPosition.camera(withLatitude: Double(DropOffLat)!,
                                              longitude: Double(DropOffLon)!,
                                              zoom: 18)
        
        mapView.camera = camera
        
        self.getDirectionsSeconMethod(origin: originalLoc, destination: destiantionLoc, waypoints: ["\(waypointLatitude),\(waypointSetLongitude)"], travelMode: nil, completionHandler: nil)
        
        //            self.socket.off(SocketData.kAcceptBookingRequestNotification)
        
    }
    
    func methodAfterStartTrip(tripData: NSArray) {
        
        SingletonClass.sharedInstance.isTripContinue = true
        
        destinationCordinate = CLLocationCoordinate2D(latitude: dropoffLat, longitude: dropoffLng)
        
        self.setHideAndShowTopViewWhenRequestAcceptedAndTripStarted(status: true)
        
        self.viewTripActions.isHidden = false
        self.ConstantViewCarListsHeight.constant = 0
        self.viewCarLists.isHidden = true
        
        self.viewActivity.stopAnimating()
        self.viewMainActivityIndicator.isHidden = true
        self.btnRequest.isHidden = true
        
        
        
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
            carInfo = (((self.aryRequestAcceptedData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "CarInfo") as! NSArray).object(at: 0) as! NSDictionary
        }
        else
        {
            // print ("Yes its dictionary")
            carInfo = (((self.aryRequestAcceptedData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "CarInfo") as! NSDictionary) //.object(at: 0) as! NSDictionary
        }
        
        
        
        showDriverInfo(bookingInfo: bookingInfo, DriverInfo: DriverInfo, carInfo: carInfo)
        
        // ------------------------------------------------------------
        let DropOffLat = bookingInfo.object(forKey: "DropOffLat") as! String
        let DropOffLon = bookingInfo.object(forKey: "DropOffLon") as! String
        
        let picklat = bookingInfo.object(forKey: "PickupLat") as! String
        let picklng = bookingInfo.object(forKey: "PickupLng") as! String
        
        dropoffLat = Double(DropOffLat)!
        dropoffLng = Double(DropOffLon)!
        
        self.txtDestinationLocation.text = bookingInfo.object(forKey: "DropoffLocation") as? String
        self.txtCurrentLocation.text = bookingInfo.object(forKey: "PickupLocation") as? String
        
        let PickupLat = self.defaultLocation.coordinate.latitude
        let PickupLng = self.defaultLocation.coordinate.longitude
        
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
        
        
//        let camera = GMSCameraPosition.camera(withLatitude: PickupLat,
//                                              longitude: PickupLng,
//                                              zoom: 17)
//
//        mapView.camera = camera
        
        self.getDirectionsSeconMethod(origin: originalLoc, destination: destiantionLoc, waypoints: ["\(waypointLatitude),\(waypointSetLongitude)"], travelMode: nil, completionHandler: nil)
        
    }
    
    //MARK:- Show Driver Information
    
    func showDriverInfo(bookingInfo : NSDictionary, DriverInfo: NSDictionary, carInfo : NSDictionary) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "DriverInfoViewController") as! DriverInfoViewController
        
        next.strDriverName = DriverInfo.object(forKey: "Fullname") as! String
        next.strPickupLocation = "Pickup Location : \(bookingInfo.object(forKey: "PickupLocation") as! String)"
        next.strDropoffLocation = "Dropoff Location : \(bookingInfo.object(forKey: "DropoffLocation") as! String)"
        next.strCarClass = String(describing: carInfo.object(forKey: "VehicleModel")!)
        next.strCareName = carInfo.object(forKey: "Company") as! String
        next.strDriverImage = WebserviceURLs.kImageBaseURL + (DriverInfo.object(forKey: "Image") as! String)
        next.strCarImage = WebserviceURLs.kImageBaseURL + (carInfo.object(forKey: "VehicleImage") as! String)
        next.strPassengerMobileNumber = DriverInfo.object(forKey: "MobileNo") as! String
        
        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(next, animated: true, completion: nil)
    }
    
    
    func socketMethodForGettingBookingRejectNotification()
    {
        // Socket Accepted
        self.socket.on(SocketData.kRejectBookingRequestNotification, callback: { (data, ack) in
            // print("data is \(data)")
            
            self.viewActivity.stopAnimating()
            self.viewMainActivityIndicator.isHidden = true
            
            UtilityClass.showAlert("", message: "Your request has been rejected.", vc: self)
        })
    }
    
    func socketMethodForGettingPickUpNotification()
    {
        self.socket.on(SocketData.kPickupPassengerNotification, callback: { (data, ack) in
            //  print("data is \(data)")
            
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            UtilityClass.showAlert("", message: "Your trip has started.", vc: self)
            
            self.btnRequest.isHidden = true
            
            SingletonClass.sharedInstance.isTripContinue = true
            
            self.methodAfterStartTrip(tripData: NSArray(array: data))
            
            //            self.socket.off(SocketData.kPickupPassengerNotification)
            
        })
    }
    
    
    func socketMethodForGettingTripCompletedNotification()
    {
        self.socket.on(SocketData.kBookingCompletedNotification, callback: { (data, ack) in
            //   print("data is \(data)")
            
            SingletonClass.sharedInstance.isTripContinue = false
            self.aryCompleterTripData = data
            
            
            
            //            self.viewMainFinalRating.isHidden = false
            
            self.performSegue(withIdentifier: "showRating", sender: nil)
//            let next = self.storyboard?.instantiateViewController(withIdentifier: "GiveRatingViewController") as! GiveRatingViewController
//            next.strBookingType = self.strBookingType
//            next.delegate = self
//            next.modalPresentationStyle = .overCurrentContext
//            self.present(next, animated: true, completion: nil)
            
            
        })
    }
    
    func completeTripInfo() {
        
        clearMap()
        
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        self.scheduledTimerWithTimeInterval()
        UtilityClass.showAlertWithCompletion("Your trip has been completed", message: "", vc: self, completionHandler: { (status) in
            if (status == true)
            {
                
                self.setHideAndShowTopViewWhenRequestAcceptedAndTripStarted(status: false)
                
                self.dismiss(animated: true, completion: nil)
                //                    self.socket.off(SocketData.kBookingCompletedNotification)
                self.arrDataAfterCompletetionOfTrip = NSMutableArray(array: (self.aryCompleterTripData[0] as! NSDictionary).object(forKey: "Info") as! NSArray)
                self.performSegue(withIdentifier: "seguePresentTripDetails", sender: nil)
                self.viewTripActions.isHidden = true
                self.viewCarLists.isHidden = false
                self.ConstantViewCarListsHeight.constant = 150
                //                    self.constraintTopSpaceViewDriverInfo.constant = 170
                self.viewMainFinalRating.isHidden = true
                
                self.txtCurrentLocation.text = ""
                self.txtDestinationLocation.text = ""
                
                self.currentLocationAction()
                
                self.getPlaceFromLatLong()
            }
        })
        
    }
    
    func socketMethodForCancelRequestTrip()
    {
        
        let myJSON = [SocketDataKeys.kBookingIdNow : SingletonClass.sharedInstance.bookingId] as [String : Any]
        socket.emit(SocketData.kCancelTripByPassenger , with: [myJSON])
        
        self.setHideAndShowTopViewWhenRequestAcceptedAndTripStarted(status: false)
        
    }
    // ------------------------------------------------------------
    
    
    
    func onAcceptBookLaterBookingRequestNotification() {
        
        self.socket.on(SocketData.kAcceptAdvancedBookingRequestNotification, callback: { (data, ack) in
            //    print("data is \(data)")
            
            self.strBookingType = "BookLater"
            
            self.DriverInfoAndSetToMap(driverData: NSArray(array: data))
            
        })
        
    }
    
    func onRejectBookLaterBookingRequestNotification() {
        
        self.socket.on(SocketData.kRejectAdvancedBookingRequestNotification, callback: { (data, ack) in
            //print("data is \(data)")
            
            
            let alert = UIAlertController(title: nil, message: "Your request has been rejected.", preferredStyle: .alert)
            let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(OK)
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
            
        })
    }
    
    func onPickupPassengerByDriverInBookLaterRequestNotification() {
        
        self.socket.on(SocketData.kAdvancedBookingPickupPassengerNotification, callback: { (data, ack) in
            //print("data is \(data)")
            
            self.strBookingType = "BookLater"
            let alert = UIAlertController(title: nil, message: "Your trip has started.", preferredStyle: .alert)
            let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(OK)
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
            
            self.btnRequest.isHidden = true
            
            SingletonClass.sharedInstance.isTripContinue = true
            
            self.methodAfterStartTrip(tripData: NSArray(array: data))
            
        })
    }
    
    func onTripHoldingNotificationForPassenger() {
        
        self.socket.on(SocketData.kReceiveHoldingNotificationToPassenger, callback: { (data, ack) in
            //print("data is \(data)")
            
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
            //print("data is \(data)")
            
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
    
    func onBookingDetailsAfterCompletedTrip() {
        
        self.socket.on(SocketData.kAdvancedBookingDetails, callback: { (data, ack) in
            //print("data is \(data)")
            
            SingletonClass.sharedInstance.isTripContinue = false
            
            self.aryCompleterTripData = data
            
            //            self.viewMainFinalRating.isHidden = false
            
            let next = self.storyboard?.instantiateViewController(withIdentifier: "GiveRatingViewController") as! GiveRatingViewController
            next.strBookingType = self.strBookingType
            next.delegate = self
            //            self.presentingViewController?.modalPresentationStyle
            self.present(next, animated: true, completion: nil)
            
            
        })
    }
    
    func CancelBookLaterTripAfterDriverAcceptRequest() {
        
        let myJSON = [SocketDataKeys.kBookingIdNow : SingletonClass.sharedInstance.bookingId] as [String : Any]
        socket.emit(SocketData.kAdvancedBookingCancelTripByPassenger , with: [myJSON])
        
    }
    
    func onAdvanceTripInfoBeforeStartTrip() {
        
        self.socket.on(SocketData.kInformPassengerForAdvancedTrip, callback: { (data, ack) in
            // print("data is \(data)")
            
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
            //print("data is \(data)")
            
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
    
    
    
    
    
    
    // ------------------------------------------------------------
    
    //-------------------------------------------------------------
    // MARK: - Auto Suggession on Google Map
    //-------------------------------------------------------------
    
    var BoolCurrentLocation = Bool()
    
    
    @IBAction func txtDestinationLocation(_ sender: UITextField) {
        
        let visibleRegion = mapView.projection.visibleRegion()
        let bounds = GMSCoordinateBounds(coordinate: visibleRegion.farLeft, coordinate: visibleRegion.nearRight)
        
        
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        acController.autocompleteBounds = bounds
        
        BoolCurrentLocation = false
        
        present(acController, animated: true, completion: nil)
        
    }
    
    @IBAction func txtCurrentLocation(_ sender: UITextField) {
        
        
        let visibleRegion = mapView.projection.visibleRegion()
        let bounds = GMSCoordinateBounds(coordinate: visibleRegion.farLeft, coordinate: visibleRegion.nearRight)
        
        
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        acController.autocompleteBounds = bounds

        BoolCurrentLocation = true

        present(acController, animated: true, completion: nil)
    }
    
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        if BoolCurrentLocation {
            txtCurrentLocation.text = place.formattedAddress
            strPickupLocation = place.formattedAddress!
            doublePickupLat = place.coordinate.latitude
            doublePickupLng = place.coordinate.longitude
            
        }
        else {
            txtDestinationLocation.text = place.formattedAddress
            strDropoffLocation = place.formattedAddress!
            doubleDropOffLat = place.coordinate.latitude
            doubleDropOffLng = place.coordinate.longitude
            
            if txtCurrentLocation.text!.count != 0 && txtDestinationLocation.text!.count != 0 && aryOfOnlineCarsIds.count != 0 {
                webserviceOfGetEstimateFare()
            }
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        //print("Error: \(error)")
        dismiss(animated: true, completion: nil)
    }
    
    // User cancelled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        //print("Autocomplete was cancelled.")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnClearPickupLocation(_ sender: UIButton) {
        txtCurrentLocation.text = ""
    }
    
    @IBAction func btnClearDropOffLocation(_ sender: UIButton) {
        txtDestinationLocation.text = ""
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Map Draw Line
    //-------------------------------------------------------------
    
    func setLineData() {
        
        let singletonData = SingletonClass.sharedInstance.dictIsFromPrevious
        
        
        //        dictData.setValue(Double(strPickupLat)!, forKey: "PickupLat")
        //        dictData.setValue(Double(strPickupLng)!, forKey: "PickupLng")
        
        //        dictData.setValue(Double(strDropoffLat)!, forKey: "DropOffLat")
        //        dictData.setValue(Double(strDropoffLng)!, forKey: "DropOffLon")
        
        //        dictData.setValue(PickupAddress, forKey: "PickupLocation")
        //        dictData.setValue(DropoffAddress, forKey: "DropoffLocation")
        
        
        
        
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
        
        //        self.mapView.stopRendering()
        //        self.mapView = nil
    }
    
    
    
    
    // ------------------------------------------------------------
    func getDirectionsSeconMethod(origin: String!, destination: String!, waypoints: Array<String>!, travelMode: AnyObject!, completionHandler: ((_ status:   String, _ success: Bool) -> Void)?)
    {
        
        clearMap()
        
        UtilityClass.showACProgressHUD()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            
            
            if let originLocation = origin {
                if let destinationLocation = destination {
                    var directionsURLString = self.baseURLDirections + "origin=" + originLocation + "&destination=" + destinationLocation
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
                        do{
                            let dictionary: Dictionary<String, AnyObject> = try JSONSerialization.jsonObject(with: directionsData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, AnyObject>
                            
                            let status = dictionary["status"] as! String
                            
                            if status == "OK" {
                                self.selectedRoute = (dictionary["routes"] as! Array<Dictionary<String, AnyObject>>)[0]
                                self.overviewPolyline = self.selectedRoute["overview_polyline"] as! Dictionary<String, AnyObject>
                                
                                let legs = self.selectedRoute["legs"] as! Array<Dictionary<String, AnyObject>>
                                
                                
                                
                                let startLocationDictionary = legs[0]["start_location"] as! Dictionary<String, AnyObject>
                                self.originCoordinate = CLLocationCoordinate2DMake(startLocationDictionary["lat"] as! Double, startLocationDictionary["lng"] as! Double)
                                
                                let endLocationDictionary = legs[legs.count - 1]["end_location"] as! Dictionary<String, AnyObject>
                                self.destinationCoordinate = CLLocationCoordinate2DMake(endLocationDictionary["lat"] as! Double, endLocationDictionary["lng"] as! Double)
                                
                                let originAddress = legs[0]["start_address"] as! String
                                let destinationAddress = legs[legs.count - 1]["end_address"] as! String
                                if(self.driverMarker == nil)
                                {
                                    
                                    self.driverMarker = GMSMarker(position: self.originCoordinate)
                                    self.driverMarker.map = self.mapView
                                    self.driverMarker.icon = UIImage(named: "iconActiveDriver")
                                    
                                    self.driverMarker.title = originAddress
                                }
                                else {
                                    
                                }
                                
                                let destinationMarker = GMSMarker(position: self.destinationCoordinate) // self.destinationCoordinate
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
                                routePolyline.strokeColor = UIColor.blue
                                routePolyline.strokeWidth = 3.0
                                
                                
                                
                                UtilityClass.hideACProgressHUD()
                                
                                UtilityClass.showAlert("", message: "Line Drawn", vc: self)
                                
                                print("Line Drawn")
                                
                            }
                            else {
                                print("status")
                                //completionHandler(status: status, success: false)
                                (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.dismiss(animated: true, completion: {
                                    
                                    UtilityClass.showAlert("", message: "Not able to get location due to free api key, please restart app", vc: self)
                                })
                                
                                UtilityClass.hideACProgressHUD()
                                UtilityClass.showAlert("", message: "Not able to get location due to free api key, please restart app", vc: self)
                                
                                print("OVER_QUERY_LIMIT")
                            }
                        }
                        catch {
                            print("catch")
                            
                            
                            UtilityClass.hideACProgressHUD()
                            UtilityClass.showAlert("", message: "Not able to get location data, please restart app", vc: self)
                            // completionHandler(status: "", success: false)
                        }
                    })
                }
                else {
                    print("Destination is nil.")
                    
                    UtilityClass.hideACProgressHUD()
                    UtilityClass.showAlert("", message: "Not able to get location Destination, please restart app", vc: self)
                    //completionHandler(status: "Destination is nil.", success: false)
                }
            }
            else {
                print("Origin is nil")
                
                UtilityClass.hideACProgressHUD()
                UtilityClass.showAlert("", message: "Not able to get location Origin, please restart app", vc: self)
                //completionHandler(status: "Origin is nil", success: false)
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
                
                self.aryCurrentBookingData.add(resultData)
                self.aryRequestAcceptedData = self.aryCurrentBookingData
                
                
                let bookingType = (self.aryCurrentBookingData.object(at: 0) as! NSDictionary).object(forKey: "BookingType") as! String
                
                
                if bookingType != "" {
                    
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
                            
                            self.bookingTypeIsBookNowAndTraveling()
                        }
                    }
                }
            }
            else {
                // print(result)
                if let res = result as? String {
                    UtilityClass.showAlert("", message: res, vc: self)
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.showAlert("", message: resDict.object(forKey: "message") as! String, vc: self)
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.showAlert("", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
                }
            }
        }
        
    }
    
    // ----------------------------------------------------------------------
    
    // ----------------------------------------------------------------------
    // Book Now Accept Request
    // ----------------------------------------------------------------------
    func bookingTypeIsBookNowAndAccepted() {
        
        if let vehicleModelId = (((aryCurrentBookingData.object(at: 0) as! NSDictionary).object(forKey: "CarInfo") as! NSArray).object(at: 0) as! NSDictionary).object(forKey: "VehicleModel") as? String {
            
            for i in 0..<self.arrTotalNumberOfCars.count {
                
                let indexOfCar = self.arrTotalNumberOfCars.object(at: i) as! NSDictionary
                if vehicleModelId == indexOfCar.object(forKey: "Id") as! String {
                    strSelectedCarMarkerIcon = markertIconName(carType: indexOfCar.object(forKey: "Name") as! String)
                }
            }
        }
        
        SingletonClass.sharedInstance.isTripContinue = true
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
        
        SingletonClass.sharedInstance.isRequestAccepted = true
        
        
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
            return "iconCar"
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
        
        //animation to make car icon in center of the mapview
        //
//        let updatedCamera = GMSCameraUpdate.setTarget(driverMarker.position, zoom: 15.0)
//        mapView.animate(with: updatedCamera)
    }
    
    var destinationCordinate: CLLocationCoordinate2D!
    
    
}


// Delegates to handle events for the location manager.
extension HomeViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        defaultLocation = location
        
        SingletonClass.sharedInstance.currentLatitude = "\(location.coordinate.latitude)"
        SingletonClass.sharedInstance.currentLongitude = "\(location.coordinate.longitude)"
        
        
        if(SingletonClass.sharedInstance.isFirstTimeDidupdateLocation)
        {
//            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
//                                                  longitude: location.coordinate.longitude,
//                                                  zoom: 17)
//            mapView.camera = camera
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
                driverMarker.icon = UIImage(named: "iconActiveDriver")
                driverMarker.map = mapView
            }
            self.moveMent.ARCarMovement(marker: driverMarker, oldCoordinate: destinationCordinate, newCoordinate: currentCordinate, mapView: mapView, bearing: Float(SingletonClass.sharedInstance.floatBearing))
            destinationCordinate = currentCordinate
            
        }
        
        if mapView.isHidden {
            mapView.isHidden = false
            self.getPlaceFromLatLong()
            self.socketMethods()
            
            mapView.delegate = self
            
            let position = CLLocationCoordinate2D(latitude: defaultLocation.coordinate.latitude, longitude: defaultLocation.coordinate.longitude)
            let marker = GMSMarker(position: position)
            marker.map = self.mapView
            marker.icon = UIImage(named: "iconCurrentLocation")
            marker.isDraggable = true
            
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,longitude: location.coordinate.longitude, zoom: 17)
            mapView.animate(to: camera)
            
            
        } else {
//            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
//                                                  longitude: location.coordinate.longitude,
//                                                  zoom: 17)
//            mapView.animate(to: camera)
            
        }
        
        let latitude: CLLocationDegrees = (location.coordinate.latitude)
        let longitude: CLLocationDegrees = (location.coordinate.longitude)
        let locations = CLLocation(latitude: latitude, longitude: longitude) //changed!!!
        CLGeocoder().reverseGeocodeLocation(locations, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                return
            }else if let country = placemarks?.first?.country,
                let city = placemarks?.first?.subAdministrativeArea {
                
                SingletonClass.sharedInstance.strCurrentCity = city
            }
            else {
            }
        })
        
    }
    
    /*
     // Heading Rotation delegare Method
     func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
     
     let heading = Double(newHeading.trueHeading)
     
     print("Head Degree Of Driver : \(heading)")
     if driverMarker != nil {
     driverMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
     driverMarker.rotation = heading
     driverMarker.map = mapView
     }
     else {
     
     }
     }
     */
    
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
            
        case .authorizedWhenInUse:
            mapView.isHidden = false
            
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




