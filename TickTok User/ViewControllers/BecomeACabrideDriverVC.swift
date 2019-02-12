
//
//  BecomeACabrideDriverVC.swift
//  Cab Ride User
//
//  Created by Excelent iMac on 26/09/18.
//  Copyright © 2018 Excellent Webworld. All rights reserved.
//

import UIKit

class BecomeACabrideDriverVC: UIViewController {

    @IBOutlet weak var lblComingSoon: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblComingSoon.text = "Coming Soon"
    }
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
