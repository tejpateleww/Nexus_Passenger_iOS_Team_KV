//
//  OnGoingTableViewCell.swift
//  TickTok User
//
//  Created by Excellent Webworld on 09/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class OnGoingTableViewCell: UITableViewCell {

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
    
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblDriverName: UILabel!
    
    @IBOutlet weak var lblPickupAddress: UILabel!
    @IBOutlet weak var lblDropoffAddress: UILabel!
    
    @IBOutlet weak var lblStatus: UILabel!
    
    

}
