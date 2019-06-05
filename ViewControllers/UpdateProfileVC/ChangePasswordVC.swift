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

class ChangePasswordVC: BaseViewController {

    
    @IBOutlet weak var lblChangePassWorld: UILabel!
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.setNavBarWithBack(Title: "Change Password".localized, IsNeedRightButton: false)
        
        btnSubmit.layer.cornerRadius = 5
        btnSubmit.layer.masksToBounds = true
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         setLocalization()
    }
    
    func setLocalization()
    {
        
        lblChangePassWorld.text = "Change Password".localized
        txtNewPassword.placeholder = "New Password".localized
        txtConfirmPassword.placeholder = "Confirm Password".localized
        btnSubmit.setTitle("Submit".localized, for: .normal)
        
        
        
    }
    

    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    @IBOutlet weak var txtOldPassword: ACFloatingTextfield!
    @IBOutlet weak var txtNewPassword: ACFloatingTextfield!
    @IBOutlet weak var txtConfirmPassword: ACFloatingTextfield!

    
    @IBOutlet weak var btnSubmit: ThemeButton!
    
    
    @IBAction func btnSubmit(_ sender: ThemeButton) {
            let validator = self.isValidateValue()
            if validator.1 == true {
                    webserviceOfChangePassword()
            } else {
                UtilityClass.setCustomAlert(title: "", message: validator.0) { (index, title) in
                    
                }
            }
//        let str = txtNewPassword.text
//
//        if txtNewPassword.text == txtConfirmPassword.text {
//
//            if str!.count >= 8  {
//                webserviceOfChangePassword()
//            }
//            else {
//                UtilityClass.setCustomAlert(title: "", message: "Password must contain at least 8 characters".localized) { (index, title) in
//            }
//            }
//        }
//        else {
//            UtilityClass.setCustomAlert(title: "Password did not match", message: "Password and confirm password must be same".localized) { (index, title) in
//            }
//        }
//
    }
    
    
    func isValidateValue() -> (String,Bool) {
        var isValid:Bool  = true
        var ValidatorMessage:String = ""
        
        if self.txtOldPassword.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" {
            
            isValid = false
            ValidatorMessage = "Please enter old password."
            
        } else if self.txtNewPassword.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" {
            
            isValid = false
            ValidatorMessage = "Please enter new password."
            
        } else if self.txtConfirmPassword.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) != self.txtNewPassword.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) {
            
            isValid = false
            ValidatorMessage = "Password and confirm password must be same."
            
        }
        
        return (ValidatorMessage,isValid)
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
        dictData["OldPassword"] = txtOldPassword.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) as AnyObject
        dictData["Password"] = txtNewPassword.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) as AnyObject
        
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData,nil)
        
        webserviceForChangePassword(dictData as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
                
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                
                self.txtNewPassword.text = ""
                self.txtConfirmPassword.text = ""
                
                UtilityClass.setCustomAlert(title: "", message: (result as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                    
                    self.navigationController?.popViewController(animated: true)
            }
                
//                UtilityClass.showAlert("", message: (result as! NSDictionary).object(forKey: "message") as! String, vc: self)
                
                
            }
            else {
                 print(result)
                UtilityClass.setCustomAlert(title: "", message: (result as! NSDictionary).object(forKey: "message") as! String, completionHandler: { (index, title) in
                    
                })
                
//                UtilityClass.setCustomAlert(title: <#T##String#>, message: <#T##String#>, completionHandler: { (<#Int#>, <#String#>) in
//                    <#code#>
//                })
                
            }
        }
        
    }
    

}
