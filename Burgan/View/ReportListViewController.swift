//
//  ReportListViewController.swift
//  Burgan
//
//  Created by Malti Maurya on 01/04/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit
import SPStorkController

class ReportListViewController : UIViewController, UIGestureRecognizerDelegate, ReportsPopupDelegate{
    
    @IBOutlet weak var lblCreditRprtDate: UILabel!
    @IBOutlet weak var lblSettlmntRprtDate: UILabel!
    @IBOutlet weak var lblTrnsctnRprtDate: UILabel!
    @IBOutlet weak var receiveMailSettlmntRprtView: UIView!
    @IBOutlet weak var receiveMailCreditRprtView: UIView!
    @IBOutlet weak var dwnloadCreditRprtView: UIView!
    @IBOutlet weak var dwnloadSettlmntRprtView: UIView!
    @IBOutlet weak var receiveMailTransctnRprtView: UIView!
    @IBOutlet weak var dwnloadTransactnReprtView: UIView!
    @IBOutlet weak var creditReprtCurvedView: UIView!
    @IBOutlet weak var settlmntReportCurvedView: UIView!
    @IBOutlet weak var transactionReportCurvedView: UIView!
    
    @IBOutlet weak var reportAccessCurvedView: UIView!
    @IBOutlet weak var creditCstmRprtCurvedView: UIView!
    @IBOutlet weak var transctnCstmRprtCurvedView: UIView!
    
    @IBOutlet weak var btnErrOk: GradientLayer!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var errorCurvedView: UIView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var settlmntCstmRprtCurvedView: UIView!
    
    @IBOutlet weak var transactionLbl: UILabel!
    
    @IBAction func errorOK(_ sender: Any) {
        
        errorView.isHidden = true
        
    }
    @IBAction func closeDialog(_ sender: Any) {
        
        errorView.isHidden = true
        
    }
    
    @IBAction func goBack(_ sender: Any) {
        let controller = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RootViewController") as? RootViewController)!
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.networkStatusChanged(_:)), name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        definesPresentationContext = true
        
        
        self.loopThroughSubViewAndAlignTextfieldText(subviews: self.view.subviews)
        self.loopThroughSubViewAndAlignLabelText(subviews: self.view.subviews)
        self.loopThroughSubViewAndMirrorImage(subviews: self.view.subviews)
        
        self.navigationController?.isNavigationBarHidden = true
        curvedviewShadow(view: settlmntCstmRprtCurvedView)
        curvedviewShadow(view: transctnCstmRprtCurvedView)
        curvedviewShadow(view: creditCstmRprtCurvedView)
        curvedviewShadow(view: reportAccessCurvedView)
        curvedviewShadow(view: transactionReportCurvedView)
        curvedviewShadow(view: creditReprtCurvedView)
        curvedviewShadow(view: settlmntReportCurvedView)
        createPanGeustures()
        previousMonthData()
        self.viewModel = RegistrationViewControllerViewModel()
        errorView.isHidden = true
        errorCurvedView.layer.cornerRadius = CGFloat.CornerRadius.popup.radius
        btnErrOk.layer.cornerRadius = CGFloat.CornerRadius.button.radius
        popupShadow(view: errorCurvedView)
        
        transactionLbl.text = "TransactionLbl".localiz()
    }
    
    func popupShadow(view:UIView){
        view.layer.shadowColor = UIColor.BurganColor.brandGray.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        view.layer.shadowOpacity = 1.0
        view.layer.shadowRadius = 10.0
        view.layer.masksToBounds = false
    }
    
    var jsonStartDate = ""
    var jsonEndDate = ""
    
    func previousMonthData(){
        let calendar = Calendar.current
        let currentDate = Date()
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale(identifier: "en")
        dateformatter.dateFormat = "dd MMM, yyyy"
        let jsonDateformatter = DateFormatter()
        jsonDateformatter.locale = Locale(identifier: "en")
        jsonDateformatter.dateFormat = "yyyy-MM-dd"
        var components = calendar.dateComponents([.day, .month, .year], from: currentDate)
        components.month = components.month! - 1
        components.day = 1
        let startDate = calendar.date(from: components)
        let stringStartDate = dateformatter.string(from: startDate!)
        print(stringStartDate)
        jsonStartDate = jsonDateformatter.string(from: startDate!)
        
        
        //        var components1 = calendar.dateComponents([.day, .month, .year], from: currentDate)
        //        components1.month = components1.month!
        //        components1.day = -1
        //        let endDate = calendar.date(from: components1)
        
        var comps2 = DateComponents()
        comps2.month = 1
        comps2.day = -1
        let endDate = Calendar.current.date(byAdding: comps2, to: startDate!)
        print(jsonDateformatter.string(from: endDate!))
        
        let stringEndDate = dateformatter.string(from: endDate!)
        print(stringEndDate)
        jsonEndDate = jsonDateformatter.string(from: endDate!)
        lblTrnsctnRprtDate.text = stringStartDate + " - " + stringEndDate
        lblSettlmntRprtDate.text = stringStartDate + " - " + stringEndDate
        lblCreditRprtDate.text = stringStartDate + " - " + stringEndDate
        print(jsonStartDate)
        print(jsonEndDate)
        
        
    }
    
    func createPanGeustures(){
        
        
        let panTrnsctnMailGesture = UITapGestureRecognizer(target: self, action: #selector(self.mailTransactionReport))
        receiveMailTransctnRprtView.isUserInteractionEnabled = true; self.receiveMailTransctnRprtView.addGestureRecognizer(panTrnsctnMailGesture)
        
        let panTrnsctnDownloadGesture = UITapGestureRecognizer(target: self, action: #selector(self.downloadTransactionReport))
        dwnloadTransactnReprtView.isUserInteractionEnabled = true; self.dwnloadTransactnReprtView.addGestureRecognizer(panTrnsctnDownloadGesture)
        
        let panSettlmntMailGesture = UITapGestureRecognizer(target: self, action: #selector(self.mailSettlementReport))
        receiveMailSettlmntRprtView.isUserInteractionEnabled = true; self.receiveMailSettlmntRprtView.addGestureRecognizer(panSettlmntMailGesture)
        
        
        let panSettlmntDownloadGesture = UITapGestureRecognizer(target: self, action: #selector(self.downloadSettlementReport))
        dwnloadSettlmntRprtView.isUserInteractionEnabled = true; self.dwnloadSettlmntRprtView.addGestureRecognizer(panSettlmntDownloadGesture)
        
        let panCreditMailGesture = UITapGestureRecognizer(target: self, action: #selector(self.mailCreditReport))
        receiveMailCreditRprtView.isUserInteractionEnabled = true; self.receiveMailCreditRprtView.addGestureRecognizer(panCreditMailGesture)
        
        
        let panCreditDownloadGesture = UITapGestureRecognizer(target: self, action: #selector(self.downloadCreditReport))
        self.dwnloadCreditRprtView.addGestureRecognizer(panCreditDownloadGesture)
        
        
        let panTrnsctnReportGesture = UITapGestureRecognizer(target: self, action: #selector(self.generateTransactionReport))
        self.transctnCstmRprtCurvedView.addGestureRecognizer(panTrnsctnReportGesture)
        
        
        let panSettlemntReportGesture = UITapGestureRecognizer(target: self, action: #selector(self.generateSettlementReport))
        self.settlmntCstmRprtCurvedView.addGestureRecognizer(panSettlemntReportGesture)
        
        
        let panCreditReportGesture = UITapGestureRecognizer(target: self, action: #selector(self.generateCreditReport))
        self.creditCstmRprtCurvedView.addGestureRecognizer(panCreditReportGesture)
        
        let panReportAccessGesture = UITapGestureRecognizer(target: self, action: #selector(self.accessReportPermission))
        self.reportAccessCurvedView.addGestureRecognizer(panReportAccessGesture)
    }
    
    @objc func mailTransactionReport(sender: UITapGestureRecognizer){
        
        getReports(isDownload: false, serviceName: RequestItemsType.getTransactionReports, pdfname: "")
    }
    
    @IBAction func MailTransactionReport_Btn_Tapped(_ sender: Any) {
        
        let controller = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ReportsPopupViewController") as? ReportsPopupViewController)!
        controller.delegate = self
        controller.popupType = 2
        controller.endTime = endTime
        controller.startTime = startTime
        controller.jsonStartDate = jsonStartDate
        controller.jsonEndDate = jsonEndDate
        controller.isFrom = "reportlistTran"
        presentAsStork(controller, height: 400, cornerRadius: 8.0, showIndicator: false, showCloseButton: false)
        
    }
    
    func SendMail(type: String) {
        
        if type == "reportlistTran" {
            getReports(isDownload: false, serviceName: RequestItemsType.getTransactionReports, pdfname: "")
        } else {
            getReports(isDownload: false, serviceName: RequestItemsType.getCreditToBankReports, pdfname: "")
        }
    }
    
    @IBAction func MailCreditReport_Btn_Tapped(_ sender: Any) {
        
        let controller = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ReportsPopupViewController") as? ReportsPopupViewController)!
        controller.delegate = self
        controller.popupType = 2
        controller.endTime = endTime
        controller.startTime = startTime
        controller.jsonStartDate = jsonStartDate
        controller.jsonEndDate = jsonEndDate
        controller.isFrom = "reportlistCredit"
        presentAsStork(controller, height: 400, cornerRadius: 8.0, showIndicator: false, showCloseButton: false)
    }
    
    
    @objc func mailCreditReport(sender: UITapGestureRecognizer){
        
        getReports(isDownload: false, serviceName: RequestItemsType.getCreditToBankReports, pdfname: "")
        
    }
    
    @objc func downloadTransactionReport(sender: UITapGestureRecognizer){
        getReports(isDownload: true, serviceName: RequestItemsType.getTransactionReports, pdfname: "Transaction_Report_From_")
        
        
    }
    var viewModel: RegistrationViewControllerViewModelProtocol?
    var startTime = "00:00:00"
    var endTime = "11:59:59"
    var loader = SwiftLoader()
    func getReports(isDownload : Bool, serviceName : EndPointType,pdfname : String)
    {
        var sendEmail = false
        
        if isDownload {
            sendEmail = false
        }else{
            sendEmail = true
        }
        loader.animShow()
        //        let param : [String : Any] = ["cif" : AppConstants.selectedFilter!.cif,
        //                                      "deviceId" :AppConstants.UserData.deviceID,
        //                                      "startDate" : jsonStartDate,
        //                                      "endDate" : jsonEndDate,
        //                                      "startTime" : startTime,
        //                                      "endTime" : endTime,
        //                                      "sendEmail" : sendEmail]
        //         MBProgressHUD.showAdded(to: self.view, animated: true)
        //        self.viewModel?.serviceRequest(param: param, apiName: serviceName)
        //        self.bindUI(isDownload: isDownload, pdfname: pdfname)
        
        //mmmmmmalti
        if AppConstants.UserData.merchantRole == "Admin"
        {
            let param : [String : Any] = ["cif" : AppConstants.selectedFilter!.cif,
                                          "deviceId" :AppConstants.UserData.deviceID,
                                          "startDate" : jsonStartDate,
                                          "endDate" : jsonEndDate,
                                          "startTime" : startTime,
                                          "endTime" : endTime,
                                          "sendEmail" : sendEmail]
            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.viewModel?.serviceRequest(param: param, apiName: serviceName)
            self.bindUI(isDownload: isDownload, pdfname: pdfname, serviceName: serviceName)
            
        } else {
            
            let heirarchyArr : [Hierarchy] = (AppConstants.locationFilterData?.filterData[0].hierarchy)!
            
            var merchantNumber : [Int] = []
            
            for i in 0..<heirarchyArr.count{
                for j in 0..<heirarchyArr[i].brandNameList.count{
                    for k in 0..<heirarchyArr[i].brandNameList[j].locationNameList.count{
                        for l in 0..<heirarchyArr[i].brandNameList[j].locationNameList[k].merchantNumber.count
                        {
                            let m : Int = Int(heirarchyArr[i].brandNameList[j].locationNameList[k].merchantNumber[l].mid)!
                            merchantNumber.append(m)
                        }
                    }
                }
            }
            let merchant = merchantNumber.map { String($0) }
            
            let param : [String : Any] = ["cif" : AppConstants.selectedFilter!.cif,
                                          "deviceId" :AppConstants.UserData.deviceID,
                                          "startDate" : jsonStartDate,
                                          "endDate" : jsonEndDate,
                                          "startTime" : startTime,
                                          "endTime" : endTime,
                                          "sendEmail" : sendEmail,
                                          "merchantNumber" : merchant]
            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.viewModel?.serviceRequest(param: param, apiName: serviceName)
            self.bindUI(isDownload: isDownload, pdfname: pdfname, serviceName: serviceName)
            
        }
    }
    
    func base64ToByteArray(base64String: String) -> [UInt8]? {
        //        if let nsdata = NSData(base64Encoded: base64String, options: []) {
        //              var bytes = [UInt8](count: nsdata.length, repeatedValue: 0)
        //              nsdata.getBytes(&bytes)
        //              return bytes
        //          }
        //          return nil // Invalid input
        
        if let nsdata = Data(base64Encoded: base64String, options: [])
        {
            //            var bytes = [UInt8](repeating: 0, count: nsdata.count)
            return nsdata.bytes
        }
        return nil
    }
    var documentPath  = ""
    private func bindUI(isDownload:Bool,pdfname : String, serviceName : EndPointType) {
        self.viewModel?.alertMessage.bind({ [weak self] in
            MBProgressHUD.hide(for: self!.view, animated: true)
            self?.showAlertDismissOnly(message: $0)
        })
        
        self.viewModel?.response.bind({ [weak self] in
            
            if let response = $0 {
                MBProgressHUD.hide(for: self!.view, animated: true)
                self?.loader.animHide()
                do{
                    if   let userStatus = DataDecryption().decryption(jsonModel: PayloadRes(iv: response.iv, payload: response.payload))
                    {
                        let message = userStatus.value(forKey: "message") as? String ?? ""
                        
                        if message == "" {
                            
                            self?.getReports(isDownload: isDownload, serviceName: serviceName, pdfname: pdfname)
                            
                        } else {
                            
                            let errorCode : String = userStatus.value(forKey: "errorCode") as! String
                            guard let message = userStatus.value(forKey: "message") as? String else{
                                return
                            }
                            
                            if errorCode == "S101" {
                                
                                if isDownload {
                                    
                                    if   let reportData   = userStatus.value(forKey: "reportData") {
                                        
                                        if self!.downloadPDF(data: reportData as! String, reportName: pdfname + self!.jsonStartDate + "_To_" + self!.jsonEndDate) {
                                            DispatchQueue.main.async {
                                                
                                                
                                                //let pdfData = NSData(contentsOfFile: fileUrlPathStr) as Data?
                                                let url = URL(fileURLWithPath: UserDefaults.standard.value(forKey: "docpath") as! String)
                                                
                                                let shareItems:Array = [url]
                                                let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems , applicationActivities: nil)
                                                //activityViewController.excludedActivityTypes = [UIActivityType.print, UIActivityType.postToWeibo, UIActivityType.copyToPasteboard, UIActivityType.addToReadingList, UIActivityType.postToVimeo, UIActivityType.postToFacebook,UIActivityType.postToTwitter]
                                                self?.present(activityViewController, animated: true, completion: nil)
                                                
                                                activityViewController.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
                                                    if completed {
                                                        // Do something
                                                        self!.popupType(type: 0)
                                                    }
                                                }
                                                
                                                
                                            }
                                        } else {
                                            self!.errorView.isHidden = false
                                            self!.lblError.text = "Unable to download reports. Please try again."
                                        }
                                    }
                                    
                                } else {
                                    self!.popupType(type: 1)
                                }
                            } else {
                                
                                self!.errorView.isHidden = false
                                self!.lblError.text = message
                            }
                            
                            //                    print(userStatus)
                            
                        }
                        
                        
                    } else {
                        self!.showAlertWith(message: AlertMessage(title: "Tijarati".localiz(), body: "Sorry, Failed to load data.".localiz()))
                    }
                } catch {
                    print(error)
                }
            }
        })
    }
    
    func downloadPDF(data : String,reportName : String) -> Bool{
        var downloaded = false
        do {
            
            let reportdata = Data(base64Encoded: data, options: .ignoreUnknownCharacters)
            var documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let filePath = "\(documentsPath)/" + reportName + ".xlsx"
            try  reportdata!.write(to: URL(fileURLWithPath: filePath))
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentsDirectory = paths[0]
            print(documentsDirectory)
            documentsPath = filePath
            downloaded = true
            
            UserDefaults.standard.setValue(filePath, forKey: "docpath")
            
        }catch{
            print(error)
            downloaded = false
        }
        return downloaded
    }
    
    
    @objc func mailSettlementReport(sender: UITapGestureRecognizer){
        
        getReports(isDownload: false, serviceName: RequestItemsType.getSettlementReports, pdfname: "")
    }
    
    @objc func downloadSettlementReport(sender: UITapGestureRecognizer){
        getReports(isDownload: true, serviceName: RequestItemsType.getSettlementReports, pdfname:   "Settlement_Report_From")
        
    }
    
    @objc func downloadCreditReport(sender: UITapGestureRecognizer){
        getReports(isDownload: true, serviceName: RequestItemsType.getCreditToBankReports, pdfname:     "Credit_Report_From")
        
    }
    @objc func generateTransactionReport(sender: UITapGestureRecognizer){
        
        generateReportType(type: 0)
        
    }
    @objc func accessReportPermission(sender: UITapGestureRecognizer){
        
        let controller = (UIStoryboard.init(name: "Main", bundle:   Bundle.main).instantiateViewController(withIdentifier: "ReportsAccessViewController") as?   ReportsAccessViewController)!
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func generateSettlementReport(sender: UITapGestureRecognizer){
        generateReportType(type: 1)
        
    }
    @objc func generateCreditReport(sender: UITapGestureRecognizer){
        generateReportType(type: 2)
        
    }
    
    func generateReportType(type:Int){
        
        let controller = (UIStoryboard.init(name: "Main", bundle:   Bundle.main).instantiateViewController(withIdentifier: "GenerateReportViewController") as?  GenerateReportViewController)!
        controller.reportType = type
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func popupType(type:Int){
        let controller = (UIStoryboard.init(name: "Main", bundle:   Bundle.main).instantiateViewController(withIdentifier: "ReportsPopupViewController") as?    ReportsPopupViewController)!
        controller.popupType = type
        if(type == 0){
            controller.documentUrl = documentPath
            presentAsStork(controller, height: 400, cornerRadius: 8.0, showIndicator: false,    showCloseButton: false)
        }else if(type == 1){
            
            presentAsStork(controller, height: 350, cornerRadius: 8.0, showIndicator: false,    showCloseButton: false)
        }else{
            
            presentAsStork(controller, height: 500, cornerRadius: 8.0, showIndicator: false,    showCloseButton: false)
        }
        
    }
    
    func curvedviewShadow(view:UIView){
        
        view.layer.cornerRadius = 8
        view.layer.shadowOpacity = 0.35
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowRadius = 3.0
        view.layer.shadowColor = UIColor.BurganColor.brandGray.lgiht.cgColor
        view.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner,.layerMaxXMinYCorner]
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createPanGeustures()
    }
    
    
}
extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case .top:
            border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
        case .bottom:
            border.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
        case .right:
            border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        addSublayer(border)
    }
}
