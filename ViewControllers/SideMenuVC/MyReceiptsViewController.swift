//
//  MyReceiptsViewController.swift
//  TickTok User
//
//  Created by Excelent iMac on 13/12/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import MessageUI

class MyReceiptsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {
    
    
    var aryData = NSArray()
    var urlForMail = String()
    var counts = Int()
    var messages = String()
    
    var expandedCellPaths = Set<IndexPath>()
    
    var labelNoData = UILabel()
    
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
        self.counts = 0
      
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
//        labelNoData = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
//        self.labelNoData.text = "Loading..."
//        labelNoData.textAlignment = .center
//        self.view.addSubview(labelNoData)
//        self.tableView.isHidden = true
        
        webserviewOfMyReceipt()
        self.setNavBarWithBack(Title: "My Receipts".localized, IsNeedRightButton: false)
        self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        self.tableView.addSubview(self.refreshControl)
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        webserviewOfMyReceipt()
        
        tableView.reloadData()
        refreshControl.endRefreshing()
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet var tableView: UITableView!
    
    
    //-------------------------------------------------------------
    // MARK: - Table View Methods
    //-------------------------------------------------------------
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.counts
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyRecepitTableViewCell") as! MyRecepitTableViewCell
        cell.selectionStyle = .none
        
        // set Title
        
        cell.lblPickUpLocationTitle.text = "PICKUP LOCATION".localized
        cell.lblDropOffLocationTitle.text = "DROP LOCATION".localized
        
        cell.lblVehicleTypeTitle.text = "VEHICLE TYPE".localized
        cell.lblDistanceTravelledTitle.text = "DISTANCE TRAVELLED".localized
        cell.lblPaymentTypeTitle.text = "PAYMENT TYPE".localized
        
//        cell.lblWaitingTimeTitle.text = "WAITING TIME".localized
//        cell.lblTripStatusTitle.text = "TRIP STATUS".localized
        
        
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
        cell.lblTaxTitle.text = "TAX".localized
        cell.lblDiscountTitle.text = "DISCOUNT".localized
        cell.lblPassDiscountTitle.text = "PASS DISCOUNT"
        cell.lblNexusChargeTitle.text = "NEXUS CHARGE"
        cell.lblTotalNexusChargeTitle.text = "TOTAL NEXUS CHARGE"
        
        
        cell.lblGrandTotalTitle.text = "GRAND TOTAL"
        
        
        //                    cell.lblNightFareTitle.text = "NIGHT FARE".localized

        
//        cell.lblFareTotalTitle.text = "FARE TOTAL".localized
//        cell.lblDiscountAppliedTitle.text = "DISCOUNT APPLIED".localized
//        cell.lblChargedCardTitle.text = "CHARGED CARD".localized
  
/*
        cell.lblPickUpTimeTitle.text = "Pickup Time".localized
        cell.lblDropOffTimeTitle.text = "DropoffTime:".localized
        cell.lblVehicleTypeTitle.text = "Vehicle Type:".localized
        cell.lblPaymentTypeTitle.text = "Payment Type:".localized
        cell.lblBookingFeeTitle.text = "Booking Fee:".localized
        cell.lblTripFareTitle.text = "Trip Fare:".localized
        cell.lblWaitingCostTitle.text = "Waiting Cost".localized
        cell.lblWaitingTimeTitle.text = "Waiting Time".localized
        cell.lblLessTitle.text = "Less".localized
        cell.lblPromoAppliedTitle.text = "Promo Applied:".localized
        cell.lblTotalAmountTitle.text = "Total Amount :".localized
        cell.lblInclTaxTitle.text = "(incl tax)".localized
        cell.lblTripStatusTitlr.text = "Trip Status:".localized
 */
        
        cell.btnGetReceipt.setTitle("GET RECEIPT".localized, for: .normal)
        cell.btnGetReceipt.titleLabel?.font = UIFont.bold(ofSize: 11.0)

        let dictData = self.newAryData.object(at: indexPath.row) as! NSDictionary
        
//        cell.viewCell.layer.cornerRadius = 10
//        cell.viewCell.clipsToBounds = true
//        cell.viewCell.layer.shadowRadius = 3.0
//        cell.viewCell.layer.shadowColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
//        cell.viewCell.layer.shadowOffset = CGSize (width: 1.0, height: 1.0)
//        cell.viewCell.layer.shadowOpacity = 1.0
        
        if dictData["HistoryType"] as! String == "Past" {
            
            if dictData["Status"] as! String == "completed" {
                
                cell.btnGetReceipt.layer.cornerRadius = 5
                cell.btnGetReceipt.layer.masksToBounds = true
                
                //Id
                //CreatedDate
                //PickupTime
                //DropTime
                //Model    vehicletype
                //PaymentType
                //BookingCharge
                //TripFare
                //WaitingTimeCost
                //WaitingTime
                //PromoCode
                //Status
                
//                if let bookingID = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Id") as? String {
//                    cell.lblBookingId.text = "\("Booking Id :".localized) \(bookingID)"
//                }
               
//                "\("Booking Id :".localized) \(String(describing: dictData.object(forKey: "Id")))"
              
                let PickTime = Double(dictData.object(forKey: "PickupTime") as! String)
                let dropoffTime = Double(dictData.object(forKey: "DropTime") as! String)
                
                let unixTimestamp = PickTime //as Double//as! Double//dictData.object(forKey: "PickupTime")
                let unixTimestampDrop = (dropoffTime as! Double)
                let date = Date(timeIntervalSince1970: TimeInterval(unixTimestamp!))
                let dateDrop = Date(timeIntervalSince1970: TimeInterval(unixTimestampDrop))
                let dateFormatter = DateFormatter()
                //        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
                //        dateFormatter.locale = NSLocale.current
                dateFormatter.dateFormat = "yyyy/MM/dd HH:mm" //Specify your format that you want
                let strDate = dateFormatter.string(from: date)
                let strDateDrop = dateFormatter.string(from: dateDrop)
                
                cell.lblDateAndTime.text = dictData.object(forKey: "CreatedDate") as? String
                
                if let PickUpLocation =  dictData.object(forKey: "PickupLocation") as? String {
                    cell.lblPickUpLocationDescription.text = ": " + PickUpLocation
                }
                
                if let DropOffLocation = dictData.object(forKey: "DropoffLocation") as? String {
                    cell.lblDropOffLocationDescription.text = ": " + DropOffLocation
                }
                
                if let VehicleTypeModel = dictData.object(forKey: "Model") as? String {
                    cell.lblVehicleType.text = ": " + VehicleTypeModel
                }
                
                if let DistanceTravelled = dictData["TripDistance"] as? String {
                
                    cell.lblDistanceTravelled.text = ": \(String(format: "%.2f", Double((DistanceTravelled != "") ? DistanceTravelled : "0.0")!)) miles"
                    if DistanceTravelled == "" || DistanceTravelled == "0" {
                        cell.StackDistanceTravelled.isHidden = true
                    } else {
                        cell.StackDistanceTravelled.isHidden = false
                    }
                }
                
                if let PaymentType = dictData[ "PaymentType"] as? String {
                    cell.lblPaymentType.text = ": " + PaymentType
                    if PaymentType == "" {
                        cell.StackPaymentType.isHidden = true
                    } else {
                        cell.StackPaymentType.isHidden = false
                    }
                }
                
                
                if let TripFare = dictData["TripFare"] as? String {
                    cell.lblTripFare.text = ": \(currencySign)" + TripFare
                    if TripFare == "" || TripFare == "0" {
                        cell.StackTripFare.isHidden = true
                    } else {
                        cell.StackTripFare.isHidden = false
                    }
                }
                
                if let MinuteFareCharge = dictData[ "MinuteFareCharge"] as? String {
                    cell.lblMinuteFareCharge.text = ": \(currencySign)" + MinuteFareCharge
                    if MinuteFareCharge == "" || MinuteFareCharge == "0" {
                        cell.StackFareCharge.isHidden = true
                    } else {
                        cell.StackFareCharge.isHidden = false
                    }
                }
                
                if let WaitingTimeCost = dictData[ "WaitingTimeCost"] as? String {
                    cell.lblWaitingCost.text = ": \(currencySign)" + WaitingTimeCost
                    if WaitingTimeCost == "" || WaitingTimeCost == "0" {
                        cell.StackWaitingCost.isHidden = true
                    } else {
                        cell.StackWaitingCost.isHidden = false
                    }
                }

                if let TollFee = dictData["TollFee"] as? String {
                    cell.lblTollFee.text = ": \(currencySign)\(String(format: "%.2f", Double((TollFee != "") ? TollFee : "0.0")!))"
                    
                    if TollFee == "" || TollFee == "0" {
                        cell.StackTollFee.isHidden = true
                    } else {
                        cell.StackTollFee.isHidden = false
                    }
                }
                
              
                

                
                //                    if let nightFare = currentData["NightFare"] as? String {
                //                        cell.lblNightFare.text = nightFare
                //                    }
                
//               if let waitingCost = dictData["WaitingTimeCost"] as? String {
//                    cell.lblWaitingCost.text = ": \(currencySign)" + waitingCost
//                }
                
                if let DistanceFare = dictData["DistanceFare"] as? String {
                    cell.lblDistanceFare.text = ": \(currencySign)\(String(format: "%.2f", Double((DistanceFare != "") ? DistanceFare : "0.0")!))"
                    if DistanceFare == "" || DistanceFare == "0" {
                        cell.StackDistanceFare.isHidden = true
                    } else {
                        cell.StackDistanceFare.isHidden = false
                    }
                }
                
                if let SurgeCharge = dictData["SpecialExtraCharge"] as? String {
                    cell.lblSurgeCharge.text = ": \(currencySign)\(String(format: "%.2f", Double((SurgeCharge != "") ? SurgeCharge : "0.0")!))"
                    if SurgeCharge == "" || SurgeCharge == "0" {
                        cell.StackSurgeCharge.isHidden = true
                    } else {
                        cell.StackSurgeCharge.isHidden = false
                    }
                }
                

                if let TripSubTotal = dictData["SubTotal"] as? String {
                    cell.lblTripSubTotal.text = ": \(currencySign)\(String(format: "%.2f", Double((TripSubTotal != "") ? TripSubTotal : "0.0")!))"
                    
                    if TripSubTotal == "" || TripSubTotal == "0" {
                        cell.StackTripSubTotal.isHidden = true
                    } else {
                        cell.StackTripSubTotal.isHidden = false
                    }
                }
                
                if let tipsDetail = dictData["Tip" ]as? String {
                    cell.lblTips.text = ": \(currencySign)" +  tipsDetail
                    
                    if tipsDetail == "" || tipsDetail == "0" {
                        cell.StackTips.isHidden = true
                    } else {
                        cell.StackTips.isHidden = false
                    }
                }
                
                if let TipSubtotal = dictData["CompanyAmount"] as? String {
                    cell.lblTipsSubTotal.text = ": \(currencySign)" + "\(String(format: "%.2f", Double((TipSubtotal != "") ? TipSubtotal : "0.0")!))"
                    
                    if TipSubtotal == "" || TipSubtotal == "0" {
                        cell.StackTipSubTotal.isHidden = true
                    } else {
                        cell.StackTipSubTotal.isHidden = false
                    }
                }
                
//                if let waitingTime = dictData["WaitingTime"] as? String {
//
//                    var strWaitingTime: String = "00:00:00"
//
//                    if waitingTime != "" {
//                        let intWaitingTime = Int(waitingTime)
//                        let WaitingTimeIs = ConvertSecondsToHoursMinutesSeconds(seconds: intWaitingTime!)
//                        if WaitingTimeIs.0 == 0 {
//                            if WaitingTimeIs.1 == 0 {
//                                strWaitingTime = "00:00:\(WaitingTimeIs.2)"
//                            } else {
//                                strWaitingTime = "00:\(WaitingTimeIs.1):\(WaitingTimeIs.2)"
//                            }
//                        } else {
//                            strWaitingTime = "\(WaitingTimeIs.0):\(WaitingTimeIs.1):\(WaitingTimeIs.2)"
//                        }
//                    }
//                    else {
//                        strWaitingTime = waitingTime
//                    }
//                    cell.lblWaitingTime.text = strWaitingTime
//                }
                
                if let bookingCharge = dictData["BookingCharge"] as? String {
                    cell.lblBookingCharge.text = ": \(currencySign)" + bookingCharge
                    
                    if bookingCharge == "" || bookingCharge == "0" {
                        cell.StackBookingCharge.isHidden = true
                    } else {
                        cell.StackBookingCharge.isHidden = false
                    }
                }
                
                if let Tax = dictData["Tax"] as? String {
                    cell.lblTax.text = ": \(currencySign)\(String(format: "%.2f", Double((Tax != "") ? Tax : "0.0")!)) (Including)"
                    if Tax == "" || Tax == "0" {
                        cell.StackTax.isHidden = true
                    } else {
                        cell.StackTax.isHidden = false
                    }
                }
                
                if let Discount = dictData["Discount"] as? String {
                    cell.lblDiscount.text = ": \(currencySign)\(String(format: "%.2f", Double((Discount != "") ? Discount : "0.0")!))"
                    if Discount == "" || Discount == "0" {
                        cell.StackDiscount.isHidden = true
                    } else {
                        cell.StackDiscount.isHidden = false
                    }
                }
                
                if let PassDiscount = dictData["PassDiscount"] as? String {
                    cell.lblPassDiscount.text = ": \(currencySign)\(String(format: "%.2f", Double((PassDiscount != "") ? PassDiscount : "0.0")!))"
                    if PassDiscount == "" || PassDiscount == "0" {
                        cell.StackPassDiscount.isHidden = true
                    } else {
                        cell.StackPassDiscount.isHidden = false
                    }
                }
                
                if let NexusCharge = dictData["NexusEarning"] as? String {
                    cell.lblNexusCharge.text = ": \(currencySign)\(String(format: "%.2f", Double((NexusCharge != "") ? NexusCharge : "0.0")!))"
                    
                    if NexusCharge  == "" || NexusCharge == "0" {
                        cell.StackNexusCharge.isHidden = true
                    } else {
                        cell.StackNexusCharge.isHidden = false
                    }
                    
                }
                
                if let TotalNexusCharge = dictData["AdminAmount"] as? String {
                    cell.lblTotalNexusCharge.text = ": \(currencySign)\(String(format: "%.2f", Double((TotalNexusCharge != "") ? TotalNexusCharge : "0.0")!))"
                    
                    if TotalNexusCharge == "" || TotalNexusCharge == "0" {
                        cell.StackTotalNexusCharge.isHidden = true
                    } else {
                        cell.StackTotalNexusCharge.isHidden = false
                    }
                }
                
                if let GrandTotal = dictData["GrandTotal"] as? String {
                    cell.lblGrandTotal.text = ": \(currencySign)\(String(format: "%.2f", Double((GrandTotal != "") ? GrandTotal : "0.0")!))"
                    
                    if GrandTotal == "" || GrandTotal == "0" {
                        cell.StackGrandTotal.isHidden = true
                    } else {
                        cell.StackGrandTotal.isHidden = false
                    }
                }
           
                
//                    dictData.object(forKey: "TollFee") as? String
//                cell.lblFareTotal.text = "\(currencySign)\(String(format: "%.2f", Double((dictData["GrandTotal"] as! String != "") ? dictData["GrandTotal"] as! String : "0.0")!))"
////                    dictData.object(forKey: "TripFare") as? String
//                cell.lblDiscountApplied.text = "\(currencySign)\(String(format: "%.2f", Double((dictData["Discount"] as! String != "") ? dictData["Discount"] as! String : "0.0")!))"
////                    dictData.object(forKey: "Discount") as? String
//                cell.lblChargedCard.text = dictData.object(forKey: "PaymentType") as? String
//
                
                /*
                cell.lblPickupTime.text = strDate//dictData.object(forKey: "PickupDateTime") as? String
                
                cell.lblDrooffTime.text = strDateDrop //dictData.object(forKey: "PickupDateTime") as? String
                
                cell.lblDriversNames.text = (dictData.object(forKey: "DriverName") as? String)?.uppercased()
                
                cell.lblDropLocationDescription.text = dictData.object(forKey: "DropoffLocation") as? String
               
                
                cell.lblPaymentType.text = dictData.object(forKey: "PaymentType") as? String
                cell.lblBookingFee.text = "\(dictData.object(forKey: "BookingCharge") as! String) \(currencySign)"
                cell.lblTripFare.text = "\(dictData.object(forKey: "TripFare") as! String) \(currencySign)"
                cell.lblWaitingCost.text = "\(dictData.object(forKey: "WaitingTimeCost") as! String) \(currencySign)"
                cell.lblWaitingTime.text = dictData.object(forKey: "WaitingTime") as? String
                cell.lblPromoCode.text = "\(dictData.object(forKey: "PromoCode") as! String) \(currencySign)"
                cell.lblTotalAmount.text = "\(dictData.object(forKey: "GrandTotal") as! String) \(currencySign)"
                cell.lblTripStatus.text = dictData.object(forKey: "Status") as? String
//                cell.lblDistanceTravelled.text = dictData.object(forKey: "TripDistance") as? String
//                cell.lblTolllFee.text = dictData.object(forKey: "TollFee") as? String
//                cell.lblFareTotal.text = dictData.object(forKey: "TripFare") as? String
//                cell.lblDiscountApplied.text = dictData.object(forKey: "Discount") as? String
//                cell.lblChargedCard.text = dictData.object(forKey: "PaymentType") as? String
//
//                self.urlForMail = dictData.object(forKey: "ShareUrl") as! String
                */
 
                cell.btnGetReceipt.tag = indexPath.row
                cell.btnGetReceipt.addTarget(self, action: #selector(self.getReceipt(sender:)), for: .touchUpInside)
                cell.viewDetails.isHidden = !self.expandedCellPaths.contains(indexPath)
                
                return cell
            }
            else
            {
                return UITableViewCell()
            }
        }
        else {
            return UITableViewCell()
        }
        
        
//        return cell
       
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        if let cell = tableView.cellForRow(at: indexPath) as? MyRecepitTableViewCell {
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
    
    func nevigateToBack()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func getReceipt(sender: UIButton) {
        
        let dictData = self.newAryData.object(at: sender.tag) as! NSDictionary
        if let strContent = dictData.object(forKey: "ShareUrl") as? String {
            let StringContent = "Please download from below link\n\n\(strContent)"
            let share = [StringContent]
            let activityViewController = UIActivityViewController(activityItems: share, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        }
        
//        let emailTitle = ""
//        let messageBody = urlForMail
//        let toRecipents = [""]
//        if MFMailComposeViewController.canSendMail() {
//            let mail = MFMailComposeViewController()
//            mail.mailComposeDelegate = self
//            mail.setToRecipients(toRecipents)
//            mail.setMessageBody(messageBody, isHTML: true)
//
//            present(mail, animated: true)
//        } else {
//            UtilityClass.setCustomAlert(title: "", message: "Your Email Id is not configured from settings. Please configure it from Settings -> Mail") { (index, title) in
//            }
//        }
        
       
    }
    
    func mailComposeController(_ controller:MFMailComposeViewController, didFinishWith result:MFMailComposeResult, error:Error?) {
        switch result {
        case MFMailComposeResult.cancelled:
            print("Mail cancelled")
            messages = "Mail cancelled"
//            UtilityClass.setCustomAlert(title: "Error", message: "Mail cancelled") { (index, title) in
//            }
        case MFMailComposeResult.saved:
            print("Mail saved")
            messages = "Mail saved"
//            UtilityClass.setCustomAlert(title: "Done", message: "Mail saved") { (index, title) in
//            }
        case MFMailComposeResult.sent:
            print("Mail sent")
            messages = "Mail sent"
//            UtilityClass.setCustomAlert(title: "Done", message: "Mail sent") { (index, title) in
//            }
        case MFMailComposeResult.failed:
            print("Mail sent failure: \(String(describing: error?.localizedDescription))")
            messages = "Mail sent failure: \(String(describing: error?.localizedDescription))"
//            UtilityClass.setCustomAlert(title: "Error", message: "Mail sent failure: \(String(describing: error?.localizedDescription))") { (index, title) in
//      }
        default:
            messages = "Something went wrong"
//            UtilityClass.setCustomAlert(title: "Error", message: "Something went wrong") { (index, title) in
//            }
            break
        }
        
        controller.dismiss(animated: true) {
            self.mailAlert(strMsg: self.messages)
        }
    }

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        switch result {
        case MessageComposeResult.cancelled:
            print("Mail cancelled")
            
//            UtilityClass.setCustomAlert(title: "Error", message: "Mail cancelled") { (index, title) in
//            }
            messages = "Mail cancelled"
        case MessageComposeResult.sent:
            print("Mail sent")
            
//            UtilityClass.setCustomAlert(title: "Done", message: "Mail sent") { (index, title) in
//            }
            messages = "Mail sent"
        case MessageComposeResult.failed:
            print("Mail sent failure")
            messages = "Mail sent failure"
        //            UtilityClass.showAlert("", message: "Mail sent failure: \(String(describing: error?.localizedDescription))", vc: self)
        default:
//            UtilityClass.showAlert("", message: "Something went wrong", vc: self)
//            UtilityClass.setCustomAlert(title: "Error", message: "Something went wrong") { (index, title) in
//            }
            messages = "Something went wrong"
//            
            break
        }
        controller.dismiss(animated: true) {
            self.mailAlert(strMsg: self.messages)
        }
    }
    
    
    func mailAlert(strMsg: String) {
        
        UtilityClass.setCustomAlert(title: appName, message: strMsg) { (index, title) in
        }
    }
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    var newAryData = NSMutableArray()
    
    func webserviewOfMyReceipt() {
        
        webserviceForBookingHistory(SingletonClass.sharedInstance.strPassengerID as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
                
                self.aryData = (result as! NSDictionary).object(forKey: "history") as! NSArray
                
                self.counts = 0
                self.newAryData = NSMutableArray()
                
                for i in 0..<self.aryData.count {
                    
                    let dictData = self.aryData.object(at: i) as! NSDictionary
                    
                    if dictData["HistoryType"] as! String == "Past" {
                        
                        if dictData["Status"] as! String == "completed" {
                            self.counts += 1
                            
                            self.newAryData.add(self.aryData.object(at: i) as! NSDictionary)
                        }
                    }
                }
                
                if self.newAryData.count > 0 {
                    self.lblNoDataFound.isHidden = true
                } else {
                    self.lblNoDataFound.isHidden = false
                }
            
               self.tableView.reloadData()
                
            }
            else {
                print(result)
                
                
                if let res = result as? String {
                    UtilityClass.setCustomAlert(title: "Error", message: res) { (index, title) in
                    }
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.setCustomAlert(title: "Error", message: resDict.object(forKey: "message") as! String) { (index, title) in
                    }
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.setCustomAlert(title: "Error", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                    }
                }
            }
        }
    }
    
    
    
}

