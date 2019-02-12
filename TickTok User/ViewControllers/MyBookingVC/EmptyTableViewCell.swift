//
//  EmptyTableViewCell.swift
//  Cab Ride User
//
//  Created by Excelent iMac on 25/09/18.
//  Copyright © 2018 Excellent Webworld. All rights reserved.
//

import UIKit

class EmptyTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var lblEmptyCell: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
