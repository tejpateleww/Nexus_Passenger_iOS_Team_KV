//
//  PackageHistoryViewController.swift
//  PickNGo User
//
//  Created by Excellent WebWorld on 07/03/18.
//  Copyright © 2018 Excellent Webworld. All rights reserved.
//

import UIKit

class PackageHistoryViewController: ParentViewController, UITableViewDataSource, UITableViewDelegate {

    
    var arrPacakge = [[String : AnyObject]]()
    
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var lblNoDataFound: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webserviceOfPackageBookingHistory()
        tblView.rowHeight = UITableViewAutomaticDimension
        tblView.estimatedRowHeight = 320
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func webserviceOfPackageBookingHistory() {
    
        
        webserviceForPackageHistory(SingletonClass.sharedInstance.strPassengerID as AnyObject) { (result, status) in
            if (status)
            {
                print(result)
                self.arrPacakge.removeAll()
                if let res = result as? [String:AnyObject]
                {
                    if let package = res["package"] as? [[String:AnyObject]]
                    {
                        self.arrPacakge = package
                    }

                }
                self.tblView.reloadData()
             
                if(self.arrPacakge.count == 0)
                {
                    self.lblNoDataFound.text = "No Data Found"
                }
            }
            else
            {
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
//        webserviceForCardList(SingletonClass.sharedInstance.strPassengerID as AnyObject) { (result, status) in
//
        }
    
    //-------------------------------------------------------------
    // MARK: - Table View Methods -
    //-------------------------------------------------------------
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrPacakge.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PackageHistoryListTableViewCell") as! PackageHistoryListTableViewCell
        cell.selectionStyle = .none
       
//            {
        let dictData = self.arrPacakge[indexPath.row] as [String:AnyObject]
        
        cell.lblPackageName.text! = (dictData["details"]!["Name"] as? String)!
        cell.lblBookingID.text! = "Booking Id : \((dictData["Id"] as? String)!)" 
        cell.lblPickupLocation.text! = (dictData["PickupLocation"] as? String)!
        cell.lblDateTime.text! = (dictData["Date"] as? String)!
        cell.lblPackageType.text! = "\(dictData["details"]!["Time"] as! String) \(dictData["details"]!["Type"]as! String)"
        
     
        cell.lblPackageStatus.text! = (dictData["Status"] as? String)!

        cell.lblPaymentType.text! = (dictData["PaymentType"] as? String)!
        cell.lblPaymentStatus.text! = (dictData["PaymentStatus"] as? String)!
        cell.lblDistance.text! = "\(dictData["details"]!["KM"] as! String) Km"
        cell.lblAmount.text! = "$ \(dictData["details"]!["Amount"] as! String)"
        cell.lblDescription.text! = (dictData["details"]!["Description"] as? String)!
        

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }

}
