//
//  EmptyTableViewCell.swift
//  eMajlis
//
//  Created by Mayur iMac on 24/01/19.
//  Copyright © 2019 excellent Mac Mini. All rights reserved.
//

import UIKit

class EmptyTableViewCell: UITableViewCell {

    @IBOutlet weak var imgEmptyCell: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
