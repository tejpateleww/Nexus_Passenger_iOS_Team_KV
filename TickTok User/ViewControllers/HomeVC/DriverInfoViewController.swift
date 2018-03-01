//
//  DriverInfoViewController.swift
//  TickTok User
//
//  Created by Excelent iMac on 08/12/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import SDWebImage

class DriverInfoViewController: UIViewController {
    
    
    var strCarImage = String()
    var strCareName = String()
    var strCarClass = String()
    var strPickupLocation = String()
    var strDropoffLocation = String()
    
    var strDriverImage = String()
    var strDriverName = String()
    
    var strPassengerMobileNumber = String()
    

    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fillAllFields()
        
      
        
        btnOk.layer.cornerRadius = 5
        btnOk.layer.masksToBounds = true
        viewCarAndDriverInfo.layer.cornerRadius = 5
        viewCarAndDriverInfo.layer.masksToBounds = true
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imgCar.layer.cornerRadius = imgCar.frame.size.width / 2
        imgCar.layer.masksToBounds = true
        
        imgDriver.layer.cornerRadius = imgDriver.frame.size.width / 2
        imgDriver.layer.masksToBounds = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var imgCar: UIImageView!
    @IBOutlet weak var lblCareName: UILabel!
    @IBOutlet weak var lblCarClassModel: UILabel!
    @IBOutlet weak var lblPickupLocation: UILabel!
    @IBOutlet weak var lblDropoffLocation: UILabel!
    
    @IBOutlet weak var imgDriver: UIImageView!
    @IBOutlet weak var lblDriverName: UILabel!
    
    @IBOutlet weak var viewCarAndDriverInfo: UIView!
    
    @IBOutlet weak var btnOk: UIButton!
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    @IBAction func btnClosed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnOK(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnCall(_ sender: UIButton) {
        
        let contactNumber = strPassengerMobileNumber
        
        if contactNumber == "" {
            
            UtilityClass.setCustomAlert(title: "\(appName)", message: "Contact number is not available") { (index, title) in
            }
        }
        else {
            callNumber(phoneNumber: contactNumber)
        }
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    func fillAllFields() {
        
        if let carImg = strCarImage as? String {
            imgCar.sd_setShowActivityIndicatorView(true)
            imgCar.sd_setIndicatorStyle(.gray)
            imgCar.sd_setImage(with: URL(string: carImg), completed: nil)
        }
        
        if let driverImg = strDriverImage as? String {
            imgDriver.sd_setShowActivityIndicatorView(true)
            imgDriver.sd_setIndicatorStyle(.gray)
            imgDriver.sd_setImage(with: URL(string: driverImg), completed: nil)
        }
        
        lblCareName.text = strCareName
       
        lblPickupLocation.text = strPickupLocation
        lblDropoffLocation.text = strDropoffLocation
        lblDriverName.text = strDriverName
       
        if strCarClass.count == 1 {
            lblCarClassModel.text = carClass(strClass: strCarClass)
        }
        else {
            lblCarClassModel.text = strCarClass
        }
        
      
        
    }
    @IBAction func btnCallToDriver(_ sender: UIButton) {
        
        let contactNumber = strPassengerMobileNumber
        
        if contactNumber == "" {
    
            UtilityClass.setCustomAlert(title: "\(appName)", message: "Contact number is not available") { (index, title) in
            }
        }
        else {
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
    
    func carClass(strClass: String) -> String {
        
        switch strClass {
        case "1":
            return "Premium"
        case "2":
            return "Mini Car"
        case "3":
            return "VAN"
        case "4":
            return "Nano"
        case "5":
            return "Tuk Tuk"
        case "6":
            return "Breakdown Services"
        case "7":
            return "Bus"
//        case "8":
//            return "Motorbike"
//        case "9":
//            return "Car Delivery"
//        case "10":
//            return "Van / Trays"
//        case "11":
//            return "3T truck"
        default:
            return ""
        }
        
    }
    
}
