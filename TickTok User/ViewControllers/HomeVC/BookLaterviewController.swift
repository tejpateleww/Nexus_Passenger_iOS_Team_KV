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
import FormTextField
import ACFloatingTextfield_Swift
import IQKeyboardManagerSwift


protocol isHaveCardFromBookLaterDelegate {
    
    func didHaveCards()
}

@objc protocol parcelAndLabourDelegate {
    
    @objc optional func didParcelSelected(dict: [String:Any]?)
    @objc optional func didLabourSelected(dict: [String:Any]?)
}


extension UIApplication {
    var statusBarView: UIView? {
        
        return value(forKey: "statusBar") as? UIView
    }
}


class BookLaterviewController: UIViewController, GMSAutocompleteViewControllerDelegate, UINavigationControllerDelegate, WWCalendarTimeSelectorProtocol, UIPickerViewDelegate, UIPickerViewDataSource, isHaveCardFromBookLaterDelegate, UITextFieldDelegate, parcelAndLabourDelegate {
   

    var pickerView = UIPickerView()
    var pickerViewLabour = UIPickerView()
    
    var strModelId = String()
    var BoolCurrentLocation = Bool()
    var strCarModelURL = String()
    var strPassengerType = String()
    var convertDateToString = String()
    var boolIsSelected = Bool()
    var boolIsSelectedNotes = Bool()
    var strCarName = String()
    
    var strFullname = String()
    var strMobileNumber = String()
    
    var placesClient = GMSPlacesClient()
    var locationManager = CLLocationManager()
    
    var aryOfPaymentOptionsNames = [String]()
    var aryOfPaymentOptionsImages = [String]()
    
    var CardID = String()
    var paymentType = String()
    
    var selector = WWCalendarTimeSelector.instantiate()
    
    var aryParcelData = [[String:Any]]()
    var aryLabour = [[String:Any]]()
    
    var isTruckSelected = false
    var strEstimateFare = String()
    var strLabourId = "0"
    var strParcelId = String()
    
    var strTruckSizeImage = String()
    var truckDetails = (name: "", height: "", width: "", capacity: "", image: "", desc: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationFontBlack()
       
        txtDropOffLocation.delegate = self
        
//        UIApplication.shared.statusBarView?.backgroundColor = UIColor.black
         
        constaintFlightNumHight.constant = 0
        constaintNotesOfHight.constant = 0
        
        if #available(iOS 11.0, *) {
            if (UIApplication.shared.keyWindow?.safeAreaInsets.top)! > 0.0 {
                
                print("iPhone X")
            }
            else {
                print("Not iPhone X ")
            }
        } else {
            // Fallback on earlier versions
        }
    
        txtDropOffLocation.text = strDropoffLocation

        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
         txtFullName.leftView = paddingView
        txtFullName.leftViewMode = .always
        
        
        selector.delegate = self
//        alertView.removeFromSuperview()
        
        btnForMySelfAction.addTarget(self, action: #selector(self.ActionForViewMySelf), for: .touchUpInside)
        
        btnForOthersAction.addTarget(self, action: #selector(self.ActionForViewOther), for: .touchUpInside)
        
        viewProocode.isHidden = true
        

        webserviceOfCardList()
        
        pickerView.delegate = self
        pickerViewLabour.delegate = self
        
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.doneActionOnPickerFoLabour))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.cancelActionOnPickerFoLabour))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        txtLabour.inputAccessoryView = toolBar
        txtLabour.inputView = pickerViewLabour
        
        aryOfPaymentOptionsNames = [""]
        aryOfPaymentOptionsImages = [""]
        
        locationManager.startUpdatingLocation()
        locationManager.delegate = self

        setViewDidLoad()
        
        txtDataAndTimeFromCalendar.isUserInteractionEnabled = false
        imgCareModel.sd_setImage(with: URL(string: strCarModelURL), completed: nil)
        
        if isTruckSelected {
            lblCareModelClass.text = "Transport Model: \(strCarName)"
        }
        else {
            lblCareModelClass.text = "Car Model: \(strCarName)"
        }
        
        
        
        txtFullName.text = strFullname
        txtMobileNumber.text = strMobileNumber

        checkMobileNumber()
        
        // --------------------------------------------
        
        webserviceOfParcelAndLabour()
        
        stackViewTruckAndLabour.isHidden = true
        stackViewEstimateFare.isHidden = true
        viewTruckDetails.isHidden = true
        constraintTopOfStackViewOfEstimateFare.constant = 0
        constraintHeightOfStackViewOfEstimateFare.constant = 0
        
        
        if isTruckSelected {
            stackViewTruckAndLabour.isHidden = false
            stackViewEstimateFare.isHidden = false
            viewTruckDetails.isHidden = false
            constraintTopOfStackViewOfEstimateFare.constant = 5
            constraintHeightOfStackViewOfEstimateFare.constant = 30
            lblEstimateFare.text = "\(currencySign) \(strEstimateFare)"
            
            stackViewMySelfAndOthers.isHidden = true
            btnForMySelfAction.isHidden = true
            btnForOthersAction.isHidden = true
            
            if strPickupLocation != "" && strDropoffLocation != "" && strModelId != "" {
                
                webserviceOfGetEstimateFareForDeliveryService()
            }
            
            txtFullName.isHidden = true
            txtMobileNumber.isHidden = true
            viewUnderLineOfTxtMobileNumber.isHidden = true
            viewUnderLineOfTxtFullName.isHidden = true
            
            viewFlightNumberView.isHidden = true
            constraintTopOfViewNotes.priority = UILayoutPriority(rawValue: 1000)
            constraintBottomOfTruckDetails.priority = UILayoutPriority(rawValue: 1000)
            
            if truckDetails.image != "" {
                
                imgTruckDetails.sd_setIndicatorStyle(.gray)
                imgTruckDetails.sd_showActivityIndicatorView()
                imgTruckDetails.sd_setImage(with: URL(string: WebserviceURLs.kImageBaseURL + truckDetails.image), completed: nil)
            }
            
        }
        
        // --------------------------------------------
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        gaveCornerRadius()
        
        if SingletonClass.sharedInstance.CardsVCHaveAryData.count != 0 {
            pickerView.reloadAllComponents()
            txtSelectPaymentMethod.text = ""
            imgPaymentOption.image = UIImage(named: "iconDummyCard")
//            paymentType = "cash"
           pickerView.selectedRow(inComponent: 0)
            txtSelectPaymentMethod.becomeFirstResponder()
            txtSelectPaymentMethod.resignFirstResponder()
 
        }
        
       txtSelectPaymentMethod.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(self.IQKeyboardmanagerDoneMethod))
        
        fillTextFields()
        
//        getPlaceFromLatLong()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func doneActionOnPickerFoLabour() {
        
        if strPickupLocation != "" && strDropoffLocation != "" {
            webserviceOfGetEstimateFareForDeliveryService()
        }
        
        txtLabour.resignFirstResponder()
    }
    
    @objc func cancelActionOnPickerFoLabour() {
        
        strLabourId = ""
        btnLabour.setTitle("", for: .normal)
        
        txtLabour.text = ""
        txtLabour.placeholder = "  Labour"
        
        if strPickupLocation != "" && strDropoffLocation != "" {
            webserviceOfGetEstimateFareForDeliveryService()
        }
        
        txtLabour.resignFirstResponder()
    }
    
    func fillTextFields() {
        txtPickupLocation.text = strPickupLocation
        txtDropOffLocation.text = strDropoffLocation
        
    }
    
    func gaveCornerRadius() {
        
        viewCurrentLocation.layer.cornerRadius = 5
        viewDestinationLocation.layer.cornerRadius = 5
        
        viewCurrentLocation.layer.borderWidth = 1
        viewDestinationLocation.layer.borderWidth = 1
        
        viewDestinationLocation.layer.borderColor = UIColor.black.cgColor
        viewDestinationLocation.layer.borderColor = UIColor.black.cgColor
        
        viewCurrentLocation.layer.masksToBounds = true
        viewDestinationLocation.layer.masksToBounds = true
        
    }

    func setViewDidLoad() {
        
//        let themeColor: UIColor = UIColor.init(red: 255/255, green: 163/255, blue: 0, alpha: 1.0)
        
        viewMySelf.tintColor = ThemeBlueColor
        viewOthers.tintColor = ThemeBlueColor
        viewFlightNumber.tintColor = ThemeBlueColor
        btnNotes.tintColor = ThemeBlueColor
        
        
        viewMySelf.stateChangeAnimation = .fill
        viewOthers.stateChangeAnimation = .fill
        viewFlightNumber.stateChangeAnimation = .fill
        btnNotes.stateChangeAnimation = .fill
        
        viewMySelf.boxType = .square
        
        viewMySelf.checkState = .checked
        viewOthers.boxType = .square
        btnNotes.boxType = .square
        strPassengerType = "myself"
        viewFlightNumber.boxType = .square
        
//        constraintsHeightOFtxtFlightNumber.constant = 0 // 30 Height
//        constaintsOfTxtFlightNumber.constant = 0
//        viewLineForFlightNumberHeight.constant = 0
        
        constantHavePromoCodeTop.constant = 31
//        constantNoteHeight.constant = 0
//        viewLineForFlightNumberHeight.constant = 0
//        imgViewLineForNotesHeight.constant = 0
        
//        txtFlightNumber.isHidden = true
//        txtFlightNumber.isEnabled = false
//        txtDescription.isEnabled = false
        
        
        alertView.layer.cornerRadius = 10
        alertView.layer.masksToBounds = true
        
        txtDataAndTimeFromCalendar.layer.borderWidth = 1
        txtDataAndTimeFromCalendar.layer.cornerRadius = 5
        txtDataAndTimeFromCalendar.layer.borderColor = UIColor.black.cgColor
        txtDataAndTimeFromCalendar.layer.masksToBounds = true
        
        
        viewPaymentMethod.layer.borderWidth = 1
        viewPaymentMethod.layer.cornerRadius = 5
        viewPaymentMethod.layer.borderColor = UIColor.black.cgColor
        viewPaymentMethod.layer.masksToBounds = true
        
        btnSubmit.layer.cornerRadius = 10
        btnSubmit.layer.masksToBounds = true
        
//        viewCurrentLocation.layer.shadowOpacity = 0.3
//        viewCurrentLocation.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
//        viewDestinationLocation.layer.shadowOpacity = 0.3
//        viewDestinationLocation.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
    }
 
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    @IBOutlet weak var viewProocode: UIView!
    @IBOutlet weak var btnSubmit: UIButton!
       @IBOutlet weak var constaintFlightNumHight: NSLayoutConstraint!
    
    @IBOutlet weak var constaintNotesOfHight: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var viewMySelf: M13Checkbox!
    @IBOutlet weak var viewOthers: M13Checkbox!
    @IBOutlet weak var viewFlightNumber: M13Checkbox!
    
    @IBOutlet weak var viewFlightNumberView: UIView!
    @IBOutlet weak var constraintTopOfViewNotes: NSLayoutConstraint!
    
    
  
    @IBOutlet weak var viewDestinationLocation: UIView!
    @IBOutlet weak var viewCurrentLocation: UIView!
    
    @IBOutlet weak var lblMySelf: UILabel!
    @IBOutlet weak var lblOthers: UILabel!
    
    @IBOutlet weak var lblCareModelClass: UILabel!
    @IBOutlet weak var imgCareModel: UIImageView!
    
    @IBOutlet weak var txtPickupLocation: UITextField!
    @IBOutlet weak var txtDropOffLocation: UITextField!
    
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtMobileNumber: FormTextField!
    @IBOutlet weak var txtDataAndTimeFromCalendar: UITextField!
    @IBOutlet weak var btnCalendar: UIButton!
 
    @IBOutlet weak var txtFlightNumber: UITextField!
    @IBOutlet weak var constraintsHeightOFtxtFlightNumber: NSLayoutConstraint!
    @IBOutlet weak var constaintsOfTxtFlightNumber: NSLayoutConstraint! // 10
    
    @IBOutlet weak var txtSelectPaymentMethod: UITextField!
    @IBOutlet weak var imgPaymentOption: UIImageView!
    
    @IBOutlet weak var btnNotes: M13Checkbox!
    
    @IBOutlet weak var constantNoteHeight: NSLayoutConstraint!  // 40
    
    @IBOutlet weak var constantHavePromoCodeTop: NSLayoutConstraint!  // 31
    
    @IBOutlet weak var txtPromoCode: UITextField!
    
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var viewPaymentMethod: UIView!
    
    @IBOutlet weak var lblPromoCode: UILabel!
    var BackView = UIView()
    
    @IBOutlet weak var btnForMySelfAction: UIButton!
    @IBOutlet weak var btnForOthersAction: UIButton!
    
    @IBOutlet weak var viewLineForFlightNumberHeight: NSLayoutConstraint!
    @IBOutlet weak var imgViewLineForNotesHeight: NSLayoutConstraint!
    
    @IBOutlet weak var stackViewTruckAndLabour: UIStackView!
    @IBOutlet weak var stackViewEstimateFare: UIStackView!
    @IBOutlet weak var constraintTopOfStackViewOfEstimateFare: NSLayoutConstraint! // 5
    @IBOutlet weak var constraintHeightOfStackViewOfEstimateFare: NSLayoutConstraint! // 23
    @IBOutlet weak var lblEstimateFare: UILabel!
    
    @IBOutlet weak var stackViewMySelfAndOthers: UIStackView!
    
    @IBOutlet weak var btnParcel: UIButton!
    @IBOutlet weak var btnLabour: UIButton!
    
    @IBOutlet weak var viewUnderLineOfTxtFullName: UIView!
    @IBOutlet weak var viewUnderLineOfTxtMobileNumber: UIView!
    
    @IBOutlet weak var txtLabour: UITextField!
    
    @IBOutlet weak var imgTruckDetails: UIImageView!
    @IBOutlet weak var viewTruckDetails: UIView!
    
    @IBOutlet weak var constraintBottomOfTruckDetails: NSLayoutConstraint!
    
    
    //-------------------------------------------------------------
    // MARK: - Button Actions
    //-------------------------------------------------------------
    
    @IBAction func btnTruckDetailsInfo(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "segueTruckDetails", sender: nil)
    }
    
    @IBAction func btnApply(_ sender: UIButton) {
        
        
        if txtPromoCode.text != "" {
            
            lblPromoCode.text = txtPromoCode.text
            
            viewProocode.isHidden = true
            
            self.view.alpha = 1.0
        }
        else {
           UtilityClass.showAlert(appName, message: "Please enter promo code", vc: self)
        }
      
//        BackView.removeFromSuperview()
//        alertView.removeFromSuperview()
        
        
    }
    @IBAction func btnCancel(_ sender: UIButton) {
        
        viewProocode.isHidden = true
        
        txtPromoCode.text = ""
        lblPromoCode.text = ""
        self.view.alpha = 1.0
//        BackView.removeFromSuperview()
//        alertView.removeFromSuperview()
    }
    
    @IBAction func btnHavePromoCode(_ sender: UIButton) {
        
//        txtPromoCode.becomeFirstResponder()
//        alertView.isHidden = false
        
        viewProocode.isHidden = false
        
//        UIApplication.shared.keyWindow!.bringSubview(toFront: alertView)
    }
    
    @IBAction func btnNotes(_ sender: M13Checkbox) {
        
        boolIsSelectedNotes = !boolIsSelectedNotes
        
        if (boolIsSelectedNotes) {
             constaintNotesOfHight.constant = 35
//            constantNoteHeight.constant = 40
            constantHavePromoCodeTop.constant = 31
//            imgViewLineForNotesHeight.constant = 1
//            txtSelectPaymentMethod.isHidden = false
//             txtDescription.isEnabled = true
        }
        else {
             constaintNotesOfHight.constant = 0
//            constantNoteHeight.constant = 0
            constantHavePromoCodeTop.constant = 31
//            imgViewLineForNotesHeight.constant = 0
//            txtSelectPaymentMethod.isHidden = true
//            txtDescription.isEnabled = false

        }
        
    }
    @IBAction func txtSelectPaymentMethod(_ sender: UITextField) {
        
        txtSelectPaymentMethod.inputView = pickerView
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        
    self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func viewMySelf(_ sender: M13Checkbox) {
     
        ActionForViewMySelf()
       
    }
    
    @objc func ActionForViewMySelf() {
        
        viewMySelf.checkState = .checked
        viewOthers.checkState = .unchecked
        viewMySelf.stateChangeAnimation = .fill
    
        txtFullName.text = strFullname
        txtMobileNumber.text = strMobileNumber

        strPassengerType = "myself"
        
    }
    
    @objc func ActionForViewOther() {
        viewMySelf.checkState = .unchecked
        viewOthers.checkState = .checked
        viewOthers.stateChangeAnimation = .fill
      
        txtFullName.text = ""
        txtMobileNumber.text = ""
        
        strPassengerType = "other"
    }
    
    @IBAction func viewOthers(_ sender: M13Checkbox) {
        ActionForViewOther()
        
    }
    
    @IBAction func viewFlightNumber(_ sender: M13Checkbox) {
        
        boolIsSelected = !boolIsSelected
        
        if (boolIsSelected) {
            constaintFlightNumHight.constant = 35
//            constraintsHeightOFtxtFlightNumber.constant = 40 //binal
//            constaintsOfTxtFlightNumber.constant = 10
//            viewLineForFlightNumberHeight.constant = 1
//            txtFlightNumber.isHidden = false
//            txtFlightNumber.isEnabled = true
        }
        else {
            constaintFlightNumHight.constant = 0
//            constraintsHeightOFtxtFlightNumber.constant = 0
//            constaintsOfTxtFlightNumber.constant = 0
//            viewLineForFlightNumberHeight.constant = 0
//            txtFlightNumber.isHidden = true
//            txtFlightNumber.isEnabled = false
           
        }
    }
    
    @IBAction func txtPickupLocation(_ sender: UITextField) {

        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        
        BoolCurrentLocation = true
        setNavigationFontBlack()
        present(acController, animated: true, completion: nil)
        
    }
    @IBAction func txtDropOffLocation(_ sender: UITextField) {
        
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        
        BoolCurrentLocation = false
        setNavigationFontBlack()
        present(acController, animated: true, completion: nil)
        
    }
    
    @IBAction func btnCalendar(_ sender: UIButton) {
        
        selector.optionCalendarFontColorPastDates = UIColor.gray
        selector.optionButtonFontColorDone = ThemeBlueColor
        selector.optionSelectorPanelBackgroundColor = ThemeBlueColor
        selector.optionCalendarBackgroundColorTodayHighlight = ThemeBlueColor
        selector.optionTopPanelBackgroundColor = ThemeBlueColor
        selector.optionClockBackgroundColorMinuteHighlightNeedle = ThemeBlueColor
        selector.optionClockBackgroundColorHourHighlight = ThemeBlueColor
        selector.optionClockBackgroundColorAMPMHighlight = ThemeBlueColor
        selector.optionCalendarBackgroundColorPastDatesHighlight = ThemeBlueColor
        selector.optionCalendarBackgroundColorFutureDatesHighlight = ThemeBlueColor
        selector.optionClockBackgroundColorMinuteHighlight = ThemeBlueColor
        
        
        
//        selector.optionStyles.showDateMonth(true)
        selector.optionStyles.showYear(false)
//        selector.optionStyles.showMonth(true)
        
        selector.optionStyles.showTime(true)
        
        // 2. You can then set delegate, and any customization options

        selector.optionTopPanelTitle = "Please choose date"
        
        selector.optionIdentifier = "Time" as AnyObject

        let dateCurrent = Date()
     

        selector.optionCurrentDate = dateCurrent.addingTimeInterval(30 * 60)

        // 3. Then you simply present it from your view controller when necessary!
        self.present(selector, animated: true, completion: nil)
   
    }
    
    
    
    @IBAction func btnSubmit(_ sender: UIButton) {
        
       
        if txtFullName.text == "" || txtMobileNumber.text == "" || txtPickupLocation.text == "" || txtDropOffLocation.text == "" || txtDataAndTimeFromCalendar.text == "" || strPassengerType == "" || paymentType == "" {
            
            UtilityClass.setCustomAlert(title: "", message: "All fields are required...") { (index, title) in
            }
        }
        else if viewMySelf.checkState == .unchecked && viewOthers.checkState == .unchecked {
            
            UtilityClass.setCustomAlert(title: "", message: "Please checked myself or other") { (index, title) in
            }
        }
        else {
            webserviceOFBookLater()
        }
        
    }
    
    var validationsMobileNumber = Validation()
    var inputValidatorMobileNumber = InputValidator()
    
    func checkMobileNumber() {
        
        
        txtMobileNumber.inputType = .integer
        
        
        //        var validation = Validation()
        validationsMobileNumber.maximumLength = 10
        validationsMobileNumber.minimumLength = 10
        validationsMobileNumber.characterSet = NSCharacterSet.decimalDigits
        let inputValidator = InputValidator(validation: validationsMobileNumber)
        txtMobileNumber.inputValidator = inputValidator
        
        print("txtMobileNumber : \(txtMobileNumber.text!)")
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
            txtPickupLocation.text = place.name + " " + place.formattedAddress!
            strPickupLocation = place.name + " " + place.formattedAddress!
            doublePickupLat = place.coordinate.latitude
            doublePickupLng = place.coordinate.longitude
            
        }
        else {
            txtDropOffLocation.text = place.name + " " + place.formattedAddress!
            strDropoffLocation = place.name + " " + place.formattedAddress!
            doubleDropOffLat = place.coordinate.latitude
            doubleDropOffLng = place.coordinate.longitude
        }
        
        if txtPickupLocation.text != "" && txtDropOffLocation.text != "" && strModelId != "" {
            
            webserviceOfGetEstimateFareForDeliveryService()
        }
        
        setNavigationClear()
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: \(error)")
        setNavigationClear()
        
        dismiss(animated: true, completion: nil)
    }
    
    // User cancelled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        setNavigationClear()
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnParcelVehicle(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "segueToParcelList", sender: nil)
    }
    
    @IBAction func btnLabourVehicle(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "segueToLabour", sender: nil)
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToParcelList" {
            
            let destinationVC = segue.destination as! ParcelListViewController
            destinationVC.aryParcel = aryParcelData
            destinationVC.delegate = self
        }
        
        if segue.identifier == "segueToLabour" {
            
            let destinationVC = segue.destination as! LabourListViewController
            destinationVC.aryLabour = aryLabour
            destinationVC.delegate = self
        }
        
        if segue.identifier == "segueTruckDetails" {
            
            let destinationVC = segue.destination as! TruckDetailsViewController
            destinationVC.truckDetail = truckDetails
           
        }
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == txtDropOffLocation {
            
            self.txtDropOffLocation(txtDropOffLocation)
            
            return false
        }
        
        return true
    }
    
    
    func getPlaceFromLatLong()
    {
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            //            self.txtCurrentLocation.text = "No current place"
            self.txtPickupLocation.text = ""
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    self.strPickupLocation = place.formattedAddress!
                    self.doublePickupLat = place.coordinate.latitude
                    self.doublePickupLng = place.coordinate.longitude
                    self.txtPickupLocation.text = place.formattedAddress?.components(separatedBy: ", ")
                        .joined(separator: "\n")
                }
            }
        })
    }
    
    func setCardIcon(str: String) -> String {
//        visa , mastercard , amex , diners , discover , jcb , other
        var CardIcon = String()
        
        switch str {
        case "visa":
            CardIcon = "Visa"
            return CardIcon
        case "mastercard":
            CardIcon = "MasterCard"
            return CardIcon
        case "amex":
            CardIcon = "Amex"
            return CardIcon
        case "diners":
            CardIcon = "Diners Club"
            return CardIcon
        case "discover":
            CardIcon = "Discover"
            return CardIcon
        case "jcb":
            CardIcon = "JCB"
            return CardIcon
        case "iconCashBlack":
            CardIcon = "iconCashBlack"
            return CardIcon
        case "iconWalletBlack":
            CardIcon = "iconWalletBlack"
            return CardIcon
        case "iconPlusBlack":
            CardIcon = "iconPlusBlack"
            return CardIcon
        case "other":
            CardIcon = "iconDummyCard"
            return CardIcon
        default:
            return ""
        }
        
    }
    
    func didHaveCards() {
        
        aryCards.removeAll()
        webserviceOfCardList()
    }
    
    @objc func IQKeyboardmanagerDoneMethod() {
        
        if (isAddCardSelected) {
             self.addNewCard()
        }
        
//        txtSelectPaymentMethod.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(self.IQKeyboardmanagerDoneMethod))
    }
    
    // ----------------------------------------------------
    // MARK: - Parcel And Labour Delegate Methods
    // ----------------------------------------------------
    
    func didParcelSelected(dict: [String : Any]?) {
        print("parcel data: \(dict!)")
        
        if dict != nil {
            if let id = dict?["Id"] as? String {
                strParcelId = id
            }
            else if let id = dict?["Id"] as? Int {
                strParcelId = "\(id)"
            }
            else {
                strParcelId = ""
            }
            
            if let name = dict?["Name"] as? String {
                btnParcel.setTitle("  \(name)", for: .normal)
            }
        }
        else {
            strParcelId = ""
        }
    }
    
    func didLabourSelected(dict: [String : Any]?) {
        print("labour data: \(dict!)")
        
//        if dict != nil {
//            if let id = dict?["Id"] as? String {
//                strLabourId = id
//            }
//            else if let id = dict?["Id"] as? Int {
//                strLabourId = "\(id)"
//            }
//            else {
//                strLabourId = "0"
//            }
//
//            if let title = dict?["Title"] as? String {
//                btnLabour.setTitle("  \(title)", for: .normal)
//            }
//
//            webserviceOfGetEstimateFareForDeliveryService()
//        }
//        else {
//            strLabourId = "0"
//        }
        
    }
  
    
    //-------------------------------------------------------------
    // MARK: - PickerView Methods
    //-------------------------------------------------------------
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerViewLabour == pickerView {
            return 10
        }
        return aryCards.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//
//    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        if pickerViewLabour == pickerView {
            
            let myView = UIView(frame: CGRect(x:0, y:0, width: pickerView.bounds.width - 30, height: 60))
            
            let myLabel = UILabel(frame: CGRect(x:(pickerView.bounds.width) / 2, y:0, width:pickerView.bounds.width - 90, height:60 ))
            //        myLabel.font = UIFont(name:some, font, size: 18)
            myLabel.text = "\(row + 1)"
            
            myView.addSubview(myLabel)
            
            return myView
        }
        else {
            
            let data = aryCards[row]
            
            let myView = UIView(frame: CGRect(x:0, y:0, width: pickerView.bounds.width - 30, height: 60))
            
            let centerOfmyView = myView.frame.size.height / 4
            
            
            let myImageView = UIImageView(frame: CGRect(x:0, y:centerOfmyView, width:40, height:26))
            myImageView.contentMode = .scaleAspectFit
            
            var rowString = String()
            
            switch row {
                
            case 0:
                rowString = data["CardNum2"] as! String
                myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
            case 1:
                rowString = data["CardNum2"] as! String
                myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
            case 2:
                rowString = data["CardNum2"] as! String
                myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
            case 3:
                rowString = data["CardNum2"] as! String
                myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
            case 4:
                rowString = data["CardNum2"] as! String
                myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
            case 5:
                rowString = data["CardNum2"] as! String
                myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
            case 6:
                rowString = data["CardNum2"] as! String
                myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
            case 7:
                rowString = data["CardNum2"] as! String
                myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
            case 8:
                rowString = data["CardNum2"] as! String
                myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
            case 9:
                rowString = data["CardNum2"] as! String
                myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
            case 10:
                rowString = data["CardNum2"] as! String
                myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
            default:
                rowString = "Error: too many rows"
                myImageView.image = nil
            }
            let myLabel = UILabel(frame: CGRect(x:60, y:0, width:pickerView.bounds.width - 90, height:60 ))
            //        myLabel.font = UIFont(name:some, font, size: 18)
            myLabel.text = rowString
            
            myView.addSubview(myLabel)
            myView.addSubview(myImageView)
            
            return myView
        }
        
    }
    
    var isAddCardSelected = Bool()
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerViewLabour == pickerView {
            
            strLabourId = "\(row + 1)"
            btnLabour.setTitle("", for: .normal)
            txtLabour.text = "  \(row + 1)"
          
        }
        else {
            
            let data = aryCards[row]
            
            imgPaymentOption.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
            txtSelectPaymentMethod.text = data["CardNum2"] as? String
            
            if data["CardNum"] as! String == "Add a Card" {
                
                isAddCardSelected = true
                //            self.addNewCard()
            }
            
            let type = data["CardNum"] as! String
            
            if type  == "wallet" {
                paymentType = "wallet"
            }
            else if type == "cash" {
                paymentType = "cash"
            }
            else {
                paymentType = "card"
            }
            
            
            if paymentType == "card" {
                
                if data["Id"] as? String != "" {
                    CardID = data["Id"] as! String
                }
            }
        }
        
    }
    
    func addNewCard() {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
        next.delegateAddCardFromBookLater = self
        self.isAddCardSelected = false
        self.navigationController?.present(next, animated: true, completion: nil)
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Calendar Method
    //-------------------------------------------------------------
    
    var currentDate = Date()
    
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date)
    {
       
        if currentDate < date {
            
//            let calendarDate = Calendar.current
//            let hour = calendarDate.component(.hour, from: date)
//            let minutes = calendarDate.component(.minute, from: date)
   
            let currentTimeInterval = currentDate.addingTimeInterval(30 * 60)
            
            if  date > currentTimeInterval {
                
                let myDateFormatter: DateFormatter = DateFormatter()
                myDateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
                
                let dateOfPostToApi: DateFormatter = DateFormatter()
                dateOfPostToApi.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
                convertDateToString = dateOfPostToApi.string(from: date)
                
                let finalDate = myDateFormatter.string(from: date)
                
                // get the date string applied date format
                let mySelectedDate = String(describing: finalDate)
                
                txtDataAndTimeFromCalendar.text = mySelectedDate
            }
            else {
                
                txtDataAndTimeFromCalendar.text = ""
                
                UtilityClass.setCustomAlert(title: "Time should be", message: "Please select 30 minutes greater time from current time!") { (index, title) in
                }

            }
            
        }

    }
    
    func WWCalendarTimeSelectorWillDismiss(_ selector: WWCalendarTimeSelector) {
        
    }
    
    func WWCalendarTimeSelectorDidDismiss(_ selector: WWCalendarTimeSelector) {
        
    }

    
    func WWCalendarTimeSelectorShouldSelectDate(_ selector: WWCalendarTimeSelector, date: Date) -> Bool {
        
        if currentDate < date {
          
            let currentTimeInterval = currentDate.addingTimeInterval(30 * 60)
            
            if  date > currentTimeInterval {
            
                
                return true
            }
            
            return false
        }
        
        return false
    }
    
   
    
    
    //-------------------------------------------------------------
    // MARK: - Webservice For Book Later
    //-------------------------------------------------------------
    
    //PassengerId,ModelId,PickupLocation,DropoffLocation,PassengerType(myself,other),PassengerName,PassengerContact,PickupDateTime,FlightNumber,
    //PromoCode,Notes,PaymentType,CardId(If paymentType is card)
    
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
        
        if lblPromoCode.text == "" {
            
        }
        else {
            dictData["PromoCode"] = lblPromoCode.text as AnyObject
        }
        
        dictData["Notes"] = txtDescription.text as AnyObject
       
        if paymentType == "" {
            
            UtilityClass.setCustomAlert(title: "", message: "Select Payment Type") { (index, title) in
            }
        }
        else {
            dictData["PaymentType"] = paymentType as AnyObject
        }
        
        if CardID == "" {
          
        }
        else {
            dictData["CardId"] = CardID as AnyObject
        }
        
        if txtFlightNumber.text!.count == 0 {
            
            dictData["FlightNumber"] = "" as AnyObject
        }
        else {
            dictData["FlightNumber"] = txtFlightNumber.text as AnyObject
        }
        
        dictData["RequestFor"] = "taxi" as AnyObject
        
        if isTruckSelected {
            dictData["RequestFor"] = "delivery" as AnyObject
            
            if strParcelId == "" {
                UtilityClass.setCustomAlert(title: "Missing", message: "Please select transport service") { (index, title) in
                }
                return
            }
            
            dictData["ParcelId"] = strParcelId as AnyObject
            dictData["LabourId"] = strLabourId as AnyObject
        }
        
        webserviceForBookLater(dictData as AnyObject) { (result, status) in
            
            if (status) {
                print(result)

                UtilityClass.setCustomAlert(title: "\(appName)", message: "Your ride has been booked.", completionHandler: { (index, title) in
                    
                    self.navigationController?.popViewController(animated: true)
                })
                
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
              
                if let res = result as? String {
                    UtilityClass.setCustomAlert(title: "", message: res) { (index, title) in
                    }
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.setCustomAlert(title: "", message: resDict.object(forKey: "message") as! String) { (index, title) in
                    }
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.setCustomAlert(title: "", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                    }
                }
            }
        }
        
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    var aryCards = [[String:AnyObject]]()
    
    func webserviceOfCardList() {
        
        webserviceForCardList(SingletonClass.sharedInstance.strPassengerID as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
                
                if let res = result as? [String:AnyObject] {
                    if let cards = res["cards"] as? [[String:AnyObject]] {
                        self.aryCards = cards
                    }
                }
                
                var dict = [String:AnyObject]()
                dict["CardNum"] = "cash" as AnyObject
                dict["CardNum2"] = "cash" as AnyObject
                dict["Type"] = "iconCashBlack" as AnyObject
                
                var dict2 = [String:AnyObject]()
                dict2["CardNum"] = "wallet" as AnyObject
                dict2["CardNum2"] = "wallet" as AnyObject
                dict2["Type"] = "iconWalletBlack" as AnyObject
                
                
                self.aryCards.append(dict)
                self.aryCards.append(dict2)
                
                if self.aryCards.count == 2 {
                    var dict3 = [String:AnyObject]()
                    dict3["Id"] = "000" as AnyObject
                    dict3["CardNum"] = "Add a Card" as AnyObject
                    dict3["CardNum2"] = "Add a Card" as AnyObject
                    dict3["Type"] = "iconPlusBlack" as AnyObject
                    self.aryCards.append(dict3)
                    
                }
                
                self.pickerView.selectedRow(inComponent: 0)
                let data = self.aryCards[0]
                
                self.imgPaymentOption.image = UIImage(named: self.setCardIcon(str: data["Type"] as! String))
                self.txtSelectPaymentMethod.text = data["CardNum2"] as? String
                
                let type = data["CardNum"] as! String
                
                if type  == "wallet" {
                    self.paymentType = "wallet"
                }
                else if type == "cash" {
                    self.paymentType = "cash"
                }
                else {
                    self.paymentType = "card"
                }
                if self.paymentType == "card" {
                    
                    if data["Id"] as? String != "" {
                        self.CardID = data["Id"] as! String
                    }
                }
                self.pickerView.reloadAllComponents()
              
                /*
                 {
                     cards =     (
                     {
                         Alias = visa;
                         CardNum = 4639251002213023;
                         CardNum2 = "xxxx xxxx xxxx 3023";
                         Id = 59;
                         Type = visa;
                     }
                     );
                     status = 1;
                 }
                 */


            }
            else {
                print(result)
                if let res = result as? String {
                    UtilityClass.setCustomAlert(title: "", message: res) { (index, title) in
                    }
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.setCustomAlert(title: "", message: resDict.object(forKey: "message") as! String) { (index, title) in
                    }
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.setCustomAlert(title: "", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                    }
                }
            }
        }
    }
    
    func webserviceOfParcelAndLabour() {
        
        let param = [String:AnyObject]()
        
        webserviceForParcelAndLabour(param as AnyObject) { (result, status) in

            if (status) {
                if let res = result as? [String:Any] {
                    if (res["percel"] as? [[String:Any]]) != nil {
                        
                        let parcel = res["percel"] as? [[String:Any]]
                        if parcel?.count != 0 {
                            self.aryParcelData = parcel!
                        }
                    }
                    
                    if (res["labour"] as? [[String:Any]]) != nil {
                        
                        let labour = res["labour"] as? [[String:Any]]
                        if labour?.count != 0 {
                            self.aryLabour = labour!
                        }
                    }
                }
            }
            else {
                print(result)
                if let res = result as? String {
                    UtilityClass.setCustomAlert(title: "", message: res) { (index, title) in
                    }
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.setCustomAlert(title: "", message: resDict.object(forKey: "message") as! String) { (index, title) in
                    }
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.setCustomAlert(title: "", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                    }
                }
            }
        }
    }
    
    func webserviceOfGetEstimateFareForDeliveryService() {
        
        var param = [String:Any]()
        param["PickupLocation"] = strPickupLocation
        param["DropoffLocation"] = strDropoffLocation
        param["ModelId"] = strModelId
        param["Labour"] = strLabourId
        
        webserviceForGetEstimateFareForDeliveryService(param as AnyObject) { (result, status) in
            
            if (status) {
                
                if let res = result as? [String:Any] {
                    if let estimateFare = res["estimate_fare"] as? [String:Any] {
                        
                        if let totalInt = estimateFare["total"] as? Int {
                            self.lblEstimateFare.text = "\(currencySign) \(totalInt)"
                        }
                        else if let totalString = estimateFare["total"] as? String {
                            self.lblEstimateFare.text = currencySign + " " + totalString
                        }
                    }
                }
            }
            else {
                print(result)
                if let res = result as? String {
                    UtilityClass.setCustomAlert(title: "", message: res) { (index, title) in
                    }
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.setCustomAlert(title: "", message: resDict.object(forKey: "message") as! String) { (index, title) in
                    }
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.setCustomAlert(title: "", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                    }
                }
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

// Delegates to handle events for the location manager.
extension BookLaterviewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
//        print("Location: \(location)")
        
//        self.getPlaceFromLatLong()
     
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: break
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
       
        print("Error: \(error)")
    }
}
