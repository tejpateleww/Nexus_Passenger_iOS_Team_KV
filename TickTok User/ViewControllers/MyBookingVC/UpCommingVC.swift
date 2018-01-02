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
    
    var bookinType = String()
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadDataTableView), name: NSNotification.Name(rawValue: NotificationCenterName.keyForUpComming), object: nil)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        tableView.reloadData()
        refreshControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    @objc func reloadDataTableView()
    {
        self.aryData = SingletonClass.sharedInstance.aryUpComming
        self.tableView.reloadData()
//        self.tableView.frame.size = tableView.contentSize
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

cell.selectionStyle = .none
            cell.lblPickupAddress.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PickupLocation") as? String
            cell.lblDropoffAddress.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "DropoffLocation") as? String
            cell.lblDateAndTime.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "CreatedDate") as? String
       
            cell.lblPaymentType.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PaymentType") as? String
  
            if let bookingID = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Id") as? String {
                cell.btnCancelRequest.tag = Int(bookingID)!
            }
            else if let bookingID = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Id") as? Int {
                cell.btnCancelRequest.tag = bookingID
            }
            
            bookinType = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "BookingType") as! String
            cell.btnCancelRequest.addTarget(self, action: #selector(self.CancelRequest), for: .touchUpInside)
            
            cell.btnCancelRequest.layer.cornerRadius = 5
            cell.btnCancelRequest.layer.masksToBounds = true
            
            cell.viewDetails.isHidden = !expandedCellPaths.contains(indexPath)
        }
        
        return cell
    }
    
  
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        if let cell = tableView.cellForRow(at: indexPath) as? UpCommingTableViewCell {
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
    
    
    @objc func CancelRequest(sender: UIButton) {
        
        let bookingID = sender.tag
        
        
        let socketData = ((self.navigationController?.childViewControllers[1] as! CustomSideMenuViewController).childViewControllers[0].childViewControllers[0] as! HomeViewController).socket
        let showTopView = ((self.navigationController?.childViewControllers[1] as! CustomSideMenuViewController).childViewControllers[0].childViewControllers[0] as! HomeViewController)
        
        if bookinType == "Book Now" {
            let myJSON = [SocketDataKeys.kBookingIdNow : bookingID] as [String : Any]
            socketData.emit(SocketData.kCancelTripByPassenger , with: [myJSON])
            
            showTopView.setHideAndShowTopViewWhenRequestAcceptedAndTripStarted(status: false)
            
            UtilityClass.showAlertWithCompletion("", message: "Your request cancelled successfully", vc: self, completionHandler: { ACTION in
                self.navigationController?.popViewController(animated: true)
            })
           
        }
        else {
            let myJSON = [SocketDataKeys.kBookingIdNow : bookingID] as [String : Any]
            socketData.emit(SocketData.kAdvancedBookingCancelTripByPassenger , with: [myJSON])
            
            UtilityClass.showAlertWithCompletion("", message: "Your request cancelled successfully", vc: self, completionHandler: { ACTION in
                self.navigationController?.popViewController(animated: true)
            })
            
            
        }
       
    }
    
   
}
