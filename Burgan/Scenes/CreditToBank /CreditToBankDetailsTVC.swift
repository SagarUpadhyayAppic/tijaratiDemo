//
//  CreditToBankDetailsTVC.swift
//  Burgan
//
//  Created by Pratik on 16/07/21.
//  Copyright © 2021 1st iMac. All rights reserved.
//

import UIKit

class CreditToBankDetailsTVC: UITableViewCell {
    @IBOutlet var viewRef: UIView!
    @IBOutlet var visaValueLblRef: UILabel!
    @IBOutlet var masterValueLblRef: UILabel!
    @IBOutlet var knetValueLblRef: UILabel!
    @IBOutlet var gccValueLblRef: UILabel!
    @IBOutlet var ezpayValueLblRef: UILabel!
    
    @IBOutlet var midLblRef: UILabel!
    
    @IBOutlet weak var visaBtnRef: UIButton!
    @IBOutlet weak var masterBtnRef: UIButton!
    @IBOutlet weak var knetBtnRef: UIButton!
    @IBOutlet weak var gccBtnRef: UIButton!
    @IBOutlet weak var ezpayBtnRef: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
