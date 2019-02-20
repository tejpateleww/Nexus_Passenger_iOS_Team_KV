//
//  RegisterViewController.swift
//  TickTok User
//
//  Created by Excellent Webworld on 25/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import ACFloatingTextfield_Swift

class RegisterViewController: UIViewController, UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate {
    
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
     var aryContoryNum = [[String:Any]]()
    let countoryz : Int = 0
    var imgflag = UIImageView()
    var countoryPicker = UIPickerView()
    @IBOutlet var txtContoryNum: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aryContoryNum = [["countoryCode" : "+1","countoryName" : "USA","countoryID" : "US", "countoryimage" : "US_Flag"]] as [[String : AnyObject]]
        
        txtPhoneNumber.delegate = self
        
        //        txtPhoneNumber.text = "1234567890"
        //        txtEmail.text = "rahul.bbit@gmail.com"
        //        txtPassword.text = "12345678"
        //        txtConfirmPassword.text = "12345678"
        
        let data = aryContoryNum[0]
        if let CountryCode:String = data["countoryCode"] as? String, let CountryId:String = data["countoryID"] as? String {
            self.txtContoryNum.text = "\(CountryId) \(CountryCode)"
        }
        //            self.txtContoryNum.text = data as? String
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
        leftView.backgroundColor = UIColor.clear
        
        imgflag = UIImageView(frame: CGRect(x: 10, y: 10, width: 25, height: 25))
        imgflag.image = UIImage(named:  data["countoryimage"] as? String ?? "")
        leftView.addSubview(imgflag)
        self.txtContoryNum.leftView = leftView
        self.txtContoryNum.leftViewMode = .always
        
        
        UtilityClass.setCornerRadiusTextField(textField: txtPhoneNumber, borderColor: UIColor.white, bgColor: UIColor.clear, textColor: UIColor.white)
        UtilityClass.setCornerRadiusTextField(textField: txtEmail, borderColor: UIColor.white, bgColor: UIColor.clear, textColor: UIColor.white)
        UtilityClass.setCornerRadiusTextField(textField: txtPassword, borderColor: UIColor.white, bgColor: UIColor.clear, textColor: UIColor.white)
        UtilityClass.setCornerRadiusTextField(textField: txtConfirmPassword, borderColor: UIColor.white, bgColor: UIColor.clear, textColor: UIColor.white)
        UtilityClass.setCornerRadiusTextField(textField: txtContoryNum, borderColor: UIColor.white, bgColor: UIColor.clear, textColor: UIColor.white)
        
        countoryPicker.delegate = self
        countoryPicker.dataSource = self
        
        txtContoryNum.inputView = countoryPicker
        self.setCornerToTextField(txtField: txtContoryNum)
        self.setCornerToTextField(txtField: txtPhoneNumber)
        self.setCornerToTextField(txtField: txtEmail)
        self.setCornerToTextField(txtField: txtPassword)
        self.setCornerToTextField(txtField: txtConfirmPassword)
//        txtPhoneNumber.placeHolderColor = UIColor.red
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.countoryPicker.reloadAllComponents()
        
        
    }
    
    func setCornerToTextField(txtField : UITextField)
    {
        txtField.layer.cornerRadius = txtField.frame.height / 2
        txtField.layer.borderColor = UIColor.white.cgColor
        txtField.layer.borderWidth = 1.0
    }
    //-------------------------------------------------------------
    // MARK: - TextField Delegate Method
    //-------------------------------------------------------------
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtPhoneNumber {
            let resultText: String? = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
            if textField == txtPhoneNumber && range.location == 0 {
                
                if string == "0" {
                    return false
                }
        
            }
            if resultText!.count >= 11 {
                return false
            }
            else {
                return true
            }
        }
        
        return true
    }
    func removeZeros(from anyString: String?) -> String? {
        if anyString?.hasPrefix("0") ?? false && (anyString?.count ?? 0) > 1 {
            return removeZeros(from: (anyString as NSString?)?.substring(from: 1))
        } else {
            return anyString
        }
    }
    
    @IBAction func textDidChange(_ sender: UITextField) {
        if !sender.text!.isEmpty {
            txtPhoneNumber.text = removeZeros(from: sender.text!)
        }
    }
    
    //-------------------------------------------------------------
    // MARK: - PickerView Methods
    //-------------------------------------------------------------
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return aryContoryNum.count
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        
        //        if pickerView == countoryPicker
        //        {
        //mainview
        let viewOfContryCode = UIView(frame: CGRect(x: 10, y: 5, width: countoryPicker.frame.size.width , height: 50))
        
        //image
        let imgOfCountry = UIImageView(frame: CGRect(x: 20 , y: 10 , width: 50, height: 30))
        
        //country Name
        let lblCountryName = UILabel(frame: CGRect(x: 80, y: 10, width: UIScreen.main.bounds.size.width - 160, height: 30))
        
        //labelNum
        let lblOfCountryNum = UILabel(frame: CGRect(x: UIScreen.main.bounds.size.width - 80, y: 10, width: 50, height: 30))
        //addsubview
        viewOfContryCode.addSubview(imgOfCountry)
        viewOfContryCode.addSubview(lblOfCountryNum)
        viewOfContryCode.addSubview(lblCountryName)
        let dictCountry = aryContoryNum[row]
        
        if let CountryCode:String = dictCountry["countoryCode"] as? String {
            lblOfCountryNum.text = CountryCode
        }
        if let CountryImg:String = dictCountry["countoryimage"] as? String {
            imgOfCountry.image = UIImage(named: CountryImg)
        }
        
        if let CountryName:String = dictCountry["countoryName"] as? String, let CountryId:String = dictCountry["countoryID"] as? String {
            lblCountryName.text = "\(CountryName) \(CountryId)"
        }
        
        
        // return mainview
        //        return viewOfContryCode
        
        //        }
        
        return viewOfContryCode
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        
        let data = aryContoryNum[row]
        if let CountryCode:String = data["countoryCode"] as? String, let CountryId:String = data["countoryID"] as? String {
            self.txtContoryNum.text = "\(CountryId) \(CountryCode)"
        }
        //            self.txtContoryNum.text = data as? String
        imgflag.image = UIImage(named:  data["countoryimage"] as? String ?? "")
        //            lblFlageCode.text = data["countoryCode"] as? String ?? ""
    }
    
    // MARK: - Navigation
    
    
    @IBAction func btnNext(_ sender: Any) {
        
        if (validateAllFields())
        {
            webserviceForGetOTPCode(email: txtEmail.text!, mobile: "1\(txtPhoneNumber.text!)")
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
    
    //-------------------------------------------------------------
    // MARK: - validation Email Methods
    //-------------------------------------------------------------
    
    func validateAllFields() -> Bool
    {
     
        let isEmailAddressValid = isValidEmailAddress(emailID: txtEmail.text!)
        
        if (txtPhoneNumber.text?.count == 0)
        {

            UtilityClass.setCustomAlert(title: "", message: "Please enter phone number") { (index, title) in
            }

            return false
        }
        else if ((txtPhoneNumber.text?.count)! < 10)
        {

            UtilityClass.setCustomAlert(title: "", message: "Please phone number should 10 digits") { (index, title) in
            }

            return false
        }
        else if (txtEmail.text?.count == 0)
        {
            UtilityClass.setCustomAlert(title: "", message: "Please enter email address") { (index, title) in
            }

            return false
        }
        else if (!isEmailAddressValid)
        {
            UtilityClass.setCustomAlert(title: "", message: "Please enter valid email id") { (index, title) in
            }

            return false
        }
        else if (txtPassword.text?.count == 0)
        {
            UtilityClass.setCustomAlert(title: "", message: "Please enter password") { (index, title) in
            }

            return false
        }
            
        else if ((txtPassword.text?.count)! < 6)
        {
            UtilityClass.setCustomAlert(title: "", message: "Password should be of more than 6 characters") { (index, title) in
            }

            return false
        }
        else if (txtPassword.text != txtConfirmPassword.text)
        {
            UtilityClass.setCustomAlert(title: "", message: "Password and Confirm Password does not match") { (index, title) in
            }

            return false
        }
       
        
        return true
    }
    
    
    func isValidEmailAddress(emailID: String) -> Bool
    {
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z)-9.-]+\\.[A-Za-z]{2,3}"
        
        do{
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailID as NSString
            let results = regex.matches(in: emailID, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
        }
        catch _ as NSError
        {
            returnValue = false
        }
        
        return returnValue
    }
    
    func setCustomAlert(title: String, message: String) {
        AJAlertController.initialization().showAlertWithOkButton(aStrTitle: title, aStrMessage: message) { (index,title) in
        }
     
    }
    
    func webserviceForGetOTPCode(email: String, mobile: String) {
        
//        Param : MobileNo,Email

        
        var param = [String:AnyObject]()
        param["MobileNo"] = mobile as AnyObject
        param["Email"] = email as AnyObject
        
        var boolForOTP = Bool()
        
        webserviceForOTPRegister(param as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
                
                let datas = (result as! [String:AnyObject])
                
                
                UtilityClass.showAlertWithCompletion("OTP Code", message: datas["message"] as! String, vc: self, completionHandler: { ACTION in
                    
                    if let otp = datas["otp"] as? String {
                        SingletonClass.sharedInstance.otpCode = otp
                    }
                    else if let otp = datas["otp"] as? Int {
                        SingletonClass.sharedInstance.otpCode = "\(otp)"
                    }
                    
                    
                    let registrationContainerVC = self.navigationController?.viewControllers.last as! RegistrationContainerViewController
                    registrationContainerVC.scrollObject.setContentOffset(CGPoint(x: self.view.frame.size.width, y: 0), animated: true)
                    registrationContainerVC.pageControl.set(progress: 1, animated: true)
                    
                })
                
//                UtilityClass.setCustomAlert(title: "OTP Code", message: datas["message"] as! String, completionHandler: { (index, title) in
//
//                    if let otp = datas["otp"] as? String {
//                        SingletonClass.sharedInstance.otpCode = otp
//                    }
//                    else if let otp = datas["otp"] as? Int {
//                        SingletonClass.sharedInstance.otpCode = "\(otp)"
//                    }
//
//
//                    let registrationContainerVC = self.navigationController?.viewControllers.last as! RegistrationContainerViewController
//                    registrationContainerVC.scrollObject.setContentOffset(CGPoint(x: self.view.frame.size.width, y: 0), animated: true)
//                    registrationContainerVC.pageControl.set(progress: 1, animated: true)
//
//
//                    let registrationContainerVC = self.navigationController?.viewControllers.last as! RegistrationContainerViewController
//                    registrationContainerVC.scrollObject.setContentOffset(CGPoint(x: self.view.frame.size.width, y: 0), animated: true)
//                    registrationContainerVC.pageControl.set(progress: 1, animated: true)
      
                
            }
            else {
                 print(result)
                
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
                
            }
        }
    }
    
}
