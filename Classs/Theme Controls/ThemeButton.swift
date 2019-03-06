//
//  ThemeButton.swift
//  TanTaxi User
//
//  Created by EWW-iMac Old on 03/10/18.
//  Copyright © 2018 Excellent Webworld. All rights reserved.
//

import UIKit

class ThemeButton: UIButton {

    @IBInspectable public var isSubmitButton: Bool = false
    @IBInspectable public var NoNeedBackground: Bool = false
    
    override func awakeFromNib() {
        self.titleLabel?.font = UIFont.bold(ofSize: 15.0)
        self.layer.cornerRadius = 0.0
        self.layer.masksToBounds = true

        if isSubmitButton == true {
            self.backgroundColor = ThemeNaviBlueColor
            setTitleColor(UIColor.white, for: .normal)
        }
        else {
            self.backgroundColor = UIColor.black
//                UIColor(red: 114.0/255.0, green: 114.0/255.0, blue: 114.0/255.0, alpha: 1.0)
            setTitleColor(UIColor.white, for: .normal)
        }
        
//        if NoNeedBackground == true {
//            self.backgroundColor = UIColor.clear
//            setTitleColor(ThemeNaviBlueColor, for: .normal)
//        }
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}


