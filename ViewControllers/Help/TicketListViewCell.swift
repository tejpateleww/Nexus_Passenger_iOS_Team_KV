//
//  TicketListViewCell.swift
//  Nexus-Driver
//
//  Created by EWW iMac2 on 02/03/19.
//  Copyright © 2019 Excellent WebWorld. All rights reserved.
//

import UIKit

class TicketListViewCell: UITableViewCell {

    @IBOutlet var lblTicketID: UILabel!
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
