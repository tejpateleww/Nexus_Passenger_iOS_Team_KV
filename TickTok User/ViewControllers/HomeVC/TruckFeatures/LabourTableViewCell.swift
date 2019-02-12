//
//  LabourTableViewCell.swift
//  Cab Ride User
//
//  Created by Apple on 28/09/18.
//  Copyright © 2018 Excellent Webworld. All rights reserved.
//

import UIKit

class LabourTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBOutlet weak var imgLabourType: UIImageView!
    @IBOutlet weak var lblLabourType: UILabel!
    
    @IBOutlet weak var viewMainLabour: UIView!
    
}
