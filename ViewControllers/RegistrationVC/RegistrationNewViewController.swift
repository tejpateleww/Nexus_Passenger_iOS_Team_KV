//
//  RegistrationNewViewController.swift
//  TickTok User
//
//  Created by Excellent Webworld on 26/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import ACFloatingTextfield_Swift
import TransitionButton

class RegistrationNewViewController: UIViewController,AKRadioButtonsControllerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
 
    
    
    var strDateOfBirth = String()

    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    var radioButtonsController: AKRadioButtonsController!
    @IBOutlet var radioButtons: [AKRadioButton]!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    
    @IBOutlet weak var txtDateOfBirth: UITextField!
    @IBOutlet weak var txtRafarralCode: UITextField!
    
    @IBOutlet weak var imgProfile: UIImageView!

    var strPhoneNumber = String()
    var strEmail = String()
    var strPassword = String()
    var gender = String()
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.radioButtonsController = AKRadioButtonsController(radioButtons: self.radioButtons)
        self.radioButtonsController.strokeColor = ThemeNaviBlueColor//UIColor.init(red: 242/255, green: 21/255, blue: 65/255, alpha: 1)//UIColor.init(red: 255/255, green: 163/255, blue: 0, alpha: 1)binal
        self.radioButtonsController.startGradColorForSelected =  ThemeWhiteColor//UIColor.init(red: 242/255, green: 21/255, blue: 65/255, alpha: 1)//UIColor.init(red: 255/255, green: 163/255, blue: 0, alpha: 1)binal
        self.radioButtonsController.endGradColorForSelected = ThemeWhiteColor// UIColor.init(red: 242/255, green: 21/255, blue: 65/255, alpha: 1)//UIColor.init(red: 255/255, green: 163/255, blue: 0, alpha: 1)binal
        self.radioButtonsController.selectedIndex = 2
        self.radioButtonsController.delegate = self //class should implement AKRadioButtonsControllerDelegate
    
//        txtFirstName.text = "rahul"
//        txtLastName.text = "patel"
        self.setCornerToTextField(txtField: txtFirstName)
        self.setCornerToTextField(txtField: txtLastName)
        self.setCornerToTextField(txtField: txtRafarralCode)
        self.setCornerToTextField(txtField: txtDateOfBirth)

    }
    func setCornerToTextField(txtField : UITextField)
    {
        txtField.layer.cornerRadius = txtField.frame.height / 2
        txtField.layer.borderColor = UIColor.white.cgColor
        txtField.layer.borderWidth = 1.0
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.width/2
        self.imgProfile.layer.masksToBounds = true
        self.imgProfile.contentMode = .scaleAspectFill
    }
    
    func selectedButton(sender: AKRadioButton) {

        print(sender.currentTitle!)
        
        switch sender.currentTitle! {
            
        case "Male":
            gender = "male"
        case "Female":
            gender = "female"
        default:
            gender = "male"
        }
        
    }
    
    // MARK: - Pick Image
     func TapToProfilePicture() {
        
        let alert = UIAlertController(title: "Choose Options", message: nil, preferredStyle: .alert)
        
        let Gallery = UIAlertAction(title: "Gallery", style: .default, handler: { ACTION in
            self.PickingImageFromGallery()
        })
        let Camera  = UIAlertAction(title: "Camera", style: .default, handler: { ACTION in
            self.PickingImageFromCamera()
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(Gallery)
        alert.addAction(Camera)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func PickingImageFromGallery()
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        // picker.stopVideoCapture()
        picker.mediaTypes = [kUTTypeImage as String]
            //UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        
        setNavigationFontBlack()
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
    
    // MARK: - Image Delegate and DataSource Methods

    
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
    
    @IBAction func txtDateOfBirth(_ sender: ACFloatingTextfield) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.maximumDate = Date()
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.pickupdateMethod(_:)), for: UIControlEvents.valueChanged)
    }
    
    @objc func pickupdateMethod(_ sender: UIDatePicker)
    {
        let dateFormaterView = DateFormatter()
        dateFormaterView.dateFormat = "yyyy-MM-dd"
        txtDateOfBirth.text = dateFormaterView.string(from: sender.date)
        strDateOfBirth = txtDateOfBirth.text!
        
    }

    
   
    
    //MARK: - Validation
    
    func isValidateValue() -> (Bool,String) {
        var isValid:Bool = true
        var ValidatorMessage:String = ""
        
        if self.txtFirstName.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" {
          
            isValid = false
            ValidatorMessage = "Please enter first name."
        
        } else if self.txtLastName.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" {
            
            isValid = false
            ValidatorMessage = "Please enter last name."
        
        } else if self.strDateOfBirth == "" {
            
            isValid = false
            ValidatorMessage = "Please choose date of birth."
        
        } else if gender == "" {
            
            isValid = false
            ValidatorMessage = "Please choose gender."
        
        }
        return (isValid,ValidatorMessage)
    }
    
//    func checkValidation() -> Bool
//    {
//        if (txtFirstName.text?.count == 0)
//        {
//
//            UtilityClass.setCustomAlert(title: "", message: "Please enter first name") { (index, title) in
//            }
//            return false
//        }
//        else if (txtLastName.text?.count == 0)
//        {
//
//            UtilityClass.setCustomAlert(title: "", message: "Please enter last name") { (index, title) in
//            }
//            return false
//        }
////        else if imgProfile.image == UIImage(named: "iconProfilePicBlank")
////        {
////
////            UtilityClass.setCustomAlert(title: "", message: "Please choose profile picture") { (index, title) in
////            }
////            return false
////        }
//        else if strDateOfBirth == "" {
//
//            UtilityClass.setCustomAlert(title: "", message: "Please choose date of birth") { (index, title) in
//            }
//            return false
//        }
//        else if gender == "" {
//
//            UtilityClass.setCustomAlert(title: "", message: "Please choose gender") { (index, title) in
//            }
//            return false
//        }
//        return true
//    }
    
    
    //MARK: - IBActions
    
    @IBAction func btnChooseImage(_ sender: Any) {
        
        self.TapToProfilePicture()
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        
        let Validator = self.isValidateValue()
        
        if Validator.0 == true
        {
            let registerVC = (self.navigationController?.viewControllers.last as! RegistrationContainerViewController).childViewControllers[0] as! RegisterViewController
            
            strPhoneNumber = (registerVC.txtPhoneNumber.text)!
            strEmail = (registerVC.txtEmail.text)!
            strPassword = (registerVC.txtPassword.text)!
            
//            self.btnSignUp.startAnimation()
            
            webServiceCallForRegister()
        } else {
            UtilityClass.setCustomAlert(title: "", message: Validator.1) { (index, title) in
            }
        }
        
    }
    
    // MARK: - WebserviceCall
    
    func webServiceCallForRegister()
    {

        let dictParams = NSMutableDictionary()
        dictParams.setObject(txtFirstName.text!, forKey: "Firstname" as NSCopying)
        dictParams.setObject(txtLastName.text!, forKey: "Lastname" as NSCopying)
        dictParams.setObject(txtRafarralCode.text!, forKey: "ReferralCode" as NSCopying)
//        dictParams.setObject("1\(strPhoneNumber)", forKey: "MobileNo" as NSCopying)
        dictParams.setObject(strPhoneNumber, forKey: "MobileNo" as NSCopying)
        dictParams.setObject(strEmail, forKey: "Email" as NSCopying)
        dictParams.setObject(strPassword, forKey: "Password" as NSCopying)
        dictParams.setObject(SingletonClass.sharedInstance.deviceToken, forKey: "Token" as NSCopying)
        dictParams.setObject("1", forKey: "DeviceType" as NSCopying)
        dictParams.setObject(gender, forKey: "Gender" as NSCopying)
        dictParams.setObject("12376152367", forKey: "Lat" as NSCopying)
        dictParams.setObject("2348273489", forKey: "Lng" as NSCopying)
        dictParams.setObject(strDateOfBirth, forKey: "DOB" as NSCopying)
        
        webserviceForRegistrationForUser(dictParams, image1: imgProfile.image!) { (result, status) in
            
            
            print(result)
            
            if ((result as! NSDictionary).object(forKey: "status") as! Int == 1)
            {
                
                DispatchQueue.main.async(execute: { () -> Void in
                    
//                    self.btnSignUp.stopAnimation(animationStyle: .normal, completion: {
                    
                        SingletonClass.sharedInstance.dictProfile = NSMutableDictionary(dictionary: (result as! NSDictionary).object(forKey: "profile") as! NSDictionary)   
                        SingletonClass.sharedInstance.isUserLoggedIN = true
                        SingletonClass.sharedInstance.strPassengerID = String(describing: SingletonClass.sharedInstance.dictProfile.object(forKey: "Id")!)
                        SingletonClass.sharedInstance.arrCarLists = NSMutableArray(array: (result as! NSDictionary).object(forKey: "car_class") as! NSArray)
                        UserDefaults.standard.set(SingletonClass.sharedInstance.arrCarLists, forKey: "carLists")

                        UserDefaults.standard.set(SingletonClass.sharedInstance.dictProfile, forKey: "profileData")
                        (UIApplication.shared.delegate as! AppDelegate).GoToHome()
                    
//                        self.performSegue(withIdentifier: "segueToHomeVC", sender: nil)
//                    })
                })
                
            }
            else
            {
//                self.btnSignUp.stopAnimation(animationStyle: .shake, revertAfterDelay: 0, completion: {
                
                    UtilityClass.setCustomAlert(title: "", message: (result as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                    }
                    
//                })
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
