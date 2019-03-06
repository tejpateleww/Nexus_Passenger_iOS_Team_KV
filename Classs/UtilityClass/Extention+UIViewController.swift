//
//  Extention+UIViewController.swift
//  PickNGo User
//
//  Created by Excelent iMac on 30/07/18.
//  Copyright © 2018 Excellent Webworld. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func setNavigationClear() {
        UINavigationBar.appearance().tintColor = UIColor.white
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.clear], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.clear], for: UIControlState.highlighted)
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey .foregroundColor : UIColor.white]
        
    }
    
    func setNavigationFontBlack() {
        UINavigationBar.appearance().tintColor = UIColor.black
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.black], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.black], for: UIControlState.highlighted)
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey .foregroundColor : UIColor.black]
    }
    
/*
    /// Convert Any data to String From Dictionary
    func checkDictionaryHaveValue(dictData: [String:AnyObject], didHaveKey paramString: String, ifHaveNotValue: String) -> String {
        
        var currentData = dictData
        
        if currentData[paramString] == nil {
            return ifHaveNotValue
        }
        
        if ((currentData[paramString] as? String) != nil) {
            if String(currentData[paramString] as! String) == "" {
                return ifHaveNotValue
            }
            return String(currentData[paramString] as! String)
            
        } else if ((currentData[paramString] as? Int) != nil) {
            if String(currentData[paramString] as! Int) == "" {
                return ifHaveNotValue
            }
            return String((currentData[paramString] as! Int))
            
        } else if ((currentData[paramString] as? Double) != nil) {
            if String(currentData[paramString] as! Double) == "" {
                return ifHaveNotValue
            }
            return String(currentData[paramString] as! Double)
            
        } else if ((currentData[paramString] as? Float) != nil){
            if String(currentData[paramString] as! Float) == "" {
                return ifHaveNotValue
            }
            return String(currentData[paramString] as! Float)
        }
        else {
            return ifHaveNotValue
        }
    }
    
*/
    /// Convert Seconds to Hours, Minutes and Seconds
//    func ConvertSecondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
//        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
//    }
}

