//
//  MyOffersTableViewCell.swift
//  Nexus User
//
//  Created by EWW076 on 03/04/19.
//  Copyright © 2019 Excellent Webworld. All rights reserved.
//

import UIKit

class MyOffersTableViewCell: UITableViewCell {
    @IBOutlet weak var lblPickupLocation: UILabel!
    @IBOutlet weak var lblDropoffLocation: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblPassType: UILabel!
    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var containerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.backgroundColor = cellBGColor
    }
    var data : [String:Any]? {
        didSet{
            lblPickupLocation.text = formattedString(key: "PickupLocation")
            lblDropoffLocation.text = formattedString(key: "DropoffLocation")
            lblStartDate.text = formattedString(key: "StartDate")
            lblPassType.text = formattedString(key: "PassType").uppercased() + " PASS"
            lblEndDate.text = formattedString(key: "EndDate").components(separatedBy: " ")[0]
        }
    }
    
    func formattedString(key: String) -> String{
        return ((data?[key] as? String) ?? "")
    }
}
