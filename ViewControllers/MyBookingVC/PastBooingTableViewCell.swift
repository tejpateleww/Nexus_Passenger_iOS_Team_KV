//
//  PastBooingTableViewCell.swift
//  TickTok User
//
//  Created by Excellent Webworld on 09/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit



class PastBooingTableViewCell: UITableViewCell {
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    //Title
    
    @IBOutlet weak var viewDetails: UIView!
    @IBOutlet var viewCell: UIView!
    
    @IBOutlet weak var lblPickupAddressTitle: UILabel!
    @IBOutlet weak var lblDropoffAddressTitle: UILabel!
    @IBOutlet weak var lblPickupTimeTitle: UILabel!
    @IBOutlet weak var lblDropoffTimeTitle: UILabel!
    @IBOutlet weak var lblVehicleTypeTitle: UILabel!
    @IBOutlet weak var lblDistanceTravelledTitle: UILabel!
    @IBOutlet weak var lblTripFareTitle: UILabel!
//    @IBOutlet weak var lblNightFareTitle: UILabel!
    @IBOutlet weak var lblTollFeeTitle: UILabel!
    @IBOutlet weak var lblWaitingCostTitle: UILabel!
    @IBOutlet weak var lblWaitingTimeTitle: UILabel!
    @IBOutlet weak var lblTaxTitle: UILabel!
    @IBOutlet weak var lblDiscountTitle: UILabel!
    @IBOutlet weak var lblPaymentTypeTitle: UILabel!
//    @IBOutlet weak var lblTotalTitle: UILabel!
    @IBOutlet weak var lblTripStatusTitle: UILabel!
    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var lblBookingID: UILabel!
 
    // NEW ADDDED FIELDS TITLE
    
    @IBOutlet var lblMinuteFareChargeTitle: UILabel!
    @IBOutlet var lblDistanceFareTitle: UILabel!
    @IBOutlet var lblSurgeChargeTitle: UILabel!
    @IBOutlet var lblTripSubTotalTitle: UILabel!
    
    @IBOutlet var lblTipsTitle: UILabel!
    @IBOutlet var lblTipsSubTotalTitle: UILabel!
    
    @IBOutlet var lblBookingChargeTitle: UILabel!
    @IBOutlet var lblPassDiscountTitle: UILabel!
    @IBOutlet var lblNexusChargeTitle: UILabel!
    @IBOutlet var lblTotalNexusChargeTitle: UILabel!
    
    @IBOutlet var lblGrandTotalTitle: UILabel!
    
    @IBOutlet weak var btnTips: ThemeButton!
    
    
//    @IBOutlet weak var lblPromoApplied: UILabel!
//    @IBOutlet weak var lblLessTitle: UILabel!

    @IBOutlet weak var lblPickupAddress: UILabel! // Pickup Address is PickupAddress
    @IBOutlet weak var lblDropoffAddress: UILabel!  // DropOff Address is PickupAddress
    @IBOutlet weak var lblDateAndTime: UILabel!


//    @IBOutlet weak var stackViewPickupTime: UIStackView!
//    @IBOutlet weak var stackViewDropoffTime: UIStackView!
//    @IBOutlet weak var stackViewVehicleType: UIStackView!
    
    
    // Value
    @IBOutlet weak var lblPickupTime: UILabel!
    @IBOutlet weak var lblDropoffTime: UILabel!
    @IBOutlet weak var lblVehicleType: UILabel!
    @IBOutlet weak var lblDistanceTravelled: UILabel!
    @IBOutlet weak var lblTripFare: UILabel!
//    @IBOutlet weak var lblNightFare: UILabel!
    @IBOutlet weak var lblTollFee: UILabel!
    @IBOutlet weak var lblWaitingCost: UILabel!
    @IBOutlet weak var lblWaitingTime: UILabel!
    @IBOutlet var lblBookingCharge: UILabel!
    @IBOutlet weak var lblTax: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet var lblPaymentType: UILabel!
//    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblTripStatus: UILabel!

    // New Fields Added
    
    @IBOutlet var lblMinuteFareCharge: UILabel!
    @IBOutlet var lblDistanceFare: UILabel!
    @IBOutlet var lblSurgeCharge: UILabel!
    @IBOutlet var lblTripSubTotal: UILabel!
    @IBOutlet var lblTips: UILabel!
    @IBOutlet var lblTipsSubTotal: UILabel!
    @IBOutlet var lblPassDiscount: UILabel!
    @IBOutlet var lblNexusCharge: UILabel!
    @IBOutlet var lblTotalNexusCharge: UILabel!
    
    @IBOutlet var lblGrandTotal: UILabel!
    
    
    @IBOutlet var StackVehicleType: UIStackView!
    @IBOutlet var StackDistanceTravelled: UIStackView!
    @IBOutlet var StackWaitingTime: UIStackView!
    @IBOutlet var StackPaymentType: UIStackView!
    @IBOutlet var StackTripStatus: UIStackView!
    
    @IBOutlet var StackTripFare: UIStackView!
    @IBOutlet var StackFareCharge: UIStackView!
    @IBOutlet var StackWaitingCost: UIStackView!
    @IBOutlet var StackDistanceFare: UIStackView!
    @IBOutlet var StackSurgeCharge: UIStackView!
    @IBOutlet var StackTollFee: UIStackView!
    @IBOutlet var StackTripSubTotal: UIStackView!
    
    @IBOutlet var StackTips: UIStackView!
    @IBOutlet var StackTipSubTotal: UIStackView!
    
    @IBOutlet var StackBookingCharge: UIStackView!
    @IBOutlet var StackTax: UIStackView!
    @IBOutlet var StackDiscount: UIStackView!
    @IBOutlet var StackPassDiscount: UIStackView!
    @IBOutlet var StackNexusCharge: UIStackView!
    @IBOutlet var StackTotalNexusCharge: UIStackView!
    
    @IBOutlet var StackGrandTotal: UIStackView!

    

//    @IBOutlet var lblTip: UILabel!
//    @IBOutlet weak var lblPromoCode: UILabel!
//    @IBOutlet weak var lblTax: UILabel!
//    @IBOutlet weak var lblDiscount: UILabel!
   
//    @IBOutlet weak var stackViewDistanceTravelled: UIStackView!
//
//
//    @IBOutlet weak var stackViewTripFare: UIStackView!
////    @IBOutlet weak var lblTripFare: UILabel!
//
//    @IBOutlet weak var stackViewNightFare: UIStackView!
//
//
//    @IBOutlet weak var stackViewTollFee: UIStackView!
//
//
//    @IBOutlet weak var stackViewWaitingCost: UIStackView!
//
//
//    @IBOutlet weak var stackViewBookingCharge: UIStackView!
//
//
//    @IBOutlet weak var stackViewTax: UIStackView!
//
//
//    @IBOutlet weak var stackViewDiscount: UIStackView!
//
//
//    @IBOutlet weak var stackViewPaymentType: UIStackView!
//
//    @IBOutlet weak var stackViewTotalCost: UIStackView!
  
    
}
