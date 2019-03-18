//
//  GenerateTicketViewController.swift
//  Nexus-Driver
//
//  Created by EWW iMac2 on 01/03/19.
//  Copyright © 2019 Excellent WebWorld. All rights reserved.
//

import UIKit
import ACFloatingTextfield_Swift

class GenerateTicketViewController: BaseViewController,UIGestureRecognizerDelegate {

    
    @IBOutlet var txtSubject: ACFloatingTextfield!
    @IBOutlet var txtDescription: ACFloatingTextfield!
    
    @IBOutlet var btnsubmit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(movetoTickeList), name: Notification.Name("moveToTicketList"), object: nil)
        
        self.setNavBarWithBack(Title: "Generate Ticket", IsNeedRightButton: false)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_Ticket"), style: .plain, target: self, action: #selector(movetoTickeList))
        // Do any additional setup after loading the view.
    }
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

       
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.txtSubject.placeHolderColor = UIColor.black
        self.txtSubject.selectedLineColor = ThemeNaviBlueColor
        self.txtSubject.lineColor = UIColor.black
        self.txtSubject.selectedPlaceHolderColor = ThemeNaviBlueColor
        
        self.txtDescription.placeHolderColor = UIColor.black
        self.txtDescription.selectedLineColor = ThemeNaviBlueColor
        self.txtDescription.lineColor = UIColor.black
        self.txtDescription.selectedPlaceHolderColor = ThemeNaviBlueColor
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool
    {
        return true
    }

    @objc func movetoTickeList()
    {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "TicketListViewController") as! TicketListViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func btnSubmitClicked(_ sender: Any)
    {
        let strSubject = txtSubject.text!
        let strDescription = txtDescription.text!
        
        
        if UtilityClass.isEmpty(str: strSubject)
        {
            UtilityClass.showAlert("", message: "Please enter subject.", vc: self)
        }
        else if UtilityClass.isEmpty(str: strSubject)
        {
            UtilityClass.showAlert("", message: "Please enter description.", vc: self)
        }
        else
        {
            let srtDriverID = SingletonClass.sharedInstance.strPassengerID
            
            var dictData = [String : AnyObject]()
//            UserId:4, Description:this is test ticket ,TicketTitle:Rfund
            dictData["TicketTitle"] = strSubject as AnyObject
            dictData["Description"] = strDescription as AnyObject
            dictData["UserId"] = srtDriverID as AnyObject
            
            webserviceForGenerateTickets(dictData as AnyObject) { (result, status) in
                if status
                {
                    print(result)
                    
                    
                    UtilityClass.showAlertWithCompletion("", message: result["message"] as! String, vc: self, completionHandler: { (status) in
                        self.navigationController?.popViewController(animated: true)
                    })
                    
                }
                else
                {
                    print(result)
                }
            }
            
        }
    }
}
