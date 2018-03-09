//
//  PackageHistoryListTableViewCell.swift
//  PickNGo User
//
//  Created by Excellent WebWorld on 07/03/18.
//  Copyright © 2018 Excellent Webworld. All rights reserved.
//

import UIKit

class PackageHistoryListTableViewCell: UITableViewCell {

     @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var lblPackageName: UILabel!
    @IBOutlet weak var lblBookingID: UILabel!
    @IBOutlet weak var lblPickupLocation: UILabel!
    @IBOutlet weak var lblPackageType: UILabel!
    @IBOutlet weak var lblPackageStatus: UILabel!
    @IBOutlet weak var lblPaymentType: UILabel!
    @IBOutlet weak var lblPaymentStatus: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
