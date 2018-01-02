//
//  BarsAndClubsViewController.swift
//  TickTok User
//
//  Created by Excelent iMac on 13/12/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import SDWebImage
import CoreLocation

class BarsAndClubsViewController: ParentViewController, UITableViewDataSource, UITableViewDelegate {

    
    
    var latitude = Double()
    var longitude = Double()
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        let coordinate₀ = CLLocation(latitude: Double(SingletonClass.sharedInstance.currentLatitude)!, longitude: Double(SingletonClass.sharedInstance.currentLongitude)!)
        let coordinate₁ = CLLocation(latitude: 5.0, longitude: 3.0)
        
        let distanceInMeters = coordinate₀.distance(from: coordinate₁) // result is in meters
        
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        webserviceOfBarAndClubs()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //-------------------------------------------------------------
    // MARK: - TableView Methods
    //-------------------------------------------------------------
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryBarsAndClubs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let params = aryBarsAndClubs[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BarsAndClubsTableViewCell") as! BarsAndClubsTableViewCell
        cell.selectionStyle = .none
        
        if let imgUrl = params["icon"] as? String {
            cell.imgItems.sd_setShowActivityIndicatorView(true)
            cell.imgItems.sd_setIndicatorStyle(.gray)
            cell.imgItems.sd_setImage(with: URL(string: imgUrl), completed: nil)
            
        }
        
        if let geometry = params["geometry"] as? NSDictionary {
        
            if let locat = geometry.object(forKey: "location") as? NSDictionary {
                if let lati = locat.object(forKey: "lat") as? Double {
                    self.latitude = lati
                }
                if let longi = locat.object(forKey: "lng") as? Double {
                    self.longitude = longi
                }
            }
            
            let coordinate₀ = CLLocation(latitude: Double(SingletonClass.sharedInstance.currentLatitude)!, longitude: Double(SingletonClass.sharedInstance.currentLongitude)!)
            let coordinate₁ = CLLocation(latitude: self.latitude, longitude: self.longitude)
            
            let distanceInMeters = coordinate₀.distance(from: coordinate₁) // result is in meters
            
            if distanceInMeters >= 1000 {
                
                let km = (distanceInMeters / 1000)
                
                cell.lblDistanceKM.text = "\(km.rounded(toPlaces: 2)) KM"
            }
            else {
                cell.lblDistanceKM.text = "\(distanceInMeters.rounded(toPlaces: 2)) M"
            }
            
        }
        
        if let rating = params["rating"] as? Float {
            cell.ratingView.rating = rating
        }
        else {
            cell.ratingView.rating = 0.0
        }
        
        
        cell.itemTitle.text = params["name"] as? String
        cell.lblAddress.text = params["vicinity"] as? String
        
        
        
//        cell.lblDistanceKM.text =
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let BookCarNow = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Book Car Now") { (action , indexPath ) -> Void in
            
            self.isEditing = false
            print("Book Car Now")
        }
        
        
        let BookCarLater = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Book Car Later") { (action , indexPath) -> Void in
            self.isEditing = false
            print("Book Car Later")
        }
        
        BookCarLater.backgroundColor = UIColor.black
        return [BookCarLater,BookCarNow]
    }

    
    var aryBarsAndClubs = [[String:AnyObject]]()
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    func webserviceOfBarAndClubs() {
        
//        let urlOFbarAndClubs = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=23.072664,72.516199&radius=5000&type=bar&key=AIzaSyCRaduVCKdm1ll3kHPY-ebtvwwPV2VVozo"
        
       
        if SingletonClass.sharedInstance.currentLatitude == "" || SingletonClass.sharedInstance.currentLongitude == "" {
            UtilityClass.showAlert("", message: "Your Current Location Not Found", vc: self)
        }
        else {
            let creentLocation = "\(SingletonClass.sharedInstance.currentLatitude),\(SingletonClass.sharedInstance.currentLongitude)"
            let type = "bar"
            
            webserviceForBarsAndTaxis("" as AnyObject, Location: creentLocation, Type: type) { (result, status) in
                
                if status {
                    print(result)
                    let dataOfNews = (result as! [String:AnyObject])
                    
                    self.aryBarsAndClubs = dataOfNews["results"] as! [[String:AnyObject]]
                    
                    self.tableView.reloadData()
                }
                else {
                    print(result)
                }
            }
        }
        
    }
    
    
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

