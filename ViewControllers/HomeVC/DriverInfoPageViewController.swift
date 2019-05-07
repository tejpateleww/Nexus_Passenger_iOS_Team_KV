//
//  DriverInfoPageViewController.swift
//  Nexus User
//
//  Created by EWW-iMac Old on 02/03/19.
//  Copyright © 2019 Excellent Webworld. All rights reserved.
//

import UIKit

class DriverInfoPageViewController: UIViewController {

    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var imgCar: UIImageView!
    @IBOutlet weak var imgDriver: UIImageView!
    @IBOutlet weak var lblCarInfoTitle: UILabel!
    @IBOutlet weak var lblCareName: UILabel!
    @IBOutlet weak var lblCarClass: UILabel!
    @IBOutlet weak var lblCarPlateNumber: UILabel!
     @IBOutlet weak var ratingDriver: FloatRatingView!
    @IBOutlet weak var lblPickupLocation: UILabel!
    @IBOutlet weak var lblDropoffLocation: UILabel!
    @IBOutlet var btnCall: UIButton!
    
   
    @IBOutlet weak var lblDriverInfoTitle: UILabel!
    @IBOutlet weak var lblDriverName: UILabel!
    
//    @IBOutlet weak var viewCarAndDriverInfo: UIView!
//    @IBOutlet weak var btnOk: ThemeButton!
//    @IBOutlet weak var lblDriverInfo: UILabel!
    
    @IBOutlet weak var lblDriverAddress: UILabel!
    @IBOutlet weak var lblDriverTotalTrips: UILabel!
    @IBOutlet weak var lblDriverDescription: UILabel!
    @IBOutlet weak var lblDriverLanguages: UILabel!
    
    @IBOutlet weak var lblDriverFunFacts: UILabel!
    @IBOutlet weak var lblDriverOtherThings: UILabel!
    @IBOutlet weak var lblDrivingReason: UILabel!
    @IBOutlet weak var tblDriverFeedback: UITableView!
    @IBOutlet weak var constraintFeedbackHeight: NSLayoutConstraint!
    
    var driverInfo = NSDictionary()
    var CarModelInfo = NSDictionary()
    var strCarImage = String()
    var strCareName = String()
    var strCarClass = String()
    var strPickupLocation = String()
    var strDropoffLocation = String()
    var strDriverImage = String()
    var strDriverName = String()
    var strCarPlateNumber = String()
    var strPassengerMobileNumber = String()

    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        setLocalization()
        
        fillAllFields()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
//        btnOk.layer.cornerRadius = 5
//        btnOk.layer.masksToBounds = true
//        viewCarAndDriverInfo.layer.cornerRadius = 5
//        viewCarAndDriverInfo.layer.masksToBounds = true
//        btnCallGreen.layer.cornerRadius = btnCallGreen.frame.width / 2
//        btnCallGreen.clipsToBounds = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
                imgCar.layer.cornerRadius = 37.5
                imgCar.layer.masksToBounds = true
                setupDriverDescriptionFields()
        //
//        imgDriver.layer.cornerRadius = imgDriver.frame.size.width / 2
//        imgDriver.layer.masksToBounds = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    func setupDriverDescriptionFields(){
        
        lblDriverAddress.text =  driverInfoStringValue(key: "Address")
        lblDriverTotalTrips.text = driverInfoStringValue(key: "TotalCompletedTrips")
        lblDriverDescription.text = driverInfoStringValue(key: "ShortDescription")
        lblDriverLanguages.text = driverInfoStringValue(key: "LanguagesKnown")
        lblDriverFunFacts.text = driverInfoStringValue(key: "FunFacts")
        lblDriverOtherThings.text = driverInfoStringValue(key: "OtherThings")
        lblDrivingReason.text = driverInfoStringValue(key: "ReasonDriverDrives")
        
        ratingDriver.rating = Float(String(describing: (driverInfo.object(forKey: "DriverRating") ?? ""))) ?? 0.0
        imgDriver.sd_setImage(with: URL(string: WebserviceURLs.kImageBaseURL + String(describing: (driverInfo.object(forKey: "Image") ?? ""))))
        imgDriver.clipsToBounds = true
    }
    
    func driverInfoStringValue(key: String)-> String{
        if let DriverInfoString = driverInfo.value(forKey: key) as? String {
            return ": " + DriverInfoString
        }
        else if let DriverInfoString = driverInfo.value(forKey: key) as? Int {
            return ": " + "\(DriverInfoString)"
        }
        return ": "
    }
    
    func setLocalization()
    {
        
//        lblDriverInfo.text = "Maelezo ya dereva".localized
        lblDriverName.text = "Jina la dereva".localized
        lblCareName.text = "Jina la Gari".localized
        lblPickupLocation.text = "Pickup Location".localized
        lblDropoffLocation.text = "Dropoff Location".localized
        
    }
    
    
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    @IBAction func btnClosed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnOK(_ sender: ThemeButton) {
        
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
        
//        if let driverImg = strDriverImage as? String {
//            imgDriver.sd_setShowActivityIndicatorView(true)
//            imgDriver.sd_setIndicatorStyle(.gray)
//            imgDriver.sd_setImage(with: URL(string: driverImg), completed: nil)
//        }
        
        lblCareName.text = strCareName
        lblCarPlateNumber.text = strCarPlateNumber
        
        lblPickupLocation.text = "Pickup Location : \(strPickupLocation)"
        lblDropoffLocation.text = "Dropoff Location : \(strDropoffLocation)"
        lblDriverName.text = strDriverName
//        if let CarModel = self.CarModelInfo["name"] as? String {
//            lblCarClass.text = CarModel
//        }
//        if strCarClass.count == 1 {
//            lblCarClass.text = carClass(strClass: strCarClass)
//        }
//        else {
            lblCarClass.text = strCarClass
//        }
    }
    
    @IBAction func btnCallToDriver(_ sender: UIButton) {
        
        let contactNumber = strPassengerMobileNumber
        
        if contactNumber == "" {
            
            UtilityClass.setCustomAlert(title: "", message: "Contact number is not available") { (index, title) in
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
    var feedback = NSArray()
    
}
////-------------------------------------------------------------
// MARK: - TableView Methods
//-------------------------------------------------------------

extension DriverInfoPageViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        constraintFeedbackHeight.constant = CGFloat(22 * feedback.count)
        return feedback.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DriverInfoTableViewCell.identifier, for: indexPath) as! DriverInfoTableViewCell
        if let feedback = feedback[indexPath.row] as? [String:Any]{
            cell.lblFeedBack.text = "-> " + (feedback["COMMENT"] as? String ?? "")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 20
    }
}
