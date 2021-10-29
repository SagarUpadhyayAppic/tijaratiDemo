//
//  CreditViewController.swift
//  Burgan
//
//  Created by Malti Maurya on 31/03/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit
import ExpyTableView
import FSCalendar

protocol creditPopupDelegate : class {
    func showVISA(cell : tbCreditContentCell, BtnTag:Int)
}

class CreditViewController : UIViewController, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance, applyFilterDelegate, calendarDelegate, creditPopupDelegate
{
    func applyFilter(heirarchy: selectedFilterData, isCif: Bool) {
        
        AppConstants.isCif = isCif
        btnSelectBrandName.setTitle(AppConstants.selectedFilter!.companyName + "(" + String(AppConstants.selectedFilter!.selectedMerchants.count) + ")  ", for: .normal)
        AppConstants.cifCompanyName = AppConstants.selectedFilter!.companyName
        AppConstants.UserData.companyCIF = AppConstants.selectedFilter!.cif
        
        
//        if isCif {
//            corporateCTBReq()
//        }else{
//            merchantCTBReq()
//        }
        

        if AppConstants.UserData.merchantRole == "Admin" {
            if AppConstants.isCif
            {
                corporateCTBReq()
            } else {
                merchantCTBReq()
            }
        }else{
            merchantCTBReq()
        }
        
        
    }
    
//    func showVISA(cell: tbCreditContentCell) {
        func showVISA(cell : tbCreditContentCell, BtnTag:Int) {
//        let section = cell.lblMID.tag
//        let tag = cell.tag
        
        let section = cell.tag
        let tag = cell.lblMID.tag
        
        let controller = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CreditPopupViewController") as? CreditPopupViewController)!
        for i in 0..<creditDataArray[section].merchantList![tag].splitAmount!.count{
            let visa = creditDataArray[section].merchantList![tag].splitAmount![i]
            
            if visa.network!.contains("VISA") {
                
                if BtnTag == 1 {
                    controller.titleStr = "VISA"
                    
                    controller.totalAmt = visa.totalAmount
                    controller.referencNum = visa.refNo
                    controller.netamt = visa.netAmount
                    controller.mdrrate = visa.mdr
                }
                
            } else if visa.network!.contains("MASTER") {
                
                if BtnTag == 2 {
                    controller.titleStr = "MASTER"
                    
                    controller.totalAmt = visa.totalAmount
                    controller.referencNum = visa.refNo
                    controller.netamt = visa.netAmount
                    controller.mdrrate = visa.mdr
                }
                
            } else if visa.network!.contains("KNET") {
                
                if BtnTag == 3 {
                    controller.titleStr = "KNET"
                    
                    controller.totalAmt = visa.totalAmount
                    controller.referencNum = visa.refNo
                    controller.netamt = visa.netAmount
                    controller.mdrrate = visa.mdr
                }
                
            } else {
                
                if BtnTag == 4 {
                    controller.titleStr = "GCC"
                    
                    controller.totalAmt = visa.totalAmount
                    controller.referencNum = visa.refNo
                    controller.netamt = visa.netAmount
                    controller.mdrrate = visa.mdr
                }
            }
            
//            controller.totalAmt = visa.totalAmount
//            controller.referencNum = visa.refNo
//            controller.netamt = visa.netAmount
//            controller.mdrrate = visa.mdr
        }
      
        self.presentAsStork(controller, height: 300, cornerRadius:CGFloat.CornerRadius.popup.radius, showIndicator: false, showCloseButton: false)

    }
    
  
    func selectDateRange(startDate: Date, endDate: Date) {
        
        /*
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        AppConstants.jsonStartDate  = dateFormatter.string(from: startDate)
        AppConstants.jsonEndDate = dateFormatter.string(from: endDate)
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MMM dd"
        let sDate = dateFormat.string(from: startDate)
        let eDate = dateFormat.string(from: endDate)
        btnSelectMonth.setTitle(sDate + " - " + eDate + " " + endDate.yearr, for: .normal)
        */
            
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
        let merchant : [String]  = ["\(AppConstants.merchantNumber)"]

        let param : [String : Any] = ["type":"cif",
                                      "cif" : AppConstants.selectedFilter!.cif,
                                      "merchantNum" : merchant,
                                      "deviceId" : AppConstants.UserData.deviceID,
                                      "startDate":AppConstants.jsonStartDate ,
                                      "endDate":AppConstants.jsonEndDate]
         MBProgressHUD.showAdded(to: self.view, animated: true)
        self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.getCreditToBankInfo)
        self.bindUI()
        */
        
        if AppConstants.UserData.merchantRole == "Admin" {
            if AppConstants.isCif
            {
                corporateCTBReq()
            } else {
                merchantCTBReq()
            }
        }else{
            merchantCTBReq()
        }
    }
    
    func selectTimeRange(startTimeValue: String, endTimeValue: String) {
        
    }
    func selectTimeRange(startTimeValue : String , endTimeValue : String, statTimeAMPM : String, endTimeAMPM : String){
        
    }
    
    
    var totalCreditAmount : Double = 0.0
    
   //MARK:- OUTLETS
   
    
    @IBOutlet weak var lblTotalCreditAmount: UILabel!
    
    @IBOutlet weak var tbCreditList: UITableView!
    @IBOutlet weak var btnSelectBrandName: UIButton!
    @IBOutlet weak var btnSelectMonth: UIButton!
    
    @IBOutlet weak var btnMonth: UIButton!
    //@IBOutlet weak var calendarView: FSCalendar!
    
    //@IBOutlet weak var curvedViewHeight: NSLayoutConstraint!
    var selectedIndx = -1

    //@IBOutlet weak var calendarViewHeight: NSLayoutConstraint!
    var thereIsCellTapped = false
    
    
    ///TOTAL CREDIT VIEW
    @IBOutlet var totalCreditViewRef: UIView!
    
    //DATE DROP DOWN VIEW
    @IBOutlet weak var dateViewRef: UIView!
    
    @IBOutlet var tvHeightRef: NSLayoutConstraint!
    
    @IBAction func applyFilter(_ sender: Any) {
         if AppConstants.selectedFilter != nil {
              let controller = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SelectLocationViewController") as? SelectLocationViewController)!
                     controller.delegateFilter = self
                            presentAsStork(controller, height: 500, cornerRadius: 8.0, showIndicator: false, showCloseButton: false)
               }else{
                  showAlertWith(message: AlertMessage(title: "Tijarati".localiz(), body: "No data available to filter.".localiz()))
              }
    }
    
    @IBAction func selectDateRange(_ sender: Any) {
         let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CalendarPopupViewController") as? CalendarPopupViewController
          controller?.popuptype = 0
        controller?.calendarClockdelegate = self
          presentAsStork(controller!, height: 650, cornerRadius: 8, showIndicator: false, showCloseButton: false)
        
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
    
    //@IBOutlet weak var creditCurvedView: UIView!
    var creditDataArray : [LocationCredit] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.networkStatusChanged(_:)), name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        definesPresentationContext = true

        
        
//        self.loopThroughSubViewAndAlignTextfieldText(subviews: self.view.subviews)
        self.loopThroughSubViewAndAlignLabelText(subviews: self.view.subviews)
        self.loopThroughSubViewAndMirrorImage(subviews: self.view.subviews)
        
        arabic()
        //tbCreditList.expandingAnimation = .fade
        //tbCreditList.delegate = self
        //tbCreditList.dataSource = self
        //tbCreditList.collapsingAnimation = .fade
        tbCreditList.tableFooterView = UIView()
        //curvedviewShadow(view: creditCurvedView)
        //curvedviewShadow(view: calendarView)
         //calendarView.delegate = self
        //curvedViewHeight.constant = 100
        //calendarView.dataSource = self
//        calendarView.select(Date())
        let jsonDateformatter = DateFormatter()
        jsonDateformatter.locale = Locale(identifier: "en")
        jsonDateformatter.dateFormat = "yyyy-MM-dd"
        let startDate = Date() // Calendar.current.date(byAdding: .day, value: -1, to: Date())! 
        
        //calendarView.select(jsonDateformatter.string(from: startDate).dateFromFormat("yyyy-MM-dd"))
        
        
         /*
        calendarView.select(AppConstants.jsonStartDate.dateFromFormat("yyyy-MM-dd"))
        currentMonthData()
        calendarView.scope = .week
        calendarAppearanceSetup(calendar: calendarView)
        curvedViewHeight.constant = curvedViewHeight.constant + 3 * 70
        CreditViewController.selectedFilter(button: btnSelectBrandName)
        lblTotalCreditAmount.text = "KD 0,000.00"
        self.viewModel = RegistrationViewControllerViewModel()
        
      
        if AppConstants.UserData.merchantRole == "Admin" {
            if AppConstants.isCif
            {
                corporateCTBReq()
            } else {
                merchantCTBReq()
            }
        }else{
            merchantCTBReq()
        }
        */
        
        ///TOTAL CREDIT VIEW
        totalCreditViewRef.layer.cornerRadius = 6
        totalCreditViewRef.dropShadow()
     
        ///DATE VIEW
        dateViewRef.layer.cornerRadius = 15
        dateViewRef.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        arabic()
//        calendarView.select(AppConstants.jsonStartDate.dateFromFormat("yyyy-MM-dd"))
        currentMonthData()
        //calendarView.scope = .week
        //calendarAppearanceSetup(calendar: calendarView)
        //curvedViewHeight.constant = curvedViewHeight.constant + (3 * 70)
        CreditViewController.selectedFilter(button: btnSelectBrandName)
        lblTotalCreditAmount.text = "KD 0.000"
        lblTotalCreditAmount.attributedText = lblTotalCreditAmount.text?.attributedString(fontsize: 15)
        self.viewModel = RegistrationViewControllerViewModel()
        
        if AppConstants.UserData.merchantRole == "Admin" {
            if AppConstants.isCif
            {
                corporateCTBReq()
            } else {
                merchantCTBReq()
            }
        }else{
            merchantCTBReq()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    static func selectedFilter(button:UIButton)
    {
        button.setTitle(AppConstants.selectedFilter!.companyName.localiz() + "(" + String(AppConstants.merchantNumber.count) + ")  ", for: .normal)
                        
    }
    
    func corporateCTBReq(){
        let param : [String : Any] = ["type":"cif",
                                      "cif" : AppConstants.selectedFilter!.cif,
                                      "deviceId" : AppConstants.UserData.deviceID,
                                      "startDate":AppConstants.jsonStartDate ,
                                      "endDate":AppConstants.jsonEndDate]
         MBProgressHUD.showAdded(to: self.view, animated: true)
        self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.getCreditToBankInfo)
        self.bindUI()
    }
    
    func merchantCTBReq(){
        let merchant : [String]  = ["\(AppConstants.merchantNumber)"]
        let param : [String : Any] = ["type":"mid",
                                      "merchantNum" : merchant,
                                      "deviceId" : AppConstants.UserData.deviceID,
                                      "startDate":AppConstants.jsonStartDate ,
                                      "endDate":AppConstants.jsonEndDate]
         MBProgressHUD.showAdded(to: self.view, animated: true)
        self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.getCreditToBankInfo)
        self.bindUI()
    }
    
     func currentMonthData(){
       
        let startDate = AppConstants.jsonStartDate.dateFromFormat("yyyy-MM-dd")
        let endDate = AppConstants.jsonEndDate.dateFromFormat("yyyy-MM-dd")
                        
        if AppConstants.jsonStartDate == AppConstants.jsonEndDate{
            let selectedDateRange = startDate!.monthh.prefix(3) + " - " + String(endDate!.day) + ", " + endDate!.yearr
                                      
            btnSelectMonth.setTitle(selectedDateRange, for: .normal)

        } else {
                           
            let selectedDateRange = startDate!.monthh.prefix(3) + " " + String(startDate!.day) + " - "
            let myEndDate = endDate!.monthh.prefix(3) + String(endDate!.day) + ", " + endDate!.yearr
            btnSelectMonth.setTitle(selectedDateRange + myEndDate, for: .normal)

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
                    
                    let status : String = userStatus?.value(forKey: "status") as? String ?? ""
                    
                    if status == "" {
                        
                        if AppConstants.UserData.merchantRole == "Admin" {
                            if AppConstants.isCif
                            {
                                self!.corporateCTBReq()
                            } else {
                                self!.merchantCTBReq()
                            }
                        }else{
                            self!.merchantCTBReq()
                        }
                        
                    } else {
                        
                        let message : String = userStatus?.value(forKey: "message") as! String
                                            let status : String = userStatus?.value(forKey: "status") as! String
                                            if status == "Success"{
                                                let errorCode : String = userStatus?.value(forKey: "errorCode") as! String
                                                if errorCode == "L128"{
                        //                                print(message)
                                                    if  let object = self?.decodeResult(model: creditToBankResp.self, result: userStatus!) {
                                                        let creditToBank = object.model
                                                        if let creditArr = creditToBank?.locationCredit
                                                        {
                                                            self!.creditDataArray.removeAll()
                                                            self!.creditDataArray = creditArr
                                                            
                                                            if self!.creditDataArray.count == 0 {
                                                                self!.tbCreditList.setEmptyMessage("No Data Found !!")
                                                            } else {
                                                                self!.tbCreditList.restore()
                                                            }
                                                            
                                                            //self?.curvedViewHeight.constant = CGFloat(70 * self!.creditDataArray.count + 100)

                                                            self?.totalCreditAmount = 0.0
                                                            // Must check
                                                            for section in 0..<self!.creditDataArray.count {
                                                                    
                        //                                        self?.totalCreditAmount = self!.totalCreditAmount + CGFloat((self!.creditDataArray[section].amount! as NSString).floatValue)
                                                                self?.totalCreditAmount = self!.totalCreditAmount + Double((self!.creditDataArray[section].amount! as NSString).doubleValue)
                                                            }
                                                                
                        //                                    self?.lblTotalCreditAmount.text = "KD " + setAmounts(amount: String(format: "%.3f", Double(self!.totalCreditAmount)))
                                                            self?.lblTotalCreditAmount.text = "KD " + setAmounts(amount: "\(self!.totalCreditAmount)")
                                                            self?.lblTotalCreditAmount.attributedText = self!.lblTotalCreditAmount.text?.attributedString(fontsize: 15)
                                                                        
                                                            self!.tbCreditList.reloadData()
                                                        }
                                                    }else{
                                                        self!.showAlertWith(message: AlertMessage(title: "Credit", body: "Invalid Data."))
                                                    }
                                                }else{
                                                    
                                                    self!.creditDataArray.removeAll()
                                                    
                                                    if self!.creditDataArray.count == 0 {
                                                        self!.tbCreditList.setEmptyMessage("No Data Found !!")
                                                    } else {
                                                        self!.tbCreditList.restore()
                                                    }
                                                    
                                                    self!.tbCreditList.reloadData()
                                                    
                                                    self?.lblTotalCreditAmount.text = "KD " + setAmounts(amount: "0.000")
                                                    self?.lblTotalCreditAmount.attributedText = self!.lblTotalCreditAmount.text?.attributedString(fontsize: 15)
                                                    
                                                    //self!.showAlertWith(message: AlertMessage(title: "Credit", body: message))
                                                }
                                            } else {
                                                self!.showAlertWith(message: AlertMessage(title: "Credit", body: message))
                                            }
                    }

                }
            }
        })
    }
           
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        //self.calendarViewHeight.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    
    @IBAction func openSideMenu(_ sender: Any) {
//        self.sideMenuViewController.presentLeftMenuViewController()
        if AppConstants.language == .ar {
            self.sideMenuViewController.presentRightMenuViewController()
        } else {
            self.sideMenuViewController.presentLeftMenuViewController()
        }
    }
    
    @IBOutlet weak var lblTotalCreditTitle: UILabel!
    func arabic(){
        lblTotalCreditTitle.text = "Total Credit to Bank".localiz()
        if AppConstants.language == .ar{
            lblTotalCreditTitle.textAlignment = NSTextAlignment.right
            lblTotalCreditAmount.textAlignment = NSTextAlignment.left
        }else{
            lblTotalCreditTitle.textAlignment = NSTextAlignment.left
            lblTotalCreditAmount.textAlignment = NSTextAlignment.right
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        let cell = calendar.cell(for: date, at: monthPosition)
       
        // cell?.contentView.addBottomBorderWithColor AppConstants.jsonStartDate = date.stringFromFormat("yyyy-MM-dd")
        AppConstants.jsonStartDate = date.stringFromFormat("yyyy-MM-dd")
        AppConstants.jsonEndDate = date.stringFromFormat("yyyy-MM-dd")
        let selectedDateRange = date.monthh.prefix(3) + " - " + String(date.day) + ", " + date.yearr
        btnSelectMonth.setTitle(selectedDateRange, for: .normal)
//                 corporateCTBReq()
        totalCreditAmount = 0.0
        if AppConstants.UserData.merchantRole == "Admin"{
            if AppConstants.isCif
            {
                corporateCTBReq()
            } else {
                merchantCTBReq()
            }
        } else {
            merchantCTBReq()
        }
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
//         let cell = calendar.cell(for: date, at: monthPosition)
       // cell?.contentView.removeLayer(layerName: "bottom")
    }

    func minimumDate(for calendar: FSCalendar) -> Date {
        return Calendar.current.date(byAdding: .month, value: -6, to: Date())!
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
       return Date()
    }
    
    
    func calendarAppearanceSetup(calendar:FSCalendar){

        calendar.appearance.eventDefaultColor = UIColor.clear
        calendar.appearance.headerDateFormat = "yyyy/MM"
        calendar.appearance.todayColor = UIColor.clear
        calendar.appearance.borderRadius = 0
        calendar.appearance.titleFont = UIFont(name: "FrutigerRoman", size: 17)
    }
    
    func curvedviewShadow(view:UIView) {
        view.layer.cornerRadius = 8
        view.layer.shadowOpacity = 0.35
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowRadius = 3.0
        view.layer.shadowColor = UIColor.BurganColor.brandGray.lgiht.cgColor
        view.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner,.layerMaxXMinYCorner]
    }
    
}

 

    func setAmounts(amount : String) -> String{
        return (Double(amount)?.rounded(digits: 3).calculate)!
    }

    //MARK: ExpyTableView delegate methods

    //extension CreditViewController: ExpyTableViewDelegate {
        
//        func tableView(_ tableView: ExpyTableView, expyState state: ExpyState, changeForSection section: Int) {
//
//            switch state {
//            case .willExpand:
//                print("WILL EXPAND")
//                //curvedViewHeight.constant = curvedViewHeight.constant + CGFloat(creditDataArray[section].merchantList!.count * 300)
//                break
//
//            case .willCollapse:
//                print("WILL COLLAPSE")
//                //curvedViewHeight.constant = curvedViewHeight.constant - CGFloat(creditDataArray[section].merchantList!.count * 300)
//                break
//
//            case .didExpand:
//                print("DID EXPAND")
//                break
//            case .didCollapse:
//                print("DID COLLAPSE")
//                break
//            }
//        }
 //   }


    extension CreditViewController {

    }


//MARK:- ExpyTableViewDataSourceMethods
//   extension CreditViewController: ExpyTableViewDataSource {
//
//       func tableView(_ tableView: ExpyTableView, canExpandSection section: Int) -> Bool {
//           return true
//       }
//
//
//       func tableView(_ tableView: ExpyTableView, expandableCellForSection section: Int) -> UITableViewCell {
//           let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: tbCreditHeaderCell.self)) as! tbCreditHeaderCell
//        cell.viewRef.layer.cornerRadius = 6
//        cell.viewRef.dropShadow()
//           cell.layoutMargins = UIEdgeInsets.zero
//           cell.lblName.text = creditDataArray[section].locationName!
//           cell.lblAmount.text = "KD " + setAmounts(amount: creditDataArray[section].amount!)
//           cell.lblAmount.attributedText = cell.lblAmount.text!.attributedString(fontsize: 12)
//
//           // Must check
//           //totalCreditAmount = totalCreditAmount + CGFloat((creditDataArray[section].amount! as NSString).floatValue)
//           cell.showSeparator()
//           //lblTotalCreditAmount.text = "KD " + setAmounts(amount: String(format: "%.3f", Double(totalCreditAmount)))
//        tableView.separatorStyle = .none
//           if AppConstants.language == .ar {
//               cell.lblName.textAlignment = .right
//               cell.lblAmount.textAlignment = .left
//           } else {
//               cell.lblName.textAlignment = .left
//               cell.lblAmount.textAlignment = .right
//           }
//
//
//              return cell
//          }
//      }

    //MARK:- UITableView Data Source Methods
extension CreditViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                    let count = creditDataArray.count//{
                    let tvHeight = count * 90
        tvHeightRef.constant = CGFloat(tvHeight)
                    return count//creditDataArray[section].merchantList!.count + 1
                    //}
                    //return 0

    }
        
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            //
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: tbCreditHeaderCell.self)) as! tbCreditHeaderCell
            cell.viewRef.layer.cornerRadius = 6
            cell.viewRef.dropShadow()
            cell.layoutMargins = UIEdgeInsets.zero
            cell.lblName.text = creditDataArray[indexPath.row].locationName!
            cell.lblAmount.text = "KD " + setAmounts(amount: creditDataArray[indexPath.row].amount!)
            cell.lblAmount.attributedText = cell.lblAmount.text!.attributedString(fontsize: 12)
            
            // Must check
            //totalCreditAmount = totalCreditAmount + CGFloat((creditDataArray[section].amount! as NSString).floatValue)
            cell.showSeparator()
            //lblTotalCreditAmount.text = "KD " + setAmounts(amount: String(format: "%.3f", Double(totalCreditAmount)))
            tableView.separatorStyle = .none
            if AppConstants.language == .ar {
                cell.lblName.textAlignment = .right
                cell.lblAmount.textAlignment = .left
            } else {
                cell.lblName.textAlignment = .left
                cell.lblAmount.textAlignment = .right
            }
            
            cell.selectionStyle = .none
            
            return cell
            //
            
            /* let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: tbCreditContentCell.self)) as! tbCreditContentCell
             let merchant = creditDataArray[indexPath.section].merchantList![indexPath.row-1]
             cell.lblMID.text = "MID".localiz() + " : " + (merchant.mid ?? "0")
             cell.delegate = self
             cell.tag = indexPath.section
             cell.lblMID.tag = indexPath.row - 1
             cell.lblVISA.text = "KD 0.000"
             cell.lblVISA.attributedText = cell.lblVISA.text?.attributedString(fontsize: 13)
             cell.lblKnet.text = "KD 0.000"
             cell.lblKnet.attributedText = cell.lblKnet.text?.attributedString(fontsize: 13)
             cell.lblGcc.text = "KD 0.000"
             cell.lblGcc.attributedText = cell.lblGcc.text?.attributedString(fontsize: 13)
             cell.lblMaster.text = "KD 0.000"
             cell.lblMaster.attributedText = cell.lblMaster.text?.attributedString(fontsize: 13)
             if merchant.splitAmount!.count > 0{
             for i in 0..<merchant.splitAmount!.count{
             let splitamount : SplitAmount = merchant.splitAmount![i]
             
             if splitamount.network!.contains("VISA") {
             cell.lblVISA.text = "KD " + setAmounts(amount: splitamount.netAmount!)
             cell.lblVISA.attributedText = cell.lblVISA.text?.attributedString(fontsize: 13)
             } else if splitamount.network!.contains("MASTER") {
             cell.lblMaster.text = "KD " + setAmounts(amount: splitamount.netAmount!)
             cell.lblMaster.attributedText = cell.lblMaster.text?.attributedString(fontsize: 13)
             } else if splitamount.network!.contains("KNET") {
             cell.lblKnet.text = "KD " + setAmounts(amount: splitamount.netAmount!)
             cell.lblKnet.attributedText = cell.lblKnet.text?.attributedString(fontsize: 13)
             } else {
             cell.lblGcc.text = "KD " + setAmounts(amount: (splitamount.netAmount ?? "0.000"))
             cell.lblGcc.attributedText = cell.lblGcc.text?.attributedString(fontsize: 13)
             }
             }
             }
             // cell.lblKnet.attributedText = cell.lblKnet.text!.attributedString(fontsize: 12)
             // cell.lblMaster.attributedText = cell.lblMaster.text!.attributedString(fontsize: 12)
             // cell.lblVISA.attributedText = cell.lblVISA.text!.attributedString(fontsize: 12)
             // cell.lblGcc.attributedText = cell.lblGcc.text!.attributedString(fontsize: 12)
             cell.layoutMargins = UIEdgeInsets.zero
             cell.hideSeparator()
             
             if AppConstants.language == .ar {
             cell.lblGcc.textAlignment = .left
             cell.lblKnet.textAlignment = .left
             cell.lblMaster.textAlignment = .left
             cell.lblVISA.textAlignment = .left
             
             cell.netAmtTitle_Lbl.textAlignment = .left
             
             } else {
             
             cell.lblGcc.textAlignment = .right
             cell.lblKnet.textAlignment = .right
             cell.lblMaster.textAlignment = .right
             cell.lblVISA.textAlignment = .right
             
             cell.netAmtTitle_Lbl.textAlignment = .right
             }
             
             return cell */
            
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "CreditToBank", bundle: nil).instantiateViewController(withIdentifier: "CreditToBankDetailsViewController") as! CreditToBankDetailsViewController
        //
        let merchant = creditDataArray[indexPath.row].merchantList
        if let merchantValue = merchant{
        vc.values = merchantValue
        }
        
        //vc.midValue = "MID".localiz() + " : " + (merchant.mid ?? "0")
//        vc.delegate = self
//        vc.tag = indexPath.section
//        vc.lblVISA.text = "KD 0.000"
//        vc.lblVISA.attributedText = cell.lblVISA.text?.attributedString(fontsize: 13)
//        vc.lblKnet.text = "KD 0.000"
//        vc.lblKnet.attributedText = cell.lblKnet.text?.attributedString(fontsize: 13)
//        vc.lblGcc.text = "KD 0.000"
//        vc.lblGcc.attributedText = cell.lblGcc.text?.attributedString(fontsize: 13)
//        vc.lblMaster.text = "KD 0.000"
//        vc.lblMaster.attributedText = cell.lblMaster.text?.attributedString(fontsize: 13)

        
//        if let count = merchant.splitAmount?.count{
//            vc.dataCount = count
//        }

        //
        
        vc.modalPresentationStyle = .popover
        self.present(vc, animated: true, completion: nil)

    }
    }
