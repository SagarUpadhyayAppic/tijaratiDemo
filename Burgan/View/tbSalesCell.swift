//
//  tbSalesCell.swift
//  Burgan
//
//  Created by Malti Maurya on 18/03/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit

class tbSalesCell: UITableViewCell {
    
    @IBOutlet weak var lblSalesAmount: UILabel!
    @IBOutlet weak var lblSalesName: UILabel!
    @IBOutlet weak var lblSalesTransaction: UILabel!
    @IBOutlet weak var curvedView: UIView!
    
    @IBOutlet weak var ivArrow: UIImageView!
    
    @IBOutlet weak var collectionBgView: UIView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var collectionViewSale: UICollectionView!
    @IBOutlet weak var separatorView1height: NSLayoutConstraint!
 
    @IBOutlet weak var sideVerticalView: UIView!
    
    @IBOutlet weak var pagerControl: UIPageControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        sideVerticalView.layer.cornerRadius = 5
        sideVerticalView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]

           curvedView.layer.cornerRadius = 8
        curvedView.layer.shadowOpacity = 0.40
                curvedView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
                curvedView.layer.shadowRadius = 3.0
            curvedView.layer.shadowColor = UIColor.BurganColor.brandGray.lgiht.cgColor
                curvedView.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner,.layerMaxXMinYCorner]
//        let firstWord   = "KD "
//          let secondWord = "45,000"
//          let thirdWord   = ".000"
//          let comboWord = firstWord + secondWord + thirdWord
//          let attributedText = NSMutableAttributedString(string:comboWord)
//        let attrs      = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
//        let range = NSString(string: comboWord).range(of: firstWord)
//        let range2 = NSString(string: comboWord).range(of: thirdWord)
//
//          attributedText.addAttributes(attrs, range: range)
//        attributedText.addAttributes(attrs, range: range2)
//          lblSalesAmount.attributedText = attributedText
       
        onload()
    }
    var collectionViewOffset: CGFloat {
        get {
            return collectionViewSale.contentOffset.x
        }

        set {
            collectionViewSale.contentOffset.x = newValue
        }
    }
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forRow row: Int) {
      

        collectionViewSale.delegate = dataSourceDelegate
        collectionViewSale.dataSource = dataSourceDelegate
        collectionViewSale.tag = row
        collectionViewSale.reloadData()
    }
    
    func onload(){
        //separatorView1height.constant = 0
        collectionBgView.isHidden = true
        ivArrow.image = UIImage(named: "ic_down_arrow_black")

    }
    func showDetailView(){
        //separatorView1height.constant = 1
        collectionBgView.isHidden = false
        ivArrow.image = UIImage(named: "ic_up_arrow_grey")

    }
 
  
}
extension String {

    mutating func attributedString(fontsize : Int) -> NSAttributedString
    {
        if self.contains(".") {
            if self.suffix(2).contains(".") {
                self.append("00")
            } else if self.suffix(3).contains(".") {
                self.append("0")
            }
        } else {
           self.append(".000")
        }
        
        let amt = self.count - 3
        let unit = self.prefix(3)
        let secondWord = self.suffix(amt)
        //let amount = secondWord.prefix(amt-4)
        let decimal = secondWord.suffix(3)
        
        let attributedText = NSMutableAttributedString(string: self)
        let attrs      = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: CGFloat(fontsize))]
        let attrs1      = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: CGFloat(fontsize))]
        let range = NSString(string: self).range(of: String(unit))
        let range2 = NSString(string: self).range(of: String(decimal))
        
        attributedText.addAttributes(attrs, range: range)
        attributedText.addAttributes(attrs1, range: range2)
        return attributedText
    }
}
