//
//  tbCompanyNameCell.swift
//  Burgan
//
//  Created by Malti Maurya on 23/03/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit

class cvCompanyNameCell: UICollectionViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    
    override  func awakeFromNib() {
        super.awakeFromNib()
     deselectedView()
    }
    
    func deselectedView(){
        self.contentView.layer.borderColor = UIColor.BurganColor.brandGray.lgiht.cgColor
             self.contentView.layer.borderWidth = 1
             self.contentView.layer.cornerRadius = 5
        self.contentView.backgroundColor = UIColor.white
        lblName.textColor = UIColor.BurganColor.brandGray.lgiht
    }
    func selectedView(){
             self.contentView.layer.borderWidth = 0
        self.contentView.backgroundColor = UIColor.BurganColor.brandBlue.dark
        lblName.textColor = UIColor.white

    }
    override var isSelected: Bool{
          didSet{
              if self.isSelected
              {
                  super.isSelected = true
                  selectedView()
              }
              else
              {
                  super.isSelected = false
                  deselectedView()
              }
          }
      }
}
