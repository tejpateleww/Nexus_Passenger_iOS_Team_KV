//
//  UtilityClass.swift
//  TickTok User
//
//  Created by Excellent Webworld on 27/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire

typealias CompletionHandler = (_ success:Bool) -> Void

class UtilityClass: NSObject, alertViewMethodsDelegates {
    
    var delegateOfAlert : alertViewMethodsDelegates!

    class func showAlert(_ title: String, message: String, vc: UIViewController) -> Void
    {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "OK",
                                         style: .cancel, handler: nil)
        
        
        
        alert.addAction(cancelAction)
        
        if((UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.presentedViewController != nil)
        {
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.dismiss(animated: true, completion: {
//                vc.present(alert, animated: true, completion: nil)
                (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
            })
        }
        else {
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
        
        
        //vc will be the view controller on which you will present your alert as you cannot use self because this method is static.
        
    }
    
    class func showAlertWithCompletion(_ title: String, message: String, vc: UIViewController,completionHandler: @escaping CompletionHandler) -> Void
    {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            completionHandler(true)
        }))
        
        if((UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.presentedViewController != nil)
        {
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.dismiss(animated: true, completion: {
                //                vc.present(alert, animated: true, completion: nil)
                (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
            })
        }
        else {
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
        }

    }
    class func setCornerRadiusTextField(textField : UITextField, borderColor : UIColor , bgColor : UIColor, textColor : UIColor)
    {
        textField.layer.cornerRadius = textField.frame.size.height / 2
        textField.backgroundColor = bgColor
        textField.layer.borderColor = borderColor.cgColor
        textField.layer.borderWidth = 1.0
        textField.textColor = textColor
        textField.clipsToBounds = true
    }
    
    class func setCornerRadiusButton(button : UIButton , borderColor : UIColor , bgColor : UIColor, textColor : UIColor)
    {
        button.layer.cornerRadius = button.frame.size.height / 2
        button.clipsToBounds = true
        button.backgroundColor = bgColor
        button.setTitleColor(textColor, for: .normal)
        button.layer.borderColor = borderColor.cgColor
        button.layer.borderWidth = 1.0
    }
    
    class func setCornerRadiusView(view: UIView, borderColor: UIColor, bgColor: UIColor) {
        view.layer.cornerRadius = view.frame.size.height / 2
        view.clipsToBounds = true
        view.backgroundColor = bgColor
        view.layer.borderColor = borderColor.cgColor
        view.layer.borderWidth = 1.0
    }
    
    class func CustomAlertViewMethod(_ title: String, message: String, vc: UIViewController, completionHandler: @escaping CompletionHandler) -> Void {
        
        let next = vc.storyboard?.instantiateViewController(withIdentifier: "CustomAlertsViewController") as! CustomAlertsViewController
        
//        next.delegateOfAlertView = vc as! alertViewMethodsDelegates
        next.strTitle = title
        next.strMessage = message
        
        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(next, animated: false, completion: nil)
        
    }
    
    typealias alertCompletionBlockAJ = ((Int, String) -> Void)?
    
    class func setCustomAlert(title: String, message: String,completionHandler: alertCompletionBlockAJ) -> Void {
       
        AJAlertController.initialization().showAlertWithOkButton(aStrTitle: title, aStrMessage: message) { (index,title) in
            
            if index == 0 {
                completionHandler!(0,title)
                
            }
            else if index == 2 {
                completionHandler!(2,title)
                
            }
            
        }
        
    }
    
    
//    convenience init(title: String, message: String, buttons buttonArray: [Any], completion block: @escaping (_ buttonIndex: Int) -> Void) {
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        for buttonTitle: String in buttonArray {
//            let action = UIAlertAction(title: buttonTitle, style: .default, handler: {(_ action: UIAlertAction) -> Void in
//                let index: Int = (buttonArray as NSArray).index(of: action.title ?? "")
//                block(index)
//            })
//            alertController.addAction(action)
//        }
//        self.topMostController().present(alertController, animated: true) {() -> Void in }
//    }
    
    class func showHUD()
    {
        let activityData = ActivityData()
        
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
    }
    
    class func hideHUD()
    {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()

    }
    class func showACProgressHUD() {
        
//        let progressView = ACProgressHUD.shared
//        /*
//         ACProgressHUD.shared.configureStyle(withProgressText: "", progressTextColor: .black, progressTextFont: <#T##UIFont#>, shadowColor: UIColor.black, shadowRadius: 3, cornerRadius: 5, indicatorColor: UIColor.init(red: 204/255, green: 3/255, blue: 0, alpha: 1.0), hudBackgroundColor: .white, enableBackground: false, backgroundColor: UIColor.black, backgroundColorAlpha: 0.3, enableBlurBackground: false, showHudAnimation: .growIn, dismissHudAnimation: .growOut)
//         */
//        progressView.progressText = ""
//
//        progressView.hudBackgroundColor = .black
//
//        progressView.indicatorColor = ThemeBlueColor
//        //        progressView.shadowRadius = 0.5
//
//
//        progressView.showHUD()
        
        let activityData = ActivityData()
        NVActivityIndicatorView.DEFAULT_BLOCKER_MINIMUM_DISPLAY_TIME = 55
        NVActivityIndicatorView.DEFAULT_BLOCKER_DISPLAY_TIME_THRESHOLD = 55
        NVActivityIndicatorView.DEFAULT_TYPE = .ballClipRotate//binal
        NVActivityIndicatorView.DEFAULT_COLOR = ThemeBlueColor
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        
    }
    
    class func hideACProgressHUD() {
        
//        ACProgressHUD.shared.hideHUD()
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()

    }

}

extension UILabel {
    func underlineToLabel() {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedStringKey.underlineStyle,
                                          value: NSUnderlineStyle.styleSingle.rawValue,
                                          range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
    }
}


//-------------------------------------------------------------
// MARK: - Internet Connection Check Methods
//-------------------------------------------------------------

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}


extension UIViewController {
    
    func checkDictionaryHaveValue(dictData: [String:AnyObject], didHaveValue paramString: String, isNotHave: String) -> String {
        
        var currentData = dictData
        
        if currentData[paramString] == nil {
            return isNotHave
        }
        
        if ((currentData[paramString] as? String) != nil) {
            if String(currentData[paramString] as! String) == "" {
                return isNotHave
            }
            return String(currentData[paramString] as! String)
            
        } else if ((currentData[paramString] as? Int) != nil) {
            if String(currentData[paramString] as! Int) == "" {
                return isNotHave
            }
            return String((currentData[paramString] as! Int))
            
        } else if ((currentData[paramString] as? Double) != nil) {
            if String(currentData[paramString] as! Double) == "" {
                return isNotHave
            }
            return String(currentData[paramString] as! Double)
            
        } else if ((currentData[paramString] as? Float) != nil){
            if String(currentData[paramString] as! Float) == "" {
                return isNotHave
            }
            return String(currentData[paramString] as! Float)
        }
        else {
            return isNotHave
        }
    }
    

    /// Convert Seconds to Hours, Minutes and Seconds
    func ConvertSecondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}
