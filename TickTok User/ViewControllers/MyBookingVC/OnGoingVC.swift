//
//  OnGoingVC.swift
//  TickTok User
//
//  Created by Excellent Webworld on 09/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import SDWebImage

class OnGoingVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var aryData = NSArray()
    
    var strPickupLat = String()
    var strPickupLng = String()
    
    var strDropoffLat = String()
    var strDropoffLng = String()
    
    var PickupAddress = String()
    var DropoffAddress = String()

    override func viewDidLoad() {
        super.viewDidLoad()
   
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadDataOfTableView), name: NSNotification.Name(rawValue: NotificationCenterName.keyForOnGoing), object: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func reloadDataOfTableView() {
        
        self.aryData = SingletonClass.sharedInstance.aryOnGoing
        self.tableView.reloadData()
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------

    @IBOutlet weak var tableView: UITableView!
    
    
    //-------------------------------------------------------------
    // MARK: - Table View Methods
    //-------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return aryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "OnGoingTableViewCell") as! OnGoingTableViewCell
        
        if aryData.count > 0 {
            
            cell.lblStatus.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "Status") as? String
            cell.lblDriverName.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "DriverName") as? String
            cell.lblPickupAddress.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PickupLocation") as? String
            cell.lblDropoffAddress.text = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "DropoffLocation") as? String
            
           
            
            if ((aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "CarDetails") != nil) {
                
                cell.lblCompanyName.text = ((aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "CarDetails") as! NSDictionary).object(forKey: "Company") as? String
                
                let url = ((aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "CarDetails") as! NSDictionary).object(forKey: "VehicleImage") as! String
                let urlString = "http://54.206.55.185/web/\(url)"
                cell.imgDriver.sd_setImage(with: URL(string: urlString), completed: nil)

            }
        
        }
 
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if aryData.count > 0 {
            
            strPickupLat = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PickupLat") as! String
            strPickupLng = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PickupLng") as! String
            
            strDropoffLat = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "DropOffLat") as! String
            strDropoffLng = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "DropOffLon") as! String
            
            PickupAddress = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "PickupLocation") as! String
            DropoffAddress = (aryData.object(at: indexPath.row) as! NSDictionary).object(forKey: "DropoffLocation") as! String
            
            setMarkersOnMap(PickupLatitude: Double(strPickupLat)!, PickupLongitude: Double(strPickupLng)!, DropoffLatitude: Double(strDropoffLat)!, DropoffLongitude: Double(strDropoffLng)!, PickupLocation: PickupAddress, DropoffLocation: DropoffAddress)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 176
    }
    
    func setMarkersOnMap(PickupLatitude: Double, PickupLongitude: Double, DropoffLatitude: Double, DropoffLongitude: Double, PickupLocation: String, DropoffLocation: String) {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
    
        SingletonClass.sharedInstance.boolIsFromPrevious = true
        
        
        let dictData = NSMutableDictionary()
        
        dictData.setValue(Double(strPickupLat)!, forKey: "PickupLat")
        dictData.setValue(Double(strPickupLng)!, forKey: "PickupLng")
        
        dictData.setValue(Double(strDropoffLat)!, forKey: "DropOffLat")
        dictData.setValue(Double(strDropoffLng)!, forKey: "DropOffLon")
        
        dictData.setValue(PickupAddress, forKey: "PickupLocation")
        dictData.setValue(DropoffAddress, forKey: "DropoffLocation")
        
        
        SingletonClass.sharedInstance.dictIsFromPrevious = dictData
     
        
//        next.zPickupLat = Double(strPickupLat)!
//        next.zPickupLng = Double(strPickupLng)!
//
//        next.zDropoffLat = Double(strDropoffLat)!
//        next.zDropoffLng = Double(strDropoffLng)!
//
//        next.zPickupLocation = PickupAddress
//        next.zDropoffLocation = DropoffAddress
        
//        self.navigationController?.popViewController(animated: true)
//        self.navigationController?.pushViewController(next, animated: true)
        
        self.navigationController?.present(next, animated: true, completion: nil)
    }
    
    
}
