//
//  PassViewController.swift
//  Nexus User
//
//  Created by EWW076 on 01/04/19.
//  Copyright © 2019 Excellent Webworld. All rights reserved.
//

import UIKit

class OffersViewController: BaseViewController {

  
    @IBOutlet weak var btnOffers: UIButton!
    @IBOutlet weak var btnMyOffers: UIButton!
    @IBOutlet weak var offersTableView: UITableView!
    @IBOutlet weak var lblNoData: UILabel!

  
    var data1 = [String]()
    var data2 = ["Weekly Pass Offers", "5% Discount","You get discount on your regular trips in month"]
    var edit = false
    var data = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = data1
        btnSelected(selectedBtn: btnOffers, unselectedBtn: btnMyOffers)
        
        btnMyOffers.buttonLayout()
        btnOffers.buttonLayout()
        
        
        
    }
    @IBAction func offers(_ sender: UIButton){
        edit = false
        btnSelected(selectedBtn: btnOffers, unselectedBtn: btnMyOffers)
        
    }
    @IBAction func myOffers(_ sender: UIButton){
        edit = true
        btnSelected(selectedBtn: btnMyOffers, unselectedBtn: btnOffers)
        
    }
   
    func btnSelected(selectedBtn: UIButton,unselectedBtn: UIButton){
        unselectedBtn.backgroundColor = UIColor.white
        unselectedBtn.setTitleColor(UIColor.black, for: .normal)
        
        selectedBtn.backgroundColor = ThemeNaviBlueColor
        selectedBtn.setTitleColor(UIColor.white, for: .normal)
        changeTableData(selectedBtn)
    }
   
        
}


extension UIButton{
    func buttonLayout(){
        self.titleLabel?.font = UIFont(name: AppRegularFont, size: 15)
    }
}
extension OffersViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return data.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PassTableViewCell.identifier, for: indexPath) as! PassTableViewCell
        cell.setup(with: data)
        cell.canEdit = edit
        cell.btnActivate.tag = indexPath.row
        cell.btnActivate.addTarget(self, action: #selector(activateAction), for: .touchUpInside)
        return cell
    }
    
    func changeTableData(_ sender: UIButton){
        lblNoData.isHidden = true
        data = sender == btnOffers ? data2 : data1
        UIView.transition(with: offersTableView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { self.offersTableView.reloadData() })
       
        guard data.count > 0 else {
            lblNoData.isHidden = false
            return
        }
        offersTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    @objc func activateAction(){
        self.performSegue(withIdentifier: PassFilterViewController.identifier, sender: self)
    }
}


