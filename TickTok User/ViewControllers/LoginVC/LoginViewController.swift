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

class LoginViewController: UIViewController, CLLocationManagerDelegate {
    
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    @IBOutlet weak var viewMain: UIView!
    
    @IBOutlet weak var txtPassword: ACFloatingTextfield!
    @IBOutlet weak var txtEmail: ACFloatingTextfield!
    @IBOutlet weak var btnLogin: TransitionButton!
    
    
    var locationManager = CLLocationManager()

    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func loadView() {
        super.loadView()
        
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
        
//        if(SingletonClass.sharedInstance.isUserLoggedIN)
//        {
//            self.performSegue(withIdentifier: "segueToHomeVC", sender: nil)
//        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewMain.isHidden = true
        
        txtEmail.lineColor = UIColor.white
        txtPassword.lineColor = UIColor.white
        
        
        if UIDevice.current.name == "Bhavesh iPhone" {
            
            txtEmail.text = "bhavesh@excellentwebworld.info"
            txtPassword.text = "12345678"
        }
        
        if UIDevice.current.name == "Excellent Web's iPhone 5s" {
            
            txtEmail.text = "bhavesh@excellentwebworld.info"
            txtPassword.text = "12345678"
        }

        if UIDevice.current.name == "Rahul's iPhone" {
            
            txtEmail.text = "bhavesh@excellentwebworld.info"
            txtPassword.text = "12345678"
        }
        
        if UIDevice.current.name == "iPhone" {
            
            txtEmail.text = "bhavesh@excellentwebworld.info"
            txtPassword.text = "12345678"
        }
        
        //        setupSideMenu()
        // Do any additional setup after loading the view.
    }
    
/*
    fileprivate func setupSideMenu() {
        // Define the menus
        SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the View Controller it displays!
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuBlurEffectStyle = .dark
        SideMenuManager.default.menuAnimationBackgroundColor = UIColor.clear
        SideMenuManager.default.menuFadeStatusBar = true
        SideMenuManager.default.menuWidth = self.view.frame.size.width - 120
        SideMenuManager.default.menuEnableSwipeGestures = false
        SideMenuManager.default.menuPresentingViewControllerUserInteractionEnabled = false
        // Set up a cool background image for demo purposes
        //SideMenuManager.default.menuAnimationBackgroundColor = UIColor(patternImage: UIImage(named: "background")!)
    }
*/
    //MARK: - Validation
    
    func checkValidation() -> Bool
    {
        if (txtEmail.text?.count == 0)
        {
            UtilityClass.showAlert("Enter Email Address", message: "", vc: self)
             // txtEmail.showErrorWithText(errorText: "Enter Email")
            return false
        }
        else if (txtPassword.text?.count == 0)
        {
           UtilityClass.showAlert("Enter Password", message: "", vc: self)
           //   txtPassword.showErrorWithText(errorText: "Enter Password"  )
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
                    // 4: Stop the animation, here you have three options for the `animationStyle` property:
                    // .expand: useful when the task has been compeletd successfully and you want to expand the button and transit to another view controller in the completion callback
                    // .shake: when you want to reflect to the user that the task did not complete successfly
                    // .normal
                    self.btnLogin.stopAnimation(animationStyle: .normal, completion: {
                        SingletonClass.sharedInstance.dictProfile = NSMutableDictionary(dictionary: (result as! NSDictionary).object(forKey: "profile") as! NSDictionary)
                        SingletonClass.sharedInstance.arrCarLists = NSMutableArray(array: (result as! NSDictionary).object(forKey: "car_class") as! NSArray)
                        SingletonClass.sharedInstance.strPassengerID = String(describing: SingletonClass.sharedInstance.dictProfile.object(forKey: "Id")!)//as! String
                        SingletonClass.sharedInstance.isUserLoggedIN = true
                        
                        
                        UserDefaults.standard.set(SingletonClass.sharedInstance.dictProfile, forKey: "profileData")
                        UserDefaults.standard.set(SingletonClass.sharedInstance.arrCarLists, forKey: "carLists")

                        
//                        let next = self.storyboard?.instantiateViewController(withIdentifier: "AllDriversOnMapViewController") as! AllDriversOnMapViewController
//                        self.present(next, animated: true, completion: nil)

                        
                        self.performSegue(withIdentifier: "segueToHomeVC", sender: nil)
                    })
                })
            }
            else
            {
                
                self.btnLogin.stopAnimation(animationStyle: .shake, revertAfterDelay: 0, completion: {
                    UtilityClass.showAlert("Error", message: (result as! NSDictionary).object(forKey: "message") as! String, vc: self)
                    
                })
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

            if ((result as! NSDictionary).object(forKey: "status") as! Int == 1)
            {
                UtilityClass.showAlert("Success", message: (result as! NSDictionary).object(forKey: "message") as! String, vc: self)
            }
            else
            {
                UtilityClass.showAlert("Error", message: (result as! NSDictionary).object(forKey: "message") as! String, vc: self)
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
/*
                {
                    "status": true,
                    "update": false,
                    "message": "Ticktoc app new version available"
                }
*/
                self.viewMain.isHidden = false
                
                if let update = (result as! NSDictionary).object(forKey: "update") as? Bool {
                    
                    let alert = UIAlertController(title: nil, message: (result as! NSDictionary).object(forKey: "message") as? String, preferredStyle: .alert)
                    let UPDATE = UIAlertAction(title: "UPDATE", style: .default, handler: { ACTION in
                        
                        UIApplication.shared.openURL(NSURL(string: "itms://itunes.apple.com/us/app/ticktoc/id1034261915?ls=1&mt=8")! as URL)
                    })
                    let Cancel = UIAlertAction(title: "Cancel", style: .default, handler: { ACTION in
                        
                        if(SingletonClass.sharedInstance.isUserLoggedIN)
                        {
                            self.performSegue(withIdentifier: "segueToHomeVC", sender: nil)
                        }
                    })
                    alert.addAction(UPDATE)
                    alert.addAction(Cancel)
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    
                    if(SingletonClass.sharedInstance.isUserLoggedIN)
                    {
                        self.performSegue(withIdentifier: "segueToHomeVC", sender: nil)
                    }
                    
                }
           
//                if(SingletonClass.sharedInstance.isUserLoggedIN)
//                {
//                    self.performSegue(withIdentifier: "segueToHomeVC", sender: nil)
//                }
               
                
            }
            else {
                print(result)
/*
                {
                    "status": false,
                    "update": false,
                    "maintenance": true,
                    "message": "Server under maintenance, please try again after some time"
                }
*/
                if let update = (result as! NSDictionary).object(forKey: "update") as? Bool {
                    
                    if (update) {
//                        UtilityClass.showAlert("", message: (result as! NSDictionary).object(forKey: "message") as! String, vc: self)
                        
                        UtilityClass.showAlertWithCompletion("", message: (result as! NSDictionary).object(forKey: "message") as! String, vc: self, completionHandler: { ACTION in
                            
                            UIApplication.shared.openURL(NSURL(string: "itms://itunes.apple.com/us/app/ticktoc/id1034261915?ls=1&mt=8")! as URL)
                        })
                    }
                    else {
                        UtilityClass.showAlert("", message: (result as! NSDictionary).object(forKey: "message") as! String, vc: self)
                    }
                    
                }
/*
                {
                    "status": false,
                    "update": true,
                    "message": "Ticktoc app new version available, please upgrade your application"
                }
 */
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
    
    //MARK: - IBActions
    
    
    @IBAction func unwindToVC(segue: UIStoryboardSegue) {
    }
    
    
    @IBAction func btnLogin(_ sender: Any) {
        
        if (checkValidation())
        {
            self.btnLogin.startAnimation()
            
            self.webserviceCallForLogin()
        }
        else
        {
          
        }
    }
    
    
    @IBAction func btnForgotPassword(_ sender: UIButton) {
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Forgot Password?", message: "Enter E-Mail address", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "E-Mail"
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
