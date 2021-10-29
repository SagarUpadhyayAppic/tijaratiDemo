//
//  ReportsPopupViewController.swift
//  Burgan
//
//  Created by Malti Maurya on 02/04/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit
import XlsxReaderWriter

protocol ReportsPopupDelegate : class{
    func SendMail(type : String)
}


class ReportsPopupViewController: UIViewController {
    
    var isFrom = String()
    weak var delegate : ReportsPopupDelegate?
    
    @IBOutlet weak var ivPopup: UIImageView!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var infoStackView: UIStackView!
    @IBOutlet weak var saveReportStackview: UIStackView!
    var popupType = 0
    @IBOutlet weak var sendMailCurvedView: UIView!
    @IBOutlet weak var saveReportViewCurved: UIView!
    var mailReport = false
    var saveToPhoneReport = false
    @IBOutlet weak var btn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendMailCurvedView.layer.cornerRadius = 8
        saveReportViewCurved.layer.cornerRadius = 8
        sendMailCurvedView.layer.borderColor = UIColor(red: 120.0/255.0, green: 144.0/255.0, blue: 156.0/255.0, alpha: 1.0).cgColor
        saveReportViewCurved.layer.borderColor = UIColor(red: 120.0/255.0, green: 144.0/255.0, blue: 156.0/255.0, alpha: 1.0).cgColor
        sendMailCurvedView.layer.borderWidth = 1
         saveReportViewCurved.layer.borderWidth = 1
        popupType(type: popupType)
        viewModel = RegistrationViewControllerViewModel()
        
    }
    
    @IBOutlet weak var btmView: UIView!
   
    @IBAction func saveReport(_ sender: Any) {
        saveReport()
    }
    
    @IBAction func emailReport(_ sender: Any) {
        sendMailReport()
    }
   func saveReport(){
        if(saveToPhoneReport){
            saveToPhoneReport = false
            lblSaveReport.textColor = UIColor.black
            saveReportViewCurved.backgroundColor = UIColor.clear
            saveReportViewCurved.layer.borderWidth = 1
        }else
        {
            saveToPhoneReport = true
            mailReport = false
            sendMailCurvedView.backgroundColor = UIColor.clear
            sendMailCurvedView.layer.borderWidth = 1
            saveReportViewCurved.backgroundColor = UIColor.BurganColor.brandBlue.medium
            saveReportViewCurved.layer.borderWidth = 0
            lblSaveReport.textColor = UIColor.white
            getReports(isDownload: true, pdfname: pdfName)
            lblReceiveMail.textColor = UIColor.black

        }
      
         
     }
    
    @IBOutlet weak var lblSaveReport: UILabel!
    @IBOutlet weak var lblReceiveMail: UILabel!
    func sendMailReport(){
        
        if isFrom == "reportlistTran" || isFrom == "reportlistCredit"{
            
            self.delegate?.SendMail(type: isFrom)
            
            self.dismiss(animated: true, completion: nil)
            
        } else {
          
            if(mailReport){
                mailReport = false
                lblReceiveMail.textColor = UIColor.black
                sendMailCurvedView.backgroundColor = UIColor.clear
                sendMailCurvedView.layer.borderWidth = 1
             } else {
                lblReceiveMail.textColor = UIColor.white
                mailReport = true
                saveToPhoneReport = false
                lblSaveReport.textColor = UIColor.black
                saveReportViewCurved.backgroundColor = UIColor.clear
                saveReportViewCurved.layer.borderWidth = 1
                sendMailCurvedView.backgroundColor = UIColor.BurganColor.brandBlue.medium
                sendMailCurvedView.layer.borderWidth = 0
                getReports(isDownload: false, pdfname: "")

            }
            
        }
         
            
    }
    
    var documentUrl = ""
    
    @IBAction func view(_ sender: Any) {
        /*
        let url = NSURL(string:documentUrl)! as URL
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
//        let documentPath: String = Bundle.main.path(forResource: "s", ofType: "xlsx")!
        
        documentUrl = UserDefaults.standard.value(forKey: "docpath") as! String
        var spreadsheet: BRAOfficeDocumentPackage = BRAOfficeDocumentPackage.open(documentUrl)
        */
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let WebView = storyBoard.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
        WebView.fileUrlPathStr = UserDefaults.standard.value(forKey: "docpath") as! String

//        WebView.fileUrlPathStr = documentUrl //filePath1 + "/\(self.exlName_Str)"
//        self.navigationController?.pushViewController(WebView, animated: true)
        self.presentAsStork(WebView)
    }
    
    func popupType(type:Int){
        switch type {
        case 0:
            saveToPhone()
        case 1:
            sendMail()
        case 2:
            receiveReport()
        default:
            break
        }
        
    }
    func saveToPhone(){
        saveReportStackview.isHidden = true
        infoStackView.isHidden = false
        btmView.isHidden = false
        btn.isHidden = false
        ivPopup.image = UIImage(named: "ic_save_report")
        lblInfo.text = "Your report has been successfully saved in your phone".localiz()
    }
    func sendMail()
    {
        saveReportStackview.isHidden = true
        infoStackView.isHidden = false
        btn.isHidden = true
        btmView.isHidden = true
        ivPopup.image = UIImage(named: "ic_receive_email")
        lblInfo.text = "Your report has been successfully sent to your registered email Id".localiz()
    
    }
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func receiveReport(){
        btmView.isHidden = true
        btn.isHidden = true
        saveReportStackview.isHidden = false
        infoStackView.isHidden = true
       
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
        //let startDate = dateFormatter.string(from:jsonStartDate!)
        
//        let diffInDays = Calendar.current.dateComponents([.day], from: dateFormatter.date(from: self.jsonStartDate)!, to: dateFormatter.date(from: self.jsonEndDate)!).day ?? 0

//        let diffInDays = dateFormatter.date(from: self.jsonEndDate)!.interval(ofComponent: .day, fromDate: dateFormatter.date(from: self.jsonStartDate)!)

        let startDate = self.jsonEndDate
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formatedStartDate = dateFormatter.date(from: startDate)
        let currentDate = dateFormatter.date(from: self.jsonStartDate)!
        let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .month, .year])
        let differenceOfDate = Calendar.current.dateComponents(components, from: formatedStartDate!, to: currentDate)

        print (differenceOfDate)
        
        if (abs(differenceOfDate.day!) + 1) > 3 {
            self.saveReportViewCurved.isHidden = true
        } else {
             self.saveReportViewCurved.isHidden = false
        }
    }
    
    var startTime = "00:00:00"
    var endTime = "11:59:59"
    var jsonStartDate = ""
    var jsonEndDate = ""
    var merchantNumber : [String]?
    var paymentType : [String:Any] = [:]
    var transactionType : [String]?
    var servicePreference  = 0
    var isFilterSelected : Bool  = false
    var viewModel: RegistrationViewControllerViewModelProtocol?
    var serviceName : EndPointType?
    var pdfName = ""
    
       func getReports(isDownload : Bool,pdfname : String)
          {
              var sendEmail = false
            var param : [String : Any] = [:]
              if isDownload {
                  sendEmail = false
              }else{
                  sendEmail = true
              }
            if servicePreference == 0 {
                param  = ["cif" : AppConstants.selectedFilter!.cif,
                          "deviceId" :AppConstants.UserData.deviceID,
                          "startDate" : jsonStartDate,
                          "endDate" : jsonEndDate,
                          "startTime" : startTime,
                          "endTime" : endTime,
                          "sendEmail" : sendEmail]
            }else if servicePreference == 1
            {
                param  = ["cif" : AppConstants.selectedFilter!.cif,
                          "deviceId" :AppConstants.UserData.deviceID,
                          "startDate" : jsonStartDate,
                          "endDate" : jsonEndDate,
                          "startTime" : startTime,
                          "merchantNumber" : merchantNumber!,
                          "endTime" : endTime,
                          "sendEmail" : sendEmail]
            }else if servicePreference == 2
            {
                
                let jsonData = try! JSONSerialization.data(withJSONObject: paymentType)
                let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
//                       print(jsonString)
                
                param  = ["cif" : AppConstants.selectedFilter!.cif,
                          "deviceId" :AppConstants.UserData.deviceID,
                          "startDate" : jsonStartDate,
                          "paymentType":jsonString!,
                          "endDate" : jsonEndDate,
                          "startTime" : startTime,
                          "endTime" : endTime,
                          "sendEmail" : sendEmail]
            }else{
                let jsonData = try! JSONSerialization.data(withJSONObject: paymentType)
                let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
//                    print(jsonString)
                    
                
//                param  = ["cif" : AppConstants.selectedFilter!.cif,
//                        "deviceId" :AppConstants.UserData.deviceID,
//                        "startDate" : jsonStartDate,
//                        "paymentType":jsonString!,
//                        "endDate" : jsonEndDate,
//                        "transactionTypes" : transactionType!,
//                        "startTime" : startTime,
//                        "endTime" : endTime,
//                        "sendEmail" : sendEmail]
                
                if AppConstants.UserData.merchantRole == "Admin" {
                    
                    if isFilterSelected {
                        
                        param  = ["cif" : AppConstants.selectedFilter!.cif,
                        "deviceId" :AppConstants.UserData.deviceID,
                        "startDate" : jsonStartDate,
                        "paymentType":paymentType, //jsonString!,
                        "endDate" : jsonEndDate,
                        "transactionTypes" : transactionType!,
                        "startTime" : startTime,
                        "endTime" : endTime,
                        "sendEmail" : sendEmail,
                        "merchantNumber" : merchantNumber!]
                        
                    } else {
                        
                        param  = ["cif" : AppConstants.selectedFilter!.cif,
                        "deviceId" :AppConstants.UserData.deviceID,
                        "startDate" : jsonStartDate,
                        //"paymentType":jsonString!,
                        "endDate" : jsonEndDate,
                        //"transactionTypes" : transactionType!,
                        "startTime" : startTime,
                        "endTime" : endTime,
                        "sendEmail" : sendEmail]
                    }
                    
                    
                } else {
                    
                    if isFilterSelected {
                        param  = ["cif" : AppConstants.selectedFilter!.cif,
                        "deviceId" :AppConstants.UserData.deviceID,
                        "startDate" : jsonStartDate,
                        "paymentType":paymentType, //jsonString!,
                        "endDate" : jsonEndDate,
                        "transactionTypes" : transactionType!,
                        "startTime" : startTime,
                        "endTime" : endTime,
                        "sendEmail" : sendEmail,
                        "merchantNumber" : merchantNumber!]
                    } else {
                        param  = ["cif" : AppConstants.selectedFilter!.cif,
                        "deviceId" :AppConstants.UserData.deviceID,
                        "startDate" : jsonStartDate,
                        //"paymentType":jsonString!,
                        "endDate" : jsonEndDate,
                        //"transactionTypes" : transactionType!,
                        "startTime" : startTime,
                        "endTime" : endTime,
                        "sendEmail" : sendEmail,
                        "merchantNumber" : merchantNumber!]
                    }
                    
                    
                }
                
                
            }
           
            self.view.isUserInteractionEnabled = false
             MBProgressHUD.showAdded(to: self.view, animated: true)
            self.viewModel?.serviceRequest(param: param, apiName: serviceName!)
              self.bindUI(isDownload: isDownload, pdfname: pdfname)
          }
    
    
    func getReportsMerchant(isDownload : Bool,pdfname : String) {
        var sendEmail = false
        var param : [String : Any] = [:]
        if isDownload {
            sendEmail = false
        }else{
            sendEmail = true
        }
        if servicePreference == 0 {
            
            param  = ["cif" : AppConstants.selectedFilter!.cif,
                      "deviceId" :AppConstants.UserData.deviceID,
                      "startDate" : jsonStartDate,
                      "endDate" : jsonEndDate,
                      "startTime" : startTime,
                      "endTime" : endTime,
                      "sendEmail" : sendEmail]
            
        } else if servicePreference == 1 {
            
            param  = ["cif" : AppConstants.selectedFilter!.cif,
                      "deviceId" :AppConstants.UserData.deviceID,
                      "startDate" : jsonStartDate,
                      "endDate" : jsonEndDate,
                      "startTime" : startTime,
                      "merchantNumber" : merchantNumber!,
                      "endTime" : endTime,
                      "sendEmail" : sendEmail]
            
        }else if servicePreference == 2 {
                   
            let jsonData = try! JSONSerialization.data(withJSONObject: paymentType)
            let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
//                          print(jsonString)
                   
            param  = ["cif" : AppConstants.selectedFilter!.cif,
                      "deviceId" :AppConstants.UserData.deviceID,
                      "startDate" : jsonStartDate,
                      "paymentType":jsonString!,
                      "endDate" : jsonEndDate,
                      "startTime" : startTime,
                      "endTime" : endTime,
                      "sendEmail" : sendEmail]
            
        } else {
            
            let jsonData = try! JSONSerialization.data(withJSONObject: paymentType)
            let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
//                       print(jsonString)
                                 
            param  = ["cif" : AppConstants.selectedFilter!.cif,
                      "deviceId" :AppConstants.UserData.deviceID,
                      "startDate" : jsonStartDate,
                      "paymentType":jsonString!,
                      "endDate" : jsonEndDate,
                      "transactionTypes" : transactionType!,
                      "startTime" : startTime,
                      "endTime" : endTime,
                      "sendEmail" : sendEmail]
               }
              
        self.view.isUserInteractionEnabled = false
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.viewModel?.serviceRequest(param: param, apiName: serviceName!)
        self.bindUI(isDownload: isDownload, pdfname: pdfname)
    }
    
    private func bindUI(isDownload:Bool,pdfname : String) {
        
        self.viewModel?.alertMessage.bind({ [weak self] in
            MBProgressHUD.hide(for: self!.view, animated: true)
            self?.showAlertDismissOnly(message: $0)
        })
               
         
        self.viewModel?.response.bind({ [weak self] in
                      
            if let response = $0 {
                MBProgressHUD.hide(for: self!.view, animated: true)
              if    let userStatus = DataDecryption().decryption(jsonModel: PayloadRes(iv: response.iv, payload: response.payload))
              {
                self!.view.isUserInteractionEnabled = true

                let message : String = userStatus.value(forKey: "message") as? String ?? ""
                
                if message == "" {
                    
                    self?.getReports(isDownload: isDownload, pdfname: pdfname)
                    
                } else {
                   
                    let errorCode : String = userStatus.value(forKey: "errorCode") as! String
                                    let message : String = userStatus.value(forKey: "message") as! String

                                      if errorCode == "S101"
                                      {

                                          if isDownload
                                          {
                                            if let reportData   = userStatus.value(forKey: "reportData")
                                            {
                                                if self!.downloadPDF(data: reportData as! String, reportName: pdfname + self!.jsonStartDate + "_To_" + self!.jsonEndDate){
                    //                                                self!.popupType(type: 0)
                                                                    
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
                                                                    
                                                                    
                                                }else{
                    //                                                self!.errorView.isHidden = false
                    //                                                self!.lblError.text = "Unable to download reports. Please try again."
                                                }
                                            }

                                          }else{
                                            
                                            self!.popupType(type: 1)
                                            
                                        }
                                      }else{
                                         
                                        self!.showAlertWith(message: AlertMessage(title: "Reports", body: message))
                                   
                                    }

                                    print(userStatus)
                }

                
                  
                }
               }else{
                self!.showAlertWith(message: AlertMessage(title: "Tijarati".localiz(), body: "Sorry, Failed to load data.".localiz()))
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
                      documentsPath = documentsDirectory
                      downloaded = true
                    documentUrl = filePath
                    UserDefaults.standard.setValue(filePath, forKey: "docpath")

              }catch{
              print(error)
              downloaded = false
              }
              return downloaded
          }
}

extension Date {

    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {

        let currentCalendar = Calendar.current

        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }

        return end - start
    }
}
