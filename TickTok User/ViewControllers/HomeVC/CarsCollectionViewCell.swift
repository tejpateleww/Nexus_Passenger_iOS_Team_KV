//
//  CarsCollectionViewCell.swift
//  TickTok User
//
//  Created by Excellent Webworld on 31/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class CarsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgCars: UIImageView!
//    @IBOutlet weak var lblAvailableCars: UILabel!
    
    @IBOutlet weak var lblMinutes: UILabel!
    @IBOutlet weak var lblPrices: UILabel!
    @IBOutlet weak var lblCarName: UILabel!
    
    @IBOutlet weak var viewOfImage: UIView!
    
    
    @IBOutlet weak var constraintHeightOfMinutes: NSLayoutConstraint! // 13
    @IBOutlet weak var constraintHeightOfPrice: NSLayoutConstraint! // 13
    
    
}
