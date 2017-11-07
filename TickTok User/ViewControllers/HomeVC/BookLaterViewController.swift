//
//  BookLaterViewController.swift
//  TickTok User
//
//  Created by Excellent Webworld on 04/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import M13Checkbox

class BookLaterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        constraintsHeightOFtxtFlightNumber.constant = 0 // 30 Height
        
        viewMySelf.boxType = .square
        viewOthers.boxType = .square
        viewFlightNumber.boxType = .square

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var viewMySelf: M13Checkbox!
    @IBOutlet weak var viewOthers: M13Checkbox!
    
    @IBOutlet weak var lblMySelf: UILabel!
    @IBOutlet weak var lblOthers: UILabel!
    
    @IBOutlet weak var lblCareModelClass: UILabel!
    @IBOutlet weak var imgCareModel: UIImageView!
    
    @IBOutlet weak var txtPickupLocation: UITextField!
    @IBOutlet weak var txtDropOffLocation: UITextField!
    
    
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    
    @IBOutlet weak var txtDataAndTimeFromCalendar: UITextField!
    
    @IBOutlet weak var btnCalendar: UIButton!
    
    @IBOutlet weak var viewFlightNumber: M13Checkbox!
    
    @IBOutlet weak var txtFlightNumber: UITextField!
    
    @IBOutlet weak var constraintsHeightOFtxtFlightNumber: NSLayoutConstraint!
    
    
    
    //-------------------------------------------------------------
    // MARK: - Button Actions
    //-------------------------------------------------------------
    
    @IBAction func btnBack(_ sender: UIButton) {
        
    self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func viewMySelf(_ sender: M13Checkbox) {
        
        viewMySelf.markType = .checkmark
        
    }
    
    @IBAction func viewOthers(_ sender: M13Checkbox) {
        
        viewOthers.markType = .checkmark
    }
    
    @IBAction func txtPickupLocation(_ sender: UITextField) {
        
    }
    @IBAction func txtDropOffLocation(_ sender: UITextField) {
        
    }
    
    @IBAction func btnCalendar(_ sender: UIButton) {
        
    }
    
    @IBAction func viewFlightNumber(_ sender: M13Checkbox) {
        viewFlightNumber.markType = .checkmark
        
        constraintsHeightOFtxtFlightNumber.constant = 30
        
    }
    
    @IBAction func btnSubmit(_ sender: UIButton) {
        
        
    }
}
