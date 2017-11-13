//
//  AllDriversOnMapViewController.swift
//  TickTok User
//
//  Created by Excellent Webworld on 08/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class AllDriversOnMapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var subMapView: UIView!
    
    var mapView : GMSMapView!
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var placesClient: GMSPlacesClient!
    var defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)
    var zoomLevel: Float = 15.0
    var viewMap = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        locationManager.requestAlwaysAuthorization()
        webserviceForAllDrivers()
        
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            
            if locationManager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization))
            {
                if locationManager.location != nil
                {
                    locationManager.startUpdatingLocation()
                    locationManager.delegate = self

                }
                
                //                manager.startUpdatingLocation()
            }
        }
        
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude, longitude: defaultLocation.coordinate.longitude, zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), camera: camera)
        mapView.isMyLocationEnabled = false
//        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        
//        let position = CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
//        let marker = GMSMarker(position: position)
//        marker.icon = UIImage(named: "iconCar")
//        marker.map = self.mapView
    
        subMapView.addSubview(mapView)
        
        
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
   
    @IBAction func btnClose(_ sender: UIButton) {
       
        self.dismiss(animated: true, completion: nil)
        
     //   self.performSegue(withIdentifier: "segueToHomeVC", sender: nil)
        
    }

    //-------------------------------------------------------------
    // MARK: - Location Methods
    //-------------------------------------------------------------
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
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
   
    func setMarkersOnMap(latitude: Double, longitude: Double, name: String) {
        
        let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let marker = GMSMarker(position: position)
        marker.icon = UIImage(named: "iconCar")
        marker.snippet = name
        marker.map = self.mapView
        
        subMapView.addSubview(mapView)
    }
    
    //-------------------------------------------------------------
    // MARK: - webserviceForGetAllDrivers
    //-------------------------------------------------------------
    
    var dictData = NSArray()
    
    func webserviceForAllDrivers()
    {
        webserviceForAllDriversList { (result, status) in
            
            if (status) {

                self.dictData = ((result as! NSDictionary).object(forKey: "drivers") as! NSArray)
                self.getAllLatandLong()
           
            }
            else {
                print(result)
            }
        }
    }
    
    func getAllLatandLong()
    {
        for i in 0..<self.dictData.count {
            
            let currentMarkers = self.dictData[i] as! NSDictionary
            
            let lat = currentMarkers.object(forKey: "Lat") as! String
            let lng = currentMarkers.object(forKey: "Lng") as! String
            let name = currentMarkers.object(forKey: "Fullname") as! String
            
            print(lat)
            print(lng)
            
            if (lat != "" && lng != "") && (lat != "0" && lng != "0") {
                
                let doubleLat = Double(lat)
                let doubleLng = Double(lng)
                
                setMarkersOnMap(latitude: doubleLat!, longitude: doubleLng!, name: name)
                
            }
   
        }
  
    }
    
    
    
    

}
