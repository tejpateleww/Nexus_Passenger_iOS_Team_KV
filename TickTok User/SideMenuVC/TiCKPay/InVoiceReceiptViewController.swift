//
//  InVoiceReceiptViewController.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 16/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import M13Checkbox

class InVoiceReceiptViewController: ParentViewController, UIPickerViewDelegate, UINavigationControllerDelegate {

    let pickerView = UIPickerView()
    
    var pickerData: [String] = [String]()
    
    var strPaymentInputMethod =
        String()
    
     var BoolCurrentLocation = Bool()
    
    var strInvoiceType = String()
    var strCustomerName = String()
    var strTiCKPayId = String()
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        pickerData = ["Send Via…", "Send Via SMS", "Send Via Email"]
        
        self.pickerView.delegate = self
        
        txtPhoneNumber.isHidden = true
        txtEmailId.isHidden = true
        
        setEmail()
        
        txtTotalAmount.text = SingletonClass.sharedInstance.strAmoutOFTickPay
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    
//    @IBOutlet weak var txtSendVia: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtEmailId: UITextField!
    @IBOutlet weak var txtCustomerName: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var txtTotalAmount: UITextField!
    
    @IBOutlet weak var viewEmail: M13Checkbox!    
    @IBOutlet weak var viewSMS: M13Checkbox!
    
    
    //-------------------------------------------------------------
    // MARK: - Picker Methods
    //-------------------------------------------------------------
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        strPaymentInputMethod = pickerData[row]
        
        if row == 1 {
            
            txtPhoneNumber.isHidden = false
            txtEmailId.isHidden = true
            txtEmailId.text = ""
            strInvoiceType = "SMS"
        }
        else if row == 2 {
            txtPhoneNumber.isHidden = true
            txtPhoneNumber.text = ""
            txtEmailId.isHidden = false
            strInvoiceType = "Email"
        }
        else {
            txtPhoneNumber.isHidden = true
            txtEmailId.isHidden = true
            txtPhoneNumber.text = ""
            txtEmailId.text = ""
        }
        
        setTextFields()
    }
    
    func setTextFields() {
        
//        txtSendVia.text = strPaymentInputMethod
        
    }
    
    
    // For Mobile Number
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtPhoneNumber {
            let resultText: String? = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
            //            return (resultText?.count ?? 0) <= 10
            
            if resultText!.count >= 11 {
                return false
            }
            else {
                return true
            }
        }
        
        return true
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    @IBAction func btnEmail(_ sender: UIButton) {
        
        setEmail()
        
    }
    @IBAction func btnSMS(_ sender: UIButton) {
        
        setSMS()
    }
    
    func setEmail() {
        viewEmail.checkState = .checked
        viewEmail.tintColor = UIColor.init(red: 204/255, green: 3/255, blue: 0, alpha: 1.0)
        viewSMS.checkState = .unchecked
        
        txtPhoneNumber.isHidden = true
        txtPhoneNumber.text = ""
        txtEmailId.isHidden = false
        strInvoiceType = "Email"
    }
    
    func setSMS() {
        viewSMS.checkState = .checked
        viewSMS.tintColor = UIColor.init(red: 204/255, green: 3/255, blue: 0, alpha: 1.0)
        viewEmail.checkState = .unchecked
        
        txtPhoneNumber.isHidden = false
        txtEmailId.isHidden = true
        txtEmailId.text = ""
        strInvoiceType = "SMS"
    }
    
    @IBAction func txtSendVia(_ sender: UITextField) {
        
//        txtSendVia.inputView = pickerView
    }
    @IBAction func btnSend(_ sender: UIButton) {
   
        webserviceOFSendInvoice()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationOfCarAndTaxi = segue.destination as? TickPayAlertViewController {
            destinationOfCarAndTaxi.strBtnNo = "OK"
            destinationOfCarAndTaxi.strMessage = "Payment Receipt send successfully!"
            destinationOfCarAndTaxi.isBtnYesVisible = true

        }
        
    }
    
    func webserviceOFSendInvoice() {
        
//        TickpayId,InvoiceType,CustomerName,Notes,Amount,Email,MobileNo(InvoiceType : SMS/Email)
        
        var param = [String:AnyObject]()
        
        strTiCKPayId = SingletonClass.sharedInstance.strTickPayId
        
        if strInvoiceType == "" {
            UtilityClass.showAlert("", message: "Select Invoice Type", vc: self)
        }
        else {
            param["InvoiceType"] = strInvoiceType as AnyObject
        }
        
        param["TickpayId"] = strTiCKPayId as AnyObject
        
        if strInvoiceType == "SMS" {
            param["MobileNo"] = txtPhoneNumber.text as AnyObject
        }
        else {
            param["Email"] = txtEmailId.text as AnyObject
        }
        
        
        param["CustomerName"] = txtCustomerName.text as AnyObject
        param["Notes"] = txtDescription.text as AnyObject
        param["Amount"] = txtTotalAmount.text as AnyObject
        
        
        webserviceForSendInvoice(param as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
                
                SingletonClass.sharedInstance.strIsFirstTimeTickPay = "FromInVoice"
                
                self.navigationController?.popViewController(animated: true)
                
                
            }
            else{
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
