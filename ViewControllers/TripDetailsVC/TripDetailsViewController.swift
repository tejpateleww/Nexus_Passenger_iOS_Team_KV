//
//  TripDetailsViewController.swift
//  TickTok User
//
//  Created by Excellent Webworld on 06/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class TripDetailsViewController: BaseViewController {

    var arrData = NSMutableArray()
    let dictData = NSMutableDictionary()
    var delegate: CompleterTripInfoDelegate!
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------

    @IBOutlet weak var lblPickUpTitle: UILabel!
    @IBOutlet weak var lblDropOfTitle: UILabel!
    
    @IBOutlet weak var lblPickupLocation: UILabel!
    @IBOutlet weak var lblDropoffLocation: UILabel!
    @IBOutlet weak var lblBaseFare: UILabel!
    @IBOutlet weak var lblDistanceFare: UILabel!
    @IBOutlet weak var lblNightFare: UILabel!
    @IBOutlet weak var lblWaitingCost: UILabel!
    @IBOutlet weak var lblTollFee: UILabel!
    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet weak var lblBookingCharge: UILabel!
    @IBOutlet weak var lblSpecialExtraCharge: UILabel!
    @IBOutlet weak var lblTax: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblGrandTotal: UILabel!
    
    
    @IBOutlet var lblTripFare: UILabel!
    @IBOutlet var lblMinuteFareCharge: UILabel!
    @IBOutlet var lblSurgeCharge: UILabel!
    @IBOutlet var lblTip: UILabel!
    @IBOutlet var lblTipSubTotal: UILabel!
    @IBOutlet var lblPassDiscount: UILabel!
    @IBOutlet var lblNexusCharge: UILabel!
    @IBOutlet var lblTotalNexusCharge: UILabel!
    @IBOutlet weak var stackViewSpecialExtraCharge: UIStackView!
    @IBOutlet weak var tblObject : UITableView!
    
    
//    @IBOutlet weak var lblPickUpLocaltion: UILabel!
//    @IBOutlet weak var lblDropuplocation: UILabel!
//    @IBOutlet weak var lblDrpupLocationDetail: UILabel!
//    @IBOutlet weak var lblBaseFareDesc: UILabel!

    @IBOutlet weak var lblDistanceFareTitle: UILabel!
    @IBOutlet weak var lblNightFareTitle: UILabel!
    @IBOutlet weak var lblSubTotalTitle: UILabel!
    @IBOutlet weak var lblGrandTotalTitle: UILabel!
    @IBOutlet weak var lblDiscountTitle: UILabel!
    @IBOutlet weak var lblTaxTitle: UILabel!
    @IBOutlet weak var lblSpecialChargeTitle: UILabel!
    @IBOutlet weak var lblBookingChargeTitle: UILabel!
    @IBOutlet weak var lblWaitingCostTitle: UILabel!
    
    
    
    @IBOutlet var lblTripFareTitle: UILabel!
    @IBOutlet var lblMinuteFareChargeTitle: UILabel!
    @IBOutlet var lblSurgeChargeTitle: UILabel!
    @IBOutlet var lblTollFeeTitle: UILabel!
    @IBOutlet var lblTipTitle: UILabel!
    @IBOutlet var lblTipSubTotalTitle: UILabel!
    @IBOutlet var lblPassDiscountTitle: UILabel!
    @IBOutlet var lblNexusChargeTitle: UILabel!
    @IBOutlet var lblTotalNexusChargeTitle: UILabel!
    
    
    @IBOutlet var StackTripFare: UIStackView!
    @IBOutlet var StackNightFare: UIStackView!
    @IBOutlet var StackFareCharge: UIStackView!
    @IBOutlet var StackWaitingCost: UIStackView!
    @IBOutlet var StackDistanceFare: UIStackView!
    @IBOutlet var StackSurgeCharge: UIStackView!
    @IBOutlet var StackTollFee: UIStackView!
    @IBOutlet var StackTripSubTotal: UIStackView!
    
    
    @IBOutlet var StackTips: UIStackView!
    @IBOutlet var StackTipSubTotal: UIStackView!
    
    @IBOutlet var StackBookingCharge: UIStackView!
    @IBOutlet var StackSpecialCharge: UIStackView!
    @IBOutlet var StackTax: UIStackView!
    @IBOutlet var StackDiscount: UIStackView!
    @IBOutlet var StackPassDiscount: UIStackView!
    @IBOutlet var StackNexusCharge: UIStackView!
    @IBOutlet var StackTotalNexusCharge: UIStackView!
    
    @IBOutlet var StackGrandTotal: UIStackView!
    
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setData()
        
//        self.tblObject.estimatedRowHeight = 100.0;
//        self.tblObject.rowHeight = UITableViewAutomaticDimension;
//        self.tblObject.tableFooterView = UIView()

        let dict = NSMutableDictionary(dictionary: arrData.object(at: 0) as! NSDictionary) as NSMutableDictionary
        dictData.setObject(dict.object(forKey: "PickupLocation")!, forKey: "Pickup Location" as NSCopying)
        dictData.setObject(dict.object(forKey: "DropoffLocation")!, forKey: "Dropoff Location" as NSCopying)
        dictData.setObject(dict.object(forKey: "NightFare")!, forKey: "Night Fee" as NSCopying)
        dictData.setObject(dict.object(forKey: "TripFare")!, forKey: "Trip Fee" as NSCopying)
        dictData.setObject(dict.object(forKey: "WaitingTimeCost")!, forKey: "Waiting Cost" as NSCopying)
        dictData.setObject(dict.object(forKey: "BookingCharge")!, forKey: "Booking Charge" as NSCopying)
        dictData.setObject(dict.object(forKey: "Discount")!, forKey: "Discount" as NSCopying)
        dictData.setObject(dict.object(forKey: "SubTotal")!, forKey: "Sub Total" as NSCopying)
        dictData.setObject(dict.object(forKey: "Status")!, forKey: "Status" as NSCopying)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
          self.setNavBarWithBack(Title: "TRIP DETAIL".localized, IsNeedRightButton: false)
        setLocalization()
        
    }
    
    func setLocalization()
    {
        lblPickUpTitle.text = "Pickup Location :".localized
        lblDropOfTitle.text = "Dropoff Location :".localized
        lblTripFareTitle.text = "Trip Fare :"
        lblNightFareTitle.text = "Night Fare :"
        lblMinuteFareChargeTitle.text = "Minute Fare Charge :"
        lblWaitingCostTitle.text = "Waiting Cost :".localized
//        lblBaseFareTitle.text = "Base Fare :".localized
        lblDistanceFareTitle.text = "Distance Fare :".localized
        lblSurgeChargeTitle.text = "Surge Charge :"
        lblTollFeeTitle.text = "Toll Fee :"
        lblSubTotalTitle.text = "Sub Total :"
        lblTipTitle.text = "Tips :"
        lblTipSubTotalTitle.text  = "Sub Total :"
        
        
//        lblTollFreeTitle.text = "Tips :".localized
        lblBookingChargeTitle.text = "Booking Charge :".localized
        lblSpecialChargeTitle.text = "Special Extra Charge :".localized
        lblTaxTitle.text = "Tax :".localized
        lblDiscountTitle.text = "Discount :".localized
        lblPassDiscountTitle.text = "Pass Discount :"
        lblNexusChargeTitle.text = "Nexus Charge :"
        lblTotalNexusChargeTitle.text = "Total Nexus Charge :"
        
        lblGrandTotalTitle.text = "Grand Total :".localized
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    func setData() {
        
        if let data = arrData.object(at: 0) as? NSDictionary {
            
            let distanceFare = "\(data.object(forKey: "DistanceFare")!) (\(data.object(forKey: "TripDistance")!) miles)"
        
            lblPickupLocation.text = data.object(forKey: "PickupLocation") as? String
            lblDropoffLocation.text = data.object(forKey: "DropoffLocation") as? String
            
    
            if let TripFare = data.object(forKey:"TripFare") as? String {
                self.lblTripFare.text = "\(currencySign)" + TripFare
                if TripFare == "" || TripFare == "0" {
                    self.StackTripFare.isHidden = true
                } else {
                    self.StackTripFare.isHidden = false
                }
            }
//           lblTripFare.text = "\(currencySign) \(data.object(forKey: "TripFare") as! String)"
            
            
            lblNightFare.text =  "\(currencySign) \(data.object(forKey: "NightFare") as! String)"
            
            if let MinuteFareCharge = data.object(forKey: "MinuteFareCharge" ) as? String {
                self.lblMinuteFareCharge.text = "\(currencySign)" + MinuteFareCharge
                if MinuteFareCharge == "" || MinuteFareCharge == "0" {
                    self.StackFareCharge.isHidden = true
                } else {
                    self.StackFareCharge.isHidden = false
                }
            }
//            lblMinuteFareCharge.text = "\(currencySign) \(data.object(forKey: "MinuteFareCharge") as! String)"
            
            if let DistanceFare =  data.object(forKey: "DistanceFare" ) as? String {
                self.lblDistanceFare.text = "\(currencySign)\(String(format: "%.2f", Double((DistanceFare != "") ? DistanceFare : "0.0")!))"
                if DistanceFare == "" || DistanceFare == "0" {
                    self.StackDistanceFare.isHidden = true
                } else {
                    self.StackDistanceFare.isHidden = false
                }
            }
//            lblDistanceFare.text = "\(currencySign) \(distanceFare)"
            
            if let SurgeCharge = data.object(forKey: "SpecialExtraCharge") as? String {
                self.lblSurgeCharge.text = "\(currencySign)\(String(format: "%.2f", Double((SurgeCharge != "") ? SurgeCharge : "0.0")!))"
                if SurgeCharge == "" || SurgeCharge == "0" {
                    self.StackSurgeCharge.isHidden = true
                } else {
                    self.StackSurgeCharge.isHidden = false
                }
            }
//            lblSurgeCharge.text = ""
            
            if let TollFee = data.object(forKey: "TollFee") as? String {
                self.lblTollFee.text = "\(currencySign)\(String(format: "%.2f", Double((TollFee != "") ? TollFee : "0.0")!))"
                if TollFee == "" || TollFee == "0" {
                    self.StackTollFee.isHidden = true
                } else {
                    self.StackTollFee.isHidden = false
                }
            }
//            lblTollFee.text = "\(currencySign) \(data.object(forKey: "TollFee") as! String)"
            
            if let TripSubTotal =  data.object(forKey: "SubTotal" ) as? String {
                self.lblSubTotal.text = "\(currencySign)\(String(format: "%.2f", Double((TripSubTotal != "") ? TripSubTotal : "0.0")!))"
                
                if TripSubTotal == "" || TripSubTotal == "0" {
                    self.StackTripSubTotal.isHidden = true
                } else {
                    self.StackTripSubTotal.isHidden = false
                }
            }
//            lblSubTotal.text = "\(currencySign) \(data.object(forKey: "SubTotal") as! String)"
            
            if let WaitingTimeCost = data.object(forKey: "WaitingTimeCost") as? String {
                lblWaitingCost.text = "\(currencySign)" + WaitingTimeCost
                if WaitingTimeCost == "" || WaitingTimeCost == "0" {
                    self.StackWaitingCost.isHidden = true
                } else {
                    self.StackWaitingCost.isHidden = false
                }
            }
//            lblWaitingCost.text = "\(currencySign) \(data.object(forKey: "WaitingTimeCost") as! String)"
            
            if let tollFee = data.object(forKey: "Tip") as? String {
                if tollFee == "" || tollFee == "0" {
                    self.StackTips.isHidden = true
                    self.lblTip.text = "\(currencySign)\(String(format: "%.2f", Double((tollFee != "") ? tollFee : "0.0")!))"
                } else {
                    self.StackTips.isHidden = false
                    self.lblTip.text = "\(currencySign)\(String(format: "%.2f", Double((tollFee != "") ? tollFee : "0.0")!))"
                }
            }
            
            if let TipSubtotal = data.object(forKey: "CompanyAmount") as? String {
                self.lblTipSubTotal.text = "\(currencySign)" + "\(String(format: "%.2f", Double((TipSubtotal != "") ? TipSubtotal : "0.0")!))"
                
                if TipSubtotal == "" || TipSubtotal == "0" {
                    self.StackTipSubTotal.isHidden = true
                } else {
                    self.StackTipSubTotal.isHidden = false
                }
            }
            
            if let bookingCharge =  data.object(forKey: "BookingCharge") as? String {
                self.lblBookingCharge.text = "\(currencySign)" + bookingCharge
                
                if bookingCharge == "" || bookingCharge == "0" {
                    self.StackBookingCharge.isHidden = true
                } else {
                    self.StackBookingCharge.isHidden = false
                }
            }
            //lblBookingCharge.text = "\(currencySign) \(data.object(forKey: "BookingCharge") as! String)"
            
            if let Tax =  data.object(forKey: "Tax") as? String {
                self.lblTax.text = "\(currencySign)\(String(format: "%.2f", Double((Tax != "") ? Tax : "0.0")!)) (Including)"
                if Tax == "" || Tax == "0" {
                    self.StackTax.isHidden = true
                } else {
                    self.StackTax.isHidden = false
                }
            }
//           lblTax.text = "\(currencySign) \(data.object(forKey: "Tax") as! String)"
            
            
            if let Discount =  data.object(forKey: "Discount") as? String {
                self.lblDiscount.text = "\(currencySign)\(String(format: "%.2f", Double((Discount != "") ? Discount : "0.0")!))"
                if Discount == "" || Discount == "0" {
                    self.StackDiscount.isHidden = true
                } else {
                    self.StackDiscount.isHidden = false
                }
            }
//            lblDiscount.text = "\(currencySign) \(data.object(forKey: "Discount") as! String)"
            
            
            if let PassDiscount =  data.object(forKey: "PassDiscount") as? String {
                    self.lblPassDiscount.text = "\(currencySign)\(String(format: "%.2f", Double((PassDiscount != "") ? PassDiscount : "0.0")!))"
                if PassDiscount == "" || PassDiscount == "0" {
                    self.StackPassDiscount.isHidden = true
                } else {
                    self.StackPassDiscount.isHidden = false
                }
            }
//            lblPassDiscount.text = "\(currencySign) \(data.object(forKey: "PassDiscount") as! String)"
            
            if let NexusCharge = data.object(forKey: "NexusEarning") as? String {
                self.lblNexusCharge.text = "\(currencySign)\(String(format: "%.2f", Double((NexusCharge != "") ? NexusCharge : "0.0")!))"
                
                if NexusCharge  == "" || NexusCharge == "0" {
                    self.StackNexusCharge.isHidden = true
                } else {
                    self.StackNexusCharge.isHidden = false
                }
            }
//            lblNexusCharge.text = ""
            
            
            if let TotalNexusCharge = data.object(forKey: "AdminAmount") as? String {
                self.lblTotalNexusCharge.text = "\(currencySign)\(String(format: "%.2f", Double((TotalNexusCharge != "") ? TotalNexusCharge : "0.0")!))"
                
                if TotalNexusCharge == "" || TotalNexusCharge == "0" {
                    self.StackTotalNexusCharge.isHidden = true
                } else {
                    self.StackTotalNexusCharge.isHidden = false
                }
            }
//            lblTotalNexusCharge.text = ""
            
            if let GrandTotal =  data.object(forKey: "GrandTotal" ) as? String {
                self.lblGrandTotal.text = "\(currencySign)\(String(format: "%.2f", Double((GrandTotal != "") ? GrandTotal : "0.0")!))"
                
                if GrandTotal == "" || GrandTotal == "0" {
                    self.StackGrandTotal.isHidden = true
                } else {
                    self.StackGrandTotal.isHidden = false
                }
            }
//            lblGrandTotal.text = "\(currencySign) \(data.object(forKey: "GrandTotal") as! String)"
            
            var strSpecial = String()
            
            if let special = data.object(forKey: "Special") as? String {
                strSpecial = special
            } else if let special = data.object(forKey: "Special") as? Int {
                strSpecial = String(special)
            }
            
            stackViewSpecialExtraCharge.isHidden = true
            if strSpecial == "1" {
                stackViewSpecialExtraCharge.isHidden = false
                lblSpecialExtraCharge.text = "\(currencySign) \(data.object(forKey: "SpecialExtraCharge") as! String)"
            }
        }
    }
    
    @IBAction func btnBackAction(sender: UIButton) {
        
//       NotificationCenter.default.addObserver(self, selector: #selector(YourClassName.methodOfReceivedNotification(notification:)), name: Notification.Name("CallToRating"), object: nil)
        
//        NotificationCenter.default.post(name: Notification.Name("CallToRating"), object: nil)
        
//        self.delegate.didRatingCompleted()
        self.dismiss(animated: true, completion: nil)
    }
    

    
    @IBOutlet weak var btnCall: UIButton!
    @IBAction func btCallClicked(_ sender: UIButton)
    {
        
        let contactNumber = helpLineNumber
        
        if contactNumber == "" {
            UtilityClass.setCustomAlert(title: "\(appName)", message: "Contact number is not available") { (index, title) in
            }
        }
        else
        {
            callNumber(phoneNumber: contactNumber)
        }
    }
    
    private func callNumber(phoneNumber:String) {
        
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
 /*
    {
    "Info": [
    {
    "Id": 263,
    "PassengerId": 29,
    "ModelId": 5,
    "DriverId": 42,
    "CreatedDate": "2017-11-25T11:31:59.000Z",
    "TransactionId": "",
    "PaymentStatus": "",
    "PickupTime": "1511589728",
    "DropTime": "",
    "TripDuration": "",
    "TripDistance": "0.001",
    "PickupLocation": "119, Science City Rd, Sola, Ahmedabad, Gujarat 380060, India",
    "DropoffLocation": "Iscon Mega Mall, Ahmedabad, Gujarat, India",
    "NightFareApplicable": 0,
    "NightFare": "0",
    "TripFare": "30",
    "DistanceFare": "0",
    "WaitingTime": "",
    "WaitingTimeCost": "0",
    "TollFee": "0",
    "BookingCharge": "2",
    "Tax": "3.20",
    "PromoCode": "",
    "Discount": "0",
    "SubTotal": "30.00",
    "GrandTotal": "32.00",
    "Status": "completed",
    "Reason": "",
    "PaymentType": "cash",
    "ByDriverAmount": "",
    "AdminAmount": "5.00",
    "CompanyAmount": "27.00",
    "PickupLat": "23.07272",
    "PickupLng": "72.516387",
    "DropOffLat": "23.030513",
    "DropOffLon": "72.5075401",
    "BookingType": "",
    "ByDriverId": 0,
    "PassengerName": "",
    "PassengerContact": "",
    "PassengerEmail": ""
    }
    ]
    }
    
    */
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
    
    /*
    //MARK:- Tableview delegate and dataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dictData.allKeys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:TripDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TripDetailsTableViewCell") as! TripDetailsTableViewCell
        cell.lblTitle.text = dictData.allKeys[indexPath.row] as? String
        cell.lblDescription.text = dictData.allValues[indexPath.row] as? String
        return cell
    }
//
//
//    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
//    {
//        return 100
//    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
*/

