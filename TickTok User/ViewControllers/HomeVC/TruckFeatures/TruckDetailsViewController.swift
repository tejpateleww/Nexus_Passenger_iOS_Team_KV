//
//  TruckDetailsViewController.swift
//  Cab Ride User
//
//  Created by Apple on 05/10/18.
//  Copyright © 2018 Excellent Webworld. All rights reserved.
//

import UIKit

class TruckDetailsViewController: UIViewController {

    // ----------------------------------------------------
    // MARK: - Outlets
    // ----------------------------------------------------

    @IBOutlet weak var imgTruck: UIImageView!
    @IBOutlet weak var lblTruckName: UILabel!
    @IBOutlet weak var lblHeight: UILabel!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblCapacity: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    
    // ----------------------------------------------------
    // MARK: - Globle Declaration Methods
    // ----------------------------------------------------
    
    var truckDetail = (name: "", height: "", width: "", capacity: "", image: "", desc: "")
    
    // ----------------------------------------------------
    // MARK: - Base Methods
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if truckDetail.image != "" {
             imgTruck.sd_setImage(with: URL(string: WebserviceURLs.kImageBaseURL + truckDetail.image), completed: nil)

        }
        
        lblTruckName.text = truckDetail.name
        lblHeight.text = truckDetail.height
        lblWeight.text = truckDetail.width
        lblCapacity.text = truckDetail.capacity
        lblDescription.text = truckDetail.desc

    }
    
    // ----------------------------------------------------
    // MARK: - Actions
    // ----------------------------------------------------
    
    @IBAction func btnOK(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    

}
