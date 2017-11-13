//
//  UpCommingVC.swift
//  TickTok User
//
//  Created by Excellent Webworld on 09/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class UpCommingVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    var aryData = NSArray()
    
    var strPickupLat = String()
    var strPickupLng = String()
    
    var strDropoffLat = String()
    var strDropoffLng = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.isScrollEnabled = true
        
        self.tableView.isUserInteractionEnabled = true
        self.view.isUserInteractionEnabled = true
        
        
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadDataTableView), name: NSNotification.Name(rawValue: NotificationCenterName.keyForUpComming), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    @objc func reloadDataTableView()
    {
        self.aryData = SingletonClass.sharedInstance.aryUpComming
        self.tableView.reloadData()
        self.tableView.frame.size = tableView.contentSize
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------

    @IBOutlet weak var tableView: UITableView!
    
    
    //-------------------------------------------------------------
    // MARK: - Table View Methods
    //-------------------------------------------------------------
    
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return aryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpCommingTableViewCell") as! UpCommingTableViewCell
        
        if aryData.count > 0 {


            cell.lblPickupAddress.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PickupLocation") as? String
            cell.lblDropoffAddress.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "DropoffLocation") as? String
            cell.lblDistanceValue.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "TripDistance") as? String
            
            strPickupLat = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PickupLng") as! String
            strPickupLng = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PickupLng") as! String
            
            strDropoffLat = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "DropOffLat") as! String
            strDropoffLng = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "DropOffLon") as! String
            
            if (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Model") != nil {
                cell.lblModelValue.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Model") as? String
            }
            
            cell.lblStatusValue.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Status") as? String
  
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 209
    }

    
    
    
    

}
