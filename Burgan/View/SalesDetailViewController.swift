//
//  SalesDetailViewController.swift
//  Burgan
//
//  Created by Malti Maurya on 18/03/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit
import FSCalendar

class SalesDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource , FSCalendarDelegate, FSCalendarDataSource, applyFilterDelegate,calendarDelegate
{
    func applyFilter(heirarchy: selectedFilterData, isCif: Bool) {
        AppConstants.isCif = isCif
        
        btnSelectLocation.setTitle(AppConstants.selectedFilter!.companyName + "(" + String(AppConstants.selectedFilter!.selectedMerchants.count) + ")  ", for: .normal)
        print("merchantno : " , AppConstants.merchantNumber)
        AppConstants.cifCompanyName = AppConstants.selectedFilter!.companyName
        AppConstants.UserData.companyCIF = AppConstants.selectedFilter!.cif
        let merchant : [String]  = ["\(AppConstants.merchantNumber)"]
        
        let param : [String : Any] = ["merchantNum" : merchant,
                                      "deviceId" : AppConstants.UserData.deviceID,
                                      "startDate":  AppConstants.jsonStartDate, "endDate":AppConstants.jsonEndDate]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.getSalesList)
        self.bindUI()
        
    }
    
    
    
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
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd"
         AppConstants.jsonStartDate = dateFormatter.string(from: startDate)
         AppConstants.jsonEndDate = dateFormatter.string(from: endDate)
         
         let dateFormat = DateFormatter()
         dateFormat.dateFormat = "MMM dd"
         let sDate = dateFormat.string(from: startDate)
         let eDate = dateFormat.string(from: endDate)
         btnSelectMonth.setTitle(sDate + " - " + eDate + " " + endDate.yearr, for: .normal)
         */
        
        
        let merchant : [String]  = ["\(AppConstants.merchantNumber)"]
        let param : [String : Any] = ["merchantNum" : merchant,
                                      "deviceId" : AppConstants.UserData.deviceID,
                                      "startDate":  AppConstants.jsonStartDate, "endDate":AppConstants.jsonEndDate]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.getSalesList)
        self.bindUI()
    }
    
    func selectTimeRange(startTimeValue: String, endTimeValue: String) {
        
    }
    
    func selectTimeRange(startTimeValue : String , endTimeValue : String, statTimeAMPM : String, endTimeAMPM : String){
        
    }
    
    
    
    
    @IBOutlet weak var btnSelectMonth: UIButton!
    
    //@IBOutlet weak var calendarView: FSCalendar!
    //@IBOutlet weak var calendarViewHieght: NSLayoutConstraint!
    @IBAction func goBack(_ sender: Any) {
        
        //        let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        //
        //        self.navigationController?.pushViewController(controller!, animated: false)
        
        self.navigationController?.popViewController(animated: true)
    }
    var selectedCellIndexPath: NSIndexPath?
    let selectedCellHeight: CGFloat = 300.0
    let unselectedCellHeight: CGFloat = 160.0
    
    
    @IBOutlet weak var tbSalesList: UITableView!
    var viewModel : RegistrationViewControllerViewModelProtocol?
    
    //DATE DROP DOWN VIEW
    @IBOutlet weak var dateViewRef: UIView!
    
    //SEGMENT BUTTON REF
    @IBOutlet var locationsBtnRef: UIButton!
    @IBOutlet var accountNumberBtnRef: UIButton!
    @IBOutlet var brandsBtnRef: UIButton!
    
    var showLocationData = true
    var showAccountNumberData = false
    var showBrandsData = false
    //@IBOutlet var allLocationViewRef: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.networkStatusChanged(_:)), name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        definesPresentationContext = true
        
        
        self.loopThroughSubViewAndMirrorImage(subviews: self.view.subviews)
        
        self.navigationController?.isNavigationBarHidden = true
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        self.tbSalesList.addSubview(refreshControl)
        //curvedviewShadow(view:calendarView)
        //calendarView.delegate = self
        //calendarView.dataSource = self
        //        calendarView.select(Date())
        //calendarView.select(AppConstants.jsonStartDate.dateFromFormat("yyyy-MM-dd"))
        
        currentMonthData()
        
        //calendarView.scope = .week
        //calendarAppearanceSetup(calendar: calendarView)
        
        viewModel = RegistrationViewControllerViewModel()
        CreditViewController.selectedFilter(button: btnSelectLocation)
        
        let merchant : [String]  = ["\(AppConstants.merchantNumber)"]
        
        let param : [String : Any] = ["merchantNum" : merchant,
                                      "deviceId" : AppConstants.UserData.deviceID,
                                      "startDate":  AppConstants.jsonStartDate,
                                      "endDate":AppConstants.jsonEndDate,]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.getSalesList)
        self.bindUI()
        
        ///DATE VIEW
        dateViewRef.layer.cornerRadius = 15
        dateViewRef.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        ///SEGMENT BUTTON VIEW
        locationsBtnRef.layer.cornerRadius = 5
        locationsBtnRef.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        brandsBtnRef.layer.cornerRadius = 5
        brandsBtnRef.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        
        accountNumberBtnRef.layer.borderWidth = 1
        
        locationsBtnRef.layer.borderWidth = 1
        brandsBtnRef.layer.borderWidth = 1
        
        locationsBtnRef.layer.borderColor = #colorLiteral(red: 0, green: 0.3960784314, blue: 0.6509803922, alpha: 1)
        brandsBtnRef.layer.borderColor = #colorLiteral(red: 0, green: 0.3960784314, blue: 0.6509803922, alpha: 1)
        accountNumberBtnRef.layer.borderColor = #colorLiteral(red: 0, green: 0.3960784314, blue: 0.6509803922, alpha: 1)
        
        ///ALL LOCATION VIEW
        //        allLocationViewRef.layer.cornerRadius = 5
        //        allLocationViewRef.dropShadow()
    }
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    // MARK: - refresh
    @objc func refresh() {
        
        //curvedviewShadow(view:calendarView)
        //calendarView.delegate = self
        //calendarView.dataSource = self
        //        calendarView.select(Date())
        //calendarView.select(AppConstants.jsonStartDate.dateFromFormat("yyyy-MM-dd"))
        
        currentMonthData()
        
        //calendarView.scope = .week
        //calendarAppearanceSetup(calendar: calendarView)
        
        viewModel = RegistrationViewControllerViewModel()
        CreditViewController.selectedFilter(button: btnSelectLocation)
        
        let merchant : [String]  = ["\(AppConstants.merchantNumber)"]
        let param : [String : Any] = ["merchantNum" : merchant,
                                      "deviceId" : AppConstants.UserData.deviceID,
                                      "startDate":  AppConstants.jsonStartDate,
                                      "endDate":AppConstants.jsonEndDate,]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.getSalesList)
        self.bindUI()
        refreshControl.endRefreshing()
    }
    
    var merchantNoArray : [String] = []
    var salesArray : [SaleDetailArr] = []
    
    func decodeResult<T: Decodable>(model: T.Type, result: NSDictionary) -> (model: T?, error: Error?) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
            let modelObject = try JSONDecoder().decode(model.self, from: jsonData)
            return (modelObject, nil)
        } catch let error {
            return (nil, error)
        }
    }
    var refreshControl: UIRefreshControl!
    
    private func bindUI() {
        
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
                        
                        let merchant : [String]  = ["\(AppConstants.merchantNumber)"]
                        let param : [String : Any] = ["merchantNum" : merchant,
                                                      "deviceId" : AppConstants.UserData.deviceID,
                                                      "startDate":  AppConstants.jsonStartDate,
                                                      "endDate":AppConstants.jsonEndDate,]
                        MBProgressHUD.showAdded(to: self!.view, animated: true)
                        self!.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.getSalesList)
                        self!.bindUI()
                        
                    } else {
                        
                        let message : String = userStatus.value(forKey: "message") as! String
                        let status : String = userStatus.value(forKey: "status") as! String
                        if status == "Success"{
                            let errorCode : String = userStatus.value(forKey: "errorCode") as! String
                            if errorCode == "L128"{
                                //                                print(message)
                                let object = self!.decodeResult(model: corporateSalesResp.self, result: userStatus)
                                let sales = object.model
                                if (sales!.saleDetails!.count > 0){
                                    //self!.salesArray = sales!.saleDetails!
                                    
                                    let ready = sales!.saleDetails!.sorted(by: { $0.locationName! < $1.locationName! })
                                    
                                    self?.salesArray = ready
                                    
                                    if self?.salesArray.count == 0 {
                                        self!.tbSalesList.setEmptyMessage("No Data Found !!")
                                    } else {
                                        self!.tbSalesList.restore()
                                    }
                                    
                                    self!.tbSalesList.reloadData()
                                }
                            }else{
                                self?.salesArray.removeAll()
                                
                                if self?.salesArray.count == 0 {
                                    self!.tbSalesList.setEmptyMessage("No Data Found !!")
                                } else {
                                    self!.tbSalesList.restore()
                                }
                                
                                self?.tbSalesList.reloadData()
                                //self!.showAlertWith(message: AlertMessage(title: "Sales".localiz(), body: message.localiz()))
                            }
                            
                        }else{
                            self!.showAlertWith(message: AlertMessage(title: "Sales".localiz(), body: message.localiz()))
                        }
                    }
                    
                }
                
            }else{
                self!.showAlertWith(message: AlertMessage(title: "Tijarati".localiz(), body: "Sorry, Failed to load data.".localiz()))
            }
            
        })
        
    }
    func currentMonthData(){
        
        let startDate = AppConstants.jsonStartDate.dateFromFormat("yyyy-MM-dd")
        let endDate = AppConstants.jsonEndDate.dateFromFormat("yyyy-MM-dd")
        
        if AppConstants.jsonStartDate == AppConstants.jsonEndDate {
            let selectedDateRange = startDate!.monthh.prefix(3) + " - " + String(endDate!.day) + ", " + endDate!.yearr
            btnSelectMonth.setTitle(selectedDateRange, for: .normal)
            
        }else{
            
            let selectedDateRange = startDate!.monthh.prefix(3) + " " + String(startDate!.day) + " - "
            let myEndDate = endDate!.monthh.prefix(3) + String(endDate!.day) + ", " + endDate!.yearr
            btnSelectMonth.setTitle(selectedDateRange + myEndDate, for: .normal)
            
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
    
    
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        //self.calendarViewHieght.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //            let cell = calendar.cell(for: date, at: monthPosition)
        
        // cell?.contentView.addBottomBorderWithColor AppConstants.jsonStartDate = date.stringFromFormat("yyyy-MM-dd")
        AppConstants.jsonStartDate = date.stringFromFormat("yyyy-MM-dd")
        AppConstants.jsonEndDate = date.stringFromFormat("yyyy-MM-dd")
        let selectedDateRange = date.monthh.prefix(3) + " - " + String(date.day) + ", " + date.yearr
        btnSelectMonth.setTitle(selectedDateRange, for: .normal)
        let merchant : [String]  = ["\(AppConstants.merchantNumber)"]
        let param : [String : Any] = ["merchantNum" : merchant,
                                      "deviceId" : AppConstants.UserData.deviceID,
                                      "startDate":  AppConstants.jsonStartDate,
                                      "endDate":AppConstants.jsonEndDate]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.getSalesList)
        self.bindUI()
        
    }
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //          let cell = calendar.cell(for: date, at: monthPosition)
        // cell?.contentView.removeLayer(layerName: "bottom")
        
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Calendar.current.date(byAdding: .month, value: -6, to: Date())!
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    
    func calendarAppearanceSetup(calendar:FSCalendar){
        
        //s  calendar.appearance.weekdayTextColor = UIColor.red
        //  calendar.appearance.headerTitleColor = UIColor.red
        calendar.appearance.eventDefaultColor = UIColor.clear
        // calendar.appearance.selectionColor = UIColor.blue
        calendar.appearance.headerDateFormat = "yyyy/MM"
        calendar.appearance.todayColor = UIColor.clear
        calendar.appearance.borderRadius = 0
        calendar.appearance.titleFont = UIFont(name: UIFont.Frutiger.roman.rawValue, size: 15)
        
        // calendar.appearance.headerMinimumDissolvedAlpha = 1.0
    }
    @IBAction func selectDateRange(_ sender: Any) {
        let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CalendarPopupViewController") as? CalendarPopupViewController
        controller?.popuptype = 0
        controller?.calendarClockdelegate = self
        presentAsStork(controller!, height: 650, cornerRadius: 8, showIndicator: false, showCloseButton: false)
    }
    
    //MARK:- TABLEVIEW METHODS
    
    //    func numberOfSections(in tableView: UITableView) -> Int {
    //        return 1
    //    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showLocationData{
            if salesArray.count != 0{
                return salesArray.count + 1
            }
            
        }else if showAccountNumberData{
            if salesArray.count != 0{
                return salesArray.count + 1
            }
            
        }else if showBrandsData{
            if salesArray.count != 0{
                return salesArray.count + 1
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let cell  =  tableView.cellForRow(at: indexPath) as? tbSalesCell
        cell?.onload()
        
    }
    @IBOutlet weak var btnSelectLocation: UIButton!
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if selectedCellIndexPath != nil && selectedCellIndexPath == indexPath as NSIndexPath {
            selectedCellIndexPath = nil
        } else {
            selectedCellIndexPath = indexPath as NSIndexPath
        }
        tbSalesList.reloadData()
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if selectedCellIndexPath == indexPath  as NSIndexPath{
            return selectedCellHeight
        }
        return unselectedCellHeight
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tbSalesCell", for: indexPath) as! tbSalesCell
        tbSalesList.separatorStyle = .none

        if showLocationData{
            if indexPath.row == 0{
                cell.lblSalesName.text = "All Location".localiz()
                cell.sideVerticalView.isHidden = false
                let sumOfAmt = salesArray.map { (Double($0.totalAmount ?? "0.000") ?? 0.0) }.reduce(0.0, +)
                cell.lblSalesAmount.text = "KD " + setAmounts(amount: "\(sumOfAmt)")
                cell.lblSalesAmount.attributedText =  cell.lblSalesAmount.text!.attributedString(fontsize: 18)
                
                let sumOfTxn = salesArray.map { (Int($0.totalCount ?? "0") ?? 0) }.reduce(0, +)
                cell.lblSalesTransaction.text = "\(sumOfTxn)" + " " + "Transactions".localiz()
                
                cell.collectionViewOffset = 10
                
                cccount = "\(salesArray.map { (Int($0.ccCount ?? "0") ?? 0) }.reduce(0, +))"
                intlcount = "\(salesArray.map { (Int($0.intlCount ?? "0") ?? 0) }.reduce(0, +))"
                dccount = "\(salesArray.map { (Int($0.dcCount ?? "0") ?? 0) }.reduce(0, +))"
                domesticcount = "\(salesArray.map { (Int($0.domesticCount ?? "0") ?? 0) }.reduce(0, +))"
                ccamount = "\(salesArray.map { (Double($0.ccAmount ?? "0.000") ?? 0.0) }.reduce(0.0, +))"
                dcamount = "\(salesArray.map { (Double($0.dcAmount ?? "0.000") ?? 0.0) }.reduce(0.0, +))"
                intlamount = "\(salesArray.map { (Double($0.intlAmount ?? "0.000") ?? 0.0) }.reduce(0.0, +))"
                domesticamount = "\(salesArray.map { (Double($0.domesticAmount ?? "0.000") ?? 0.0) }.reduce(0.0, +))"
                
                cell.collectionViewSale.tag = indexPath.row
                cell.collectionViewSale.reloadData()
            }else{
                
                cell.selectionStyle = .none
                cell.sideVerticalView.isHidden = true
                
                cell.collectionViewOffset = 10
                cell.lblSalesName.text = salesArray[indexPath.row - 1].locationName
                cell.lblSalesAmount.text = "KD " + setAmounts(amount: (salesArray[indexPath.row - 1].totalAmount ?? "0.000"))
                cell.lblSalesAmount.attributedText =  cell.lblSalesAmount.text!.attributedString(fontsize: 18)
                cell.lblSalesTransaction.text = (salesArray[indexPath.row - 1].totalCount ?? "0") + " " + "Transactions".localiz()
                cccount = salesArray[indexPath.row - 1].ccCount ?? "0"
                intlcount = salesArray[indexPath.row - 1].intlCount ?? "0"
                dccount = salesArray[indexPath.row - 1].dcCount ?? "0"
                domesticcount = salesArray[indexPath.row - 1].domesticCount ?? "0"
                ccamount = salesArray[indexPath.row - 1].ccAmount ?? "0.000"
                dcamount = salesArray[indexPath.row - 1].dcAmount ?? "0.000"
                intlamount = salesArray[indexPath.row - 1].intlAmount ?? "0.000"
                domesticamount = salesArray[indexPath.row - 1].domesticAmount ?? "0.000"
                
                cell.collectionViewSale.tag = indexPath.row
                cell.collectionViewSale.reloadData()
            }
            
            //
            if selectedCellIndexPath != nil && selectedCellIndexPath == indexPath as NSIndexPath {
                cell.showDetailView()
            } else {
                cell.onload()
            }
            
            return cell
        }else if showAccountNumberData{
            if indexPath.row == 0{
                cell.lblSalesName.text = "All Account"
                
                cell.sideVerticalView.isHidden = false
                
            }else{
                
                cell.selectionStyle = .none
                cell.sideVerticalView.isHidden = true
                
                cell.collectionViewOffset = 10
                cell.lblSalesName.text = salesArray[indexPath.row - 1].locationName
                cell.lblSalesAmount.text = "KD " + setAmounts(amount: (salesArray[indexPath.row - 1].totalAmount ?? "0.000"))
                cell.lblSalesAmount.attributedText =  cell.lblSalesAmount.text!.attributedString(fontsize: 18)
                cell.lblSalesTransaction.text = (salesArray[indexPath.row - 1].totalCount ?? "0") + " " + "Transactions".localiz()
                cccount = salesArray[indexPath.row - 1].ccCount ?? "0"
                intlcount = salesArray[indexPath.row - 1].intlCount ?? "0"
                dccount = salesArray[indexPath.row - 1].dcCount ?? "0"
                domesticcount = salesArray[indexPath.row - 1].domesticCount ?? "0"
                ccamount = salesArray[indexPath.row - 1].ccAmount ?? "0.000"
                dcamount = salesArray[indexPath.row - 1].dcAmount ?? "0.000"
                intlamount = salesArray[indexPath.row - 1].intlAmount ?? "0.000"
                domesticamount = salesArray[indexPath.row - 1].domesticAmount ?? "0.000"
                
                cell.collectionViewSale.tag = indexPath.row
                cell.collectionViewSale.reloadData()
            }
            if selectedCellIndexPath != nil && selectedCellIndexPath == indexPath as NSIndexPath {
                cell.showDetailView()
            } else {
                cell.onload()
            }

            return cell
        }else if showBrandsData{
            if indexPath.row == 0{
                cell.lblSalesName.text = "All Brands"
                
                cell.sideVerticalView.isHidden = false
                
            }else{
                
                cell.selectionStyle = .none
                cell.sideVerticalView.isHidden = true
                
                cell.collectionViewOffset = 10
                cell.lblSalesName.text = salesArray[indexPath.row - 1].locationName
                cell.lblSalesAmount.text = "KD " + setAmounts(amount: (salesArray[indexPath.row - 1].totalAmount ?? "0.000"))
                cell.lblSalesAmount.attributedText =  cell.lblSalesAmount.text!.attributedString(fontsize: 18)
                cell.lblSalesTransaction.text = (salesArray[indexPath.row - 1].totalCount ?? "0") + " " + "Transactions".localiz()
                cccount = salesArray[indexPath.row - 1].ccCount ?? "0"
                intlcount = salesArray[indexPath.row - 1].intlCount ?? "0"
                dccount = salesArray[indexPath.row - 1].dcCount ?? "0"
                domesticcount = salesArray[indexPath.row - 1].domesticCount ?? "0"
                ccamount = salesArray[indexPath.row - 1].ccAmount ?? "0.000"
                dcamount = salesArray[indexPath.row - 1].dcAmount ?? "0.000"
                intlamount = salesArray[indexPath.row - 1].intlAmount ?? "0.000"
                domesticamount = salesArray[indexPath.row - 1].domesticAmount ?? "0.000"
                
                cell.collectionViewSale.tag = indexPath.row
                cell.collectionViewSale.reloadData()
            }
            
            if selectedCellIndexPath != nil && selectedCellIndexPath == indexPath as NSIndexPath {
                cell.showDetailView()
            } else {
                cell.onload()
            }

            return cell
        }
        
        return cell
    }
    func setAmounts(amount : String) -> String{
        return (Double(amount)?.rounded(digits: 3).calculate)!
    }
    var cccount = ""
    var dccount = ""
    var intlcount = ""
    var domesticcount = ""
    var ccamount = ""
    var dcamount = ""
    var intlamount = ""
    var domesticamount = ""
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? tbSalesCell else { return }
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
        
    }
    
    
    @objc func salesDetailsHeadViewBtnTap(_ sender: UIButton){
        var superview = tbSalesList.superview
        while let view = superview, !(view is UITableViewCell) {
            superview = view.superview
            
        }
        
    }
    
    
    @IBAction func selectLocation(_ sender: Any) {
        if AppConstants.selectedFilter != nil {
            let controller = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SelectLocationViewController") as? SelectLocationViewController)!
            controller.delegateFilter = self
            presentAsStork(controller, height: 500, cornerRadius: 8.0, showIndicator: false, showCloseButton: false)
        }else{
            showAlertWith(message: AlertMessage(title: "Tijarati".localiz(), body: "No data available to filter.".localiz()))
        }
    }
}

//MARK:- COLLECTIONVIEW METHODS
extension SalesDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //pagerControl.currentPage = Int(scrollView.contentOffset.x)/Int(scrollView.frame.width - 50)
        
        let cell = scrollView.superview?.superview?.superview?.superview?.superview
        
        if (cell?.isKind(of: tbSalesCell.self))! {
            print("yes sales cell")
            if let cell : tbSalesCell = (scrollView.superview?.superview?.superview?.superview?.superview as? tbSalesCell) {
                
                cell.pagerControl.currentPage = Int(scrollView.contentOffset.x)/Int(scrollView.frame.width - 50)
                
            }
            
        } else {
            print("No not sales cell")
        }
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cvTbSalesCell", for: indexPath) as! cvSalesCell
        cell.progressView.layer.cornerRadius = 5
        cell.progressView.clipsToBounds = true
        cell.progressView.layer.sublayers![1].cornerRadius = 5
        cell.progressView.subviews[1].clipsToBounds = true
        
        if showLocationData{
            if collectionView.tag == 0{
                
                cccount = "\(salesArray.map { (Int($0.ccCount ?? "0") ?? 0) }.reduce(0, +))"
                intlcount = "\(salesArray.map { (Int($0.intlCount ?? "0") ?? 0) }.reduce(0, +))"
                dccount = "\(salesArray.map { (Int($0.dcCount ?? "0") ?? 0) }.reduce(0, +))"
                domesticcount = "\(salesArray.map { (Int($0.domesticCount ?? "0") ?? 0) }.reduce(0, +))"
                ccamount = "\(salesArray.map { (Double($0.ccAmount ?? "0.000") ?? 0.0) }.reduce(0.0, +))"
                dcamount = "\(salesArray.map { (Double($0.dcAmount ?? "0.000") ?? 0.0) }.reduce(0.0, +))"
                intlamount = "\(salesArray.map { (Double($0.intlAmount ?? "0.000") ?? 0.0) }.reduce(0.0, +))"
                domesticamount = "\(salesArray.map { (Double($0.domesticAmount ?? "0.000") ?? 0.0) }.reduce(0.0, +))"
                let sumOfAmt = salesArray.map { (Double($0.totalAmount ?? "0.000") ?? 0.0) }.reduce(0.0, +)
                
                if indexPath.row == 0{
                    cell.lblTitle1.text = "Debit Card".localiz()
                    cell.lblTitle2.text = "Credit Card".localiz()
                    //            cell.lblTransctn1.text = dccount + " " + "Transactions".localiz()
                    //            cell.lblTrnsctn2.text = cccount + " " + "Transactions".localiz()
                    //            cell.lblAmount1.text = "KD " + setAmounts(amount: dcamount)
                    //            cell.lblAmount2.text = "KD " + setAmounts(amount: ccamount)
                    
                    //collectionView.tag = salesArray.count + 1
                    cell.lblTransctn1.text = dccount + " " + "Transactions".localiz()
                    cell.lblTrnsctn2.text = cccount + " " + "Transactions".localiz()
                    cell.lblAmount1.text = "KD " + setAmounts(amount: dcamount)
                    
                    cell.lblAmount2.text = "KD " + setAmounts(amount: ccamount)
                    
                    cell.lblAmount1.attributedText = cell.lblAmount1.text!.attributedString(fontsize: 10)
                    cell.lblAmount2.attributedText = cell.lblAmount2.text!.attributedString(fontsize: 10)
                    
                    
                    let Amt = Double(dcamount) ?? 0.0
                    let totAmt = Double(sumOfAmt)
                    cell.progressView.setProgress( Float(Amt / totAmt), animated: true)
                    
                }else{
                    
                    cell.lblTitle1.text = "International".localiz()
                    cell.lblTitle2.text = "Domestic".localiz()
                    
                    //            cell.lblTransctn1.text = intlcount + " " + "Transactions".localiz()
                    //            cell.lblTrnsctn2.text = domesticcount + " " + "Transactions".localiz()
                    //            cell.lblAmount1.text = "KD " + setAmounts(amount: intlamount)
                    //            cell.lblAmount2.text = "KD " + setAmounts(amount: domesticamount)
                    
                    
                    cell.lblTransctn1.text = intlcount + " " + "Transactions".localiz()
                    cell.lblTrnsctn2.text = domesticcount + " " + "Transactions".localiz()
                    cell.lblAmount1.text = "KD " + setAmounts(amount: intlamount)
                    cell.lblAmount2.text = "KD " + setAmounts(amount: domesticamount)
                    
                    cell.lblAmount1.attributedText = cell.lblAmount1.text!.attributedString(fontsize: 10)
                    cell.lblAmount2.attributedText = cell.lblAmount2.text!.attributedString(fontsize: 10)
                    
                    let Amt = Double(intlamount) ?? 0.0
                    let totAmt = Double(sumOfAmt)
                    cell.progressView.setProgress( Float(Amt / totAmt), animated: true)
                    
                }
                
            }else{
                
                if indexPath.row == 0{
                    cell.lblTitle1.text = "Debit Card".localiz()
                    cell.lblTitle2.text = "Credit Card".localiz()
                    //            cell.lblTransctn1.text = dccount + " " + "Transactions".localiz()
                    //            cell.lblTrnsctn2.text = cccount + " " + "Transactions".localiz()
                    //            cell.lblAmount1.text = "KD " + setAmounts(amount: dcamount)
                    //            cell.lblAmount2.text = "KD " + setAmounts(amount: ccamount)
                    
                    //collectionView.tag = salesArray.count + 1
                    cell.lblTransctn1.text = (salesArray[collectionView.tag - 1].dcCount ?? "0") + " " + "Transactions".localiz()
                    cell.lblTrnsctn2.text = (salesArray[collectionView.tag - 1].ccCount ?? "0") + " " + "Transactions".localiz()
                    cell.lblAmount1.text = "KD " + setAmounts(amount: salesArray[collectionView.tag - 1].dcAmount ?? "0.000")
                    
                    cell.lblAmount2.text = "KD " + setAmounts(amount: salesArray[collectionView.tag - 1].ccAmount ?? "0.000")
                    
                    cell.lblAmount1.attributedText = cell.lblAmount1.text!.attributedString(fontsize: 10)
                    cell.lblAmount2.attributedText = cell.lblAmount2.text!.attributedString(fontsize: 10)
                    
                    
                    let Amt = Double(salesArray[collectionView.tag - 1].dcAmount ?? "0.000")
                    let totAmt = Double(salesArray[collectionView.tag - 1].totalAmount ?? "0.000")
                    cell.progressView.setProgress( Float(Amt! / totAmt!), animated: true)
                    
                }else{
                    
                    cell.lblTitle1.text = "International".localiz()
                    cell.lblTitle2.text = "Domestic".localiz()
                    
                    //            cell.lblTransctn1.text = intlcount + " " + "Transactions".localiz()
                    //            cell.lblTrnsctn2.text = domesticcount + " " + "Transactions".localiz()
                    //            cell.lblAmount1.text = "KD " + setAmounts(amount: intlamount)
                    //            cell.lblAmount2.text = "KD " + setAmounts(amount: domesticamount)
                    
                    
                    cell.lblTransctn1.text = (salesArray[collectionView.tag - 1].intlCount ?? "0") + " " + "Transactions".localiz()
                    cell.lblTrnsctn2.text = (salesArray[collectionView.tag - 1].domesticCount ?? "0") + " " + "Transactions".localiz()
                    cell.lblAmount1.text = "KD " + setAmounts(amount: salesArray[collectionView.tag - 1].intlAmount ?? "0.000")
                    cell.lblAmount2.text = "KD " + setAmounts(amount: salesArray[collectionView.tag - 1].domesticAmount ?? "0.000")
                    
                    cell.lblAmount1.attributedText = cell.lblAmount1.text!.attributedString(fontsize: 10)
                    cell.lblAmount2.attributedText = cell.lblAmount2.text!.attributedString(fontsize: 10)
                    
                    let Amt = Double(salesArray[collectionView.tag - 1].intlAmount ?? "0.000")
                    let totAmt = Double(salesArray[collectionView.tag - 1].totalAmount ?? "0.000")
                    cell.progressView.setProgress( Float(Amt! / totAmt!), animated: true)
                    
                }
            }
        }else if showAccountNumberData{
            if collectionView.tag == 0{
                
            }else{
                
                if indexPath.row == 0{
                    cell.lblTitle1.text = "Debit Card".localiz()
                    cell.lblTitle2.text = "Credit Card".localiz()
                    //            cell.lblTransctn1.text = dccount + " " + "Transactions".localiz()
                    //            cell.lblTrnsctn2.text = cccount + " " + "Transactions".localiz()
                    //            cell.lblAmount1.text = "KD " + setAmounts(amount: dcamount)
                    //            cell.lblAmount2.text = "KD " + setAmounts(amount: ccamount)
                    
                    //collectionView.tag = salesArray.count + 1
                    cell.lblTransctn1.text = (salesArray[collectionView.tag - 1].dcCount ?? "0") + " " + "Transactions".localiz()
                    cell.lblTrnsctn2.text = (salesArray[collectionView.tag - 1].ccCount ?? "0") + " " + "Transactions".localiz()
                    cell.lblAmount1.text = "KD " + setAmounts(amount: salesArray[collectionView.tag - 1].dcAmount ?? "0.000")
                    
                    cell.lblAmount2.text = "KD " + setAmounts(amount: salesArray[collectionView.tag - 1].ccAmount ?? "0.000")
                    
                    cell.lblAmount1.attributedText = cell.lblAmount1.text!.attributedString(fontsize: 10)
                    cell.lblAmount2.attributedText = cell.lblAmount2.text!.attributedString(fontsize: 10)
                    
                    
                    let Amt = Double(salesArray[collectionView.tag - 1].dcAmount ?? "0.000")
                    let totAmt = Double(salesArray[collectionView.tag - 1].totalAmount ?? "0.000")
                    cell.progressView.setProgress( Float(Amt! / totAmt!), animated: true)
                    
                }else{
                    
                    cell.lblTitle1.text = "International".localiz()
                    cell.lblTitle2.text = "Domestic".localiz()
                    
                    //            cell.lblTransctn1.text = intlcount + " " + "Transactions".localiz()
                    //            cell.lblTrnsctn2.text = domesticcount + " " + "Transactions".localiz()
                    //            cell.lblAmount1.text = "KD " + setAmounts(amount: intlamount)
                    //            cell.lblAmount2.text = "KD " + setAmounts(amount: domesticamount)
                    
                    
                    cell.lblTransctn1.text = (salesArray[collectionView.tag - 1].intlCount ?? "0") + " " + "Transactions".localiz()
                    cell.lblTrnsctn2.text = (salesArray[collectionView.tag - 1].domesticCount ?? "0") + " " + "Transactions".localiz()
                    cell.lblAmount1.text = "KD " + setAmounts(amount: salesArray[collectionView.tag - 1].intlAmount ?? "0.000")
                    cell.lblAmount2.text = "KD " + setAmounts(amount: salesArray[collectionView.tag - 1].domesticAmount ?? "0.000")
                    
                    cell.lblAmount1.attributedText = cell.lblAmount1.text!.attributedString(fontsize: 10)
                    cell.lblAmount2.attributedText = cell.lblAmount2.text!.attributedString(fontsize: 10)
                    
                    let Amt = Double(salesArray[collectionView.tag - 1].intlAmount ?? "0.000")
                    let totAmt = Double(salesArray[collectionView.tag - 1].totalAmount ?? "0.000")
                    cell.progressView.setProgress( Float(Amt! / totAmt!), animated: true)
                    
                }
            }
        }else if showBrandsData{
            if collectionView.tag == 0{
                
            }else{
                
                if indexPath.row == 0{
                    cell.lblTitle1.text = "Debit Card".localiz()
                    cell.lblTitle2.text = "Credit Card".localiz()
                    //            cell.lblTransctn1.text = dccount + " " + "Transactions".localiz()
                    //            cell.lblTrnsctn2.text = cccount + " " + "Transactions".localiz()
                    //            cell.lblAmount1.text = "KD " + setAmounts(amount: dcamount)
                    //            cell.lblAmount2.text = "KD " + setAmounts(amount: ccamount)
                    
                    //collectionView.tag = salesArray.count + 1
                    cell.lblTransctn1.text = (salesArray[collectionView.tag - 1].dcCount ?? "0") + " " + "Transactions".localiz()
                    cell.lblTrnsctn2.text = (salesArray[collectionView.tag - 1].ccCount ?? "0") + " " + "Transactions".localiz()
                    cell.lblAmount1.text = "KD " + setAmounts(amount: salesArray[collectionView.tag - 1].dcAmount ?? "0.000")
                    
                    cell.lblAmount2.text = "KD " + setAmounts(amount: salesArray[collectionView.tag - 1].ccAmount ?? "0.000")
                    
                    cell.lblAmount1.attributedText = cell.lblAmount1.text!.attributedString(fontsize: 10)
                    cell.lblAmount2.attributedText = cell.lblAmount2.text!.attributedString(fontsize: 10)
                    
                    
                    let Amt = Double(salesArray[collectionView.tag - 1].dcAmount ?? "0.000")
                    let totAmt = Double(salesArray[collectionView.tag - 1].totalAmount ?? "0.000")
                    cell.progressView.setProgress( Float(Amt! / totAmt!), animated: true)
                    
                }else{
                    
                    cell.lblTitle1.text = "International".localiz()
                    cell.lblTitle2.text = "Domestic".localiz()
                    
                    //            cell.lblTransctn1.text = intlcount + " " + "Transactions".localiz()
                    //            cell.lblTrnsctn2.text = domesticcount + " " + "Transactions".localiz()
                    //            cell.lblAmount1.text = "KD " + setAmounts(amount: intlamount)
                    //            cell.lblAmount2.text = "KD " + setAmounts(amount: domesticamount)
                    
                    
                    cell.lblTransctn1.text = (salesArray[collectionView.tag - 1].intlCount ?? "0") + " " + "Transactions".localiz()
                    cell.lblTrnsctn2.text = (salesArray[collectionView.tag - 1].domesticCount ?? "0") + " " + "Transactions".localiz()
                    cell.lblAmount1.text = "KD " + setAmounts(amount: salesArray[collectionView.tag - 1].intlAmount ?? "0.000")
                    cell.lblAmount2.text = "KD " + setAmounts(amount: salesArray[collectionView.tag - 1].domesticAmount ?? "0.000")
                    
                    cell.lblAmount1.attributedText = cell.lblAmount1.text!.attributedString(fontsize: 10)
                    cell.lblAmount2.attributedText = cell.lblAmount2.text!.attributedString(fontsize: 10)
                    
                    let Amt = Double(salesArray[collectionView.tag - 1].intlAmount ?? "0.000")
                    let totAmt = Double(salesArray[collectionView.tag - 1].totalAmount ?? "0.000")
                    cell.progressView.setProgress( Float(Amt! / totAmt!), animated: true)
                    
                }
            }
        }
        
        
        
        if AppConstants.language == .ar{
            cell.lblAmount1.textAlignment = NSTextAlignment.right
        }else{
            cell.lblAmount1.textAlignment = NSTextAlignment.left
        }
        
        if AppConstants.language == .ar{
            cell.lblTitle1.textAlignment = .right
            cell.lblTitle2.textAlignment = .left
            cell.lblAmount1.textAlignment = NSTextAlignment.right
            cell.lblAmount2.textAlignment = NSTextAlignment.left
            cell.lblTransctn1.textAlignment = NSTextAlignment.right
            cell.lblTrnsctn2.textAlignment = NSTextAlignment.left
            
        }else{
            
            cell.lblTitle1.textAlignment = .left
            cell.lblTitle2.textAlignment = .right
            cell.lblAmount1.textAlignment = NSTextAlignment.left
            cell.lblAmount2.textAlignment = NSTextAlignment.right
            cell.lblTransctn1.textAlignment = NSTextAlignment.left
            cell.lblTrnsctn2.textAlignment = NSTextAlignment.right
        }
        
        //cell.lblAmount1.attributedText = cell.lblAmount1.text!.attributedString(fontsize: 17)
        //  cell.lblAmount2.attributedText = cell.lblAmount2.text!.attributedString(fontsize: 17)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width - 10, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    //        return 5;
    //    }
}


//MARK:- SEGMENT BUTTON ACTION
extension SalesDetailViewController{
    @IBAction func locationsBtnTap(_ sender: UIButton){
        locationsBtnRef.backgroundColor = #colorLiteral(red: 0, green: 0.3960784314, blue: 0.6509803922, alpha: 1)
        accountNumberBtnRef.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        brandsBtnRef.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        locationsBtnRef.setTitleColor(UIColor.white, for: .normal)
        accountNumberBtnRef.setTitleColor(#colorLiteral(red: 0, green: 0.3960784314, blue: 0.6509803922, alpha: 1), for: .normal)
        brandsBtnRef.setTitleColor(#colorLiteral(red: 0, green: 0.3960784314, blue: 0.6509803922, alpha: 1), for: .normal)
        
        showLocationData = true
        showAccountNumberData = false
        showBrandsData = false
        
        tbSalesList.reloadData()
    }
    
    @IBAction func accountNumberBtnTap(_ sender: UIButton){
        accountNumberBtnRef.backgroundColor = #colorLiteral(red: 0, green: 0.3960784314, blue: 0.6509803922, alpha: 1)
        locationsBtnRef.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        brandsBtnRef.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        accountNumberBtnRef.setTitleColor(UIColor.white, for: .normal)
        locationsBtnRef.setTitleColor(#colorLiteral(red: 0, green: 0.3960784314, blue: 0.6509803922, alpha: 1), for: .normal)
        brandsBtnRef.setTitleColor(#colorLiteral(red: 0, green: 0.3960784314, blue: 0.6509803922, alpha: 1), for: .normal)
        
        showLocationData = false
        showAccountNumberData = true
        showBrandsData = false
        
        tbSalesList.reloadData()
        
    }
    
    @IBAction func brandsBtnTap(_ sender: UIButton){
        brandsBtnRef.backgroundColor = #colorLiteral(red: 0, green: 0.3960784314, blue: 0.6509803922, alpha: 1)
        locationsBtnRef.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        accountNumberBtnRef.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        brandsBtnRef.setTitleColor(UIColor.white, for: .normal)
        locationsBtnRef.setTitleColor(#colorLiteral(red: 0, green: 0.3960784314, blue: 0.6509803922, alpha: 1), for: .normal)
        accountNumberBtnRef.setTitleColor(#colorLiteral(red: 0, green: 0.3960784314, blue: 0.6509803922, alpha: 1), for: .normal)
        
        showLocationData = false
        showAccountNumberData = false
        showBrandsData = true
        
        tbSalesList.reloadData()
        
    }
    
}

//MARK:- Sales details btn delegate
extension SalesDetailViewController: expandSalesDetailsDelegate{
    func expandSalesDetailsBtnTappedInCell(_ cell: SalesDetailsHeaderTVC) {
        var value = cell.showExpandDetailsView
        value = false
        
        if cell.showExpandDetailsView == true{
            cell.showExpandDetailsView = false
            //cell.expandDetailsViewRef.isHidden = true
            print("Value:- \(value)")
            
            print("closed")
            tbSalesList.sectionHeaderHeight = 165
            
        }else{
            cell.showExpandDetailsView = true
            //cell.expandDetailsViewRef.isHidden = false
            print("opened")
            print("Value:- \(value)")
            tbSalesList.sectionHeaderHeight = 311
            //cell.cvRef.reloadData()
            
        }
        
        tbSalesList.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .none)
        //cell.showExpandDetailsView = !cell.showExpandDetailsView
        
        // DispatchQueue.main.async {
        //self.tbSalesList.reloadData()
        //self.tbSalesList.reloadSections(IndexSet(0..<1), with: .automatic)
        
        // UIView.setAnimationsEnabled(false)
        //self.tbSalesList.beginUpdates()
        // self.tbSalesList.reloadSections(NSIndexSet(index: 0) as IndexSet, with: UITableView.RowAnimation.none)
        // self.tbSalesList.endUpdates()
        
        
        // }
        
        
    }
    
    
}
