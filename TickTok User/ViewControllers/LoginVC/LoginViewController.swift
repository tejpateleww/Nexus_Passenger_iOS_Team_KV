//
//  LoginViewController.swift
//  TickTok User
//
//  Created by Excellent Webworld on 25/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import Foundation
import UIKit
import TransitionButton
import ACFloatingTextfield_Swift
//import SideMenu
import NVActivityIndicatorView
import CoreLocation
import SocketIO

class LoginViewController: UIViewController, CLLocationManagerDelegate, alertViewMethodsDelegates {
    
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    @IBOutlet weak var viewMain: UIView!
    
    @IBOutlet weak var txtPassword: ACFloatingTextfield!
    @IBOutlet weak var txtEmail: ACFloatingTextfield!
    @IBOutlet weak var btnLogin: TransitionButton!
    @IBOutlet weak var btnSignup: TransitionButton!
    
    
    var locationManager = CLLocationManager()

    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func loadView() {
        super.loadView()
      
//        if(SingletonClass.sharedInstance.isUserLoggedIN)
//        {
//            //
//            self.performSegue(withIdentifier: "segueToHomeVC", sender: nil)
//        }
        
        
        if Connectivity.isConnectedToInternet() {
            print("Yes! internet is available.")
            // do some tasks..
        }
        else {

            UtilityClass.setCustomAlert(title: "Connection Error", message: "Internet connection not available") { (index, title) in
            }
        }
        
        
        
        webserviceOfAppSetting()
        
        locationManager.requestAlwaysAuthorization()
        
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewMain.isHidden = false
        
//        txtEmail.lineColor = UIColor.white
//        txtPassword.lineColor = UIColor.white`

        if UIDevice.current.name == "Bhavesh iPhone" || UIDevice.current.name == "Excellent Web's iPhone 5s" || UIDevice.current.name == "Rahul's iPhone" ||  UIDevice.current.name == "iOS2’s iPad" ||  UIDevice.current.name == "Excellent iPhone 7" || UIDevice.current.name ==  "Mayur's iPhone X" || UIDevice.current.name ==  "EWW iPhone" {
            
            txtPassword.text = "12345678"
            txtEmail.text = "bhavesh@excellentwebworld.info" // "bhavesh@excellentwebworld.info"
        }
       
        #if targetEnvironment(simulator)
        txtPassword.text = "12345678"
        txtEmail.text = "bhavesh@yahoo.com" // "bhavesh@excellentwebworld.info"
        #endif
       
        
//        #if DEBUG
//        UtilityClass.showAlert("Debug", message: "This is Debuging Mode", vc: self)
//        #elseif release
//        UtilityClass.showAlert("Live", message: "This is Live Mode", vc: self)
//        #endif

        txtPassword.text = "12345678"
        txtEmail.text = "bhavesh@excellentwebworld.info"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        btnLogin.setTitle("Log In", for: .normal)
        btnLogin.titleLabel?.tintColor = UIColor.white
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    

    //MARK: - Validation
    
    func checkValidation() -> Bool
    {
        if (txtEmail.text?.count == 0)
        {

            UtilityClass.setCustomAlert(title: "", message: "Please enter email") { (index, title) in
            }
            
             // txtEmail.showErrorWithText(errorText: "Enter Email")
            return false
        }
        else if (txtPassword.text?.count == 0)
        {

            UtilityClass.setCustomAlert(title: "", message: "Please enter password") { (index, title) in
            }

            return false
        }
        return true
    }
    
    
    //MARK: - Webservice Call for Login
    
    func webserviceCallForLogin()
    {
       
        let dictparam = NSMutableDictionary()
        dictparam.setObject(txtEmail.text!, forKey: "Username" as NSCopying)
        dictparam.setObject(txtPassword.text!, forKey: "Password" as NSCopying)
        dictparam.setObject("1", forKey: "DeviceType" as NSCopying)
        dictparam.setObject("6287346872364287", forKey: "Lat" as NSCopying)
        dictparam.setObject("6287346872364287", forKey: "Lng" as NSCopying)
        dictparam.setObject(SingletonClass.sharedInstance.deviceToken, forKey: "Token" as NSCopying)
        
        webserviceForDriverLogin(dictparam) { (result, status) in
            
            if ((result as! NSDictionary).object(forKey: "status") as! Int == 1)
            {
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    SingletonClass.sharedInstance.dictProfile = NSMutableDictionary(dictionary: (result as! NSDictionary).object(forKey: "profile") as! NSDictionary)
                    SingletonClass.sharedInstance.arrCarLists = NSMutableArray(array: (result as! NSDictionary).object(forKey: "car_class") as! NSArray)
                    SingletonClass.sharedInstance.strPassengerID = String(describing: SingletonClass.sharedInstance.dictProfile.object(forKey: "Id")!)//as! String
                    SingletonClass.sharedInstance.isUserLoggedIN = true
                    
                    
                    UserDefaults.standard.set(SingletonClass.sharedInstance.dictProfile, forKey: "profileData")
                    UserDefaults.standard.set(SingletonClass.sharedInstance.arrCarLists, forKey: "carLists")
                    
                    
                    self.webserviceForAllDrivers()
                    

//                    self.btnLogin.stopAnimation(animationStyle: .normal, completion: {
//
////                        self.performSegue(withIdentifier: "segueToHomeVC", sender: nil)
//                    })
                })
            }
            else
            {
                
                UtilityClass.setCustomAlert(title: "", message: (result as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                }
                
//                self.btnLogin.stopAnimation(animationStyle: .shake, revertAfterDelay: 0, completion: {
//
////                    let next = self.storyboard?.instantiateViewController(withIdentifier: "CustomAlertsViewController") as! CustomAlertsViewController
////                    next.delegateOfAlertView = self
////                    next.strTitle = ""
////                    next.strMessage = (result as! NSDictionary).object(forKey: "message") as! String
////                    self.navigationController?.present(next, animated: false, completion: nil)
//                })
            }
        }
    }
    
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueToHomeVC") {
       
        }
    }

    
    var aryAllDrivers = NSArray()
    func webserviceForAllDrivers()
    {
        webserviceForAllDriversList { (result, status) in
            
            if (status) {
                
                self.aryAllDrivers = ((result as! NSDictionary).object(forKey: "drivers") as! NSArray)
                
                SingletonClass.sharedInstance.allDiverShowOnBirdView = self.aryAllDrivers
              
                self.performSegue(withIdentifier: "segueToHomeVC", sender: nil)
            }
            else {
                print(result)
            }
        }
    }

    
     //MARK: - Webservice Call for Forgot Password
    
    func webserviceCallForForgotPassword(strEmail : String)
    {
        let dictparam = NSMutableDictionary()
        dictparam.setObject(strEmail, forKey: "Email" as NSCopying)
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        webserviceForForgotPassword(dictparam) { (result, status) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()

            if ((result as! NSDictionary).object(forKey: "status") as! Int == 1) {
  
                 UtilityClass.setCustomAlert(title: "Success", message: (result as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                }
            }
            else {

                 UtilityClass.setCustomAlert(title: appName, message: (result as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                }
            }
        }
    }
    
    func webserviceOfAppSetting() {
//        version : 1.0.0 , (app_type : AndroidPassenger , AndroidDriver , IOSPassenger , IOSDriver)

        let nsObject: AnyObject? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as AnyObject
        let version = nsObject as! String
        
        print("Vewsion : \(version)")
        
        var param = String()
        param = version + "/" + "IOSPassenger"
        webserviceForAppSetting(param as AnyObject) { (result, status) in
            
            if (status) {
                print("result is : \(result)")

                self.viewMain.isHidden = false
                
                if ((result as! NSDictionary).object(forKey: "update") as? Bool) != nil {
                    
                    let alert = UIAlertController(title: nil, message: (result as! NSDictionary).object(forKey: "message") as? String, preferredStyle: .alert)
                    let UPDATE = UIAlertAction(title: "UPDATE", style: .default, handler: { ACTION in
                        
                        UIApplication.shared.openURL(NSURL(string: "https://itunes.apple.com/us/app/cab-ride-passenger/id1438603822?ls=1&mt=8")! as URL)
                    })
                    let Cancel = UIAlertAction(title: "Cancel", style: .default, handler: { ACTION in
                        
                        if(SingletonClass.sharedInstance.isUserLoggedIN)
                        {
//                            self.webserviceForAllDrivers()
                            self.performSegue(withIdentifier: "segueToHomeVC", sender: nil)
                        }
                    })
                    alert.addAction(UPDATE)
                    alert.addAction(Cancel)
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    
                    if(SingletonClass.sharedInstance.isUserLoggedIN) {

                        self.performSegue(withIdentifier: "segueToHomeVC", sender: nil)
                    }
                }
            }
            else {
                print(result)

                if let update = (result as! NSDictionary).object(forKey: "update") as? Bool {
                    
                    if (update) {

                        UtilityClass.showAlertWithCompletion("", message: (result as! NSDictionary).object(forKey: "message") as! String, vc: self, completionHandler: { ACTION in
                            
                            UIApplication.shared.open((NSURL(string: "https://itunes.apple.com/us/app/cab-ride-passenger/id1438603822?ls=1&mt=8")! as URL), options: [:], completionHandler: { (status) in
                                
                            })//openURL(NSURL(string: "https://itunes.apple.com/us/app/pick-n-go/id1320783092?mt=8")! as URL)
                        })
                    }
                    else {

                         UtilityClass.setCustomAlert(title: "", message: (result as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                            if (index == 0)
                            {
                                UIApplication.shared.open((NSURL(string: "https://itunes.apple.com/us/app/cab-ride-passenger/id1438603822?ls=1&mt=8")! as URL), options: [:], completionHandler: { (status) in
                                    
                                })
                            }
                        }

                    }
                    
                }
                
              
/*
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
 */
            }
        }
    }
    
    //MARK: - IBActions
    
    @IBAction func unwindToVC(segue: UIStoryboardSegue) {
        SingletonClass.sharedInstance.isUserLoggedIN = false
//        webserviceOfAppSetting()
        print("Logout")
        if (self.navigationController?.childViewControllers.count)! > 1 {
            if let customSideMenuVC = self.navigationController?.childViewControllers[1] as? CustomSideMenuViewController {
                if customSideMenuVC.childViewControllers.count != 0 {
                    if customSideMenuVC.childViewControllers.first?.childViewControllers.count != 0 {
                        if let homeVC = customSideMenuVC.childViewControllers.first?.childViewControllers.first as? HomeViewController {
                            
                            homeVC.socket.off(SocketData.kNearByDriverList)
                            homeVC.socket.off(SocketData.kAcceptBookingRequestNotification)
                            homeVC.socket.off(SocketData.kRejectBookingRequestNotification)
                            homeVC.socket.off(SocketData.kPickupPassengerNotification)
                            homeVC.socket.off(SocketData.kBookingCompletedNotification)
                            homeVC.socket.off(SocketData.kAdvancedBookingTripHoldNotification)
                            homeVC.socket.off(SocketData.kReceiveDriverLocationToPassenger)
                            homeVC.socket.off(SocketData.kCancelTripByDriverNotficication)
                            homeVC.socket.off(SocketData.kAcceptAdvancedBookingRequestNotification)
                            homeVC.socket.off(SocketData.kRejectAdvancedBookingRequestNotification)
                            homeVC.socket.off(SocketData.kAdvancedBookingPickupPassengerNotification)
                            homeVC.socket.off(SocketData.kReceiveHoldingNotificationToPassenger)
                            homeVC.socket.off(SocketData.kAdvancedBookingDetails)
                            homeVC.socket.off(SocketData.kReceiveGetEstimateFare)
                            homeVC.socket.off(SocketData.kInformPassengerForAdvancedTrip)
                            homeVC.socket.off(SocketData.kAcceptAdvancedBookingRequestNotify)
                            
                            homeVC.txtDestinationLocation.text = ""
                            homeVC.txtCurrentLocation.text = ""
                            
                            homeVC.socket.off(clientEvent: .disconnect)
                            
                            homeVC.socket.disconnect()
                            
                            
//                            SocketIOClient(socketURL: URL(string: SocketData.kBaseURL)!, config: [.log(false), .compress])
                            
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func unwindLogOut(segue: UIStoryboardSegue) {
        SingletonClass.sharedInstance.isUserLoggedIN = false
//        webserviceOfAppSetting()
        print("Logout")
        if (self.navigationController?.childViewControllers.count)! > 1 {
            if let customSideMenuVC = self.navigationController?.childViewControllers[1] as? CustomSideMenuViewController {
                if customSideMenuVC.childViewControllers.count != 0 {
                    if customSideMenuVC.childViewControllers.first?.childViewControllers.count != 0 {
                        if let homeVC = customSideMenuVC.childViewControllers.first?.childViewControllers.first as? HomeViewController {
                            
                            homeVC.socket.off(SocketData.kNearByDriverList)
                            homeVC.socket.off(SocketData.kAcceptBookingRequestNotification)
                            homeVC.socket.off(SocketData.kRejectBookingRequestNotification)
                            homeVC.socket.off(SocketData.kPickupPassengerNotification)
                            homeVC.socket.off(SocketData.kBookingCompletedNotification)
                            homeVC.socket.off(SocketData.kAdvancedBookingTripHoldNotification)
                            homeVC.socket.off(SocketData.kReceiveDriverLocationToPassenger)
                            homeVC.socket.off(SocketData.kCancelTripByDriverNotficication)
                            homeVC.socket.off(SocketData.kAcceptAdvancedBookingRequestNotification)
                            homeVC.socket.off(SocketData.kRejectAdvancedBookingRequestNotification)
                            homeVC.socket.off(SocketData.kAdvancedBookingPickupPassengerNotification)
                            homeVC.socket.off(SocketData.kReceiveHoldingNotificationToPassenger)
                            homeVC.socket.off(SocketData.kAdvancedBookingDetails)
                            homeVC.socket.off(SocketData.kReceiveGetEstimateFare)
                            homeVC.socket.off(SocketData.kInformPassengerForAdvancedTrip)
                            homeVC.socket.off(SocketData.kAcceptAdvancedBookingRequestNotify)
                            
                            if homeVC.txtCurrentLocation != nil {
                                homeVC.txtCurrentLocation.text = ""
                            }
                            
                            if homeVC.txtDestinationLocation != nil {
                                homeVC.txtDestinationLocation.text = ""
                            }
                            
                            homeVC.socket.off(clientEvent: .disconnect)
                            
                            homeVC.socket.disconnect()
                            
                            //                            SocketIOClient(socketURL: URL(string: SocketData.kBaseURL)!, config: [.log(false), .compress])
                            
                        }
                    }
                }
            }
        }
        
    }
    
    
    
    @IBAction func btnLogin(_ sender: Any) {
        
        if (checkValidation()) {
//            self.btnLogin.startAnimation()
            self.webserviceCallForLogin()
        }
    
    }
    
    @IBAction func btnSignup(_ sender: Any) {
        
    }
    
    
    @IBAction func btnForgotPassword(_ sender: UIButton) {
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Forgot Password?", message: "Enter email id", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            
            textField.placeholder = "Email"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(String(describing: textField?.text))")
            
            if (textField?.text?.count != 0)
            {
                self.webserviceCallForForgotPassword(strEmail: (textField?.text)!)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Location Methods
    //-------------------------------------------------------------
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
//        print("Location: \(location)")
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
           
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
    
    func didOKButtonPressed() {
        
    }
    
    func didCancelButtonPressed() {
        
    }
    
    
    func setCustomAlert(title: String, message: String) {
        AJAlertController.initialization().showAlertWithOkButton(aStrTitle: title, aStrMessage: message) { (index,title) in
        }
        
//        let next = self.storyboard?.instantiateViewController(withIdentifier: "CustomAlertsViewController") as! CustomAlertsViewController
//
//        next.delegateOfAlertView = self
//        next.strTitle = title
//        next.strMessage = message
//
//        self.navigationController?.present(next, animated: false, completion: nil)
        
    }
   
    
}
