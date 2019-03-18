//
//  ChatViewController.swift
//  ChatDemo
//
//  Created by Apple on 30/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

//import SocketIO
protocol DelegatechatListRefresh {
    func RefreshChat()
}

let windowWidth: CGFloat = CGFloat(UIScreen.main.bounds.size.width)

class ChatViewController: BaseViewController,UIGestureRecognizerDelegate ,UINavigationControllerDelegate,UIActionSheetDelegate,UITextViewDelegate{//,UITableViewDataSource,UITableViewDelegate {
    
    // ----------------------------------------------------
    // MARK: - Outlets
    // ----------------------------------------------------
    var ViewProfile = String()

    @IBOutlet var viewChatBottom: UIView!
    @IBOutlet weak var ViewChatDetails: UIView!
    @IBOutlet weak var viewChatdata: UIView!
    @IBOutlet weak var btnUserDetail: UIButton!
    
    @IBOutlet weak var tblVw: UITableView!
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblSubjectTitle : UILabel!
    
    @IBOutlet weak var txtMessage: UITextView!
    @IBOutlet weak var vwSelectedImage: UIView!
    @IBOutlet weak var vwEmergency: UIView!
    
    @IBOutlet weak var conVwMessageBottom: NSLayoutConstraint!
    @IBOutlet weak var conVwEmergencyMessageHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnSend: UIButton!
    
    
    // ----------------------------------------------------
    // MARK: - Global Declaration
    // ----------------------------------------------------
    var strTicketID = String()
    var strTicketTile = String()
    
    var arrData = [MessageObject]()
    var isEmergency = false
    var isImage = false
    let picker = UIImagePickerController()
    var strSendId = String()
    var userInfo : [String: AnyObject]!
    var strBookingId = String()
    var strBookingType = String()
    var delegateOfRefreshChatList : DelegatechatListRefresh?
    
    @IBOutlet weak var btnHello: UIButton!
    @IBOutlet weak var viewEmjncy: UIView!
    @IBOutlet weak var btnHelloHeight: NSLayoutConstraint!
    
    //    let socket = (UIApplication.shared.delegate as! AppDelegate).SocketManager
    
    
    // ----------------------------------------------------
    // MARK: - Base Methods
    // ----------------------------------------------------
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavBarWithBack(Title: "Ticket Detail", IsNeedRightButton: false)
        setupKeyboard(false)
        self.hideKeyboard()
        self.registerForKeyboardNotifications()
        
        //Change by Bhautik
        SingletonClass.sharedInstance.isChatBoxOpen = true
        SingletonClass.sharedInstance.ChatBoxOpenedWithID = self.strTicketID
//        UtilityClass.setNavigationBarInViewController(controller: self, naviColor: UIColor.clear, naviTitle: "mymatcher".localized, leftImage: "iconBackArrow", rightImage: "",font: UIFont.Bold(ofSize:fontSize.largeTitleFont.rawValue))
//
//        self.btnHello.setTitle("hello".localized, for: .normal)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if arrData.count>0 {
            self.btnHello.isHidden = true
            self.btnHelloHeight.constant = 0
            tblVw.reloadData()
            let indexPath = IndexPath.init(row: arrData.count-1, section: 0)
            tblVw.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setupKeyboard(true)
        self.deregisterFromKeyboardNotifications()
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.enable = true
        
        //Change by Bhautik
        SingletonClass.sharedInstance.isChatBoxOpen = false
        SingletonClass.sharedInstance.ChatBoxOpenedWithID = ""
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        txtMessage.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        txtMessage.isScrollEnabled = true
        
        
    }
    @IBAction func segmentview(_ sender: UISegmentedControl) {
    }
    @IBOutlet weak var textHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.enable = false
        
        self.btnUserDetail.imageView?.contentMode = .scaleAspectFit
        
//        self.view.backgroundColor = UIColor.red
//        ViewChatDetails.roundCorners(corners: [.topRight,.topLeft], radius: 20.0)
        //        viewEmjncy.roundCorners(corners: [.topRight,.topLeft], radius: 20.0)
        NotificationCenter.default.removeObserver(self, name: NotificationforUpdateChatDetail, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.webServiceForFetchData), name: NotificationforUpdateChatDetail, object: nil)
        
        viewChatBottom.layer.cornerRadius = 10
        viewChatBottom.clipsToBounds = true
        self.picker.delegate = self
        viewChatBottom.layer.borderColor = UIColor.gray.cgColor
        viewChatBottom.layer.borderWidth = 1.0
        
        lblName.text = "Ticket ID: \(strTicketID)"
        lblSubjectTitle.text = "Subject: \(strTicketTile)"
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
       
        setImage()
        webServiceForFetchData()
    }
    
    
    func setImage() {
//        let dataProfile  = userInfo["image"] as? String
//
//        let imageURL = URL(string: (WebserviceURLs.kBaseImageURL + (dataProfile ?? "")))
//        self.imgProfile.sd_setShowActivityIndicatorView(true)
//        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.width/2
//        self.imgProfile.clipsToBounds = true
//        self.lblName.font = UIFont.Regular(ofSize: 17)
//        self.lblName.text = userInfo["fullname"] as? String
//        self.imgProfile.sd_setImage(with: imageURL, placeholderImage: UIImage.init(named: "imgEmajlis"), options: []) { (image, error, cacheType, url) in
//            self.imgProfile.sd_removeActivityIndicator()
//        }
    }
    @objc func btnSearch()
    {
        //        performSegue(withIdentifier: "", sender: self)
    }
    
    func adjustTextViewHeight()
    {
        let fixedWidth = txtMessage.frame.size.width
        
        let newSize = txtMessage.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let numLines = Int(txtMessage.contentSize.height / (txtMessage.font?.lineHeight)! ?? 0)
        print(numLines)
        print("textFieldHeight: \(newSize.height)")
        self.textHeightConstraint?.constant = newSize.height
        
        if numLines <= 4 {
            self.txtMessage.isScrollEnabled = false
            let difference = newSize.height - 35 //new line
            self.textHeightConstraint?.constant = newSize.height
            self.containerHeightConstraint?.constant = 84 + difference //new line
        }
        else {
            self.txtMessage.isScrollEnabled = true
            
        }
        self.view.layoutIfNeeded()
        
        
    }
    func textViewDidChange(_ textView: UITextView) {
        
    }
    
    @IBAction func btnSayHelloAction(_ sender: Any) {
//        self.txtMessage.text = "hello".localized
    }
    
    
    @IBAction func btnUserDetail(_ sender: Any) {
        
        //Create the AlertController and add Its action like button in Actionsheet
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
        let saveActionButton = UIAlertAction(title: "Unmatch", style: .default)
        { _ in
            print("Save")
        }
        actionSheetControllerIOS8.addAction(saveActionButton)
        
        
        let viewProfile = UIAlertAction(title: "View Prolile", style: .default)
        { _ in
            self.performSegue(withIdentifier: "segueToViewProfile", sender: self)
        }
        actionSheetControllerIOS8.addAction(viewProfile)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }
    
    
    //===================================
    // MARK: = Webservice OF Unmatch
    //===================================
    

    
    
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    @objc func keyboardWasShown(notification: NSNotification){

        let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        conVwMessageBottom.constant = keyboardSize!.height - 30

        if #available(iOS 11.0, *) {
            conVwMessageBottom.constant = keyboardSize!.height - view.safeAreaInsets.bottom
        } else {
            conVwMessageBottom.constant = keyboardSize!.height
        }
        self.animateConstraintWithDuration()
        
    }
    @objc func keyboardWillBeHidden(notification: NSNotification){
        conVwMessageBottom.constant = 0
        self.animateConstraintWithDuration()
        //Once keyboard disappears, restore original positions
        
    }
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    //MARK: Button Methods
    @IBAction func sendClick(_ sender: UIButton) {
        if (self.txtMessage.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count != 0) //? true : false
        {
            
            if txtMessage.text!.isEmpty == false {
                
                
                webserviceOFSendMessage()
                
                
            }
            
        }
        
    }
    
    func sendMessage(_ isSender: Bool , dictData : [String:AnyObject]){
        
        let objMessage = MessageObject()
        
        
        objMessage.message = dictData["Message"] as? String
        objMessage.isSender = isSender
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timeString = formatter.string(from: Date())
        
        objMessage.created_date = dictData["Date"] as? String
        arrData.append(objMessage)
        
        if arrData.count > 0 {
            self.btnHello.isHidden = true
            self.btnHelloHeight.constant = 0
        }
        
        let indexPath = IndexPath.init(row: arrData.count-1, section: 0)
        
        tblVw.insertRows(at: [indexPath], with: .bottom)
        let path = IndexPath.init(row: arrData.count-1, section: 0)
        tblVw.scrollToRow(at: path, at: .bottom, animated: true)
        
        //        sendMessageToPassenger(message: txtMessage.text!)
        
        self.resetAll()
    }
    
    func resetAll() {
        txtMessage.text = ""
        
        conVwEmergencyMessageHeight.constant = 0
        self.animateConstraintWithDuration()
    }
    
    
    
    //===================================
    // MARK: = SaveMessage
    //===================================
    
    func webserviceOFSendMessage()
    {
        
        var dictdata = [String: AnyObject]()
        
//        "SenderId:4, TicketId:NXSPSR9TCT,
//        Message:ok"
        
        dictdata["SenderId"] = SingletonClass.sharedInstance.strPassengerID as AnyObject//id
        dictdata["TicketId"] = strTicketID as AnyObject//id
        dictdata["Message"] = txtMessage.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) as AnyObject
        
        webserviceForSendingDataChat(dictParams: dictdata as AnyObject) { (result , status) in
            if status
            {
               print(result)
                let dictData = result["tickets_history"] as! [String:AnyObject]
                self.delegateOfRefreshChatList?.RefreshChat()
                self.sendMessage(true, dictData: dictData)
                
            }
            else
            {
                print(result)
            }
        }
//        webserviceOfSendMessage(dictdata as AnyObject) { (result, status) in
//            if(status)
//            {
//                do {
//                    if let dictResponse = try JSONSerialization.jsonObject(with: result as! Data, options : .allowFragments) as? Dictionary<String,Any>
//                    {
//                        if let dictDataResponse = dictResponse as? [String:AnyObject]
//                        {
//                            if let dictData = dictDataResponse["message_data"] as? [String:AnyObject]
//                            {
//
//                                self.delegateOfRefreshChatList?.RefreshChat()
//                                self.sendMessage(true, dictData: dictData)
//                            }
//                        }
//                    } else {
//                        print("bad json")
//                    }
//                }
//                catch let DecodingError.dataCorrupted(context) {
//                    print(context)
//                } catch let DecodingError.keyNotFound(key, context) {
//                    print("Key '\(key)' not found:", context.debugDescription)
//                    print("codingPath:", context.codingPath)
//                } catch let DecodingError.valueNotFound(value, context) {
//                    print("Value '\(value)' not found:", context.debugDescription)
//                    print("codingPath:", context.codingPath)
//                } catch let DecodingError.typeMismatch(type, context)  {
//                    print("Type '\(type)' mismatch:", context.debugDescription)
//                    print("codingPath:", context.codingPath)
//                } catch {
//                    print("error: ", error)
//
//                }
//            }
//            else
//            {
//                if let msg = result["message"] as? String
//                {
//                    UtilityClass.showMessageForError(msg)
//                }
//            }
//        }
    }
    
    
    
    //===================================
    // MARK: = facthDetail
    //===================================
    
    @objc func webServiceForFetchData()
    {
        
//        var dictdata = [String: AnyObject]()
//        let data = SingltonClass.sharedInstance.ProfileLoginData!
//        let IdOfUser =  data.profiledata!.id!
//        dictdata[keyAllKey.senderUserMember1] = IdOfUser as AnyObject//id
//        dictdata[keyAllKey.senderReciverMember2] = strSendId as AnyObject
//        dictdata[keyAllKey.pagenum] = "1" as AnyObject
        
        webserviceForChatHistory(strTicketID as AnyObject) { (result, status) in
            
            if(status)
            {
                print(result)

                self.strTicketTile = (result["ticket_info"] as! NSDictionary).object(forKey: "TicketTitle") as! String
                 self.lblSubjectTitle.text = "Subject: \(self.strTicketTile)"
                    if var tempArra = result["ticket_history"] as? [[String:AnyObject]]
                    {
//                         tempArra = tempArra.reversed()
                        if tempArra.count != 0
                        {
                            for (_, value) in (tempArra.enumerated())
                            {
                                let objMessage = MessageObject()
                                
                                objMessage.message = (value["Message"] as! String)
                                
                                
                                if (value["SenderId"] as! String) == SingletonClass.sharedInstance.strPassengerID
                                {
                                    objMessage.isSender = true
                                }
                                else {
                                    objMessage.isSender = false
                                }
                                
                                objMessage.id = value["Id"] as? String
                                //                        objMessage.bookingId = value["BookingId"] as? String
                                //                        objMessage.type = value["Type"] as? String
                                objMessage.sender_id = value["SenderId"] as? String
                                //                        objMessage.sender_id = value["Sender"] as? String
                                objMessage.receiver_id = value["ReceiverId"] as? String
                                objMessage.message = value["Message"] as? String
                                objMessage.created_date = value["Date"] as? String
                                
                                self.arrData.append(objMessage)
                                
                                self.tblVw.reloadData()
                                
                            }
                            self.btnHello.isHidden = true
                            self.btnHelloHeight.constant = 0
                            self.tblVw.reloadData()
                        } else {
                            self.btnHello.isHidden = false
                            self.btnHelloHeight.constant = 40.0
                        }
//                    }
                }
            }else{
//                UtilityClass.showMessageForError((result as! [String:AnyObject])["message"] as! String)
            }
        }
        
    }
    
    
    
    func nsdataToJSON(data: NSData) -> AnyObject? {
        do {
            return try JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as AnyObject
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
    
    //Change by Bhautik
    
    override func loadView() {
        super.loadView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.UpdateChat(notification:)), name: NotificationforUpdateChat, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(self.RefreshChatViewWithNewChat(notification:)), name: NotificationforRefreshNewChat, object: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
//        if (segue.identifier == "segueToViewProfile")
//        {
//            let ProfileViewVc = segue.destination as! ProfileViewController
//            ProfileViewVc.strChatVc = SingltonClass.sharedInstance.ChatBoxOpenedWithID
//            ProfileViewVc.isFromChatVc = true
//        }
    }
    @objc private func RefreshChatViewWithNewChat(notification: NSNotification)
    {
        if let MessageDict = notification.userInfo as? [String:Any]
        {
//            print(MessageDict as! NSDictionary)
            
            var UserDict = [String:Any]()
            let dictData = MessageDict["gcm.notification.data"] as! String
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
            
             self.strTicketID = UserDict["TicketId"] as! String
//             self.strTicketTile = UserDict["TicketId"] as! String
            self.lblName.text = "Ticket ID: \(strTicketID)"
//            self.lblSubjectTitle.text = "Subject: \(strTicketTile)"
//            self.lblName.text = ""
//            self.lblSubjectTitle.text = ""
           
            self.webServiceForFetchData()
        }
    }
    @objc private func UpdateChat(notification: NSNotification)
    {
        
        if let MessageDict = notification.userInfo as? [String:Any] {

            let objMessage = MessageObject()
            objMessage.message = (MessageDict["Message"] as! String)
            if (MessageDict["SenderId"] as! String) == SingletonClass.sharedInstance.strPassengerID
            {
                objMessage.isSender = true
            }
            else {
                objMessage.isSender = false
            }
//            objMessage.id = MessageDict["message_id"] as? String
            objMessage.sender_id = MessageDict["SenderId"] as? String
            objMessage.receiver_id = MessageDict["ReceiverId"] as? String
            objMessage.message = MessageDict["Message"] as? String
            
            let DateFormatters = DateFormatter()
            DateFormatters.dateFormat = "yyyy-MM-DD HH:mm:ss"
            objMessage.created_date = DateFormatters.string(from: Date())
            self.arrData.append(objMessage)
            
            if arrData.count > 0 {
                self.btnHello.isHidden = true
                self.btnHelloHeight.constant = 0
            }
            self.tblVw.beginUpdates()
            self.tblVw.insertRows(at: [IndexPath(row: self.arrData.count - 1, section: 0)], with: .top)
            self.tblVw.endUpdates()
            self.tblVw.scrollToRow(at: IndexPath(row: self.arrData.count - 1, section: 0), at: .bottom, animated: true)
            //self.tblVw.reloadData()
        }
    }
    
    func animateConstraintWithDuration(duration: TimeInterval = 0.5) {
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.loadViewIfNeeded() ?? ()
        })
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}

extension ChatViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: MessageCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let obj = arrData[indexPath.row]
//        let strIdentifier = obj.isSender ? "SenderCell" : "RecieverCell"
        let strIdentifier = obj.isSender ? "SenderCell" : "RecieverCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: strIdentifier) as! MessageCell
        cell.lblMessage.text = obj.message
        
        cell.lblMessage.isHidden = obj.message!.isEmpty ? true : false
        cell.lblTime.text = obj.created_date
        cell.lblReadStatus.isHidden = true
        
        
        cell.lblMessage.textColor = UIColor.white
        cell.lblTime.textColor = UIColor.white
        cell.lblReadStatus.textColor = UIColor.white
        if obj.isSender {
            cell.lblMessage.textColor = UIColor.white
            cell.lblTime.textColor = UIColor.white
            cell.lblReadStatus.textColor = UIColor.white
        }else{
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.00, execute: {
            if obj.isSender == true {
                cell.vwChatBg.roundCorners([.bottomLeft,.topLeft,.topRight], radius: 15.0)
            }else {
                cell.vwChatBg.roundCorners([.bottomRight,.topLeft,.topRight], radius: 15.0)
            }
            
        })
        
        cell.selectionStyle = .none
        return cell
    }
}
extension ChatViewController : UIImagePickerControllerDelegate {
    
}

//MARK: Table Methods
class MessageCell: UITableViewCell {
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblReadStatus: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var vwChatBg: UIView!
    @IBOutlet weak var constraintHeightOfImage: NSLayoutConstraint!
    
    
    
    
    override func layoutSubviews() {
        
    }
}


class MessageObject  {
    var isSender: Bool = false
    var name : String? = nil
    var image : String? = nil
    var id : String? = nil
    var sender_id : String? = nil
    var receiver_id : String? = nil
    var message : String? = nil
    var created_date : String? = nil
    
    
}

extension UIView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

func setupKeyboard(_ enable: Bool) {
    IQKeyboardManager.shared.enable = enable
    IQKeyboardManager.shared.enableAutoToolbar = enable
    IQKeyboardManager.shared.shouldShowToolbarPlaceholder = !enable
    IQKeyboardManager.shared.previousNextDisplayMode = .alwaysShow
}

extension UIViewController {
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboards))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboards()
    {
        view.endEditing(true)
    }
}

