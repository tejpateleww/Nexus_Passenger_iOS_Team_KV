//
//  PassViewController.swift
//  Nexus User
//
//  Created by EWW076 on 01/04/19.
//  Copyright © 2019 Excellent Webworld. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class OffersViewController: BaseViewController {

  
    @IBOutlet weak var btnOffers: UIButton!
    @IBOutlet weak var btnMyOffers: UIButton!
    @IBOutlet weak var offersTableView: UITableView!
    @IBOutlet weak var lblNoData: UILabel!
   
    var tabUrl = ""
    var activeButton : UIButton!
    var passengerId = SingletonClass.sharedInstance.strPassengerID
    var selectedButtonTag = Int()
    var editButtonTag = Int()
    var editPass = false
    var currentHistoryId = ""
    var myOffersList = [[String:Any]]()
    var offersList = [[String:Any]]()
    var data = [[String:Any]]()
    var currentData = [String: Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnSelected(selectedBtn: self.btnOffers, unselectedBtn: self.btnMyOffers)
      
        getPassHistory(){
            self.getTabData(self.activeButton)
        }
        
        btnMyOffers.titleLabel?.font = UIFont.semiBold(ofSize: 15)
        btnOffers.titleLabel?.font = UIFont.semiBold(ofSize: 15)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setNavBarWithBack(Title: "PASS", IsNeedRightButton: false)
        
    }
    
    @IBAction func offers(_ sender: UIButton){
        if sender != activeButton{
            btnSelected(selectedBtn: btnOffers, unselectedBtn: btnMyOffers)
            getTabData(sender)
        }else{
            offersTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    @IBAction func myOffers(_ sender: UIButton){
        if sender != activeButton{
            btnSelected(selectedBtn: btnMyOffers, unselectedBtn: btnOffers)
            getTabData(sender)
        }else{
            offersTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)

        }
    }
    @IBAction func activateAction(_ sender: UIButton){
        selectedButtonTag = sender.tag
        editPass = false
        if sender.status == .deactivate{
            UtilityClass.setCustomAlert(title: "", message: "Are you sure to deactivate you want to deactivate?") { (index, title) in
                if index == 0{
                    self.deactivatePass(){
                        self.getPassHistory(){
                            self.getTabData(self.activeButton)
                        }
                    }
                }
            }
            
        }
        else{
            self.performSegue(withIdentifier: PassFilterViewController.identifier, sender: self)
        }
    }
    @IBAction func editAction(_ sender: UIButton){
        editButtonTag = sender.tag
        editPass = true
        self.performSegue(withIdentifier: PassFilterViewController.identifier, sender: self)

    }
    func btnSelected(selectedBtn: UIButton,unselectedBtn: UIButton){
        activeButton = selectedBtn
        
        lblNoData.isHidden = false
        unselectedBtn.backgroundColor = UIColor.white
        unselectedBtn.setTitleColor(UIColor.black, for: .normal)
        
        selectedBtn.backgroundColor = ThemeNaviBlueColor
        selectedBtn.setTitleColor(UIColor.white, for: .normal)
        changeTableData(activeButton)

    }
   
    var discountType : DiscountType{
        if passString(key: "DiscountValue") != ""
        {
            if passString(key: "DiscountType") == DiscountType.percentage.rawValue{
                return .percentage
            }
            else if passString(key: "DiscountType") == DiscountType.flat.rawValue{
                return .flat
            }
            else{
                return .none
            }
        }else{
            return .none
        }
    }
    func passString(key: String) -> String{
        return ((data[selectedButtonTag][key] as? String) ?? "")
    }
    
    //-------------------------------------------------------------
    // MARK: - Trip Data from Filter
    //-------------------------------------------------------------
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case PassFilterViewController.identifier:
            if let vc = segue.destination as? PassFilterViewController{
                vc.getTrip = {
                    self.getPassHistory(){
                        self.getTabData(self.activeButton)
                    }
                }
                vc.passData = data[selectedButtonTag]
                vc.discountType = discountType
                if editPass{
                    vc.editable = true
                    vc.currentData = currentData
                }else {vc.editable = false}
            }
        default:
            break
        }
    }
}



////-------------------------------------------------------------
// MARK: - Table Data
//-------------------------------------------------------------

extension OffersViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch activeButton{
        case btnOffers:
            let cell = tableView.dequeueReusableCell(withIdentifier: OffersTableViewCell.identifier, for: indexPath) as! OffersTableViewCell
            cell.currentData = currentData
            selectedButtonTag = indexPath.row
            cell.data = data[indexPath.row]
            cell.discountType = discountType
            cell.btnActivate.tag = indexPath.row
            cell.btnEdit.tag = indexPath.row
            return cell
        
        case btnMyOffers:
            let cell = tableView.dequeueReusableCell(withIdentifier: MyOffersTableViewCell.identifier, for: indexPath) as! MyOffersTableViewCell
            cell.data = data[indexPath.row]
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func changeTableData(_ sender: UIButton){
        data = sender == btnOffers ? offersList : myOffersList
        UIView.transition(with: offersTableView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { self.offersTableView.reloadData() })
       
        guard data.count > 0 else {
            lblNoData.isHidden = false
            return
        }
        lblNoData.isHidden = true
        offersTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    func getTabData(_ sender: UIButton){
        if sender == btnOffers{
            getPassType()
        }else{
            getPassHistory()
        }
    }
}


//-------------------------------------------------------------
// MARK: - WebServices
//-------------------------------------------------------------

extension OffersViewController{
    
    func getPassType(){
        webserviceForGetPassType(dictParams: passengerId as AnyObject) { (response, status) in
            print(response)
            if status{
                if let result = response as? [String: Any]{
                    if let data = result["data"] as? [[String:Any]]{
                        self.offersList = data
                        self.changeTableData(self.activeButton)
                    }
                }
            }
            else{
                print(response)
            }
        }
    }
    
    
    func deactivatePass(completion: (() -> ())? = nil){
        let param = currentHistoryId
        webserviceForPassDeactivation((param as AnyObject)) { (response, status) in
            print(response)
            if status{
                if let completion = completion{
                    completion()
                }
            }else{
                if let data = response["message"] as? String{
                    UtilityClass.showAlert("\(status)", message: data, vc: self)
                }
            }
            
        }
    }
    
    
    func getPassHistory(completion: (() -> ())? = nil){
        
        webserviceForGetPassHistory(dictParams: passengerId as AnyObject) { (response, status) in
            print(SingletonClass.sharedInstance.strPassengerID)
            print(response)
            if status{
                if let result = response as? [String: Any]{
                    print(response)
                    if let currentData = result["current_history"] as? [String:Any]{
                        self.currentHistoryId = String(describing: (currentData["Id"] ?? ""))
                        self.currentData = currentData
                    }else{
                        self.currentData = [String:Any]()
                    }
                    if let completion = completion{
                        completion()
                        return
                    }
                    if let data = result["past_history"] as? [[String:Any]]{
                        self.myOffersList = data
                        self.changeTableData(self.activeButton)
                        print(data)
                    }
                    
                }
            }
            else{
                print(response)
            }
        }
    }
   
}
