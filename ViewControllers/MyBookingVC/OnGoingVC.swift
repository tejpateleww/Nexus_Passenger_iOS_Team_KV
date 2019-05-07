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

    var strPickupLat = String()
    var strPickupLng = String()
    var aryData:[[String:Any]] = []
    
    var strDropoffLat = String()
    var strDropoffLng = String()
    
    var PickupAddress = String()
    var DropoffAddress = String()
    
    var expandedCellPaths = Set<IndexPath>()
    
    
    @IBOutlet weak var lblNoDataFound: UILabel!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = ThemeNaviBlueColor
        
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblNoDataFound.text = "No Data Found".localized
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        self.tableView.addSubview(self.refreshControl)
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadDataOfTableView), name: NSNotification.Name(rawValue: NotificationCenterName.keyForOnGoing), object: nil)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func reloadDataOfTableView() {
        
//        self.aryData = SingletonClass.sharedInstance.aryOnGoing
        
        if self.aryData.count > 0 {
            self.lblNoDataFound.isHidden = true
        } else {
            self.lblNoDataFound.isHidden = false
        }
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

        let cell = tableView.dequeueReusableCell(withIdentifier: "OnGoingTableViewCell") as! OnGoingTableViewCell
        
        cell.lblPickupUpAddressTitle.text = "PICK UP LOCATION".localized
        cell.lblDropOffAddressTitle.text = "DROP OFF LOCATION".localized
        cell.lblPickupTimeTitle.text = "PICKUP TIME".localized
        cell.lblVehicleTypeTitle.text = "VEHICLE TYPE".localized
        cell.lblPaymentTypeTitle.text = "PAYMENT TYPE".localized
        
        cell.btnTrackYourTrip.setTitle("Track Your Trip".localized, for: .normal)
        cell.btnTrackYourTrip.titleLabel?.font = UIFont.bold(ofSize: 11.0)
        
        if aryData.count > 0 {
            
            cell.selectionStyle = .none
            
//            cell.viewCell.layer.cornerRadius = 10
//            cell.viewCell.clipsToBounds = true
            if let name = aryData[ indexPath.row]["DriverName"] as? String {
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
            
           let dictData = aryData[ indexPath.row]
            
//            let formattedString = NSMutableAttributedString()
//            formattedString
//                .normal("\("Booking Id :".localized)")
//                .bold("\(String(describing: (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Id")!))", 14)
            
            if let BookingID = dictData["Id"] as? String {
                cell.lblBookingID.text = "\("Booking Id".localized) : \(BookingID)"
            }
            
            
//            cell.lblBookingID.attributedText = formattedString
            if let Createdate = dictData[ "CreatedDate"] as? String {
                cell.lblDateAndTime.text =  Createdate
            }
            if let PickupLocation = dictData[ "PickupLocation"] as? String {
                cell.lblPickupAddress.text = ": " + PickupLocation // PickupLocation
            }
            if let DropOffAddress = dictData[ "DropoffLocation"] as? String {
                cell.lblDropoffAddress.text =  ": " + DropOffAddress  // DropoffLocation
            }
            
            if let pickupTime = dictData["PickupTime"] as? String {
                if pickupTime == "" {
                    cell.lblPickupTime.text = "Date and Time not available"
                }
                else {
                    cell.lblPickupTime.text = ": " + setTimeStampToDate(timeStamp: pickupTime)
                }
            }
            if let vehicleType = dictData["Model"] as? String {
                cell.lblVehicleType.text = ": " + vehicleType
            }
            if let PaymentType = dictData["PaymentType"] as? String {
                cell.lblPaymentType.text = ": " + PaymentType
            }
           
            if let waitingTime = dictData["WaitingTime"] as? String {
                
                var strWaitingTime: String = "00:00:00"
                
                if waitingTime != "" {
                    let intWaitingTime = Int(waitingTime)
                    let WaitingTimeIs = ConvertSecondsToHoursMinutesSeconds(seconds: intWaitingTime!)
                    if WaitingTimeIs.0 == 0 {
                        if WaitingTimeIs.1 == 0 {
                            strWaitingTime = "00:00:\(WaitingTimeIs.2)"
                        } else {
                            strWaitingTime = "00:\(WaitingTimeIs.1):\(WaitingTimeIs.2)"
                        }
                    } else {
                        strWaitingTime = "\(WaitingTimeIs.0):\(WaitingTimeIs.1):\(WaitingTimeIs.2)"
                    }
                }
                else {
                    strWaitingTime = waitingTime
                }
                cell.lblWaitingTime.text = ": " + strWaitingTime
            }
            
//            if let DropoffTime = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "DropTime") as? String {
//                if DropoffTime == "" {
//                    cell.lbldrop.text = "Date and Time not available"
//                }
//                else {
//                    cell.lblDropoffTime.text = setTimeStampToDate(timeStamp: DropoffTime)
//                }
//            }
            
//            cell.lblPickupTime.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PickupTime") as? String
//            cell.lblDropoffTime.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "DropTime") as? String
            
//            cell.lblDistanceTravelled.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "TripDistance") as? String
//            cell.lblTripFare.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "TripFare") as? String
//            cell.lblNightFare.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "NightFare") as? String
//            cell.lblTollFee.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "TollFee") as? String
//            cell.lblWaitingCost.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "WaitingTimeCost") as? String
//            cell.lblBookingCharge.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "BookingCharge") as? String
//            cell.lblTax.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Tax") as? String
//            cell.lblDiscount.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Discount") as? String
//            cell.lblTotalCost.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "GrandTotal") as? String
            
            cell.btnTrackYourTrip.layer.cornerRadius = 5
            cell.btnTrackYourTrip.layer.masksToBounds = true
            cell.btnTrackYourTrip.tag = indexPath.row
            cell.btnTrackYourTrip.addTarget(self, action: #selector(self.trackYourTrip(sender:)), for: .touchUpInside)
            
            cell.viewDetails.isHidden = !expandedCellPaths.contains(indexPath)
        
        }
 
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }

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
        
        let currentData = aryData[sender.tag]
        
        let id:String = currentData["Id"] as! String
        
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
                
                let alert = UIAlertController(title: appName, message: msg, preferredStyle: .alert)
                let OK = UIAlertAction(title: "OK".localized, style: .default, handler: nil)
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
    
    @objc func webserviceOfBookingHistory()
    {
        //        let activityData = ActivityData()
        //        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        //
        if Connectivity.isConnectedToInternet() == false {
            
            UtilityClass.setCustomAlert(title: "Connection Error", message: "Internet connection not available") { (index, title) in
            }
            return
        }
         webserviceForOnGoingBookingList(SingletonClass.sharedInstance.strPassengerID as AnyObject ) { (result, status) in
            
            if (status) {
                self.aryData = (result as! [String:Any])["history"] as! [[String:Any]]
                print(self.aryData)
                self.reloadDataOfTableView()
                self.refreshControl.endRefreshing()
                
            }
            else {
                
                print(result)
                
                if let res = result as? String {
                    UtilityClass.setCustomAlert(title: "", message: res) { (index, title) in
                    }
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.setCustomAlert(title: "", message: resDict.object(forKey: "message") as! String) { (index, title) in
                    }
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.setCustomAlert(title: "", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                    }
                }
            }
        }
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
