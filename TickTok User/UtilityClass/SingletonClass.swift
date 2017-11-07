//
//  SingletonClass.swift
//  TickTok User
//
//  Created by Excellent Webworld on 28/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class SingletonClass: NSObject {
   
    var dictProfile = NSDictionary()
    var strPassengerID = String()
    var isUserLoggedIN = Bool()
    
    static let sharedInstance = SingletonClass()
    
    var bookedDetails = NSDictionary()

}
