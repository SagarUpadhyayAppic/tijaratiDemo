//
//  eZpayCVC.swift
//  GuageMeterDemo
//
//  Created by Pratik on 09/07/21.
//

import UIKit
//import SmartGauge

class eZpayCVC: UICollectionViewCell {
    @IBOutlet weak var gaugeMeterViewRef: SmartGauge!
    @IBOutlet weak var availableBalanceLblRef: UILabel!
    @IBOutlet weak var totalAmountLblRef: UILabel!
    @IBOutlet weak var expireOnLblRef: UILabel!
    
    @IBOutlet weak var leftTitleLabel: UILabel!
    @IBOutlet weak var rightTitleLabel: UILabel!
}
