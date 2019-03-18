//
//  HelpListViewCell.swift
//  Nexus-Driver
//
//  Created by EWW iMac2 on 01/03/19.
//  Copyright © 2019 Excellent WebWorld. All rights reserved.
//

import UIKit

class HelpListViewCell: UITableViewCell {

    
    @IBOutlet var viewCell: UIView!
    
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var iconArrow: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
