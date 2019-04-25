//
//  PassFilterViewController.swift
//  Nexus User
//
//  Created by EWW076 on 01/04/19.
//  Copyright © 2019 Excellent Webworld. All rights reserved.
//

import UIKit
import M13Checkbox
import GoogleMaps
import GooglePlaces

class PassFilterViewController: BaseViewController{

    @IBOutlet weak var roundTripCheckBox: M13Checkbox!
    @IBOutlet weak var dropOffView: UIView!
    @IBOutlet weak var pickupTimeFld: UITextField!
    @IBOutlet weak var dropOffTimeFld: UITextField!
    @IBOutlet weak var pickupFld: UITextField!
    @IBOutlet weak var dropOffFld: UITextField!
    @IBOutlet weak var carModelFld: UITextField!
    @IBOutlet weak var lblActualPrice: UILabel!
    @IBOutlet weak var lblDiscountPrice: UILabel!
    
    let parameterKey = PassSubscription.shared
    var isOpenPlacePickerController:Bool = false
    var NearByRegion = GMSCoordinateBounds()
    
    let pickupTimeSelector = WWCalendarTimeSelector.instantiate()
    let dropoffTimeSelector = WWCalendarTimeSelector.instantiate()

    let pickupController = GMSAutocompleteViewController()
    let dropOffController = GMSAutocompleteViewController()
    
    var pickupPlace : GMSPlace?
    var dropoffPlace : GMSPlace?
    
    var availableCars = [[String: Any]]()
    var carIndex : Int?
    var pickupDate = Date()
    var dropoffDate : Date?
    
    var passData : [String: Any]?{
        didSet{
            passType = String(describing: (passData!["PassType"] ?? ""))
            passId = String(describing: (passData!["Id"] ?? ""))
            discountValue = String(describing: (passData!["DiscountValue"] ?? ""))
        }
    }
    var passId = ""
    var passengerId = SingletonClass.sharedInstance.strPassengerID
    var passType = ""
    var tripDistance = ""
    var discountType : DiscountType?
    var discountValue = ""
    var carModels = [String]()
    var picker  = UIPickerView()
    var isRoundTrip = "0"
    var getTrip: (() -> ())!
    
    var editable = false
    var currentData = [String: Any]()

    override func viewDidLoad() {
        super.viewDidLoad()
        pickupTimeFld.delegate = self
        dropOffTimeFld.delegate = self
        pickupFld.delegate = self
        dropOffFld.delegate = self
        carModelFld.delegate = self
        carModelFld.inputView = picker
        picker.delegate = self
        roundTripCheckBox.tintColor = ThemeNaviBlueColor
       roundTripCheckBox.stateChangeAnimation = .fill
        roundTripCheckBox.boxType = .square
        setupEditing()
        roundTripCheckBox.checkState = isRoundTrip == "1" ? .checked : .unchecked
        dropOffView.isHidden = roundTripCheckBox.checkState == .unchecked

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setNavBarWithBack(Title: "PASS", IsNeedRightButton: false)
        
    }
    
    func setupEditing(){
        guard editable, currentData.count != 0  else {return}
        pickupFld.text = formattedString(key: "PickupLocation")
        dropOffFld.text = formattedString(key: "DropoffLocation")
        
        pickupTimeFld.text = formattedTime(key: "PickupTime")
        isRoundTrip = formattedString(key: "IsRoundTrip")
        if isRoundTrip == "1"{
            dropOffTimeFld.text = formattedTime(key: "DropoffTime")
        }
        getCarModels()
    }
    
    func formattedTime(key: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        if let date = dateFormatter.date(from:formattedString(key: key))?.stringFromFormat("h:mm a"){
            return date
        }
        return formattedString(key: key)
    }
    
    
    func formattedString(key: String) -> String{
        return (currentData[key] as? String ?? "")
    }
    @IBAction func roundTrip(_ sender: M13Checkbox){
        isRoundTrip = sender.checkState == .checked ? "1" : "0"
        dropOffView.isHidden = sender.checkState == .unchecked
    }
    @IBAction func onSubmit(_ sender: UIButton){
        if isValidate().0{
            getSubscription()
        }else {
            UtilityClass.setCustomAlert(title: "", message: isValidate().1) { (no, str) in
                
            }
        }
        
    }
  
}

//-------------------------------------------------------------
// MARK: - Calendar Methods
//-------------------------------------------------------------

extension PassFilterViewController: WWCalendarTimeSelectorProtocol{
    
    @IBAction func pickUpCalendarAction(_ sender: UIButton) {
        setupCalendar(pickupTimeSelector)
    }
    @IBAction func dropoffCalendarAction(_ sender: UIButton) {
        setupCalendar(dropoffTimeSelector)
    }
   
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        switch selector {
        case pickupTimeSelector:
            pickupDate = date
            pickupTimeFld.text = pickupDate.stringFromFormat("h:mm a")
        case dropoffTimeSelector:
            dropoffDate = date
            dropOffTimeFld.text = dropoffDate!.stringFromFormat("h:mm a")
        default:
            break
        }
    }
    
   
    func  setupCalendar(_ timeSelector: WWCalendarTimeSelector){
        timeSelector.delegate = self
        timeSelector.optionCalendarFontColorPastDates = UIColor.gray
        timeSelector.optionButtonFontColorDone = ThemeNaviBlueColor
        timeSelector.optionSelectorPanelBackgroundColor = ThemeNaviBlueColor
        timeSelector.optionCalendarBackgroundColorTodayHighlight = ThemeNaviBlueColor
        timeSelector.optionTopPanelBackgroundColor = ThemeNaviBlueColor
        timeSelector.optionClockBackgroundColorMinuteHighlightNeedle = ThemeNaviBlueColor
        timeSelector.optionClockBackgroundColorHourHighlight = ThemeNaviBlueColor
        timeSelector.optionClockBackgroundColorAMPMHighlight = ThemeNaviBlueColor
        timeSelector.optionCalendarBackgroundColorPastDatesHighlight = ThemeNaviBlueColor
        timeSelector.optionCalendarBackgroundColorFutureDatesHighlight = ThemeNaviBlueColor
        timeSelector.optionClockBackgroundColorMinuteHighlight = ThemeNaviBlueColor
        timeSelector.optionStyles.showYear(false)
        timeSelector.optionStyles.showMonth(false)
        timeSelector.optionStyles.showDateMonth(false)
        timeSelector.optionStyles.showTime(true)
        timeSelector.optionTopPanelTitle = "Please choose Time"
        timeSelector.optionIdentifier = "Time" as AnyObject
        let dateCurrent = Date()
        timeSelector.optionCurrentDate = dateCurrent.addingTimeInterval(30 * 60)
        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(timeSelector, animated: true, completion: nil)
    }
}

//-------------------------------------------------------------
// MARK: - Google PlacePicker Methods
//-------------------------------------------------------------


extension PassFilterViewController : GMSAutocompleteViewControllerDelegate{
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        switch viewController{
        case pickupController:
            pickupPlace = place
            pickupFld.text = place.formattedAddress
            getCarModels()
        case dropOffController:
            dropoffPlace = place
            dropOffFld.text = place.formattedAddress
            getCarModels()
           
        default:
            break
        }
        dismiss(animated: true, completion: nil)
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: \(error)")
        dismiss(animated: true, completion: nil)
    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        dismiss(animated: true, completion: nil)
    }
    func setupLocationPicker(acController: GMSAutocompleteViewController){
        self.isOpenPlacePickerController = true
        acController.delegate = self
        acController.autocompleteBounds = NearByRegion
        present(acController, animated: true, completion: nil)
    }

}

//-------------------------------------------------------------
// MARK: - TextField Methods
//-------------------------------------------------------------


extension PassFilterViewController: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
            case pickupTimeFld:
                view.endEditing(true)
                setupCalendar(pickupTimeSelector)
                return false
            case dropOffTimeFld:
                view.endEditing(true)
                setupCalendar(dropoffTimeSelector)
                return false
            case pickupFld:
                setupLocationPicker(acController: pickupController)
                return false
            case dropOffFld:
                setupLocationPicker(acController: dropOffController)
                return false
            case carModelFld:
               guard carModels.count > 0 else{
                 getCarModels()
                return false
               }
                return true
            default:
                break
            }
        return true
    }
  
    @IBAction func clearPickupLocation(_ sender: UIButton){
        pickupFld.text = ""
        getCarModels()
    }
    @IBAction func clearDropoffLocation(_ sender: UIButton){
        dropOffFld.text = ""
        getCarModels()
    }
   
}

//MARK: - PickerView Methods

extension PassFilterViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return carModels.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return carModels[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        carIndex = row
        carModelFld.text = carModels[row]
        let selectedCar = availableCars[row]
        
//        self.lblActualPrice.text = formattedPrice(key: "total",selectedCar: selectedCar)
//        self.lblDiscountPrice.text = formattedPrice(key: "trip_fare",selectedCar: selectedCar)
        formattedPrice(key: "total",selectedCar: selectedCar)
    }
    
    
    func getCarModels(){
        
        carModels = [String]()
        carModelFld.text = ""
        lblActualPrice.text = "$"
        lblDiscountPrice.text = "$"
        
//        guard pickupFld.text != "", dropOffFld.text != "" else { return }
        if pickupFld.text != "", dropOffFld.text != "" {
            getDistance()
            UtilityClass.showACProgressHUD()
        } else {
            UtilityClass.setCustomAlert(title: "", message: "Please enter pickup and dropoff location.") { (no, str) in
                }
            return
        }
        
        
        
        
    }
    func isValidate() -> (Bool,String) {
        
        var isValidate:Bool = true
        var ValidatorMessage:String = ""
        
        if pickupFld.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" {
            isValidate  = false
            ValidatorMessage = "Please enter a valid pickup location!"
        }else if dropOffFld.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" {
            isValidate  = false
            ValidatorMessage = "Please enter a valid destination!"
        }else if carModelFld.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" {
            isValidate  = false
            ValidatorMessage = "Please enter a car model!"
        }else if pickupTimeFld.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" {
            isValidate  = false
            ValidatorMessage = "Please select valid pickup time!"
        }else if dropOffTimeFld.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "",
            roundTripCheckBox.checkState == .checked{
            isValidate  = false
            ValidatorMessage = "Please select valid dropoff time!"
        }
        
        
        return (isValidate,ValidatorMessage)
    }
    
    ////-------------------------------------------------------------
    // MARK: - String Formatting
    //-------------------------------------------------------------

    func formattedPrice(key: String, selectedCar: [String:Any]){
        if let  actualPrice = Double(String(describing: (selectedCar[key] ?? "")))?.rounded(toPlaces: 2),
            var cutDiscount = Double(discountValue)?.rounded(toPlaces: 2){
            if discountType == .percentage{
                cutDiscount = actualPrice * (cutDiscount / 100)
            }
            let discountedPrice = (actualPrice - cutDiscount) > 0 ? (actualPrice - cutDiscount).rounded(toPlaces: 2) : 0.0
            self.lblDiscountPrice.text = "$" + String(describing: discountedPrice)
            self.lblActualPrice.text = "$" + String(describing: actualPrice)
        }
            
        else{
            self.lblDiscountPrice.text = "$" + String(describing: (selectedCar[key] ?? ""))
            self.lblActualPrice.text = "$" + String(describing: (selectedCar[key] ?? ""))
        }
        
    }
    
////-------------------------------------------------------------
// MARK: - Webservices
//-------------------------------------------------------------

   func getSubscription(){
    if editable{
        if tripDistance == "" {
            getDistance(){
                self.editSubscription()
            }
        }else{
            self.editSubscription()
        }
    }
    else{
        if tripDistance == "" {
            getDistance(){
                self.doneSubscription()
            }
        }else{
            doneSubscription()
        }
    }
    
    }
    
    func doneSubscription(){
        let parameter = PassSubscription.shared.setParam(passId: passId,
                                                         passengerId: passengerId,
                                                         passType: passType,
                                                         pickLat: "\(pickupPlace!.coordinate.latitude)",
                                                         dropoffLat: "\(dropoffPlace!.coordinate.latitude)",
                                                         pickLong:  "\(pickupPlace!.coordinate.longitude)",
                                                         dropoffLong:  "\(dropoffPlace!.coordinate.longitude)",
                                                         pickupLocation: pickupFld.text!,
                                                         dropoffLocation: dropOffFld.text!,
                                                         tripDistance: tripDistance,
                                                         isRoundTrip: isRoundTrip,
                                                         pickupTime: pickupDate,
                                                         dropoffTime: dropoffDate)
        print(parameter)
        webserviceForPassActivation(parameter as AnyObject) { (response, status) in
            print(response)
          
            if status{
                self.getTrip()
                UtilityClass.setCustomAlert(title: "", message: "Pass has been subscribed successfully") { (index, title) in
                    self.navigationController?.popViewController(animated: true)
                }
            }
            else{
                if let message = response["message"] as? String{
                    UtilityClass.setCustomAlert(title: "", message: message) { (index, title) in
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
            
        }
    }
    func editSubscription(){
        let parameter = PassSubscription.shared.setParam(edit: true,
                                                         passHistoryId: formattedString(key: "Id"),
                                                         pickLat: formattedString(key: "PickupLat"),
                                                        dropoffLat: formattedString(key: "DropoffLat"),
                                                        pickLong:  formattedString(key: "PickupLong"),
                                                        dropoffLong: formattedString(key: "DropoffLong"),
                                                        pickupLocation: pickupFld.text!,
                                                        dropoffLocation: dropOffFld.text!,
                                                         tripDistance: tripDistance,
                                                         isRoundTrip: isRoundTrip,
                                                         pickupTime: pickupDate,
                                                         dropoffTime: dropoffDate)
        webserviceForPassEdit(parameter as AnyObject) { (response , status) in
            print(response)
            
            if status{
                self.getTrip()
                UtilityClass.setCustomAlert(title: "", message: "Pass has been edited successfully") { (index, title) in
                    self.navigationController?.popViewController(animated: true)
                }
            }
            else{
                if let message = response["message"] as? String{
                    UtilityClass.setCustomAlert(title: "", message: message) { (index, title) in
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
            
        }
    }
    func getDistance(completion: (()-> ())? = nil){
        var parameter = [String: Any]()
        parameter["PickupLocation"] = pickupFld.text!
        parameter["DropoffLocation"] = dropOffFld.text!
        
        webserviceForGetEstimateFare(parameter as AnyObject) { (response, status) in
            if status{
                print(response)
                UtilityClass.hideACProgressHUD()
                if let data = response as? [String:Any]{
                    if let availableCars = data["estimate_fare"] as? [[String:Any]]{
                        self.availableCars = availableCars
                        self.carModels = [String]()

                        availableCars.forEach({
                            self.carModels.append($0["name"] as! String)
                        })
                        
                        self.carModelFld.text = self.carModels[0]
                        self.formattedPrice(key: "total",selectedCar: availableCars[0])
                        if let distance = availableCars[0]["km"] as? Double{
                            self.tripDistance = "\(distance)"
                            if let completion = completion{
                            completion()
                        }
                    }
                    else{
                        UtilityClass.showAlert("Invalid Location", message: "Distance not given by the provider", vc: self)
                    }
                }
                }else{
                    UtilityClass.showAlert("Data cant be retrived", message: "Data can't be retrived", vc: self)
                }
            }
            else {
                print(response)
            }
        }
    }
}
