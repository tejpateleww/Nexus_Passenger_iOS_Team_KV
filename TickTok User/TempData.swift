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

/*

AcceptBooking data is [{
    BookingInfo =     (
        {
            AdminAmount = "";
            BookingCharge = "";
            BookingType = "";
            ByDriverAmount = "";
            ByDriverId = 0;
            CardId = 0;
            CompanyAmount = "";
            CompanyId = 1;
            CreatedDate = "2018-05-25T12:59:18.000Z";
            Discount = "";
            DistanceFare = "";
            DriverId = 70;
            DropOffLat = "23.03051289906712";
            DropOffLon = "72.50754006206989";
            DropTime = "";
            DropoffLocation = "SG Road Bodakdev, GJ, Ahmedabad";
            FlightNumber = "";
            GrandTotal = "";
            Id = 7627;
            ModelId = 5;
            NightFare = "";
            NightFareApplicable = 0;
            Notes = "";
            PaidToDriver = 0;
            PassengerContact = "";
            PassengerEmail = "";
            PassengerId = 8;
            PassengerName = "";
            PaymentStatus = "";
            PaymentType = cash;
            PickupLat = "23.07001398702818";
            PickupLng = "72.51621801406145";
            PickupLocation = "119 Anurag Bunglow Road, Ahmedabad, Ahmedabad";
            PickupTime = "";
            PromoCode = "";
            Reason = "";
            Special = 0;
            SpecialExtraCharge = 0;
            Status = accepted;
            SubTotal = "";
            Tax = "";
            TollFee = "";
            TransactionId = "";
            Trash = 0;
            TripDistance = "";
            TripDuration = "";
            TripFare = "";
            WaitingTime = "";
            WaitingTimeCost = "";
        }
    );
    CarInfo =     (
        {
            Color = "";
            Company = jdjdhdh;
            CompanyId = 1;
            Description = "";
            DriverId = 70;
            Id = 197;
            RegistrationCertificate = "images/driver/70/image.jpeg";
            RegistrationCertificateExpire = "0000-00-00";
            VehicleImage = "images/driver/70/image2.jpeg";
            VehicleInsuranceCertificate = "images/driver/70/image1.jpeg";
            VehicleInsuranceCertificateExpire = "0000-00-00";
            VehicleModel = 5;
            VehicleRegistrationNo = jshshs;
        }
    );
    Details =     (
        {
            BookingId = 7627;
            BookingType = BookNow;
            Distance = 980;
            DriverId = 70;
            Lat = "23.070013987028";
            Long = "72.516218014061";
            PassengerId = 8;
            Status = 2;
            UpdateTime = 1527233358;
            UpdatedDate = "2018-05-25 07:29:18";
            "_id" = 5b07bb4ec1f9f1194482ba79;
        }
    );
    DriverInfo =     (
        {
            ABN = "";
            AccreditationCertificate = "images/driver/70/image5.jpeg";
            AccreditationCertificateExpire = "0000-00-00";
            Address = hahshs;
            Availability = 1;
            BSB = shsh;
            BankAcNo = 7477474;
            BankHolderName = rahil;
            BankName = hshah;
            City = "";
            CompanyId = 1;
            Country = "";
            DCNumber = "";
            DOB = "1990-03-15T00:00:00.000Z";
            Description = "";
            DeviceType = 1;
            DispatcherId = 0;
            DriverDuty = 1;
            DriverLicense = "images/driver/70/image4.jpeg";
            DriverLicenseExpire = "0000-00-00";
            Email = "rahul.b.bit@gmail.com";
            Fullname = "rahul patel";
            Gender = Male;
            Id = 70;
            Image = "images/driver/70/0b8ace3f9004dd57fbb80f7e596763fa.png";
            Lat = "23.072699134255576";
            Lng = "72.51637077057804";
            MobileNo = 9904439228;
            Password = 25d55ad283aa400af464c76d713c07ad;
            ProfileComplete = 1;
            QRCode = "images/qrcode/jsbS2dDmzpxqYmdeh6KVnaw=.png";
            ReferralCode = pkng70rah;
            SmartPhone = 1;
            State = "";
            Status = 1;
            SubUrb = "";
            Token = "dDEEbNx7xuo:APA91bFNGAE3dWPeBxwn63lHf8xpQx7o-PxUjCVBRmx_2Xo0hcn4N9kiVNBxcZGQorPk1QNRuhGCcZermxEdueZA9XfkwRVhwvBFhba6hMJXjLlASutGtuRZNqmDmtccAqmirbY5JpyW";
            Trash = 0;
            ZipCode = 48484545;
        }
    );
    ModelInfo =     (
        {
            AbovePerKmCharge = 30;
            BaseFare = 60;
            BelowAndAboveKmLimit = 1000;
            BelowPerKmCharge = 33;
            BookingFee = 0;
            CancellationFee = 25;
            Capacity = 3;
            CategoryId = 1;
            Commission = 5;
            Description = "Smoking is Prohibited in PicknGo";
            Id = 5;
            Image = "images/model/Tuk_Tuk1.jpg";
            MinKm = 1;
            MinuteFare = 0;
            Name = "Tuk Tuk";
            NightCharge = 15;
            NightChargeApplicable = 1;
            NightTimeFrom = "22:00:00";
            NightTimeTo = "06:59:00";
            Sort = 1;
            SpecialEventSurcharge = 0;
            SpecialEventTimeFrom = "17:00:00";
            SpecialEventTimeTo = "18:59:59";
            SpecialExtraCharge = 60;
            Status = 1;
            WaitingTimePerMinuteCharge = "3.50";
        }
    );
    message = "Your booking request has been confirmed";
    type = Notification;
}]

*/
/*
onBookingDetailsAfterCompletedTrip() is [{
    BookingType = BookLater;
    Info =     (
        {
            AdminAmount = "3.14";
            BookingCharge = 0;
            BookingType = "";
            ByDriverAmount = "";
            ByDriverId = 0;
            CardId = 0;
            CompanyAmount = "59.66";
            CompanyId = 1;
            CompanyTax = "";
            CreatedDate = "2018-05-28T18:36:15.000Z";
            Discount = 0;
            DistanceFare = "0.00";
            DriverId = 9;
            DropOffLat = "23.0271224";
            DropOffLon = "72.5084742";
            DropTime = "";
            DropoffLocation = "BRTS Bus Stop Pandurang Shastri Athavale Marg, Ahmedabad, Ahmedabad";
            FlightNumber = "";
            GrandTotal = "62.80";
            Id = 533;
            ModelId = 5;
            NightFare = 0;
            NightFareApplicable = 0;
            Notes = "";
            OnTheWay = 1;
            PaidToDriver = 0;
            PassengerContact = 1122334455;
            PassengerEmail = "";
            PassengerId = 8;
            PassengerName = "Vishal Dabhi";
            PassengerType = myself;
            PaymentStatus = "";
            PaymentType = cash;
            PickupDate = "2018-05-28T00:00:00.000Z";
            PickupDateTime = "2018-05-28T19:06:06.000Z";
            PickupLat = "23.0691958";
            PickupLng = "72.5112124";
            PickupLocation = "Sola, Ahmedabad, Gujarat 380060, India";
            PickupTime = "";
            PromoCode = "";
            Reason = "";
            Status = completed;
            SubDispatcherId = 0;
            SubTotal = "62.80";
            Tax = "0.00";
            TollFee = 0;
            TransactionId = "";
            Trash = 0;
            TripDistance = 9;
            TripDuration = 1080;
            TripFare = 60;
            WaitingTime = 48;
            WaitingTimeCost = "2.80";
        }
    );
    PassengerType = myself;
    UpdatedBal = "-715";
}]
*/


// Get Estimate Fare
/*
[{
    "estimate_fare" =     (
        {
            "base_fare" = 210;
            "booking_fee" = 0;
            duration = 0;
            id = 1;
            km = "8.800000000000001";
            name = Executive;
            "per_km_charge" = 64;
            "share_ride" = 0;
            sort = 4;
            total = "581.2";
            "trip_fare" = "581.2";
    },
        {
            "base_fare" = 140;
            "booking_fee" = 0;
            duration = 0;
            id = 2;
            km = "8.800000000000001";
            name = "Mini Car";
            "per_km_charge" = 45;
            "share_ride" = 1;
            sort = 3;
            total = "312.2";
            "trip_fare" = 446;
    },
        {
            "base_fare" = 1000;
            "booking_fee" = 0;
            duration = 0;
            id = 3;
            km = "8.800000000000001";
            name = VAN;
            "per_km_charge" = 0;
            "share_ride" = 0;
            sort = 5;
            total = 1000;
            "trip_fare" = 1000;
    },
        {
            "base_fare" = 140;
            "booking_fee" = 0;
            duration = 1;
            id = 4;
            km = "8.800000000000001";
            name = Nano;
            "per_km_charge" = 40;
            "share_ride" = 1;
            sort = 2;
            total = "288.4";
            "trip_fare" = 412;
    },
        {
            "base_fare" = 60;
            "booking_fee" = 0;
            duration = 1;
            id = 5;
            km = "8.800000000000001";
            name = "Tuk Tuk";
            "per_km_charge" = 33;
            "share_ride" = 1;
            sort = 1;
            total = "222.18";
            "trip_fare" = "317.4";
    },
        {
            "base_fare" = 6000;
            "booking_fee" = 200;
            duration = 0;
            id = 6;
            km = "8.800000000000001";
            name = "Breakdown Services";
            "per_km_charge" = 0;
            "share_ride" = 0;
            sort = 7;
            total = 6200;
            "trip_fare" = 6000;
    },
        {
            "base_fare" = 5000;
            "booking_fee" = 2;
            duration = 0;
            id = 7;
            km = "8.800000000000001";
            name = Bus;
            "per_km_charge" = "0.80";
            "share_ride" = 0;
            sort = 6;
            total = "5006.64";
            "trip_fare" = "5004.64";
    }
    );
    status = 1;
}]
*/


/*
onAcceptBookLaterBookingRequestNotification() is [{
    BookingInfo =     (
        {
            AdminAmount = "";
            BookingCharge = "";
            BookingType = "";
            ByDriverAmount = "";
            ByDriverId = 0;
            CancelBy = "";
            CancellationFee = "";
            CancelledReason = "";
            CancelledTime = "0000-00-00 00:00:00";
            CardId = 0;
            CompanyAmount = "";
            CompanyId = 1;
            CompanyTax = "";
            CreatedDate = "2018-10-05T14:54:41.000Z";
            Discount = "";
            DistanceFare = "";
            DriverId = 7;
            DropOffLat = "23.0632526";
            DropOffLon = "72.5372408";
            DropTime = "";
            DropoffLocation = "112, Mahavir Smruti Society, C P Nagar Cross Road, Ghatlodiya, Ahmedabad, Gujarat 380061, India";
            FlightNumber = "";
            GrandTotal = "";
            Id = 183;
            Labour = 0;
            ModelId = 1;
            NightFare = "";
            NightFareApplicable = 0;
            Notes = "";
            OnTheWay = 0;
            PaidToDriver = 0;
            ParcelId = 0;
            PassengerContact = 6655443322;
            PassengerEmail = "";
            PassengerId = 8;
            PassengerName = "Bhavesh Odedra      ";
            PassengerType = myself;
            PaymentStatus = "";
            PaymentType = cash;
            PickupDate = "2018-10-05T00:00:00.000Z";
            PickupDateTime = "2018-10-05T16:24:31.000Z";
            PickupLat = "23.072623";
            PickupLng = "72.516301";
            PickupLocation = "508, City Center, CIMS Circle, Science City Road, Sola, Sola, Ahmedabad, Gujarat 380060, India";
            PickupTime = "";
            PromoCode = "";
            Reason = "";
            RequestFor = taxi;
            Status = accepted;
            SubTotal = "";
            Tax = "";
            TollFee = "";
            TransactionId = "";
            Trash = 0;
            TripDistance = "2.7";
            TripDuration = 420;
            TripFare = "";
            WaitingTime = "";
            WaitingTimeCost = "";
        }
    );
    CarInfo =     (
        {
            Color = "";
            Company = "Honda City";
            CompanyId = 0;
            Description = "";
            DriverId = 7;
            Id = 206;
            RegistrationCertificate = "images/driver/7/9db3a1ccb98081a08249795a36280dd0";
            RegistrationCertificateExpire = "0000-00-00";
            VehicleImage = "images/driver/7/abf823b2179ff509afbffeb9420c2ee5";
            VehicleInsuranceCertificate = "images/driver/7/bbb21eb13995764acf3bf962479a6d2f";
            VehicleInsuranceCertificateExpire = "2018-09-25T00:00:00.000Z";
            VehicleModel = 1;
            VehicleRegistrationNo = Gj11;
        }
    );
    Details =     (
        {
            AdminAmount = "";
            BookingCharge = "";
            BookingType = "";
            ByDriverAmount = "";
            ByDriverId = 0;
            CancelBy = "";
            CancellationFee = "";
            CancelledReason = "";
            CancelledTime = "0000-00-00 00:00:00";
            CardId = 0;
            CompanyAmount = "";
            CompanyId = 1;
            CompanyTax = "";
            CreatedDate = "2018-10-05T14:54:41.000Z";
            Discount = "";
            DistanceFare = "";
            DriverId = 7;
            DropOffLat = "23.0632526";
            DropOffLon = "72.5372408";
            DropTime = "";
            DropoffLocation = "112, Mahavir Smruti Society, C P Nagar Cross Road, Ghatlodiya, Ahmedabad, Gujarat 380061, India";
            FlightNumber = "";
            GrandTotal = "";
            Id = 183;
            Labour = 0;
            ModelId = 1;
            NightFare = "";
            NightFareApplicable = 0;
            Notes = "";
            OnTheWay = 0;
            PaidToDriver = 0;
            ParcelId = 0;
            PassengerContact = 6655443322;
            PassengerEmail = "";
            PassengerId = 8;
            PassengerName = "Bhavesh Odedra      ";
            PassengerType = myself;
            PaymentStatus = "";
            PaymentType = cash;
            PickupDate = "2018-10-05T00:00:00.000Z";
            PickupDateTime = "2018-10-05T16:24:31.000Z";
            PickupLat = "23.072623";
            PickupLng = "72.516301";
            PickupLocation = "508, City Center, CIMS Circle, Science City Road, Sola, Sola, Ahmedabad, Gujarat 380060, India";
            PickupTime = "";
            PromoCode = "";
            Reason = "";
            RequestFor = taxi;
            Status = accepted;
            SubTotal = "";
            Tax = "";
            TollFee = "";
            TransactionId = "";
            Trash = 0;
            TripDistance = "2.7";
            TripDuration = 420;
            TripFare = "";
            WaitingTime = "";
            WaitingTimeCost = "";
        }
    );
    DriverInfo =     (
        {
            ABN = "";
            AccreditationCertificate = "images/driver/7/32ebc539e476e4c9e387c92d716ccf54";
            AccreditationCertificateExpire = "2018-09-25T00:00:00.000Z";
            Address = Ahmedabad;
            Availability = 1;
            BSB = bodakdev;
            BankAcNo = 1234567890;
            BankHolderName = "Jone Cena";
            BankName = kotak;
            City = "";
            CompanyId = 1;
            Country = "";
            CreatedDate = "2018-09-25T19:20:15.000Z";
            DCNumber = "";
            DOB = "2018-09-25T00:00:00.000Z";
            Description = "";
            DeviceType = 2;
            DispatcherId = 0;
            DriverDuty = 1;
            DriverLicense = "images/driver/7/a0ebb1f7e4b27ef3da1df6333419b43a";
            DriverLicenseExpire = "2018-09-27T00:00:00.000Z";
            Email = "vishal@gmail.com";
            Fullname = "Jhon Cena";
            Gender = Male;
            Id = 7;
            Image = "images/driver/7/bc7657ea0397c28072d7624a8e0d4cc1";
            Lat = "23.072758";
            Lng = "72.51634";
            MobileNo = 9977553311;
            Password = 25d55ad283aa400af464c76d713c07ad;
            PendingBooking = 0;
            ProfileComplete = 1;
            Pwd = "";
            QRCode = "images/qrcode/ZHJpdmVyXzk5Nzc1NTMzMTE=.png";
            ReferralCode = cbrddr7Jho;
            ShareRiding = 0;
            SmartPhone = 1;
            State = "";
            Status = 1;
            SubUrb = "";
            Token = "fhsNbUST9O8:APA91bEXaz5GebDBuOif0bLTUvxbeRTOKoCrHDC5g9pcZ7aUvA1idMHZZxd8mxOs9xOtBOtF4rETzMcOJ17rykyvG6BTiGG_elmebxrkAuZoy6PgWzN_VAcGwaBePwKVQiUxssnKgjL3";
            Trash = 0;
            ZipCode = 123456;
        }
    );
    ModelInfo =     (
        {
            AbovePerKmCharge = "2.25";
            BaseFare = 25;
            BelowAndAboveKmLimit = 15;
            BelowPerKmCharge = "2.85";
            BookingFee = 5;
            CancellationFee = 10;
            Capacity = 4;
            CategoryId = 1;
            Commission = 0;
            Description = Premium;
            Height = 0;
            Id = 1;
            Image = "images/model/Premium.png";
            MinKm = 3;
            MinuteFare = "0.80";
            ModelSizeImage = "";
            Name = Premium;
            NightCharge = 20;
            NightChargeApplicable = 1;
            NightTimeFrom = "23:00:00";
            NightTimeTo = "05:00:00";
            Sort = 1;
            SpecialEventSurcharge = 5;
            SpecialEventTimeFrom = "18:00:00";
            SpecialEventTimeTo = "23:59:59";
            SpecialExtraCharge = 0;
            Status = 1;
            WaitingTimePerMinuteCharge = 1;
            Width = 0;
        }
    );
    message = "Your driver is on the way.";
    type = Notification;
}]
*/
/*
AcceptBooking data is [{
    BookingInfo =     (
        {
            AdminAmount = "";
            BookingCharge = "";
            BookingType = "";
            ByDriverAmount = "";
            ByDriverId = 0;
            CancelBy = "";
            CancellationFee = "";
            CancelledReason = "";
            CancelledTime = "0000-00-00 00:00:00";
            CardId = 0;
            CompanyAmount = "";
            CompanyId = 1;
            CreatedDate = "2018-10-05T17:03:31.000Z";
            Discount = "";
            DistanceFare = "";
            DriverId = 0;
            DropOffLat = "23.03097140877728";
            DropOffLon = "72.4762849509716";
            DropTime = "";
            DropoffLocation = "Sardar Patel Ring Road, Near Bopal Circle, Bopal, Ahmedabad, Gujarat 380058, India";
            FlightNumber = "";
            GrandTotal = "";
            Id = 282;
            ModelId = 2;
            NightFare = "";
            NightFareApplicable = 0;
            NoOfPassenger = 1;
            Notes = "";
            PaidToDriver = 0;
            PassengerContact = "";
            PassengerEmail = "";
            PassengerId = 8;
            PassengerName = "";
            PaymentStatus = "";
            PaymentType = cash;
            PickupLat = "23.072623";
            PickupLng = "72.516301";
            PickupLocation = "508, City Center, CIMS Circle, Science City Road, Sola, Sola, Ahmedabad, Gujarat 380060, India";
            PickupTime = "";
            PromoCode = "";
            Reason = "";
            ShareRide = 0;
            Special = 0;
            SpecialExtraCharge = 0;
            Status = pending;
            SubTotal = "";
            Tax = "";
            TollFee = "";
            TransactionId = "";
            Trash = 0;
            TripDistance = "";
            TripDuration = "";
            TripFare = "";
            WaitingTime = "";
            WaitingTimeCost = "";
        }
    );
    CarInfo =     (
        {
            Color = "";
            Company = "Honda City";
            CompanyId = 0;
            Description = "";
            DriverId = 4;
            Id = 167;
            RegistrationCertificate = "images/driver/4/28ccc7b881f3b6f36a221aec2c794a02";
            RegistrationCertificateExpire = "0000-00-00";
            VehicleImage = "images/driver/4/ebdd2686603f3c98a9c3fa816ef17c91";
            VehicleInsuranceCertificate = "images/driver/4/80768f73e67fb3e8cc935082e90b8d5f";
            VehicleInsuranceCertificateExpire = "2018-09-29T00:00:00.000Z";
            VehicleModel = 2;
            VehicleRegistrationNo = "GJ 11 314";
        }
    );
    Details =     (
        {
            BookingId = 282;
            BookingType = BookNow;
            Distance = 50;
            DriverId = 4;
            Lat = "23.072623";
            Long = "72.516301";
            PassengerId = 8;
            Status = 2;
            UpdateTime = 1538739211;
            UpdatedDate = "2018-10-05 11:33:31";
            "_id" = 5bb74c0bd898550305886d8e;
        }
    );
    DriverInfo =     (
        {
            ABN = "";
            AccreditationCertificate = "images/driver/4/ca418b1166fd0891019ef284d6104e3c";
            AccreditationCertificateExpire = "2018-09-13T00:00:00.000Z";
            Address = Ahmedabad;
            Availability = 1;
            BSB = "Ahmedabad Branch";
            BankAcNo = 1234567890;
            BankHolderName = "Jhon Cena";
            BankName = kotak;
            City = "";
            CompanyId = 1;
            Country = "";
            CreatedDate = "0000-00-00 00:00:00";
            DCNumber = "";
            DOB = "2018-09-11T00:00:00.000Z";
            Description = "";
            DeviceType = 2;
            DispatcherId = 0;
            DriverDuty = 1;
            DriverLicense = "images/driver/4/2a801982e0710874c283e5f5cf6d6956";
            DriverLicenseExpire = "2018-09-11T00:00:00.000Z";
            
            Email = "vishal@excellentwebworld.info";
            Fullname = "Jhon Cena";
            Gender = Male;
            Id = 4;
            Image = "images/driver/4/285608cbd0d0d9f6427d639dabb2143a";
            Lat = "23.072764";
            Lng = "72.516352";
            MobileNo = 1133557799;
            Password = 25d55ad283aa400af464c76d713c07ad;
            PendingBooking = 0;
            ProfileComplete = 1;
            Pwd = "";
            QRCode = "images/qrcode/ZHJpdmVyXzExMzM1NTc3OTk=.png";
            ReferralCode = cbrddr4Jho;
            ShareRiding = 0;
            SmartPhone = 1;
            State = "";
            Status = 1;
            SubUrb = "";
            Token = "e8qH1fCwaSg:APA91bEp6jIhs4FkO9-HI22YqGniOG1ZqfPLlelpZZ-_V47GNVOXsA1qhuF7hz2iN0hCZh0cFeeHmFqzynHrDVRMUSEIIdDeiCL70WM3i0gnzsdkYnNvp1M5qxPzYuFrIbsKEOJiY43q";
            Trash = 0;
            ZipCode = 123456;
        }
    );
    ModelInfo =     (
        {
            AbovePerKmCharge = "1.90";
            BaseFare = 20;
            BelowAndAboveKmLimit = 21;
            BelowPerKmCharge = "2.00";
            BookingFee = 4;
            CancellationFee = 10;
            Capacity = 4;
            CategoryId = 1;
            Commission = 0;
            Description = "Caprice, Genesis, Lexus, Mercedes E, BMW 5 Series, VW Touareg, Audi A6, Chrysler 300C. etc";
            Height = 0;
            Id = 2;
            Image = "images/model/Standard-min.png";
            MinKm = 3;
            MinuteFare = "0.80";
            ModelSizeImage = "";
            Name = Standard;
            NightCharge = 10;
            NightChargeApplicable = 1;
            NightTimeFrom = "23:00:00";
            NightTimeTo = "05:00:00";
            Sort = 2;
            SpecialEventSurcharge = 5;
            SpecialEventTimeFrom = "18:00:00";
            SpecialEventTimeTo = "23:59:59";
            SpecialExtraCharge = 0;
            Status = 1;
            WaitingTimePerMinuteCharge = "1.00";
            Width = 0;
        }
    );
    message = "Your booking request has been confirmed.";
    type = Notification;
}]
*/


/*
CurrentBooking
{
    BookingInfo =     (
        {
            AdminAmount = "";
            BookingCharge = "";
            BookingType = "";
            ByDriverAmount = "";
            ByDriverId = 0;
            CancelBy = "";
            CancellationFee = "";
            CancelledReason = "";
            CancelledTime = "0000-00-00 00:00:00";
            CardId = 0;
            CompanyAmount = "";
            CompanyId = 1;
            CreatedDate = "2018-10-05 17:45:32";
            Discount = "";
            DistanceFare = "";
            DriverId = 4;
            DropOffLat = "23.03051289906712";
            DropOffLon = "72.50754006206989";
            DropTime = "";
            DropoffLocation = "Iscon Mega Mall, First Floor, Sarkhej - Gandhinagar Hwy, Ahmedabad, Gujarat 380054, India";
            FlightNumber = "";
            GrandTotal = "";
            Id = 297;
            ModelId = 2;
            NightFare = "";
            NightFareApplicable = 0;
            NoOfPassenger = 1;
            Notes = "";
            PaidToDriver = 0;
            PassengerContact = "";
            PassengerEmail = "";
            PassengerId = 8;
            PassengerName = "";
            PaymentStatus = "";
            PaymentType = cash;
            PickupLat = "23.072623";
            PickupLng = "72.516301";
            PickupLocation = "508, City Center, CIMS Circle, Science City Road, Sola, Sola, Ahmedabad, Gujarat 380060, India";
            PickupTime = "";
            PromoCode = "";
            Reason = "";
            ShareRide = 0;
            Special = 0;
            SpecialExtraCharge = 0;
            Status = accepted;
            SubTotal = "";
            Tax = "";
            TollFee = "";
            TransactionId = "";
            Trash = 0;
            TripDistance = "";
            TripDuration = "";
            TripFare = "";
            WaitingTime = "";
            WaitingTimeCost = "";
        }
    );
    BookingType = BookNow;
    CarInfo =     (
        {
            Color = "";
            Company = "Honda City";
            CompanyId = 0;
            Description = "";
            DriverId = 4;
            Id = 167;
            Model =             {
                AbovePerKmCharge = "1.90";
                BaseFare = 20;
                BelowAndAboveKmLimit = 21;
                BelowPerKmCharge = "2.00";
                BookingFee = 4;
                CancellationFee = 10;
                Capacity = 4;
                CategoryId = 1;
                Commission = 0;
                Description = "Caprice, Genesis, Lexus, Mercedes E, BMW 5 Series, VW Touareg, Audi A6, Chrysler 300C. etc";
                Height = 0;
                Id = 2;
                Image = "images/model/Standard-min.png";
                MinKm = 3;
                MinuteFare = "0.80";
                ModelSizeImage = "";
                Name = Standard;
                NightCharge = 10;
                NightChargeApplicable = 1;
                NightTimeFrom = "23:00:00";
                NightTimeTo = "05:00:00";
                Sort = 2;
                SpecialEventSurcharge = 5;
                SpecialEventTimeFrom = "18:00:00";
                SpecialEventTimeTo = "23:59:59";
                SpecialExtraCharge = 0;
                Status = 1;
                WaitingTimePerMinuteCharge = "1.00";
                Width = 0;
            };
            RegistrationCertificate = "images/driver/4/28ccc7b881f3b6f36a221aec2c794a02";
            RegistrationCertificateExpire = "0000-00-00";
            VehicleImage = "images/driver/4/ebdd2686603f3c98a9c3fa816ef17c91";
            VehicleInsuranceCertificate = "images/driver/4/80768f73e67fb3e8cc935082e90b8d5f";
            VehicleInsuranceCertificateExpire = "2018-09-29";
            VehicleModel = 2;
            VehicleRegistrationNo = "GJ 11 314";
        }
    );
    DriverInfo =     (
        {
            ABN = "";
            AccreditationCertificate = "images/driver/4/ca418b1166fd0891019ef284d6104e3c";
            AccreditationCertificateExpire = "2018-09-13";
            Address = Ahmedabad;
            Availability = 1;
            BSB = "Ahmedabad Branch";
            BankAcNo = 1234567890;
            BankHolderName = "Jhon Cena";
            BankName = kotak;
            City = "";
            CompanyId = 1;
            Country = "";
            CreatedDate = "0000-00-00 00:00:00";
            DCNumber = "";
            DOB = "2018-09-11";
            Description = "";
            DeviceType = 2;
            DispatcherId = 0;
            DriverDuty = 1;
            DriverLicense = "images/driver/4/2a801982e0710874c283e5f5cf6d6956";
            DriverLicenseExpire = "2018-09-11";
            Email = "vishal@excellentwebworld.info";
            Fullname = "Jhon Cena";
            Gender = Male;
            Id = 4;
            Image = "images/driver/4/285608cbd0d0d9f6427d639dabb2143a";
            Lat = "23.072769";
            Lng = "72.516357";
            MobileNo = 1133557799;
            Password = 25d55ad283aa400af464c76d713c07ad;
            PendingBooking = 1;
            ProfileComplete = 1;
            Pwd = "";
            QRCode = "images/qrcode/ZHJpdmVyXzExMzM1NTc3OTk=.png";
            ReferralCode = cbrddr4Jho;
            ShareRiding = 0;
            SmartPhone = 1;
            State = "";
            Status = 1;
            SubUrb = "";
            Token = "e8qH1fCwaSg:APA91bEp6jIhs4FkO9-HI22YqGniOG1ZqfPLlelpZZ-_V47GNVOXsA1qhuF7hz2iN0hCZh0cFeeHmFqzynHrDVRMUSEIIdDeiCL70WM3i0gnzsdkYnNvp1M5qxPzYuFrIbsKEOJiY43q";
            Trash = 0;
            ZipCode = 123456;
        }
    );
    Status = accepted;
    balance = "15809.6";
    cards =     (
        {
            Alias = "";
            CardNum = 4444333322221111;
            CardNum2 = "xxxx xxxx xxxx 1111";
            Expiry = "/30";
            Id = 34;
            Type = visa;
        }
    );
    rating = "4.7";
    status = 1;
    type = Notification;
}
 */
