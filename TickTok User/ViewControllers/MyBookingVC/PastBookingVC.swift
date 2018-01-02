//
//  PastBookingVC.swift
//  TickTok User
//
//  Created by Excellent Webworld on 09/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class PastBookingVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    var aryData = NSArray()
    
    var strPickupLat = String()
    var strPickupLng = String()
    
    var strDropoffLat = String()
    var strDropoffLng = String()
    
    var expandedCellPaths = Set<IndexPath>()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        self.tableView.addSubview(self.refreshControl)
        

        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTableView), name: NSNotification.Name(rawValue: NotificationCenterName.keyForPastBooking), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func reloadTableView()
    {
        self.aryData = SingletonClass.sharedInstance.aryPastBooking
        self.tableView.reloadData()
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        tableView.reloadData()
        refreshControl.endRefreshing()
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PastBooingTableViewCell") as! PastBooingTableViewCell
        
        if aryData.count > 0 {
            
            
            cell.selectionStyle = .none
            
            if let name = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "DriverName") as? String {
                
                if name == "" {
                    cell.lblDriverName.text = "NULL"
                }
                else {
                    cell.lblDriverName.text = name
                }
                
            }
            else {
                cell.lblDriverName.text = "NULL"
            }
            
            
            cell.lblBookingID.text = "Booking Id: (\(String(describing: (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Id")!)))"
            cell.lblDateAndTime.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "CreatedDate") as? String
            
            cell.lblPickupAddress.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PickupLocation") as? String
            cell.lblDropoffAddress.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "DropoffLocation") as? String
            
            cell.lblPickupTime.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PickupTime") as? String
            cell.lblDropoffTime.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "DropTime") as? String
            cell.lblVehicleType.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Model") as? String
            cell.lblDistanceTravelled.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "TripDistance") as? String
            cell.lblTripFare.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "TripFare") as? String
            cell.lblNightFare.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "NightFare") as? String
            cell.lblTollFee.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "TollFee") as? String
            cell.lblWaitingCost.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "WaitingTimeCost") as? String
            cell.lblBookingCharge.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "BookingCharge") as? String
            cell.lblTax.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Tax") as? String
            cell.lblDiscount.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Discount") as? String
            cell.lblPaymentType.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PaymentType") as? String
            cell.lblTotalCost.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "GrandTotal") as? String
            
            
            cell.viewDetails.isHidden = !expandedCellPaths.contains(indexPath)
            
            
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? PastBooingTableViewCell {
            cell.viewDetails.isHidden = !cell.viewDetails.isHidden
            if cell.viewDetails.isHidden {
                expandedCellPaths.remove(indexPath)
            } else {
                expandedCellPaths.insert(indexPath)
            }
            tableView.beginUpdates()
            tableView.endUpdates()
            
        }
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    

    
    
    

}
