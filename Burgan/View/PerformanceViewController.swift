//
//  PerformanceViewController.swift
//  Burgan
//
//  Created by Malti Maurya on 19/03/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit
import FSCalendar

class PerformanceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FSCalendarDelegate, FSCalendarDataSource, applyFilterDelegate,calendarDelegate{
    func applyFilter(heirarchy: selectedFilterData, isCif: Bool) {
        AppConstants.isCif = isCif
         btnSelectLocation.setTitle(AppConstants.selectedFilter!.companyName + "(" + String(AppConstants.selectedFilter!.selectedMerchants.count) + ")  ", for: .normal)
                      print("merchantno : " , AppConstants.merchantNumber)
        AppConstants.cifCompanyName = AppConstants.selectedFilter!.companyName
        AppConstants.UserData.companyCIF = AppConstants.selectedFilter!.cif
               performanceGraphList()
    }
    
    func selectDateRange(startDate: Date, endDate: Date) {
       
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
        
        
        performanceGraphList()
        
    }
    
    func selectTimeRange(startTimeValue: String, endTimeValue: String) {
        //no values
    }
    func selectTimeRange(startTimeValue : String , endTimeValue : String, statTimeAMPM : String, endTimeAMPM : String){
        
    }
 
    
 
    
//    @IBOutlet weak var calendarViewHeight: NSLayoutConstraint!
    @IBOutlet weak var btnSelectLocation: UIButton!
    
    @IBOutlet weak var btnSelectMonth: UIButton!
//    @IBOutlet weak var calendarView: FSCalendar!
    
    @IBAction func goBack(_ sender: Any) {
      
        let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
          
        self.navigationController?.pushViewController(controller!, animated: false)
      }
    
    @IBOutlet weak var tbPerformacneList: UITableView!
    var selectedCellIndexPath: NSIndexPath?
    let selectedCellHeight: CGFloat = 500.0
    let unselectedCellHeight: CGFloat = 180.0   //240.0

    @IBAction func selectDateRange(_ sender: Any) {
        let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CalendarPopupViewController") as? CalendarPopupViewController
                      controller?.popuptype = 0
        controller?.calendarClockdelegate = self
                      presentAsStork(controller!, height: 650, cornerRadius: 8, showIndicator: false, showCloseButton: false)
    }
    override func viewDidLoad() {
          super.viewDidLoad()
        
        self.loopThroughSubViewAndMirrorImage(subviews: self.view.subviews)
        
        self.navigationController?.isNavigationBarHidden = true

//                curvedviewShadow(view:calendarView)
//                calendarView.delegate = self
//                calendarView.dataSource = self
////        calendarView.select(Date())
//        calendarView.select(AppConstants.jsonStartDate.dateFromFormat("yyyy-MM-dd"))
//
//        btnSelectMonth.setTitle(calendarView.currentPage.monthh + ", " + calendarView.currentPage.yearr + "     ", for: .normal)
//        calendarView.scope = .week
//        calendarAppearanceSetup(calendar: calendarView)
        currentMonthData()
          viewModel = RegistrationViewControllerViewModel()
        CreditViewController.selectedFilter(button: btnSelectLocation)
        performanceGraphList()
      }
    
    
    func curvedviewShadow(view:UIView){
         
             view.layer.cornerRadius = 8
             view.layer.shadowOpacity = 0.35
             view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
             view.layer.shadowRadius = 3.0
         view.layer.shadowColor = UIColor.BurganColor.brandGray.lgiht.cgColor
             view.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner,.layerMaxXMinYCorner]
     }

    var viewModel : RegistrationViewControllerViewModelProtocol?
    var performanceArray : [PerformanceData] = []
    
    func performanceGraphList(){
        
        let merchant : [String]  = ["\(AppConstants.merchantNumber)"]

        let param : [String : Any] = ["merchantNum" : merchant,
                                      "deviceId" : AppConstants.UserData.deviceID,
                                      "startDate" : AppConstants.jsonStartDate,
                                      "endDate" : AppConstants.jsonEndDate]
         MBProgressHUD.showAdded(to: self.view, animated: true)
        self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.getPerformanceList)
          self.bindGraphUI()
    }
    
   func currentMonthData(){
    
    let startDate = AppConstants.jsonStartDate.dateFromFormat("yyyy-MM-dd")
              let endDate = AppConstants.jsonEndDate.dateFromFormat("yyyy-MM-dd")
              
              if AppConstants.jsonStartDate == AppConstants.jsonEndDate{
                let selectedDateRange = startDate!.monthh.prefix(3) + " - " + String(endDate!.day) + ", " + endDate!.yearr
                               btnSelectMonth.setTitle(selectedDateRange, for: .normal)

              }else{
                 
                let selectedDateRange = startDate!.monthh.prefix(3) + " " + String(startDate!.day) + " - "
                let myEndDate = endDate!.monthh.prefix(3) + String(endDate!.day) + ", " + endDate!.yearr
                  btnSelectMonth.setTitle(selectedDateRange + myEndDate, for: .normal)

              }
           
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
       
    
  private func bindGraphUI() {
         
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
                        
                        self?.performanceGraphList()
                        
                    } else {
                        
                        let message : String = userStatus?.value(forKey: "message") as! String
                        let status : String = userStatus?.value(forKey: "status") as! String
                        if status == "Success"{
                            let errorCode : String = userStatus?.value(forKey: "errorCode") as! String
                            if errorCode == "L128"
                            {
                                let object = self!.decodeResult(model: performanceListResponse.self, result: userStatus!)
                                
                                if let performance = object.model
                                {
                                    self!.performanceArray = performance.performance
                                    
                                    if self!.performanceArray.count == 0 {
                                        self!.tbPerformacneList.setEmptyMessage("No Data Found !!")
                                    } else {
                                        self!.tbPerformacneList.restore()
                                    }
                                    
                                    self!.tbPerformacneList.reloadData()
                                }else{
                                    self!.showAlertWith(message: AlertMessage(title: "Performance".localiz(), body: "Invalid Data.".localiz()))
                                }
                                
                                
                            }else{
                                
                                if self!.performanceArray.count == 0 {
                                    self!.tbPerformacneList.setEmptyMessage("No Data Found !!")
                                } else {
                                    self!.tbPerformacneList.restore()
                                }
                                //self!.showAlertWith(message: AlertMessage(title: "Performance".localiz(), body: message))
                            }
                            
                            
                        }else{
                            self!.showAlertWith(message: AlertMessage(title: "Tijarati".localiz(), body: message.localiz()))
                        }
                        
                    }
                    

                } else {
                    
                }
             }
             
         })
         
     }
     
       func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
//           self.calendarViewHeight.constant = bounds.height
                self.view.layoutIfNeeded()
        }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//            let cell = calendar.cell(for: date, at: monthPosition)
        
           // cell?.contentView.addBottomBorderWithColor AppConstants.jsonStartDate = date.stringFromFormat("yyyy-MM-dd")
        AppConstants.jsonStartDate = date.stringFromFormat("yyyy-MM-dd")
        AppConstants.jsonEndDate = date.stringFromFormat("yyyy-MM-dd")
        let selectedDateRange = date.monthh.prefix(3) + " - " + String(date.day) + ", " + date.yearr
        btnSelectMonth.setTitle(selectedDateRange, for: .normal)
        performanceGraphList()
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
      
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return performanceArray.count
    }
      func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
          
          let cell  =  tableView.cellForRow(at: indexPath) as? TbPerformanceListCell
        cell?.showSmallChart()
    }
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

          
          if selectedCellIndexPath != nil && selectedCellIndexPath == indexPath as NSIndexPath {
                 selectedCellIndexPath = nil
             } else {
              selectedCellIndexPath = indexPath as NSIndexPath
             }

             tableView.beginUpdates()
             tableView.endUpdates()
          if selectedCellIndexPath != nil {

              let cell  =  tableView.cellForRow(at: indexPath) as? TbPerformanceListCell
            cell?.hideSmallChart()
          }else{
              
              let cell  =  tableView.cellForRow(at: indexPath) as? TbPerformanceListCell
            cell?.showSmallChart()
        
        }
      }
      @IBOutlet weak var btnMonth: UIButton!
    
      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          
            if selectedCellIndexPath == indexPath  as NSIndexPath{
                return selectedCellHeight
            }
            return unselectedCellHeight
      }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "TbPerformanceListCell", for: indexPath) as! TbPerformanceListCell
            cell.lblPerformanceName.text = performanceArray[indexPath.row].locationName
            if performanceArray[indexPath.row].graphData.count > 0
            {
                var transactions : [Double] = []
                var amounts : [Double] = []
                var dateList : [String] = []
                var fullDateList : [String] = []
                var totalAmount : Double = 0.0
                var totalTransactionCount : Int = 0
                for i in 0..<performanceArray[indexPath.row].graphData.count {
                    
                    let graph = performanceArray[indexPath.row].graphData[i]
                    transactions.append(Double(graph.txnCount!)!)
                    if  let date = graph.duration.dateFromFormat("yyyy-MM-dd") {
                        
                        dateList.append(String(date.day) + " " + String(date.monthh))
                        fullDateList.append(String(date.day) + " " + String(date.monthh))
                    } else {
                        dateList.append(graph.duration)
                        fullDateList.append(graph.duration)
                    }
                
                    amounts.append(Double(graph.txnAmount)!)
                
//                    totalAmount = totalAmount + Double((graph.txnCount! as NSString).doubleValue)
                    totalAmount = totalAmount + Double((graph.txnAmount as NSString).doubleValue)
                    
                    totalTransactionCount = totalTransactionCount + Int(graph.txnCount!)!
                }
                
                cell.setLineGraph(sales: amounts, transactions: transactions, dates: dateList, fulldate : fullDateList)
                // cell.chartSetup(sales: amounts, transactions: transactions, category: dateList)
                //  cell.chartDeatilSetup(sales: amounts, transactions: transactions, category: dateList)
                cell.lblAmount.text = String(format: "%.2f", Double(totalAmount))
                cell.lblAmount.text = String(format: "%.2f", Double(totalAmount))
                
                cell.lblAmount.text = "KD " + setAmounts(amount: "\(totalAmount)")
                cell.lblAmount.attributedText =  cell.lblAmount.text!.attributedString(fontsize: 12)
                
                cell.lblTransactions.text = "\(totalTransactionCount)" + " " + "Transactions".localiz()
                
            } else {
                cell.chartSetup(sales: [0], transactions: [0], category: ["S", "M", "T","W","T","F","S","S"])
            }
              
          return cell
    }
        
    @IBAction func selectLocation(_ sender: Any) {
        if AppConstants.selectedFilter != nil {
            let controller = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SelectLocationViewController") as? SelectLocationViewController)!
            controller.delegateFilter = self
            presentAsStork(controller, height: 500, cornerRadius: 8.0, showIndicator: false, showCloseButton: false)
          } else {
            showAlertWith(message: AlertMessage(title: "Tijarati".localiz(), body: "No data available to filter.".localiz()))
        }
    }
 
}
