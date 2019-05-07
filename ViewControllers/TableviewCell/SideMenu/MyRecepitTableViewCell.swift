//
//  MyRecepitTableViewCell.swift
//  TickTok User
//
//  Created by Excelent iMac on 13/12/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class MyRecepitTableViewCell: UITableViewCell {

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
    
    
    @IBOutlet var viewCell: UIView!
    @IBOutlet weak var viewDetails: UIView!
    @IBOutlet weak var btnGetReceipt: ThemeButton!
    @IBOutlet var lblDriverName: UILabel!
    @IBOutlet var lblPickUpLocationTitle: UILabel!
    @IBOutlet var lblDropOffLocationTitle: UILabel!
    @IBOutlet var lblPickUpLocationDescription: UILabel!
    @IBOutlet var lblDropOffLocationDescription: UILabel!
    @IBOutlet var lblDateAndTime: UILabel!
    
    // Title
//    @IBOutlet weak var lblPickupTimeTitle: UILabel!
//    @IBOutlet weak var lblDropoffTimeTitle: UILabel!
    @IBOutlet weak var lblVehicleTypeTitle: UILabel!
    @IBOutlet weak var lblDistanceTravelledTitle: UILabel!
    @IBOutlet weak var lblPaymentTypeTitle: UILabel!
    
    @IBOutlet weak var lblTripFareTitle: UILabel!
    @IBOutlet var lblMinuteFareChargeTitle: UILabel!
    @IBOutlet weak var lblWaitingCostTitle: UILabel!
    @IBOutlet var lblDistanceFareTitle: UILabel!
    @IBOutlet var lblSurgeChargeTitle: UILabel!
    //    @IBOutlet weak var lblNightFareTitle: UILabel!
    @IBOutlet weak var lblTollFeeTitle: UILabel!
    @IBOutlet var lblTripSubTotalTitle: UILabel!

    @IBOutlet var lblTipsTitle: UILabel!
    @IBOutlet var lblTipsSubTotalTitle: UILabel!
    
    @IBOutlet var lblBookingChargeTitle: UILabel!
    @IBOutlet weak var lblTaxTitle: UILabel!
    @IBOutlet weak var lblDiscountTitle: UILabel!
    @IBOutlet var lblPassDiscountTitle: UILabel!
    @IBOutlet var lblNexusChargeTitle: UILabel!
    @IBOutlet var lblTotalNexusChargeTitle: UILabel!
    
    @IBOutlet var lblGrandTotalTitle: UILabel!
    
//    @IBOutlet weak var lblWaitingTimeTitle: UILabel!
   //    @IBOutlet weak var lblTotalTitle: UILabel!
//    @IBOutlet weak var lblTripStatusTitle: UILabel!

    
    // Value
//    @IBOutlet weak var lblPickupTime: UILabel!
//    @IBOutlet weak var lblDropoffTime: UILabel!
    
    
    @IBOutlet weak var lblVehicleType: UILabel!
    @IBOutlet weak var lblDistanceTravelled: UILabel!
    @IBOutlet var lblPaymentType: UILabel!
    
    @IBOutlet weak var lblTripFare: UILabel!
    @IBOutlet var lblMinuteFareCharge: UILabel!
    @IBOutlet weak var lblWaitingCost: UILabel!
    @IBOutlet var lblDistanceFare: UILabel!
    @IBOutlet var lblSurgeCharge: UILabel!
    @IBOutlet weak var lblTollFee: UILabel!
    @IBOutlet var lblTripSubTotal: UILabel!
    
    @IBOutlet var lblTips: UILabel!
    @IBOutlet var lblTipsSubTotal: UILabel!
    
    @IBOutlet var lblBookingCharge: UILabel!
    @IBOutlet weak var lblTax: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet var lblPassDiscount: UILabel!
    @IBOutlet var lblNexusCharge: UILabel!
    @IBOutlet var lblTotalNexusCharge: UILabel!

    @IBOutlet var lblGrandTotal: UILabel!
    
    
    @IBOutlet var StackVehicleType: UIStackView!
    @IBOutlet var StackDistanceTravelled: UIStackView!
    @IBOutlet var StackPaymentType: UIStackView!
    
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

    
    //    @IBOutlet weak var lblNightFare: UILabel!
//    @IBOutlet weak var lblWaitingTime: UILabel!
    //    @IBOutlet weak var lblTotal: UILabel!
//    @IBOutlet weak var lblTripStatus: UILabel!
    
    // New Fields Added
    



    


/*
    @IBOutlet var lblTripFare: UILabel!
    @IBOutlet var lblBookingFee: UILabel!
    @IBOutlet var lblDrooffTime: UILabel!
    @IBOutlet var lblPickupTime: UILabel!
    @IBOutlet var lblBookingId: UILabel!
    @IBOutlet var lblTotalAmount: UILabel!
    @IBOutlet var lblPromoCode: UILabel!
    @IBOutlet var lblWaitingTime: UILabel!
    @IBOutlet var lblWaitingCost: UILabel!
    @IBOutlet var lblPaymentType: UILabel!
    @IBOutlet weak var lblTripStatusTitlr: UILabel!
    @IBOutlet weak var lblInclTaxTitle: UILabel!
    @IBOutlet weak var lblTotalAmountTitle: UILabel!
    @IBOutlet weak var lblPromoAppliedTitle: UILabel!
    @IBOutlet weak var lblLessTitle: UILabel!
    @IBOutlet weak var lblWaitingTimeTitle: UILabel!
    @IBOutlet weak var lblWaitingCostTitle: UILabel!
    @IBOutlet weak var lblTripFareTitle: UILabel!
    @IBOutlet weak var lblBookingFeeTitle: UILabel!
    @IBOutlet weak var lblPaymentTypeTitle: UILabel!
    @IBOutlet weak var lblPickUpTimeTitle: UILabel!
    @IBOutlet weak var lblDropOffTimeTitle: UILabel!
    @IBOutlet var lblTripStatus: UILabel!
*/
}
