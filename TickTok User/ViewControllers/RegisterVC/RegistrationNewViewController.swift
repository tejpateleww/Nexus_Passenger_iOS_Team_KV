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
 
    

    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    var radioButtonsController: AKRadioButtonsController!
    @IBOutlet var radioButtons: [AKRadioButton]!
    @IBOutlet weak var txtFirstName: ACFloatingTextfield!
    @IBOutlet weak var txtLastName: ACFloatingTextfield!
    @IBOutlet weak var btnSignUp: TransitionButton!
    
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
        self.radioButtonsController.strokeColor = UIColor.red
        self.radioButtonsController.startGradColorForSelected = UIColor.red
        self.radioButtonsController.endGradColorForSelected = UIColor.red
        self.radioButtonsController.selectedIndex = 2
        self.radioButtonsController.delegate = self //class should implement AKRadioButtonsControllerDelegate
    
//        txtFirstName.text = "rahul"
//        txtLastName.text = "patel"
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
        case "Other":
            gender = "other"
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
    
    // MARK: - Image Delegate and DataSource Methods

    
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
    
   
    
    //MARK: - Validation
    
    func checkValidation() -> Bool
    {
        if (txtFirstName.text?.count == 0)
        {
            UtilityClass.showAlert("Enter First Name", message: "", vc: self)
            return false
        }
        else if (txtLastName.text?.count == 0)
        {
            UtilityClass.showAlert("Enter Last Name", message: "", vc: self)
            return false
        }
        return true
    }
    
    
    //MARK: - IBActions
    
    @IBAction func btnChooseImage(_ sender: Any) {
        
        self.TapToProfilePicture()
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        
        if (checkValidation())
        {
            let registerVC = (self.navigationController?.viewControllers.last as! RegistrationContainerViewController).childViewControllers[0] as! RegisterViewController
            
            strPhoneNumber = (registerVC.txtPhoneNumber.text)!
            strEmail = (registerVC.txtEmail.text)!
            strPassword = (registerVC.txtPassword.text)!
            
            self.btnSignUp.startAnimation()
            
            webServiceCallForRegister()
        }
        
    }
    
    // MARK: - WebserviceCall
    
    func webServiceCallForRegister()
    {

        let dictParams = NSMutableDictionary()
        dictParams.setObject(txtFirstName.text!, forKey: "Firstname" as NSCopying)
        dictParams.setObject(txtLastName.text!, forKey: "Lastname" as NSCopying)
        dictParams.setObject(strPhoneNumber, forKey: "MobileNo" as NSCopying)
        dictParams.setObject(strEmail, forKey: "Email" as NSCopying)
        dictParams.setObject(strPassword, forKey: "Password" as NSCopying)
        dictParams.setObject(SingletonClass.sharedInstance.deviceToken, forKey: "Token" as NSCopying)
        dictParams.setObject("1", forKey: "DeviceType" as NSCopying)
        dictParams.setObject(gender, forKey: "Gender" as NSCopying)
        dictParams.setObject("12376152367", forKey: "Lat" as NSCopying)
        dictParams.setObject("2348273489", forKey: "Lng" as NSCopying)
        
        
        webserviceForRegistrationForUser(dictParams, image1: imgProfile.image!) { (result, status) in
            
            
            print(result)
            
            if ((result as! NSDictionary).object(forKey: "status") as! Int == 1)
            {
                
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    self.btnSignUp.stopAnimation(animationStyle: .normal, completion: {
                        
                        SingletonClass.sharedInstance.dictProfile = NSMutableDictionary(dictionary: (result as! NSDictionary).object(forKey: "profile") as! NSDictionary)   
                        SingletonClass.sharedInstance.isUserLoggedIN = true
                        SingletonClass.sharedInstance.strPassengerID = String(describing: SingletonClass.sharedInstance.dictProfile.object(forKey: "Id")!)
                        SingletonClass.sharedInstance.arrCarLists = NSMutableArray(array: (result as! NSDictionary).object(forKey: "car_class") as! NSArray)
                        UserDefaults.standard.set(SingletonClass.sharedInstance.arrCarLists, forKey: "carLists")

                        UserDefaults.standard.set(SingletonClass.sharedInstance.dictProfile, forKey: "profileData")
                        self.performSegue(withIdentifier: "segueToHomeVC", sender: nil)
                    })
                })
                
            }
            else
            {
                self.btnSignUp.stopAnimation(animationStyle: .shake, revertAfterDelay: 0, completion: {
                    UtilityClass.showAlert("Error", message: (result as! NSDictionary).object(forKey: "message") as! String, vc: self)
                    
                })
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
