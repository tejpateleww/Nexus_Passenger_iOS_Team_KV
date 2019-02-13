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
    
    var strNotAvailable: String = "N/A"
    var isTransportService = Bool()
    
    var expandedCellPaths = Set<IndexPath>()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = ThemeBlueColor
        
        return refreshControl
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        self.tableView.addSubview(self.refreshControl)
        
        self.aryData = SingletonClass.sharedInstance.aryPastBooking
        if (aryData.count == 0)
        {
            lblNodataFound.text = "No Data Found"
            tableView.isHidden = true
            lblNodataFound.isHidden = false
        }
        else
        {
            tableView.isHidden = false
            lblNodataFound.isHidden = true
        }
        

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
        
        if (aryData.count == 0)
        {
            lblNodataFound.text = "No Data Found"
            tableView.isHidden = true
            lblNodataFound.isHidden = false
        }
        else
        {
            tableView.isHidden = false
            lblNodataFound.isHidden = true
        }
        
        self.tableView.reloadData()
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        self.aryData = SingletonClass.sharedInstance.aryPastBooking
        
        if (aryData.count == 0)
        {
            lblNodataFound.text = "No Data Found"
            tableView.isHidden = true
            lblNodataFound.isHidden = false
        }
        else
        {
            tableView.isHidden = false
            lblNodataFound.isHidden = true
        }
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblNodataFound: UILabel!
    
    
    @IBAction func btnTaxiHistory(_ sender: UIButton) {
        
        if let taxiData = (SingletonClass.sharedInstance.aryPastBooking as? [[String:Any]])?.filter({($0["RequestFor"] as? String) == "taxi"}) {
            isTransportService = false
            aryData = taxiData as NSArray
            tableView.reloadData()
        }
    }
    
    @IBAction func btnTransportHistory(_ sender: UIButton) {
        
        if let deliveryData = (SingletonClass.sharedInstance.aryPastBooking as? [[String:Any]])?.filter({($0["RequestFor"] as? String) == "delivery"}) {
            isTransportService = true
            aryData = deliveryData as NSArray
            tableView.reloadData()
        }
    }
    
    //-------------------------------------------------------------
    // MARK: - Table View Methods
    //-------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PastBooingTableViewCell") as! PastBooingTableViewCell
        cell.selectionStyle = .none
        
        if aryData.count > 0 {
            
            let currentData = (aryData.object(at: indexPath.row) as! NSDictionary)
            
            if isTransportService {
                
                if let parcel = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Parcel") as? [String:Any] {
                    
                    if let parcelName = parcel["Name"] as? String {
                        let myString = parcelName
                        let myAttribute = [ NSAttributedStringKey.foregroundColor: UIColor.black, .underlineStyle: NSUnderlineStyle.styleSingle.rawValue] as [NSAttributedStringKey : Any]
                        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
                        cell.lblTranportName.attributedText = myAttrString
                        cell.lblTranportName.isHidden = false
                       
                        cell.constantHeightOfTransportName.constant = 21
                    }
                }
            }
            else {
                cell.lblTranportName.isHidden = true
                cell.constantHeightOfTransportName.constant = 0
            }
          
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
            
            let pickupLocation = checkDictionaryHaveValue(dictData: currentData as! [String : AnyObject], didHaveValue: "DropoffLocation", isNotHave: strNotAvailable)
            let dropoffLocation = checkDictionaryHaveValue(dictData: currentData as! [String : AnyObject], didHaveValue: "PickupLocation", isNotHave: strNotAvailable)
            let pickupTime = checkDictionaryHaveValue(dictData: currentData as! [String : AnyObject], didHaveValue: "PickupTime", isNotHave: strNotAvailable)
            let DropoffTime = checkDictionaryHaveValue(dictData: currentData as! [String : AnyObject], didHaveValue: "DropTime", isNotHave: strNotAvailable)
            let strModel = checkDictionaryHaveValue(dictData: currentData as! [String : AnyObject], didHaveValue: "Model", isNotHave: strNotAvailable)
            let strTripDistance = checkDictionaryHaveValue(dictData: currentData as! [String : AnyObject], didHaveValue: "TripDistance", isNotHave: strNotAvailable)
            let strTripFare = checkDictionaryHaveValue(dictData: currentData as! [String : AnyObject], didHaveValue: "TripFare", isNotHave: strNotAvailable)
            let strNightFare = checkDictionaryHaveValue(dictData: currentData as! [String : AnyObject], didHaveValue: "NightFare", isNotHave: strNotAvailable)
            
            let strTollFee = checkDictionaryHaveValue(dictData: currentData as! [String : AnyObject], didHaveValue: "TollFee", isNotHave: strNotAvailable)
            let strWaitingTimeCost = checkDictionaryHaveValue(dictData: currentData as! [String : AnyObject], didHaveValue: "WaitingTimeCost", isNotHave: strNotAvailable)
//            let strModel = checkDictionaryHaveValue(dictData: currentData as! [String : AnyObject], didHaveValue: "Model", isNotHave: strNotAvailable)
//            let strTripDistance = checkDictionaryHaveValue(dictData: currentData as! [String : AnyObject], didHaveValue: "TripDistance", isNotHave: strNotAvailable)
//            let strTripFare = checkDictionaryHaveValue(dictData: currentData as! [String : AnyObject], didHaveValue: "TripFare", isNotHave: strNotAvailable)
//            let strNightFare = checkDictionaryHaveValue(dictData: currentData as! [String : AnyObject], didHaveValue: "NightFare", isNotHave: strNotAvailable)
            
            
            
            let waitingTime = checkDictionaryHaveValue(dictData: currentData as! [String : AnyObject], didHaveValue: "WaitingTime", isNotHave: strNotAvailable)
            
            var strWaitingTime: String = "00:00:00"
      
            if waitingTime != strNotAvailable {
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
            
            cell.lblWaitingTime.text = strWaitingTime
            
            cell.lblPickupAddress.text = pickupLocation
            cell.lblDropoffAddress.text = dropoffLocation
            
            if pickupTime == strNotAvailable {
                 cell.lblPickupTime.text = pickupTime
            } else {
                 cell.lblPickupTime.text = setTimeStampToDate(timeStamp: pickupTime)
            }
            
            if DropoffTime == strNotAvailable {
                 cell.lblDropoffTime.text = DropoffTime
            } else {
                cell.lblDropoffTime.text = setTimeStampToDate(timeStamp: DropoffTime)
            }
            
            cell.lblVehicleType.text = strModel
            cell.lblDistanceTravelled.text = strTripDistance
            cell.lblTripFare.text = strTripFare
            cell.lblNightFare.text = strNightFare
            
            
            cell.lblTollFee.text = strTollFee // (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "TollFee") as? String
            cell.lblWaitingCost.text = strWaitingTimeCost // (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "WaitingTimeCost") as? String
            cell.lblBookingCharge.text = checkDictionaryHaveValue(dictData: currentData as! [String : AnyObject], didHaveValue: "BookingCharge", isNotHave: strNotAvailable) //(aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "BookingCharge") as? String
            cell.lblTax.text = checkDictionaryHaveValue(dictData: currentData as! [String : AnyObject], didHaveValue: "Tax", isNotHave: strNotAvailable) // (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Tax") as? String
            cell.lblDiscount.text = checkDictionaryHaveValue(dictData: currentData as! [String : AnyObject], didHaveValue: "Discount", isNotHave: strNotAvailable)// (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Discount") as? String
            cell.lblPaymentType.text = checkDictionaryHaveValue(dictData: currentData as! [String : AnyObject], didHaveValue: "PaymentType", isNotHave: strNotAvailable)//(aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PaymentType") as? String
            cell.lblTotalCost.text = checkDictionaryHaveValue(dictData: currentData as! [String : AnyObject], didHaveValue: "GrandTotal", isNotHave: strNotAvailable)
    
            
            
//            if let pickupAddress = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "DropoffLocation") as? String {
////                DropoffLocation
//                if pickupAddress == "" {
//                     cell.lblPickupAddress.isHidden = true
//                }
//                else {
//                    cell.lblPickupAddress.text = pickupAddress
//                }
//            }
           
//            if let dropoffAddress = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PickupLocation") as? String {
////                PickupLocation
//                if dropoffAddress == "" {
//                    cell.lblDropoffAddress.isHidden = true
//                }
//                else {
//                    cell.lblDropoffAddress.text = dropoffAddress
//                }
//            }
            
//            cell.lblPickupAddress.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PickupLocation") as? String
//            cell.lblDropoffAddress.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "DropoffLocation") as? String
            
//            if let pickupTime = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PickupTime") as? String {
//                if pickupTime == "" {
//                    cell.lblPickupTime.isHidden = true
//                    cell.stackViewPickupTime.isHidden = true
//                }
//                else {
//                    cell.lblPickupTime.text = setTimeStampToDate(timeStamp: pickupTime)
//                }
//            }
            
//            if let DropoffTime = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "DropTime") as? String {
//                if DropoffTime == "" {
//                    cell.lblDropoffTime.isHidden = true
//                    cell.stackViewDropoffTime.isHidden = true
//                }
//                else {
//                    cell.lblDropoffTime.text = setTimeStampToDate(timeStamp: DropoffTime)
//                }
//            }
            
//            cell.lblPickupTime.text = setTimeStampToDate(timeStamp: ((aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PickupTime") as? String)!)
//            cell.lblDropoffTime.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "DropTime") as? String
            
//            if let strModel = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Model") as? String {
//                if strModel == "" {
//                    cell.lblVehicleType.isHidden = true
//                    cell.stackViewVehicleType.isHidden = true
//                }
//                else {
//                    cell.lblVehicleType.text = strModel
//                }
//            }
//            cell.lblVehicleType.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Model") as? String
//            if let strTripDistance = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "TripDistance") as? String {
//                if strTripDistance == "" {
//                    cell.lblDistanceTravelled.isHidden = true
//                    cell.stackViewDistanceTravelled.isHidden = true
//                }
//                else {
//                    cell.lblDistanceTravelled.text = strTripDistance
//                }
//            }
//            cell.lblDistanceTravelled.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "TripDistance") as? String
            
            
//            if let strTripFare = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "TripFare") as? String {
//                if strTripFare == "" {
//                    cell.lblTripFare.text = strNotAvailable
//                }
//                else {
//                    cell.lblTripFare.text = strTripFare
//                }
//            }

//            if let strNightFare = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "NightFare") as? String {
//                if strNightFare == "" {
//                    cell.lblNightFare.isHidden = true
//                    cell.stackViewNightFare.isHidden = true
//                }
//                else {
//                    cell.lblNightFare.text = strNightFare
//                }
//            }
            
            
//            cell.lblTripFare.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "TripFare") as? String
//            cell.lblNightFare.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "NightFare") as? String
            
            
//            cell.lblTollFee.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "TollFee") as? String
//            cell.lblWaitingCost.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "WaitingTimeCost") as? String
//            cell.lblBookingCharge.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "BookingCharge") as? String
//            cell.lblTax.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Tax") as? String
//            cell.lblDiscount.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Discount") as? String
//            cell.lblPaymentType.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PaymentType") as? String
//            cell.lblTotalCost.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "GrandTotal") as? String
            
            
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
    
    func webserviceOfPastBookingWithPagination(index: Int = 1, loader: Bool) {
        
        let param = SingletonClass.sharedInstance.strPassengerID + "/" + "\(index)"
        
        webserviceForPastBookingData(param as AnyObject, showLoader: loader) { (result, status) in
            
            if (status) {
                
            }
            else {
                
            }
        }
    }
    
    // ----------------------------------------------------
    // MARK: - Pagination
    // ----------------------------------------------------
    
    var isDataLoading:Bool = false
    var pageNo:Int = 0
    var limit:Int = 20
    var offset:Int = 0 //pageNo*limit
    var didEndReached:Bool = false
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        print("scrollViewWillBeginDragging")
        isDataLoading = false
    }
    
    //Pagination
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        print("scrollViewDidEndDragging")
        
        let contentSize = scrollView.contentSize.height
        let tableSize = scrollView.frame.size.height - scrollView.contentInset.top - scrollView.contentInset.bottom
        let canLoadFromBottom = contentSize > tableSize
        
        // Offset
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let difference = maximumOffset - currentOffset
        
        if canLoadFromBottom, difference <= -120.0 {
            // Save the current bottom inset
            let previousScrollViewBottomInset = scrollView.contentInset.bottom
            // Add 50 points to bottom inset, avoiding it from laying over the refresh control.
            scrollView.contentInset.bottom = previousScrollViewBottomInset + 50
            
            // loadMoreData function call
            //            loadMoreDataFunction(){ result in
            //                // Reset the bottom inset to its original value
            //                scrollView.contentInset.bottom = previousScrollViewBottomInset
            //            }
            
            if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height) {
                if !isDataLoading{
                    isDataLoading = true
                    self.pageNo = self.pageNo + 1
                    self.limit = self.limit + 10
                    self.offset = self.limit * self.pageNo
                    //                loadCallLogData(offset: self.offset, limit: self.limit)
                   
                    scrollView.contentInset.bottom = previousScrollViewBottomInset
                }
            }
        }
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
