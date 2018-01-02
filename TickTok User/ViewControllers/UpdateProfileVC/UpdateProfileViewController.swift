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
    
    @IBOutlet var viewChangePassword: UIView!
    @IBOutlet var btnChangePassword: UIButton!
    @IBOutlet var btnProfile: UIButton!
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
        imgProfile.layer.borderColor = UIColor.red.cgColor
        imgProfile.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    @IBOutlet weak var viewMale: M13Checkbox!
    @IBOutlet weak var viewFemale: M13Checkbox!
  
    @IBOutlet weak var btnSave: UIButton!
    
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    @IBAction func btnMale(_ sender: UIButton) {
        
        viewMale.checkState = .checked
        viewMale.tintColor = UIColor.init(red: 204/255, green: 3/255, blue: 0, alpha: 1.0)
        viewFemale.checkState = .unchecked
        
        gender = "Male"
    }
    @IBAction func btnFemale(_ sender: UIButton) {
        
        viewFemale.checkState = .checked
        viewFemale.tintColor = UIColor.init(red: 204/255, green: 3/255, blue: 0, alpha: 1.0)
        viewMale.checkState = .unchecked
        
        gender = "Female"
    }
    
    
    
    @IBAction func btnChangePassword(_ sender: UIButton) {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        self.navigationController?.pushViewController(next, animated: true)

    }
    
    @IBAction func btnSubmit(_ sender: UIButton) {

        if txtAddress.text == "" || txtFirstName.text == "" || txtLastName.text == "" || gender == "" || imgProfile.image == nil {
            
            UtilityClass.showAlert("Misssing", message: "Please fill all details", vc: self)
        }
        else {
            webserviceOfUpdateProfile()
        }
        
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
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imgProfile.contentMode = .scaleToFill
            imgProfile.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    
    func setData() {
        
        let getData = SingletonClass.sharedInstance.dictProfile
        
        imgProfile.sd_setShowActivityIndicatorView(true)
        imgProfile.sd_setIndicatorStyle(.gray)
        imgProfile.sd_setImage(with: URL(string: getData.object(forKey: "Image") as! String), completed: nil)
        
        lblEmailId.text = getData.object(forKey: "Email") as? String
        lblContactNumber.text = getData.object(forKey: "MobileNo") as? String
        
        fullName = getData.object(forKey: "Fullname") as! String
  
        let fullNameArr = fullName.components(separatedBy: " ")
        
        firstName = fullNameArr[0]
        lastName = fullNameArr[1]

        txtFirstName.text = firstName
        txtLastName.text = lastName
        txtAddress.text = getData.object(forKey: "Address") as? String
        
        gender = getData.object(forKey: "Gender") as! String
        
        if gender == "male" || gender == "Male" {
            viewMale.checkState = .checked
            viewMale.tintColor = UIColor.init(red: 204/255, green: 3/255, blue: 0, alpha: 1.0)
            viewFemale.checkState = .unchecked
        }
        else {
            viewMale.checkState = .unchecked
            viewFemale.tintColor = UIColor.init(red: 204/255, green: 3/255, blue: 0, alpha: 1.0)
            viewFemale.checkState = .checked
        }
    }
    
    @IBAction func viewMale(_ sender: M13Checkbox) {
        
//        viewMale.checkState = .checked
//        viewMale.tintColor = UIColor.init(red: 204/255, green: 3/255, blue: 0, alpha: 1.0)
//        viewFemale.checkState = .unchecked
//
//        gender = "Male"
        
    }
    
    @IBAction func viewFemale(_ sender: M13Checkbox) {
        
        viewFemale.checkState = .checked
        viewFemale.tintColor = UIColor.init(red: 204/255, green: 3/255, blue: 0, alpha: 1.0)
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
        
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        
        webserviceForUpdateProfile(dictData as AnyObject, image1: imgProfile.image!) { (result, status) in
            
            if (status) {
                
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                
                print(result)
                SingletonClass.sharedInstance.dictProfile = NSMutableDictionary(dictionary: (result as! NSDictionary).object(forKey: "profile") as! NSDictionary)
                
                UserDefaults.standard.set(SingletonClass.sharedInstance.dictProfile, forKey: "profileData")
                
                UtilityClass.showAlert("", message: "Update Profile Successfully", vc: self)
                
                
            }
            else {
                print(result)
            }
        }
    }
    
    
}
