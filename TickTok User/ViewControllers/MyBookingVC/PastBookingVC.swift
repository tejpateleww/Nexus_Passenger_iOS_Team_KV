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
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
            
            cell.lblStatusValue.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Status") as? String
            cell.lblDriverNameValue.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "DriverName") as? String
            cell.lblPickupAddress.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PickupLocation") as? String
            cell.lblDropoffAddress.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "DropoffLocation") as? String
            
            strPickupLat = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PickupLng") as! String
            strPickupLng = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PickupLng") as! String
            
            strDropoffLat = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "DropOffLat") as! String
            strDropoffLng = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "DropOffLon") as! String
            
            if ((aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "CarDetails") != nil) {
                
                cell.lblCompanyValue.text = ((aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "CarDetails") as! NSDictionary).object(forKey: "Company") as? String
                
                let url = ((aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "CarDetails") as! NSDictionary).object(forKey: "VehicleImage") as! String
                let urlString = "http://54.206.55.185/web/\(url)"
                cell.imgDriver.sd_setImage(with: URL(string: urlString), completed: nil)
                
            }
            
            cell.lblTotalValue.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "GrandTotal") as? String
            cell.lblBookingChargeValue.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "BookingCharge") as? String
            cell.lblWaitingCostValue.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "WaitingTimeCost") as? String
            cell.lblTripFareValue.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "TripFare") as? String
            cell.lblNightFareValue.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "NightFare") as? String
            
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 290
    }

    
    
    

}
