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
    
    @IBOutlet weak var txtNewPassword: ACFloatingTextfield!
    @IBOutlet weak var txtConfirmPassword: ACFloatingTextfield!
    @IBOutlet weak var btnSubmit: UIButton!
    
    
    @IBAction func btnSubmit(_ sender: UIButton) {
        
        let str = txtNewPassword.text
        
        if txtNewPassword.text == txtConfirmPassword.text {
        
            if str!.count >= 8  {
                webserviceOfChangePassword()
            }
            else {
                UtilityClass.setCustomAlert(title: "Missing", message: "Password should be minimum 8 characters.") { (index, title) in
            }
            }
        }
        else {
            UtilityClass.setCustomAlert(title: "Password did not match", message: "Please re-enter password") { (index, title) in
            }
        }
        
    }
    
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
                
                UtilityClass.setCustomAlert(title: "", message: (result as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
            }
                
//                UtilityClass.showAlert("", message: (result as! NSDictionary).object(forKey: "message") as! String, vc: self)
                
                self.navigationController?.popViewController(animated: true)
                
            }
            else {
                 print(result)
                
//                UtilityClass.setCustomAlert(title: <#T##String#>, message: <#T##String#>, completionHandler: { (<#Int#>, <#String#>) in
//                    <#code#>
//                })
                
            }
        }
        
    }
    

}
