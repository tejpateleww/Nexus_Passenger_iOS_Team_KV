//
//  DriverINFOConfirmPopup.swift
//  Nexus User
//
//  Created by EWW082 on 25/04/19.
//  Copyright © 2019 Excellent Webworld. All rights reserved.
//

import UIKit

class DriverINFOConfirmPopup: UIViewController {

    
    @IBOutlet var imgDriverProfilePic: UIImageView!
    @IBOutlet var lblDriverName: UILabel!
    @IBOutlet var lblVehicleMake: UILabel!
    @IBOutlet var lblVehicleModel: UILabel!
    @IBOutlet var lblVehicleColor: UILabel!
    @IBOutlet var lblNumberPlate: UILabel!
    
    var DriverInfo:[String:Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let DriverName = DriverInfo["name"] as? String {
            self.lblDriverName.text = DriverName
        }
        if let VehicleMake = DriverInfo["name"] as? String {
            self.lblDriverName.text = DriverName
        }
        if let VehicleModel = DriverInfo["name"] as? String {
            self.lblDriverName.text = DriverName
        }
        if let VehicleColor = DriverInfo["name"] as? String {
            self.lblDriverName.text = DriverName
        }
        if let NumberPlate = DriverInfo["name"] as? String {
            self.lblDriverName.text = DriverName
        }
        
        // Do any additional setup after loading the view.
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
