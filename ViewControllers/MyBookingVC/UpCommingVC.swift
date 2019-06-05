//
//  UpCommingVC.swift
//  TickTok User
//
//  Created by Excellent Webworld on 09/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class UpCommingVC: UIViewController, UITableViewDataSource, UITableViewDelegate { 

    
    var aryData:[[String:Any]] = []
    
    var strPickupLat = String()
    var strPickupLng = String()
    
    var strDropoffLat = String()
    var strDropoffLng = String()
    let notAvailable: String = "N/A"
    
    var bookinType = String()
    
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
//        self.aryData = SingletonClass.sharedInstance.aryUpComming
        
        if self.aryData.count > 0 {
            self.lblNoDataFound.isHidden = true
        } else {
            self.lblNoDataFound.isHidden = false
        }
        
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
//            let currentData = (aryData.object(at: indexPath.row) as! [String:AnyObject])
            
            cell.selectionStyle = .none
            
            cell.lblPickupAddressTitle.text = "PICK UP LOCATION".localized
            cell.lblDropoffAddressTitle.text = "DROP OFF LOCATION".localized
            cell.lblPickUpTimeTitle.text = "PICKUP TIME".localized
            cell.lblVehicleTypeTitle.text = "VEHICLE TYPE".localized
            cell.lblPaymentTypeTitle.text = "PAYMENT TYPE".localized
            
            cell.btnCancelRequest.setTitle("Track Your Trip".localized, for: .normal)
            cell.btnCancelRequest.titleLabel?.font = UIFont.bold(ofSize: 11.0)
            
//            cell.viewCell.layer.cornerRadius = 10
//            cell.viewCell.clipsToBounds = true
            
            let dictData = aryData[indexPath.row]
            
            if let BookingID = dictData[ "Id"] as? String {
                cell.lblBookingId.text = "\("Booking Id".localized) : \(BookingID)"
            }
            
            //            cell.lblBookingID.attributedText = formattedString
            if let Createdate = dictData[ "CreatedDate"] as? String {
                cell.lblDateAndTime.text =  Createdate
            }
            
            if let Notes = dictData["Notes"] as? String {
                cell.lblNotes.text = Notes
            }
            
            if let PickupLocation = dictData[ "PickupLocation"] as? String {
                cell.lblPickupAddress.text = ": " + PickupLocation // PickupLocation
            }
            if let DropOffAddress = dictData[ "DropoffLocation"] as? String {
                cell.lblDropoffAddress.text =  ": " + DropOffAddress  // DropoffLocation
            }
            if let pickupTime = dictData[ "PickupDateTime"] as? String {
                if pickupTime == "" {
                    cell.lblPickUpTime.text = "Date and Time not available"
                }
                else {
                    cell.lblPickUpTime.text = ": " +  pickupTime
//                        setTimeStampToDate(timeStamp: pickupTime)
                }
            }
            
            if let PassDiscount = dictData["PassDiscount"] as? String {
                cell.lblPassDiscount.text = ": \(currencySign)\(String(format: "%.2f", Double((PassDiscount != "") ? PassDiscount : "0.0")!))"
            }
            
            if let DistanceTravelled = dictData["TripDistance"] as? String {
                cell.lblDistanceTravel.text = ": \(String(format: "%.2f", Double((DistanceTravelled != "") ? DistanceTravelled : "0.0")!)) miles"
            }
            
            if let vehicleType = dictData["Model"] as? String {
                cell.lblVehicleType.text = ": " + vehicleType
            }
            if let PaymentType = dictData["PaymentType"] as? String {
                cell.lblPaymentType.text = ": " + PaymentType
            }
            let myString = aryData[ indexPath.row]["DriverName"] as? String
            cell.lblDriverName.text = myString
            
            bookinType = aryData[ indexPath.row]["BookingType"] as! String
            cell.btnCancelRequest.setTitle("Cancel Request".localized, for: .normal)
            cell.btnCancelRequest.addTarget(self, action: #selector(self.CancelRequest), for: .touchUpInside)
            cell.btnCancelRequest.tag = indexPath.row
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
    
    @objc func CancelRequest(sender: UIButton)
    {
        let Index = sender.tag
        let currentData = aryData [Index]
        guard let bookingID = currentData["Id"] as? String else {
            return
        }
        RMUniversalAlert.show(in: self, withTitle:appName, message: "Are you sure you want to cancel this request?", cancelButtonTitle: nil, destructiveButtonTitle: nil, otherButtonTitles: ["Yes", "No"], tap: {(alert, buttonIndex) in
            if (buttonIndex == 2)
            {
                
                let socketData = (self.navigationController?.childViewControllers[0] as! HomeViewController).socket
                let showTopView = self.navigationController?.childViewControllers[0] as! HomeViewController
                
                
                //((self.navigationController?.childViewControllers[1] as! CustomSideMenuViewController).childViewControllers[0].childViewControllers[0] as! HomeViewController).socket
            //((self.navigationController?.childViewControllers[1] as! CustomSideMenuViewController).childViewControllers[0].childViewControllers[0] as! HomeViewController)
                
                if (SingletonClass.sharedInstance.isTripContinue) {
                    
                    //            if (SingletonClass.sharedInstance.bookingId == String(bookingID)) {
                    
                    UtilityClass.setCustomAlert(title: "Your trip has started", message: "You cannot cancel this request.") { (index, title) in
                    }
                    
                    //            }
                    
                }
                else {
                    if self.bookinType == "Book Now"
                    {
                        let myJSON = [SocketDataKeys.kBookingIdNow : bookingID] as [String : Any]
                        socketData.emit(SocketData.kCancelTripByPassenger , with: [myJSON])
                        showTopView.setHideAndShowTopViewWhenRequestAcceptedAndTripStarted(status: false)
                        self.webserviceOfBookingHistory()
                        //                UtilityClass.showAlertWithCompletion("", message: "Your request cancelled successfully", vc: self, completionHandler: { ACTION in
                        //                    self.navigationController?.popViewController(animated: true)
                        //                })
                        
                        //                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                        self.navigationController?.popViewController(animated: true)
                        //                }
                        
                        
                        //                UtilityClass.setCustomAlert(title: "\(appName)", message: "Your request cancelled successfully", completionHandler: { (index, title) in
                        //                    self.navigationController?.popViewController(animated: true)
                        //                })
                    }
                    else {
                        let myJSON = [SocketDataKeys.kBookingIdNow : bookingID] as [String : Any]
                        socketData.emit(SocketData.kAdvancedBookingCancelTripByPassenger , with: [myJSON])
                         self.webserviceOfBookingHistory()
                        //                UtilityClass.showAlertWithCompletion("", message: "Your request cancelled successfully", vc: self, completionHandler: { ACTION in
                        //                    self.navigationController?.popViewController(animated: true)
                        //                })
                        //                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                        self.navigationController?.popViewController(animated: true)
                        //                }
                        //                UtilityClass.setCustomAlert(title: "\(appName)", message: "Your request cancelled successfully", completionHandler: { (index, title) in
                        //                    self.navigationController?.popViewController(animated: true)
                        //                })
                    }
                }
            }
        })
      
        
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
        dateFormatter.dateFormat = "HH:mm dd/MM/yyyy" //Specify your format that you want
        let strDate: String = dateFormatter.string(from: date)
        
        return strDate
    }
    
    func changeDateAndTimeFormate(dateAndTime: String) -> String {
        
        let time = dateAndTime // "22:02:00"
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-mm-dd HH-mm-ss"
        
        var fullDate = dateFormatter.date(from: time)
        
        dateFormatter.dateFormat = "yyyy/mm/dd HH:mm"
        
        var time2 = dateFormatter.string(from: fullDate!)
        
        return time2
    }
    
    
    @objc func webserviceOfBookingHistory()
    {
        if Connectivity.isConnectedToInternet() == false {
            self.refreshControl.endRefreshing()
            UtilityClass.setCustomAlert(title: "Connection Error", message: "Internet connection not available") { (index, title) in
            }
            return
        }
        webserviceForUpcomingBookingList(SingletonClass.sharedInstance.strPassengerID as AnyObject) { (result, status) in
            
            if (status) {
                self.aryData = result["history"] as! [[String:Any]]
                print(self.aryData)
                
                self.reloadDataTableView()
                self.refreshControl.endRefreshing()
                
            }
            else {
                
                print(result)
                
                if let res = result as? String {
                    UtilityClass.setCustomAlert(title: "", message: res) { (index, title) in
                    }
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.setCustomAlert(title: "", message: resDict[ "message"] as! String) { (index, title) in
                    }
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.setCustomAlert(title: "", message: (resAry.object(at: 0) as! NSDictionary)[ "message"] as! String) { (index, title) in
                    }
                }
            }
        }
    }

   
}
