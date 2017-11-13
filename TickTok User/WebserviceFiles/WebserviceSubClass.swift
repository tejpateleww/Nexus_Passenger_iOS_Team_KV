//
//  WebserviceSubClass.swift
//  TickTok User
//
//  Created by Excellent Webworld on 27/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import Alamofire

let DriverLogin = WebserviceURLs.kDriverLogin
let Registration =  WebserviceURLs.kDriverRegister
let ForgotPassword =  WebserviceURLs.kForgotPassword
let CarLists =  WebserviceURLs.kGetCarList
let MakeBookingRequest = WebserviceURLs.kMakeBookingRequest
let bookLater = WebserviceURLs.kAdvancedBooking
let driverList = WebserviceURLs.kDriver
let BookingHistory = WebserviceURLs.kBookingHistory
let GetEstimateFare =  WebserviceURLs.kGetEstimateFare
let ChangePassword = WebserviceURLs.kChangePassword
let UpdateProfile = WebserviceURLs.kUpdateProfile

//-------------------------------------------------------------
// MARK: - Webservice For Registration
//-------------------------------------------------------------

func webserviceForRegistrationForUser(_ dictParams: AnyObject, image1: UIImage, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = Registration
    sendImage(dictParams as! [String : AnyObject], image1: image1, nsURL: url, completion: completion)
    
}

//-------------------------------------------------------------
// MARK: - Webservice For Driver Login
//-------------------------------------------------------------

func webserviceForDriverLogin(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = DriverLogin
    postData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Driver Login
//-------------------------------------------------------------

func webserviceForForgotPassword(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = ForgotPassword
    postData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Driver Login
//-------------------------------------------------------------

func webserviceForCarList(completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = CarLists
    getData([] as AnyObject, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Request a Taxi
//-------------------------------------------------------------

func webserviceForTaxiRequest(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = MakeBookingRequest
    postData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Book Later
//-------------------------------------------------------------

func webserviceForBookLater(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = bookLater
    postData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For All Drivers List
//-------------------------------------------------------------

func webserviceForAllDriversList(completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = driverList
    getData([] as AnyObject, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Booking History
//-------------------------------------------------------------

func webserviceForBookingHistory(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = "\(BookingHistory)/\(dictParams)"
    getData(dictParams as AnyObject, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Get Estimate Fare
//-------------------------------------------------------------

func webserviceForGetEstimateFare(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = GetEstimateFare
    postData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Change Password
//-------------------------------------------------------------

func webserviceForChangePassword(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = ChangePassword
    postData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Update Profile
//-------------------------------------------------------------

func webserviceForUpdateProfile(_ dictParams: AnyObject, image1: UIImage, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = UpdateProfile
    sendImage(dictParams as! [String : AnyObject], image1: image1, nsURL: url, completion: completion)
    
}

