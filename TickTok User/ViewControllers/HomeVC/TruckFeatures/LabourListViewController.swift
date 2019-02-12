//
//  LabourListViewController.swift
//  Cab Ride User
//
//  Created by Apple on 28/09/18.
//  Copyright © 2018 Excellent Webworld. All rights reserved.
//

import UIKit

class LabourListViewController: UIViewController {

    // ----------------------------------------------------
    // MARK: - Outlets
    // ----------------------------------------------------

    @IBOutlet weak var tableView: UITableView!
    
    // ----------------------------------------------------
    // MARK: - Globle Declaration Methods
    // ----------------------------------------------------
    
    var aryLabour = [[String:Any]]()
    var delegate: parcelAndLabourDelegate?
    var selectedData = [String:Any]()
    var selectedIndexPath = IndexPath()
    
    // ----------------------------------------------------
    // MARK: - Base Methods
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        tableView.reloadData()
    }
    
    // ----------------------------------------------------
    // MARK: - Actions
    // ----------------------------------------------------
    
    @IBAction func btnCancel(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnDone(_ sender: UIButton) {
        
        if delegate != nil {
            delegate?.didLabourSelected!(dict: selectedData)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}

// ----------------------------------------------------
// MARK: - TableView Delegate & DataSource
// ----------------------------------------------------

extension LabourListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryLabour.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabourTableViewCell") as! LabourTableViewCell
        
        cell.selectionStyle = .none
        let currentData = aryLabour[indexPath.row]
        
        cell.lblLabourType.text = currentData["Title"] as? String
        cell.imgLabourType.sd_setIndicatorStyle(.gray)
        cell.imgLabourType.sd_showActivityIndicatorView()
        
        if let img = currentData["Image"] as? String {
            if img != "" {
                cell.imgLabourType.sd_setImage(with: URL(string: img), completed: nil)
            }
        }
        
        cell.viewMainLabour.backgroundColor = UIColor.white
        cell.lblLabourType.textColor = UIColor.black
        
        if selectedIndexPath == indexPath {
            cell.viewMainLabour.backgroundColor = UIColor.black
            cell.lblLabourType.textColor = UIColor.white
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentData = aryLabour[indexPath.row]
        print("\(currentData["Title"] ?? "none")")
        
        selectedData = currentData
        selectedIndexPath = indexPath
        
        tableView.reloadData()
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
}
