//
//  MyBookingViewController.swift
//  TickTok User
//
//  Created by Excellent Webworld on 09/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
//import NVActivityIndicatorView

class MyBookingViewController: BaseViewController, UIScrollViewDelegate, GiveTipAlertDelegate,UIPickerViewDelegate, UIPickerViewDataSource,addCardFromHomeVCDelegate {

    
    var aryHistory = NSArray()
    
    let bottomBorderOnGoing = CALayer()
    let bottomBorderUpComming = CALayer()
    let bottomBorderPastBooking = CALayer()
    
    var heightOfLayer = CGFloat()
    var heighMinusFromY = CGFloat()
    
    var isFromPushNotification = Bool()
    var bookingType = String()
    
    var selectedBackgroundColor = ThemeNaviBlueColor
//        UIColor.black
    var unselectedBackgroundColor = UIColor.clear
//        UIColor.init(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0)
    
    
    
    var selectedTextColor = UIColor.white
//    ThemeNaviBlueColor //UIColor.init(red: 48/255, green: 48/255, blue: 48/255, alpha: 1.0)
    var unselectedTextColor = UIColor.black
//        UIColor.init(red: 167/255, green: 167/255, blue: 167/255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.TipParentView.isHidden = true
        heightOfLayer = 2.0
        heighMinusFromY = 2.0
        
        self.setNavBarWithBack(Title: "My Bookings".localized, IsNeedRightButton: false)

        webserviceOfBookingHistory()
        scrollObject.isUserInteractionEnabled = true
        scrollObject.delegate = self
        scrollObject.layoutIfNeeded()
        scrollObject.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
        if (isFromPushNotification) {
            
            if bookingType == "accept" {
                Upcomming()
            }
            else if bookingType == "reject" {
                PastBooking()
            }
            
        }
        else {
            PastBooking()
        }
        
        if let PastbookingScreen = self.childViewControllers[2] as? PastBookingVC {
            PastbookingScreen.DelegateForTip = self
        }
        
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var lbltitile: UILabel!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         setLocalization()
         
    }
    func setLocalization()
    {
        lbltitile.text = "My Bookings".localized
        btnOnGoing.setTitle("OnGoing".localized, for: .normal)
        btnUpComming.setTitle("UpComing".localized, for: .normal)
        btnPastBooking.setTitle("Past Booking".localized, for: .normal)
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var btnOnGoing: UIButton!
    @IBOutlet weak var btnUpComming: UIButton!
    @IBOutlet weak var btnPastBooking: UIButton!
    
    @IBOutlet weak var scrollObject: UIScrollView!
    
    
    @IBOutlet weak var TipParentView: UIView!
    
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    @IBAction func btnBack(_ sender: UIButton) {
      
        if isModal() {
            self.dismiss(animated: true, completion: {
            })
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    @IBOutlet weak var btnCall: UIButton!
    @IBAction func btCallClicked(_ sender: UIButton)
    {
        let contactNumber = helpLineNumber
        if contactNumber == "" {
            UtilityClass.setCustomAlert(title: "\(appName)", message: "Contact number is not available") { (index, title) in
            }
        }
        else
        {
            callNumber(phoneNumber: contactNumber)
        }
    }
    
    private func callNumber(phoneNumber:String) {
        
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func lblOnGoing(_ sender: UIButton) {
        OnGoing()
        
    }
    
    @IBAction func btnUpComming(_ sender: UIButton) {
        Upcomming()
       
    }
    
    func isModal() -> Bool {
        if (presentingViewController != nil) {
            return true
        }
        if navigationController?.presentingViewController?.presentedViewController == navigationController {
            return true
        }
        if (tabBarController?.presentingViewController is UITabBarController) {
            return true
        }
        return false
    }

    func OnGoing() {
        

//        bottomBorderOnGoing.frame = CGRect(x: 0.0, y: lblOnGoing.frame.size.height - heighMinusFromY, width: lblOnGoing.frame.size.width, height: heightOfLayer)
//        bottomBorderOnGoing.backgroundColor = UIColor.init(red: 255/255, green: 163/255, blue: 0, alpha: 1.0).cgColor
//        lblOnGoing.layer.addSublayer(bottomBorderOnGoing)
        //        bottomBorderUpComming.removeFromSuperlayer()
        //        bottomBorderPastBooking.removeFromSuperlayer()
        
        
        btnUpComming.backgroundColor = unselectedBackgroundColor
        btnPastBooking.backgroundColor = unselectedBackgroundColor
        btnUpComming.setTitleColor(unselectedTextColor, for: .normal)
        btnPastBooking.setTitleColor(unselectedTextColor, for: .normal)
        
        btnOnGoing.backgroundColor = selectedBackgroundColor
        btnOnGoing.setTitleColor(selectedTextColor, for: .normal)
        
        scrollObject.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func Upcomming() {
       
        
        btnUpComming.backgroundColor = selectedBackgroundColor
        btnPastBooking.backgroundColor = unselectedBackgroundColor
        btnOnGoing.backgroundColor = unselectedBackgroundColor
        
        btnUpComming.setTitleColor(selectedTextColor, for: .normal)
        btnOnGoing.setTitleColor(unselectedTextColor, for: .normal)
        btnPastBooking.setTitleColor(unselectedTextColor, for: .normal)
       
//        bottomBorderUpComming.frame = CGRect(x: 0.0, y: btnUpComming.frame.size.height - heighMinusFromY, width: btnUpComming.frame.size.width, height: heightOfLayer)
//        bottomBorderUpComming.backgroundColor = UIColor.init(red: 255/255, green: 163/255, blue: 0, alpha: 1.0).cgColor
//        btnUpComming.layer.addSublayer(bottomBorderUpComming)
//
//
//        bottomBorderOnGoing.removeFromSuperlayer()
//        bottomBorderPastBooking.removeFromSuperlayer()
        
        
        
        
//        lblOnGoing.backgroundColor = UIColor.white
////        btnUpComming.backgroundColor = UIColor.init(red: 255/255, green: 163/255, blue: 0, alpha: 1.0)
//        btnPastBooking.backgroundColor = UIColor.white
//
//        lblOnGoing.setTitleColor(UIColor.black, for: .normal)
//        btnUpComming.setTitleColor(UIColor.black, for: .normal)
//        btnPastBooking.setTitleColor(UIColor.black, for: .normal)
        
      
        scrollObject.setContentOffset(CGPoint(x: self.view.frame.size.width, y: 0), animated: true)
    }
    
    func PastBooking() {
        
        
//        bottomBorderPastBooking.frame = CGRect(x: 0.0, y: btnPastBooking.frame.size.height - heighMinusFromY, width: btnPastBooking.frame.size.width, height: heightOfLayer)
//        bottomBorderPastBooking.backgroundColor = UIColor.init(red: 255/255, green: 163/255, blue: 0, alpha: 1.0).cgColor
//        btnPastBooking.layer.addSublayer(bottomBorderPastBooking)
//
//
//        bottomBorderUpComming.removeFromSuperlayer()
//        bottomBorderOnGoing.removeFromSuperlayer()
        
        
//        lblOnGoing.backgroundColor = UIColor.white
//        btnUpComming.backgroundColor = UIColor.white
////        btnPastBooking.backgroundColor = UIColor.init(red: 255/255, green: 163/255, blue: 0, alpha: 1.0)
//
//        lblOnGoing.setTitleColor(UIColor.black, for: .normal)
//        btnUpComming.setTitleColor(UIColor.black, for: .normal)
//        btnPastBooking.setTitleColor(UIColor.black, for: .normal)
        
        btnUpComming.backgroundColor = unselectedBackgroundColor
        btnPastBooking.backgroundColor = selectedBackgroundColor
        btnOnGoing.backgroundColor = unselectedBackgroundColor
        
        btnUpComming.setTitleColor(unselectedTextColor, for: .normal)
        btnOnGoing.setTitleColor(unselectedTextColor, for: .normal)
        btnPastBooking.setTitleColor(selectedTextColor, for: .normal)

        
        scrollObject.setContentOffset(CGPoint(x: self.view.frame.size.width * 2, y: 0), animated: true)
    }
    
    @IBAction func btnPastBooking(_ sender: UIButton) {
       
        PastBooking()
        
    }
    
    //-------------------------------------------------------------
    // MARK: - DidTipAlert Open Delegate Methods
    //-------------------------------------------------------------
    
    func didOpenTipViewController(BookingId: String, BookingType: String) {
        self.TipbookingType = BookingType
        self.Tipbookingid = BookingId
        self.txtEntertip.text = ""
        self.PaymentOption()
        UIView.transition(with: TipParentView, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
            self.TipParentView.isHidden = false
        }) { _ in }
       
        
        /*
        let TipAlertAfterBooking = self.storyboard?.instantiateViewController(withIdentifier: "TipViewController") as! TipViewController
        TipAlertAfterBooking.bookingid = BookingId
        TipAlertAfterBooking.bookingType = BookingType
        let navigationPage = UINavigationController(rootViewController: TipAlertAfterBooking)
        navigationPage.isNavigationBarHidden = true
        navigationPage.modalTransitionStyle = .crossDissolve
        navigationPage.modalPresentationStyle = .overCurrentContext
        self.present(navigationPage, animated: true, completion: nil)
        */
    }
    
    
    
    //-------------------------------------------------------------
    // MARK: - Scroll Methods
    //-------------------------------------------------------------
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let pageNo = CGFloat(scrollView.contentOffset.x / scrollView.frame.size.width)
        //        segmentController.selectItemAt(index: Int(pageNo), animated: true)
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
//        let currentPage = scrollView.contentOffset.x / scrollView.frame.size.width
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    func webserviceOfBookingHistory()
    {
//        let activityData = ActivityData()
//        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData,nil)
//
        webserviceForBookingHistory(SingletonClass.sharedInstance.strPassengerID as AnyObject) { (result, status) in
            
            if (status) {
                
                self.aryHistory = (result as! NSDictionary).object(forKey: "history") as! NSArray
                
//                print(self.aryHistory)
                
                SingletonClass.sharedInstance.aryHistory = self.aryHistory
                
                // ------------------------------------------------------------
                // OnGoing
                var aryOnGoing = [NSDictionary]()
                for i in 0..<self.aryHistory.count
                {
                    if (self.aryHistory.object(at: i) as! NSDictionary).object(forKey: "HistoryType") as? String == "onGoing" {
                      
                        aryOnGoing.append((self.aryHistory.object(at: i) as! NSDictionary))
                    }
                }
                SingletonClass.sharedInstance.aryOnGoing = aryOnGoing as NSArray
                // Post notification
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationCenterName.keyForOnGoing), object: nil)
                // ------------------------------------------------------------
                
                // UpComming
                var aryUpComming = [NSDictionary]()
                for i in 0..<self.aryHistory.count
                {
                    if (self.aryHistory.object(at: i) as! NSDictionary).object(forKey: "HistoryType") as? String == "Upcoming" {
                        
                        aryUpComming.append((self.aryHistory.object(at: i) as! NSDictionary))
                    }
                }
                SingletonClass.sharedInstance.aryUpComming = aryUpComming as NSArray
                // Post notification
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationCenterName.keyForUpComming), object: nil)
                // ------------------------------------------------------------
            
                // UpComming
                var aryPastBooking = [NSDictionary]()
                for i in 0..<self.aryHistory.count
                {
                    if (self.aryHistory.object(at: i) as! NSDictionary).object(forKey: "HistoryType") as? String == "Past" {
                        
                        aryPastBooking.append((self.aryHistory.object(at: i) as! NSDictionary))
                    }
                }
                SingletonClass.sharedInstance.aryPastBooking = aryPastBooking as NSArray
                // Post notification
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationCenterName.keyForPastBooking), object: nil)
                // ------------------------------------------------------------
                
//                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            }
            else {
                
                print(result)
            }
        }
    }

    
    //-------------------------------------------------------------
    // MARK: - TipView Handle Methods
    //-------------------------------------------------------------
    
    @IBOutlet weak var viewSelectPaymentOption: UIView!
    @IBOutlet weak var txtSelectPaymentOption: UITextField!
    @IBOutlet weak var imgPaymentType: UIImageView!
    
    @IBOutlet weak var txtEntertip: UITextField!
    
    @IBOutlet weak var btnSubmit: ThemeButton!
    
    var pickerView = UIPickerView()
    var paymentType:String = ""
    var cardData = [[String:AnyObject]]()
    var CardID:String = ""
    var Tipbookingid:String = ""
    var TipbookingType:String = ""
    
    func PaymentOption() {
        self.btnSubmit.setTitle("Submit", for: .normal)
        self.txtSelectPaymentOption.placeholder = "Select Card"
        self.imgPaymentType.image = UIImage(named: "iconDummyCard")
        if SingletonClass.sharedInstance.CardsVCHaveAryData.count != 0 {
            
            cardData = SingletonClass.sharedInstance.CardsVCHaveAryData
            self.pickerView.reloadAllComponents()
            
            let data = cardData[0]
            
            imgPaymentType.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
            txtSelectPaymentOption.text = data["CardNum2"] as? String
            paymentType = "card"
            
            if paymentType == "card" {
                CardID = data["Id"] as! String
            }
        }
    }
    
    
    @IBAction func txtPaymentOption(_ sender: UITextField) {
        if SingletonClass.sharedInstance.CardsVCHaveAryData.count != 0 {
            
            pickerView.delegate = self
            pickerView.dataSource = self
            txtSelectPaymentOption.inputView = pickerView
        } else {
            self.view.endEditing(true)
            let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
//            self.navigationController?.isNavigationBarHidden = false
            next.delegateAddCardFromHomeVC = self
            next.isCameforTips = true
            self.navigationController?.pushViewController(next, animated: true)
        }
    }
    
    //-------------------------------------------------------------
    // MARK: - IBAction Methods
    //-------------------------------------------------------------
    @IBAction func btnSubmitAction(_ sender: Any) {
        self.view.endEditing(true)
       let Validator = self.isValidate()
        if Validator.1 == true {
            self.webserviceOfSendTip()
        } else {
             UtilityClass.showAlert("", message: Validator.0, vc: self)
        }
        
    }
    
    func isValidate() -> (String,Bool) {
        
        var isValid:Bool = true
        var ValidatorMessage:String = ""
        
        if self.txtEntertip.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" {
            isValid = false
            ValidatorMessage = "Please enter tip."
        } else if self.txtSelectPaymentOption.text == "" {
            isValid = false
            ValidatorMessage = "Please select Card."
        }
        return (ValidatorMessage,isValid)
    }
    
    @IBAction func btnCloseAction(_ sender: Any) {
        UIView.transition(with: TipParentView, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
            self.TipParentView.isHidden = true
        }) { _ in }
        
    }
    
    
    func webserviceOfSendTip() {
        // PassengerId,CardNo,Cvv,Expiry,Alias (CarNo : 4444555511115555,Expiry:09/20)
        var dictData = [String:AnyObject]()
        
        dictData["BookingId"] = self.Tipbookingid as AnyObject
        dictData["BookingType"] = self.TipbookingType as AnyObject
        dictData["Amount"] = txtEntertip.text!.trimmingCharacters(in: .whitespacesAndNewlines) as AnyObject
        dictData["CardId"] = self.CardID as AnyObject
        
        webserviceToSendTip(dictData as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
                
                UtilityClass.setCustomAlert(title: "", message: ((result as! NSDictionary).object(forKey: "message") as? String)!) { (index, title) in
                    UIView.transition(with: self.TipParentView, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
                        self.TipParentView.isHidden = true
                    }) { _ in
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationCenterName.keyForPastBooking), object: nil)
                    }
                }
            }
            else {
                print(result)
                
                if let res = result as? String {
                    UtilityClass.setCustomAlert(title: "Error", message: res) { (index, title) in
                    }
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.setCustomAlert(title: "Error", message: resDict.object(forKey: "message") as! String) { (index, title) in
                    }
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.setCustomAlert(title: "Error", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                    }
                }
                
            }
        }
        
    }
    
    func didAddCardFromHomeVC() {
        
        if SingletonClass.sharedInstance.CardsVCHaveAryData.count != 0 {
            
            cardData = SingletonClass.sharedInstance.CardsVCHaveAryData
            self.pickerView.reloadAllComponents()
            
            let data = cardData[0]
            
            imgPaymentType.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
            txtSelectPaymentOption.text = data["CardNum2"] as? String
            paymentType = "card"
            
            if paymentType == "card" {
                CardID = data["Id"] as! String
            }
        }
    }
    
    //-------------------------------------------------------------
    // MARK: - PickerView Methods
    //-------------------------------------------------------------
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return cardData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        
        return 60
    }
    
    //    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    //
    //    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let data = cardData[row]
        
        let myView = UIView(frame: CGRect(x:0, y:0, width: pickerView.bounds.width - 30, height: 60))
        
        let myImageView = UIImageView(frame: CGRect(x:0, y:0, width:50, height:50))
        
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let data = cardData[row]
        
        imgPaymentType.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        txtSelectPaymentOption.text = data["CardNum2"] as? String
        
        paymentType = "card"
        
        if paymentType == "card" {
            CardID = data["Id"] as! String
        }
        
        
        // do something with selected row
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
        case "other":
            CardIcon = "iconDummyCard"
            return CardIcon
        default:
            return ""
        }
        
    }
}
