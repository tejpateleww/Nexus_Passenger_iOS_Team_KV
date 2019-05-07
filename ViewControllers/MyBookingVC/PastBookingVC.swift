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
    var aryData:[[String:Any]] = []
    var strPickupLat = String()
    var strPickupLng = String()
    var strDropoffLat = String()
    var strDropoffLng = String()
    var PageLimit:Int = 10
    var NeedToReload:Bool = false
    var PageNumber:Int = 1
    
    var strNotAvailable: String = "N/A"
    
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
//        NotificationCenter.default.addObserver(self, selector: #selector(self.ReloadNewData), name: NSNotification.Name(rawValue: NotificationCenterName.keyForPastBooking), object: nil)
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
    
//    @objc func reloadTableView()
//    {
//        self.webserviceOfPastbookingpagination(index: 1)
////        self.aryData = SingletonClass.sharedInstance.aryPastBooking
//        self.tableView.reloadData()
//    }
    
    func reloadTableView() {
        if self.aryData.count > 0 {
            self.lblNoDataFound.isHidden = true
        } else {
            self.lblNoDataFound.isHidden = false
        }
        self.tableView.reloadData()
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.ReloadNewData()
//        tableView.reloadData()
//        refreshControl.endRefreshing()
    }
    
    
    @objc func ReloadNewData() {
        self.PageNumber = 1
        self.NeedToReload = false
        self.aryData.removeAll()
        self.tableView.reloadData()
        self.getPastBookingHistory()
    }
    
    func reloadMoreHistory() {
        self.PageNumber += 1
        self.getPastBookingHistory()
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
            let currentData = aryData[ indexPath.row]
            
            if let TripStatus = currentData["Status"] as? String {
                if TripStatus == "canceled" {
                    
                    let CancelledCell = tableView.dequeueReusableCell(withIdentifier: "CanceledBookingTableViewCell") as! CanceledBookingTableViewCell
                    
                    CancelledCell.lblPickupAddressTitle.text = "PICK UP LOCATION".localized
                    CancelledCell.lblDropoffAddressTitle.text = "DROP OFF LOCATION".localized
                    CancelledCell.lblPickupAddressTitle.text = "PICKUP TIME".localized
                    
                    CancelledCell.lblVehicleTypeTitle.text = "VEHICLE TYPE".localized
                    CancelledCell.lblWaitingTimeTitle.text = "WAITING TIME"
                    CancelledCell.lblPaymentTypeTitle.text = "PAYMENT TYPE".localized
                    CancelledCell.lblTripStatusTitle.text = "TRIP STATUS".localized
                    
                    CancelledCell.lblSurgeChargeTitle.text = "SURGE CHARGE"
                    CancelledCell.lblTollFeeTitle.text = "TOLL FEE"
                    
                    CancelledCell.lblTipsTitle.text = "TIPS"
                    CancelledCell.lblNexusChargeTitle.text = "NEXUS CHARGE"
                    
                    if let DriverName = currentData["DriverName"] as? String {
                        CancelledCell.lblDriverName.text = DriverName
                    } else {
                        CancelledCell.lblDriverName.text = ""
                    }
                    
                    if let BookingId = currentData["Id"] as? String {
                        CancelledCell.lblBookingId.text = "\("Booking Id :".localized) \(BookingId)"
                    }
                    
                    if let pickupAddress = currentData["PickupLocation"] as? String {
                        CancelledCell.lblPickupAddress.text = ": " + pickupAddress
                    }
                    
                    if let dropOffAddress = currentData["DropoffLocation"] as? String {
                        CancelledCell.lblDropoffAddress.text = ": " + dropOffAddress
                    }
                    
                    if let dateAndTime = currentData["CreatedDate"] as? String {
                        CancelledCell.lblDateAndTime.text = dateAndTime
                    }
                    
                    if let VehicleType = currentData[ "Model"] as? String {
                        CancelledCell.lblVehicleType.text = ": " + VehicleType
                        
                        if VehicleType == ""{
                            CancelledCell.StackVehicleType.isHidden  = true
                        } else {
                            CancelledCell.StackVehicleType.isHidden = false
                        }
                    }
                    
                    if let PaymentType = currentData[ "PaymentType"] as? String {
                        CancelledCell.lblPaymentType.text = ": " + PaymentType
                        if PaymentType == "" {
                            CancelledCell.StackPaymentType.isHidden = true
                        } else {
                            CancelledCell.StackPaymentType.isHidden = false
                        }
                    }
                    
                    if let SurgeCharge = currentData["SpecialExtraCharge"] as? String {
                        CancelledCell.lblSurgeCharge.text = ": \(currencySign)\(String(format: "%.2f", Double((SurgeCharge != "") ? SurgeCharge : "0.0")!))"
                        if SurgeCharge == "" || SurgeCharge == "0" {
                            CancelledCell.StackSurgeCharge.isHidden = true
                        } else {
                            CancelledCell.StackSurgeCharge.isHidden = false
                        }
                    }
                    
                    if let TollFee = currentData["TollFee"] as? String {
                        CancelledCell.lblTollFee.text = ": \(currencySign)\(String(format: "%.2f", Double((TollFee != "") ? TollFee : "0.0")!))"
                        if TollFee == "" || TollFee == "0" {
                            CancelledCell.StackTollFee.isHidden = true
                        } else {
                            CancelledCell.StackTollFee.isHidden = false
                        }
                    }
                    
                    if let tollFee = currentData["Tip" ]as? String {
                        if tollFee == "" || tollFee == "0" {
                            CancelledCell.StackTips.isHidden = true
                            CancelledCell.lblTips.text = ": \(currencySign)\(String(format: "%.2f", Double((tollFee != "") ? tollFee : "0.0")!))"
                        } else {
                            CancelledCell.StackTips.isHidden = false
                            CancelledCell.lblTips.text = ": \(currencySign)\(String(format: "%.2f", Double((tollFee != "") ? tollFee : "0.0")!))"
                        }
                    }
                    
                    if let NexusCharge = currentData["NexusEarning"] as? String {
                        CancelledCell.lblNexusCharge.text = ": \(currencySign)\(String(format: "%.2f", Double((NexusCharge != "") ? NexusCharge : "0.0")!))"
                        
                        if NexusCharge  == "" || NexusCharge == "0" {
                            CancelledCell.StackNexusCharge.isHidden = true
                        } else {
                            CancelledCell.StackNexusCharge.isHidden = false
                        }
                    }
                    
                    if let waitingTime = currentData["WaitingTime"] as? String {
                        
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
                        CancelledCell.lblWaitingTime.text =  ": " + strWaitingTime
                        if strWaitingTime  == "" || strWaitingTime == "00:00:00" {
                            CancelledCell.StackWaitingTime.isHidden = true
                        } else {
                            CancelledCell.StackWaitingTime.isHidden = false
                        }
                    }
                    
                    CancelledCell.lblTripStatus.text =  ": " + TripStatus
                    
                    if CancelledCell.StackSurgeCharge.isHidden  == true && CancelledCell.StackTollFee.isHidden == true {
                        CancelledCell.SeparatorSurgeTollfee.isHidden = true
                    } else {
                        CancelledCell.SeparatorSurgeTollfee.isHidden = false
                    }
                    
                    CancelledCell.SeparatorTips.isHidden = CancelledCell.StackTips.isHidden
                    CancelledCell.SeparatorNexusCharge.isHidden = CancelledCell.StackNexusCharge.isHidden
                    
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
                    cell.lblWaitingTimeTitle.text = "WAITING TIME".localized
                    cell.lblTripStatusTitle.text = "TRIP STATUS".localized
                    
                    
                    cell.lblTripFareTitle.text = "TRIP FARE".localized
                    cell.lblMinuteFareChargeTitle.text = "MINUTE FARE CHARGE"
                    cell.lblWaitingCostTitle.text = "WAITING COST".localized
                    cell.lblDistanceFareTitle.text = "DISTANCE FARE"
                    cell.lblSurgeChargeTitle.text = "SURGE CHARGE"
                    cell.lblTollFeeTitle.text = "TOLL FEE".localized
                    cell.lblTripSubTotalTitle.text = "SUB TOTAL"
                    
                    cell.lblTipsTitle.text = "TIPS"
                    cell.lblTipsSubTotalTitle.text = "SUB TOTAL"
                    
                    cell.lblBookingChargeTitle.text = "BOOKING CHARGE".localized

//                    cell.lblNightFareTitle.text = "NIGHT FARE".localized
                    
                    cell.lblTaxTitle.text = "TAX".localized
                    cell.lblDiscountTitle.text = "DISCOUNT".localized
                    cell.lblPassDiscountTitle.text = "PASS DISCOUNT"
                    cell.lblNexusChargeTitle.text = "NEXUS CHARGE"
                    cell.lblTotalNexusChargeTitle.text = "TOTAL NEXUS CHARGE"
                    cell.lblGrandTotalTitle.text = "GRAND TOTAL"
                    cell.lblPaymentTypeTitle.text = "PAYMENT TYPE".localized
//                    cell.lblTotalTitle.text = "TOTAL".localized
                   
                    
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
                    
                    if let DriverName = currentData[ "DriverName"] as? String {
                        cell.lblDriverName.text = DriverName
                    } else {
                        cell.lblDriverName.text = ""
                    }
                    
                    if let BookingId = currentData["Id"] as? String {
                        cell.lblBookingID.text = "\("Booking Id :".localized) \(BookingId)"
                    }
                    
                    if let pickupAddress = currentData["PickupLocation"] as? String {
                        cell.lblPickupAddress.text = ": " + pickupAddress
                    }
                    
                    if let dropOffAddress = currentData["DropoffLocation"] as? String {
                        cell.lblDropoffAddress.text = ": " +  dropOffAddress
                    }
                    
                    if let dateAndTime = currentData["CreatedDate"] as? String {
                        cell.lblDateAndTime.text =  dateAndTime
                    }
      
                    if let pickupTime = currentData["PickupTime"] as? String {
                        cell.lblPickupTime.text = ": " + ((pickupTime != "") ? setTimeStampToDate(timeStamp: pickupTime) : "")
                    }
                    
                    if let dropOffTime = currentData["DropTime"] as? String {
                        cell.lblDropoffTime.text = ": " + ((dropOffTime != "") ? setTimeStampToDate(timeStamp: dropOffTime) : "")
                    }
                    
                    if let VehicleType = currentData[ "Model"] as? String {
                        cell.lblVehicleType.text = ": " + VehicleType
                        
                        if VehicleType == ""{
                            cell.StackVehicleType.isHidden  = true
                        } else {
                            cell.StackVehicleType.isHidden = false
                        }
                    }
                    
                    if let MinuteFareCharge = currentData[ "MinuteFareCharge"] as? String {
                        cell.lblMinuteFareCharge.text = ": \(currencySign)" + MinuteFareCharge
                        if MinuteFareCharge == "" || MinuteFareCharge == "0" {
                            cell.StackFareCharge.isHidden = true
                        } else {
                            cell.StackFareCharge.isHidden = false
                        }
                    }
                    
                    if let WaitingTimeCost = currentData[ "WaitingTimeCost"] as? String {
                        cell.lblWaitingCost.text = ": \(currencySign)" + WaitingTimeCost
                        if WaitingTimeCost == "" || WaitingTimeCost == "0" {
                            cell.StackWaitingCost.isHidden = true
                        } else {
                            cell.StackWaitingCost.isHidden = false
                        }
                    }
                    
                    
                    if let TollFee = currentData["TollFee"] as? String {
                        cell.lblTollFee.text = ": \(currencySign)\(String(format: "%.2f", Double((TollFee != "") ? TollFee : "0.0")!))"
                        if TollFee == "" || TollFee == "0" {
                            cell.StackTollFee.isHidden = true
                        } else {
                            cell.StackTollFee.isHidden = false
                        }
                    }
                    
                    if let DistanceTravelled = currentData["TripDistance"] as? String {
                            cell.lblDistanceTravelled.text = ": \(String(format: "%.2f", Double((DistanceTravelled != "") ? DistanceTravelled : "0.0")!)) miles"
                        if DistanceTravelled == "" || DistanceTravelled == "0" {
                            cell.StackDistanceTravelled.isHidden = true
                        } else {
                            cell.StackDistanceTravelled.isHidden = false
                        }
                    }
                    
                    if let TripFare = currentData["TripFare"] as? String {
                        cell.lblTripFare.text = ": \(currencySign)" + TripFare
                        if TripFare == "" || TripFare == "0" {
                            cell.StackTripFare.isHidden = true
                        } else {
                            cell.StackTripFare.isHidden = false
                        }
                    }
                    
//                    if let nightFare = currentData["NightFare"] as? String {
//                        cell.lblNightFare.text = nightFare
//                    }
                    
                    cell.btnTips.addTarget(self, action: #selector(self.Tips(sender:)), for: .touchUpInside)
                    cell.btnTips.tag = indexPath.row
                    cell.btnTips.layer.cornerRadius = 5
                    cell.btnTips.layer.masksToBounds = true
                    
                    if let tollFee = currentData["Tip" ]as? String {
                        if tollFee == "" || tollFee == "0" {
                            cell.btnTips.isHidden = false
                            cell.StackTips.isHidden = true
                            cell.lblTips.text = ": \(currencySign)\(String(format: "%.2f", Double((tollFee != "") ? tollFee : "0.0")!))"
                        } else {
                            cell.StackTips.isHidden = false
                            cell.lblTips.text = ": \(currencySign)\(String(format: "%.2f", Double((tollFee != "") ? tollFee : "0.0")!))"
                            cell.btnTips.isHidden = true
                        }
                    }
                    
                    
                    if let waitingTime = currentData["WaitingTime"] as? String {
                        
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
                        
                        if strWaitingTime  == "" || strWaitingTime == "00:00:00" {
                            cell.StackWaitingTime.isHidden = true
                        } else {
                            cell.StackWaitingTime.isHidden = false
                        }
                    }
                    
              
                    if let bookingCharge = currentData["BookingCharge"] as? String {
                        cell.lblBookingCharge.text = ": \(currencySign)" + bookingCharge
                        
                        if bookingCharge == "" || bookingCharge == "0" {
                            cell.StackBookingCharge.isHidden = true
                        } else {
                            cell.StackBookingCharge.isHidden = false
                        }
                    }
                    
                    if let Tax = currentData["Tax"] as? String {
                        cell.lblTax.text = ": \(currencySign)\(String(format: "%.2f", Double((Tax != "") ? Tax : "0.0")!)) (Including)"
                        if Tax == "" || Tax == "0" {
                            cell.StackTax.isHidden = true
                        } else {
                            cell.StackTax.isHidden = false
                        }
                    }
                    
                    if let Discount = currentData["Discount"] as? String {
                        cell.lblDiscount.text = ": \(currencySign)\(String(format: "%.2f", Double((Discount != "") ? Discount : "0.0")!))"
                        if Discount == "" || Discount == "0" {
                            cell.StackDiscount.isHidden = true
                        } else {
                            cell.StackDiscount.isHidden = false
                        }
                    }
                    
                    if let PassDiscount = currentData["PassDiscount"] as? String {
                        cell.lblPassDiscount.text = ": \(currencySign)\(String(format: "%.2f", Double((PassDiscount != "") ? PassDiscount : "0.0")!))"
                        if PassDiscount == "" || PassDiscount == "0" {
                            cell.StackPassDiscount.isHidden = true
                        } else {
                            cell.StackPassDiscount.isHidden = false
                        }
                    }

                    if let DistanceFare = currentData["DistanceFare"] as? String {
                        cell.lblDistanceFare.text = ": \(currencySign)\(String(format: "%.2f", Double((DistanceFare != "") ? DistanceFare : "0.0")!))"
                        if DistanceFare == "" || DistanceFare == "0" {
                            cell.StackDistanceFare.isHidden = true
                        } else {
                            cell.StackDistanceFare.isHidden = false
                        }
                    }
                    
                    if let SurgeCharge = currentData["SpecialExtraCharge"] as? String {
                        cell.lblSurgeCharge.text = ": \(currencySign)\(String(format: "%.2f", Double((SurgeCharge != "") ? SurgeCharge : "0.0")!))"
                        if SurgeCharge == "" || SurgeCharge == "0" {
                            cell.StackSurgeCharge.isHidden = true
                        } else {
                            cell.StackSurgeCharge.isHidden = false
                        }
                    }
                    
                    if let TripSubTotal = currentData["SubTotal"] as? String {
                        cell.lblTripSubTotal.text = ": \(currencySign)\(String(format: "%.2f", Double((TripSubTotal != "") ? TripSubTotal : "0.0")!))"
                        
                        if TripSubTotal == "" || TripSubTotal == "0" {
                            cell.StackTripSubTotal.isHidden = true
                        } else {
                            cell.StackTripSubTotal.isHidden = false
                        }
                    }
                    
                    if let TipSubtotal = currentData["CompanyAmount"] as? String {
                        cell.lblTipsSubTotal.text = ": \(currencySign)" + "\(String(format: "%.2f", Double((TipSubtotal != "") ? TipSubtotal : "0.0")!))"
                        
                        if TipSubtotal == "" || TipSubtotal == "0" {
                            cell.StackTipSubTotal.isHidden = true
                        } else {
                            cell.StackTipSubTotal.isHidden = false
                        }
                    }
                    
                    if let NexusCharge = currentData["NexusEarning"] as? String {
                        cell.lblNexusCharge.text = ": \(currencySign)\(String(format: "%.2f", Double((NexusCharge != "") ? NexusCharge : "0.0")!))"
                        
                        if NexusCharge  == "" || NexusCharge == "0" {
                            cell.StackNexusCharge.isHidden = true
                        } else {
                            cell.StackNexusCharge.isHidden = false
                        }
                    }
                    
                    if let TotalNexusCharge = currentData["AdminAmount"] as? String {
                        cell.lblTotalNexusCharge.text = ": \(currencySign)\(String(format: "%.2f", Double((TotalNexusCharge != "") ? TotalNexusCharge : "0.0")!))"
                        
                        if TotalNexusCharge == "" || TotalNexusCharge == "0" {
                            cell.StackTotalNexusCharge.isHidden = true
                        } else {
                            cell.StackTotalNexusCharge.isHidden = false
                        }
                    }
                    
                    if let GrandTotal = currentData["GrandTotal"] as? String {
                        cell.lblGrandTotal.text = ": \(currencySign)\(String(format: "%.2f", Double((GrandTotal != "") ? GrandTotal : "0.0")!))"
                        
                        if GrandTotal == "" || GrandTotal == "0" {
                            cell.StackGrandTotal.isHidden = true
                        } else {
                            cell.StackGrandTotal.isHidden = false
                        }
                    }
                    
                    if let PaymentType = currentData[ "PaymentType"] as? String {
                        cell.lblPaymentType.text = ": " + PaymentType
                        if PaymentType == "" {
                            cell.StackPaymentType.isHidden = true
                        } else {
                            cell.StackPaymentType.isHidden = false
                        }
                    }
                    
                    if let TripStatus = currentData[ "Status"] as? String {
                        cell.lblTripStatus.text = ": " + TripStatus
                        if TripStatus == "" {
                            cell.StackTripStatus.isHidden = true
                        } else {
                            cell.StackTripStatus.isHidden = false
                        }
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
    
    @objc func getPastBookingHistory(){
        
        if Connectivity.isConnectedToInternet() == false {
            self.refreshControl.endRefreshing()
            UtilityClass.setCustomAlert(title: "Connection Error", message: "Internet connection not available") { (index, title) in
            }
            return
        }
        
        webserviceForPastBookingList(SingletonClass.sharedInstance.strPassengerID as AnyObject , PageNumber: self.PageNumber as AnyObject, completion: { (result, status) in
            if (status) {
                
                let arrHistory = (result as! [String:Any])["history"] as! [[String:Any]]
                if arrHistory.count == 10 {
                    self.NeedToReload = true
                } else {
                    self.NeedToReload = false
                }
                
                if self.aryData.count == 0 {
                    self.aryData = arrHistory
                } else {
                    self.aryData.append(contentsOf: arrHistory)
                }
                
                self.reloadTableView()
                
//                if self.LoaderBackView.isHidden == false {
//                    self.ActivityIndicator.stopAnimating()
//                    self.LoaderBackView.isHidden = true
//                }
                
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
        })
    }
    
    
    @objc func Tips(sender: UIButton)
    {
        let Index = sender.tag
        let currentData = aryData[Index]
        //            cell.lblDriverName.text = ""
      
        if let BookingId = currentData["Id"] as? String, let BookingType = currentData["BookingType"] as? String  {
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
                    
                    let tempPastData = (result as! [String:Any])["history"] as! [[String:Any]]
                    
                    for i in 0..<tempPastData.count {
                        
                        let dataOfAry = tempPastData[i]
                        
                        let strHistoryType = dataOfAry["HistoryType"] as? String
                       
                        if strHistoryType == "Past" {
                            self.aryData.append(dataOfAry)
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
        if self.NeedToReload == true && indexPath.row == self.aryData.count - 1  {
            self.reloadMoreHistory()
        }
//        if indexPath.row == (self.aryData.count - 5) {
//            if !isDataLoading{
//                isDataLoading = true
//                self.pageNo = self.pageNo + 1
//                webserviceOfPastbookingpagination(index: self.pageNo)
//            }
//        }
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
