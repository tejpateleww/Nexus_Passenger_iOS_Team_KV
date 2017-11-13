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

    
    @IBOutlet weak var imgDriver: UIImageView!
    
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var lblCompanyValue: UILabel!
    
    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var lblDriverNameValue: UILabel!
    
    @IBOutlet weak var lblPickup: UILabel!
    @IBOutlet weak var lblPickupAddress: UILabel!
    
    @IBOutlet weak var lblDropoff: UILabel!
    @IBOutlet weak var lblDropoffAddress: UILabel!
    
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblDistanceValue: UILabel!
    
    @IBOutlet weak var lblTripFare: UILabel!
    @IBOutlet weak var lblTripFareValue: UILabel!
    
    @IBOutlet weak var lblNightFare: UILabel!
    @IBOutlet weak var lblNightFareValue: UILabel!
    
    @IBOutlet weak var lblWaitingCost: UILabel!
    @IBOutlet weak var lblWaitingCostValue: UILabel!
    
    @IBOutlet weak var lblBookingCharge: UILabel!
    @IBOutlet weak var lblBookingChargeValue: UILabel!
    
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblTotalValue: UILabel!
    
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblStatusValue: UILabel!
 
}
