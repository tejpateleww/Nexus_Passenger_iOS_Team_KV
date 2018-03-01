//
//  TempData.swift
//  TickTok User
//
//  Created by Excellent Webworld on 03/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import Foundation

 // Accept Request by Driver
/*
func Accept Request by Driver()
{
    [{
        BookingInfo =     (
            {
                AdminAmount = "";
                BookingCharge = "";
                BookingType = "";
                ByDriverAmount = "";
                ByDriverId = 0;
                CardId = 0;
                CompanyAmount = "";
                CreatedDate = "2017-12-07T11:05:18.000Z";
                Discount = "";
                DistanceFare = "";
                DriverId = 21;
                DropOffLat = "23.030513";
                DropOffLon = "72.5075401";
                DropTime = "";
                DropoffLocation = "Near Rajpath Club, SG Highway, Bodakdev, Ahmedabad, Gujarat 380054, India";
                GrandTotal = "";
                Id = 182;
                ModelId = 1;
                NightFare = "";
                NightFareApplicable = 0;
                Notes = "";
                PassengerContact = "";
                PassengerEmail = "";
                PassengerId = 44;
                PassengerName = "";
                PaymentStatus = "";
                PaymentType = "";
                PickupLat = "23.0734427";
                PickupLng = "72.5170918";
                PickupLocation = "35, Sola Gam Rd, Sola, Ahmedabad, Gujarat 380060, India";
                PickupTime = "";
                PromoCode = "";
                Reason = "";
                Status = accepted;
                SubTotal = "";
                Tax = "";
                TollFee = "";
                TransactionId = "";
                TripDistance = "";
                TripDuration = "";
                TripFare = "";
                WaitingTime = "";
                WaitingTimeCost = "";
            }
        );
        CarInfo =     (
            {
                Color = Black;
                Company = Hummer;
                CompanyId = 1;
                Description = "";
                DriverId = 21;
                Id = 659;
                RegistrationCertificate = "images/driver/21/image5.jpeg";
                RegistrationCertificateExpire = "2017-12-04T00:00:00.000Z";
                VehicleImage = "images/driver/21/image1.jpeg";
                VehicleInsuranceCertificate = "images/driver/21/image4.jpeg";
                VehicleInsuranceCertificateExpire = "2017-12-04T00:00:00.000Z";
                VehicleModel = 4;
                VehicleRegistrationNo = "GJ-01-B-9999";
            }
        );
        Details =     (
            {
                BookingId = 182;
                BookingType = BookNow;
                Distance = "0.125931449550502";
                DriverId = 21;
                Lat = "23.0734427";
                Long = "72.5170918";
                PassengerId = 44;
                Status = 2;
                UpdateTime = 1512624918;
                UpdatedDate = "2017-12-07 05:35:18";
                "_id" = 5a28d316f2e81b701909cf0f;
            }
        );
        DriverInfo =     (
            {
                ABN = 1234556;
                AccreditationCertificate = "images/driver/21/image2.jpeg";
                AccreditationCertificateExpire = "2017-12-04T00:00:00.000Z";
                Address = Prahladnagar;
                Availability = 1;
                BSB = qwerty;
                BankAcNo = 12345678900987;
                BankHolderName = Bhavesh;
                BankName = HDFC;
                City = Ahmedabad;
                CompanyId = 1;
                Country = India;
                DCNumber = "";
                DispatcherId = 0;
                DriverDuty = 1;
                DriverLicense = "images/driver/21/image.jpeg";
                DriverLicenseExpire = "2017-11-21T00:00:00.000Z";
                Email = "bhavesh@excellentwebworld.info";
                Fullname = "Bhavesh developer";
                Gender = Male;
                Id = 21;
                Image = "images/driver/21/image10037.png";
                Lat = "23.07290128000603";
                Lng = "72.51691108496337";
                MobileNo = 9876543210;
                Password = 25d55ad283aa400af464c76d713c07ad;
                ProfileComplete = 1;
                QRCode = "images/qrcode/jsbS2dDmzpxpaWlfiJyVnKQ=.png";
                ReferralCode = tktc21Bha;
                State = Gujarat;
                Status = 1;
                SubUrb = Ahm;
                ZipCode = 123456;
            }
        );
        message = "Your booking request has been confirmed";
        type = Notification;
        }]
}
*/

//-------------------------------------------------------------
// MARK: - Get Estimate Fare Response
//-------------------------------------------------------------

/*
{
    "estimate_fare" =     (
        {
            "base_fare" = 25;
            "booking_fee" = 2;
            duration = 8;
            id = 1;
            km = "4.2";
            name = "Business Class";
            "per_km_charge" = 0;
            total = "27.2";
            "trip_fare" = 25;
    },
        {
            "base_fare" = "20.2";
            "booking_fee" = 2;
            duration = 8;
            id = 2;
            km = "4.2";
            name = Disability;
            "per_km_charge" = "2.75";
            total = 31;
            "trip_fare" = 29;
    },
        {
            "base_fare" = "4.2";
            "booking_fee" = 2;
            duration = 8;
            id = 3;
            km = "4.2";
            name = Taxi;
            "per_km_charge" = "1.62";
            total = "11.384";
            "trip_fare" = "9.384";
    },
        {
            "base_fare" = 35;
            "booking_fee" = 2;
            duration = 8;
            id = 4;
            km = "4.2";
            name = "First Class";
            "per_km_charge" = 0;
            total = "37.2";
            "trip_fare" = 35;
    },
        {
            "base_fare" = 40;
            "booking_fee" = 2;
            duration = 8;
            id = 5;
            km = "4.2";
            name = "LUX-VAN";
            "per_km_charge" = 0;
            total = 42;
            "trip_fare" = 40;
    },
        {
            "base_fare" = 5;
            "booking_fee" = 2;
            duration = 8;
            id = 6;
            km = "4.2";
            name = Economy;
            "per_km_charge" = "0.5";
            total = "7.6";
            "trip_fare" = "5.6";
    }
    );
    status = 1;
}

*/
/*
(
    {
        AbovePerKmCharge = "1.85";
        BaseFare = 20;
        BelowAndAboveKmLimit = 21;
        BelowPerKmCharge = "1.90";
        BookingFee = 2;
        CancellationFee = 10;
        Capacity = 4;
        CategoryId = 1;
        Description = "Caprice, Genesis, Lexus, Mercedes E, BMW 5 Series, VW Touareg, Audi A6, Chrysler 300C. etc";
        Id = 1;
        Image = "http://54.206.55.185/web/images/model/BUSINESS_12.png";
        Lat = "23.072664";
        Lng = "72.516199";
        MinKm = 3;
        MinuteFare = "0.45";
        Name = "Business Class";
        NightCharge = 10;
        NightChargeApplicable = 1;
        NightTimeFrom = "23:00:00";
        NightTimeTo = "05:00:00";
        Sort = 2;
        SpecialEventSurcharge = 5;
        SpecialEventTimeFrom = "18:00:00";
        SpecialEventTimeTo = "23:59:59";
        Status = 1;
        WaitingTimePerMinuteCharge = 1;
        carCount = 2;
},
    {
        AbovePerKmCharge = "2.75";
        BaseFare = "20.2";
        BelowAndAboveKmLimit = 25;
        BelowPerKmCharge = "2.75";
        BookingFee = 2;
        CancellationFee = 10;
        Capacity = 12;
        CategoryId = 1;
        Description = "(fitted with wheelchair access)";
        Id = 2;
        Image = "http://54.206.55.185/web/images/model/DISABILITY_15.png";
        Lat = "23.072664";
        Lng = "72.516199";
        MinKm = 1;
        MinuteFare = "0.92";
        Name = Disability;
        NightCharge = "11.22";
        NightChargeApplicable = 1;
        NightTimeFrom = "17:00:00";
        NightTimeTo = "09:00:00";
        Sort = 6;
        SpecialEventSurcharge = "3.75";
        SpecialEventTimeFrom = "18:00:00";
        SpecialEventTimeTo = "23:59:59";
        Status = 1;
        WaitingTimePerMinuteCharge = 1;
        carCount = 1;
}
)
 */
