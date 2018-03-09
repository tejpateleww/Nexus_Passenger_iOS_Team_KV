//
//  SideMenuTableViewController.swift
//  TickTok User
//
//  Created by Excellent Webworld on 26/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

protocol delegateForTiCKPayVerifyStatus {
    
    func didRegisterCompleted()
}

class SideMenuTableViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, delegateForTiCKPayVerifyStatus {
  
    @IBOutlet weak var tableView: UITableView!
    
    var ProfileData = NSDictionary()
    
    var arrMenuIcons = NSMutableArray()
    var arrMenuTitle = NSMutableArray()

    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        giveGradientColor()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.SetRating), name: NSNotification.Name(rawValue: "rating"), object: nil)

        webserviceOfTickPayStatus()
        
        ProfileData = SingletonClass.sharedInstance.dictProfile
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        

        
        arrMenuIcons = ["iconMyBooking","iconPaymentOption","iconWallet","iconStarOfSideMenu","iconMyreceipts","iconInviteFriends","iconSettings","iconMyBooking","iconPackageHistory","iconLogOut"]
        
        arrMenuTitle = ["My Booking","Payment Options","Wallet","Favourites","My Receipts","Invite Friends","Settings","Become a \(appName) Driver","Package History","LogOut"]
        

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        giveGradientColor()
        
//        UIApplication.shared.isStatusBarHidden = true
//        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
//
//
    }
    
    
    @objc func SetRating() {
        
        
        self.tableView.reloadData()
    }
    
    func giveGradientColor() {
        
        let colorTop =  UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor
        let colorMiddle =  UIColor(red: 36/255, green: 24/255, blue: 3/255, alpha: 0.5).cgColor
        let colorBottom = UIColor(red: 64/255, green: 43/255, blue: 6/255, alpha: 0.8).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ colorTop, colorMiddle, colorBottom]
        gradientLayer.locations = [ 0.0, 0.5, 1.0]
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
    }

    // MARK: - Table view data source

     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return 1
        }
        else
        {
            return arrMenuIcons.count
        }
    }
  
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        if (indexPath.section == 0)
        {
            let cellHeader = tableView.dequeueReusableCell(withIdentifier: "MainHeaderTableViewCell") as! MainHeaderTableViewCell
            cellHeader.selectionStyle = .none
            
            cellHeader.imgProfile.layer.cornerRadius = cellHeader.imgProfile.frame.width / 2
             cellHeader.imgProfile.layer.borderWidth = 1.0
             cellHeader.imgProfile.layer.borderColor = UIColor.white.cgColor
            cellHeader.imgProfile.layer.masksToBounds = true
            
            cellHeader.imgProfile.sd_setImage(with: URL(string: ProfileData.object(forKey: "Image") as! String), completed: nil)
            cellHeader.lblName.text = ProfileData.object(forKey: "Fullname") as? String
            
            cellHeader.lblMobileNumber.text = ProfileData.object(forKey: "MobileNo") as? String
            cellHeader.lblRating.text = SingletonClass.sharedInstance.passengerRating

            return cellHeader
        }
        else
        {
            let cellMenu = tableView.dequeueReusableCell(withIdentifier: "ContentTableViewCell") as! ContentTableViewCell

            cellMenu.imgDetail?.image = UIImage.init(named:  "\(arrMenuIcons.object(at: indexPath.row ))")
            cellMenu.selectionStyle = .none
            
            cellMenu.lblTitle.text = arrMenuTitle.object(at: indexPath.row) as? String
            
            return cellMenu
        }
        
        
        // Configure the cell...

//        return cellHeader
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
//            let next = self.storyboard?.instantiateViewController(withIdentifier: "CommingSoonViewController") as! CommingSoonViewController
//            self.navigationController?.pushViewController(next, animated: true)
            
            let next = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
            self.navigationController?.pushViewController(next, animated: true)

        }
        else if (indexPath.section == 1)
        {
            if indexPath.row == 0
            {
//                self.performSegue(withIdentifier: "segueMyBooking", sender: self)

                let next = self.storyboard?.instantiateViewController(withIdentifier: "MyBookingViewController") as! MyBookingViewController
                self.navigationController?.pushViewController(next, animated: true)
                
                
            }
            
            if indexPath.row == 1 {
                
//                if SingletonClass.sharedInstance.setPasscode == "" {
//                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SetPasscodeViewController") as! SetPasscodeViewController
//                    self.navigationController?.pushViewController(viewController, animated: true)
//                }
//                else {
//
//                    if (SingletonClass.sharedInstance.passwordFirstTime) {
//
                        if SingletonClass.sharedInstance.CardsVCHaveAryData.count == 0 {
                            let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
                            self.navigationController?.pushViewController(next, animated: true)
                        }
                        else {
                            let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletCardsVC") as! WalletCardsVC
                            self.navigationController?.pushViewController(next, animated: true)
                        }
//                    }
//                    else {
//                        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "VerifyPasswordViewController") as! VerifyPasswordViewController
//                        self.navigationController?.pushViewController(viewController, animated: true)
//
//                    }
//                }
                
            }
            else if indexPath.row == 2 {
                
                if (SingletonClass.sharedInstance.isPasscodeON) {
                    
                    if SingletonClass.sharedInstance.setPasscode == "" {
                        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SetPasscodeViewController") as! SetPasscodeViewController
                        viewController.strStatusToNavigate = "Wallet"
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                    else {
                        
//                        if (SingletonClass.sharedInstance.passwordFirstTime) {
//
//                            let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletViewController") as! WalletViewController
//                            self.navigationController?.pushViewController(next, animated: true)
//
//                        }
//                        else {
                            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "VerifyPasswordViewController") as! VerifyPasswordViewController
                            viewController.strStatusToNavigate = "Wallet"
                            self.navigationController?.pushViewController(viewController, animated: true)
                            
//                        }
                    }
                }
                else {
                    let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletViewController") as! WalletViewController
                    self.navigationController?.pushViewController(next, animated: true)
                }
                
            }
            else if indexPath.row == 3 {
                let next = self.storyboard?.instantiateViewController(withIdentifier: "FavoriteViewController") as! FavoriteViewController
                
//                let homeVC = ((self.navigationController?.childViewControllers[1] as! CustomSideMenuViewController).childViewControllers[0] as! UINavigationController).childViewControllers[0] as! HomeViewController
                var homeVC : HomeViewController!
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: CustomSideMenuViewController.self) {
                        
                        homeVC = (controller.childViewControllers[0] as! UINavigationController).childViewControllers[0] as! HomeViewController
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
                
                next.delegateForFavourite = homeVC.self as? FavouriteLocationDelegate!
                
                self.navigationController?.pushViewController(next, animated: true)
            }
            else if indexPath.row == 4 {
                let next = self.storyboard?.instantiateViewController(withIdentifier: "MyReceiptsViewController") as! MyReceiptsViewController
                self.navigationController?.pushViewController(next, animated: true)
            }
            else if indexPath.row == 5 {
                let next = self.storyboard?.instantiateViewController(withIdentifier: "InviteDriverViewController") as! InviteDriverViewController
                self.navigationController?.pushViewController(next, animated: true)
            }
            else if indexPath.row == 6 {
                let next = self.storyboard?.instantiateViewController(withIdentifier: "SettingPasscodeVC") as! SettingPasscodeVC
                self.navigationController?.pushViewController(next, animated: true)
            }
            else if indexPath.row == 7 {
                UIApplication.shared.openURL(NSURL(string: "https://itunes.apple.com/us/app/pick-n-go-driver/id1320783710?mt=8")! as URL)
            }
            else if indexPath.row == 8
            {
                let next = self.storyboard?.instantiateViewController(withIdentifier: "PackageHistoryViewController") as! PackageHistoryViewController
                self.navigationController?.pushViewController(next, animated: true)
            }
            
            
            if (indexPath.row == arrMenuTitle.count - 1)
            {
                self.performSegue(withIdentifier: "unwindToContainerVC", sender: self)
                UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                
                UserDefaults.standard.removeObject(forKey: "Passcode")
                SingletonClass.sharedInstance.setPasscode = ""
                
                UserDefaults.standard.removeObject(forKey: "isPasscodeON")
                SingletonClass.sharedInstance.isPasscodeON = false
                
            }
//            else if (indexPath.row == arrMenuTitle.count - 2)
//            {
//                self.performSegue(withIdentifier: "pushToBlank", sender: self)
//            }
        }

        
    }
    
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0)
        {
            return 130
        }
        else
        {
            return 42
        }
    }
    
    func didRegisterCompleted() {
        
        webserviceOfTickPayStatus()
    }
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    func navigateToTiCKPay() {
//        webserviceOfTickPayStatus()
        
        if self.varifyKey == 0 {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "TickPayRegistrationViewController") as! TickPayRegistrationViewController
            next.delegateForVerifyStatus = self
            self.navigationController?.pushViewController(next, animated: true)
        }
            
        else if self.varifyKey == 1 {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "TiCKPayNeedToVarifyViewController") as! TiCKPayNeedToVarifyViewController
            self.navigationController?.pushViewController(next, animated: true)
        }
            
        else if self.varifyKey == 2 {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "PayViewController") as! PayViewController
            self.navigationController?.pushViewController(next, animated: true)
        }
    }
    
    
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    var varifyKey = Int()
    func webserviceOfTickPayStatus() {
        
        webserviceForTickpayApprovalStatus(SingletonClass.sharedInstance.strPassengerID as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
                
                if let id = (result as! [String:AnyObject])["Verify"] as? String {
                    
//                    SingletonClass.sharedInstance.TiCKPayVarifyKey = Int(id)!
                    self.varifyKey = Int(id)!
                }
                else if let id = (result as! [String:AnyObject])["Verify"] as? Int {
                    
//                    SingletonClass.sharedInstance.TiCKPayVarifyKey = id
                    self.varifyKey = id
                }

            }
            else {
                print(result)
            }
        }
    }
    
}
