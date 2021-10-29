//
//  ProfilePopups.swift
//  Burgan
//
//  Created by Malti Maurya on 25/03/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit
import Alamofire
import SPStorkController
import LanguageManager_iOS



class ProfilePopupsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var feeModuleView: UIView!
    
    @IBOutlet weak var lblknet: UILabel!
    @IBOutlet weak var lblvisamaster: UILabel!
    @IBOutlet weak var lblMonthlyFeeTitle: UILabel!
    @IBOutlet weak var lblInstallationFeeTitle: UILabel!
    @IBOutlet weak var lbltitTitle: UILabel!
    @IBOutlet weak var lblDeviceModelTitle: UILabel!
    @IBOutlet weak var lblFeesRecovered: UILabel!
    @IBOutlet weak var lblTransactionFees: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblDialogTitle: UILabel!
    @IBOutlet weak var notifyView: UIView!
    weak var linkDelegate : popupDelegate?
    weak var alertDelegate : AlertDelegate?
    weak var languageDelegate : LanguageDelegate?
    weak var profileDelegate : profileDelegate?
    @IBOutlet weak var changePinView: UIView!
    @IBOutlet weak var ivChkBxWhatsapp: UIImageView!
    @IBOutlet weak var ivChkBxSMS: UIImageView!
    @IBOutlet weak var tbCompanyListProfile: UITableView!
    @IBOutlet weak var tbMIDLIst: UITableView!
    @IBOutlet weak var lblWhatsapp: UILabel!
    @IBOutlet weak var lblSMS: UILabel!
    var popupType : Int = 0
    var selectAllReports = false
    var trnscationSelected = false
    var settlementSelected = false
    var creditSelected = false
    
    @IBOutlet weak var ivCreditBank: UIImageView!
    @IBOutlet weak var ivSettlement: UIImageView!
    @IBOutlet weak var oldpintitle: UILabel!
    @IBOutlet weak var ivTransction: UIImageView!
    @IBOutlet weak var confirmpintitle: UILabel!
    @IBOutlet weak var ivSelectAllReport: UIImageView!
    @IBOutlet weak var newpintitle: UILabel!
    var viewModel: RegistrationViewControllerViewModelProtocol?
    
    func arabic(){
        lbltitTitle.text = "TID".localiz()
        lblDeviceModelTitle.text =  lblDeviceModelTitle.text!.localiz()
        lblInstallationFeeTitle.text = lblInstallationFeeTitle.text!.localiz()
        lblTransactionFees.text = lblTransactionFees.text!.localiz()
        lblvisamaster.text = lblvisamaster.text!.localiz()
        lblknet.text =  lblknet.text!.localiz()
        lblFeesRecovered.text = lblFeesRecovered.text!.localiz()
        //        btnForgotPIn.setTitle("Forgot PIN ?".localiz(), for: .normal)
        oldpintitle.text = "Old PIN".localiz()
        newpintitle.text = "New PIN".localiz()
        confirmpintitle.text = "Confirm New PIN".localiz()
        
        if AppConstants.language == .ar {
            lblTid.textAlignment = .right
            lblInstallationFee.textAlignment = .right
            lblvisamaster.textAlignment = .right
            lblknet.textAlignment = .right
        } else {
            lblTid.textAlignment = .left
            lblInstallationFee.textAlignment = .left
            lblvisamaster.textAlignment = .left
            lblknet.textAlignment = .left
        }
    }
    
    @IBAction func selectCreditReport(_ sender: Any) {
        
        if(creditSelected){
            creditSelected = false
            ivCreditBank.image = UIImage(named: "ic_checkbox_disabled")
            selectedReports.remove(at: selectedReports.index(of: "Credit To Bank Report")!)
            
            ivSelectAllReport.image = UIImage(named: "ic_checkbox_disabled")
            
        } else {
            
            creditSelected = true
            ivCreditBank.image = UIImage(named: "ic_checkbox_enabled")
            selectAllReports = false
            selectedReports.append("Credit To Bank Report")
            
            if selectedReports.count == 2 {
                ivSelectAllReport.image = UIImage(named: "ic_checkbox_enabled")
            } else {
                ivSelectAllReport.image = UIImage(named: "ic_checkbox_disabled")
            }
        }
    }
    
    @IBAction func selectSettlementReport(_ sender: Any) {
        if(settlementSelected) {
            settlementSelected = false
            ivSettlement.image = UIImage(named: "ic_checkbox_disabled")
            selectedReports.remove(at: selectedReports.index(of: "Settlement Report")!)
        } else {
            settlementSelected = true
            ivSettlement.image = UIImage(named: "ic_checkbox_enabled")
            selectAllReports = false
            ivSelectAllReport.image = UIImage(named: "ic_checkbox_disabled")
            selectedReports.append("Settlement Report")
        }
    }
    
    @IBAction func selectTransctnReport(_ sender: Any) {
        if(trnscationSelected){
            trnscationSelected = false
            selectedReports.remove(at: selectedReports.index(of: "Transaction Report")!)
            ivTransction.image = UIImage(named: "ic_checkbox_disabled")
            
            ivSelectAllReport.image = UIImage(named: "ic_checkbox_disabled")
            
        } else {
            trnscationSelected = true
            ivTransction.image = UIImage(named: "ic_checkbox_enabled")
            selectAllReports = false
            selectedReports.append("Transaction Report")
            
            if selectedReports.count == 2 {
                ivSelectAllReport.image = UIImage(named: "ic_checkbox_enabled")
            } else {
                ivSelectAllReport.image = UIImage(named: "ic_checkbox_disabled")
            }
        }
    }
    
    @IBAction func clearReports(_ sender: Any) {
        selectAllReports = false
        trnscationSelected = false
        ivTransction.image = UIImage(named: "ic_checkbox_disabled")
        settlementSelected = false
        ivSettlement.image = UIImage(named: "ic_checkbox_disabled")
        creditSelected = false
        ivCreditBank.image = UIImage(named: "ic_checkbox_disabled")
        
        ivSelectAllReport.image = UIImage(named: "ic_checkbox_disabled")
        
        selectedReports.removeAll()
    }
    
    @IBAction func selectAllReports(_ sender: Any) {
        
        //        if(selectAllReports){
        //
        //            selectAllReports = false
        //            ivSelectAllReport.image = UIImage(named: "ic_checkbox_disabled")
        //            trnscationSelected = false
        //            ivTransction.image = UIImage(named: "ic_checkbox_disabled")
        //            settlementSelected = false
        //            ivSettlement.image = UIImage(named: "ic_checkbox_disabled")
        //
        //            creditSelected = false
        //            ivCreditBank.image = UIImage(named: "ic_checkbox_disabled")
        //            selectedReports.removeAll()
        //
        //        }else{
        
        selectAllReports = true
        ivSelectAllReport.image = UIImage(named: "ic_checkbox_enabled")
        
        trnscationSelected = true
        ivTransction.image = UIImage(named: "ic_checkbox_enabled")
        
        settlementSelected = true
        ivSettlement.image = UIImage(named: "ic_checkbox_enabled")
        
        creditSelected = true
        ivCreditBank.image = UIImage(named: "ic_checkbox_enabled")
        
        //            selectedReports = ["Transaction Report", "Credit To Bank Report" , "Settlement Report"]
        selectedReports = ["Transaction Report", "Credit To Bank Report"]
        //        }
    }
    @IBOutlet weak var confirmPinView: OTPInputView!
    @IBOutlet weak var changeLanguageview: UIStackView!
    @IBOutlet weak var selectReportView: UIView!
    @IBOutlet weak var btnForgotPIn: UIButton!
    @IBOutlet weak var newPInView: OTPInputView!
    @IBOutlet weak var oldPInView: OTPInputView!
    @IBOutlet weak var ivChkBxEmail: UIImageView!
    
    @IBOutlet weak var myScrollView: UIScrollView!
    
    // MARK: - Keyboard Events
    
    @objc func keyboardWillShow(notification: Notification) {
        
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = myScrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 55
        myScrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        myScrollView.contentInset = contentInset
    }
    
    
    override func viewDidLoad() {   
        super.viewDidLoad()
        
        //NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        arabic()
        popupType(type: popupType)
        
        codeView(codeView: oldPInView, digits: 6)
        codeView(codeView: newPInView, digits: 6)
        codeView(codeView: confirmPinView, digits: 6)
        self.viewModel = RegistrationViewControllerViewModel()
        
        lblTid.text =  "--"
        lblDeviceModel.text = "--"
        lblInstallationFee.text = "0"
        
        lblmonthlkyFee.text = "0"
        lblVisaPercent.text = "0 %"
        lblKNETPercernt.text = "0 %"
        
        if popupType == 5 {
            
            if AppConstants.language == .en {
                
                ivChkBxEnglish.image = UIImage(named: "ic_checkbox_enabled")
                ivChkBxArabic.image = UIImage(named: "ic_checkbox_disabled")
                lblEnglish.textAlignment = .left
                lblArabic.textAlignment = .left
            }else{
                
                ivChkBxEnglish.image = UIImage(named: "ic_checkbox_disabled")
                ivChkBxArabic.image = UIImage(named: "ic_checkbox_enabled")
                lblEnglish.textAlignment = .right
                lblArabic.textAlignment = .right
            }
        }
        
        
        if AppConstants.language == .ar
        {
            oldPInView.transform = CGAffineTransform(scaleX: -1, y: 1)
            newPInView.transform = CGAffineTransform(scaleX: -1, y: 1)
            confirmPinView.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        
        
    }
    
    
    @IBOutlet weak var ivChkBxEnglish: UIImageView!
    @IBOutlet weak var ivChkBxArabic: UIImageView!
    
    @IBOutlet weak var lblEnglish: UILabel!
    @IBOutlet weak var lblArabic: UILabel!
    
    @available(iOS 13.0, *)
    @IBAction func EngLanguage_Btn_Tapped(_ sender: Any) {
        
        ivChkBxEnglish.image = UIImage(named: "ic_checkbox_enabled")
        ivChkBxArabic.image = UIImage(named: "ic_checkbox_disabled")
        
        AppConstants.language = .en
        
        self.languageDelegate?.SelectOnEnglishLanguage()
        
        /*
         // change the language
         LanguageManager.shared.setLanguage(language: .en, viewControllerFactory: { title -> UIViewController in
         
         //            let storyboard = UIStoryboard(name: "Main", bundle: nil)
         //            return storyboard.instantiateViewController(identifier: "RootViewController")
         
         let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
         let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RootViewController") as! RootViewController
         let navigationController = UINavigationController(rootViewController: nextViewController)
         //let appdelegate = UIApplication.shared.delegate as! AppDelegate
         //appdelegate.window!.rootViewController = navigationController
         
         
         return navigationController
         
         }) { view in
         // do custom animation
         view.transform = CGAffineTransform(scaleX: 2, y: 2)
         view.alpha = 0
         }
         */
    }
    
    @available(iOS 13.0, *)
    @IBAction func ArabicLanguage_Btn_Tapped(_ sender: Any) {
        
        ivChkBxEnglish.image = UIImage(named: "ic_checkbox_disabled")
        ivChkBxArabic.image = UIImage(named: "ic_checkbox_enabled")
        
        AppConstants.language = .ar
        
        self.languageDelegate?.SelectOnArabicLanguage()
        
        /*
         // change the language
         LanguageManager.shared.setLanguage(language: .ar, viewControllerFactory: { title -> UIViewController in
         //            let storyboard = UIStoryboard(name: "Main", bundle: nil)
         //            return storyboard.instantiateViewController(identifier: "RootViewController")
         
         let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
         let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RootViewController") as! RootViewController
         let navigationController = UINavigationController(rootViewController: nextViewController)
         //let appdelegate = UIApplication.shared.delegate as! AppDelegate
         //appdelegate.window!.rootViewController = navigationController
         
         
         return navigationController
         
         
         }) { view in
         // do custom animation
         view.transform = CGAffineTransform(scaleX: 2, y: 2)
         view.alpha = 0
         }
         
         //        let controller = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RootViewController") as? RootViewController)!
         //        self.navigationController?.pushViewController(controller, animated: true)
         
         */
    }
    
    
    @IBAction func changePin(_ sender: Any) {
        
        if oldPInView.text == "" || oldPInView.text.isEmpty {
            showAlertDismissOnly(message: AlertMessage(title: "Change PIN".localiz(), body: "Enter old PIN".localiz()))
        } else if newPInView.text == "" || newPInView.text.isEmpty {
            showAlertDismissOnly(message: AlertMessage(title: "Change PIN".localiz(), body: "Enter new PIN".localiz()))
        } else if confirmPinView.text == "" || confirmPinView.text.isEmpty {
            showAlertDismissOnly(message: AlertMessage(title: "Change PIN".localiz(), body: "Enter confirm PIN".localiz()))
        } else if newPInView.text != confirmPinView.text {
            showAlertDismissOnly(message: AlertMessage(title: "Change PIN".localiz(), body: "Confirmation PIN and new PIN should be same".localiz()))
        } else if oldPInView.text.count != 6 {
            showAlertDismissOnly(message: AlertMessage(title: "Change PIN".localiz(), body: "Enter valid old PIN".localiz()))
        } else if newPInView.text.count != 6 {
            showAlertDismissOnly(message: AlertMessage(title: "Change PIN".localiz(), body: "Enter valid new PIN".localiz()))
        } else if confirmPinView.text.count != 6 {
            showAlertDismissOnly(message: AlertMessage(title: "Change PIN".localiz(), body: "Enter valid confirm PIN".localiz()))
        } else {
            
            let deviceID  = UIDevice.current.identifierForVendor!.uuidString
            
            let param : [String : Any] = ["cif" : AppConstants.UserData.cif,
                                          "oldPin" : oldPInView.text,
                                          "newPin" : newPInView.text,
                                          "PinType" : "mPin",
                                          "deviceId" : deviceID]
            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.changePIN)
            self.bindProfileUI()
        }
    }
    
    private func bindProfileUI() {
        self.viewModel?.alertMessage.bind({ [weak self] in
            MBProgressHUD.hide(for: self!.view, animated: true)
            self?.showAlertDismissOnly(message: $0)
        })
        
        
        
        self.viewModel?.response.bind({ [weak self] in
            
            if let response = $0 {
                MBProgressHUD.hide(for: self!.view, animated: true)
                if    let userStatus = DataDecryption().decryption(jsonModel: PayloadRes(iv: response.iv, payload: response.payload)) {
                    
                    let status : String = userStatus.value(forKey: "status") as? String ?? ""
                    
                    if status == "" {
                        
                        let deviceID  = UIDevice.current.identifierForVendor!.uuidString
                        
                        let param : [String : Any] = ["cif" : AppConstants.UserData.cif,
                                                      "oldPin" : self!.oldPInView.text,
                                                      "newPin" : self!.newPInView.text,
                                                      "PinType" : "mPin",
                                                      "deviceId" : deviceID]
                        MBProgressHUD.showAdded(to: self!.view, animated: true)
                        self!.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.changePIN)
                        self!.bindProfileUI()
                        
                    } else {
                        
                        let status : String = userStatus.value(forKey: "status") as! String
                        if (status == "Success") {
                            let errorCode : String = userStatus.value(forKey: "errorCode") as! String
                            
                            if errorCode == "E105" {
                                self?.alertDelegate?.showAlert(msg: "Session expired -- Public key got expired".localiz(), isError: true)
                                self?.dismiss(animated: true, completion: {
                                    
                                })
                            } else if errorCode == "P101" {
                                //                        self?.alertDelegate?.showAlert(msg: "Invalid Request".localiz(), isError: true)
                                //
                                //                        self?.dismiss(animated: true, completion: nil)
                                self?.dismiss(animated: true, completion: {
                                    self?.alertDelegate?.showAlert(msg: "Invalid Request".localiz(), isError: true)
                                })
                                
                            } else if errorCode == "P104" {
                                self?.alertDelegate?.showAlert(msg: "Mobile number registered is invalid or not found.".localiz(), isError: true)
                                self?.dismiss(animated: true, completion: {
                                    
                                })
                            } else if errorCode == "L108" {
                                self?.alertDelegate?.showAlert(msg: "Mobile number not registered.".localiz(), isError: true)
                                self?.dismiss(animated: true, completion: {
                                    
                                })
                            } else if errorCode == "L110" {
                                self?.alertDelegate?.showAlert(msg: "Old pin entered is invalid.".localiz(), isError: true)
                                self?.dismiss(animated: true, completion: {
                                    
                                })
                            } else if errorCode == "P105" {
                                self?.alertDelegate?.showAlert(msg: "Old pin entered is invalid.".localiz(), isError: true)
                                self?.dismiss(animated: true, completion: {
                                    
                                })
                            } else if errorCode == "S101" {
                                
                                self?.alertDelegate?.showAlert(msg: "Successfully updated the PIN.".localiz(), isError: false)
                                self?.dismiss(animated: true, completion: {
                                    
                                })
                                
                            } else if errorCode == "L123" {
                                self?.alertDelegate?.showAlert(msg: "Device Id is not registered.".localiz(), isError: true)
                                self?.dismiss(animated: true, completion: {
                                    
                                })
                            } else {
                                self?.alertDelegate?.showAlert(msg: "Device Id is invalid or null.".localiz(), isError: true)
                                self?.dismiss(animated: true, completion: {
                                    
                                })
                            }
                            
                        } else {
                            
                            let errorCode : String = userStatus.value(forKey: "errorCode") as! String
                            
                            if errorCode == "P101" {
                                //                        self?.alertDelegate?.showAlert(msg: (userStatus.value(forKey: "message") as! String).localiz(), isError: true)
                                self?.dismiss(animated: true, completion: {
                                    self?.alertDelegate?.showAlert(msg: (userStatus.value(forKey: "message") as! String).localiz(), isError: true)
                                })
                            }
                            print(status)
                        }
                    }
                    
                    
                    
                }
            } else {
                MBProgressHUD.hide(for: self!.view, animated: true)
                self!.showAlertWith(message: AlertMessage(title: "Tijarati".localiz(), body: "Sorry, Failed to load data.".localiz()))
            }
        })
        
    }
    
    func codeView(codeView:OTPInputView,digits:Int){
        codeView.numberOfDigits = digits
        
        codeView.bottomBorderColor = UIColor.BurganColor.brandGray.lgiht
        codeView.textColor = UIColor.BurganColor.brandGray.black
        codeView.acceptableCharacters = "0123456789"
        codeView.keyboardType = .numberPad
        codeView.animationType = .none
        
        codeView.font = UIFont.init(name:"Monsterrat-Medium", size: 15)
        
        
    }
    @IBOutlet weak var btnConfirmPIN: UIButton!
    @IBAction func forgotPin(_ sender: Any) {
    }
    
    
    @IBAction func assignReports(_ sender: Any) {
        if popupType == 4{
            if selectedReports.count > 0
            {
                linkDelegate?.showAccessGranted()
                
                linkDelegate?.selectedReports(reports: self.selectedReports)
                self.dismiss(animated: true, completion: nil)
            }else{
                self.showAlertDismissOnly(message: AlertMessage(title: "Select Reports".localiz(), body: "Please assign at least one report to continue".localiz()))
            }
            
        }else{
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBOutlet weak var whatsappBtn: UIButton!
    @IBOutlet weak var emailBtn: UIButton!
    @IBOutlet weak var smsBtn: UIButton!
    
    
    
    var selectedLinks = [String]()
    var whatsappStr = String()
    var emailStr = String()
    var smsStr = String()
    
    @IBAction func selectSMS(_ sender: Any)
    {
        if smsBtn.tag == 0
        {
            smsBtn.tag = 1
            smsStr = "SMS"
            ivChkBxSMS.image = UIImage(named: "ic_checkbox_enabled")
        }
        else{
            smsBtn.tag = 0
            smsStr = ""
            ivChkBxSMS.image = UIImage(named: "ic_checkbox_disabled")
        }
    }
    
    @IBAction func selectWhatsapp(_ sender: Any)
    {
        print(whatsappBtn.tag)
        if whatsappBtn.tag == 0
        {
            whatsappBtn.tag = 1
            whatsappStr = "Whatsapp"
            ivChkBxWhatsapp.image = UIImage(named: "ic_checkbox_enabled")
            
        }
        else{
            whatsappBtn.tag = 0
            whatsappStr = ""
            ivChkBxWhatsapp.image = UIImage(named: "ic_checkbox_disabled")
        }
    }
    var outlet = ""
    @IBOutlet weak var btnSendLink: UIButton!
    @IBAction func selectEmail(_ sender: Any)
    {
        if emailBtn.tag == 0
        {
            emailBtn.tag = 1
            emailStr = "Email"
            ivChkBxEmail.image = UIImage(named: "ic_checkbox_enabled")
        } else {
            emailBtn.tag = 0
            emailStr = ""
            ivChkBxEmail.image = UIImage(named: "ic_checkbox_disabled")
        }
    }
    
    var merchant : [String] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tbCompanyListProfile {
            if AppConstants.locationFilterData != nil {
                return AppConstants.locationFilterData!.filterData.count
            }else{
                return 0
            }
        }else{
            return merchant.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tbCompanyListProfile {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tbCompanyListProfileCell", for: indexPath) as! tbCompanyListProfileCell
            cell.lblName.text = AppConstants.locationFilterData!.filterData[indexPath.row].companyName
            if AppConstants.language == .ar{
                cell.lblName.textAlignment = NSTextAlignment.right
            }else{
                cell.lblName.textAlignment = NSTextAlignment.left
            }
            cell.lblStoreCount.text = String(AppConstants.locationFilterData!.filterData[indexPath.row].hierarchy.count)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "tbMIDListCell", for: indexPath) as! tbMIDListCell
            cell.lblMIDName.text = merchant[indexPath.row]
            
            if AppConstants.language == .ar{
                cell.lblMIDName.textAlignment = NSTextAlignment.right
            }else{
                cell.lblMIDName.textAlignment = NSTextAlignment.left
            }
            
            for subView in cell.subviews {
                if subView is UIButton && subView.tag == 999 {
                    let btn = subView as! UIButton
                    
                    btn.imageView?.transform = AppConstants.language == .ar ? CGAffineTransform(scaleX: -1, y: 1) : CGAffineTransform(scaleX: 1, y: 1)
                }
                
                if subView is UIImageView && subView.tag == 999 {
                    let imgView = subView as! UIImageView
                    
                    imgView.transform = AppConstants.language == .ar ? CGAffineTransform(scaleX: -1, y: 1) : CGAffineTransform(scaleX: 1, y: 1)
                }
                
                loopThroughSubViewAndMirrorImage(subviews: subView.subviews)
            }
            
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tbCompanyListProfile {
            let cell = tableView.cellForRow(at: indexPath) as! tbCompanyListProfileCell
            cell.selectRow()
            profileDelegate?.selectedLocation(heirarchy: AppConstants.locationFilterData!.filterData[indexPath.row].hierarchy, companyName: AppConstants.locationFilterData!.filterData[indexPath.row].companyName)
            self.dismiss(animated: true, completion: nil)
        }else{
            
            let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProfilePopupsViewController") as? ProfilePopupsViewController
            controller!.popupType = 1
            controller!.outlet = merchant[indexPath.row]
            presentAsStork(controller!, height: 600, cornerRadius: 10, showIndicator: false, showCloseButton: false)
            
        }
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if tableView == tbCompanyListProfile {
            let cell = tableView.cellForRow(at: indexPath) as! tbCompanyListProfileCell
            cell.deselectRow()
        }
    }
    
    @IBAction func sendLink(_ sender: Any) {
        
        if smsStr != ""
        {
            selectedLinks.append(smsStr)
        }
        
        if emailStr != ""
        {
            selectedLinks.append(emailStr)
        }
        
        if whatsappStr != ""
        {
            selectedLinks.append(whatsappStr)
        }
        
        if selectedLinks.count > 0
        {
            linkDelegate?.showLinkSent(Links: selectedLinks)
            self.dismiss(animated: true, completion: nil)
        }
        else
        {
            print("select at least one")
        }
        
        
        
    }
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func feeDetailRequest(){
        self.viewModel = RegistrationViewControllerViewModel()
        let param : [String : Any] = ["cif" : AppConstants.UserData.cif,
                                      "deviceId" : AppConstants.UserData.deviceID,
                                      "outletNumber" : outlet]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.getFeeDetails)
        self.bindUI()
        
    }
    func decodeResult<T: Decodable>(model: T.Type, result: NSDictionary) -> (model: T?, error: Error?) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
            let modelObject = try JSONDecoder().decode(model.self, from: jsonData)
            return (modelObject, nil)
        } catch let error {
            return (nil, error)
        }
    }
    private func bindUI() {
        
        self.viewModel?.alertMessage.bind({ [weak self] in
            MBProgressHUD.hide(for: self!.view, animated: true)
            self?.showAlertDismissOnly(message: $0)
        })
        
        
        
        self.viewModel?.response.bind({ [weak self] in
            
            if let response = $0 {
                MBProgressHUD.hide(for: self!.view, animated: true)
                let userStatus = DataDecryption().decryption(jsonModel: PayloadRes(iv: response.iv, payload: response.payload))
                
                if userStatus != nil {
                    
                    let status : String = userStatus!.value(forKey: "status") as? String ?? ""
                    
                    if status == "" {
                        self?.feeDetailRequest()
                    } else {
                        
                        var message = ""
                        
                        if   let msg  = userStatus?.value(forKey: "message")
                        {
                            message = msg as! String
                        }
                        //                                                 let status : String = userStatus?.value(forKey: "status") as! String
                        //                                                 if status == "Success"{
                        //                                                     let errorCode : String = userStatus?.value(forKey: "errorCode") as! String
                        //                                                  if errorCode == "S101"{
                        
                        //                                                      print(message)
                        
                        self!.lblTid.text =  self!.outlet
                        self!.lblDeviceModel.text = userStatus?.value(forKey: "deviceModel") as? String
                        let kd = "KD "
                        let insatllationFee = userStatus?.value(forKey: "installationFee") as! String
                        let monthlyFee = userStatus?.value(forKey: "monthRent") as! String
                        
                        self!.lblInstallationFee.text = kd + insatllationFee
                        self?.lblInstallationFee.attributedText = self?.lblInstallationFee.text?.attributedString(fontsize: 12)
                        
                        self!.lblmonthlkyFee.text = kd + monthlyFee
                        self?.lblmonthlkyFee.attributedText = self?.lblmonthlkyFee.text?.attributedString(fontsize: 12)
                        
                        self!.lblVisaPercent.text = userStatus?.value(forKey: "transactionFee_Others") as! String + " %"
                        
                        //self!.lblKNETPercernt.text = userStatus?.value(forKey: "transactionFee_KNET") as! String  + " %"
                        
                        self?.lblKNETPercernt.text = "KD " + setAmounts(amount: "\(userStatus?.value(forKey: "transactionFee_KNET") as! String)")
                        self?.lblKNETPercernt.attributedText = self!.lblKNETPercernt.text?.attributedString(fontsize: 12)
                        
                    }
                    
                    
                    
                }
                
                //  }
                //}
            }
            
        })
        
    }
    
    
    @IBOutlet weak var lblmonthlkyFee: UILabel!
    @IBOutlet weak var lblKNETPercernt: UILabel!
    @IBOutlet weak var lblVisaPercent: UILabel!
    @IBOutlet weak var lblInstallationFee: UILabel!
    @IBOutlet weak var lblDeviceModel: UILabel!
    @IBOutlet weak var lblTid: UILabel!
    func popupType(type: Int) {
        switch type {
        case 0:
            
            showPopup(title: "Select Company".localiz(), selectMIDPopup: true, notifyPopup: true, feeModulePopup: true, selectReportsPopup: true, selectLanguagePopup: true, selectCompany: false, changePinPopup: true)
            
        case 1:
            
            showPopup(title: "Fee Module".localiz(), selectMIDPopup: true, notifyPopup: true, feeModulePopup: false, selectReportsPopup: true, selectLanguagePopup: true, selectCompany: true, changePinPopup: true)
            feeDetailRequest()
            
        case 2:
            
            showPopup(title: "Notify Via", selectMIDPopup: true, notifyPopup: false, feeModulePopup: true, selectReportsPopup: true, selectLanguagePopup: true, selectCompany: true, changePinPopup: true)
            
        case 3:
            
            showPopup(title: "Select TID", selectMIDPopup: false, notifyPopup: true, feeModulePopup: true, selectReportsPopup: true, selectLanguagePopup: true, selectCompany: true, changePinPopup: true)
            tbMIDLIst.reloadData()
        case 4:
            showPopup(title: "Select Reports", selectMIDPopup: true, notifyPopup: true, feeModulePopup: true, selectReportsPopup: false, selectLanguagePopup: true, selectCompany: true, changePinPopup: true)
        case 5:
            showPopup(title: "Change Language", selectMIDPopup: true, notifyPopup: true, feeModulePopup: true, selectReportsPopup: true, selectLanguagePopup: false, selectCompany: true, changePinPopup: true)
        case 6:
            
            showPopup(title: "Change PIN".localiz(), selectMIDPopup: true, notifyPopup: true, feeModulePopup: true, selectReportsPopup: true, selectLanguagePopup: true, selectCompany: true, changePinPopup: false)
        default:
            
            break;
        }
    }
    
    var selectedReports : [String] = []
    func showPopup(title:String, selectMIDPopup:Bool, notifyPopup:Bool, feeModulePopup:Bool, selectReportsPopup:Bool, selectLanguagePopup:Bool, selectCompany:Bool, changePinPopup:Bool){
        tbCompanyListProfile.isHidden = selectCompany
        feeModuleView.isHidden = feeModulePopup
        notifyView.isHidden = notifyPopup
        lblDialogTitle.text = title.localiz()
        tbMIDLIst.isHidden = selectMIDPopup
        selectReportView.isHidden = selectReportsPopup
        changeLanguageview.isHidden = selectLanguagePopup
        changePinView.isHidden = changePinPopup
        
        selectAllReports = false
        ivSelectAllReport.image = UIImage(named: "ic_checkbox_disabled")
        
        trnscationSelected = false
        ivTransction.image = UIImage(named: "ic_checkbox_disabled")
        
        settlementSelected = false
        ivSettlement.image = UIImage(named: "ic_checkbox_disabled")
        
        creditSelected = false
        ivCreditBank.image = UIImage(named: "ic_checkbox_disabled")
        
        if selectedReports.count > 0 {
            
            for obj in selectedReports {
                
                /*
                 switch obj {
                 
                 case "Transaction Report":
                 trnscationSelected = true
                 ivTransction.image = UIImage(named: "ic_checkbox_enabled")
                 break
                 case "Credit To Bank Report":
                 creditSelected = true
                 ivCreditBank.image = UIImage(named: "ic_checkbox_enabled")
                 break
                 case "Settlement Report":
                 settlementSelected = true
                 ivSettlement.image = UIImage(named: "ic_checkbox_enabled")
                 default:
                 print("Default....")
                 }
                 */
                if obj.contains("Transaction Report"){
                    trnscationSelected = true
                    ivTransction.image = UIImage(named: "ic_checkbox_enabled")
                }
                
                if obj.contains("Settlement Report")
                {
                    settlementSelected = true
                    ivSettlement.image = UIImage(named: "ic_checkbox_enabled")
                }
                
                if obj.contains("Credit To Bank Report")
                {
                    creditSelected = true
                    ivCreditBank.image = UIImage(named: "ic_checkbox_enabled")
                }
            }
            
            
            //            if selectedReports.count == 3 {
            if selectedReports.count == 2 {
                selectAllReports = true
                ivSelectAllReport.image = UIImage(named: "ic_checkbox_enabled")
            }
            
        } else {
            
            selectAllReports = true
            ivSelectAllReport.image = UIImage(named: "ic_checkbox_enabled")
            
            trnscationSelected = true
            ivTransction.image = UIImage(named: "ic_checkbox_enabled")
            
            //            settlementSelected = true
            //            ivSettlement.image = UIImage(named: "ic_checkbox_enabled")
            
            creditSelected = true
            ivCreditBank.image = UIImage(named: "ic_checkbox_enabled")
            
            //            selectedReports = ["TransactionReport", "CreditToBank" , "SettlementReport"]
            selectedReports = ["Transaction Report", "Credit To Bank Report"]
            
        }
    }
}
