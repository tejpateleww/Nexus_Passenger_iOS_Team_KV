//
//  WalletCardsVC.swift
//  TiCKTOC-Driver
//
//  Created by Excelent iMac on 23/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

@objc protocol AddCadsDelegate {
    
    func didAddCard(cards: NSArray)
}

class WalletCardsVC: UIViewController, UITableViewDataSource, UITableViewDelegate, AddCadsDelegate {

    
    weak var delegateForTopUp: SelectCardDelegate!
    weak var delegateForTransferToBank: SelectBankCardDelegate!
    
    var aryData = [[String:AnyObject]]()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
   
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func loadView() {
        super.loadView()
        
        if SingletonClass.sharedInstance.isCardsVCFirstTimeLoad {
//            webserviceOFGetAllCards()
            
            if SingletonClass.sharedInstance.CardsVCHaveAryData.count != 0 {
                aryData = SingletonClass.sharedInstance.CardsVCHaveAryData
            }
            else {
                
                webserviceOFGetAllCards()
                
            }
        }
        else {
            if SingletonClass.sharedInstance.CardsVCHaveAryData.count != 0 {
                aryData = SingletonClass.sharedInstance.CardsVCHaveAryData
            }
            else {
                let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
                next.delegateAddCard = self
                self.navigationController?.pushViewController(next, animated: true)
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        self.tableView.addSubview(self.refreshControl)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAddCards: UIButton!
    
    //-------------------------------------------------------------
    // MARK: - TableView Methods
    //-------------------------------------------------------------
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return aryData.count
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletCardsTableViewCell") as! WalletCardsTableViewCell
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "AddCard") as! WalletCardsTableViewCell
        
        cell.selectionStyle = .none
        cell2.selectionStyle = .none
        
        if indexPath.section == 0 {
            
            let dictData = aryData[indexPath.row] as [String:AnyObject]
            
            cell.lblCardType.text = "Credit Card"
            
            cell.viewCards.layer.cornerRadius = 5
            cell.viewCards.layer.masksToBounds = true
            
            let type = dictData["Type"] as! String
            
            cell.imgCardIcon.image = UIImage(named: setCreditCardImage(str: type))
            
            if (indexPath.row % 2) == 0 {
                cell.viewCards.backgroundColor = UIColor.orange
                cell.lblBankName.text = dictData["Alias"] as? String
                cell.lblCardNumber.text = dictData["CardNum2"] as? String
//                cell.imgCardIcon.image = UIImage(named: "MasterCard")
            }
            else {
                cell.viewCards.backgroundColor = UIColor.init(red: 0, green: 145/255, blue: 147/255, alpha: 1.0)
                cell.lblBankName.text = dictData["Alias"] as? String
                cell.lblCardNumber.text = dictData["CardNum2"] as? String
//                cell.imgCardIcon.image = UIImage(named: "Visa")
                
            }
            
         /*
          //   visa , mastercard , amex , diners , discover , jcb , other
             
            if (indexPath.row % 2) == 0 {
                cell.viewCards.backgroundColor = UIColor.orange
                cell.lblCardNumber.text = "**** **** **** 1081"
                cell.imgCardIcon.image = UIImage(named: "MasterCard")
            }
            else {
                cell.viewCards.backgroundColor = UIColor.init(red: 0, green: 145/255, blue: 147/255, alpha: 1.0)
                cell.lblCardNumber.text = "**** **** **** 9964"
                cell.imgCardIcon.image = UIImage(named: "Visa")
                
            }
          */
            
            return cell
        }
        else {
            
            return cell2
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if indexPath.section == 0 {
         
            let selectedData = aryData[indexPath.row] as [String:AnyObject]
            
            print("selectedData : \(selectedData)")
            
            if SingletonClass.sharedInstance.isFromTopUP {
                delegateForTopUp.didSelectCard(dictData: selectedData)
                SingletonClass.sharedInstance.isFromTopUP = false
                self.navigationController?.popViewController(animated: true)
            }
            else if SingletonClass.sharedInstance.isFromTransferToBank {
                delegateForTransferToBank.didSelectBankCard(dictData: selectedData)
                SingletonClass.sharedInstance.isFromTransferToBank = false
                self.navigationController?.popViewController(animated: true)
            }
            
        }
        else if indexPath.section == 1 {
            
            let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
            next.delegateAddCard = self
            self.navigationController?.pushViewController(next, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 120
        }
        else {
            return 75
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let selectedData = aryData[indexPath.row] as [String:AnyObject]
        
        if editingStyle == .delete {
            
            let selectedID = selectedData["Id"] as? String
            
            tableView.beginUpdates()
            aryData.remove(at: indexPath.row)
            webserviceForRemoveCardFromWallet(cardId : selectedID!)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
        
    }
   
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    @IBAction func btnBack(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }

    @IBAction func btnAddCards(_ sender: UIButton) {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
        
        next.delegateAddCard = self
        self.navigationController?.pushViewController(next, animated: true)
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        webserviceOFGetAllCards()
        
        tableView.reloadData()
    }
    
    func setCreditCardImage(str: String) -> String {
        
        //   visa , mastercard , amex , diners , discover , jcb , other
        
        var strType = String()
        
        if str == "visa" {
            strType = "Visa"
        }
        else if str == "mastercard" {
            strType = "MasterCard"
        }
        else if str == "amex" {
            strType = "Amex"
        }
        else if str == "diners" {
            strType = "Diners Club"
        }
        else if str == "discover" {
            strType = "Discover"
        }
        else if str == "jcb" {
            strType = "JCB"
        }
        else {
            strType = "iconDummyCard"
        }
        
        return strType
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Add Cads Delegate Methods
    //-------------------------------------------------------------
    
    func didAddCard(cards: NSArray) {
        
        aryData = cards as! [[String:AnyObject]]
        
        tableView.reloadData()
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods For All Cards
    //-------------------------------------------------------------
    
    func webserviceOFGetAllCards() {
 
        webserviceForCardList(SingletonClass.sharedInstance.strPassengerID as AnyObject) { (result, status) in
        
       
            if (status) {
                print(result)
                
                self.aryData = (result as! NSDictionary).object(forKey: "cards") as! [[String:AnyObject]]
                
                SingletonClass.sharedInstance.CardsVCHaveAryData = self.aryData
                
                SingletonClass.sharedInstance.isCardsVCFirstTimeLoad = false
                
                self.tableView.reloadData()
                
                if SingletonClass.sharedInstance.CardsVCHaveAryData.count == 0 {
                    let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
                    next.delegateAddCard = self
                    self.navigationController?.pushViewController(next, animated: true)
                }
                
                self.refreshControl.endRefreshing()
            }
            else {
                
                print(result)
                if let res = result as? String {
                    UtilityClass.showAlert("", message: res, vc: self)
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.showAlert("", message: resDict.object(forKey: "message") as! String, vc: self)
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.showAlert("", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
                }
            }
        }

    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods Remove Cards
    //-------------------------------------------------------------
    
    
    
    func webserviceForRemoveCardFromWallet(cardId : String) {
      
        
        var params = String()
        params = "\(SingletonClass.sharedInstance.strPassengerID)/\(cardId)"

        webserviceForRemoveCard(params as AnyObject) { (result, status) in
        
            if (status) {
                print(result)
                
                self.aryData = (result as! NSDictionary).object(forKey: "cards") as! [[String:AnyObject]]
                
                SingletonClass.sharedInstance.CardsVCHaveAryData = self.aryData
                
                SingletonClass.sharedInstance.isCardsVCFirstTimeLoad = false
                
                
                if SingletonClass.sharedInstance.CardsVCHaveAryData.count == 0 {
             
                    self.navigationController?.popViewController(animated: true)
                }
                
                
                self.tableView.reloadData()
                
                UtilityClass.showAlert("", message: (result as! NSDictionary).object(forKey: "message") as! String, vc: self)
            }
            else {
                print(result)
                
                if let res = result as? String {
                    UtilityClass.showAlert("", message: res, vc: self)
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.showAlert("", message: resDict.object(forKey: "message") as! String, vc: self)
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.showAlert("", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
                }
            }
        }

    }
    
    
}



