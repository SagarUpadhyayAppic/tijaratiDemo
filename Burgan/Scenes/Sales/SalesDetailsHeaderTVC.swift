//
//  SalesDetailsHeaderTVC.swift
//  Burgan
//
//  Created by Pratik on 17/07/21.
//  Copyright © 2021 1st iMac. All rights reserved.
//

import UIKit

protocol expandSalesDetailsDelegate:class {
    func expandSalesDetailsBtnTappedInCell(_ cell:SalesDetailsHeaderTVC)

    }


class SalesDetailsHeaderTVC: UITableViewCell {
    @IBOutlet var mainViewRef: UIView!
    @IBOutlet var salesTitleLblRef: UILabel!
    @IBOutlet var totalAmountLblRef: UILabel!
    @IBOutlet var totalTransactionLblRef: UILabel!
    @IBOutlet var cvRef: UICollectionView!
    @IBOutlet var expandDetailsViewRef: UIView!
    @IBOutlet var dropDownActionBtnRef: UIButton!
    
    var showExpandDetailsView = true
    weak var btnDelegate: expandSalesDetailsDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func expandSalesDetailsBtnPress(_ sender: UIButton) {
        btnDelegate?.expandSalesDetailsBtnTappedInCell(self)
        
    }
}

extension SalesDetailsHeaderTVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
//   func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//       //pagerControl.currentPage = Int(scrollView.contentOffset.x)/Int(scrollView.frame.width - 50)
//    
//    let cell = scrollView.superview?.superview?.superview?.superview?.superview
//
//    if (cell?.isKind(of: tbSalesCell.self))! {
//       print("yes sales cell")
//        if let cell : tbSalesCell = (scrollView.superview?.superview?.superview?.superview?.superview as? tbSalesCell) {
//
//            cell.pagerControl.currentPage = Int(scrollView.contentOffset.x)/Int(scrollView.frame.width - 50)
//
//        }
//        
//    } else {
//        print("No not sales cell")
//    }
//    
//    
//
//   }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cvTbSalesCell", for: indexPath) as! cvSalesCell
        cell.progressView.layer.cornerRadius = 5
        cell.progressView.clipsToBounds = true
        cell.progressView.layer.sublayers![1].cornerRadius = 5
        cell.progressView.subviews[1].clipsToBounds = true
               
         if indexPath.row == 0 {
            cell.lblTitle1.text = "Debit Card".localiz()
            cell.lblTitle2.text = "Credit Card".localiz()
//            cell.lblTransctn1.text = dccount + " " + "Transactions".localiz()
//            cell.lblTrnsctn2.text = cccount + " " + "Transactions".localiz()
//            cell.lblAmount1.text = "KD " + setAmounts(amount: dcamount)
//            cell.lblAmount2.text = "KD " + setAmounts(amount: ccamount)
            
            
//            cell.lblTransctn1.text = (salesArray[collectionView.tag].dcCount ?? "0") + " " + "Transactions".localiz()
//            cell.lblTrnsctn2.text = (salesArray[collectionView.tag].ccCount ?? "0") + " " + "Transactions".localiz()
//            cell.lblAmount1.text = "KD " + setAmounts(amount: salesArray[collectionView.tag].dcAmount ?? "0.000")
//
//            cell.lblAmount2.text = "KD " + setAmounts(amount: salesArray[collectionView.tag].ccAmount ?? "0.000")
//
//            cell.lblAmount1.attributedText = cell.lblAmount1.text!.attributedString(fontsize: 10)
//            cell.lblAmount2.attributedText = cell.lblAmount2.text!.attributedString(fontsize: 10)
//
//
//            let Amt = Double(salesArray[collectionView.tag].dcAmount ?? "0.000")
//            let totAmt = Double(salesArray[collectionView.tag].totalAmount ?? "0.000")
 //           cell.progressView.setProgress( Float(Amt! / totAmt!), animated: true)
            
         }else{
            
            cell.lblTitle1.text = "International".localiz()
            cell.lblTitle2.text = "Domestic".localiz()
            
//            cell.lblTransctn1.text = intlcount + " " + "Transactions".localiz()
//            cell.lblTrnsctn2.text = domesticcount + " " + "Transactions".localiz()
//            cell.lblAmount1.text = "KD " + setAmounts(amount: intlamount)
//            cell.lblAmount2.text = "KD " + setAmounts(amount: domesticamount)
            
            
//            cell.lblTransctn1.text = (salesArray[collectionView.tag].intlCount ?? "0") + " " + "Transactions".localiz()
//            cell.lblTrnsctn2.text = (salesArray[collectionView.tag].domesticCount ?? "0") + " " + "Transactions".localiz()
//            cell.lblAmount1.text = "KD " + setAmounts(amount: salesArray[collectionView.tag].intlAmount ?? "0.000")
//            cell.lblAmount2.text = "KD " + setAmounts(amount: salesArray[collectionView.tag].domesticAmount ?? "0.000")
//
//            cell.lblAmount1.attributedText = cell.lblAmount1.text!.attributedString(fontsize: 10)
//            cell.lblAmount2.attributedText = cell.lblAmount2.text!.attributedString(fontsize: 10)
//
//            let Amt = Double(salesArray[collectionView.tag].intlAmount ?? "0.000")
//            let totAmt = Double(salesArray[collectionView.tag].totalAmount ?? "0.000")
//            cell.progressView.setProgress( Float(Amt! / totAmt!), animated: true)
            
        }
        
        if AppConstants.language == .ar{
            cell.lblAmount1.textAlignment = NSTextAlignment.right
        }else{
            cell.lblAmount1.textAlignment = NSTextAlignment.left
        }
        
        if AppConstants.language == .ar{
            cell.lblTitle1.textAlignment = .right
            cell.lblTitle2.textAlignment = .left
            cell.lblAmount1.textAlignment = NSTextAlignment.right
            cell.lblAmount2.textAlignment = NSTextAlignment.left
            cell.lblTransctn1.textAlignment = NSTextAlignment.right
            cell.lblTrnsctn2.textAlignment = NSTextAlignment.left
            
        }else{
            
            cell.lblTitle1.textAlignment = .left
            cell.lblTitle2.textAlignment = .right
            cell.lblAmount1.textAlignment = NSTextAlignment.left
            cell.lblAmount2.textAlignment = NSTextAlignment.right
            cell.lblTransctn1.textAlignment = NSTextAlignment.left
            cell.lblTrnsctn2.textAlignment = NSTextAlignment.right
        }
        
       //cell.lblAmount1.attributedText = cell.lblAmount1.text!.attributedString(fontsize: 17)
          //  cell.lblAmount2.attributedText = cell.lblAmount2.text!.attributedString(fontsize: 17)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width - 10, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
     
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 5;
//    }
}
