//
//  ParentViewController.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 09/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import SocketIO

class ParentViewController: UIViewController, HeaderViewDelegate {
    
//    let socket = SocketIOClient(socketURL: URL(string: "http://54.206.55.185:8080")!, config: [.log(false), .compress])
    
    
    @IBInspectable var showsBackButton: Bool = false
    @IBInspectable var showTitleLabelView : Bool = false
//    @IBInspectable var hideSwitchButton: Bool = false
    @IBInspectable var strHeaderTitle: String?
    @IBInspectable var strTitle : String?
//    @IBInspectable var hideSignOut: Bool = false
    
    var headerView: HeaderView?
    var userDefault = UserDefaults.standard
    var driverDuty = String()
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        createHeaderView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    

    func didSideMenuClicked()       //  Side Menu
    {
        SideMenuClicked()
    }
    func didBackButtonClicked()     //  Back Button
    {
        BackButtonClicked()
    }
    
    func didSignOutClicked()        //  SignOut
    {
        SignOutClicked()
    }
    
    func didSwitchOnOFFClicked(isOn: Bool) {
        
        if isOn {
            SwitchOnClicked()
        }
        else {
            SwitchOFFClicked()
        }
    }
    
    // ------------------------------------------------------------
    
    func SideMenuClicked()       //  Side Menu
    {
        sideMenuController?.toggle()
    }
    func BackButtonClicked()     //  Back Button
    {
        if isModal() {
            self.dismiss(animated: true, completion: nil)
            
        }
        else {
            
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func isModal() -> Bool {
        if (presentingViewController != nil) {
            return true
        }
        if navigationController?.presentingViewController?.presentedViewController == navigationController {
            return true
        }
        if (tabBarController?.presentingViewController is UITabBarController) {
            return true
        }
        return false
    }
    
    func SearchClicked()         //  Search
    {
        
    }
    func SignOutClicked()        //  SignOut
    {
        
        userDefault.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        
        performSegue(withIdentifier: "SignOutFromRegister", sender: (Any).self)
  
    }
    func SwitchOnClicked()    //  Switch On
    {

    }
    func SwitchOFFClicked()   //  Switch OFF
    {

    }
    
    func CloseButtonClicked()    //  Close Button
    {
        self.navigationController?.popViewController(animated: true)
    }
    // ------------------------------------------------------------
    
    func createHeaderView() {
        let screenRect: CGRect = UIScreen.main.bounds
        let screenWidth: CGFloat = screenRect.size.width
        let hView = HeaderView.headerView(withDelegate: self)
        
        var frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: screenWidth, height: CGFloat(44))
        
        hView.bottomView.isHidden = !showTitleLabelView
        if (showTitleLabelView)
        {
            frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: screenWidth, height: CGFloat(94))
            hView.lblHeaderTitle.text = strHeaderTitle
        }
        
        headerView?.lblTitle.isHidden = true
        
        if (strTitle != nil)
        {
            hView.lblTitle.isHidden = false
            hView.lblTitle.text = strTitle
            hView.imgHeaderImage.isHidden = true
        }
        
        hView.btnBack.isHidden = !showsBackButton
        hView.btnMenu.isHidden = showsBackButton
//        hView.btnSwitch.isHidden = !hideSwitchButton
//        hView.btnSignOut.isHidden = !hideSignOut
        
        hView.frame = frame
        headerView = hView
        view.addSubview(hView)
        
    }
    
    
}

