//
//  TransactionDetailViewController.swift
//  GuageMeterDemo
//
//  Created by Pratik on 12/07/21.
//

import UIKit

class TransactionsDetailViewController: UIViewController {
    @IBOutlet var backBtnRef: UIButton!
    @IBOutlet var amountLblRef: UILabel!
    @IBOutlet var paymentModeLblRef: UILabel!
    @IBOutlet var dateLblRef: UILabel!
    @IBOutlet var timeLblRef: UILabel!
    @IBOutlet weak var fileStackView: UIStackView!
    @IBOutlet weak var transactionStackView: UIStackView!
    @IBOutlet weak var paymentModeTitleLbl: UILabel!
    @IBOutlet weak var contactTitleLbl: UILabel!
    @IBOutlet weak var contactStackView: UIStackView!
    @IBOutlet weak var emailStackView: UIStackView!
    @IBOutlet weak var statusStackView: UIStackView!
    @IBOutlet weak var descStackView: UIStackView!
    @IBOutlet weak var shareStackView: UIView!
    @IBOutlet weak var fileNameTitleLabel: UILabel!
    @IBOutlet var fileNameLblRef: UILabel!
    @IBOutlet weak var txnTitlelLabel: UILabel!
    @IBOutlet var transactionIdLblRef: UILabel!
    @IBOutlet var contactNumberLblRef: UILabel!
    @IBOutlet weak var emailTitleLabel: UILabel!
    @IBOutlet var emailIdLblRef: UILabel!
    @IBOutlet var statusLblRef: UILabel!
    @IBOutlet weak var descTitleLabel: UILabel!
    @IBOutlet var descriptionLblRef: UILabel!
    @IBOutlet var shareBtnRef: UIButton!
    @IBOutlet var resendRecieptBtnRef: UIButton!
    
    @IBOutlet weak var payerNameStackView: UIStackView!
    @IBOutlet weak var payerNameTitleLabel: UILabel!
    @IBOutlet var payerNameLblRef: UILabel!

    var amountValue = ""
    var paymentModeValue = ""
    var dateValue = ""
    var timeValue = ""
    var fileNameValue = ""
    var transactionIdValue = ""
    var contackNumberValue = ""
    var emailIdValue = ""
    var statusValue = ""
    var descriptionValue = ""
    var paymentURL = ""
    var payerNameValue = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fileStackView.isHidden = fileNameValue.isEmpty ? true : false
        fileNameLblRef.text = fileNameValue
        
        payerNameStackView.isHidden = fileNameValue.isEmpty ? false : true
        payerNameLblRef.text = payerNameValue

        amountLblRef.text = amountValue
        amountLblRef.attributedText =  amountLblRef.text!.attributedString(fontsize: 13)
        
        paymentModeLblRef.text = paymentModeValue
        
        dateLblRef.text = dateValue
        timeLblRef.text = timeValue
        
        transactionIdLblRef.text = transactionIdValue
        
        if contackNumberValue.contains("X") {
            contactNumberLblRef.text = contackNumberValue
        } else {
            let characters = Array(contackNumberValue)
            print(characters)
            var tempAry = [Character]()
            
            
            for i in 0..<characters.count {
                
                if i >= characters.count - 4 {
                    tempAry.append(characters[i])
                } else {
                    tempAry.append("X")
                }
            }
            let str = String(tempAry)
            contactNumberLblRef.text = str
        }
        

        emailIdLblRef.text = emailIdValue
        
        statusLblRef.text = statusValue
        
        switch statusValue.lowercased() {
        case "success":
            statusLblRef.textColor = UIColor.init(hexString: "#0078BD")
            break
            
        case "failed":
            statusLblRef.textColor = UIColor.init(hexString: "#D62525")
            break
            
        case "void":
            statusLblRef.textColor = UIColor.init(hexString: "#F18E00")
            break
            
        case "refund":
            statusLblRef.textColor = UIColor.init(hexString: "#7A8890")
            break
            
        case "linkexpired":
            statusLblRef.textColor = UIColor.init(hexString: "#A3BBC3")
            break
            
        case "linkdeclined":
            statusLblRef.textColor = UIColor.init(hexString: "#D62525")
            break
            
        default:
            statusLblRef.textColor = UIColor.init(hexString: "#0078BD")
            break
        }
//        <color name="decline_color">#D62525</color> use for failed also
//        <color name="expired_color">#A3BBC3</color>
//        <color name="refund">#7A8890</color>
//        <color name="void">#F18E00</color>
//        <color name="inprogress">#0078BD</color>
        
        descriptionLblRef.text = descriptionValue
        
        shareBtnRef.isHidden = statusValue.lowercased() != "inprogress"
        shareBtnRef.layer.cornerRadius = 22
        
        resendRecieptBtnRef.layer.cornerRadius = 15
        resendRecieptBtnRef.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        arabicSetup()
        
    }
    
    func arabicSetup(){
        fileNameTitleLabel.text = fileNameTitleLabel.text?.localiz()
        emailTitleLabel.text = emailTitleLabel.text?.localiz()
        descTitleLabel.text = descTitleLabel.text?.localiz()
        contactTitleLbl.text = contactTitleLbl.text?.localiz()
        paymentModeTitleLbl.text = paymentModeTitleLbl.text?.localiz()
        payerNameTitleLabel.text = payerNameTitleLabel.text?.localiz()
        
        shareBtnRef.setTitle("SHARE".localiz(), for: .normal)
        resendRecieptBtnRef.setTitle("RESEND RECIEPT".localiz(), for: .normal)
        shareBtnRef.imageEdgeInsets = UIEdgeInsets(top: 0, left: AppConstants.language == .ar ? 10 : -10, bottom: 0, right: 0)
    }
    
}

//MARK:- BUTTON ACTION
extension TransactionsDetailViewController{
    @IBAction func backBtnTap(_ sender: UIButton){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareBtnTap(_ sender: UIButton){
//        let someText:String = "Dear customer,".localiz() + " \(AppConstants.cifCompanyName) " + "has requested payment for".localiz() + " \(amountLblRef.text ?? "KD 0.000")." + "\nTap on the below link to pay:- \n".localiz() + "\(paymentURL)"
        let someText:String = paymentURL
       let sharedObjects:[AnyObject] = [someText as AnyObject]
       let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
       activityViewController.popoverPresentationController?.sourceView = self.view

//        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook,UIActivity.ActivityType.postToTwitter,UIActivity.ActivityType.mail]

       self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func resendRecieptBtnTap(_ sender: UIButton){
        
    }
}
