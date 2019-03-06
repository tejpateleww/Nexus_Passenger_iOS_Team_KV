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
    
    var expandedCellPaths = Set<IndexPath>()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = ThemeWhiteColor
        
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
            
            
            let currentData = (aryData.object(at: indexPath.row) as! [String:AnyObject])
            
            cell.selectionStyle = .none
            
            cell.viewCell.layer.cornerRadius = 10
            cell.viewCell.clipsToBounds = true
            let myString = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "DriverName") as? String
//            let myAttribute = [ NSAttributedStringKey.foregroundColor: UIColor.black, .underlineStyle: NSUnderlineStyle.styleSingle.rawValue] as [NSAttributedStringKey : Any]
//            let myAttrString = NSAttributedString(string: myString!, attributes: myAttribute)
            cell.lblDriverName.text = myString
            cell.lblPaymentType.text = "Cash"
            cell.lblVehicleType.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Model") as? String
            cell.lblTripStatus.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Status") as? String
            cell.lblPickupAddress.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PickupLocation") as? String // PickupLocation
            cell.lblDropoffAddress.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "DropoffLocation") as? String //  DropoffLocation
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
            
//            cell.lblPickupTime.text = checkDictionaryHaveValue(dictData: currentData, didHaveValue: "PickupTime", isNotHave: notAvailable)
//            cell.lblDistanceTravelled.text = checkDictionaryHaveValue(dictData: currentData, didHaveValue: "TripDistance", isNotHave: notAvailable)
            
            cell.lblBookingId.text = "\("Booking Id :".localized) \(checkDictionaryHaveValue(dictData: currentData, didHaveValue: "Id", isNotHave: notAvailable))"
            
            cell.lblVehicleTypeTitle.text = "Vehicle Type:".localized
            cell.lblPaymentTypeTitle.text = "Payment Type:".localized
            cell.lblTripStatusTitle.text = "Trip Status:".localized
            
            bookinType = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "BookingType") as! String
            cell.btnCancelRequest.setTitle("Cancel Request".localized, for: .normal)
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
    
    @objc func CancelRequest(sender: UIButton)
    {
        
         let bookingID = sender.tag
        
        RMUniversalAlert.show(in: self, withTitle:appName, message: "Are you sure you want to cancel this request?", cancelButtonTitle: nil, destructiveButtonTitle: nil, otherButtonTitles: ["Yes", "No"], tap: {(alert, buttonIndex) in
            if (buttonIndex == 2)
            {
               
                
                let socketData = (self.navigationController?.childViewControllers[0] as! HomeViewController).socket
                //((self.navigationController?.childViewControllers[1] as! CustomSideMenuViewController).childViewControllers[0].childViewControllers[0] as! HomeViewController).socket
                let showTopView = self.navigationController?.childViewControllers[0] as! HomeViewController //((self.navigationController?.childViewControllers[1] as! CustomSideMenuViewController).childViewControllers[0].childViewControllers[0] as! HomeViewController)
                
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
                        
                        //                UtilityClass.showAlertWithCompletion("", message: "Your request cancelled successfully", vc: self, completionHandler: { ACTION in
                        //                    self.navigationController?.popViewController(animated: true)
                        //                })
                        
                        //                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.navigationController?.popViewController(animated: true)
                        //                }
                        
                        
                        //                UtilityClass.setCustomAlert(title: "\(appName)", message: "Your request cancelled successfully", completionHandler: { (index, title) in
                        //                    self.navigationController?.popViewController(animated: true)
                        //                })
                    }
                    else {
                        let myJSON = [SocketDataKeys.kBookingIdNow : bookingID] as [String : Any]
                        socketData.emit(SocketData.kAdvancedBookingCancelTripByPassenger , with: [myJSON])
                        
                        //                UtilityClass.showAlertWithCompletion("", message: "Your request cancelled successfully", vc: self, completionHandler: { ACTION in
                        //                    self.navigationController?.popViewController(animated: true)
                        //                })
                        //                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.navigationController?.popViewController(animated: true)
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
    
   
}
