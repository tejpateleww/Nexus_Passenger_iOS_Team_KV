//
//  CommingSoonViewController.swift
//  PickNGo User
//
//  Created by Excelent iMac on 13/02/18.
//  Copyright © 2018 Excellent Webworld. All rights reserved.
//

import UIKit

class CommingSoonViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnBack(_ sender: UIButton) {
        
        
        self.navigationController?.popViewController(animated: true)

    }
    
    
    

}
