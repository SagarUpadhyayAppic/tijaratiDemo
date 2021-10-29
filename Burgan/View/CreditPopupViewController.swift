//
//  CreditPopupViewController.swift
//  Burgan
//
//  Created by Malti Maurya on 26/06/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import Foundation
class CreditPopupViewController: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMDRRate: UILabel!
    @IBOutlet weak var lblMDRRateTitle: UILabel!
    @IBOutlet weak var lblNetAmount: UILabel!
    @IBOutlet weak var lblNetAmountTitle: UILabel!
    @IBOutlet weak var lblTotalAmt: UILabel!
    @IBOutlet weak var lblTotalAmtTitle: UILabel!
    @IBOutlet weak var lblReferenceNum: UILabel!
    @IBOutlet weak var lblReferenceNumTitle: UILabel!
    var mdrrate : String?
    var totalAmt : String?
    var netamt : String?
    var referencNum : String?
    var titleStr : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTitle.text = self.titleStr
//        lblMDRRate.text = (mdrrate ?? "0") + " %"
        
        lblMDRRate.text = "KD " + setAmounts(amount: (mdrrate ?? "0.000"))
        lblMDRRate.attributedText = lblMDRRate.text?.attributedString(fontsize: 13)

        lblNetAmount.text = "KD " + setAmounts(amount: (netamt ?? "0.000"))
        lblNetAmount.attributedText = lblNetAmount.text?.attributedString(fontsize: 13)

        lblTotalAmt.text = "KD " + setAmounts(amount: (totalAmt ?? "0.000"))
        lblTotalAmt.attributedText = lblTotalAmt.text?.attributedString(fontsize: 13)

        lblReferenceNum.text = referencNum
        
        if AppConstants.language == .ar {
            
            lblNetAmount.textAlignment = .left
            lblNetAmountTitle.textAlignment = .left
            lblTotalAmt.textAlignment = .left
            lblTotalAmtTitle.textAlignment = .left
            
            lblMDRRate.textAlignment = .right
            lblMDRRateTitle.textAlignment = .right
            lblReferenceNum.textAlignment = .right
            lblReferenceNumTitle.textAlignment = .right
            
        } else {
            
            lblNetAmount.textAlignment = .right
            lblNetAmountTitle.textAlignment = .right
            lblTotalAmt.textAlignment = .right
            lblTotalAmtTitle.textAlignment = .right
            
            lblMDRRate.textAlignment = .left
            lblMDRRateTitle.textAlignment = .left
            lblReferenceNum.textAlignment = .left
            lblReferenceNumTitle.textAlignment = .left
            
        }
    }
    
    @IBAction func closePopup(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
