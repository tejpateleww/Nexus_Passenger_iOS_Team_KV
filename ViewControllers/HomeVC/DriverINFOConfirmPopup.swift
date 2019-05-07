//
//  DriverINFOConfirmPopup.swift
//  Nexus User
//
//  Created by EWW082 on 25/04/19.
//  Copyright © 2019 Excellent Webworld. All rights reserved.
//

import UIKit

protocol ConfirmedDriverDelegate {
    func didConfirmDriverDetail()
    func didConfirmDriverDetailBookLater()
}

class DriverINFOConfirmPopup: UIViewController {
    
    var Delegate:ConfirmedDriverDelegate!
    
    @IBOutlet var imgDriverProfilePic: UIImageView!
    @IBOutlet var lblDriverName: UILabel!
    @IBOutlet var lblVehicleMake: UILabel!
    @IBOutlet var lblVehicleModel: UILabel!
    @IBOutlet var lblVehicleColor: UILabel!
    @IBOutlet var lblNumberPlate: UILabel!
    @IBOutlet var lblMessage: UILabel!
    
    var DriverInfo:[String:Any] = [:]
    var CarInfo:[String:Any] = [:]
    var ModelInfo:[String:Any] = [:]
    
    var ArrivedMessage:String = ""
    
    var isBookNow:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(DriverInfo)
        self.setAllFields()
        
        // Do any additional setup after loading the view.
    }
    
    func setAllFields() {
        self.imgDriverProfilePic.layer.cornerRadius = 27.5
        self.imgDriverProfilePic.layer.masksToBounds  = true
        self.imgDriverProfilePic.layer.borderColor = ThemeNaviBlueColor.cgColor
        self.imgDriverProfilePic.layer.borderWidth = 1.0
        
        if let VehicleImageName = CarInfo["VehicleImage"] as? String {
            let carImg = WebserviceURLs.kImageBaseURL + VehicleImageName
            imgDriverProfilePic.sd_setShowActivityIndicatorView(true)
            imgDriverProfilePic.sd_setIndicatorStyle(.gray)
            imgDriverProfilePic.sd_setImage(with: URL(string: carImg)! , completed: nil)
        }
        self.lblMessage.text = ArrivedMessage
        self.lblDriverName.text  = self.driverInfoStringValue(key: "Fullname")
        self.lblVehicleMake.text = self.carInfoStringValue(key: "Company")
        if let Model = CarInfo["Model"] as? [String:Any] {
            self.lblVehicleModel.text = " : \((Model["Name"] as! String))"
        } else if let ModelName =  ModelInfo["Name"] as? String {
            self.lblVehicleModel.text = " : \(ModelName)"
        }
        self.lblVehicleColor.text = self.carInfoStringValue(key: "Color")
        self.lblNumberPlate.text = self.carInfoStringValue(key: "VehicleRegistrationNo")
        
    }
    
    
    func driverInfoStringValue(key: String)-> String{
        return " : " + String(describing: (DriverInfo[key] ?? ""))
    }

    func carInfoStringValue(key: String)-> String{
        return " : " + String(describing: (CarInfo[key] ?? ""))
    }
    // MARK:- IBAction Methods
    
    @IBAction func btnOkAction(_ sender: Any) {
        self.dismiss(animated: true) {
            if self.isBookNow {
                self.Delegate.didConfirmDriverDetail()
            } else {
                self.Delegate.didConfirmDriverDetailBookLater()
            }
        }
      
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
