//
//  UtilityClass.swift
//  TickTok User
//
//  Created by Excellent Webworld on 27/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import NVActivityIndicatorView


typealias CompletionHandler = (_ success:Bool) -> Void

class UtilityClass: NSObject {

    class func showAlert(_ title: String, message: String, vc: UIViewController) -> Void
    {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "OK",
                                         style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        //vc will be the view controller on which you will present your alert as you cannot use self because this method is static.
        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    class func showAlertWithCompletion(_ title: String, message: String, vc: UIViewController,completionHandler: @escaping CompletionHandler) -> Void
    {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            completionHandler(true)
        }))
        //vc will be the view controller on which you will present your alert as you cannot use self because this method is static.
        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)

    }
    
    
//    func showAlert(title: String, message: String, callback: @escaping () -> ()) {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
//            alertAction in
//            callback()
//        }))
//
////        self.present(alert, animated: true, completion: nil)
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
        
        let progressView = ACProgressHUD.shared
        /*
         ACProgressHUD.shared.configureStyle(withProgressText: "", progressTextColor: .black, progressTextFont: <#T##UIFont#>, shadowColor: UIColor.black, shadowRadius: 3, cornerRadius: 5, indicatorColor: UIColor.init(red: 204/255, green: 3/255, blue: 0, alpha: 1.0), hudBackgroundColor: .white, enableBackground: false, backgroundColor: UIColor.black, backgroundColorAlpha: 0.3, enableBlurBackground: false, showHudAnimation: .growIn, dismissHudAnimation: .growOut)
         */
        progressView.progressText = ""
        
        progressView.hudBackgroundColor = .black
        
        progressView.indicatorColor = UIColor.init(red: 204/255, green: 3/255, blue: 0, alpha: 1.0)
        //        progressView.shadowRadius = 0.5
        
        progressView.showHUD()
        
    }
    
    class func hideACProgressHUD() {
        
        ACProgressHUD.shared.hideHUD()
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

