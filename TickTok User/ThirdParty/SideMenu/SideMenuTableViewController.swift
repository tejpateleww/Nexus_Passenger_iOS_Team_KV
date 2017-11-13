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

    
    override func viewDidLoad() {
        super.viewDidLoad()

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
            
            cellHeader.imgProfile.layer.cornerRadius = cellHeader.imgProfile.frame.width / 2
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
            
            let next = self.storyboard?.instantiateViewController(withIdentifier: "UpdateProfileViewController") as! UpdateProfileViewController
            self.navigationController?.pushViewController(next, animated: true)

        }
        
        if (indexPath.section == 1)
        {
            if indexPath.row == 0
            {
                self.performSegue(withIdentifier: "segueMyBooking", sender: self)

//                let next = self.storyboard?.instantiateViewController(withIdentifier: "MyBookingViewController") as! MyBookingViewController
//                self.navigationController?.pushViewController(next, animated: true)
                
                
            }
            
            if (indexPath.row == arrMenuTitle.count - 1)
            {
                self.performSegue(withIdentifier: "unwindToContainerVC", sender: self)
                UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
            }
            else if (indexPath.row == arrMenuTitle.count - 2)
            {
                self.performSegue(withIdentifier: "pushToBlank", sender: self)
            }
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
    
}
