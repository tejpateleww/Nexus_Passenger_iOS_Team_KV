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
    let notAvailable: String = "N/A"
    
    var bookinType = String()
    var isTransport = Bool()
    
    var expandedCellPaths = Set<IndexPath>()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = ThemeBlueColor
        
        return refreshControl
    }()
    
    @IBOutlet weak var lblNoDataFound: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
        
        self.aryData = SingletonClass.sharedInstance.aryUpComming
        if (aryData.count == 0)
        {
            lblNoDataFound.text = "No Data Found"
            tableView.isHidden = true
            lblNoDataFound.isHidden = false
        }
        else
        {
            tableView.isHidden = false
            lblNoDataFound.isHidden = true
        }
        
 
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        self.tableView.addSubview(self.refreshControl)
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadDataTableView), name: NSNotification.Name(rawValue: NotificationCenterName.keyForUpComming), object: nil)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        tableView.reloadData()
       
        self.aryData = SingletonClass.sharedInstance.aryUpComming
        if (aryData.count == 0)
        {
            lblNoDataFound.text = "No Data Found"
            tableView.isHidden = true
            lblNoDataFound.isHidden = false
        }
        else
        {
            tableView.isHidden = false
            lblNoDataFound.isHidden = true
        }
         self.tableView.reloadData()
        refreshControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    @objc func reloadDataTableView()
    {
        self.aryData = SingletonClass.sharedInstance.aryUpComming
        if (aryData.count == 0)
        {
            lblNoDataFound.text = "No Data Found"
            tableView.isHidden = true
            lblNoDataFound.isHidden = false
        }
        else
        {
            tableView.isHidden = false
            lblNoDataFound.isHidden = true
        }
         self.tableView.reloadData()
//        self.tableView.frame.size = tableView.contentSize
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func btnTaxiHistory(_ sender: UIButton) {
        
        if let taxiData = (SingletonClass.sharedInstance.aryUpComming as? [[String:Any]])?.filter({($0["RequestFor"] as? String) == "taxi"}) {
            isTransport = false
            aryData = taxiData as NSArray
            tableView.reloadData()
        }
    }
    
    @IBAction func btnTransportHistory(_ sender: UIButton) {
        
        if let deliveryData = (SingletonClass.sharedInstance.aryUpComming as? [[String:Any]])?.filter({($0["RequestFor"] as? String) == "delivery"}) {
            isTransport = true
            aryData = deliveryData as NSArray
            tableView.reloadData()
        }
    }
    
    //-------------------------------------------------------------
    // MARK: - Table View Methods
    //-------------------------------------------------------------
    
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(aryData.count == 0)
        {
            return 1
        }
        return aryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpCommingTableViewCell") as! UpCommingTableViewCell
//        let Emptycell = tableView.dequeueReusableCell(withIdentifier: "EmptyTableViewCell") as! EmptyTableViewCell
//        cell.constaintOFLblNoDataFond.constant = 0
//        if(aryData.count == 0)
//        {
//
//           cell.constaintOFLblNoDataFond.constant = 40
//             cell.lblNoDataFound.text = " No Data Found"
//
//        }
        
        if aryData.count > 0 {
            
            
            let currentData = (aryData.object(at: indexPath.row) as! [String:AnyObject])
            
            cell.selectionStyle = .none
            
            if isTransport {
                
                if let parcel = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Parcel") as? [String:Any] {
                    
                    if let parcelName = parcel["Name"] as? String {
                        let myString = parcelName
                        let myAttribute = [ NSAttributedStringKey.foregroundColor: UIColor.black, .underlineStyle: NSUnderlineStyle.styleSingle.rawValue] as [NSAttributedStringKey : Any]
                        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
                        cell.lblDriverName.attributedText = myAttrString
                    }
                }
            }
            else {
                let myString = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "DriverName") as? String
                let myAttribute = [ NSAttributedStringKey.foregroundColor: UIColor.black, .underlineStyle: NSUnderlineStyle.styleSingle.rawValue] as [NSAttributedStringKey : Any]
                let myAttrString = NSAttributedString(string: myString!, attributes: myAttribute)
                cell.lblDriverName.attributedText = myAttrString
            }
            
            
            cell.lblPickupAddress.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "DropoffLocation") as? String // PickupLocation
            cell.lblDropoffAddress.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PickupLocation") as? String //  DropoffLocation
            var time = ((aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "CreatedDate") as? String)
            time!.removeLast(3)
            
            cell.lblDateAndTime.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "CreatedDate") as? String
            cell.lblPaymentType.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PaymentType") as? String
  
            if let bookingID = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Id") as? String {
                cell.btnCancelRequest.tag = Int(bookingID)!
            }
            else if let bookingID = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Id") as? Int {
                cell.btnCancelRequest.tag = bookingID
            }
            
            cell.lblPickupTime.text = checkDictionaryHaveValue(dictData: currentData, didHaveValue: "PickupTime", isNotHave: notAvailable)
            cell.lblDistanceTravelled.text = checkDictionaryHaveValue(dictData: currentData, didHaveValue: "TripDistance", isNotHave: notAvailable)
            
            cell.lblBookingId.text = "Booking Id: \(checkDictionaryHaveValue(dictData: currentData, didHaveValue: "Id", isNotHave: notAvailable))"
            
            cell.lblVehicleModel.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Model") as? String
            
            cell.stackViewTransportService.isHidden = true
            
            if let parcel = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Parcel") as? NSDictionary {
                if parcel.count != 0 {
                    if let parcelName = parcel.object(forKey: "Name") as? String {
                        cell.stackViewTransportService.isHidden = false
                        cell.lblTransportService.text = parcelName
                    }
                }
                
            }
//                lblTransportService
            
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
        
        if (SingletonClass.sharedInstance.isTripContinue) {
            
//            if (SingletonClass.sharedInstance.bookingId == String(bookingID)) {
            
            UtilityClass.setCustomAlert(title: "Your trip has started", message: "You cannot cancel this request.") { (index, title) in
            }
            
//            }
            
        }
        else {
            
            let alert = UIAlertController(title: appName, message: "Are you sure to cancel this trip?", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "Yes", style: .default) { (action) in
                
                if self.bookinType == "Book Now" {
                    let myJSON = [SocketDataKeys.kBookingIdNow : bookingID] as [String : Any]
                    socketData.emit(SocketData.kCancelTripByPassenger , with: [myJSON])
                    
                    showTopView.setHideAndShowTopViewWhenRequestAcceptedAndTripStarted(status: false)
                    
                    if let myBooking = self.parent as? MyBookingViewController {
                        myBooking.webserviceOfBookingHistory()
                    }
                    
                    //                UtilityClass.showAlertWithCompletion("", message: "Your request cancelled successfully", vc: self, completionHandler: { ACTION in
                    //                    self.navigationController?.popViewController(animated: true)
                    //                })
                    
                    //                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    //                    self.navigationController?.popViewController(animated: true) // 8-Oct-2018
                    //                }
                    
                    
                    //                UtilityClass.setCustomAlert(title: "\(appName)", message: "Your request cancelled successfully", completionHandler: { (index, title) in
                    //                    self.navigationController?.popViewController(animated: true)
                    //                })
                }
                else {
                    let myJSON = [SocketDataKeys.kBookingIdNow : bookingID] as [String : Any]
                    socketData.emit(SocketData.kAdvancedBookingCancelTripByPassenger , with: [myJSON])
                    
                    if let myBooking = self.parent as? MyBookingViewController {
                        myBooking.webserviceOfBookingHistory()
                    }
                    
                    //                UtilityClass.showAlertWithCompletion("", message: "Your request cancelled successfully", vc: self, completionHandler: { ACTION in
                    //                    self.navigationController?.popViewController(animated: true)
                    //                })
                    //                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    //                    self.navigationController?.popViewController(animated: true)  // 8-Oct-2018
                    //                }
                    //                UtilityClass.setCustomAlert(title: "\(appName)", message: "Your request cancelled successfully", completionHandler: { (index, title) in
                    //                    self.navigationController?.popViewController(animated: true)
                    //                })
                }
            }
            
            let cancel = UIAlertAction(title: "No", style: .default, handler: nil)
            alert.addAction(ok)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
           
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
    
   
}
