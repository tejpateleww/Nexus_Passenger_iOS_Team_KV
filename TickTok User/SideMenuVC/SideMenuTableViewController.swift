//
//  SideMenuTableViewController.swift
//  TickTok User
//
//  Created by Excellent Webworld on 26/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class SideMenuTableViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
  
    
    var ProfileData = NSDictionary()
    
    var arrMenuIcons = NSMutableArray()
    var arrMenuTitle = NSMutableArray()

    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webserviceOfTickPayStatus()
        
        ProfileData = SingletonClass.sharedInstance.dictProfile
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        arrMenuIcons = ["iconMyBooking","iconPaymentOption","iconWallet","iconPay","iconFavourites","iconMyreceipts","iconInviteFriends","iconBars&Club","iconHotelReservation","iconBookaTable","iconShopping","iconLogOut"]
        
        arrMenuTitle = ["My Booking","Payment Options","Wallet","Pay","Favourites","My Receipts","Invite Friends","Bars & Clubs", "Hotel Reservations", "Book a Table", "Shopping","LogOut"]
        

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
             cellHeader.imgProfile.layer.borderColor = UIColor.red.cgColor
            cellHeader.imgProfile.layer.masksToBounds = true
            
            cellHeader.imgProfile.sd_setImage(with: URL(string: ProfileData.object(forKey: "Image") as! String), completed: nil)
            cellHeader.lblName.text = ProfileData.object(forKey: "Fullname") as? String

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
            
            let next = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
            self.navigationController?.pushViewController(next, animated: true)

        }
        
        if (indexPath.section == 1)
        {
            if indexPath.row == 0
            {
//                self.performSegue(withIdentifier: "segueMyBooking", sender: self)

                let next = self.storyboard?.instantiateViewController(withIdentifier: "MyBookingViewController") as! MyBookingViewController
                self.navigationController?.pushViewController(next, animated: true)
                
                
            }
            
            if indexPath.row == 1 {
                
                if SingletonClass.sharedInstance.setPasscode == "" {
                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SetPasscodeViewController") as! SetPasscodeViewController
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
                else {
                
                    if (SingletonClass.sharedInstance.passwordFirstTime) {
                    
                        if SingletonClass.sharedInstance.CardsVCHaveAryData.count == 0 {
                            let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
                            self.navigationController?.pushViewController(next, animated: true)
                        }
                        else {
                            let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletCardsVC") as! WalletCardsVC
                            self.navigationController?.pushViewController(next, animated: true)
                        }
                    }
                    else {
                        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "VerifyPasswordViewController") as! VerifyPasswordViewController
                        self.navigationController?.pushViewController(viewController, animated: true)
                        
                    }
                }
                
            }
            else if indexPath.row == 2 {
                
                if SingletonClass.sharedInstance.setPasscode == "" {
                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SetPasscodeViewController") as! SetPasscodeViewController
                    viewController.strStatusToNavigate = "Wallet"
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
                else {
                
                    if (SingletonClass.sharedInstance.passwordFirstTime) {
                    
                        let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletViewController") as! WalletViewController
                        self.navigationController?.pushViewController(next, animated: true)
                        
                    }
                    else {
                        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "VerifyPasswordViewController") as! VerifyPasswordViewController
                        viewController.strStatusToNavigate = "Wallet"
                        self.navigationController?.pushViewController(viewController, animated: true)
                        
                    }
                }
            }
            else if indexPath.row == 3 {
                
                if SingletonClass.sharedInstance.setPasscode == "" {
                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SetPasscodeViewController") as! SetPasscodeViewController
                    
                    viewController.strStatusToNavigate = "\(self.varifyKey)"
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
                else {
                
                    if (SingletonClass.sharedInstance.passwordFirstTime) {
                        
                        if self.varifyKey == 0 {
                            let next = self.storyboard?.instantiateViewController(withIdentifier: "TickPayRegistrationViewController") as! TickPayRegistrationViewController
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
                    else {
                        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "VerifyPasswordViewController") as! VerifyPasswordViewController
                        
                        viewController.strStatusToNavigate = "\(self.varifyKey)"
                        self.navigationController?.pushViewController(viewController, animated: true)
                    
                    }
                }
                
            }
            else if indexPath.row == 4 {
                let next = self.storyboard?.instantiateViewController(withIdentifier: "FavoriteViewController") as! FavoriteViewController
                
                let homeVC = ((self.navigationController?.childViewControllers[1] as! CustomSideMenuViewController).childViewControllers[0] as! UINavigationController).childViewControllers[0] as! HomeViewController
                
                next.delegateForFavourite = homeVC.self
                
                self.navigationController?.pushViewController(next, animated: true)
            }
            else if indexPath.row == 5 {
                let next = self.storyboard?.instantiateViewController(withIdentifier: "MyReceiptsViewController") as! MyReceiptsViewController
                self.navigationController?.pushViewController(next, animated: true)
            }
            else if indexPath.row == 6 {
                let next = self.storyboard?.instantiateViewController(withIdentifier: "InviteDriverViewController") as! InviteDriverViewController
                self.navigationController?.pushViewController(next, animated: true)
            }
            else if indexPath.row == 7 {
                let next = self.storyboard?.instantiateViewController(withIdentifier: "BarsAndClubsViewController") as! BarsAndClubsViewController
                self.navigationController?.pushViewController(next, animated: true)
            }
            else if indexPath.row == 8 {
                let next = self.storyboard?.instantiateViewController(withIdentifier: "HotelReservationViewController") as! HotelReservationViewController
                self.navigationController?.pushViewController(next, animated: true)
            }
            else if indexPath.row == 9 {
                let next = self.storyboard?.instantiateViewController(withIdentifier: "BookTableViewController") as! BookTableViewController
                self.navigationController?.pushViewController(next, animated: true)
            }
            else if indexPath.row == 10 {
                let next = self.storyboard?.instantiateViewController(withIdentifier: "ShoppingViewController") as! ShoppingViewController
                self.navigationController?.pushViewController(next, animated: true)
            }
            
            
            if (indexPath.row == arrMenuTitle.count - 1)
            {
                self.performSegue(withIdentifier: "unwindToContainerVC", sender: self)
                UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
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
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    var varifyKey = Int()
    func webserviceOfTickPayStatus() {
        
        webserviceForTickpayApprovalStatus(SingletonClass.sharedInstance.strPassengerID as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
                
                if let id = (result as! [String:AnyObject])["Verify"] as? String {
                    self.varifyKey = Int(id)!
                }
                else if let id = (result as! [String:AnyObject])["Verify"] as? Int {
                    self.varifyKey = id
                }

            }
            else {
                print(result)
            }
        }
    }
    
}
