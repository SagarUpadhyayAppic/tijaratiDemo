//
//  RecentTransactionTVC.swift
//  GuageMeterDemo
//
//  Created by Pratik on 09/07/21.
//

import UIKit

class RecentTransactionTVC: UITableViewCell {
    @IBOutlet var recentTransactionViewRef: UIView!
    @IBOutlet var bulkTransactionViewRef: UIView!

    
    @IBOutlet weak var txnStatusIcon: UIImageView!
    @IBOutlet var transactionNameLblRef: UILabel!
    @IBOutlet var transactionAmountLblRef: UILabel!
    @IBOutlet var txId_DateTimeLblRef: UILabel!
    @IBOutlet var paymentMode1logoImgRef: UIImageView!
    @IBOutlet var paymentMode2logoImgRef: UIImageView!
    
    @IBOutlet var bulkLogoImgV1Ref: UIImageView!
    @IBOutlet var bulkTransactionNameLblRef: UILabel!
    @IBOutlet var bulkViewAllBtnRef: UIButton!
    @IBOutlet var bulkDateTimeLblRef: UILabel!
    @IBOutlet var bulkContactLblRef: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
