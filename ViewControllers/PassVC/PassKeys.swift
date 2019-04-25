//
//  PassKeys.swift
//  Nexus User
//
//  Created by EWW076 on 08/04/19.
//  Copyright © 2019 Excellent Webworld. All rights reserved.
//

import Foundation
import GooglePlaces
struct PassSubscription{
 
    static let shared = PassSubscription()
    var dictParam = [String:Any]()
    let forKeyPassengerId = "PassengerId"
    let forKeyPassId = "PassId"
    let forKeyPassType = "PassType"
    let forKeyPickupLocation = "PickupLocation"
    let forKeyDropoffLocation = "DropoffLocation"
    let forKeyPickupLat = "PickupLat"
    let forKeyPickupLong = "PickupLong"
    let forKeyDropoffLat = "DropoffLat"
    let forKeyDropoffLong = "DropoffLong"
    let forKeyTripDistance = "TripDistance"
    let forKeyIsRoundTrip = "IsRoundTrip"
    let forKeyPickupTime = "PickupTime"
    let forKeyDropoffTime = "DropoffTime"
    let forKeyPassHistoryId = "PassHistoryId"
  
    func setParam(edit: Bool = false,
                  passHistoryId: String? = nil,
                  passId: String? = nil,
                  passengerId: String? = nil,
                  passType: String? = nil,
                  pickLat: String,
                  dropoffLat: String,
                  pickLong: String,
                  dropoffLong: String,
                  pickupLocation: String,
                  dropoffLocation: String,
                  tripDistance : String,
                  isRoundTrip: String,
                  pickupTime: Date,
                  dropoffTime: Date? = nil) -> [String:Any]
    {
        var dictParam = [String:Any]()
        if edit{
            dictParam[forKeyPassHistoryId] = passHistoryId
        }else{
            dictParam[forKeyPassengerId] = passengerId!
            dictParam[forKeyPassId] = passId!
            dictParam[forKeyPassType] = passType!
        }
        
        dictParam[forKeyPickupLocation] = pickupLocation
        dictParam[forKeyDropoffLocation] = dropoffLocation
        
        dictParam[forKeyPickupLat] = pickLat
        dictParam[forKeyPickupLong] = pickLong
        dictParam[forKeyDropoffLat] = dropoffLat
        
        dictParam[forKeyDropoffLong] = dropoffLong
        dictParam[forKeyTripDistance] = tripDistance
        dictParam[forKeyIsRoundTrip] = isRoundTrip
        dictParam[forKeyPickupTime] = setTime(date: pickupTime)
        if isRoundTrip == "1"{
            dictParam[forKeyDropoffTime] = setTime(date: dropoffTime!)
        }
        return dictParam
    }
    
    func getLatitude(place: GMSPlace) -> Double{
        return place.coordinate.latitude
    }
    func getLongitude(place: GMSPlace) -> Double{
        return place.coordinate.longitude
    }
    
    func setTime(date: Date) -> String{
        return date.stringFromFormat("HH:mm:ss")
    }
}

enum PassStatus: String{
    case activate = "Activate"
    case deactivate = "Deactivate"
}
enum DiscountType: String{
    case percentage = "percentage"
    case flat = "flat"
    case none = "none"
}
