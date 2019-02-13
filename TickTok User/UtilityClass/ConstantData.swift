//
//  ConstantData.swift
//  TickTok User
//
//  Created by Excellent Webworld on 28/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import Foundation

//let ThemeBlueColor: UIColor =  UIColor.init(red: 242/255, green: 21/255, blue: 65/255, alpha: 1.0) // UIColor.init(red: 255/255, green: 163/255, blue: 0, alpha: 1.0)//binal
//let themeGrayColor: UIColor = UIColor.init(red: 231/255, green: 231/255, blue: 231/255, alpha: 1.0) //UIColor.init(red: 114/255, green: 114/255, blue: 114/255, alpha: 1.0)//binal
//let ThemeBlueColor : UIColor = UIColor.init(hex: "ffa300")

let currencySign = "$"
let appName = "Nexus"
let helpLineNumber = "1234567890"

let googleAnalyticsTrackId = "UA-122360832-1"

//let appCurrentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String


struct WebserviceURLs {
    static let kBaseURL                                 = "http://3.17.200.7/web/Passenger_Api/"//"http://52.66.86.25/web/Passenger_Api/"//13.127.148.119
    static let kDriverRegister                          = "Register"
    static let kDriverLogin                             = "Login"
    static let kChangePassword                          = "ChangePassword"
    static let kUpdateProfile                           = "UpdateProfile"
    static let kForgotPassword                          = "ForgotPassword"
    static let kGetCarList                              = "GetCarClass"
    static let kMakeBookingRequest                      = "SubmitBookingRequest"
    static let kAdvancedBooking                         = "AdvancedBooking"
    static let kDriver                                  = "Driver"
    static let kBookingHistory                          = "BookingHistory/"
    static let kGetEstimateFare                         = "GetEstimateFare"
    static let kImageBaseURL                            = "http://3.17.200.7/web/"//http://52.66.86.25/web/"
    
    static let kCardsList                               = "Cards/"
    static let kPackageBookingHistory                   = "PackageBookingHistory"
    static let kBookPackage                             = "BookPackage"
    static let kCurrentBooking                          = "CurrentBooking/"
    static let kAddNewCard                              = "AddNewCard"
    static let kAddMoney                                = "AddMoney"
    static let kTransactionHistory                      = "TransactionHistory/"
    static let kSendMoney                               = "SendMoney"
    static let kQRCodeDetails                           = "QRCodeDetails"
    static let kRemoveCard                              = "RemoveCard/"
    static let kTickpay                                 = "Tickpay"
    static let kAddAddress                              = "AddAddress"
    static let kGetAddress                              = "GetAddress/"
    static let kRemoveAddress                           = "RemoveAddress/"
    static let kVarifyUser                              = "VarifyUser"
    static let kTickpayInvoice                          = "TickpayInvoice"
    static let kGetTickpayRate                          = "GetTickpayRate"
    static let kInit                                    = "Init/"
    
    static let kReviewRating                            = "ReviewRating"
    static let kGetTickpayApprovalStatus                = "GetTickpayApprovalStatus/"
    static let kTransferToBank                          = "TransferToBank"
    static let kUpdateBankAccountDetails                = "UpdateBankAccountDetails"
    static let kOtpForRegister                          = "OtpForRegister"
    static let kGetPackages                             = "Packages"
    static let kMissBokkingRequest                      = "BookingMissRequest"
    static let kTrackRunningTrip                        = "TrackRunningTrip/"
    
    static let kParcelAndLabour                         = "ParcelAndLabour"
    static let kGetEstimateFareForDeliveryService       = "GetEstimateFareForDeliveryService"
    
    // For Pagination
    static let kPastBooking                             = "PastBooking/"
    static let kUpcomingBooking                         = "UpcomingBooking/"
    static let kOngoingBooking                          = "OngoingBooking/"
    
     
}

struct SocketData {
    
    static let kBaseURL                                     = "http://3.17.200.7:8080/"//"http://52.66.86.25:8080"
    static let kNearByDriverList                            = "NearByDriverListIOS"
    static let kUpdatePassengerLatLong                      = "UpdatePassengerLatLong"
    static let kAcceptBookingRequestNotification            = "AcceptBookingRequestNotification"
    static let kRejectBookingRequestNotification            = "RejectBookingRequestNotification"
    static let kPickupPassengerNotification                 = "PickupPassengerNotification"
    static let kBookingCompletedNotification                = "BookingDetails"
    static let kCancelTripByPassenger                       = "CancelTripByPassenger"
    static let kCancelTripByDriverNotficication             = "PassengerCancelTripNotification"
    static let kSendDriverLocationRequestByPassenger        = "DriverLocation"
    static let kReceiveDriverLocationToPassenger            = "GetDriverLocation"
    static let kReceiveHoldingNotificationToPassenger       = "TripHoldNotification"
    static let kSendRequestForGetEstimateFare               = "EstimateFare"
    static let kReceiveGetEstimateFare                      = "GetEstimateFare"
    
    static let kAcceptAdvancedBookingRequestNotification    = "AcceptAdvancedBookingRequestNotification"
    static let kRejectAdvancedBookingRequestNotification    = "RejectAdvancedBookingRequestNotification"
    static let kAdvancedBookingPickupPassengerNotification  = "AdvancedBookingPickupPassengerNotification"
    static let kAdvancedBookingTripHoldNotification         = "AdvancedBookingTripHoldNotification"
    static let kAdvancedBookingDetails                      = "AdvancedBookingDetails"
    static let kAdvancedBookingCancelTripByPassenger        = "AdvancedBookingCancelTripByPassenger"
    
    static let kInformPassengerForAdvancedTrip              = "InformPassengerForAdvancedTrip"
    static let kAcceptAdvancedBookingRequestNotify          = "AcceptAdvancedBookingRequestNotify"
    
}

struct SocketDataKeys {
    
    static let kBookingIdNow    = "BookingId"
}



struct SubmitBookingRequest {
// PassengerId,ModelId,PickupLocation,DropoffLocation,PickupLat,PickupLng,DropOffLat,DropOffLon
// PassengerId,ModelId,PickupLocation,DropoffLocation,PickupLat,PickupLng,DropOffLat,DropOffLon,PromoCode,Notes,PaymentType,CardId(If paymentType is card)
    
    
    static let kModelId                 = "ModelId"
    static let kPickupLocation          = "PickupLocation"
    static let kDropoffLocation         = "DropoffLocation"
    static let kPickupLat               = "PickupLat"
    static let kPickupLng               = "PickupLng"
    static let kDropOffLat              = "DropOffLat"
    static let kDropOffLon              = "DropOffLon"
    
    static let kPromoCode               = "PromoCode"
    static let kNotes                   = "Notes"
    static let kPaymentType             = "PaymentType"
    static let kCardId                  = "CardId"
    static let kSpecial                 = "Special"
    
    static let kShareRide               = "ShareRide"
    static let kNoOfPassenger           = "NoOfPassenger"
    
    
}

struct NotificationCenterName {
    
    // Define identifier
    static let keyForOnGoing   = "keyForOnGoing"
    static let keyForUpComming = "keyForUpComming"
    static let keyForPastBooking = "keyForPastBooking"
    

}

struct PassengerDataKeys {
    static let kPassengerID = "PassengerId"
    
}

struct setAllDevices {
    
    static let allDevicesStatusBarHeight = 20
    static let allDevicesNavigationBarHeight = 44
    static let allDevicesNavigationBarTop = 20
}

struct setiPhoneX {
    
    static let iPhoneXStatusBarHeight = 44
    static let iPhoneXNavigationBarHeight = 40
    static let iPhoneXNavigationBarTop = 44
    
    
}



let NotificationKeyFroAllDriver =  NSNotification.Name("NotificationKeyFroAllDriver")

let NotificationBookNow = NSNotification.Name("NotificationBookNow")
let NotificationBookLater = NSNotification.Name("NotificationBookLater")

let NotificationTrackRunningTrip = NSNotification.Name("NotificationTrackRunningTrip")
let NotificationForBookingNewTrip = NSNotification.Name("NotificationForBookingNewTrip")
let NotificationForAddNewBooingOnSideMenu = NSNotification.Name("NotificationForAddNewBooingOnSideMenu")

let NotificationUpdateProfileOnSidemenu = Notification.Name("NotificationUpdateProfileOnSidemenu")

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}

//let ThemeBlueColor : UIColor = UIColor(hex: "ffa300")
//let ThemeGrayColor : UIColor = UIColor(hex: "8e8c80")  //UIColor.init(hex:  "8e8c80")
let ThemePinkColor : UIColor = UIColor(hex: "F31541") //UIColor.init(hex:  "F21541")
let ThemeBlueColor : UIColor = UIColor(hex: "292a6a") //UIColor.init(hex:  "0e0c22")
//let ThemeStatusBarColor : UIColor = UIColor.init(hex:  "cccccc")



//let NotificationHotelReservation = NSNotification.Name("NotificationHotelReservation")
//let NotificationBookaTable = NSNotification.Name("NotificationBookaTable")
//let NotificationShopping = NSNotification.Name("NotificationShopping")

//struct iPhoneDevices {
//    
//    static func getiPhoneXDevice() -> String {
//        
//        var deviceName = String()
//        
//        if UIDevice().userInterfaceIdiom == .phone {
//            switch UIScreen.main.nativeBounds.height {
//            case 1136:
//                print("iPhone 5 or 5S or 5C")
//                return deviceName = "iPhone 5"
//                
//            case 1334:
//                print("iPhone 6/6S/7/8")
//                deviceName = "iPhone 6"
//                
//            case 2208:
//                print("iPhone 6+/6S+/7+/8+")
//                deviceName = "iPhone 6+"
//                
//            case 2436:
//                print("iPhone X")
//                deviceName = "iPhone X"
//                
//            default:
//                print("unknown")
//            }
//        }
//    }
//}
/*
struct iPhoneDevices {
    
    let SCREEN_MAX_LENGTH = max(UIScreen.screenWidth, UIScreen.screenHeight)
    let SCREEN_MIN_LENGTH = min(UIScreen.screenWidth, UIScreen.screenHeight)
    
    let IS_IPHONE_4_OR_LESS = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH < 568.0
    let IS_IPHONE_5 = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH == 568.0
    let IS_IPHONE_6 = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH == 667.0
    let IS_IPHONE_6P = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH == 736.0
    let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad && SCREEN_MAX_LENGTH == 1024.0
    let IS_IPHONE_X = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH == 812.0

}
*/


