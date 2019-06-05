//
//  HelpViewController.swift
//  Nexus-Driver
//
//  Created by EWW iMac2 on 01/03/19.
//  Copyright © 2019 Excellent WebWorld. All rights reserved.
//

import UIKit

class HelpViewController: BaseViewController,UITableViewDataSource, UITableViewDelegate,UIGestureRecognizerDelegate
{

    var arrReviewData = [[String:AnyObject]]()
    @IBOutlet var tblView: UITableView!
    var expandedCellPaths = Set<IndexPath>()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.webseviceForQuestionList()
        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.setNavBarWithBack(Title: "FAQ", IsNeedRightButton: false)
    }
    
    func webseviceForQuestionList()
    {
        webserviceForHelpQuestionList("" as AnyObject) { (result, status) in
            if status
            {
                print(result)
                self.arrReviewData = result["faq_list"] as! [[String : AnyObject]]
//                self.strAvgRate = result["avg"]  as! String
//                self.strTotalRate = result["total_rating"]  as! String
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
        
        
            return arrReviewData.count
   
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let customCell = self.tblView.dequeueReusableCell(withIdentifier: "HelpListViewCell") as! HelpListViewCell
        
        customCell.selectionStyle = .none
        let dictData = arrReviewData[indexPath.row] as! [String : AnyObject]
        
//
//
        customCell.viewCell.layer.cornerRadius = 5.0
        customCell.viewCell.layer.masksToBounds = true
        customCell.lblTitle.text = dictData["Questions"] as? String
        customCell.lblDescription.text = ""

        customCell.lblDescription.isHidden = !expandedCellPaths.contains(indexPath)
        
        return customCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
            let dictData = arrReviewData[indexPath.row]
            if let cell = tblView.cellForRow(at: indexPath) as? HelpListViewCell
            {
                cell.lblDescription.isHidden = !cell.lblDescription.isHidden
                if cell.lblDescription.isHidden
                {
                    expandedCellPaths.remove(indexPath)
                    cell.lblDescription.text = ""
                    cell.iconArrow.image = UIImage.init(named: "icon_ArrowDown")
                    cell.viewCell.layer.borderColor = UIColor.clear.cgColor
                    cell.viewCell.layer.borderWidth = 0.5
                }
                else
                {
                    expandedCellPaths.insert(indexPath)
                    cell.lblDescription.text = dictData["Answers"] as? String
                    cell.iconArrow.image = UIImage.init(named: "icon_ArrowDown")
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
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    @IBAction func btnGenerateTicketsClicked(_ sender: Any)
    {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "GenerateTicketViewController") as! GenerateTicketViewController
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    
}
