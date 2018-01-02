//
//  VerifyPasswordViewController.swift
//  TickTok User
//
//  Created by Excelent iMac on 22/12/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class VerifyPasswordViewController: UIViewController {

    var strStatusToNavigate = String()
    
    var aryImagesPassword = [String]()
    var aryImagesRetypePassword = [String]()
    
    
    var strPassword = String()
    var strRetypePassword = String()
    var strImages = String()
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var lblPasscode: UILabel!
    @IBOutlet var imgPasscodes: [UIImageView]!
    
    
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    
    @IBAction func btnNumberActions(_ sender: UIButton) {
        
        if strRetypePassword.count < 4 {
            
            strRetypePassword.append(sender.currentTitle!)
            print("strRetypePassword : \(strRetypePassword)")
            imgPasscodes[strRetypePassword.count-1].image = UIImage(named: "iconDot")
            
            aryImagesPassword.append("iconDot")
            
            if strRetypePassword.count == 4 {
                
                if SingletonClass.sharedInstance.setPasscode != strRetypePassword {
                    
                    lblPasscode.text = "Retype Password"
                    strRetypePassword.removeAll()
                    aryImagesPassword.removeAll()
                    
                    for i in 0..<imgPasscodes.count
                    {
                        imgPasscodes[i].image = UIImage(named: "iconLockStar")
                    }
                }
                else {
                    
                     SingletonClass.sharedInstance.passwordFirstTime = true
                    
                    if checkPresentation() {
                        
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                    else {
                        
                      
                        if strStatusToNavigate == "0" {
                            
                            let next = self.storyboard?.instantiateViewController(withIdentifier: "TickPayRegistrationViewController") as! TickPayRegistrationViewController
                            self.navigationController?.pushViewController(next, animated: true)
                            
                        }
                        else if strStatusToNavigate == "1" {
                            
                            let next = self.storyboard?.instantiateViewController(withIdentifier: "TiCKPayNeedToVarifyViewController") as! TiCKPayNeedToVarifyViewController
                            self.navigationController?.pushViewController(next, animated: true)
                            
                        }
                        else if strStatusToNavigate == "2" {
                            
                            let next = self.storyboard?.instantiateViewController(withIdentifier: "PayViewController") as! PayViewController
                            self.navigationController?.pushViewController(next, animated: true)
                            
                        }
                        else if strStatusToNavigate == "Wallet" {
                            let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletViewController") as! WalletViewController
                            self.navigationController?.pushViewController(next, animated: true)
                        }
                        
                    }
                }
                
            }
        }
    }
    
    func checkPresentation() -> Bool {
        if (presentingViewController != nil) {
            return true
        }
        if navigationController?.presentingViewController?.presentedViewController == navigationController {
            return true
        }
        if (tabBarController?.presentingViewController is UITabBarController) {
            return true
        }
        return false
    }
    
    @IBAction func btnForgotPasscode(_ sender: UIButton) {
        
        let msg = "If you can't remember your passcode, you must sign out from TiCKTOC and login with your email address and password."
        
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        let OK = UIAlertAction(title: "OK", style: .default, handler: { ACTIOn in
            
            let socket = (UIApplication.shared.delegate as! AppDelegate).SocketManager

            
            UserDefaults.standard.set(nil, forKey: "Passcode")

            self.performSegue(withIdentifier: "signOuyFromPasscode", sender: nil)
        })
        let Cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(OK)
        alert.addAction(Cancel)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func btnClearNumber(_ sender: UIButton) {
        
        if strRetypePassword.count < 4 && strRetypePassword.count != 0 {
            
            strRetypePassword.removeLast()
            aryImagesPassword.removeLast()
            
            if aryImagesPassword.count < 4 && aryImagesPassword.count >= 0
            {
                
                for i in 0..<imgPasscodes.count
                {
                    if aryImagesPassword.count > i {
                        imgPasscodes[i].image = UIImage(named: "iconDot")
                    }
                    else {
                        imgPasscodes[i].image = UIImage(named: "iconLockStar")
                    }
                    
                }
            }

            print("Removerd strRetypePassword = \(strRetypePassword)")
        }
        
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        
        if checkPresentation() {
            
            self.dismiss(animated: true, completion: nil)
        }
        else {
            self.navigationController?.popViewController(animated: true)
            
        }
    }
    
   

}
