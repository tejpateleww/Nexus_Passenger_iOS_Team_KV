//
//  SingletonClass.swift
//  TickTok User
//
//  Created by Excellent Webworld on 28/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class SingletonClass: NSObject {
   
    var dictProfile = NSMutableDictionary()
    var strPassengerID = String()
    var isUserLoggedIN = Bool()
    var arrCarLists = NSMutableArray()
    static let sharedInstance = SingletonClass()
    
    var isFirstTimeInTickPay = Bool()
    var isFirstTimeDidupdateLocation = true
    
    var bookedDetails = NSDictionary()
    
    var currentLatitude = String()
    var currentLongitude = String()
    
    var aryHistory = NSArray()
    var aryOnGoing = NSArray()
    var aryUpComming = NSArray()
    var aryPastBooking = NSArray()
    
    var boolIsFromPrevious = Bool()
    
    var bookingId = String()
    
    var dictIsFromPrevious = NSDictionary()
    
    
    var isCardsVCFirstTimeLoad: Bool = true
    var CardsVCHaveAryData = [[String:AnyObject]]()
    
    var strCurrentBalance = Double()
    var walletHistoryData = [[String:AnyObject]]()
    
    var strQRCodeForSendMoney = String()
    var isSendMoneySuccessFully = Bool()
    
    
    var isFromTopUP = Bool()
    var isFromTransferToBank = Bool()
    
    var isTiCKPayFromSideMenu = Bool()
    var firstRequestIsAccepted = Bool()
    
    var isfirstTimeTickPay = Bool()
    var strIsFirstTimeTickPay = String()
    var strTickPayId = String()
    var strAmoutOFTickPay = String()
    
    var strCurrentCity = String()
    
    var isFirstTimeReloadCarList = Bool()
    
    var aryDriverInfo = NSArray()
    
    var isRequestAccepted = Bool()
    var isTripContinue = false

    var floatBearing:Float = 0.0
    
    var deviceToken = String()
    
    var setPasscode = String()
    var passwordFirstTime = Bool()
}
