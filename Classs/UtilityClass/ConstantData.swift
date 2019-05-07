//
//  ConstantData.swift
//  TickTok User
//
//  Created by Excellent Webworld on 28/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import Foundation

let ThemeNaviBlueColor : UIColor = UIColor(red: 41.0/255.0, green: 42.0/255.0, blue: 106.0/255.0, alpha: 1.0)
let ThemeNaviBlueLightColor :UIColor = UIColor(red: 75.0/255.0, green: 77.0/255.0, blue: 136.0/255.0, alpha: 1.0)
let ThemeWhiteColor : UIColor = UIColor.white
let ThemeClearColor : UIColor = UIColor.clear

let themeYellowColor: UIColor =  UIColor.init(hex: "E48428")
//    UIColor.init(red: 255/255, green: 163/255, blue: 0, alpha: 1.0)
let themeGrayColor: UIColor = UIColor.init(red: 114/255, green: 114/255, blue: 114/255, alpha: 1.0)
//let ThemeYellowColor : UIColor = UIColor.init(hex: "ffa300")
let themeGrayBGColor : UIColor = UIColor.init(hex: "DDDDDD")
let cellBGColor = UIColor(hex: "f5f5f5")
let themeGrayTextColor : UIColor = UIColor.init(hex: "7A7A7C")
let currencySign = "$"
let appName = "Nexus"
let helpLineNumber = "+255777115054"//"0772506506"
let googleAnalyticsTrackId = "UA-122360832-1"

let AppRegularFont:String = "ProximaNova-Regular"
let AppBoldFont:String = "ProximaNova-Bold"
let AppSemiboldFont:String = "ProximaNova-Semibold"
let dictanceType : String = " "
let windowHeight: CGFloat = CGFloat(UIScreen.main.bounds.size.height)
let screenHeightDeveloper : Double = 568
let screenWidthDeveloper : Double = 320

/* App Font Names

 Family : Proxima Nova Font Name : ProximaNova-Extrabld
 Family : Proxima Nova Font Name : ProximaNova-Light
 Family : Proxima Nova Font Name : ProximaNova-Black
 Family : Proxima Nova Font Name : ProximaNova-Semibold
 Family : Proxima Nova Font Name : ProximaNova-RegularIt
 Family : Proxima Nova Font Name : ProximaNova-BoldIt
 Family : Proxima Nova Font Name : ProximaNova-Bold
 Family : Proxima Nova Font Name : ProximaNova-SemiboldIt
 Family : Proxima Nova Font Name : ProximaNova-Regular
 Family : Proxima Nova Font Name : ProximaNova-LightIt

 */




//func setLayoutForEnglishLanguage() {
//    UIView.appearance().semanticContentAttribute = .forceLeftToRight
//    UINavigationBar.appearance().semanticContentAttribute = .forceLeftToRight
//}
//func setLayoutForSwahilLanguage() {
//    UIView.appearance().semanticContentAttribute = .forceLeftToRight
//    UINavigationBar.appearance().semanticContentAttribute = .forceLeftToRight
//}

//let appCurrentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String


struct WebserviceURLs {
    static let kBaseURL                                  = "https://nexusappllc.com/web/Passenger_Api/"
//    "http://3.17.200.7/web/Passenger_Api/"
    static let kDriverRegister                          = "Register"
    static let kDriverLogin                             = "Login"
    static let kChangePassword                          = "ChangePassword"
        static let kSocialLogin                             = "SocialLogin"
    static let kUpdateProfile                           = "UpdateProfile"
    static let kForgotPassword                          = "ForgotPassword"
    static let kGetCarList                              = "GetCarClass"
    static let kMakeBookingRequest                      = "SubmitBookingRequest"
    static let kAdvancedBooking                         = "AdvancedBooking"
    static let kDriver                                  = "Driver"
    static let kBookingHistory                          = "BookingHistory"
    static let kPastBooking                             = "PastBooking"
    static let kUpcomingBooking                     = "UpcomingBooking"
    static let kOnGoing                                     = "OngoingBooking"
    static let kGetEstimateFare                         = "GetEstimateFare"
    static let kImageBaseURL                            = "https://nexusappllc.com/web/"
    //"http://3.17.200.7/web/"

    static let kFeedbackList                            = "FeedbackList/"
    static let kCardsList                               = "Cards/"
    static let kPackageBookingHistory                   = "PackageBookingHistory"
    static let kBookPackage                             = "BookPackage"
    static let kCurrentBooking                          = "CurrentBooking/"
    static let kAddNewCard                              = "AddNewCard"
    static let kSendTip                                 = "TipsForCompletedBooking"
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
    
    static let kFAQ                                     = "faq"
    static let kGenerateTicket                          = "generateTicket/"
    static let kTicketList                          = "ticketList/"
    static let kTicketChatHistory                          = "ticketChatHistory/"
    static let kTicketChat                          = "ticketChat"
    
    static let kReviewRating                            = "ReviewRating"
    static let kGetTickpayApprovalStatus                = "GetTickpayApprovalStatus/"
    static let kTransferToBank                          = "TransferToBank"
    static let kUpdateBankAccountDetails                = "UpdateBankAccountDetails"
    static let kOtpForRegister                          = "OtpForRegister"
    static let kGetPackages                             = "Packages"
    static let kMissBokkingRequest                      = "BookingMissRequest"
    static let kTrackRunningTrip                        = "TrackRunningTrip/"
    
    static let kPassType                                = "PassType"
    static let kPassHistory                             = "PassHistory/"
    static let kSubscribePassType                       = "BuyPass"
    static let kSubscribePassEdit                       = "EditPass"
    static let kDeactivePass                            = "DeactivePass/"

//    https://pickngolk.info/web/Passenger_Api/OtpForRegister
}



struct SocketData {
    
    static let kBaseURL                                     = "https://nexusappllc.com:8080/"
//    "http://3.17.200.7:8080/"

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
    static let kArrivedDriverBookLaterRequest               = "AdvanceBookingDriverArrivedAtPickupLocation"
    static let kArrivedDriverBookNowRequest                 = "DriverArrivedAtPickupLocation"
    static let kArrviedDetailConfirmation                   = "ArrivedDetailsConfirmation"
    static let kArrivedDetailConfirmationBookLater      = "AdvanceBookingArrivedDetailsConfirmation"
    static let kReceiveTollFeeToDriver                      = "ReceiveTollFeeToDriver"
    static let kReceiveTollFeeToDriverBookLater        = "ReceiveTollFeeToDriverBookLater"
    
    static let kAcceptAdvancedBookingRequestNotification    = "AcceptAdvancedBookingRequestNotification"
    static let kRejectAdvancedBookingRequestNotification    = "RejectAdvancedBookingRequestNotification"
    static let kAdvancedBookingPickupPassengerNotification  = "AdvancedBookingPickupPassengerNotification"
    static let kAdvancedBookingTripHoldNotification         = "AdvancedBookingTripHoldNotification"
    static let kAdvancedBookingDetails                      = "AdvancedBookingDetails"
    static let kAdvancedBookingCancelTripByPassenger        = "AdvancedBookingCancelTripByPassenger"
    
    static let kInformPassengerForAdvancedTrip              = "InformPassengerForAdvancedTrip"
    static let kAcceptAdvancedBookingRequestNotify          = "AcceptAdvancedBookingRequestNotify"
    
    static let kAskForTipsToPassenger = "AskForTipsToPassenger"
    static let kAskForTipsToPassengerForBookLater = "AskForTipsToPassengerForBookLater"

    static let kReceiveTips = "ReceiveTips"
    static let kReceiveTipsForBookLater = "ReceiveTipsForBookLater"
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

let OpenEditProfile = NSNotification.Name("OpenEditProfile")
let OpenMyBooking = NSNotification.Name("OpenMyBooking")
let OpenPaymentOption = NSNotification.Name("OpenPaymentOption")
let OpenWallet = NSNotification.Name("OpenWallet")
let OpenMyReceipt = NSNotification.Name("OpenMyReceipt")
let OpenFavourite = NSNotification.Name("OpenFavourite")
let OpenInviteFriend = NSNotification.Name("OpenInviteFriend")
let OpenHelp = NSNotification.Name("Help")
let OpenPass = NSNotification.Name("Pass")
let OpenSetting = NSNotification.Name("OpenSetting")
let OpenSupport = NSNotification.Name("OpenSupport")
let OpenHome = NSNotification.Name("OpenHome")



let NotificationforUpdateChatDetail = NSNotification.Name("UpdateChatDetail")
let NotificationforOpenChat = NSNotification.Name(rawValue: "OpenChatfromNotification")
let NotificationforUpdateChat = NSNotification.Name(rawValue: "UpdateChatfromNotification")
let NotificationforRefreshNewChat = NSNotification.Name(rawValue: "RefreshNewChatfromNotification")

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



