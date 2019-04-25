//
//  LoginVC.swift
//  Nexus User
//
//  Created by EWW-iMac Old on 21/02/19.
//  Copyright © 2019 Excellent Webworld. All rights reserved.
//

import Foundation
import UIKit
//import TransitionButton
import ACFloatingTextfield_Swift
//import SideMenu
import NVActivityIndicatorView
import CoreLocation
import SocketIO
import FBSDKLoginKit
import FacebookLogin
import GoogleSignIn

class LoginVC: UIViewController, CLLocationManagerDelegate, alertViewMethodsDelegates,GIDSignInDelegate,GIDSignInUIDelegate  {

    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    @IBOutlet weak var viewMain: UIView!
    
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignup: UIButton!
    
    
    var locationManager = CLLocationManager()
    var strURLForSocialImage = String()
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
    func setCornerToTextField(txtField : UITextField)
    {
        txtField.layer.cornerRadius = txtField.frame.height / 2
        txtField.layer.borderColor = UIColor.white.cgColor
        txtField.layer.borderWidth = 1.0
    }
    func setCornerToButton(BTN : UIButton , bgColor : UIColor, BorderColor : UIColor, textcolor : UIColor)
    {
        BTN.layer.cornerRadius = BTN.frame.height / 2
        BTN.layer.borderColor = BorderColor.cgColor
        BTN.layer.borderWidth = 1.0
        BTN.backgroundColor = bgColor
        BTN.setTitleColor(textcolor, for: .normal)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewMain.isHidden = false
        
        //        txtEmail.lineColor = UIColor.white
        //        txtPassword.lineColor = UIColor.white`
        
//        if UIDevice.current.name == "Bhavesh iPhone" || UIDevice.current.name == "Excellent Web's iPhone 5s" || UIDevice.current.name == "Rahul's iPhone" ||  UIDevice.current.name == "iOS2’s iPad" ||  UIDevice.current.name == "Excellent iPhone 7" || UIDevice.current.name ==  "Mayur's iPhone X" || UIDevice.current.name ==  "EWW iPhone" {
//
//            txtPassword.text = "12345678"
//            txtEmail.text = "bhavesh@excellentwebworld.info" // "bhavesh@excellentwebworld.info"
//        }
//
//        #if targetEnvironment(simulator)
//        txtPassword.text = "12345678"
//        txtEmail.text = "bhavesh@yahoo.com" // "bhavesh@excellentwebworld.info"
//        #endif
//
        
        self.setCornerToTextField(txtField: txtEmail)
        self.setCornerToTextField(txtField: txtPassword)
        
        self.setCornerToButton(BTN: btnLogin, bgColor: UIColor.white, BorderColor: UIColor.white, textcolor: ThemeNaviBlueColor)
        self.setCornerToButton(BTN: btnSignup, bgColor: UIColor.clear, BorderColor: UIColor.white, textcolor: UIColor.white)
        
        //        #if DEBUG
        //        UtilityClass.showAlert("Debug", message: "This is Debuging Mode", vc: self)
        //        #elseif release
        //        UtilityClass.showAlert("Live", message: "This is Live Mode", vc: self)
        //        #endif
     
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
    
    func isValidateValue() -> (Bool,String) {
        var isValid:Bool = true
        var ValidatorMessage:String = ""
        
        if self.txtEmail.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" {
            
            isValid = false
            ValidatorMessage = "Please enter email or mobile number."
            
        } else if self.txtPassword.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" {
            
            isValid = false
            ValidatorMessage = "Please enter password"
            
        }
        
        return (isValid,ValidatorMessage)
    }
    
//    func checkValidation() -> Bool
//    {
//        if (txtEmail.text?.count == 0)
//        {
//
//            UtilityClass.setCustomAlert(title: "", message: "Please enter email") { (index, title) in
//            }
//
//            // txtEmail.showErrorWithText(errorText: "Enter Email")
//            return false
//        }
//        else if (txtPassword.text?.count == 0)
//        {
//
//            UtilityClass.setCustomAlert(title: "", message: "Please enter password") { (index, title) in
//            }
//
//            return false
//        }
//        return true
//    }
    
    
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
                (UIApplication.shared.delegate as! AppDelegate).GoToHome()
                
//                self.performSegue(withIdentifier: "segueToHomeVC", sender: nil)
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
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData,nil)
        webserviceForForgotPassword(dictparam) { (result, status) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            
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
                            homeVC.socket.off(SocketData.kArrivedDriverBookNowRequest)
                            homeVC.socket.off(SocketData.kArrivedDriverBookLaterRequest)
                            
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
                            homeVC.socket.off(SocketData.kArrivedDriverBookNowRequest)
                            homeVC.socket.off(SocketData.kArrivedDriverBookLaterRequest)
                            
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
    
    
    //MARK: - IBActions
    
//    @IBAction func unwindToVC(segue: UIStoryboardSegue) {
//    }
    
    
    @IBAction func btnGoogleClicked(_ sender: Any) {
        if Connectivity.isConnectedToInternet() == false {
            
            UtilityClass.setCustomAlert(title: "Connection Error", message: "Internet connection not available") { (index, title) in
            }
            return
        }
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self as GIDSignInUIDelegate
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    //MARK: - Google SignIn Delegate -
    
    func signInWillDispatch(signIn: GIDSignIn!, error: Error!)
    {
        // myActivityIndicator.stopAnimating()
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        UIApplication.shared.statusBarStyle = .default
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!)
    {
        UIApplication.shared.statusBarStyle = .lightContent
        self.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
    {
        
        if (error == nil)
        {
            // Perform any operations on signed in user here.
            let userId : String = user.userID // For client-side use only!
            let firstName : String  = user.profile.givenName
            let lastName : String  = user.profile.familyName
            let email : String = user.profile.email
            
            var dictUserData = [String: AnyObject]()
            var image = UIImage()
            if user.profile.hasImage
            {
                let pic = user.profile.imageURL(withDimension: 400)
                let imgUrl: String = (pic?.absoluteString)!
                print(imgUrl)
                self.strURLForSocialImage = imgUrl
                let url = URL(string: imgUrl as! String)
                let data = try? Data(contentsOf: url!)
                
                if let imageData = data {
                    image = UIImage(data: imageData)!
                }else {
                    image = UIImage(named: "iconUser")!
                }
                
                //                dictUserData["image"] = strImage as AnyObject
            }
            
            //            var strFullName = ""
            //
            //            if Utili !Utilities.isEmpty(str: firstName)
            //            {
            //                strFullName = strFullName + ("\(firstName)")
            //            }
            //            if !Utilities.isEmpty(str: strFullName) {
            //                strFullName = strFullName + (" \(lastName)")
            //            }
            
            
            //            dictUserData["profileimage"] = "" as AnyObject
            SingletonClass.sharedInstance.strSocialFirstName = firstName
            SingletonClass.sharedInstance.strSocialLastName = lastName
            dictUserData["Firstname"] = firstName as AnyObject
            dictUserData["Lastname"] = lastName as AnyObject
            dictUserData["Email"] = email as AnyObject
            dictUserData["MobileNo"] = "" as AnyObject
            dictUserData["Lat"] = "6287346872364287" as AnyObject
            dictUserData["Lng"] = "6287346872364287" as AnyObject
            dictUserData["SocialId"] = userId as AnyObject
            dictUserData["SocialType"] = "Google" as AnyObject
            dictUserData["Token"] = SingletonClass.sharedInstance.deviceToken as AnyObject
            dictUserData["DeviceType"] = "1" as AnyObject
            self.webserviceForSocilLogin(dictUserData as AnyObject, ImgPic: image, socialId: userId, SocialType:"Google")
        }
        else
        {
            print("\(error.localizedDescription)")
        }
        
    }
    
    //MARK: - Webservice methods -
    func webserviceForSocilLogin(_ dictData : AnyObject, ImgPic : UIImage, socialId:String, SocialType:String)
    {
        webserviceForSocialLogin(dictData as AnyObject, image1: ImgPic, showHUD: true) { (result, status) in
     
            if(status)
            {
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    SingletonClass.sharedInstance.dictProfile = NSMutableDictionary(dictionary: (result as! NSDictionary).object(forKey: "profile") as! NSDictionary)
                    SingletonClass.sharedInstance.arrCarLists = NSMutableArray(array: (result as! NSDictionary).object(forKey: "car_class") as! NSArray)
                    SingletonClass.sharedInstance.strPassengerID = String(describing:SingletonClass.sharedInstance.dictProfile.object(forKey: "Id")!)//as! String
                    SingletonClass.sharedInstance.isUserLoggedIN = true
                    
                    
                    UserDefaults.standard.set(SingletonClass.sharedInstance.dictProfile, forKey: "profileData")
                    UserDefaults.standard.set(SingletonClass.sharedInstance.arrCarLists, forKey: "carLists")
                    
                    
                    self.webserviceForAllDrivers()
                    
                    
                    //                    self.btnLogin.stopAnimation(animationStyle: .normal, completion: {
                    //
                    ////                        self.performSegue(withIdentifier: "segueToHomeVC", sender: nil)
                    //                    })
                })
                
                //                let dictData = result as! [String : AnyObject]
//                SingletonClass.sharedInstance.dictProfile = NSMutableDictionary(dictionary: (result as! NSDictionary).object(forKey: "profile") as! NSDictionary)
//                SingletonClass.sharedInstance.arrCarLists = NSMutableArray(array: (result as! NSDictionary).object(forKey: "car_class") as! NSArray)
//                SingletonClass.sharedInstance.strPassengerID = String(describing: SingletonClass.sharedInstance.dictProfile.object(forKey: "Id")!)//as! String
//                SingletonClass.sharedInstance.isUserLoggedIN = true
//
//                UserDefaults.standard.set(SingletonClass.sharedInstance.dictProfile, forKey: "profileData")
//                UserDefaults.standard.set(SingletonClass.sharedInstance.arrCarLists, forKey: "carLists")
//
//                self.webserviceForAllDrivers()
                //                let dict = dictData["profile"] as! [String : AnyObject]
                //                let tempID = dict["Id"] as? String
                
            }
            else
            {
                print(result)
                if let res = result as? String
                {
                    UtilityClass.showAlert(appName, message: res, vc: self)
                }
                else if let resDict = result as? NSDictionary
                {
                    //                    Utilities.showAlert(appName, message: resDict.object(forKey: "message") as! String, vc: self)
                    let RegisterStoryBoard = UIStoryboard(name: "Registration", bundle: nil)
                    let viewController = RegisterStoryBoard.instantiateViewController(withIdentifier: "RegistrationContainerViewController") as? RegistrationContainerViewController
                    
                    SingletonClass.sharedInstance.strSocialEmail = dictData["Email"] as! String
                    SingletonClass.sharedInstance.strSocialFirstName = "\(dictData["Firstname"] as! String)"
                    SingletonClass.sharedInstance.strSocialLastName = "\(dictData["Lastname"] as! String)"
                    SingletonClass.sharedInstance.strSocialImage = self.strURLForSocialImage
                     self.navigationController?.pushViewController(viewController!, animated: true)
                    
                }
                else if let resAry = result as? NSArray
                {
                    UtilityClass.showAlert(appName, message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
                }
//                UtilityClass.setCustomAlert(title: "", message: (result as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
//                }
            }
        }
    }
    
    
    @IBAction func btnFBClicked(_ sender: Any) {
        
        if Connectivity.isConnectedToInternet() == false {
            
            UtilityClass.setCustomAlert(title: "Connection Error", message: "Internet connection not available") { (index, title) in
            }
            return
        }
        let login = FBSDKLoginManager()
        login.loginBehavior = FBSDKLoginBehavior.browser
        UIApplication.shared.statusBarStyle = .default
        login.logOut()
        login.logIn(withReadPermissions: ["public_profile","email"], from: self) { (result, error) in
            
            
            if error != nil
            {
                UIApplication.shared.statusBarStyle = .lightContent
            }
            else if (result?.isCancelled)!
            {
                UIApplication.shared.statusBarStyle = .lightContent
            }
            else
            {
                if (result?.grantedPermissions.contains("email"))!
                {
                    UIApplication.shared.statusBarStyle = .lightContent
                    self.getFBUserData()
                }
                else
                {
                    print("you don't have permission")
                }
            }
        }
        
    }
    
    
    //function is fetching the user data from Facebook
    
    func getFBUserData()
    {
        
        //        Utilities.showActivityIndicator()
        
        var parameters = [AnyHashable: Any]()
        parameters["fields"] = "first_name, last_name, picture, email,id"
        
        FBSDKGraphRequest.init(graphPath: "me", parameters: parameters).start { (connection, result, error) in
            if error == nil
            {
                print("\(#function) \(result)")
                let dictData = result as! [String : AnyObject]
                let strFirstName = String(describing: dictData["first_name"]!)
                let strLastName = String(describing: dictData["last_name"]!)
                let strEmail = String(describing: dictData["email"]!)
                let strUserId = String(describing: dictData["id"]!)
                
                //                //NSString *strPicurl = [NSString stringWithFormat:@"%@",[[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]];
                let imgUrl = ((dictData["picture"] as! [String:AnyObject])["data"]  as! [String:AnyObject])["url"] as? String
                
                //                var imgUrl = "http://graph.facebook.com/\(strUserId)/picture?type=large"
                
                
                
                //                let pictureDict = self.report["picture"]!["data"] as AnyObject
                //                let imgUrl = pictureDict["url"] as AnyObject
                
                var image = UIImage()
                let url = URL(string: imgUrl as! String)
                self.strURLForSocialImage = imgUrl!
                let data = try? Data(contentsOf: url!)
                
                if let imageData = data {
                    image = UIImage(data: imageData)!
                }else {
                    image = UIImage(named: "iconUser")!
                }
                
                var dictUserData = [String: AnyObject]()
                dictUserData["Firstname"] = strFirstName as AnyObject
                dictUserData["Lastname"] = strLastName as AnyObject
                dictUserData["Email"] = strEmail as AnyObject
                dictUserData["MobileNo"] = "" as AnyObject
                dictUserData["Lat"] = "6287346872364287" as AnyObject
                dictUserData["Lng"] = "6287346872364287" as AnyObject
                dictUserData["SocialId"] = strUserId as AnyObject
                dictUserData["SocialType"] = "Facebook" as AnyObject
                dictUserData["Token"] = SingletonClass.sharedInstance.deviceToken as AnyObject
                dictUserData["DeviceType"] = "1" as AnyObject
                
                self.webserviceForSocilLogin(dictUserData as AnyObject, ImgPic: image, socialId: strUserId,SocialType: "Facebook")
                
                //                self.APIcallforSocialMedia(dictParam: dictUserData)
                
                //                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
                //                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    
    @IBAction func btnLogin(_ sender: Any) {
        let Validator = self.isValidateValue()
        
        if Validator.0 == true {
            //            self.btnLogin.startAnimation()
            self.webserviceCallForLogin()
        } else {
            UtilityClass.setCustomAlert(title: "", message: Validator.1) { (index, title) in
            }
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
