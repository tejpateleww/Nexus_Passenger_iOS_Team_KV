//
//  ShoppingDetailsVC.swift
//  TickTok User
//
//  Created by Excelent iMac on 15/12/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import SDWebImage

class ShoppingDetailsVC: ParentViewController, UITableViewDataSource, UITableViewDelegate {

    var strType = String()
    var strHeader = String()
    var aryData = [[String:AnyObject]]()
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        webserviceOfShoppingList(shoppingType: strType)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if strHeader != "" {
            headerView?.lblTitle.text = strHeader
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //-------------------------------------------------------------
    // MARK: - TableView Methods
    //-------------------------------------------------------------
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return aryData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let datas = aryData[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingTableViewCell") as! ShoppingTableViewCell
        cell.selectionStyle = .none
        
        if strHeader == "RETAIL" || strHeader == "CHEMIST" {
            
            cell.imgWidthConstraints.constant = 0
            cell.imgTailingConstraints.constant = 0
        }
        else {
            cell.imgWidthConstraints.constant = 27
            cell.imgTailingConstraints.constant = 20
        }
        
        
        if let title = datas["name"] as? String {
    
            cell.lblShopTitle.text = title
            cell.lblShopTitle.underlineToLabel()
            cell.lblShopTitle.font = UIFont.boldSystemFont(ofSize: 17.0)
           
        }
        
        if let rating = datas["rating"] as? Float {
            cell.lblRatting.text = String(rating)
            cell.viewRatting.rating = rating
            cell.lblRatting.textColor = UIColor.init(red: 229/255, green: 166/255, blue: 28/255, alpha: 1.0)
        }
        
        if let address = datas["formatted_address"] as? String {
            cell.lblAddress.text = address
        }
        
        if let iconShop = datas["icon"] as? String {
    
            cell.imgItem.sd_setShowActivityIndicatorView(true)
            cell.imgItem.sd_setIndicatorStyle(.gray)
            cell.imgItem.sd_setImage(with: URL(string: iconShop), completed: nil)
        }
        
        if let shopStatus = datas["opening_hours"] as? [String:AnyObject] {
            if let openNowStatus = shopStatus["open_now"] as? Bool {
                if (openNowStatus) {
                    cell.btnShopStatus.setTitle("Open now", for: .normal)
                    cell.btnShopStatus.setTitleColor(UIColor.init(red: 0, green: 144/255, blue: 81/255, alpha: 1.0), for: .normal)
                    
                }
                else {
                    cell.btnShopStatus.setTitle("Close now", for: .normal)
                    cell.btnShopStatus.setTitleColor(UIColor.init(red: 204/255, green: 3/255, blue: 0, alpha: 1.0), for: .normal)
                    
                }
            }
            else {
                cell.btnShopStatus.setTitle("Close now", for: .normal)
                cell.btnShopStatus.setTitleColor(UIColor.init(red: 204/255, green: 3/255, blue: 0, alpha: 1.0), for: .normal)
                
            }
        }
        else {
            cell.btnShopStatus.setTitle("Close now", for: .normal)
            cell.btnShopStatus.setTitleColor(UIColor.init(red: 204/255, green: 3/255, blue: 0, alpha: 1.0), for: .normal)
            
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 126
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let BookCarNow = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Book Car Now") { (action , indexPath ) -> Void in
            
            self.isEditing = false
            print("Book Car Now")
        }
        
        
        let BookCarLater = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Book Car Later") { (action , indexPath) -> Void in
            self.isEditing = false
            print("Book Car Later")
        }
        
        BookCarLater.backgroundColor = UIColor.black
        return [BookCarLater,BookCarNow]
    }
    

    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    func webserviceOfShoppingList(shoppingType: String) {
        
        if let currentCity = SingletonClass.sharedInstance.strCurrentCity as? String {
            
            ShoppingListOfGoogle("" as AnyObject, Location: currentCity, Type: shoppingType) { (result, status) in
                
                if (status) {
                    print(result)
                    
                    let dataOfShops = (result as! [String:AnyObject])
                    
                    self.aryData = dataOfShops["results"] as! [[String:AnyObject]]
                    
                    self.tableView.reloadData()
                    
                }
                else {
                    print(result)
                    
                    if let resDict = result as? NSDictionary {
                        UtilityClass.showAlert("", message: resDict.object(forKey: "status") as! String, vc: self)
                    }
                    
                }
            }
            
        }
        
        
    }
    
    
}



