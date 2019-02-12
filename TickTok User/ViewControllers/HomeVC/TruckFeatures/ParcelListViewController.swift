//
//  ParcelListViewController.swift
//  Cab Ride User
//
//  Created by Apple on 28/09/18.
//  Copyright © 2018 Excellent Webworld. All rights reserved.
//

import UIKit

class ParcelListViewController: UIViewController {

    // ----------------------------------------------------
    // MARK: - Outlets
    // ----------------------------------------------------
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // ----------------------------------------------------
    // MARK: - Globle Declaration Methods
    // ----------------------------------------------------
    
    var aryParcel = [[String:Any]]()
    var delegate: parcelAndLabourDelegate?
    var selectedData = [String:Any]()
    var selectedCell = IndexPath()
    
    
    // ----------------------------------------------------
    // MARK: - Base Methods
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.reloadData()
    }
    
    // ----------------------------------------------------
    // MARK: - Actions
    // ----------------------------------------------------

    @IBAction func btnCancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnDone(_ sender: UIButton) {
        
        if delegate != nil {
            delegate?.didParcelSelected!(dict: selectedData)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    

}

// ----------------------------------------------------
// MARK: - CollectionView Delegate & DataSource
// ----------------------------------------------------

extension ParcelListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return aryParcel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ParcelListCollectionViewCell", for: indexPath) as! ParcelListCollectionViewCell
        
        
        let currentData = aryParcel[indexPath.row]
        
        cell.lblParcel.text = currentData["Name"] as? String
        cell.imgParcel.sd_setIndicatorStyle(.gray)
        cell.imgParcel.sd_showActivityIndicatorView()
        
        if let img = currentData["Image"] as? String {
            if img != "" {
                cell.imgParcel.sd_setImage(with: URL(string: img), completed: nil)
            }
        }
        
        cell.viewRightSideLine.isHidden =  (indexPath.row % 2 != 0) ? true : false
//        if indexPath.row % 2 == 0 {
//            cell.viewRightSideLine.isHidden = true
//        }
        
        cell.viewMainParcel.backgroundColor = UIColor.white
        cell.lblParcel.textColor = UIColor.black
        
        
        if selectedCell == indexPath {
            cell.viewMainParcel.backgroundColor = UIColor.black
            cell.lblParcel.textColor = UIColor.white
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("\(aryParcel[indexPath.row]["Name"] ?? "none")")
        
        selectedData = aryParcel[indexPath.row]
        selectedCell = indexPath
        collectionView.reloadData()
    }
    
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        selectedCell = IndexPath()
//        deSelectedCell = indexPath
//        collectionView.reloadData()
//    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.collectionView.frame.width / 2, height: 155)
    }
    
}

