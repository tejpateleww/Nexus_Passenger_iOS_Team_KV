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

class UpdateProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    var firstName = String()
    var lastName = String()
    var fullName = String()
    var gender = String()
    

    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setData()
        
        btnSave.layer.cornerRadius = 5
        btnSave.layer.masksToBounds = true
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imgProfile.layer.cornerRadius = imgProfile.frame.width / 2
        imgProfile.layer.borderWidth = 1.0
        imgProfile.layer.borderColor = ThemeBlueColor.cgColor
        imgProfile.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblEmailId: UILabel!
    @IBOutlet weak var lblContactNumber: UILabel!
    
    @IBOutlet weak var txtFirstName: ACFloatingTextfield!
    @IBOutlet weak var txtLastName: ACFloatingTextfield!
    @IBOutlet weak var txtAddress: ACFloatingTextfield!
    @IBOutlet weak var txtDateOfBirth: ACFloatingTextfield!
    
    @IBOutlet weak var viewMale: M13Checkbox!
    @IBOutlet weak var viewFemale: M13Checkbox!
  
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet var viewChangePassword: UIView!
    @IBOutlet var btnChangePassword: UIButton!
    @IBOutlet var btnProfile: UIButton!
    
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    @IBAction func btnMale(_ sender: UIButton) {
        
        viewMale.checkState = .checked
        viewMale.tintColor = ThemeBlueColor
        viewFemale.checkState = .unchecked
        
        gender = "Male"
    }
    @IBAction func btnFemale(_ sender: UIButton) {
        
        viewFemale.checkState = .checked
        viewFemale.tintColor = ThemeBlueColor
        viewMale.checkState = .unchecked
        
        gender = "Female"
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
    @IBAction func txtDateOfBirthAction(_ sender: ACFloatingTextfield) {
        
        
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
    
    @IBAction func btnChangePassword(_ sender: UIButton) {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        self.navigationController?.pushViewController(next, animated: true)

    }
    
    @IBAction func btnSubmit(_ sender: UIButton) {

        if validation() {
            webserviceOfUpdateProfile()
        }
    }
    
    func validation() -> Bool {
        
        if txtFirstName.text == "" {
            UtilityClass.setCustomAlert(title: appName, message: "Please enter first name") { (index, title) in
            }
            return false
        }
        else if txtAddress.text == "" {
            UtilityClass.setCustomAlert(title: appName, message: "Please enter address") { (index, title) in
            }
            return false
        }
        else if gender == "" {
            UtilityClass.setCustomAlert(title: appName, message: "Please choose gender") { (index, title) in
            }
            return false
        }
    
        return true
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
        
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        setNavigationFontBlack()
        // picker.stopVideoCapture()
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    func PickingImageFromCamera()
    {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        setNavigationFontBlack()
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imgProfile.contentMode = .scaleToFill
            imgProfile.image = pickedImage
        }
        setNavigationClear()
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        setNavigationClear()
        dismiss(animated: true, completion: nil)
    }

    
    func setData() {
        
        let getData = SingletonClass.sharedInstance.dictProfile
        
        imgProfile.sd_setShowActivityIndicatorView(true)
        imgProfile.sd_setIndicatorStyle(.gray)
        imgProfile.sd_setImage(with: URL(string: getData.object(forKey: "Image") as! String), completed: nil)
        
        lblEmailId.text = getData.object(forKey: "Email") as? String
        lblContactNumber.text = getData.object(forKey: "MobileNo") as? String
        txtDateOfBirth.text = getData.object(forKey: "DOB") as? String
        
        fullName = getData.object(forKey: "Fullname") as! String
  
        let fullNameArr = fullName.components(separatedBy: " ")
        
        firstName = fullNameArr[0]
        lastName = fullNameArr[1]

        txtFirstName.text = fullName
//        txtLastName.text = lastName
        txtAddress.text = getData.object(forKey: "Address") as? String
        
        gender = getData.object(forKey: "Gender") as! String
        
        if gender == "male" || gender == "Male" {
            viewMale.checkState = .checked
            viewMale.tintColor = ThemeBlueColor
            viewFemale.checkState = .unchecked
        }
        else {
            viewMale.checkState = .unchecked
            viewFemale.tintColor = ThemeBlueColor
            viewFemale.checkState = .checked
        }
    }
    
    @IBAction func viewMale(_ sender: M13Checkbox) {
        
//        viewMale.checkState = .checked
//        viewMale.tintColor = UIColor.init(red: 255/255, green: 163/255, blue: 0, alpha: 1.0)
//        viewFemale.checkState = .unchecked
//
//        gender = "Male"
        
    }
    
    @IBAction func viewFemale(_ sender: M13Checkbox) {
        
        viewFemale.checkState = .checked
        viewFemale.tintColor = ThemeBlueColor
        viewMale.checkState = .unchecked
        
        gender = "Female"
        
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
         self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    func webserviceOfUpdateProfile()
    {
        fullName = txtFirstName.text! + " " + txtLastName.text!
        
        var dictData = [String:AnyObject]()
        dictData["PassengerId"] = SingletonClass.sharedInstance.strPassengerID as AnyObject
        dictData["Fullname"] = fullName as AnyObject
        dictData["Gender"] = gender as AnyObject
        dictData["Address"] = txtAddress.text as AnyObject
        dictData["DOB"] = txtDateOfBirth.text as AnyObject
        
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        
        webserviceForUpdateProfile(dictData as AnyObject, image1: imgProfile.image!) { (result, status) in
             NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            
            if (status) {
                
               
                
                print(result)
                SingletonClass.sharedInstance.dictProfile = NSMutableDictionary(dictionary: (result as! NSDictionary).object(forKey: "profile") as! NSDictionary)
                
                UserDefaults.standard.set(SingletonClass.sharedInstance.dictProfile, forKey: "profileData")
                
                
                NotificationCenter.default.post(name: NotificationUpdateProfileOnSidemenu, object: nil)
               
                UtilityClass.setCustomAlert(title: "Done", message: "Update Profile Successfully") { (index, title) in
                }
            
            }
            else {
                print(result)
            }
        }
    }
    
    
}
