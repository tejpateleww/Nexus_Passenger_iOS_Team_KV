//
//  MyReceiptsViewController.swift
//  TickTok User
//
//  Created by Excelent iMac on 13/12/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import MessageUI

class MyReceiptsViewController: ParentViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {
    
    
    var aryData = NSArray()
    var urlForMail = String()
    var counts = Int()
    
    var expandedCellPaths = Set<IndexPath>()
    
    var labelNoData = UILabel()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.counts = 0
  
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
//        labelNoData = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
//        self.labelNoData.text = "Loading..."
//        labelNoData.textAlignment = .center
//        self.view.addSubview(labelNoData)
//        self.tableView.isHidden = true
        
       webserviewOfMyReceipt()
        
        self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        self.tableView.addSubview(self.refreshControl)
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        webserviewOfMyReceipt()
        
        tableView.reloadData()
        refreshControl.endRefreshing()
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet var tableView: UITableView!
    
    
    //-------------------------------------------------------------
    // MARK: - Table View Methods
    //-------------------------------------------------------------
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        return self.counts
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyRecepitTableViewCell") as! MyRecepitTableViewCell
        cell.selectionStyle = .none
        
        let dictData = self.newAryData.object(at: indexPath.row) as! NSDictionary
        
        
        if dictData["HistoryType"] as! String == "Past" {
            
            if dictData["Status"] as! String == "completed" {
                
                cell.btnGetReceipt.layer.cornerRadius = 5
                cell.btnGetReceipt.layer.masksToBounds = true
                
                cell.lblDriversNames.text = dictData.object(forKey: "DriverName") as? String
                
                cell.lblDropLocationDescription.text = dictData.object(forKey: "DropoffLocation") as? String
                cell.lblDateAndTime.text = dictData.object(forKey: "CreatedDate") as? String
                
                cell.lblPickUpLocationDescription.text = dictData.object(forKey: "PickupLocation") as? String
                cell.lblVehicleType.text = dictData.object(forKey: "Model") as? String
                cell.lblDistanceTravelled.text = dictData.object(forKey: "TripDistance") as? String
                cell.lblTolllFee.text = dictData.object(forKey: "TollFee") as? String
                cell.lblFareTotal.text = dictData.object(forKey: "TripFare") as? String
                cell.lblDiscountApplied.text = dictData.object(forKey: "Discount") as? String
                cell.lblChargedCard.text = dictData.object(forKey: "PaymentType") as? String
                
                self.urlForMail = dictData.object(forKey: "ShareUrl") as! String
                cell.btnGetReceipt.addTarget(self, action: #selector(self.getReceipt(sender:)), for: .touchUpInside)
                cell.viewDetails.isHidden = !self.expandedCellPaths.contains(indexPath)
                
                return cell
            }
            else {
                return UITableViewCell()
            }
        }
        else {
            return UITableViewCell()
        }
        
        
//        return cell
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        if let cell = tableView.cellForRow(at: indexPath) as? MyRecepitTableViewCell {
            cell.viewDetails.isHidden = !cell.viewDetails.isHidden
            if cell.viewDetails.isHidden {
                expandedCellPaths.remove(indexPath)
            } else {
                expandedCellPaths.insert(indexPath)
            }
            tableView.beginUpdates()
            tableView.endUpdates()
           
        }
      
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    func nevigateToBack()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func getReceipt(sender: UIButton) {
        
        let emailTitle = ""
        let messageBody = urlForMail
        let toRecipents = [""]
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: false)
        mc.setToRecipients(toRecipents)
        
        self.present(mc, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller:MFMailComposeViewController, didFinishWith result:MFMailComposeResult, error:Error?) {
        switch result {
        case MFMailComposeResult.cancelled:
            print("Mail cancelled")
            UtilityClass.showAlert("", message: "Mail cancelled", vc: self)
        case MFMailComposeResult.saved:
            print("Mail saved")
            UtilityClass.showAlert("", message: "Mail saved", vc: self)
        case MFMailComposeResult.sent:
            print("Mail sent")
            UtilityClass.showAlert("", message: "Mail sent", vc: self)
        case MFMailComposeResult.failed:
            print("Mail sent failure: \(String(describing: error?.localizedDescription))")
            UtilityClass.showAlert("", message: "Mail sent failure: \(String(describing: error?.localizedDescription))", vc: self)
        default:
            UtilityClass.showAlert("", message: "Something went wrong", vc: self)
            break
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        switch result {
        case MessageComposeResult.cancelled:
            print("Mail cancelled")
            UtilityClass.showAlert("", message: "Mail cancelled", vc: self)
        case MessageComposeResult.sent:
            print("Mail sent")
            UtilityClass.showAlert("", message: "Mail sent", vc: self)
        case MessageComposeResult.failed:
            print("Mail sent failure")
        //            UtilityClass.showAlert("", message: "Mail sent failure: \(String(describing: error?.localizedDescription))", vc: self)
        default:
            UtilityClass.showAlert("", message: "Something went wrong", vc: self)
            break
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    var newAryData = NSMutableArray()
    
    func webserviewOfMyReceipt() {
        
        webserviceForBookingHistory(SingletonClass.sharedInstance.strPassengerID as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
                
                self.aryData = (result as! NSDictionary).object(forKey: "history") as! NSArray
                
                self.counts = 0
                self.newAryData = NSMutableArray()
                
                for i in 0..<self.aryData.count {
                    
                    let dictData = self.aryData.object(at: i) as! NSDictionary
                    
                    if dictData["HistoryType"] as! String == "Past" {
                        
                        if dictData["Status"] as! String == "completed" {
                            self.counts += 1
                            
                            self.newAryData.add(self.aryData.object(at: i) as! NSDictionary)
                        }
                    }
                }
                
            
               self.tableView.reloadData()
                
            }
            else {
                print(result)
                
                if let res = result as? String {
                    UtilityClass.showAlert("", message: res, vc: self)
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.showAlert("", message: resDict.object(forKey: "message") as! String, vc: self)
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.showAlert("", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
                }
            }
        }
    }
    
    
    
}

