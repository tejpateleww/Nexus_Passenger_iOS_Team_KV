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
import SideMenu
import SocketIO
import SDWebImage
import NVActivityIndicatorView
//let BaseURL = "http://54.206.55.185:8080"

class HomeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,GMSAutocompleteViewControllerDelegate {
    
    let socket = SocketIOClient(socketURL: URL(string: SocketData.kBaseURL)!, config: [.log(false), .compress])
    var timer = Timer()

    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    var likelyPlaces: [GMSPlace] = []
    var selectedPlace: GMSPlace?
    var defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)
    var arrNumberOfAvailableCars = NSMutableArray()
    var arrTotalNumberOfCars = NSMutableArray()
    var arrNumberOfOnlineCars = NSMutableArray()
    var dictCars = NSMutableDictionary()
    var strCarModelClass = String()
    
    var strCarModelID = String()
    
    var strNavigateCarModel = String()
    
    //MARK:- Driver Details
    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var lblDriverEmail: UILabel!
    @IBOutlet weak var lblDriverPhoneNumber: UILabel!
    @IBOutlet weak var imgDriverImage: UIImageView!
    @IBOutlet weak var viewDriverInformation: UIView!

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

    @IBOutlet weak var constraintTopSpaceViewDriverInfo: NSLayoutConstraint!
    
    //---------------
    
    @IBOutlet weak var viewDestinationLocation: UIView!
    @IBOutlet weak var viewCurrentLocation: UIView!
    @IBOutlet weak var txtDestinationLocation: UITextField!
    @IBOutlet weak var txtCurrentLocation: UITextField!
    @IBOutlet weak var viewMap: UIView!
    @IBOutlet weak var collectionViewCars: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        UIApplication.shared.statusBarStyle = .default
        
        viewCurrentLocation.layer.shadowOpacity = 0.3
        viewCurrentLocation.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        
        viewDestinationLocation.layer.shadowOpacity = 0.3
        viewDestinationLocation.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)

        self.setupSideMenu()
//        webserviceCallForGettingCarLists()
        
       
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.arrTotalNumberOfCars = NSMutableArray(array: SingletonClass.sharedInstance.arrCarLists)

        self.setupGoogleMap()

        
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
        let dictParams = NSMutableDictionary()
        dictParams.setObject(SingletonClass.sharedInstance.strPassengerID, forKey: "PassengerId" as NSCopying)
        dictParams.setObject(strModelId, forKey: SubmitBookingRequest.kModelId as NSCopying)
        
        dictParams.setObject(strPickupLocation, forKey: SubmitBookingRequest.kPickupLocation as NSCopying)
        dictParams.setObject(strDropoffLocation, forKey: SubmitBookingRequest.kDropoffLocation as NSCopying)
        
        dictParams.setObject(doublePickupLat, forKey: SubmitBookingRequest.kPickupLat as NSCopying)
        dictParams.setObject(doublePickupLng, forKey: SubmitBookingRequest.kPickupLng as NSCopying)
        
        dictParams.setObject(doubleDropOffLat, forKey: SubmitBookingRequest.kDropOffLat as NSCopying)
        dictParams.setObject(doubleDropOffLng, forKey: SubmitBookingRequest.kDropOffLon as NSCopying)
        
       
        webserviceForTaxiRequest(dictParams) { (result, status) in
            
            if (status) {
                print(result)
                
                SingletonClass.sharedInstance.bookedDetails = (result as! NSDictionary)
                
                
                let activityData = ActivityData(size: CGSize(width: self.view.frame.width, height: 60), message: "Your request is pending...", messageFont: UIFont.systemFont(ofSize: 34, weight: UIFont.Weight.regular), type: .ballBeat, color: .red, padding: 2.0, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: .white, textColor: .black)

                
                
                NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
                self.socketMethodForGettingBookingAcceptNotification()
                self.socketMethodForGettingBookingRejectNotification()
                self.socketMethodForGettingPickUpNotification()
                self.socketMethodForGettingTripCompletedNotification()
              }
            else {
                print(result)
            }
            
        }
    }

    
    //MARK:- SideMenu Methods
    @IBAction func openSideMenu(_ sender: Any) {
        
        
    }
    
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
        // Set up a cool background image for demo purposes
    }
    
    //MARK: - Setup Google Maps
    func setupGoogleMap()
    {
        // Initialize the location manager.
        //        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()
        
        // Create a map.
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        
        // Add the map to the view, hide it until we've got a location update.
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
        
        if SingletonClass.sharedInstance.strPassengerID == "" || strModelId == "" || strPickupLocation == "" || strDropoffLocation == "" || doublePickupLat == 0 || doublePickupLng == 0 || doubleDropOffLat == 0 || doubleDropOffLng == 0
        {
            UtilityClass.showAlert("", message: "Locations or select available car", vc: self)

        }
        else {
            self.webserviceCallForBookingCar()
        }
        
    }
    
    @IBAction func btnBookLater(_ sender: Any) {
        
        if strCarModelID == "" {
            UtilityClass.showAlert("", message: "Select Car", vc: self)
        }
        else {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "BookLaterViewController") as! BookLaterViewController
            
            next.strModelId = strCarModelID
            next.strCarModelURL = strNavigateCarModel
            next.strCarName = strCarModelClass
            
            self.navigationController?.pushViewController(next, animated: true)

        }
        
    }
    @IBAction func btnGetFareEstimate(_ sender: Any) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        cell.imgCars.image = UIImage.init(named: "iconCar")
        cell.lblAvailableCars.text = "Avail. 0"
        
        
        cell.imgCars.layer.cornerRadius = cell.imgCars.frame.width / 2
        cell.imgCars.layer.borderWidth = 2.0
        cell.imgCars.layer.borderColor = UIColor.black.cgColor
        cell.imgCars.layer.masksToBounds = true
  
        if (self.arrNumberOfOnlineCars.count != 0)
        {
            let dictOnlineCarData = (arrNumberOfOnlineCars.object(at: indexPath.row) as! NSDictionary)
            cell.lblAvailableCars.text = "Avail. \(String(describing: dictOnlineCarData.object(forKey: "carCount")!))"
            let imageURL = (self.arrTotalNumberOfCars.object(at: indexPath.row) as! NSDictionary).object(forKey: "Image") as! String
            
            cell.imgCars.sd_addActivityIndicator()
            cell.imgCars.sd_setShowActivityIndicatorView(true)
            cell.imgCars.sd_showActivityIndicatorView()
            cell.imgCars.sd_setIndicatorStyle(.gray)
         
            cell.imgCars.sd_setImage(with: URL(string: imageURL), completed: { (image, error, cacheType, url) in
                    cell.imgCars.sd_setShowActivityIndicatorView(false)
                })
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
        
        let dictOnlineCarData = (arrNumberOfOnlineCars.object(at: indexPath.row) as! NSDictionary)
        
        print("dictOnlineCarData: \(dictOnlineCarData)")
        
        let available = dictOnlineCarData.object(forKey: "carCount") as! Int
        let checkAvailabla = String(available)
        
        let carModelID = dictOnlineCarData.object(forKey: "Id") as? String
        let carModelIDConverString: String = carModelID!
        
        let strCarName: String = dictOnlineCarData.object(forKey: "carName") as! String
        
        strCarModelClass = strCarName
        
        
        
        let cell = collectionView.cellForItem(at: indexPath) as! CarsCollectionViewCell
        cell.imgCars.layer.borderColor = UIColor.red.cgColor
        
        let imageURL = (self.arrTotalNumberOfCars.object(at: indexPath.row) as! NSDictionary).object(forKey: "Image") as! String
        
        strNavigateCarModel = imageURL
        
        strCarModelID = carModelIDConverString
        
        if checkAvailabla != "0" {
            strModelId = dictOnlineCarData.object(forKey: "Id") as! String
     
        }
        else {
            strModelId = "0"
            
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath as IndexPath) as! CarsCollectionViewCell
        cell.imgCars.layer.borderColor = UIColor.black.cgColor
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: self.view.frame.size.width/6, height: self.collectionViewCars.frame.size.height)
    }
    
    
    func setData()
    {
        var k = 0 as Int
        self.arrNumberOfOnlineCars.removeAllObjects()

        for j in 0..<self.arrTotalNumberOfCars.count
        {
            if (j <= 5)
            {
                k = 0
                let totalCarsAvailableCarTypeID = (self.arrTotalNumberOfCars.object(at: j) as! NSDictionary).object(forKey: "Id") as! String
                for i in 0..<self.arrNumberOfAvailableCars.count
                {
                    
                    let carType = (self.arrNumberOfAvailableCars.object(at: i) as! NSDictionary).object(forKey: "CarType") as! String
                    
                    if (totalCarsAvailableCarTypeID == carType)
                    {
                        k = k+1
                    }
                    
                }
                print("The number of cars available is \(String(describing: (self.arrTotalNumberOfCars.object(at: j) as! NSDictionary).object(forKey: "Name")!)) and the count is \(k)")
                
                dictCars.setObject((self.arrTotalNumberOfCars.object(at: j) as! NSDictionary).object(forKey: "Name")!, forKey: "carName" as NSCopying)
                dictCars.setObject(k, forKey: "carCount" as NSCopying)
                dictCars.setObject((self.arrTotalNumberOfCars.object(at: j) as! NSDictionary).object(forKey: "Id")!, forKey: "Id" as NSCopying)
                arrNumberOfOnlineCars.add(dictCars.mutableCopy())
            }
        }
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
       
      
     }
    
    
    func BookingConfirmed(dictData : NSDictionary)
    {
        lblDriverName.text = dictData.object(forKey: "Fullname") as? String
        lblDriverEmail.text = dictData.object(forKey: "Email") as? String
        lblDriverPhoneNumber.text = dictData.object(forKey: "MobileNo") as? String
        let strImageURL = URL(string: "http://54.206.55.185/web/\(dictData.object(forKey: "Image")!)")
        
        imgDriverImage.sd_setShowActivityIndicatorView(true)
        imgDriverImage.sd_setIndicatorStyle(.gray)
        self.imgDriverImage.layer.cornerRadius =  self.imgDriverImage.frame.width/2
        self.imgDriverImage.layer.masksToBounds = true
        imgDriverImage.sd_setImage(with: strImageURL) { (image, error, cacheType, url) in
            self.imgDriverImage.stopAnimating()
            self.imgDriverImage.image = image
        }
        
        
        constraintTopSpaceViewDriverInfo.constant = 0;
        UIView.animate(withDuration: 1.0) {
            self.viewCarLists.layoutIfNeeded()
            self.timer.invalidate()
            
        }
    }

    
    
    //MARK: - Socket Methods
    func socketMethods()
    {
        
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            
            self.methodsAfterConnectingToSocket()
            
            
            self.socket.on(SocketData.kNearByDriverList, callback: { (data, ack) in
                print("data is \(data)")
                
                var lat : Double!
                var long : Double!

                self.arrNumberOfAvailableCars = NSMutableArray(array: ((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "driver") as! NSArray)
                self.setData()
                self.collectionViewCars.reloadData()
                if (((data as NSArray).object(at: 0) as! NSDictionary).count != 0)
                {
                    for i in 0..<(((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "driver") as! NSArray).count
                    {
                        
                        let arrayOfCoordinte = ((((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "driver") as! NSArray).object(at: i) as! NSDictionary).object(forKey: "Location") as! NSArray
                        lat = arrayOfCoordinte.object(at: 0) as! Double
                        long = arrayOfCoordinte.object(at: 1) as! Double
                        
                        let position = CLLocationCoordinate2D(latitude: lat, longitude: long)
                        let marker = GMSMarker(position: position)
                        marker.icon = UIImage(named: "iconCar")
                        marker.map = self.mapView
                    }
                }
            })
            
        }
        
        socket.connect()
    }
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)

    }
    
    
    @objc func updateCounting(){
        let myJSON = ["PassengerId" : SingletonClass.sharedInstance.strPassengerID, "Lat": defaultLocation.coordinate.latitude, "Long": defaultLocation.coordinate.longitude] as [String : Any]
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
            print("data is \(data)")
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            UtilityClass.showAlert("", message: "Your request has been accepted.", vc: self)
            self.BookingConfirmed(dictData: ((data[0] as! NSDictionary).object(forKey: "DriverInfo") as! NSArray).object(at: 0) as! NSDictionary)
            self.socket.off(SocketData.kAcceptBookingRequestNotification)

        })
    }
    
    
    func socketMethodForGettingBookingRejectNotification()
    {
        // Socket Accepted
        self.socket.on(SocketData.kRejectBookingRequestNotification, callback: { (data, ack) in
            print("data is \(data)")
            self.socket.off(SocketData.kRejectBookingRequestNotification)
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            UtilityClass.showAlert("", message: "Your request has been rejected.", vc: self)
        })
    }
    
    func socketMethodForGettingPickUpNotification()
    {
        self.socket.on(SocketData.kPickupPassengerNotification, callback: { (data, ack) in
            print("data is \(data)")
            
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            UtilityClass.showAlert("", message: "Your trip has started.", vc: self)
            self.socket.off(SocketData.kPickupPassengerNotification)

        })
    }
    
    
    func socketMethodForGettingTripCompletedNotification()
    {
        self.socket.on(SocketData.kBookingCompletedNotification, callback: { (data, ack) in
            print("data is \(data)")
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            self.scheduledTimerWithTimeInterval()
            UtilityClass.showAlertWithCompletion("Your trip has been completed", message: "", vc: self, completionHandler: { (status) in
                if (status == true)
                {
                    self.dismiss(animated: true, completion: nil)
                    self.socket.off(SocketData.kBookingCompletedNotification)
                    self.arrDataAfterCompletetionOfTrip = NSMutableArray(array: (data[0] as! NSDictionary).object(forKey: "Info") as! NSArray)
                    self.performSegue(withIdentifier: "seguePresentTripDetails", sender: nil)
                    self.constraintTopSpaceViewDriverInfo.constant = 150
                }
            })
        })
    }
    
    //-------------------------------------------------------------
    // MARK: - Auto Suggession on Google Map
    //-------------------------------------------------------------
    
    var BoolCurrentLocation = Bool()

    
    @IBAction func txtDestinationLocation(_ sender: UITextField) {
        
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        
        BoolCurrentLocation = false
        
        present(acController, animated: true, completion: nil)
    
    }
    
    @IBAction func txtCurrentLocation(_ sender: UITextField) {
        
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        
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
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: \(error)")
        dismiss(animated: true, completion: nil)
    }
    
    // User cancelled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnClearPickupLocation(_ sender: UIButton) {
        txtCurrentLocation.text = ""
    }
    
    @IBAction func btnClearDropOffLocation(_ sender: UIButton) {
        txtDestinationLocation.text = ""
    
    }
    
    
}


// Delegates to handle events for the location manager.
extension HomeViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        defaultLocation = location
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        
        if mapView.isHidden {
            mapView.isHidden = false
            self.getPlaceFromLatLong()
            mapView.camera = camera
            
            
            
            
            
            self.socketMethods()
        } else {
            mapView.animate(to: camera)
        }
        
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
    
}
