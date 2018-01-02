//
//  MyBookingViewController.swift
//  TickTok User
//
//  Created by Excellent Webworld on 09/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
//import NVActivityIndicatorView

class MyBookingViewController: UIViewController, UIScrollViewDelegate {

    
    var aryHistory = NSArray()
    
    let bottomBorderOnGoing = CALayer()
    let bottomBorderUpComming = CALayer()
    let bottomBorderPastBooking = CALayer()
    
    var heightOfLayer = CGFloat()
    var heighMinusFromY = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        heightOfLayer = 2.0
        heighMinusFromY = 2.0
        
        webserviceOfBookingHistory()
        
        scrollObject.isUserInteractionEnabled = true
        
        scrollObject.delegate = self
        scrollObject.layoutIfNeeded()
        scrollObject.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
       PastBooking()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var lblOnGoing: UIButton!
    @IBOutlet weak var btnUpComming: UIButton!
    @IBOutlet weak var btnPastBooking: UIButton!
    
    @IBOutlet weak var scrollObject: UIScrollView!
    
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func lblOnGoing(_ sender: UIButton) {
        OnGoing()
        
    }
    
    @IBAction func btnUpComming(_ sender: UIButton) {
        Upcomming()
       
    }

    func OnGoing() {
        

        bottomBorderOnGoing.frame = CGRect(x: 0.0, y: lblOnGoing.frame.size.height - heighMinusFromY, width: lblOnGoing.frame.size.width, height: heightOfLayer)
        bottomBorderOnGoing.backgroundColor = UIColor.init(red: 204/255, green: 4/255, blue: 0, alpha: 1.0).cgColor
        lblOnGoing.layer.addSublayer(bottomBorderOnGoing)
        
        
        bottomBorderUpComming.removeFromSuperlayer()
        bottomBorderPastBooking.removeFromSuperlayer()
        
        
        scrollObject.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func Upcomming() {
        
       
        bottomBorderUpComming.frame = CGRect(x: 0.0, y: btnUpComming.frame.size.height - heighMinusFromY, width: btnUpComming.frame.size.width, height: heightOfLayer)
        bottomBorderUpComming.backgroundColor = UIColor.init(red: 204/255, green: 4/255, blue: 0, alpha: 1.0).cgColor
        btnUpComming.layer.addSublayer(bottomBorderUpComming)
        
        
        bottomBorderOnGoing.removeFromSuperlayer()
        bottomBorderPastBooking.removeFromSuperlayer()
        
        
        
        
//        lblOnGoing.backgroundColor = UIColor.white
////        btnUpComming.backgroundColor = UIColor.init(red: 204/255, green: 4/255, blue: 0, alpha: 1.0)
//        btnPastBooking.backgroundColor = UIColor.white
//
//        lblOnGoing.setTitleColor(UIColor.black, for: .normal)
//        btnUpComming.setTitleColor(UIColor.black, for: .normal)
//        btnPastBooking.setTitleColor(UIColor.black, for: .normal)
        
        scrollObject.setContentOffset(CGPoint(x: self.view.frame.size.width, y: 0), animated: true)
    }
    
    func PastBooking() {
        
        
        bottomBorderPastBooking.frame = CGRect(x: 0.0, y: btnPastBooking.frame.size.height - heighMinusFromY, width: btnPastBooking.frame.size.width, height: heightOfLayer)
        bottomBorderPastBooking.backgroundColor = UIColor.init(red: 204/255, green: 4/255, blue: 0, alpha: 1.0).cgColor
        btnPastBooking.layer.addSublayer(bottomBorderPastBooking)
        
        
        bottomBorderUpComming.removeFromSuperlayer()
        bottomBorderOnGoing.removeFromSuperlayer()
        
        
//        lblOnGoing.backgroundColor = UIColor.white
//        btnUpComming.backgroundColor = UIColor.white
////        btnPastBooking.backgroundColor = UIColor.init(red: 204/255, green: 4/255, blue: 0, alpha: 1.0)
//
//        lblOnGoing.setTitleColor(UIColor.black, for: .normal)
//        btnUpComming.setTitleColor(UIColor.black, for: .normal)
//        btnPastBooking.setTitleColor(UIColor.black, for: .normal)
        
        scrollObject.setContentOffset(CGPoint(x: self.view.frame.size.width * 2, y: 0), animated: true)
    }
    
    @IBAction func btnPastBooking(_ sender: UIButton) {
       
        PastBooking()
        
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
//        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
//
        webserviceForBookingHistory(SingletonClass.sharedInstance.strPassengerID as AnyObject) { (result, status) in
            
            if (status) {
                
                self.aryHistory = (result as! NSDictionary).object(forKey: "history") as! NSArray
                
                print(self.aryHistory)
                
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
                SingletonClass.sharedInstance.aryPastBooking = aryUpComming as NSArray
                // Post notification
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationCenterName.keyForPastBooking), object: nil)
                // ------------------------------------------------------------
                
//                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            }
            else {
                
                print(result)
            }
        }
    }
    
    
    
    
    // ------------------------------------------------------------
    
    
    

}
