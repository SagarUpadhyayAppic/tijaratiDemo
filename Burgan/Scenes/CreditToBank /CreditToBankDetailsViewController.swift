//
//  CreditToBankDetailsViewController.swift
//  Burgan
//
//  Created by Pratik on 16/07/21.
//  Copyright © 2021 1st iMac. All rights reserved.
//

import UIKit

class CreditToBankDetailsViewController: UIViewController {
    @IBOutlet var tvRef: UITableView!
    @IBOutlet var okBtnRef: UIButton!
    @IBOutlet var backBtnRef: UIButton!
    
    var dataCount = Int()
    var midValue = ""
    var visaValue = ""
    var masterValue = ""
    var knetValue = ""
    var gccValue = ""
    var ezpayValue = ""
    
    var values = [MerchantList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tvRef.separatorStyle = .none
        tvRef.tableFooterView = UIView()
        okBtnRef.layer.cornerRadius = 15
        okBtnRef.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        print("Data Count:- \(values.count) Data:- \(values)")
        
    }
    
}

//MARK:- BUTTON ACTION
extension CreditToBankDetailsViewController{
    @IBAction func okBtnTap(_ sender: UIButton){
        
    }
    
    @IBAction func backBtnTap(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }

}

//MARK:- TABLEVIEW METHODS
extension CreditToBankDetailsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         let count = values.count//{
        return count
        //}
        //return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CreditToBankDetailsTVC
        cell.viewRef.layer.cornerRadius = 6
        cell.viewRef.dropShadow()
        
        print("IndexPath:- \(indexPath.row)")
        cell.midLblRef.text = "MID".localiz() + " : " + (values[indexPath.row].mid ?? "0")

        if let valuess = values[indexPath.row].splitAmount?.count{
            
            if valuess > 0 {
                for i in 0..<self.values[indexPath.row].splitAmount!.count{
                    let splitamount : SplitAmount = self.values[indexPath.row].splitAmount![i]
                    
                    if splitamount.network!.contains("VISA") {
                        cell.visaValueLblRef.text = "KD " + setAmounts(amount: splitamount.netAmount!)
                        cell.visaValueLblRef.attributedText = cell.visaValueLblRef.text?.attributedString(fontsize: 13)
                    } else if splitamount.network!.contains("MASTER") {
                        cell.masterValueLblRef.text = "KD " + setAmounts(amount: splitamount.netAmount!)
                        cell.masterValueLblRef.attributedText = cell.masterValueLblRef.text?.attributedString(fontsize: 13)
                    } else if splitamount.network!.contains("KNET") {
                        cell.knetValueLblRef.text = "KD " + setAmounts(amount: splitamount.netAmount!)
                        cell.knetValueLblRef.attributedText = cell.knetValueLblRef.text?.attributedString(fontsize: 13)
                    } else {
                        cell.gccValueLblRef.text = "KD " + setAmounts(amount: (splitamount.netAmount ?? "0.000"))
                        cell.gccValueLblRef.attributedText = cell.gccValueLblRef.text?.attributedString(fontsize: 13)
                    }
                }
            }
        }
        
        cell.visaBtnRef.tag = indexPath.row
        cell.masterBtnRef.tag = indexPath.row
        cell.knetBtnRef.tag = indexPath.row
        cell.gccBtnRef.tag = indexPath.row
        cell.ezpayBtnRef.tag = indexPath.row

        cell.visaBtnRef.addTarget(self, action: #selector(showVisaDetailBtn(_:)), for: .touchUpInside)
        cell.masterBtnRef.addTarget(self, action: #selector(showMasterDetailBtn(_:)), for: .touchUpInside)
        cell.knetBtnRef.addTarget(self, action: #selector(showKnetDetailBtn(_:)), for: .touchUpInside)
        cell.gccBtnRef.addTarget(self, action: #selector(showGccDetailBtn(_:)), for: .touchUpInside)
        cell.ezpayBtnRef.addTarget(self, action: #selector(showEzpayDetailBtn(_:)), for: .touchUpInside)
        //
        
        cell.selectionStyle = .none
        
        if AppConstants.language == .ar {
            cell.visaValueLblRef.textAlignment = .left
            cell.masterValueLblRef.textAlignment = .left
            cell.knetValueLblRef.textAlignment = .left
            cell.gccValueLblRef.textAlignment = .left
            
            
        } else {
            
            cell.visaValueLblRef.textAlignment = .right
            cell.masterValueLblRef.textAlignment = .right
            cell.knetValueLblRef.textAlignment = .right
            cell.gccValueLblRef.textAlignment = .right
            
        }
        
        return cell
    }
    
    @objc func showVisaDetailBtn(_ sender: UIButton){
        let ButtonPosition = sender.convert(CGPoint.zero, to: tvRef)
        let indexPath = tvRef.indexPathForRow(at: ButtonPosition)
        if indexPath != nil {

            let ButtonPosition = sender.convert(CGPoint.zero, to: tvRef)
            let indexPath = tvRef.indexPathForRow(at: ButtonPosition)
            if indexPath != nil {
                let controller = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CreditPopupViewController") as? CreditPopupViewController)!
                if let valuess = values[indexPath!.row].splitAmount?.count{
                    
                if valuess > 0{
                    for i in 0..<self.values[indexPath!.row].splitAmount!.count{
                        let splitamount : SplitAmount = self.values[indexPath!.row].splitAmount![i]

                        if splitamount.network!.contains("VISA") {
                        controller.titleStr = "VISA"
                        controller.referencNum = splitamount.refNo
                            controller.netamt = splitamount.netAmount
                            controller.mdrrate = splitamount.mdr
                            controller.totalAmt = splitamount.totalAmount

                        //cell.lblMaster.attributedText = cell.lblMaster.text?.attributedString(fontsize: 13)
                    }

                    }
                }

                }
                
                self.presentAsStork(controller, height: 300, cornerRadius:CGFloat.CornerRadius.popup.radius, showIndicator: false, showCloseButton: false)

            }}}
    
    @objc func showMasterDetailBtn(_ sender: UIButton){
        let ButtonPosition = sender.convert(CGPoint.zero, to: tvRef)
        let indexPath = tvRef.indexPathForRow(at: ButtonPosition)
        if indexPath != nil {
            let controller = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CreditPopupViewController") as? CreditPopupViewController)!
            if let valuess = values[indexPath!.row].splitAmount?.count{
                
            if valuess > 0{
                for i in 0..<self.values[indexPath!.row].splitAmount!.count{
                    let splitamount : SplitAmount = self.values[indexPath!.row].splitAmount![i]

                    if splitamount.network!.contains("MASTER") {
                    controller.titleStr = "MASTER"
                    controller.referencNum = splitamount.refNo
                        controller.netamt = splitamount.netAmount
                        controller.mdrrate = splitamount.mdr
                        controller.totalAmt = splitamount.totalAmount

                    //cell.lblMaster.attributedText = cell.lblMaster.text?.attributedString(fontsize: 13)
                }

                }
            }

            }
            
            self.presentAsStork(controller, height: 300, cornerRadius:CGFloat.CornerRadius.popup.radius, showIndicator: false, showCloseButton: false)
        }}
         
    @objc func showKnetDetailBtn(_ sender: UIButton){
        let ButtonPosition = sender.convert(CGPoint.zero, to: tvRef)
        let indexPath = tvRef.indexPathForRow(at: ButtonPosition)
        if indexPath != nil {
            let ButtonPosition = sender.convert(CGPoint.zero, to: tvRef)
            let indexPath = tvRef.indexPathForRow(at: ButtonPosition)
            if indexPath != nil {
                let controller = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CreditPopupViewController") as? CreditPopupViewController)!
                if let valuess = values[indexPath!.row].splitAmount?.count{
                    
                if valuess > 0{
                    for i in 0..<self.values[indexPath!.row].splitAmount!.count{
                        let splitamount : SplitAmount = self.values[indexPath!.row].splitAmount![i]

                        if splitamount.network!.contains("KNET") {
                        controller.titleStr = "KNET"
                        controller.referencNum = splitamount.refNo
                            controller.netamt = splitamount.netAmount
                            controller.mdrrate = splitamount.mdr
                            controller.totalAmt = splitamount.totalAmount

                        //cell.lblMaster.attributedText = cell.lblMaster.text?.attributedString(fontsize: 13)
                    }

                    }
                }

                }
                
                self.presentAsStork(controller, height: 300, cornerRadius:CGFloat.CornerRadius.popup.radius, showIndicator: false, showCloseButton: false)

            }
         
    }
    }
    @objc func showGccDetailBtn(_ sender: UIButton){
        let ButtonPosition = sender.convert(CGPoint.zero, to: tvRef)
        let indexPath = tvRef.indexPathForRow(at: ButtonPosition)
        if indexPath != nil {
            

            let ButtonPosition = sender.convert(CGPoint.zero, to: tvRef)
            let indexPath = tvRef.indexPathForRow(at: ButtonPosition)
            if indexPath != nil {
                let controller = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CreditPopupViewController") as? CreditPopupViewController)!
                if let valuess = values[indexPath!.row].splitAmount?.count{
                    
                if valuess > 0{
                    for i in 0..<self.values[indexPath!.row].splitAmount!.count{
                        let splitamount : SplitAmount = self.values[indexPath!.row].splitAmount![i]

                        if splitamount.network!.contains("GCC") {
                        controller.titleStr = "GCC"
                        controller.referencNum = splitamount.refNo
                            controller.netamt = splitamount.netAmount
                            controller.mdrrate = splitamount.mdr
                            controller.totalAmt = splitamount.totalAmount

                        //cell.lblMaster.attributedText = cell.lblMaster.text?.attributedString(fontsize: 13)
                    }

                    }
                }

                }
                
                self.presentAsStork(controller, height: 300, cornerRadius:CGFloat.CornerRadius.popup.radius, showIndicator: false, showCloseButton: false)

    }
        }}
    @objc func showEzpayDetailBtn(_ sender: UIButton){
        
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 

    }
    
}
