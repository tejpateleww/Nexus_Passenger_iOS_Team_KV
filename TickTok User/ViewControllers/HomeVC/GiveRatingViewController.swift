//
//  GiveRatingViewController.swift
//  TickTok User
//
//  Created by Excelent iMac on 23/12/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class GiveRatingViewController: UIViewController, FloatRatingViewDelegate {

    
    var ProfileData = NSDictionary()
    
   
    
    var ratingToDriver = Float()
    var commentToDriver = String()
    var strBookingType = String()
//    var delegate: CompleterTripInfoDelegate!
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        giveRating.delegate = self
        
        ProfileData = SingletonClass.sharedInstance.dictDriverProfile
//        ProfileData.object(forKey: "Fullname") as? String

        lblMessageToShow.text = "How was your experience with \(ProfileData.object(forKey: "Fullname")!)"
        
        viewSubFinalRating.layer.cornerRadius = 5
        viewSubFinalRating.layer.masksToBounds = true
        
//        btnSubmit.layer.cornerRadius = 5
//        btnSubmit.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var viewMainFinalRating: UIView!
    @IBOutlet weak var viewSubFinalRating: UIView!
    @IBOutlet weak var txtFeedbackFinal: UITextField!
    
    @IBOutlet weak var giveRating: FloatRatingView!
    @IBOutlet weak var btnSubmit: UIButton!
    
    @IBOutlet weak var lblMessageToShow: UILabel!
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        
        giveRating.rating = rating
        ratingToDriver = giveRating.rating
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    @IBAction func btnSubmitFinalRating(_ sender: UIButton) {
        
        webserviceOfRating()
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    func webserviceOfRating() {
        //        BookingId,Rating,Comment,BookingType(BookNow,BookLater)
        
        var param = [String:AnyObject]()
        param["BookingId"] = SingletonClass.sharedInstance.bookingId as AnyObject
        param["Rating"] = ratingToDriver as AnyObject
        param["Comment"] = txtFeedbackFinal.text as AnyObject
        param["BookingType"] = strBookingType as AnyObject
        
        webserviceForRatingAndComment(param as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
                
                self.txtFeedbackFinal.text = ""
                self.ratingToDriver = 0
                
                //                self.completeTripInfo()
                
//                self.delegate.didRatingCompleted()
                
                
                NotificationCenter.default.removeObserver("CallToRating")
                
                self.dismiss(animated: true, completion: nil)
                
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
            
            SingletonClass.sharedInstance.bookingId = ""
            NotificationCenter.default.post(name: NotificationForAddNewBooingOnSideMenu, object: nil)
        }
    }
    
    

}
