//
//  UpCommingTableViewCell.swift
//  TickTok User
//
//  Created by Excellent Webworld on 09/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class UpCommingTableViewCell: UITableViewCell {

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
    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var lblBookingId: UILabel!
    @IBOutlet weak var lblDropoffAddressTitle: UILabel!
    @IBOutlet weak var lblPickupAddressTitle: UILabel!
    @IBOutlet weak var lblDropoffAddress: UILabel!
    @IBOutlet weak var lblPickupAddress: UILabel!
    @IBOutlet weak var lblDateAndTime: UILabel!

    @IBOutlet weak var btnCancelRequest: ThemeButton!
    @IBOutlet weak var lblPickUpTimeTitle: UILabel!
    @IBOutlet weak var lblVehicleTypeTitle: UILabel!
    @IBOutlet weak var lblPaymentTypeTitle: UILabel!
    @IBOutlet weak var lblPickUpTime: UILabel!
    @IBOutlet weak var lblVehicleType: UILabel!
    @IBOutlet weak var lblPaymentType: UILabel!

    @IBOutlet var lblDistanceTravelTitle: UILabel!
    @IBOutlet var lblPassDiscountTitle: UILabel!
    @IBOutlet var lblDistanceTravel: UILabel!
    @IBOutlet var lblPassDiscount: UILabel!
    
    
    @IBOutlet var lblNotesTitle: UILabel!
    @IBOutlet var lblNotes: UILabel!
    
    
}
