//
//  AskForTipViewController.swift
//  Nexus User
//
//  Created by EWW-iMac Old on 04/03/19.
//  Copyright © 2019 Excellent Webworld. All rights reserved.
//

import UIKit

protocol AskForTipDelegate {
    func DidClickYes(Tips:String, isTripBookNow:Bool)
    func DidClickNo(isTripBookNow:Bool)
}

class AskForTipViewController: UIViewController {

    @IBOutlet weak var lblAlertDesc: UILabel!
    
    @IBOutlet weak var txtTip: UITextField!
    
    @IBOutlet weak var btnYes: ThemeButton!
    
    @IBOutlet weak var btnNo: ThemeButton!
    var Delegate:AskForTipDelegate!
    var strMessage:String = ""
    var isBookNow:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.lblAlertDesc.text = self.strMessage
//        "Nexus driver Ask For Tips. Do you want to give tips?"
        self.txtTip.placeholder = "Enter tip"
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
    
    
    
//MARK:- IBAction Methods
    
    @IBAction func btnNoAction(_ sender: Any) {
        self.Delegate.DidClickNo(isTripBookNow:isBookNow)
    }
    
    @IBAction func btnYesAction(_ sender: Any) {
        if self.txtTip.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) != "" {
            self.Delegate.DidClickYes(Tips: self.txtTip.text!, isTripBookNow: isBookNow)
        } else {
            let alert = UIAlertController(title: appName,
                                          message: "Please enter amount",
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            UtilityClass.presentPopupOverScreen(alert)
        }
    }
    
}
