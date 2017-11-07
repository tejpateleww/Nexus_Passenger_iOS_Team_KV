//
//  RegisterViewController.swift
//  TickTok User
//
//  Created by Excellent Webworld on 25/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import ACFloatingTextfield_Swift

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var txtPhoneNumber: ACFloatingTextfield!
    @IBOutlet weak var txtEmail: ACFloatingTextfield!
    @IBOutlet weak var txtPassword: ACFloatingTextfield!
    @IBOutlet weak var txtConfirmPassword: ACFloatingTextfield!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //        txtPhoneNumber.text = "1234567890"
        //        txtEmail.text = "rahul.bbit@gmail.com"
        //        txtPassword.text = "12345678"
        //        txtConfirmPassword.text = "12345678"
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Validation
    
    func checkValidation() -> Bool
    {
        if (txtPhoneNumber.text?.count == 0)
        {
            UtilityClass.showAlert("Enter Phone Number", message: "", vc: self)
            return false
        }
        else if ((txtPhoneNumber.text?.count)! > 10)
        {
            UtilityClass.showAlert("Phone Number should be less than 10 digits", message: "", vc: self)
            return false
        }
        else if (txtEmail.text?.count == 0)
        {
            UtilityClass.showAlert("Enter Email Address", message: "", vc: self)
            return false
        }
        else if (txtPassword.text?.count == 0)
        {
            UtilityClass.showAlert("Enter Password", message: "", vc: self)
            return false
        }
            
        else if ((txtPassword.text?.count)! < 6)
        {
            UtilityClass.showAlert("Password should be of more than 6 characters", message: "", vc: self)
            return false
        }
        else if (txtPassword.text != txtConfirmPassword.text)
        {
            UtilityClass.showAlert("Password and Confirm Password does not match", message: "", vc: self)
            return false
        }
        return true
    }
    
    
    
    
    // MARK: - Navigation
    
    
    @IBAction func btnNext(_ sender: Any) {
        
        if (checkValidation())
        {
            let registrationContainerVC = self.navigationController?.viewControllers.last as! RegistrationContainerViewController
            registrationContainerVC.scrollObject.setContentOffset(CGPoint(x: self.view.frame.size.width, y: 0), animated: true)
            registrationContainerVC.pageControl.set(progress: 1, animated: true)
        }
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
