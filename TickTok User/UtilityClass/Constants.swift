//
//  File.swift
//  SwiftDEMO_Palak
//
//  Created by MAYUR on 17/01/18.
//  Copyright © 2018 MAYUR. All rights reserved.
//

import Foundation
import UIKit
import BFKit

let Appdelegate = UIApplication.shared.delegate as! AppDelegate

//let loaderGIF = ActivityGIFIndicatorViewController()


let RingToneSound : String = "PickNGo"

let kIsSocketEmited : String = "IsEmited"

//let kAdMobBannerViewHeight : CGFloat = 44
//let KadUnitID : String = "ca-app-pub-3940256099942544/2934735716"
//let KGADInterstitial : String = "ca-app-pub-3940256099942544/4411468910"
//let KtestDevices : String = "2077ef9a63d2b398840261c8221a0c9b"

let kHtmlReplaceString   :   String  =   "<[^>]+>"
let currency : String = "$"
let dictanceType : String = "mi."

let kGoogle_Client_ID : String = "1052191415198-8uegn0efcr41f0njmaoilub6k50n35dd.apps.googleusercontent.com"
let kGoogleAPIKEY : String = "AIzaSyCtqQ0n_JgAUVydSwu3frORFsYH3C0nmMg"
let kGoogleReservationKey : String = ""
let kDeviceType : String = "1"

//let kCustomerCareNumber : String = "8338375893"
//let kCustomerCareDisplayNumber : String = "(833) 837-5893"


let kFutureBooking : String = "FutureBooking"
let kPendingJob : String = "PendingJob"
let kPastJob : String = "PastJob"

let kPassengerType : String = "Passenger"
let kDriverType : String = "Driver"

let kAcceptTripStatus : String = "accepted"
let kPendingTripStatus : String = "pending"
let kTravellingTripStatus : String = "traveling"

let SCREEN_WIDTH = UIScreen.screenWidth
let SCREEN_HEIGHT = UIScreen.screenHeight

let SCREEN_MAX_LENGTH = max(UIScreen.screenWidth, UIScreen.screenHeight)
let SCREEN_MIN_LENGTH = min(UIScreen.screenWidth, UIScreen.screenHeight)

let IS_IPHONE_4_OR_LESS = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH < 568.0
let IS_IPHONE_5 = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH == 568.0
let IS_IPHONE_6_7 = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH == 667.0
let IS_IPHONE_6P_7P = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH == 736.0
let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad && SCREEN_MAX_LENGTH == 1024.0
let IS_IPHONE_X = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH == 812.0
let IS_IPAD_PRO = UIDevice.current.userInterfaceIdiom == .pad && SCREEN_MAX_LENGTH == 1366.0
let IS_IPHONE_XR = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH == 896.0
let IS_IPHONE_XS_MAX = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH == 896.0


let ThemeNaviBlueColor : UIColor = UIColor.color(string: "292a6a")
let ThemeNaviBlueLightColor : UIColor = UIColor.color(string: "4B4D88")


let ThemeWhiteColor : UIColor = UIColor.color(string: "FFFFFF")
let ThemeClearColor : UIColor = UIColor.clear

let navigationBar_Height_IphoneX_ = 84

let kBack_Icon : String = "iconBack"
let kSearch_Icon : String = "iconSearch"
let kMap_Icon : String = "iconMap"
let kSave_Icon : String = "iconSave"

let kEdit_Icon : String = "iconEdit"
let kMenu_Icon : String = "iconMenu"
let kRight_icon : String = "right_start_icon"
let kPlus_icon : String = "iconPlus"
let kNav_BG_Icon : String = "navi_bar_bg"
let kNav_Icon : String = "navi_icon"





