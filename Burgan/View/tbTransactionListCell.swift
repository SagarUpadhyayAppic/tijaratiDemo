//
//  tbTransactionListCell.swift
//  Burgan
//
//  Created by Malti Maurya on 20/03/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit

class tbTransactionListCell: UITableViewCell {
    
    @IBOutlet weak var txnStatusIcon: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var symbolLogo1: UIImageView!
    @IBOutlet weak var symbolLogo2: UIImageView!
    @IBOutlet weak var backView: UIView!
    override  func awakeFromNib() {
        super.awakeFromNib()
        backView.layer.cornerRadius = 10
    }
}
