//
//  PrintTransactionViewController.swift
//  Burgan
//
//  Created by Malti Maurya on 23/03/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit
import SPStorkController



class PrintTransactionViewController: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var transactionDetailStackView: UIStackView!
    @IBOutlet weak var printStackView: UIStackView!
    
    @IBOutlet weak var lblMobileNo: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblCardNumber: UILabel!
    @IBOutlet weak var lblTransactionId: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var view1: UIView!
    var popupType = 0
    var transactionInfo : Transaction?
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblPayment: UILabel!
    @IBAction func closeDialog(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if popupType == 0 {
            printStackView.isHidden = false
            transactionDetailStackView.isHidden = true
        }else{
            printStackView.isHidden = true
            transactionDetailStackView.isHidden = false
            lblAmount.text = "KD " + setAmounts(amount:  (transactionInfo?.amount ?? "0.000").replacingOccurrences(of: "-", with: ""))
            lblAmount.attributedText = lblAmount.text!.attributedString(fontsize: 15)

            lblPayment.text = (transactionInfo?.network ?? "--")
            lblDate.text = self.convertDateToSpecificFormat(date: transactionInfo?.date ?? "", currentFormat: "dd-MM-yyyy", desiredFormat: "dd MMM yyyy")
            lblTime.text = self.convertDateToSpecificFormat(date: "\(transactionInfo?.time ?? "")", currentFormat: "HH:mm:ss", desiredFormat: "hh:mm a")
            lblCardNumber.text = (transactionInfo?.cardNum ?? "--")
            lblTransactionId.text = (transactionInfo?.txnid ?? "--")
            lblStatus.text = (transactionInfo?.txnStatus ?? "--")
            lblMobileNo.text = (transactionInfo?.mobileNum ?? "--")
            lblStatus.text = lblStatus.text?.localiz()
            
            // lblDate.text = (transactionInfo?.date ?? "--")
            // lblTime.text = (transactionInfo?.time ?? "00.00 -- ")
        }
    }
    
    func convertDateToSpecificFormat(date: String, currentFormat: String, desiredFormat: String) -> String
    {
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en")
        inputFormatter.dateFormat = currentFormat
        let showDate = inputFormatter.date(from: date)
        inputFormatter.dateFormat = desiredFormat
        let resultString = inputFormatter.string(from: showDate ?? Date())
        return resultString
    }
    
    func convertDateToFormat(date: Date, desiredFormat: String) -> String
    {
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en")
        inputFormatter.dateFormat = desiredFormat
        let resultString = inputFormatter.string(from: date)
        return resultString
    }
    
    func setAmounts(amount : String) -> String{
        return (Double(amount)?.rounded(digits: 3).calculate)!
    }
    var panScrollable: UIScrollView? {
        return nil
    }
    
    
    var anchorModalToLongForm: Bool {
        return false
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
