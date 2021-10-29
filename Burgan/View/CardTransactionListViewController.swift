//
//  CardTransactionListViewController.swift
//  Burgan
//
//  Created by Malti Maurya on 20/03/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
class CardTransactionListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tbTransactions: UITableView!
    
    var startDate : String = ""
    var endDate : String = ""
    var cardType : String = ""
    var txnStatus : String = ""
    var fileName : String = ""
    var noOfContact : String = ""
    var titleStr : String = ""
    var isFromPayment: Bool = false
    var bulkTransactionData = BulkPaymentTransactionApi()
    var bulkSmsRefId : String = ""
    
    
    @IBOutlet weak var lblTitles: UILabel!
    
    ///Top segment Control
    @IBOutlet var segmentCtrlRef: UISegmentedControl!
    @IBOutlet var segmentViewHeightRef: NSLayoutConstraint!
    @IBOutlet var segmentOutsideViewRef: UIView!
    
    @IBOutlet var bulkTransactionViewAllViewRef: UIView!
    @IBOutlet var bulkTransactionViewAllViewHeightRef: NSLayoutConstraint!
    @IBOutlet var bulkTransactionViewAllContactsLblRef: UILabel!
    @IBOutlet var bulkTransactionViewAllFileNameLblRef: UILabel!
    
    //DATE DROP DOWN VIEW
    @IBOutlet weak var dateViewRef: UIView!
    @IBOutlet weak var btnSelectMonth: UIButton!
    @IBOutlet weak var dateViewHeightRef: UIView!
    
    //TOP BAR OUTLETS
    @IBOutlet weak var searchBtnRef: UIButton!
    @IBOutlet weak var searchViewRef: UIView!
    @IBOutlet weak var searchTfRef: UITextField!
    @IBOutlet weak var topBarViewRef: UIView!
    @IBOutlet weak var backBtnRef: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTitles.text = titleStr
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Search"
        searchTfRef.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.networkStatusChanged(_:)), name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        definesPresentationContext = true
        
        
        self.loopThroughSubViewAndMirrorImage(subviews: self.view.subviews)
        
        
        self.navigationController?.isNavigationBarHidden = true
        self.viewModel = RegistrationViewControllerViewModel()
        
        //        if AppConstants.UserData.merchantRole == "Admin"{
        //            corporateTranDetailReq()
        //        }else{
        //            merchantTranDetailReq()
        //        }
        
        if isFromPayment{
            callBulkHistoryAPI()
        }else{
            if AppConstants.UserData.merchantRole == "Admin"
            {
                if AppConstants.isCif {
                    corporateTranDetailReq()
                } else {
                    merchantTranDetailReq()
                }
            } else {
                merchantTranDetailReq()
            }
        }
        
        bulkTransactionViewAllFileNameLblRef.text = fileName
        bulkTransactionViewAllContactsLblRef.text = noOfContact
        //Segment
        
        //if cardtype = bulkTransactionViewAll
        bulkTransactionViewAllViewRef.layer.cornerRadius = 6
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchViewRef.isHidden = true
        if cardType == "debit"{
            
            bulkTransactionViewAllViewHeightRef.constant = 0
            bulkTransactionViewAllViewRef.isHidden = true
            
            let items = ["All","POS","Ecomm","Tijarati"]
            
            segmentCtrlRef.replaceSegments(segments: items)
            segmentCtrlRef.selectedSegmentIndex = 0
            DispatchQueue.main.async {
                self.segmentCtrlRef.setupSegment()
            }
            
        }else if cardType == "credit"{
            
            bulkTransactionViewAllViewHeightRef.constant = 0
            bulkTransactionViewAllViewRef.isHidden = true
            
            let items = ["All","POS","Ecomm","Tijarati"]
            
            segmentCtrlRef.replaceSegments(segments: items)
            segmentCtrlRef.selectedSegmentIndex = 0
            DispatchQueue.main.async {
                self.segmentCtrlRef.setupSegment()
            }
            
            
        }else if cardType == "POS"{
            
            bulkTransactionViewAllViewHeightRef.constant = 0
            bulkTransactionViewAllViewRef.isHidden = true
            
            let items = ["All","POS","Ecomm","Tijarati"]
            
            segmentCtrlRef.replaceSegments(segments: items)
            segmentCtrlRef.selectedSegmentIndex = 0
            DispatchQueue.main.async {
                self.segmentCtrlRef.setupSegment()
            }
            
            
        }else if cardType == "Ecomm"{
            
            bulkTransactionViewAllViewHeightRef.constant = 0
            bulkTransactionViewAllViewRef.isHidden = true
            
            let items = ["All","POS","Ecomm","Tijarati"]
            
            segmentCtrlRef.replaceSegments(segments: items)
            segmentCtrlRef.selectedSegmentIndex = 0
            DispatchQueue.main.async {
                self.segmentCtrlRef.setupSegment()
            }
            
            
        }else if cardType == "ezpay"{
            
            bulkTransactionViewAllViewHeightRef.constant = 0
            bulkTransactionViewAllViewRef.isHidden = true
            
            let items = ["All","POS","Ecomm","Tijarati"]
            
            segmentCtrlRef.replaceSegments(segments: items)
            segmentCtrlRef.selectedSegmentIndex = 0
            DispatchQueue.main.async {
                self.segmentCtrlRef.setupSegment()
            }
            
            
        }
        else if cardType == "bulkTransactionViewAll"{
            
            let items = ["All","Debit Card","Credit Card","Tijarati Pay"]
            
            segmentCtrlRef.replaceSegments(segments: items)
            segmentCtrlRef.selectedSegmentIndex = 0
            DispatchQueue.main.async {
                self.segmentCtrlRef.setupSegment()
            }
            
            
            bulkTransactionViewAllViewHeightRef.constant = 64
            bulkTransactionViewAllViewRef.isHidden = false
            
        } else if cardType == "all" {
            bulkTransactionViewAllViewHeightRef.constant = 0
            bulkTransactionViewAllViewRef.isHidden = true
            
            segmentOutsideViewRef.isHidden = true
            segmentViewHeightRef.constant = 0
            dateViewRef.isHidden = true
            
        }
        
        searchViewRef.isHidden = true
        segmentOutsideViewRef.isHidden = true
        
        let startDate = AppConstants.jsonStartDate.dateFromFormat("yyyy-MM-dd")
        let endDate = AppConstants.jsonEndDate.dateFromFormat("yyyy-MM-dd")
        
        if AppConstants.jsonStartDate == AppConstants.jsonEndDate {
            let selectedDateRange = startDate!.monthh.prefix(3) + " - " + String(endDate!.day) + ", " + endDate!.yearr
            btnSelectMonth.setTitle(selectedDateRange, for: .normal)
            
        } else {
            
            let startDate = startDate!.monthh.prefix(3) + " " + String(startDate!.day) + " - "
            let endDate = endDate!.monthh.prefix(3) + " " + String(endDate!.day) + ", " + endDate!.yearr
            let selectedDateRange = startDate + endDate
            btnSelectMonth.setTitle(selectedDateRange, for: .normal)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Done"
    }
    
    func corporateTranDetailReq(){
        let param : [String : Any] = ["type":"cif",
                                      "cif" : AppConstants.selectedFilter!.cif,
                                      "deviceId" : AppConstants.UserData.deviceID,
                                      "startDate": startDate,
                                      "endDate":endDate,
                                      "cardType" : cardType,
                                      "txnStatus" : txnStatus] //"Success"
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.getTransactionDetails)
        self.bindUI()
    }
    
    func merchantTranDetailReq(){
        
        let merchant : [String]  = ["\(AppConstants.merchantNumber)"]
        
        let param : [String : Any] = ["type":"mid",
                                      "merchantNum" : merchant,
                                      "deviceId" : AppConstants.UserData.deviceID,
                                      "startDate": startDate,
                                      "endDate":endDate,
                                      "cardType" :cardType,
                                      "txnStatus" : txnStatus]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.getTransactionDetails)
        self.bindUI()
    }
    
    var viewModel : RegistrationViewControllerViewModelProtocol?
    
    func decodeResult<T: Decodable>(model: T.Type, result: NSDictionary) -> (model: T?, error: Error?) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
            let modelObject = try JSONDecoder().decode(model.self, from: jsonData)
            return (modelObject, nil)
        } catch let error {
            return (nil, error)
        }
    }
    
    var transactionDetailArray : [Transaction] = []
    
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
                    
                    let status : String = userStatus?.value(forKey: "status") as? String ?? ""
                    
                    if status == "" {
                        
                        if AppConstants.UserData.merchantRole == "Admin"
                        {
                            if AppConstants.isCif {
                                self!.corporateTranDetailReq()
                            } else {
                                self!.merchantTranDetailReq()
                            }
                        } else {
                            self!.merchantTranDetailReq()
                        }
                        
                    } else {
                        
                        let message : String = userStatus?.value(forKey: "message") as! String
                        let status : String = userStatus?.value(forKey: "status") as! String
                        if status == "Success"{
                            let errorCode : String = userStatus?.value(forKey: "errorCode") as! String
                            if errorCode == "L128"{
                                //                                     print(message)
                                if let object =  self?.decodeResult(model: transactionDetailResp.self, result: userStatus!)
                                {
                                    let transactionDetail = object.model
                                    if let transactionArr = transactionDetail?.transaction
                                    {
                                        self!.transactionDetailArray = transactionArr
                                        self!.tbTransactions.reloadData()
                                    }
                                    
                                } else {
                                    self!.showAlertWith(message: AlertMessage(title: "Transactions".localiz(), body: "Invalid Data.".localiz()))
                                }
                                
                            } else {
                                self!.showAlertWith(message: AlertMessage(title: "Transactions".localiz(), body: message.localiz()))
                            }
                            
                        } else {
                            self!.showAlertWith(message: AlertMessage(title: "Transactions".localiz(), body: message.localiz()))
                        }
                        
                    }
                    
                }
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFromPayment ? (bulkTransactionData.transaction?.count ?? 0) : transactionDetailArray.count
    }
    
    func setAmounts(amount : String) -> String{
        return (Double(amount)?.rounded(digits: 3).calculate)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tbTransactionListCell", for: indexPath) as! tbTransactionListCell
        //    cell.lblDate.text = (transactionDetailArray[indexPath.row].date ?? "--")
        if isFromPayment {
            cell.symbolLogo1.isHidden = true
            cell.symbolLogo2.isHidden = true
            
            let object = bulkTransactionData.transaction?[indexPath.row]
            
            cell.lblAmount.text = "KD " + setAmounts(amount: (object?.amount ?? "0.000").replacingOccurrences(of: "-", with: "") )
            
            cell.lblDate.text = "TX ID".localiz() + ": \(object?.txnid ?? "") | " + self.convertDateToSpecificFormat(date: "\(object?.date ?? "") \(object?.time ?? "")", currentFormat: "yyyy-MM-dd HH:mm:ss", desiredFormat: "dd MMM yyyy | HH:mm")
            
            switch object?.network?.lowercased() {
            case "visa":
                cell.symbolLogo1.image = UIImage(named: "visaIcon")
                cell.symbolLogo1.isHidden = false
                break
            case "m/c":
                cell.symbolLogo1.image = UIImage(named: "mastercardIcon")
                cell.symbolLogo1.isHidden = false
                break
            case "bulk":
                cell.symbolLogo1.image = UIImage(named: "bulkIcon")
                cell.symbolLogo1.isHidden = false
                break
            default:
                print("Default...")
            }
            
//            if let status  = object?.txnStatus {
//                if status.contains("Success") {
//                    cell.lblStatus.text =  "Approved".localiz()
//                } else {
//                    cell.lblStatus.text =  status.localiz()
//                }
//            } else {
//                cell.lblStatus.text = "--"
//            }
            
            cell.lblStatus.text = object?.cardNum ?? ""
            
            switch object?.txnStatus?.lowercased() {
            case "success":
                cell.txnStatusIcon.image = UIImage(named: "success")
                break
                
            case "failed":
                cell.txnStatusIcon.image = UIImage(named: "Same color as declined")
                break
                
            case "void":
                cell.txnStatusIcon.image = UIImage(named: "Icon Void")
                break
                
            //            case "inprogress":
            //                cell.txnStatusIcon.image = UIImage(named: "in-progress")
            //                break
            
            case "refund":
                cell.txnStatusIcon.image = UIImage(named: "Icon Refunds")
                break
                
            case "linkexpired":
                cell.txnStatusIcon.image = UIImage(named: "Icon link expired1")
                break
                
            case "linkdeclined":
                cell.txnStatusIcon.image = UIImage(named: "Icon link declined")
                break
                
            default:
                cell.txnStatusIcon.image = UIImage(named: "in-progress")
                break
            }
            
        } else {
            
            cell.symbolLogo1.isHidden = true
            cell.symbolLogo2.isHidden = true
            
            cell.lblAmount.text = "KD " + setAmounts(amount: (transactionDetailArray[indexPath.row].amount ?? "0.000").replacingOccurrences(of: "-", with: "") )
            cell.lblDate.text = "TX ID".localiz() + ": \(transactionDetailArray[indexPath.row].txnid ?? "") | " + self.convertDateToSpecificFormat(date: "\(transactionDetailArray[indexPath.row].date ?? "") \(transactionDetailArray[indexPath.row].time ?? "")", currentFormat: "dd-MM-yyyy HH:mm:ss", desiredFormat: "dd MMM yyyy | HH:mm")
            
//            if let status  = transactionDetailArray[indexPath.row].txnStatus {
//                if status.contains("Success") {
//                    cell.lblStatus.text =  "Approved".localiz()
//                } else {
//                    cell.lblStatus.text =  status.localiz()
//                }
//            } else {
//                cell.lblStatus.text = "--"
//            }
            
            cell.lblStatus.text = transactionDetailArray[indexPath.row].cardNum ?? ""
            
            switch transactionDetailArray[indexPath.row].network?.lowercased() {
            case "visa":
                cell.symbolLogo1.image = UIImage(named: "visaIcon")
                cell.symbolLogo1.isHidden = false
                break
            case "mastercard":
                cell.symbolLogo1.image = UIImage(named: "mastercardIcon")
                cell.symbolLogo1.isHidden = false
                break
            case "bulk":
                cell.symbolLogo1.image = UIImage(named: "bulkIcon")
                cell.symbolLogo1.isHidden = false
                break
            default:
                print("Default...")
            }
            
            switch transactionDetailArray[indexPath.row].txnStatus?.lowercased() {
            case "success":
                cell.txnStatusIcon.image = UIImage(named: "success")
                break
                
            case "failed":
                cell.txnStatusIcon.image = UIImage(named: "Same color as declined")
                break
                
            case "void":
                cell.txnStatusIcon.image = UIImage(named: "Icon Void")
                break
                
            //            case "inprogress":
            //                cell.txnStatusIcon.image = UIImage(named: "in-progress")
            //                break
            
            case "refund":
                cell.txnStatusIcon.image = UIImage(named: "Icon Refunds")
                break
                
            case "linkexpired":
                cell.txnStatusIcon.image = UIImage(named: "Icon link expired1")
                break
                
            case "linkdeclined":
                cell.txnStatusIcon.image = UIImage(named: "Icon link declined")
                break
                
            default:
                cell.txnStatusIcon.image = UIImage(named: "in-progress")
                break
            }
            
            // cell.lblAmount.attributedText = cell.lblAmount.text!.attributedString(fontsize: 17)
            
        }
        
        cell.lblAmount.attributedText = cell.lblAmount.text?.attributedString(fontsize: 15)
        
        if AppConstants.language == .ar {
            
            cell.lblStatus.textAlignment = .right
            cell.lblDate.textAlignment = .right
            cell.lblAmount.textAlignment = .left
        } else {
            cell.lblStatus.textAlignment = .left
            cell.lblDate.textAlignment = .left
            cell.lblAmount.textAlignment = .right
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.txnStatus == "LinkDeclined" || self.txnStatus == "LinkExpired" || self.txnStatus == "inProgress" || (self.cardType == "ezpay" && self.txnStatus == "Success") {
            goToDetailPage(object: transactionDetailArray[indexPath.row])
            
        } else if isFromPayment {
            let vc = UIStoryboard(name: "Payment", bundle: nil).instantiateViewController(withIdentifier: "TransactionsDetailViewController") as! TransactionsDetailViewController
            vc.modalPresentationStyle = .currentContext
            let object = bulkTransactionData.transaction?[indexPath.row]
            vc.amountValue = "KD " + setAmounts(amount: object?.amount ?? "0.000")
            vc.paymentModeValue = object?.network ?? ""
            vc.dateValue = convertDateToSpecificFormat(date: object?.date ?? "", currentFormat: "yyyy-MM-dd", desiredFormat: "dd MMM yyyy")
            vc.timeValue = convertDateToSpecificFormat(date: object?.time ?? "", currentFormat: "HH:mm:ss", desiredFormat: "hh:mm a")
            vc.transactionIdValue = object?.txnid ?? ""
            vc.contackNumberValue = object?.mobileNum ?? ""
            vc.statusValue = object?.txnStatus ?? ""
            vc.descriptionValue = object?.transactionDescription ?? ""
            vc.paymentURL = object?.paymentURL ?? ""
            vc.emailIdValue = object?.email ?? ""
            vc.fileNameValue = object?.fileName ?? ""
            vc.payerNameValue = object?.payerName ?? ""
            self.present(vc, animated: true, completion: nil)
            
        } else {
            let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PrintTransactionViewController") as? PrintTransactionViewController
            controller?.popupType = 1
            controller?.transactionInfo = transactionDetailArray[indexPath.row]
            presentAsStork(controller!, height: 470, cornerRadius: 8, showIndicator: false, showCloseButton: false)
        }
    }
    
    func goToDetailPage(object: Transaction) {
        let vc = UIStoryboard(name: "Payment", bundle: nil).instantiateViewController(withIdentifier: "TransactionsDetailViewController") as! TransactionsDetailViewController
        vc.modalPresentationStyle = .popover
        vc.amountValue = "KD " + setAmounts(amount: object.amount ?? "0.000")
        vc.paymentModeValue = object.network ?? ""
        vc.dateValue = convertDateToSpecificFormat(date: object.date ?? "", currentFormat: "yyyy-MM-dd", desiredFormat: "dd MMM yyyy")
        vc.timeValue = convertDateToSpecificFormat(date: object.time ?? "", currentFormat: "HH:mm:ss", desiredFormat: "hh:mm a")
        vc.transactionIdValue = object.txnid ?? ""
        vc.contackNumberValue = object.mobileNum ?? ""
        vc.statusValue = object.txnStatus ?? ""
        vc.descriptionValue = object.transactionDescription ?? ""
        vc.paymentURL = object.paymentURL ?? ""
        vc.emailIdValue = object.email ?? ""
        vc.payerNameValue = object.payerName ?? ""
        self.present(vc, animated: true, completion: nil)
    }
    
    func convertDateToSpecificFormat(date: String, currentFormat: String, desiredFormat: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en")
        inputFormatter.dateFormat = currentFormat
        let showDate = inputFormatter.date(from: date)
        inputFormatter.dateFormat = desiredFormat
        let resultString = inputFormatter.string(from: showDate ?? Date())
        return resultString
    }
    
    func convertDateToFormat(date: Date, desiredFormat: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en")
        inputFormatter.dateFormat = desiredFormat
        let resultString = inputFormatter.string(from: date)
        return resultString
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchBtnTap(_ sender: UIButton){
        dateViewRef.isHidden = true
        
        searchViewRef.isHidden = false
        if cardType == "all"{
            segmentOutsideViewRef.isHidden = true

        } else {
            segmentOutsideViewRef.isHidden = false
        }
    }
    
    @IBAction func searchBackButtonTapped(_ sender: Any) {
        
        searchViewRef.isHidden = true
        segmentOutsideViewRef.isHidden = true
    }
    
    @IBAction func printTransactions(_ sender: Any) {
        let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PrintTransactionViewController") as? PrintTransactionViewController
        controller?.popupType = 0
        presentAsStork(controller!, height: 350, cornerRadius: 8, showIndicator: false, showCloseButton: false)
    }
    
}

extension CardTransactionListViewController{
    
    func callBulkHistoryAPI(){
        viewModel = RegistrationViewControllerViewModel()
        
//        let param : [String : Any] = [
//            "cif" : AppConstants.UserData.companyCIF,
//            "deviceId": AppConstants.UserData.deviceID,
//            "startDate" : AppConstants.jsonStartDate,
//            "endDate" : AppConstants.jsonEndDate,
//            "cardType" : "BULKSMSTXN",
//            "txnStatus": "Success",
//            "BulkSmsRefId": self.bulkSmsRefId
//        ]
        
        if AppConstants.UserData.merchantRole == "Admin"
        {
            if AppConstants.isCif {
                let param : [String : Any] = [
                    "type":"cif",
                    "cif" : AppConstants.UserData.companyCIF,
                    "deviceId": AppConstants.UserData.deviceID,
                    "startDate" : AppConstants.jsonStartDate,
                    "endDate" : AppConstants.jsonEndDate,
                    "cardType" : "BULKSMSTXN",
                    "txnStatus": "Success",
                    "BulkSmsRefId": self.bulkSmsRefId
                ]
                MBProgressHUD.showAdded(to: self.view, animated: true)
                
                self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.bulkTransaction)
                bulkTransactionApi()
            } else {
                let merchant : [String]  = ["\(AppConstants.merchantNumber)"]
                let param : [String : Any] = ["type":"mid",
                                              "merchantNum" : merchant,
                                              "deviceId" : AppConstants.UserData.deviceID,
                                              "startDate": startDate,
                                              "endDate": endDate,
                                              "cardType" : "BULKSMSTXN",
                                              "txnStatus" : txnStatus,
                                              "BulkSmsRefId": self.bulkSmsRefId
                ]
                
                MBProgressHUD.showAdded(to: self.view, animated: true)
                
                self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.bulkTransaction)
                bulkTransactionApi()
            }
        } else {
            let merchant : [String]  = ["\(AppConstants.merchantNumber)"]
            let param : [String : Any] = ["type":"mid",
                                          "merchantNum" : merchant,
                                          "deviceId" : AppConstants.UserData.deviceID,
                                          "startDate": startDate,
                                          "endDate": endDate,
                                          "cardType" : "BULKSMSTXN",
                                          "txnStatus" : txnStatus,
                                          "BulkSmsRefId": self.bulkSmsRefId
            ]
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.bulkTransaction)
            bulkTransactionApi()
        }
        
        
//        MBProgressHUD.showAdded(to: self.view, animated: true)
//
//        self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.bulkTransaction)
//        bulkTransactionApi()
    }
    
    func bulkTransactionApi(){
        
        self.viewModel?.alertMessage.bind({ [weak self] in
            MBProgressHUD.hide(for: self!.view, animated: true)
            self?.showAlertDismissOnly(message: $0)
        })
        
        
        self.viewModel?.response.bind({ [weak self] in
            
            if let response = $0 {
                
                MBProgressHUD.hide(for: self!.view, animated: true)
                if   let userStatus = DataDecryption().decryption(jsonModel: PayloadRes(iv: response.iv, payload: response.payload))
                {
                    let status : String = userStatus.value(forKey: "status") as? String ?? ""
                    if status == "" {
                        /*
                        let param : [String : Any] = [
                            "cif" : AppConstants.UserData.companyCIF,
                            "deviceId": AppConstants.UserData.deviceID,
                            "startDate" : AppConstants.jsonStartDate,
                            "endDate" : AppConstants.jsonEndDate,
                            "cardType" : "BULKSMSTXN",
                            "txnStatus": "Success",
                            "BulkSmsRefId": self?.bulkSmsRefId ?? ""
                        ]
                        
                        MBProgressHUD.showAdded(to: self!.view, animated: true)
                        self!.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.bulkTransaction)
                        self!.bulkTransactionApi()
                        */
                        
                        self?.callBulkHistoryAPI()
                        
                    } else {
                        
                        let message : String = userStatus.value(forKey: "message") as! String
                        let status : String = userStatus.value(forKey: "status") as! String
                        if status == "Success"{
                            let errorCode : String = userStatus.value(forKey: "errorCode") as! String
                            if errorCode == "L128"{
                                print("Message:-\(message)")
                                let object = self!.decodeResult(model: BulkPaymentTransactionApi.self, result: userStatus)
                                if let objectModel = object.model{
                                    self?.bulkTransactionData = objectModel
                                }
                                print("MYDATA:- \(userStatus.allKeys)")
                                
                                DispatchQueue.main.async {
                                    self?.reloadTable()
                                }
                                
                            }
                            
                        } else {
                            self!.showAlertWith(message: AlertMessage(title: "Transactions".localiz(), body: message.localiz()))
                        }
                    }
                    
                }
                
            } else {
                self!.showAlertWith(message: AlertMessage(title: "Tijarati".localiz(), body: "Sorry, Failed to load data.".localiz()))
            }
            
        })
        
    }
    
    func reloadTable(){
        if bulkTransactionData.transaction?.count != 0 && bulkTransactionData.transaction?.count != nil{
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tbTransactions.bounds.size.width, height: tbTransactions.bounds.size.height))
            noDataLabel.text          = ""
            tbTransactions.backgroundView  = noDataLabel
        }else{
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tbTransactions.bounds.size.width, height: tbTransactions.bounds.size.height))
            noDataLabel.text          = "No Data Available".localiz()
            noDataLabel.textColor     = .black
            noDataLabel.textAlignment = .center
            noDataLabel.numberOfLines = 0
            tbTransactions.backgroundView  = noDataLabel
            tbTransactions.isScrollEnabled = false
        }
        tbTransactions.reloadData()
    }
    
}

extension CardTransactionListViewController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let invocation = IQInvocation(self, #selector(didPressOnDoneButton))
        searchTfRef.keyboardToolbar.doneBarButton.invocation = invocation
    }
    
    @objc func didPressOnDoneButton() {
        searchTfRef.resignFirstResponder()
        if searchTfRef.text != ""{
            searchTranDetailReq()
        }
    }
    
    func searchTranDetailReq(){
        let merchant : [String]  = ["\(AppConstants.merchantNumber)"]
        
        let param : [String : Any] = ["type":"cif",
                                      "cif" : AppConstants.selectedFilter!.cif,
                                      "merchantNum":merchant,
                                      "deviceId" : AppConstants.UserData.deviceID,
                                      "startDate": startDate,
                                      "endDate":endDate,
                                      "cardType" : cardType,
                                      "txnStatus" : txnStatus,
                                      "search":searchTfRef.text ?? ""] //"Success"
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.getTransactionDetails)
        self.bindSearchUI()
    }
    
    private func bindSearchUI() {
        
        self.viewModel?.alertMessage.bind({ [weak self] in
            MBProgressHUD.hide(for: self!.view, animated: true)
            self?.showAlertDismissOnly(message: $0)
        })
        
        self.viewModel?.response.bind({ [weak self] in
            
            if let response = $0 {
                
                MBProgressHUD.hide(for: self!.view, animated: true)
                let userStatus = DataDecryption().decryption(jsonModel: PayloadRes(iv: response.iv, payload: response.payload))
                
                if userStatus != nil {
                    let message : String = userStatus?.value(forKey: "message") as! String
                    let status : String = userStatus?.value(forKey: "status") as! String
                    if status == "Success"{
                        let errorCode : String = userStatus?.value(forKey: "errorCode") as! String
                        if errorCode == "L128"{
                            //                                     print(message)
                            if let object =  self?.decodeResult(model: transactionDetailResp.self, result: userStatus!){
                                print(object)
                            } else {
                                self!.showAlertWith(message: AlertMessage(title: "Transactions".localiz(), body: "Invalid Data.".localiz()))
                            }
                            
                        } else {
                            self!.showAlertWith(message: AlertMessage(title: "Transactions".localiz(), body: message.localiz()))
                        }
                    } else {
                        self!.showAlertWith(message: AlertMessage(title: "Transactions".localiz(), body: message.localiz()))
                    }
                    
                    
                    
                }
            }
        })
    }
    
}

//MARK:- SEGMENT ACTION
extension CardTransactionListViewController{
    @IBAction func segmentValueChange(_ sender: UISegmentedControl){
        segmentCtrlRef.changeUnderlinePosition()
        
        if cardType == "debit"{
            
            //let items = ["All","POS","Ecomm","Tijarati"]
            
            switch segmentCtrlRef.selectedSegmentIndex{
            case 0:
                print("")
            case 1:
                print("")
            case 2:
                print("")
                
            case 3:
                print("")
                
            default:
                break
            }
            
        }else if cardType == "credit"{
            
            
            
            //let items = ["All","POS","Ecomm","Tijarati"]
            
            switch segmentCtrlRef.selectedSegmentIndex{
            case 0:
                print("")
            case 1:
                print("")
            case 2:
                print("")
                
            case 3:
                print("")
                
            default:
                break
            }
            
            
        }else if cardType == "POS"{
            
            
            //let items = ["All","POS","Ecomm","Tijarati"]
            
            switch segmentCtrlRef.selectedSegmentIndex{
            case 0:
                print("")
            case 1:
                print("")
            case 2:
                print("")
                
            case 3:
                print("")
                
            default:
                break
            }
            
            
        }else if cardType == "Ecomm"{
            
            
            
            //let items = ["All","POS","Ecomm","Tijarati"]
            
            switch segmentCtrlRef.selectedSegmentIndex{
            case 0:
                print("")
            case 1:
                print("")
            case 2:
                print("")
                
            case 3:
                print("")
                
            default:
                break
            }
            
            
        }else if cardType == "Tijarati"{
            
            //let items = ["All","POS","Ecomm","Tijarati"]
            
            switch segmentCtrlRef.selectedSegmentIndex{
            case 0:
                print("")
            case 1:
                print("")
            case 2:
                print("")
                
            case 3:
                print("")
                
            default:
                break
            }
            
            
        }
        else if cardType == "bulkTransactionViewAll"{
            
            //let items = ["All","Debit Card","Credit Card","Tijarati Pay"]
            
            switch segmentCtrlRef.selectedSegmentIndex{
            case 0:
                print("")
            case 1:
                print("")
            case 2:
                print("")
                
            case 3:
                print("")
                
            default:
                break
            }
        }
        
        
    }
}

//MARK:- SELECT MONTH BUTTON ACTION
extension CardTransactionListViewController: calendarDelegate{
    func selectDateRange(startDate: Date, endDate: Date) {
        if startDate == endDate {
            AppConstants.jsonStartDate = startDate.stringFromFormat("yyyy-MM-dd")
            AppConstants.jsonEndDate = endDate.stringFromFormat("yyyy-MM-dd")
            let selectedDateRange = startDate.monthh.prefix(3) + " - " + String(startDate.day) + ", " + startDate.yearr
            btnSelectMonth.setTitle(selectedDateRange, for: .normal)
            
        } else {
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en")
            dateFormatter.dateFormat = "yyyy-MM-dd"
            AppConstants.jsonStartDate = dateFormatter.string(from: startDate)
            AppConstants.jsonEndDate = dateFormatter.string(from: endDate)
            
            
            let dateFormat = DateFormatter()
            dateFormat.locale = Locale(identifier: "en")
            dateFormat.dateFormat = "MMM dd"
            let sDate = dateFormat.string(from: startDate)
            let eDate = dateFormat.string(from: endDate)
            btnSelectMonth.setTitle(sDate + " - " + eDate + " " + endDate.yearr, for: .normal)
        }
        
        /*
         let merchant = AppConstants.merchantNumber.map { String($0) }
         
         let param : [String : Any] = ["type":"cif",
         "cif" : AppConstants.selectedFilter!.cif,
         "merchantNum" : merchant,
         "deviceId" : AppConstants.UserData.deviceID,
         "startDate":  AppConstants.jsonStartDate, "endDate":AppConstants.jsonEndDate]
         MBProgressHUD.showAdded(to: self.view, animated: true)
         self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.getTransactionSummary)
         self.bindUI()
         */
        
        if isFromPayment{
            callBulkHistoryAPI()
        }else{
            if AppConstants.UserData.merchantRole == "Admin"
            {
                if AppConstants.isCif {
                    corporateTranDetailReq()
                } else {
                    merchantTranDetailReq()
                }
            } else {
                merchantTranDetailReq()
            }
        }
    }
    
    func selectTimeRange(startTimeValue: String, endTimeValue: String, statTimeAMPM: String, endTimeAMPM: String) {
        
    }
    
    @IBAction func selectMonth(_ sender: Any) {
        
        let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CalendarPopupViewController") as? CalendarPopupViewController
        controller?.popuptype = 0
        controller?.calendarClockdelegate = self
        presentAsStork(controller!, height: 650, cornerRadius: 8, showIndicator: false, showCloseButton: false)
    }
}
