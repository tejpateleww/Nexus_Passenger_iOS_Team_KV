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
        refreshControl.tintColor = themeYellowColor
        
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
                    cell.lblDriverName.isHidden = true
                }
                else {
                    let attributedString = NSAttributedString(string: name)
                    let textRange = NSMakeRange(0, attributedString.length)
                    let underlinedMessage = NSMutableAttributedString(attributedString: attributedString)
                    underlinedMessage.addAttribute(NSAttributedStringKey.underlineStyle,
                                                   value:NSUnderlineStyle.styleSingle.rawValue,
                                                   range: textRange)
                    cell.lblDriverName.attributedText = underlinedMessage
//                    cell.lblDriverName.text = name
                }
            }
           
            let formattedString = NSMutableAttributedString()
            formattedString
                .normal("Booking Id: ")
                .bold("\(String(describing: (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Id")!))", 14)
            
            let lbl = UILabel()
            lbl.attributedText = formattedString
            
            cell.lblBookingID.attributedText = formattedString
            
//            cell.lblBookingID.text = "Booking Id: \(String(describing: (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Id")!))"
            
            if let dateAndTime = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "CreatedDate") as? String {
                
                if dateAndTime == "" {
                    cell.lblDateAndTime.isHidden = true
                }
                else {
                    cell.lblDateAndTime.text = dateAndTime
                }
                
            }
//            cell.lblDateAndTime.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "CreatedDate") as? String
            
            // DropOff Address is PickupAddress
            // Pickup Address is DropOffAddress
            
            if let pickupAddress = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "DropoffLocation") as? String {
//                DropoffLocation
                if pickupAddress == "" {
                     cell.lblPickupAddress.isHidden = true
                    
                }
                else {
                    cell.lblPickupAddress.text = pickupAddress
                }
            }
           
            if let dropoffAddress = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PickupLocation") as? String {
//                PickupLocation
                if dropoffAddress == "" {
                    cell.lblDropoffAddress.isHidden = true
                }
                else {
                    cell.lblDropoffAddress.text = dropoffAddress
                }
            }
            
//            cell.lblPickupAddress.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PickupLocation") as? String
//            cell.lblDropoffAddress.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "DropoffLocation") as? String
            
            if let pickupTime = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PickupTime") as? String {
                if pickupTime == "" {
                    cell.lblPickupTime.isHidden = true
                    cell.stackViewPickupTime.isHidden = true
                }
                else {
                    cell.lblPickupTime.text = setTimeStampToDate(timeStamp: pickupTime)
                }
            }
            
            if let DropoffTime = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "DropTime") as? String {
                if DropoffTime == "" {
                    cell.lblDropoffTime.isHidden = true
                    cell.stackViewDropoffTime.isHidden = true
                }
                else {
                    cell.lblDropoffTime.text = setTimeStampToDate(timeStamp: DropoffTime)
                }
            }
            
//            cell.lblPickupTime.text = setTimeStampToDate(timeStamp: ((aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PickupTime") as? String)!)
//            cell.lblDropoffTime.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "DropTime") as? String
            
            if let strModel = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Model") as? String {
                if strModel == "" {
                    cell.lblVehicleType.isHidden = true
                    cell.stackViewVehicleType.isHidden = true
                }
                else {
                    cell.lblVehicleType.text = strModel
                }
            }
//            cell.lblVehicleType.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Model") as? String
            if let strTripDistance = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "TripDistance") as? String {
                if strTripDistance == "" {
                    cell.lblDistanceTravelled.isHidden = true
                    cell.stackViewDistanceTravelled.isHidden = true
                }
                else {
                    cell.lblDistanceTravelled.text = strTripDistance
                }
            }
//            cell.lblDistanceTravelled.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "TripDistance") as? String
            
            
            
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

}


extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String, _ fontSize: CGFloat) -> NSMutableAttributedString {
        let attrs: [NSAttributedStringKey: Any] = [.font: UIFont(name: "AvenirNext-Medium", size: fontSize)!]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let normal = NSAttributedString(string: text)
        append(normal)
        
        return self
    }
}
