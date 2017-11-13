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

    @IBOutlet weak var lblPickup: UILabel!
    @IBOutlet weak var lblPickupAddress: UILabel!
    
    @IBOutlet weak var lblDropoff: UILabel!
    @IBOutlet weak var lblDropoffAddress: UILabel!
    
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblDistanceValue: UILabel!
    
    @IBOutlet weak var lblPickupDate: UILabel!
    @IBOutlet weak var lblPickupDateValue: UILabel!
    
    @IBOutlet weak var lblPickupTime: UILabel!
    @IBOutlet weak var lblPickupTimeValue: UILabel!
    
    @IBOutlet weak var lblModel: UILabel!
    @IBOutlet weak var lblModelValue: UILabel!
    
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblStatusValue: UILabel!
    

}
