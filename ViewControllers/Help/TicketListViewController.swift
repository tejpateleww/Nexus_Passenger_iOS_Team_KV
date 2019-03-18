//
//  TicketListViewController.swift
//  Nexus-Driver
//
//  Created by EWW iMac2 on 02/03/19.
//  Copyright © 2019 Excellent WebWorld. All rights reserved.
//

import UIKit

class TicketListViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,DelegatechatListRefresh
{
   

    @IBOutlet var tblView: UITableView!
    var arrTicketList = [[String : AnyObject]]()
    
    
    var isFromNotifications = Bool()
    var NotificationObject = [String:Any]()
    
    override func loadView() {
        super.loadView()
        
    }
    
    func goToChatViewByNotification(NotificationDetail:[String:Any]) {
        
        var UserDict = [String:Any]()
        let dictData = NotificationDetail["gcm.notification.data"] as! String
        let data = dictData.data(using: .utf8)!
        do
        {
            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,Any>
            {
                UserDict["Sender"] = jsonResponse["Sender"] as! String
                UserDict["ReceiverId"] = jsonResponse["ReceiverId"] as! String
                UserDict["TicketId"] = jsonResponse["TicketId"] as! String
                UserDict["Message"] = jsonResponse["Message"] as! String
                UserDict["Receiver"] = jsonResponse["Receiver"] as! String
                UserDict["SenderId"] = jsonResponse["SenderId"] as! String
                UserDict["Date"] = jsonResponse["Date"] as! String
            }
        }
        catch let error as NSError {
            print(error)
        }
        let ChatDetails = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
//        ChatDetails.strSendId = NotificationDetail["id"] as! String
        ChatDetails.userInfo = NotificationDetail as [String:AnyObject]
        ChatDetails.delegateOfRefreshChatList = self
        
        ChatDetails.strTicketID = UserDict["TicketId"] as! String
        ChatDetails.strTicketTile = ""
        
        self.navigationController?.pushViewController(ChatDetails, animated: true)
        
    }
    
    func RefreshChat()
    {
       self.webserviceForGettingTicketList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isFromNotifications == true {
            isFromNotifications = false
            self.goToChatViewByNotification(NotificationDetail: NotificationObject)
        }
        
        self.webserviceForGettingTicketList()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.setNavBarWithBack(Title: "My Ticket", IsNeedRightButton: false)
    }
    func webserviceForGettingTicketList()
    {
        let strID = SingletonClass.sharedInstance.strPassengerID
        
        webserviceForTicketList(strID as AnyObject) { (result, status) in
            if status
            {
                print(result)
                
                self.arrTicketList = result["tickets"] as! [[String : AnyObject]]
                self.tblView.reloadData()
                
            }
            else
            {
                print(result)
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        
        return arrTicketList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let customCell = self.tblView.dequeueReusableCell(withIdentifier: "TicketListViewCell") as! TicketListViewCell
        
        customCell.selectionStyle = .none
        let dictData = arrTicketList[indexPath.row] as! [String : AnyObject]

        //
        //
        customCell.lblTicketID.text = "Ticket ID: \(dictData["TicketId"] as! String)"
        customCell.lblTitle.text = dictData["TicketTitle"] as! String
        let StrStatus = dictData["Status"] as! String
        
        if StrStatus == "0"
        {
            customCell.lblStatus.text = "Pending"
        }
        if StrStatus == "1"
        {
            customCell.lblStatus.text = "Processing"
        }
        if StrStatus == "2"
        {
            customCell.lblStatus.text = "Complete"
        }
        
        return customCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        let dictData = arrTicketList[indexPath.row] as! [String : AnyObject]
        
        //
        //
       
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        viewController.strTicketID = dictData["TicketId"] as! String
        viewController.strTicketTile = dictData["TicketTitle"] as! String
        
        self.navigationController?.pushViewController(viewController, animated: true)
        
        /*
        let dictData = arrReviewData[indexPath.row]
        if let cell = tblView.cellForRow(at: indexPath) as? HelpListViewCell
        {
            cell.lblDescription.isHidden = !cell.lblDescription.isHidden
            if cell.lblDescription.isHidden
            {
                expandedCellPaths.remove(indexPath)
                cell.lblDescription.text = ""
                cell.iconArrow.image = UIImage.init(named: "arrow-down-leftBlue")
                cell.viewCell.layer.borderColor = UIColor.clear.cgColor
                cell.viewCell.layer.borderWidth = 0.5
            }
            else
            {
                expandedCellPaths.insert(indexPath)
                cell.lblDescription.text = dictData["Answers"] as? String
                cell.iconArrow.image = UIImage.init(named: "arrow-down-Blue")
                cell.viewCell.layer.borderColor = UIColor.black.cgColor
                cell.viewCell.layer.borderWidth = 0.5
            }
            
            DispatchQueue.main.async {
                self.tblView.beginUpdates()
                self.tblView.endUpdates()
            }
            
            //            DispatchQueue.main.async {
            //                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            //            }
            
        }
        */
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100
        // UITableViewAutomaticDimension
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
