//
//  RegistrationContainerViewController.swift
//  TickTok User
//
//  Created by Excellent Webworld on 26/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import CHIPageControl

class RegistrationContainerViewController: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var pageControl: CHIPageControlJaloro!
    @IBOutlet weak var scrollObject: UIScrollView!
    
    @IBOutlet weak var firstStep: UIImageView!
    @IBOutlet weak var secondStep: UIImageView!
    @IBOutlet weak var thirdStep: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollObject.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        UIApplication.shared.isStatusBarHidden = true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        let currentPage = self.scrollObject.contentOffset.x / self.scrollObject.frame.size.width
        
        if (currentPage == 0)
        {
            self.navigationController?.popViewController(animated: true)
        }
        else if (currentPage == 1){
            self.scrollObject.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            self.selectPageControlIndex(Index: 0)
            //            self.pageControl.set(progress: 0, animated: true)
        }
        else
        {
            self.scrollObject.setContentOffset(CGPoint(x: self.view.frame.size.width, y: 0), animated: true)
            self.selectPageControlIndex(Index: 0)
            //            self.pageControl.set(progress: 0, animated: true)
        }
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        let currentPage = scrollView.contentOffset.x / scrollView.frame.size.width
        self.selectPageControlIndex(Index: 0)
//        self.pageControl.set(progress: Int(currentPage), animated: true)

    }
    
    func selectPageControlIndex(Index:Int) {
        self.firstStep.image = UIImage(named: "Unselected_Circle")
        self.secondStep.image = UIImage(named: "Unselected_Circle")
        self.thirdStep.image = UIImage(named: "Unselected_Circle")
        
        if Index == 0 {
            self.firstStep.image = UIImage(named: "Selected_Circle")
        } else if Index == 1 {
            self.secondStep.image = UIImage(named: "Selected_Circle")
        } else if Index == 2 {
            self.thirdStep.image = UIImage(named: "Selected_Circle")
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
