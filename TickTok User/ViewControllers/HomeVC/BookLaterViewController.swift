//
//  BookLaterViewController.swift
//  TickTok User
//
//  Created by Excellent Webworld on 04/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import M13Checkbox
import GoogleMaps
import GooglePlaces
import SDWebImage


class BookLaterViewController: UIViewController, GMSAutocompleteViewControllerDelegate, UINavigationControllerDelegate, WWCalendarTimeSelectorProtocol {

    var strModelId = String()
    var BoolCurrentLocation = Bool()
    var strCarModelURL = String()
    var strPassengerType = String()
    var convertDateToString = String()
    var boolIsSelected = Bool()
    var strCarName = String()
    
    var strFullname = String()
    var strMobileNumber = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        constraintsHeightOFtxtFlightNumber.constant = 0 // 30 Height
        constaintsOfTxtFlightNumber.constant = 0
        txtFlightNumber.isHidden = true
        
        viewMySelf.boxType = .square
        viewMySelf.checkState = .checked
        viewOthers.boxType = .square
        strPassengerType = "myself"
        viewFlightNumber.boxType = .square
        
        txtDataAndTimeFromCalendar.isUserInteractionEnabled = false

        viewCurrentLocation.layer.shadowOpacity = 0.3
        viewCurrentLocation.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        
        viewDestinationLocation.layer.shadowOpacity = 0.3
        viewDestinationLocation.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        
        imgCareModel.sd_setImage(with: URL(string: strCarModelURL), completed: nil)
        
        lblCareModelClass.text = "Car Model: \(strCarName)"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var viewMySelf: M13Checkbox!
    @IBOutlet weak var viewOthers: M13Checkbox!
    @IBOutlet weak var viewFlightNumber: M13Checkbox!
    
    @IBOutlet weak var viewDestinationLocation: UIView!
    @IBOutlet weak var viewCurrentLocation: UIView!
    
    @IBOutlet weak var lblMySelf: UILabel!
    @IBOutlet weak var lblOthers: UILabel!
    
    @IBOutlet weak var lblCareModelClass: UILabel!
    @IBOutlet weak var imgCareModel: UIImageView!
    
    @IBOutlet weak var txtPickupLocation: UITextField!
    @IBOutlet weak var txtDropOffLocation: UITextField!
    
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var txtDataAndTimeFromCalendar: UITextField!
    @IBOutlet weak var btnCalendar: UIButton!
 
    @IBOutlet weak var txtFlightNumber: UITextField!
    @IBOutlet weak var constraintsHeightOFtxtFlightNumber: NSLayoutConstraint!
    @IBOutlet weak var constaintsOfTxtFlightNumber: NSLayoutConstraint! // 10
    
    
    
    //-------------------------------------------------------------
    // MARK: - Button Actions
    //-------------------------------------------------------------
    
    @IBAction func btnBack(_ sender: UIButton) {
        
    self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func viewMySelf(_ sender: M13Checkbox) {
        
        viewMySelf.checkState = .checked
        viewOthers.checkState = .unchecked
        
        if strFullname == "" || strMobileNumber == "" {
            
            strFullname = txtFullName.text!
            strMobileNumber = txtMobileNumber.text!
        }
        else {
            
            txtFullName.text = strFullname
            txtMobileNumber.text = strMobileNumber
        }
     
        strPassengerType = "myself"
        
    }
    
    @IBAction func viewOthers(_ sender: M13Checkbox) {
        
        viewMySelf.checkState = .unchecked
        viewOthers.checkState = .checked
        
        strFullname = txtFullName.text!
        strMobileNumber = txtMobileNumber.text!
        
        txtFullName.text = ""
        txtMobileNumber.text = ""
        
        strPassengerType = "other"
    }
    
    @IBAction func viewFlightNumber(_ sender: M13Checkbox) {
        
        boolIsSelected = !boolIsSelected
        
        if (boolIsSelected) {
            
            constraintsHeightOFtxtFlightNumber.constant = 40
            constaintsOfTxtFlightNumber.constant = 10
            txtFlightNumber.isHidden = false
        }
        else {
            
            constraintsHeightOFtxtFlightNumber.constant = 0
            constaintsOfTxtFlightNumber.constant = 0
            txtFlightNumber.isHidden = true
           
        }
        
//        if viewFlightNumber.markType == .checkmark {
//            constraintsHeightOFtxtFlightNumber.constant = 30
//            constaintsOfTxtFlightNumber.constant = 10
//        }
//        else {
//            constraintsHeightOFtxtFlightNumber.constant = 0
//            constaintsOfTxtFlightNumber.constant = 0
//        }
        
        
    }
    
    @IBAction func txtPickupLocation(_ sender: UITextField) {
        
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        
        BoolCurrentLocation = true
        
        present(acController, animated: true, completion: nil)
        
    }
    @IBAction func txtDropOffLocation(_ sender: UITextField) {
        
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        
        BoolCurrentLocation = false
        
        present(acController, animated: true, completion: nil)
        
    }
    
    @IBAction func btnCalendar(_ sender: UIButton) {
        
        let selector = WWCalendarTimeSelector.instantiate()
        selector.delegate = self
        
        // 2. You can then set delegate, and any customization options
        //        selector.delegate = self
        selector.optionTopPanelTitle = "Please choose date"
        
        // 3. Then you simply present it from your view controller when necessary!
        self.present(selector, animated: true, completion: nil)
   
    }
    
    
    
    @IBAction func btnSubmit(_ sender: UIButton) {
        
       
        if txtFullName.text == "" || txtMobileNumber.text == "" || txtPickupLocation.text == "" || txtDropOffLocation.text == "" || txtDataAndTimeFromCalendar.text == "" || strPassengerType == ""  {
            
            UtilityClass.showAlert("Missing", message: "All fields are required...", vc: self)
        }
        else if viewMySelf.checkState == .unchecked && viewOthers.checkState == .unchecked {
            
            UtilityClass.showAlert("Missing", message: "Please Checked Myself or Other", vc: self)
        }
        else {
            webserviceOFBookLater()
        }
        
    }
    
    var strPickupLocation = String()
    var strDropoffLocation = String()
    
    var doublePickupLat = Double()
    var doublePickupLng = Double()
    
    var doubleDropOffLat = Double()
    var doubleDropOffLng = Double()
    
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        if BoolCurrentLocation {
            txtPickupLocation.text = place.formattedAddress
            strPickupLocation = place.formattedAddress!
            doublePickupLat = place.coordinate.latitude
            doublePickupLng = place.coordinate.longitude
            
        }
        else {
            txtDropOffLocation.text = place.formattedAddress
            strDropoffLocation = place.formattedAddress!
            doubleDropOffLat = place.coordinate.latitude
            doubleDropOffLng = place.coordinate.longitude
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: \(error)")
        dismiss(animated: true, completion: nil)
    }
    
    // User cancelled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        dismiss(animated: true, completion: nil)
    }
    
    //-------------------------------------------------------------
    // MARK: - Calendar Method
    //-------------------------------------------------------------
    
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date)
    {
        let myDateFormatter: DateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "dd/MM/yyyy hh:mm"
        
        let dateOfPostToApi: DateFormatter = DateFormatter()
        dateOfPostToApi.dateFormat = "yyyy-MM-dd hh:mm:ss a"
        
        convertDateToString = dateOfPostToApi.string(from: date)
        
        
        let finalDate = myDateFormatter.string(from: date)
        
        // get the date string applied date format
        let mySelectedDate = String(describing: finalDate)
        
        txtDataAndTimeFromCalendar.text = mySelectedDate
        
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Webservice For Book Later
    //-------------------------------------------------------------
    
    // PassengerId,ModelId,PickupLocation,DropoffLocation,PassengerType(myself,other),PassengerName,PassengerContact,PickupDateTime,FlightNumber
    
    func webserviceOFBookLater()
    {
        
        var dictData = [String:AnyObject]()
        
        dictData["PassengerId"] = SingletonClass.sharedInstance.strPassengerID as AnyObject
        dictData["ModelId"] = strModelId as AnyObject
        dictData["PickupLocation"] = txtPickupLocation.text as AnyObject
        dictData["DropoffLocation"] = txtDropOffLocation.text as AnyObject
        dictData["PassengerType"] = strPassengerType as AnyObject
        dictData["PassengerName"] = txtFullName.text as AnyObject
        dictData["PassengerContact"] = txtMobileNumber.text as AnyObject
        dictData["PickupDateTime"] = convertDateToString as AnyObject
        
        if txtFlightNumber.text?.characters.count == 0 {
            
            dictData["FlightNumber"] = "" as AnyObject
        }
        else {
            dictData["FlightNumber"] = txtFlightNumber.text as AnyObject
        }
        
        webserviceForBookLater(dictData as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
                
                let alert = UIAlertController(title: nil, message: "Booking Successful", preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alert.addAction(ok)
                
                self.present(alert, animated: true, completion: nil)
 /*
                {
                    info =     {
                        BookingFee = "2.2";
                        Duration = 27;
                        EstimatedFare = "43.28";
                        GrandTotal = "45.48";
                        Id = 1;
                        KM = "9.6";
                        SubTotal = "43.28";
                        Tax = "4.548";
                    };
                    status = 1;
                }
*/
                
            } else {
                
                print(result)
            }
        }
        
        
    }
    
    
    @IBAction func btnClearCurrentLocation(_ sender: UIButton) {
        txtPickupLocation.text = ""
    }
    
    @IBAction func btnClearDropOffLocation(_ sender: UIButton) {
        txtDropOffLocation.text = ""
    }
    
    
}
