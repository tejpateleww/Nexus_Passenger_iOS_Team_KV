//
//  EditAccountViewController.swift
//  TickTok User
//
//  Created by Excelent iMac on 23/12/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import ACFloatingTextfield_Swift

class EditAccountViewController: UIViewController {

    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var txtAccountHolderName: ACFloatingTextfield!
    @IBOutlet weak var txtABN: ACFloatingTextfield!
    @IBOutlet weak var txtBankName: ACFloatingTextfield!
    @IBOutlet weak var txtBSB: ACFloatingTextfield!
    @IBOutlet weak var txtBankAccount: ACFloatingTextfield!
    @IBOutlet weak var txtNote: ACFloatingTextfield!
    
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSave(_ sender: UIButton) {
        
        if (validationForUpdateBankAccountDetails()) {
            webserviceOFUpdateBankAccountDetails()
        }
       
    }
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    func validationForUpdateBankAccountDetails() -> Bool {
        
        if (txtAccountHolderName.text!.count == 0) {
            UtilityClass.showAlert("", message: "Enter Account Holeder Name", vc: self)
            return false
        }
        else if (txtABN.text!.count == 0) {
            UtilityClass.showAlert("", message: "Enter ABN Number", vc: self)
            return false
        }
        else if (txtBankName.text!.count == 0) {
            UtilityClass.showAlert("", message: "Enter Bank Name", vc: self)
            return false
        }
        else if (txtBSB.text!.count == 0) {
            UtilityClass.showAlert("", message: "Enter BSB Number", vc: self)
            return false
        }
        else if (txtBankAccount.text!.count == 0) {
            UtilityClass.showAlert("", message: "Enter Bank Account Number", vc: self)
            return false
        }
//        else if (txtNote.text!.count == 0) {
//            UtilityClass.showAlert("", message: "Enter Note", vc: self)
//            return false
//        }
        
        return true
    }
    
    func setData() {
        let profileData = SingletonClass.sharedInstance.dictProfile
        txtNote.text = profileData.object(forKey: "Description") as? String
        txtABN.text = profileData.object(forKey: "ABN") as? String
        txtBSB.text = profileData.object(forKey: "BSB") as? String
        txtBankName.text = profileData.object(forKey: "BankName") as? String
        txtBankAccount.text = profileData.object(forKey: "BankAccountNo") as? String
        txtAccountHolderName.text = profileData.object(forKey: "CompanyName") as? String
        
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    func webserviceOFUpdateBankAccountDetails() {
//        PassengerId,AccountHolderName,ABN,BankName,BSB,BankAccountNo,Description
        var param = [String:AnyObject]()
        param["PassengerId"] = SingletonClass.sharedInstance.strPassengerID as AnyObject
        param["AccountHolderName"] = txtAccountHolderName.text as AnyObject
        param["ABN"] = txtABN.text as AnyObject
        param["BankName"] = txtBankName.text as AnyObject
        param["BSB"] = txtBSB.text as AnyObject
        param["BankAccountNo"] = txtBankAccount.text as AnyObject
        param["Description"] = txtNote.text as AnyObject
        
        
        webserviceForUpdateBankAccountDetails(param as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
                
                UtilityClass.showAlert("", message: "Update Successfully.", vc: self)
                
                SingletonClass.sharedInstance.dictProfile = NSMutableDictionary(dictionary: (result as! NSDictionary).object(forKey: "profile") as! NSDictionary)
                
                 UserDefaults.standard.set(SingletonClass.sharedInstance.dictProfile, forKey: "profileData")
                    
//                    (result as! NSDictionary).object(forKey: "profile") as! NSMutableDictionary
                
                
/*
                    {
                        profile =     {
                            ABN = 1234;
                            Address = "";
                            BSB = qwer;
                            BankAccountNo = 0978645312;
                            BankName = bob;
                            CompanyName = Isco;
                            CreatedDate = "2017-11-24 06:36:31";
                            Description = hi;
                            DeviceType = 1;
                            Email = "bhavesh@excellentwebworld.info";
                            Fullname = "Bhavesh Odedra";
                            Gender = male;
                            Id = 36;
                            Image = "http://54.206.55.185/web/images/passenger/Image13";
                            Lat = 6287346872364287;
                            LicenceImage = "images/passenger/image16.png";
                            Lng = 6287346872364287;
                            MobileNo = 0987456321;
                            Password = 25d55ad283aa400af464c76d713c07ad;
                            QRCode = "images/qrcode/mrXc1tDi1sijkWNjjKCXoKqilWI=.png";
                            ReferralCode = tktcps36Bha;
                            Status = 1;
                            Token = cc958ac268a826a7cf92f9eb655985d5b8de2517e0e5a8432f88801ddd367134;
                            Verify = 1;
                        };
                        status = 1;
                }
 */
                
            }
            else {
                print(result)
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

}
