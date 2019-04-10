//
//  PastBookingVC.swift
//  TickTok User
//
//  Created by Excellent Webworld on 09/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

protocol GiveTipAlertDelegate {
    func didOpenTipViewController(BookingId:String, BookingType:String)
}

class PastBookingVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var DelegateForTip:GiveTipAlertDelegate!
    var aryData = NSMutableArray()
    var strPickupLat = String()
    var strPickupLng = String()
    var strDropoffLat = String()
    var strDropoffLng = String()
    
    var strNotAvailable: String = "N/A"
    
    var expandedCellPaths = Set<IndexPath>()
    
    @IBOutlet weak var lblNoDataFound: UILabel!
    
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
        self.lblNoDataFound.text = "No Data Found".localized
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        self.tableView.addSubview(self.refreshControl)
        

        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTableView), name: NSNotification.Name(rawValue: NotificationCenterName.keyForPastBooking), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    
        
    }

     func setLocalization()
     {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func reloadTableView()
    {
        self.webserviceOfPastbookingpagination(index: 1)
//        self.aryData = SingletonClass.sharedInstance.aryPastBooking
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
        var CustomCell = UITableViewCell()
        
        if aryData.count > 0 {
            let currentData = (aryData.object(at: indexPath.row) as! NSDictionary)
            
            if let TripStatus = currentData.object(forKey: "Status") as? String {
                if TripStatus == "canceled" {
                    
                    let CancelledCell = tableView.dequeueReusableCell(withIdentifier: "CanceledBookingTableViewCell") as! CanceledBookingTableViewCell
                    
                    CancelledCell.lblPickupAddressTitle.text = "PICK UP LOCATION".localized
                    CancelledCell.lblDropoffAddressTitle.text = "DROP OFF LOCATION".localized
                    CancelledCell.lblPickupAddressTitle.text = "PICKUP TIME".localized
                    
                    CancelledCell.lblVehicleTypeTitle.text = "VEHICLE TYPE".localized
                    CancelledCell.lblPaymentTypeTitle.text = "PAYMENT TYPE".localized
                    CancelledCell.lblTripStatusTitle.text = "TRIP STATUS".localized
                    
                    if let DriverName = currentData.object(forKey: "DriverName") as? String {
                        CancelledCell.lblDriverName.text = DriverName
                    } else {
                        CancelledCell.lblDriverName.text = ""
                    }
                    
                    if let BookingId = currentData.object(forKey: "Id") as? String {
                        CancelledCell.lblBookingId.text = "\("Booking Id :".localized) : \(BookingId)"
                    }
                    
                    if let pickupAddress = currentData.object(forKey: "PickupLocation") as? String {
                        CancelledCell.lblPickupAddress.text = pickupAddress
                    }
                    
                    if let dropOffAddress = currentData.object(forKey: "DropoffLocation") as? String {
                        CancelledCell.lblDropoffAddress.text = dropOffAddress
                    }
                    
                    if let dateAndTime = currentData.object(forKey: "CreatedDate") as? String {
                        CancelledCell.lblDateAndTime.text = dateAndTime
                    }
                    
                    if let VehicleType = currentData.object(forKey: "Model") as? String {
                        CancelledCell.lblVehicleType.text = VehicleType
                    }
                    
                    if let PaymentType = currentData.object(forKey: "PaymentType") as? String {
                        CancelledCell.lblPaymentType.text = PaymentType
                    }
                    
                    CancelledCell.lblTripStatus.text = TripStatus
                    
                    CancelledCell.viewDetails.isHidden = !expandedCellPaths.contains(indexPath)
                    CancelledCell.selectionStyle = .none
                    CustomCell = CancelledCell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "PastBooingTableViewCell") as! PastBooingTableViewCell
                    
                    cell.lblPickupAddressTitle.text = "PICK UP LOCATION".localized
                    cell.lblDropoffAddressTitle.text = "DROP OFF LOCATION".localized
                    cell.lblPickupTimeTitle.text = "PICKUP TIME".localized
                    cell.lblDropoffTimeTitle.text = "DROPOFF TIME".localized
                    cell.lblVehicleTypeTitle.text = "VEHICLE TYPE".localized
                    cell.lblDistanceTravelledTitle.text = "DISTANCE TRAVELLED".localized
                    cell.lblTripFareTitle.text = "TRIP FARE".localized
                    cell.lblNightFareTitle.text = "NIGHT FARE".localized
                    cell.lblTollFeeTitle.text = "TIPS".localized
                    cell.lblWaitingCostTitle.text = "WAITING COST".localized
                    cell.lblWaitingTimeTitle.text = "WAITING TIME".localized
                    cell.lblBookingCharge.text = "BOOKING CHARGE".localized
                    cell.lblTaxTitle.text = "TAX".localized
                    cell.lblDiscountTitle.text = "DISCOUNT".localized
                    cell.lblPaymentTypeTitle.text = "PAYMENT TYPE".localized
                    cell.lblTotalTitle.text = "TOTAL".localized
                    cell.lblTripStatusTitle.text = "TRIP STATUS".localized
                    
                    cell.btnTips.setTitle("TIPS".localized, for: .normal)
                    cell.btnTips.titleLabel?.font = UIFont.bold(ofSize: 11.0)
                    
                    cell.selectionStyle = .none
                    //            cell.viewCell.layer.cornerRadius = 10
                    //            cell.viewCell.clipsToBounds = true
                    //        cell.viewCell.layer.shadowRadius = 3.0
                    //        cell.viewCell.layer.shadowColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
                    //        cell.viewCell.layer.shadowOffset = CGSize (width: 1.0, height: 1.0)
                    //        cell.viewCell.layer.shadowOpacity = 1.0
                    
                    
                    //            cell.lblDriverName.text = ""
                    
                    if let DriverName = currentData.object(forKey: "DriverName") as? String {
                        cell.lblDriverName.text = DriverName
                    } else {
                        cell.lblDriverName.text = ""
                    }
                    
                    if let BookingId = currentData.object(forKey: "Id") as? String {
                        cell.lblBookingID.text = "\("Booking Id :".localized) : \(BookingId)"
                    }
                    
                    if let pickupAddress = currentData.object(forKey: "PickupLocation") as? String {
                        cell.lblPickupAddress.text = pickupAddress
                    }
                    
                    if let dropOffAddress = currentData.object(forKey: "DropoffLocation") as? String {
                        cell.lblDropoffAddress.text = dropOffAddress
                    }
                    
                    if let dateAndTime = currentData.object(forKey: "CreatedDate") as? String {
                        cell.lblDateAndTime.text = dateAndTime
                    }
                    
                    if let pickupTime = currentData.object(forKey: "PickupTime") as? String {
                        cell.lblPickupTime.text = (pickupTime != "") ? setTimeStampToDate(timeStamp: pickupTime) : ""
                    }
                    
                    if let dropOffTime = currentData.object(forKey: "DropTime") as? String {
                        cell.lblDropoffTime.text = (dropOffTime != "") ? setTimeStampToDate(timeStamp: dropOffTime) : ""
                    }
                    
                    if let VehicleType = currentData.object(forKey: "Model") as? String {
                        cell.lblVehicleType.text = VehicleType
                    }
                    
                    if let DistanceTravelled = currentData.object(forKey: "TripDistance") as? String {
                        cell.lblDistanceTravelled.text = "\(String(format: "%.2f", Double((DistanceTravelled != "") ? DistanceTravelled : "0.0")!)) km"
                        //                DistanceTravelled
                    }
                    
                    if let TripFare = currentData.object(forKey: "TripFare") as? String {
                        cell.lblTripFare.text = TripFare
                    }
                    
                    if let nightFare = currentData.object(forKey: "NightFare") as? String {
                        cell.lblNightFare.text = nightFare
                    }
                    
                    cell.btnTips.addTarget(self, action: #selector(self.Tips(sender:)), for: .touchUpInside)
                    cell.btnTips.tag = indexPath.row
                    cell.btnTips.layer.cornerRadius = 5
                    cell.btnTips.layer.masksToBounds = true
                    
                    if let tollFee = currentData.object(forKey: "TollFee") as? String {
                        if tollFee == "" || tollFee == "0" {
                            cell.btnTips.isHidden = false
                            cell.lblTollFee.text = tollFee
                        } else {
                            cell.lblTollFee.text = tollFee
                            cell.btnTips.isHidden = true
                        }
                    }
                    
                    
                    
                    if let waitingCost = currentData.object(forKey: "WaitingTimeCost") as? String {
                        cell.lblWaitingCost.text = waitingCost
                    }
                    
                    if let waitingTime = currentData.object(forKey: "WaitingTime") as? String {
                        
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
                        cell.lblWaitingTime.text = strWaitingTime
                    }
                    
                    if let bookingCharge = currentData.object(forKey: "BookingCharge") as? String {
                        cell.lblBookingCharge.text = bookingCharge
                    }
                    
                    if let Tax = currentData.object(forKey: "Tax") as? String {
                        cell.lblTax.text = "\(String(format: "%.2f", Double((Tax != "") ? Tax : "0.0")!))"
                    }
                    
                    if let Discount = currentData.object(forKey: "Discount") as? String {
                        cell.lblDiscount.text = "\(String(format: "%.2f", Double((Discount != "") ? Discount : "0.0")!))"
                    }
                    
                    if let PaymentType = currentData.object(forKey: "PaymentType") as? String {
                        cell.lblPaymentType.text = PaymentType
                    }
                    
                    if let Total = currentData.object(forKey: "GrandTotal") as? String {
                        cell.lblTotal.text = Total
                        //                "\(String(format: "%.2f", Double((Total != "") ? Total : "0.0")!))"
                    }
                    
                    if let TripStatus = currentData.object(forKey: "Status") as? String {
                        cell.lblTripStatus.text = TripStatus
                    }
                    
                    cell.viewDetails.isHidden = !expandedCellPaths.contains(indexPath)
                    CustomCell = cell
                }
                
                
            }
            
        }
        
        return CustomCell
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
            
        } else if let cell = tableView.cellForRow(at: indexPath) as? CanceledBookingTableViewCell {
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
    
    @objc func Tips(sender: UIButton)
    {
        let Index = sender.tag
        let currentData = (aryData.object(at:Index) as! NSDictionary)
        //            cell.lblDriverName.text = ""
      
        if let BookingId = currentData.object(forKey: "Id") as? String, let BookingType = currentData.object(forKey: "BookingType") as? String  {
           self.DelegateForTip.didOpenTipViewController(BookingId: BookingId, BookingType: BookingType)
        }
        
    }
    
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
    
    func webserviceOfPastbookingpagination(index: Int)
    {
        
        let driverId = SingletonClass.sharedInstance.strPassengerID //+ "/" + "\(index)"

        webserviceForPastBookingList(driverId as AnyObject, PageNumber: index as AnyObject) { (result, status) in
            if (status) {
                DispatchQueue.main.async {
                    
                    let tempPastData = ((result as! NSDictionary).object(forKey: "history") as! NSArray)
                    
                    for i in 0..<tempPastData.count {
                        
                        let dataOfAry = (tempPastData.object(at: i) as! NSDictionary)
                        
                        let strHistoryType = dataOfAry.object(forKey: "HistoryType") as? String
                        
                        if strHistoryType == "Past" {
                            self.aryData.add(dataOfAry)
                        }
                    }
                    
                    if self.aryData.count > 0 {
                        self.lblNoDataFound.isHidden = true
                    } else {
                        self.lblNoDataFound.isHidden = false
                    }
                    
//                    if(self.aryData.count == 0) {
////                        self.labelNoData.text = "No data found."
////                        self.tableView.isHidden = true
//                    }
//                    else {
////                        self.labelNoData.removeFromSuperview()
//                        self.tableView.isHidden = false
//                    }
                    
                    //                    self.getPostJobs()
                    self.refreshControl.endRefreshing()
                    self.tableView.reloadData()
                    
                    UtilityClass.hideACProgressHUD()
                }
            }
            else {
//                UtilityClass.showAlertOfAPIResponse(param: result, vc: self)
            }

        }
    }
    
    var isDataLoading:Bool=false
    var pageNo:Int = 1
    var didEndReached:Bool=false
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        print("scrollViewWillBeginDragging")
        isDataLoading = false
    }
    
    //Pagination
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        print("scrollViewDidEndDragging")
        if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height) {
            //            if !isDataLoading{
            //                isDataLoading = true
            //                self.pageNo = self.pageNo + 1
            //                webserviceOfPastbookingpagination(index: self.pageNo)
            //            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == (self.aryData.count - 5) {
            if !isDataLoading{
                isDataLoading = true
                self.pageNo = self.pageNo + 1
                webserviceOfPastbookingpagination(index: self.pageNo)
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
