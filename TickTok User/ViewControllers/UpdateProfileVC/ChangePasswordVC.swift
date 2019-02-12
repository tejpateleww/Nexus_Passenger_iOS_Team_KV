//
//  ChangePasswordVC.swift
//  TickTok User
//
//  Created by Excellent Webworld on 11/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import ACFloatingTextfield_Swift

class ChangePasswordVC: UIViewController {

    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnSubmit.layer.cornerRadius = 5
        btnSubmit.layer.masksToBounds = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    

    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var txtNewPassword  : ACFloatingTextfield!
    @IBOutlet weak var txtConfirmPassword: ACFloatingTextfield!
    @IBOutlet weak var btnSubmit: UIButton!
    
    
    @IBAction func btnSubmit(_ sender: UIButton) {
     
        
       
        //binal
       
     if(isValidation())
     {
        if self.txtNewPassword.text == self.txtConfirmPassword.text {
                    let  str = self.txtNewPassword.text
                    if str!.count >= 8  {
                        self.webserviceOfChangePassword()
                        
                    }
                    else {
                        UtilityClass.setCustomAlert(title: "", message: "Password should be minimum 8 characters.") { (index, title) in
                        }
                    }
                }
                else {
                    UtilityClass.setCustomAlert(title: "Password did not match", message: "Password and confirm password must be same.") { (index, title) in
                    }
                }
        
            }
    
    }
    func isValidation() -> Bool
    {
            let  Str = self.txtNewPassword.text
        if txtNewPassword.text == " " || txtConfirmPassword.text == " "
        {
            UtilityClass.showAlert("", message: "we do not allow blank space.", vc:self)
            return false
        }
            
        else if(Str!.count < 8)
        {
            UtilityClass.showAlert("", message: "Please enter password maximum 8 character.", vc:self)
            return false
        }
        
        return true
    }
    
    
   
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    func webserviceOfChangePassword() {
        
    
        var dictData = [String:AnyObject]()
        
        dictData["PassengerId"] = SingletonClass.sharedInstance.strPassengerID as AnyObject
        dictData["Password"] = txtNewPassword.text as AnyObject
        
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        webserviceForChangePassword(dictData as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
                
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                
                self.txtNewPassword.text = ""
                self.txtConfirmPassword.text = ""
                
                UtilityClass.setCustomAlert(title: appName, message: (result as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                    
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: UpdateProfileViewController.self) {
                            self.navigationController!.popToViewController(controller, animated: true)
                            break
                        }
                    }
                    
//                    self.navigationController?.popViewController(animated: true)
                }
                
//                UtilityClass.showAlert("", message: (result as! NSDictionary).object(forKey: "message") as! String, vc: self)
                
                
            }
            else {
                 print(result)
                
                UtilityClass.setCustomAlert(title: appName, message: (result as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                    
                }
//                UtilityClass.setCustomAlert(title: <#T##String#>, message: <#T##String#>, completionHandler: { (<#Int#>, <#String#>) in
//
//                })
                
            }
        }
        
    }
    

}
