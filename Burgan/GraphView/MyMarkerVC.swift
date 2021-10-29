//
//  MyMarkerVC.swift
//  PaperVideo
//
//  Created by 1st iMac on 24/04/19.
//  Copyright © 2019 mac new. All rights reserved.
//

import UIKit
import Charts

class MyMarkerVC: MarkerView {

    
    @IBOutlet weak var back_View: UIView!
    @IBOutlet weak var correct_Label: UILabel!
    @IBOutlet weak var incorrect_Label: UILabel!
    @IBOutlet weak var unanswered_Label: UILabel!
    
   // @IBOutlet weak var transactionImage: UIImageView!
  //  @IBOutlet weak var salesImage: UIImageView!
    var correctArr = [String]()
    var incorrectArr = [String]()
    var unansweredArr = [String]()

   
    override open func awakeFromNib()
    {
        self.offset.x = -self.frame.size.width / 2.0
        self.offset.y = -self.frame.size.height - 7.0
        
        self.back_View.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
        self.back_View.layer.cornerRadius = 10
//        transactionImage.layer.cornerRadius =   transactionImage.frame.height / 2
//        salesImage.layer.cornerRadius =   salesImage.frame.height / 2
//        transactionImage.layer.masksToBounds = true
//        salesImage.layer.masksToBounds = true

        if AppConstants.language == .ar {
            
            correct_Label.textAlignment = .right
            incorrect_Label.textAlignment = .right
            unanswered_Label.textAlignment = .right
            
        } else {
            
            correct_Label.textAlignment = .left
            incorrect_Label.textAlignment = .left
            unanswered_Label.textAlignment = .left

        }
    }
  
    func arrayPassVal(correctAry:[String], incorrectAry:[String], unansweredAry: [String], fromWhere: String)
    {
        correctArr = correctAry
        incorrectArr = incorrectAry
        unansweredArr = unansweredAry
    }
    
    open override func refreshContent(entry: ChartDataEntry, highlight: Highlight)
    {
        let x  = entry.x
        let indxPath = Int(x)
        
        correct_Label?.text = correctArr[indxPath]
        
//        incorrect_Label.text = "◉ KD " + incorrectArr[indxPath]
        // incorrect_Label.text = "KD " + incorrectArr[indxPath]
        incorrect_Label.text = "KD " + setAmounts(amount: "\(incorrectArr[indxPath])")
        
//        unanswered_Label.text = "◉ " + unansweredArr[indxPath] + " " + "Transactions".localiz()
        
        var str = unansweredArr[indxPath]

        if let dotRange = str.range(of: ".") {
          str.removeSubrange(dotRange.lowerBound..<str.endIndex)
        }
        unanswered_Label.text = "◉ " + str + " " + "Transactions".localiz()
        
        let mutableAttributedString = NSMutableAttributedString()
//
//        let AttributedString1 = NSAttributedString(string: "◉ ")
//        let AttributedString2 = incorrect_Label.text?.attributedString(fontsize: 10) ?? NSAttributedString(string: "KD 0.000")
//        mutableAttributedString.append(AttributedString1)
//        mutableAttributedString.append(AttributedString2)
        
//        incorrect_Label.attributedText =  incorrect_Label.text?.attributedString(fontsize: 10)
        
        if AppConstants.language == .ar {
                   

            let AttributedString1 = NSAttributedString(string: " ◉")
            let AttributedString2 = incorrect_Label.text?.attributedString(fontsize: 10) ?? NSAttributedString(string: "KD 0.000")
            mutableAttributedString.append(AttributedString2)
            mutableAttributedString.append(AttributedString1)
                   
        } else {
                   

            let AttributedString1 = NSAttributedString(string: "◉ ")
            let AttributedString2 = incorrect_Label.text?.attributedString(fontsize: 10) ?? NSAttributedString(string: "KD 0.000")
            mutableAttributedString.append(AttributedString1)
            mutableAttributedString.append(AttributedString2)

        }
        
        incorrect_Label.attributedText = mutableAttributedString
        
       
        
        
        layoutIfNeeded()
    }
    
}
extension UIView
{
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
       layer.masksToBounds = false
       layer.shadowColor = color.cgColor
       layer.shadowOpacity = opacity
       layer.shadowOffset = offSet
       layer.shadowRadius = radius

       layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
       layer.shouldRasterize = true
       layer.rasterizationScale = scale ? UIScreen.main.scale : 1
     }
}
