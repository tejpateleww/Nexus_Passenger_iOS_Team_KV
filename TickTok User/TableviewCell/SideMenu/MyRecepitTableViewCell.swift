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
    
    
    @IBOutlet weak var viewDetails: UIView!
    
    @IBOutlet var lblDriversNames: UILabel!
    @IBOutlet weak var btnGetReceipt: UIButton!
    
    @IBOutlet var lblDropLocationDescription: UILabel!
    @IBOutlet var lblDateAndTime: UILabel!
    @IBOutlet var lblPickUpLocationDescription: UILabel!
    
    @IBOutlet weak var lblVehicleType: UILabel!
    @IBOutlet weak var lblDistanceTravelled: UILabel!
    @IBOutlet weak var lblTolllFee: UILabel!
    
    @IBOutlet weak var lblFareTotal: UILabel!
    @IBOutlet weak var lblDiscountApplied: UILabel!
    @IBOutlet weak var lblChargedCard: UILabel!

    
}
