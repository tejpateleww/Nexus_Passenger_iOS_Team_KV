//
//  OnGoingVC.swift
//  TickTok User
//
//  Created by Excellent Webworld on 09/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import SDWebImage

class OnGoingVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var aryData = NSArray()
    
    var strPickupLat = String()
    var strPickupLng = String()
    
    var strDropoffLat = String()
    var strDropoffLng = String()
    
    var PickupAddress = String()
    var DropoffAddress = String()
    
    var expandedCellPaths = Set<IndexPath>()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = ThemeBlueColor
        
        return refreshControl
    }()
    @IBOutlet weak var lblNoDataFounds: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
   
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        self.tableView.addSubview(self.refreshControl)
        self.aryData = SingletonClass.sharedInstance.aryOnGoing
        self.tableView.reloadData()
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadDataOfTableView), name: NSNotification.Name(rawValue: NotificationCenterName.keyForOnGoing), object: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func reloadDataOfTableView() {
        
        self.aryData = SingletonClass.sharedInstance.aryOnGoing
        self.tableView.reloadData()
        
        if (aryData.count == 0)
        {
            lblNoDataFounds.text = "No Data Found "
            
        }
        else
        {
         
            lblNoDataFounds.isHidden = true
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        self.aryData = SingletonClass.sharedInstance.aryOnGoing
        self.tableView.reloadData()
        
        if (aryData.count == 0)
        {
            lblNoDataFounds.text = "No Data Found "
            
        }
        else
        {
            
            lblNoDataFounds.isHidden = true
        }
       
        refreshControl.endRefreshing()
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func btnTaxiHistory(_ sender: UIButton) {
        
        if SingletonClass.sharedInstance.aryOnGoing.count != 0 {
            
            if let taxiData = (SingletonClass.sharedInstance.aryOnGoing as? [[String:Any]])?.filter({($0["RequestFor"] as? String) == "taxi"}) {
                
                aryData = taxiData as NSArray
                tableView.reloadData()
            }
        }
       
    }
    
    @IBAction func btnTransportHistory(_ sender: UIButton) {
        
        if SingletonClass.sharedInstance.aryOnGoing.count != 0 {
            if let deliveryData = (SingletonClass.sharedInstance.aryOnGoing as? [[String:Any]])?.filter({($0["RequestFor"] as? String) == "delivery"}) {
                
                aryData = deliveryData as NSArray
                tableView.reloadData()
            }
        }
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Table View Methods
    //-------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return aryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "OnGoingTableViewCell") as! OnGoingTableViewCell
        
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
            
            let formattedString = NSMutableAttributedString()
            formattedString
                .normal("Booking Id: ")
                .bold("\(String(describing: (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Id")!))", 14)
            
           
            cell.lblBookingID.attributedText = formattedString
            cell.lblDateAndTime.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "CreatedDate") as? String
            
            cell.lblPickupAddress.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "DropoffLocation") as? String // PickupLocation
            cell.lblDropoffAddress.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PickupLocation") as? String  // DropoffLocation
            
            if let pickupTime = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PickupTime") as? String {
                if pickupTime == "" {
                    cell.lblPickupTime.text = "Date and Time not available"
                }
                else {
                    cell.lblPickupTime.text = setTimeStampToDate(timeStamp: pickupTime)
                }
            }
            
            if let DropoffTime = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "DropTime") as? String {
                if DropoffTime == "" {
                    cell.lblDropoffTime.text = "Date and Time not available"
                }
                else {
                    cell.lblDropoffTime.text = setTimeStampToDate(timeStamp: DropoffTime)
                }
            }
            
//            cell.lblPickupTime.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PickupTime") as? String
//            cell.lblDropoffTime.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "DropTime") as? String
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
            
            cell.btnTrackYourTrip.tag = indexPath.row
            cell.btnTrackYourTrip.addTarget(self, action: #selector(self.trackYourTrip(sender:)), for: .touchUpInside)
            
             cell.viewDetails.isHidden = !expandedCellPaths.contains(indexPath)
        
        }
 
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? OnGoingTableViewCell {
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
    
    
    @objc func CancelRequest() {
        
    }
   
    @objc func trackYourTrip(sender: UIButton) {
        
        let currentData = aryData.object(at: sender.tag)
        
        let id:String = (currentData as! NSDictionary).object(forKey: "Id")! as! String
        
        RunningTripTrack(param: id)
        
    }
    
    
    func RunningTripTrack(param: String) {
        
        
        webserviceForTrackRunningTrip(param as AnyObject) { (result, status) in
            
            if (status) {
                 print(result)
                SingletonClass.sharedInstance.bookingId = param
                
//                 Post notification
                NotificationCenter.default.post(name: NotificationTrackRunningTrip, object: nil)
                
                self.navigationController?.popViewController(animated: true)
                
            }
            else {
                SingletonClass.sharedInstance.bookingId = ""
                NotificationCenter.default.post(name: NotificationForAddNewBooingOnSideMenu, object: nil)
                var msg = String()
                if let res = result as? String {
                    msg = res
                }
                else if let resDict = result as? NSDictionary {
                    msg = resDict.object(forKey: "message") as! String
                }
                else if let resAry = result as? NSArray {
                    msg = (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String
                }
                
                let alert = UIAlertController(title: "Cab Ride", message: msg, preferredStyle: .alert)
                let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(OK)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    func setTimeStampToDate(timeStamp: String) -> String {
        
        let unixTimestamp = Double(timeStamp)
        //        let date = Date(timeIntervalSince1970: unixTimestamp)
        
        let date = Date(timeIntervalSince1970: unixTimestamp!)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "HH:mm yyyy/MM/dd" //Specify your format that you want
        let strDate: String = dateFormatter.string(from: date)
        
        return strDate
    }
    
/*
    func setMarkersOnMap(PickupLatitude: Double, PickupLongitude: Double, DropoffLatitude: Double, DropoffLongitude: Double, PickupLocation: String, DropoffLocation: String) {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
    
        SingletonClass.sharedInstance.boolIsFromPrevious = true
        
        
        let dictData = NSMutableDictionary()
        
        dictData.setValue(Double(strPickupLat)!, forKey: "PickupLat")
        dictData.setValue(Double(strPickupLng)!, forKey: "PickupLng")
        
        dictData.setValue(Double(strDropoffLat)!, forKey: "DropOffLat")
        dictData.setValue(Double(strDropoffLng)!, forKey: "DropOffLon")
        
        dictData.setValue(PickupAddress, forKey: "PickupLocation")
        dictData.setValue(DropoffAddress, forKey: "DropoffLocation")
        
        
        SingletonClass.sharedInstance.dictIsFromPrevious = dictData
     
        
//        next.zPickupLat = Double(strPickupLat)!
//        next.zPickupLng = Double(strPickupLng)!
//
//        next.zDropoffLat = Double(strDropoffLat)!
//        next.zDropoffLng = Double(strDropoffLng)!
//
//        next.zPickupLocation = PickupAddress
//        next.zDropoffLocation = DropoffAddress
        
//        self.navigationController?.popViewController(animated: true)
//        self.navigationController?.pushViewController(next, animated: true)
        
        self.navigationController?.present(next, animated: true, completion: nil)
    }
*/
    
}
