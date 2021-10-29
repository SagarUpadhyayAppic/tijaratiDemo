//
//  BulkPaymentFileConfirmAndSendViewController.swift
//  Burgan
//
//  Created by Pratik on 15/07/21.
//  Copyright © 2021 1st iMac. All rights reserved.
//

import UIKit

class BulkPaymentFileConfirmAndSendViewController: UIViewController {
    class var instance: BulkPaymentFileConfirmAndSendViewController {
        struct Static {
            static let instance: BulkPaymentFileConfirmAndSendViewController = BulkPaymentFileConfirmAndSendViewController()
        }
        return Static.instance
    }
    private var listener: BulkPaymentFileConfirmAndSendVCDelegate?
    
    @IBOutlet weak var detailTitleLbl: UILabel!
    @IBOutlet var containerView: UIView!
    @IBOutlet var backBtnRef: UIButton!
    @IBOutlet var goToDashboardBtnRef: UIButton!
    @IBOutlet var emailSentToLblRef: UILabel!
    
    var emailSentToText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        containerView.layer.cornerRadius = 20.0
        containerView.clipsToBounds = true
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        emailSentToLblRef.text = "Email Sent to \(emailSentToText) Customers"
        
        goToDashboardBtnRef.layer.cornerRadius = 15
        goToDashboardBtnRef.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        arabicSetup()
    }

    func arabicSetup(){
        detailTitleLbl.text = detailTitleLbl.text?.localiz()
        goToDashboardBtnRef.setTitle("GO TO DASHBOARD".localiz(), for: .normal)
        emailSentToLblRef.text = "Email Sent to ".localiz() + emailSentToText + " Customers".localiz()
    }

}

//MARK:- BUTTON ACTION
extension BulkPaymentFileConfirmAndSendViewController{
    
    @IBAction func goToDashboardBtnTap(_ sender: UIButton){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // let dashboardVc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let controller = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RootViewController") as? RootViewController)!
        appDelegate.window?.rootViewController = controller
        appDelegate.window?.makeKeyAndVisible()
    }
    
    @IBAction func backBtnTap(_ sender: UIButton){
        self.dismiss(animated: true) {
            BulkPaymentFileConfirmAndSendViewController.instance.sendDismissedAction()
        }
    }
    
    func setListener(listener: BulkPaymentFileConfirmAndSendVCDelegate){
        self.listener = listener
    }
    
    func sendDismissedAction() {
        listener?.didiVCDismiss()
    }
    
}

protocol BulkPaymentFileConfirmAndSendVCDelegate:class {
    func didiVCDismiss()
}
