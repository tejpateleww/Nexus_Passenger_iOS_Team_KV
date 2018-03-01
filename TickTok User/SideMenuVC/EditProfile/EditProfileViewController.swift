//
//  EditProfileViewController.swift
//  TickTok User
//
//  Created by Excelent iMac on 23/12/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewEditProfile.layer.cornerRadius = 10
        viewEditProfile.layer.masksToBounds = true
        
        viewAccount.layer.cornerRadius = 10
        viewAccount.layer.masksToBounds = true
       
//        self.ConstraintEditProfileX.constant = self.view.frame.origin.x - viewEditProfile.frame.size.width - 20
//        self.constraintAccountTailing.constant = -(viewEditProfile.frame.size.width + 20)
//
        
//        AnimationToView()

        setImageColor()
        
        iconProfile.image = setImageColorOfImage(name: "iconEditProfile")
        iconAccount.image = setImageColorOfImage(name: "iconAccount")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

//        ConstraintEditProfileX.constant = -(self.view.frame.size.width)
//        constraintAccountTailing.constant = -(self.view.frame.size.width)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        AnimationToView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func setImageColor() {
        
        let img = UIImage(named: "iconArrowGrey")
        imgArrowProfile.image = img?.maskWithColor(color: UIColor.white)
        imgArrowAccount.image = img?.maskWithColor(color: UIColor.white)
    }
    
    func setImageColorOfImage(name: String) -> UIImage {
        
        var imageView = UIImageView()
        
        let img = UIImage(named: name)
        imageView.image = img?.maskWithColor(color: UIColor.white)
       
        
        return imageView.image!
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var viewEditProfile: UIView!
    @IBOutlet weak var viewAccount: UIView!
    
    @IBOutlet weak var imgArrowProfile: UIImageView!
    @IBOutlet weak var imgArrowAccount: UIImageView!
    
    @IBOutlet weak var ConstraintEditProfileX: NSLayoutConstraint!
    @IBOutlet weak var constraintAccountTailing: NSLayoutConstraint!
    
    @IBOutlet weak var viewMain: UIView!
    
    @IBOutlet weak var iconProfile: UIImageView!
    @IBOutlet weak var iconAccount: UIImageView!
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
//        AnimationToView()
        
        print("Back Button Clicked")
        
    }
    
    @IBAction func btnEditProfile(_ sender: UIButton) {
        
    }
    
    @IBAction func btnEditAccount(_ sender: UIButton) {
        
    }
    
    func AnimationToView() {

        self.ConstraintEditProfileX.constant = self.view.frame.origin.x - viewEditProfile.frame.size.width - 20
        self.constraintAccountTailing.constant = -(viewEditProfile.frame.size.width + 20)
        
        self.viewMain.layoutIfNeeded()
        
        UIView.animate(withDuration: 2.0, delay: 0.0, options: .curveEaseIn, animations: {

            
            self.ConstraintEditProfileX.constant = 20
            self.constraintAccountTailing.constant = 20
            
            self.viewMain.layoutIfNeeded()
            
            
        }, completion: { finished in
            
        })
        
        
    }
    

}


extension UIImage {
    
    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
    
}
