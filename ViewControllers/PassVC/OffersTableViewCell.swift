//
//  OffersTableViewCell.swift
//  Nexus User
//
//  Created by EWW076 on 01/04/19.
//  Copyright © 2019 Excellent Webworld. All rights reserved.
//

import UIKit

class OffersTableViewCell: UITableViewCell {
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnEdit: UIButton!{
        didSet{
            btnEdit.isHidden = true
        }
    }
    
    @IBOutlet weak var btnActivate: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblDiscount.font = UIFont.semiBold(ofSize: 14)
        lblInfo.font = UIFont.semiBold(ofSize: 14)
        lblDescription.font = UIFont.semiBold(ofSize: 12)
        containerView.backgroundColor = cellBGColor
    }
    
    var discountType: DiscountType?{
        didSet{
            lblDiscount.text = formatDiscount()
        }
    }
    var currentData: [String: Any]?
   
    var data : [String:Any]? {
        didSet{
            lblInfo.text = formattedString(key: "Name")
            lblDescription.text = formattedString(key: "Description")

            if let currentData = currentData,
                String(describing: (currentData["PassId"] ?? "")) == formattedString(key: "Id"),
                formattedString(key: "Id") != ""
                {
                    btnActivate.status = .deactivate
                    btnEdit.isHidden = String(describing: (currentData["is_editable"] ?? 0)) == "1" ? false : true
                }
             else{
                btnActivate.status = .activate
            }
        }
    }
    func formatDiscount() -> String{
        if discountType == .flat{
                return "Flat $" + formattedString(key: "DiscountValue") + " Discount"
            }
        else if discountType == .percentage{
            return formattedString(key: "DiscountValue") + "% Discount"
        }
        else{
            return "Discount not Available"
        }
    }
    
    func formattedString(key: String) -> String{
        return ((data?[key] as? String) ?? "")
    }
}

