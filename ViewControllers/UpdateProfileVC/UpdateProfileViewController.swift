//
//  UpdateProfileViewController.swift
//  TickTok User
//
//  Created by Excellent Webworld on 13/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import SDWebImage
import M13Checkbox
import NVActivityIndicatorView
import ACFloatingTextfield_Swift
import IQDropDownTextField


class UpdateProfileViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,IQDropDownTextFieldDelegate {
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblEmailId: UILabel!
    @IBOutlet weak var lblContactNumber: UILabel!
    var  imgUpdatedProfilePic = UIImage()
    @IBOutlet weak var txtFirstName: UITextField!
    //    @IBOutlet weak var txtLastName: UITextField!
//    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtDateOfBirth: UITextField!
    
    @IBOutlet weak var viewMale: M13Checkbox!
    @IBOutlet weak var viewFemale: M13Checkbox!
    
    @IBOutlet weak var btnSave: ThemeButton!
    @IBOutlet weak var btnChangePasssword: ThemeButton!
//    @IBOutlet var viewChangePassword: UIView!
//    @IBOutlet var btnChangePassword: UIButton!
//    @IBOutlet var btnProfile: UIButton!
    
    
    var firstName = String()
//    var lastName = String()
//    var fullName = String()
    var gender = String()
    var isimageSelected:Bool = false
    
//    @IBOutlet weak var viewFullName: UIView!
//    @IBOutlet weak var viewEmail: UIView!
//    @IBOutlet weak var viewMobile: UIView!
//    @IBOutlet weak var viewGender: UIView!
//    @IBOutlet weak var viewDateofBirth: UIView!
//    @IBOutlet weak var lblFullName: UILabel!
//    @IBOutlet weak var lblAddress: UILabel!
//    @IBOutlet weak var lblPhoneNum: UILabel!
//    @IBOutlet weak var lblDateOfBirth: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblMale: UILabel!
    @IBOutlet weak var lblFemale: UILabel!
//    @IBOutlet weak var btnSave: ThemeButton!
//    @IBOutlet var btnMale: RadioButton!
//    @IBOutlet var btnFemale: RadioButton!
    @IBOutlet weak var btnMale:UIButton!
    @IBOutlet weak var btnFemale:UIButton!
    @IBOutlet weak var btnCamera: UIButton!
//    @IBOutlet var iconCamera: UIImageView!
//    @IBOutlet var viewRadioGender: UIView!
    //    @IBOutlet var btnChangePassword: UIButton!
    //    @IBOutlet var btnProfile: UIButton!
//    @IBOutlet weak var btnChangePassword: UIButton!
    
    
    var isEditable = Bool()
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        txtDateOfBirth.delegate = self
     
//        self.btnMale.isSelected = true
//        self.txtPhoneNumber.isUserInteractionEnabled = false
 
//        self.setShadowToTextFieldView(txtField: txtFirstName)
//        self.setShadowToTextFieldView(txtField: txtAddress)
//        self.setShadowToTextFieldView(txtField: txtPhoneNumber)
//        self.setShadowToTextFieldView(txtField: txtDateOfBirth)
        
        
        UtilityClass.setLeftPaddingInTextfield(textfield: txtFirstName, padding: 10)
        UtilityClass.setLeftPaddingInTextfield(textfield: txtAddress, padding: 10)
//        UtilityClass.setLeftPaddingInTextfield(textfield: txtPhoneNumber, padding: 10)
        UtilityClass.setLeftPaddingInTextfield(textfield: txtDateOfBirth, padding: 10)
        
        UtilityClass.setRightPaddingInTextfield(textfield: txtFirstName, padding: 10)
        UtilityClass.setRightPaddingInTextfield(textfield: txtAddress, padding: 10)
//        UtilityClass.setRightPaddingInTextfield(textfield: txtPhoneNumber, padding: 10)
        UtilityClass.setRightPaddingInTextfield(textfield: txtDateOfBirth, padding: 10)
        
        viewMale.tintColor = ThemeNaviBlueColor
        viewFemale.tintColor = ThemeNaviBlueColor
        viewMale.boxType = .circle
        viewFemale.boxType = .circle
        setData()
//        viewRadioGender.layer.cornerRadius = 2
//        viewRadioGender.layer.shadowRadius = 3.0
//        viewRadioGender.layer.shadowColor = UIColor.black.withAlphaComponent(0.6).cgColor
//        viewRadioGender.layer.shadowOffset = CGSize (width: 1.0, height: 1.0)
//        viewRadioGender.layer.shadowOpacity = 1.0
        
//        btnSave.layer.cornerRadius = 5
//        btnSave.layer.masksToBounds = true
//          setViewWillAppear()
        }
//
    func setShadowToTextFieldView(txtField : UITextField)
    {
        txtField.layer.cornerRadius = 2
        txtField.layer.shadowRadius = 3.0
        txtField.layer.shadowColor = UIColor.black.withAlphaComponent(0.6).cgColor
        txtField.layer.shadowOffset = CGSize (width: 1.0, height: 1.0)
        txtField.layer.shadowOpacity = 1.0
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imgProfile.layer.cornerRadius = imgProfile.frame.width / 2
        imgProfile.layer.borderWidth = 1.0
        imgProfile.layer.borderColor = ThemeNaviBlueColor.cgColor
        imgProfile.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setLocalization()
        self.setNavBarWithBack(Title: "Profile".localized, IsNeedRightButton: false)
    }

    
    func setLocalization()
    {
       
//        lblFullName.text = "Full Name".localized
//        lblAddress.text = "Address".localized
//        lblPhoneNum.text = "Phone Number".localized
//        lblDateOfBirth.text =  "Date Of Birth".localized
        lblGender.text = "Gender".localized
        lblMale.text = "Male".localized
        lblFemale.text = "Female".localized
        
//        btnMale.setTitle("Male".localized, for: .normal)
//        btnFemale.setTitle("Female".localized, for: .normal)
        
        btnChangePasssword.setTitle("Change Password".localized, for: .normal)
        btnSave.setTitle("Save".localized, for: .normal)
    }


    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------

//    @IBAction func btnMale(_ sender: UIButton) {
//
//        viewMale.checkState = .checked
//        viewMale.tintColor = themeYellowColor
//        viewFemale.checkState = .unchecked
//
//        gender = "Male"
//    }
//    @IBAction func btnFemale(_ sender: UIButton) {
//
//        viewFemale.checkState = .checked
//        viewFemale.tintColor = themeYellowColor
//        viewMale.checkState = .unchecked
//
//        gender = "Female"
//    }
   
    @IBAction func txtDateOfBirthAction(_ sender: UITextField) {

        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.pickupdateMethod(_:)), for: UIControlEvents.valueChanged)
    }

    @objc func pickupdateMethod(_ sender: UIDatePicker)
    {
        let dateFormaterView = DateFormatter()
        dateFormaterView.dateFormat = "yyyy-MM-dd"
        
        txtDateOfBirth.text = dateFormaterView.string(from: sender.date)
    }
    func textField(_ textField: IQDropDownTextField, didSelect date: Date?)
    {
        

    }
    @IBAction func btnChangePassword(_ sender: UIButton) {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        self.navigationController?.pushViewController(next, animated: true)

    }
    
    @IBAction func btnGenderSelection(_ sender: UIButton) {
        
        viewFemale.checkState = .unchecked
        viewMale.checkState = .unchecked
        
        if sender.tag == 101 {
            viewMale.checkState = .checked
            gender = "Male"
        } else if sender.tag == 102 {
            viewFemale.checkState = .checked
            gender = "Female"
        }
    
    }
    
    
    
    @IBAction func btnSave(_ sender: ThemeButton) {
        
        let VAlidator = self.isProfileValidate()
        if VAlidator.0 == true {
            webserviceOfUpdateProfile()
            
        } else {
            UtilityClass.setCustomAlert(title: "", message: VAlidator.1) { (index, status) in
            }
        }
        
//        if txtAddress.text == "" || txtFirstName.text == "" || gender == "" {
//
//
//            UtilityClass.setCustomAlert(title: "Misssing", message: "Please fill all details".localized) { (index, title) in
//            }
//        }
//        else
//        {
//            webserviceOfUpdateProfile()
//        }
        
    }
    
    func isProfileValidate() -> (Bool,String) {
        var isValid:Bool = true
        var ValidatorMessage:String = ""
        
        if self.txtFirstName.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" {
            isValid  = false
            ValidatorMessage = "Please enter full name."
        } else if self.txtDateOfBirth.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" {
            isValid = false
            ValidatorMessage = "Please enter date of birth."
        } else if self.txtAddress.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" {
            isValid = false
            ValidatorMessage = "Please enter address."
        } else if gender == "" {
            isValid = false
            ValidatorMessage = "Please select gender."
        }
        return (isValid, ValidatorMessage)
    }
    
    
    @IBAction func btnUploadImage(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Choose Image From", message: nil, preferredStyle: .actionSheet)
        
        let Camera = UIAlertAction(title: "Camera", style: .default, handler: { ACTION in
            
            self.PickingImageFromCamera()
        })
        
        let Gallery = UIAlertAction(title: "Gallery", style: .default, handler: { ACTION in
            
             self.PickingImageFromGallery()
        })
        
        let Cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(Camera)
        alert.addAction(Gallery)
        alert.addAction(Cancel)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func PickingImageFromGallery()
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        // picker.stopVideoCapture()
        picker.mediaTypes = [kUTTypeImage as String]
            //UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    func PickingImageFromCamera()
    {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        
        present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imgProfile.contentMode = .scaleToFill
            imgProfile.image = pickedImage
            self.imgUpdatedProfilePic = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    
    func setData()
    {
        
        let getData = SingletonClass.sharedInstance.dictProfile
        
        imgProfile.sd_setShowActivityIndicatorView(true)
        imgProfile.sd_setIndicatorStyle(.gray)
        
        imgProfile.sd_setImage(with: URL(string: getData.object(forKey: "Image") as! String), completed: nil)
        
        
//        txtPhoneNumber.text = getData.object(forKey: "MobileNo") as? String
        txtDateOfBirth.text = getData.object(forKey: "DOB") as? String

        
//        fullName = getData.object(forKey: "Fullname") as! String
//
//        let fullNameArr = fullName.components(separatedBy: " ")
//        if fullNameArr.count == 1 {
//            firstName = fullNameArr[0]
//        } else if fullNameArr.count == 2 {
//            firstName = fullNameArr[0]
//            lastName = fullNameArr[1]
//        }

        txtFirstName.text = getData.object(forKey: "Fullname") as? String
        self.lblEmailId.text = getData.object(forKey: "Email") as? String
        self.lblContactNumber.text = getData.object(forKey: "MobileNo") as? String
        txtAddress.text = getData.object(forKey: "Address") as? String
        
        gender = getData.object(forKey: "Gender") as! String
        
        if gender == "male" || gender == "Male" {
            viewMale.checkState = .checked
        }
        else {
            viewFemale.checkState = .checked
        }
    }

    

    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    func webserviceOfUpdateProfile()
    {
//        fullName = txtFirstName.text! // + " " + txtLastName.text!
        
        var dictData = [String:AnyObject]()
        dictData["PassengerId"] = SingletonClass.sharedInstance.strPassengerID as AnyObject
        dictData["Fullname"] = txtFirstName.text as AnyObject
        dictData["Gender"] = gender as AnyObject
        dictData["Address"] = txtAddress.text as AnyObject
        dictData["DOB"] = txtDateOfBirth.text as AnyObject
        
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData,nil)
        
        webserviceForUpdateProfile(dictData as AnyObject, image1: self.imgUpdatedProfilePic ) { (result, status) in
            
            if (status) {
                
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                print(result)
                SingletonClass.sharedInstance.dictProfile = NSMutableDictionary(dictionary: (result as! NSDictionary).object(forKey: "profile") as! NSDictionary)
                UserDefaults.standard.set(SingletonClass.sharedInstance.dictProfile, forKey: "profileData")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateProfile") , object: nil)
                UtilityClass.setCustomAlert(title: "", message: "The profile has been updated successfully.") { (index, title) in
                    self.navigationController?.popViewController(animated: true)
                }
               
            }
            else {
                print(result)
            }
        }
    }
    
    
}
