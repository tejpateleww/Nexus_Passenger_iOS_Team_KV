//
//  InviteDriverViewController.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 14/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import MessageUI
import Social
import SDWebImage

class InviteDriverViewController: ParentViewController, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {

    
    var strReferralCode = String()
    var strReferralMoney = String()
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let profileData = SingletonClass.sharedInstance.dictProfile

        if let ReferralCode = profileData.object(forKey: "ReferralCode") as? String {
            strReferralCode = ReferralCode
            self.lblReferralCode.text = self.strReferralCode
        }
        
        if let RefarMoney = profileData.object(forKey: "ReferralAmount") as? Double {
            strReferralMoney = String(RefarMoney)
            self.lblReferralMoney.text = "$ \(strReferralMoney)"
        }

        if let imgProfile = (profileData).object(forKey: "Image") as? String {
            
            imgProfilePick.sd_setShowActivityIndicatorView(true)
            imgProfilePick.sd_setIndicatorStyle(.gray)
            imgProfilePick.sd_setImage(with: URL(string: imgProfile), completed: nil)
        }

       
        
        /*
         {
         profile =     {
         ABN = 1234;
         Address = "";
         BSB = qwer;
         BankAccountNo = 0978645312;
         BankName = bob;
         CompanyName = Isco;
         CreatedDate = "2017-11-24 06:36:31";
         Description = hi;
         DeviceType = 1;
         Email = "bhavesh@excellentwebworld.info";
         Fullname = "Bhavesh Odedra";
         Gender = male;
         Id = 36;
         Image = "http://54.206.55.185/web/images/passenger/Image13";
         Lat = 6287346872364287;
         LicenceImage = "images/passenger/image16.png";
         Lng = 6287346872364287;
         MobileNo = 0987456321;
         Password = 25d55ad283aa400af464c76d713c07ad;
         QRCode = "images/qrcode/mrXc1tDi1sijkWNjjKCXoKqilWI=.png";
         ReferralCode = tktcps36Bha;
         Status = 1;
         Token = cc958ac268a826a7cf92f9eb655985d5b8de2517e0e5a8432f88801ddd367134;
         Verify = 1;
         };
         status = 1;
         }
         */

//        headerView?.btnBack.addTarget(self, action: #selector(self.nevigateToBack), for: .touchUpInside)
        
        imgProfilePick.layer.cornerRadius = imgProfilePick.frame.width / 2
        imgProfilePick.layer.masksToBounds = true
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet var imgProfilePick: UIImageView!
    @IBOutlet weak var lblReferralCode: UILabel!
    @IBOutlet weak var lblReferralMoney: UILabel!
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
/*
    func nevigateToBack()
    {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: TabbarController.self) {
                self.sideMenuController?.embed(centerViewController: controller)
                break
            }
        }
    }
*/
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    @IBAction func btnFacebook(_ sender: UIButton) {
//        var facebookURL = URL(string: "fb://profile/<profile-ID>")
//         var facebookURL = URL(string: "fb://app")
//        if UIApplication.shared.canOpenURL(facebookURL!) {
//            UIApplication.shared.openURL(facebookURL!)
//        }
//        else {
//            UtilityClass.showAlert("", message: "Please install WhatsApp app", vc: self)
//        }
        
//        if(SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook)) {
//
//            let socialController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
//
//            socialController?.setInitialText("Check out TiCKTOC, taxi booking app for Australia by TiCKTOCK, Your Referral Code is '\(strReferralCode)'")
//
//            self.present(socialController!, animated: true, completion: nil)
//        }
//        else {
//            UtilityClass.showAlert("", message: "Please install Facebook app", vc: self)
//
//        }
        
        var fbController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            var completionHandler: SLComposeViewControllerCompletionHandler = {(_ result: SLComposeViewControllerResult) -> Void in
                fbController?.dismiss(animated: true) { [weak self] in }
                switch result {
                case .done:
                    print("Posted.")
                case .cancelled:
                    fallthrough
                default:
                    print("Cancelled.")
                }
            }
//            fbController?.add(UIImage(named: "1.jpg") ?? UIImage())
            fbController?.setInitialText("Check out this article.")
//            fbController.add(URL(string: "URLString")!)
            fbController?.completionHandler = completionHandler
            self.present(fbController!, animated: true) { [weak self] in }
        }
        else {
            if let fbSignInDialog = SLComposeViewController(forServiceType: SLServiceTypeFacebook) {
                fbSignInDialog.setInitialText("")
                self.present(fbSignInDialog, animated: false) { [weak self] in }
        }
            else {
                UtilityClass.showAlert("", message: "Please install Facebook app", vc: self)
            }
        }
        
    }
    
    @IBAction func btnTwitter(_ sender: UIButton) {
        
//        if(SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter)) {
//
//            let socialController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
//
//            socialController?.setInitialText("Check out TiCKTOC, taxi booking app for Australia by TiCKTOCK, Your Referral Code is '\(strReferralCode)'")
//
//            self.present(socialController!, animated: true, completion: nil)
//        }
//        else {
//
//            UtilityClass.showAlert("", message: "Please install Twitter app", vc: self)
//
//        }
        
        var TWController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            var completionHandler: SLComposeViewControllerCompletionHandler = {(_ result: SLComposeViewControllerResult) -> Void in
                TWController?.dismiss(animated: true) { [weak self] in }
                switch result {
                case .done:
                    print("Posted.")
                case .cancelled:
                    fallthrough
                default:
                    print("Cancelled.")
                }
            }
            //            fbController?.add(UIImage(named: "1.jpg") ?? UIImage())
            TWController?.setInitialText("Check out this article.")
            //            fbController.add(URL(string: "URLString")!)
            TWController?.completionHandler = completionHandler
            self.present(TWController!, animated: true) { [weak self] in }
        }
        else {
            if let twitterSignInDialog = SLComposeViewController(forServiceType: SLServiceTypeTwitter) {
            
                twitterSignInDialog.setInitialText("")
                
                if twitterSignInDialog.serviceType == SLServiceTypeTwitter {
                     self.present(twitterSignInDialog, animated: false)
                }
                else {
                    UtilityClass.showAlert("", message: "Please install Twitter app", vc: self)
                }
                
            }
            else {
               UtilityClass.showAlert("", message: "Please install Twitter app", vc: self)
            }
            
        }
    }
    
    @IBAction func btnEmail(_ sender: UIButton) {
        
        var emailTitle = ""
        var messageBody = ""
        var toRecipents = [""]
        var mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: false)
        mc.setToRecipients(toRecipents)
        
        self.present(mc, animated: true, completion: nil)

    }
    
    @IBAction func btnWhatsApp(_ sender: UIButton) {
        
//        let attrs = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 15)]
//        var boldString = NSMutableAttributedString(string:strReferralCode, attributes:attrs)


        let urlString = ""
        let urlStringEncoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let url  = NSURL(string: "whatsapp://send?text=\(urlStringEncoded!)")
        
        if UIApplication.shared.canOpenURL(url! as URL) {
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
        } else {
            
            UtilityClass.showAlert("", message: "Please install WhatsApp app", vc: self)
            
//            let errorAlert = UIAlertView(title: "Cannot Send Message", message: "Your device is not able to send WhatsApp messages.", delegate: self, cancelButtonTitle: "OK")
//            errorAlert.show()
        }
    }
    
    @IBAction func btnSMS(_ sender: UIButton) {
        
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = ""
            controller.recipients = [""]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
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

    
    
    
}
