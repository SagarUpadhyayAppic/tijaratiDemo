//
//  DashBoardViewController.swift
//  Burgan
//
//  Created by Malti Maurya on 18/03/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit
import AAInfographics
import Charts
import FSCalendar
import SPStorkController
import BubbleTransition
import LanguageManager_iOS


protocol applyFilterDelegate : class{
    func applyFilter(heirarchy: selectedFilterData, isCif : Bool)
}

class DashBoardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance,  applyFilterDelegate,UICollectionViewDelegateFlowLayout, UIViewControllerTransitioningDelegate, calendarDelegate, ChartViewDelegate {
    
    func applyFilter(heirarchy: selectedFilterData, isCif: Bool) {
        /*
         AppConstants.isCif = isCif
         btnApplyFilter.setTitle(AppConstants.selectedFilter!.companyName + "(" + String(AppConstants.selectedFilter!.selectedMerchants.count) + ")  ", for: .normal)
         
         if isCif{
         corporateDashRequest(startDate: AppConstants.jsonStartDate, endDate: AppConstants.jsonEndDate, cif: AppConstants.selectedFilter!.cif)
         }else{
         merchantDashRequest(startDate: AppConstants.jsonStartDate, endDate: AppConstants.jsonEndDate)
         
         }
         */
        
        AppConstants.isCif = isCif
        btnApplyFilter.setTitle(AppConstants.selectedFilter!.companyName + "(" + String(AppConstants.selectedFilter!.selectedMerchants.count) + ")  ", for: .normal)
        AppConstants.cifCompanyName = AppConstants.selectedFilter!.companyName
        AppConstants.UserData.companyCIF = AppConstants.selectedFilter!.cif
        //mmmmmmalti
        if AppConstants.UserData.merchantRole == "Admin"
        {
            if AppConstants.isCif {
                corporateDashRequest(startDate: AppConstants.jsonStartDate, endDate: AppConstants.jsonEndDate, cif: AppConstants.selectedFilter!.cif)
            } else {
                merchantDashRequest(startDate: AppConstants.jsonStartDate, endDate: AppConstants.jsonEndDate)
            }
        } else {
            merchantDashRequest(startDate: AppConstants.jsonStartDate, endDate: AppConstants.jsonEndDate)
        }
    }
    
    @IBOutlet weak var btnApplyFilter: UIButton!
//    @IBOutlet weak var calendarViewHeight: NSLayoutConstraint!
    @IBOutlet weak var lblCreditBankAmount: UILabel!
    @IBOutlet weak var performanceViewCurved: UIView!
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var btnSelectDate: UIButton!
//    @IBOutlet weak var calendarview: FSCalendar!
    @IBOutlet weak var yellowCurvedView: GradientLayer!
    @IBOutlet weak var cvSales: UICollectionView!
    @IBOutlet weak var lblSalesTransactions: UILabel!
    @IBOutlet weak var lblSalesAmount: UILabel!
    @IBOutlet weak var creditViewCurved: UIView!
    @IBOutlet weak var pagerControl: UIPageControl!
    
    @IBOutlet weak var lblNotificationsCount: UILabel!
    
    @IBOutlet weak var lblSales: UILabel!
    
    @IBOutlet weak var performanceLabel: UILabel!
    
    @IBAction func notifications(_ sender: Any) {
    }
    
    @IBOutlet weak var ivSalesCardBg: UIImageView!
    
    @IBOutlet weak var lblContactlessDescpt: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    var ccCount = "0"
    var dcCount = "0"
    var slAmount = "0.000"
    var ccAmount = "0.000"
    var dcAmount = "0.000"
    var domesticAmount = "0.000"
    var domesticCount = "0"
    var internationalCount = "0"
    var internationalAmount = "0.000"
    
    var cornerRadius : CGFloat = 10
    
    var refreshControl: UIRefreshControl!
    
    
    @IBAction func onScroll(_ sender: Any) {
        let page = pagerControl.currentPage
        var frame:CGRect = cvSales.frame
        frame.origin.x = frame.size.width * CGFloat(page)
        frame.origin.y = 0
        cvSales.scrollRectToVisible(frame, animated: true)
        
    }
    
    @IBAction func applyFilter(_ sender: Any) {
        if AppConstants.selectedFilter != nil {
            let controller = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SelectLocationViewController") as? SelectLocationViewController)!
            controller.delegateFilter = self
            
            presentAsStork(controller, height: 500, cornerRadius: 8.0, showIndicator: false, showCloseButton: false)
        }else{
            showAlertWith(message: AlertMessage(title: "Tijarati".localiz(), body: "No data available to filter.".localiz()))
        }
        
    }
    @IBAction func salesViewMore(_ sender: Any) {
        
        let controller = UIStoryboard.init(name: "Sales", bundle: Bundle.main).instantiateViewController(withIdentifier: "SalesDetailViewController") as? SalesDetailViewController
        self.navigationController?.pushViewController(controller!, animated: true)
    }
    
    @IBAction func selectDateRange(_ sender: Any) {
        
        let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CalendarPopupViewController") as? CalendarPopupViewController
        controller?.popuptype = 0
        controller?.calendarClockdelegate = self
        presentAsStork(controller!, height: 650, cornerRadius: 8, showIndicator: false, showCloseButton: false)
    }
    
    // MARK: - UICollectionView Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width - 10, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pagerControl.currentPage = indexPath.row
    }
    
    //    - (CGFloat)collectionView:(UICollectionView *)collectionView
    //                         layout:(UICollectionViewLayout *)collectionViewLayout
    //              minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    //          return 0;
    //      }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5;
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pagerControl.currentPage = Int(scrollView.contentOffset.x)/Int(scrollView.frame.width - 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cvSalesCell", for: indexPath) as! cvSalesCell
        
        cell.progressView.layer.cornerRadius = 5
        cell.progressView.clipsToBounds = true
        cell.progressView.layer.sublayers![1].cornerRadius = 5
        cell.progressView.subviews[1].clipsToBounds = true
        if indexPath.row == 0 {
            cell.lblTitle1.text = "Debit Card".localiz()
            cell.lblTitle2.text = "Credit Card".localiz()
            cell.lblAmount1.text = "KD " + setAmounts(amount: dcAmount)
            cell.lblAmount2.text =  "KD " + setAmounts(amount: ccAmount)
            cell.lblTransctn1.text = dcCount + " " + "Transactions".localiz()
            cell.lblTrnsctn2.text = ccCount + " " + "Transactions".localiz()
            
            cell.lblAmount1.attributedText = cell.lblAmount1.text?.attributedString(fontsize: 17)
            cell.lblAmount2.attributedText = cell.lblAmount2.text?.attributedString(fontsize: 17)
            
            let dcAmt = Double(dcAmount)
            let slAmt = Double(slAmount)
            
            //            cell.progressView.setProgress( Float(Double(dcAmt!) / Double(slAmt!)), animated: true)
            cell.progressView.setProgress( Float(dcAmt! / slAmt!), animated: true)
            
        } else {
            cell.lblTitle1.text = "International".localiz()
            cell.lblTitle2.text = "Domestic".localiz()
            cell.lblAmount1.text =  "KD " + setAmounts(amount: internationalAmount)
            cell.lblAmount2.text =  "KD " + setAmounts(amount: domesticAmount)
            cell.lblTransctn1.text = internationalCount + " " + "Transactions".localiz()
            cell.lblTrnsctn2.text = domesticCount + " " + "Transactions".localiz()
            
            cell.lblAmount1.attributedText = cell.lblAmount1.text?.attributedString(fontsize: 17)
            cell.lblAmount2.attributedText = cell.lblAmount2.text?.attributedString(fontsize: 17)
            
            let domAmt = Double(internationalAmount)
            let slAmt = Double(slAmount)
            cell.progressView.setProgress( Float(domAmt! / slAmt!), animated: true)
            
        }
        
        if AppConstants.language == .ar{
            cell.lblTitle1.textAlignment = .right
            cell.lblTitle2.textAlignment = .left
            cell.lblAmount1.textAlignment = NSTextAlignment.right
            cell.lblAmount2.textAlignment = NSTextAlignment.left
            cell.lblTransctn1.textAlignment = .right
            cell.lblTrnsctn2.textAlignment = NSTextAlignment.left
            
        }else{
            
            cell.lblTitle1.textAlignment = .left
            cell.lblTitle2.textAlignment = .right
            cell.lblAmount1.textAlignment = NSTextAlignment.left
            cell.lblAmount2.textAlignment = NSTextAlignment.right
            cell.lblTransctn1.textAlignment = .left
            cell.lblTrnsctn2.textAlignment = NSTextAlignment.right
        }
        
        return cell
    }
    
    
    // MARK: - Set Line Graph
    func setLineGraph(sales: [Double], transactions: [Double], dates : [String], fulldate : [String]) {
        
        chartView.delegate = self
        
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = false
        chartView.doubleTapToZoomEnabled = false
        
        
        chartView.xAxis.setLabelCount(sales.count, force: false)
        chartView.xAxis.labelTextColor = UIColor.BurganColor.brandGray.medium
        // chartView.xAxis.labelFont = UIFont(name: "OpenSans", size: 10)!
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.granularity = 1.0
        chartView.xAxis.granularityEnabled = true
        
        
        let leftAxis = chartView.leftAxis
        leftAxis.removeAllLimitLines()
        
        //leftAxis.axisMinimum = 0
        leftAxis.axisMinimum = 0
        leftAxis.gridLineDashLengths = [0, 0]
        leftAxis.drawLimitLinesBehindDataEnabled = false
        // leftAxis.labelFont = UIFont(name: "OpenSans-Bold", size: 10)!
        leftAxis.labelTextColor =  UIColor.BurganColor.brandGray.medium //UIColor.BurganColor.brandBlue.medium
        leftAxis.drawGridLinesEnabled = true
        leftAxis.gridColor = UIColor(hexString: "B0DAEA", alpha: 0.3) //UIColor.BurganColor.brandBlue.veryLight
        leftAxis.gridLineWidth = 1
        leftAxis.valueFormatter = LargeValueFormatter(appendix: "")
        leftAxis.axisLineWidth = 0
        
        let rightAxis = chartView.rightAxis
        rightAxis.removeAllLimitLines()
        //leftAxis.axisMinimum = 0
        rightAxis.axisMinimum = transactions.min()!
        rightAxis.axisMaximum = transactions.max()!
        rightAxis.gridLineDashLengths = [0, 0]
        rightAxis.drawLimitLinesBehindDataEnabled = false
        // leftAxis.labelFont = UIFont(name: "OpenSans-Bold", size: 10)!
        rightAxis.labelTextColor =  UIColor.BurganColor.brandOrange.orange
        rightAxis.drawGridLinesEnabled = false
        rightAxis.gridColor =   UIColor.BurganColor.brandOrange.orange
        rightAxis.gridLineWidth = 2
        rightAxis.valueFormatter = LargeValueFormatter(appendix: "")
        rightAxis.axisLineWidth = 0
        let salesstring = sales.map{String(format: "%.3f", $0)}
        let transtring = transactions.map{String($0)}
        
        var mytime = [String]()
        for i in 0..<dates.count {
            if  let date = dates[i].dateFromFormat("dd MMMM")
            {
                print(date)
                mytime.append(fulldate[i])
                
            } else {
                //mytime.append(dates[i])
                // mytime.append(self.convertDateToSpecificFormat(date: dates[i], currentFormat: "HH", desiredFormat: "HH:ss a"))
                let dateString = dates[i] != "24" ? dates[i] : "00"
                mytime.append(self.convertDateToSpecificFormat(date: dateString, currentFormat: "HH", desiredFormat: "HH:ss a"))
            }
        }
        
        let marker = XYCustomMarker( color:  UIColor.BurganColor.brandGray.light,
                                     font: UIFont.systemFont(ofSize: 10),
                                     textColor: UIColor.BurganColor.brandBlue.medium,
                                     insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8),
                                     xAxisValueFormatter: IndexAxisValueFormatter(values: dates),
                                     yAxisValueFormatter: rightAxis.valueFormatter!, CompletionStr: dates)
        
        //       marker.minimumSize = CGSize(width: 50, height: 50)
        marker.size = CGSize(width: 50, height: 50)
        let vc: MyMarkerVC = (MyMarkerVC.viewFromXib() as? MyMarkerVC)!
        vc.chartView = chartView
        //       vc.arrayPassVal(correctAry: fulldate, incorrectAry: salesstring, unansweredAry: transtring, fromWhere: "resultView")
        vc.arrayPassVal(correctAry: mytime, incorrectAry: salesstring, unansweredAry: transtring, fromWhere: "resultView")
        
        chartView.marker = vc
        chartView.drawMarkers = true
        
        
        let pFormatter = NumberFormatter()
        pFormatter.locale = Locale(identifier: "en")
        pFormatter.numberStyle = .currency
        pFormatter.currencySymbol = "K"
        //        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1.0
        
        let cFormatter = NumberFormatter()
        cFormatter.locale = Locale(identifier: "en")
        cFormatter.numberStyle = .none
        cFormatter.multiplier = 1.0
        
        
        chartView.rightAxis.valueFormatter = DefaultValueFormatter(formatter: pFormatter) as? IAxisValueFormatter
        chartView.leftAxis.valueFormatter = DefaultValueFormatter(formatter: cFormatter) as? IAxisValueFormatter
        chartView.leftAxis.labelTextColor = UIColor.BurganColor.brandGray.medium //UIColor.BurganColor.brandBlue.medium
        chartView.rightAxis.labelTextColor = UIColor.BurganColor.brandOrange.orange
        // chartView.leftAxis.labelFont = UIFont(name: "OpenSans", size: 10)!
        //        chartView.leftAxis.axisMinimum = 0
        //        chartView.leftAxis.axisMaximum = sales.max()!
        //        chartView.rightAxis.axisMinimum = transactions.min()!
        //        chartView.rightAxis.axisMaximum = transactions.max()!
        
        chartView.leftAxis.resetCustomAxisMin()
        chartView.leftAxis.resetCustomAxisMax()
        chartView.rightAxis.resetCustomAxisMin()
        chartView.rightAxis.resetCustomAxisMax()
        
        
        chartView.rightAxis.enabled = false
        
        chartView.xAxis.labelPosition = .bottom
        
        chartView.xAxis.labelWidth = 25.0
        
        //        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dates)
        // By Me
        
        var myDates = [String]()
        for i in 0..<dates.count {
            if  let date = dates[i].dateFromFormat("dd MMMM")
            {
                print(date)
                //                myDates.append(String(date.day))
                myDates.append(self.convertDateToSpecificFormat(date: dates[i], currentFormat: "dd MMMM", desiredFormat: "dd"))
                
                //                myDates.append(String(date.day) + " " + date.monthh + " " + date.yearr)
            } else {
                myDates.append(dates[i])
                //                myDates.append(dates[i])
            }
        }
        
        let xAxis = XAxis()
        let chartFormmater = IndexAxisValueFormatter()
        //        chartFormmater.values = dates
        chartFormmater.values = myDates
        xAxis.valueFormatter=chartFormmater
        chartView.xAxis.valueFormatter=xAxis.valueFormatter
        // By Me Over
        
        
        chartView.legend.form = .line
        chartView.legend.enabled = false
        chartView.xAxis.setLabelCount(dates.count, force: false)
        chartView.xAxis.granularity = 1.0
        chartView.xAxis.granularityEnabled = true
        chartView.xAxis.labelRotationAngle = -90.0
        
        
        //        chartView.setVisibleXRangeMaximum(3)
        
        //let dataArray:[Double] = [1.0,13.0,17.0,23.0,37.0,45.0,59.0,62.0,75.0,82.0,88.0,95.0,100.0]
        self.setDataCount(sales: sales, transactions: transactions)
        
    }
    
    func setDataCount(sales: [Double], transactions: [Double]) {
        
        let values = (0..<sales.count).map { (i) -> ChartDataEntry in
            
            let perVal : Double = sales[i]
            return ChartDataEntry(x: Double(i), y: perVal)
        }
        
        let values2 = (0..<transactions.count).map { (i) -> ChartDataEntry in
            
            let perVal : Double = transactions[i]
            
            return ChartDataEntry(x: Double(i), y: perVal)
        }
        
        //        let values = (0..<count).map { (i) -> ChartDataEntry in
        //            let val = Double(arc4random_uniform(range) + 3)
        //                    return ChartDataEntry(x: Double(i), y: val, icon: #imageLiteral(resourceName: "icon"))
        //        }
        //        var values = [ChartDataEntry]()
        //
        //        else{
        //            values = (0..<arrLineChart.count).map { (i) -> ChartDataEntry in
        //
        //                return ChartDataEntry(x: Double(i), y: Double(arrLineChart [i]["totaltransaction"] as! String)!, icon: nil)
        //            }
        //        }
        
        
        let set1 = LineChartDataSet(entries: values, label: "")
        set1.drawIconsEnabled = false
        set1.mode = .cubicBezier
        set1.lineDashLengths = [0, 0]
        
        //  set1.highlightLineDashLengths = [1, 1]
        set1.setColor(UIColor.BurganColor.brandBlue.medium)
        set1.axisDependency = .left
        set1.lineWidth = 1
        set1.circleRadius = 2.0
        set1.setCircleColor(UIColor.clear)
        set1.drawCircleHoleEnabled = true
        set1.drawCirclesEnabled = true
        set1.circleHoleRadius = 2.0
        set1.circleHoleColor = UIColor.clear //UIColor.init(hexString: "D10263", alpha: 1.0)
        set1.drawValuesEnabled = false
        set1.highlightColor = UIColor.BurganColor.brandBlue.medium
        //       set1.valueFont = UIFont(name: "Montserrat-SemiBold", size: 10)!
        set1.setDrawHighlightIndicators(true)
        set1.formLineDashLengths = [0, 0]
        set1.formLineWidth = 1
        set1.formSize = 15
        //9FD6F1
        set1.fillAlpha = 1
        let gradientColors = [UIColor(displayP3Red: 0.0/255.0, green: 101.0/255.0, blue: 166.0/255.0, alpha: 0.2).cgColor] as CFArray // Colors of the gradient
        let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)
        set1.fill = Fill(linearGradient: gradient!, angle: 90.0)
        
        set1.fill = Fill(linearGradient: gradient!, angle: 90.0)
        set1.drawFilledEnabled = true
        
        
        let set2 = LineChartDataSet(entries: values2, label: "")
        set2.drawIconsEnabled = false
        set2.mode = .cubicBezier
        set2.lineDashLengths = [0, 0]
        // set2.highlightLineDashLengths = [0, 0]
        set1.setColor(UIColor.BurganColor.brandBlue.medium)
        
        
        set2.axisDependency = .right
        
        set2.lineWidth = 1
        set2.circleRadius = 2.0
        set2.setCircleColor(UIColor.clear)
        set2.drawCircleHoleEnabled = true
        set2.drawCirclesEnabled = true
        set2.circleHoleRadius = 2.0
        set2.setColor(UIColor.BurganColor.brandOrange.orange)
        set2.circleHoleColor = UIColor.clear //UIColor.init(hexString: "D10263", alpha: 1.0)
        set2.drawValuesEnabled = false
        set2.highlightColor = UIColor.BurganColor.brandOrange.orange
        //       set1.valueFont = UIFont(name: "Montserrat-SemiBold", size: 10)!
        set2.setDrawHighlightIndicators(true)
        set2.formLineDashLengths = [0, 0]
        set2.formLineWidth = 1
        set2.formSize = 15
        
        set2.fillAlpha = 1
        //set1.fill = Fill (color: UIColor.init(hexString: "c3f2d1"))
        let gradientColors1 = [UIColor(displayP3Red: 241.0/255.0, green: 142.0/255.0, blue: 0.0/255.0, alpha: 0.2).cgColor] as CFArray // Colors of the gradient
        let colorLocations1:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
        let gradient1 = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors1, locations: colorLocations1)
        
        
        set2.fill = Fill(linearGradient: gradient1!, angle: 90.0)
        set2.drawFilledEnabled = true
        
        let data = LineChartData(dataSets: [set2, set1])
        
        chartView.data = data
        chartView.setNeedsDisplay()
    }
    
    // MARK: - Date Functions
    func convertDateToSpecificFormat(date: String, currentFormat: String, desiredFormat: String) -> String
    {
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en")
        inputFormatter.dateFormat = currentFormat
        let showDate = inputFormatter.date(from: date)
        inputFormatter.dateFormat = desiredFormat
        let resultString = inputFormatter.string(from: showDate ?? Date())
        return resultString
    }
    
    func convertDateToFormat(date: Date, desiredFormat: String) -> String
    {
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en")
        inputFormatter.dateFormat = desiredFormat
        let resultString = inputFormatter.string(from: date)
        return resultString
    }
    
    // MARK: - Calendar Methods
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        /*
         _ = calendar.cell(for: date, at: monthPosition)
         // cell?.contentView.addBottomBorderWithColor(color: UIColor.BurganColor.brandBlue.medium, width: 3)
         /*
         AppConstants.jsonStartDate = date.stringFromFormat("yyyy-MM-dd")
         AppConstants.jsonEndDate = date.stringFromFormat("yyyy-MM-dd")
         let selectedDateRange = date.monthh + " - " + String(date.day) + ", " + date.yearr
         btnSelectDate.setTitle(selectedDateRange, for: .normal)
         corporateDashRequest(startDate: AppConstants.jsonStartDate, endDate: AppConstants.jsonEndDate, cif: AppConstants.selectedFilter!.cif)
         */
         
         AppConstants.jsonStartDate = date.stringFromFormat("yyyy-MM-dd")
         AppConstants.jsonEndDate = date.stringFromFormat("yyyy-MM-dd")
         let selectedDateRange = date.monthh + " - " + String(date.day) + ", " + date.yearr
         btnSelectDate.setTitle(selectedDateRange, for: .normal)
         //mmmmmmalti
         if AppConstants.isCif {
         corporateDashRequest(startDate: AppConstants.jsonStartDate, endDate: AppConstants.jsonEndDate, cif: AppConstants.selectedFilter!.cif)
         }else{
         merchantDashRequest(startDate: AppConstants.jsonStartDate, endDate: AppConstants.jsonEndDate)
         }
         */
        
        _ = calendar.cell(for: date, at: monthPosition)
        // cell?.contentView.addBottomBorderWithColor(color: UIColor.BurganColor.brandBlue.medium, width: 3)
        AppConstants.jsonStartDate = date.stringFromFormat("yyyy-MM-dd")
        AppConstants.jsonEndDate = date.stringFromFormat("yyyy-MM-dd")
        let selectedDateRange = date.monthh.prefix(3) + " - " + String(date.day) + ", " + date.yearr
        btnSelectDate.setTitle(selectedDateRange, for: .normal)
        //mmmmmmalti
        if AppConstants.UserData.merchantRole == "Admin"
        {
            if AppConstants.isCif {
                corporateDashRequest(startDate: AppConstants.jsonStartDate, endDate: AppConstants.jsonEndDate, cif: AppConstants.selectedFilter!.cif)
            }else{
                merchantDashRequest(startDate: AppConstants.jsonStartDate, endDate: AppConstants.jsonEndDate)
            }
        } else {
            merchantDashRequest(startDate: AppConstants.jsonStartDate, endDate: AppConstants.jsonEndDate)
        }
    }
    
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //        let cell = calendar.cell(for: date, at: monthPosition)
        // cell?.contentView.removeLayer(layerName: "bottom")
        
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Calendar.current.date(byAdding: .month, value: -6, to: Date())!
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    
    @IBAction func performanceViewMore(_ sender: Any) {
        
        let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PerformanceViewController") as? PerformanceViewController
        
        self.navigationController?.pushViewController(controller!, animated: true)
    }
    
    @IBAction func goToCreditBankDetails(_ sender: Any) {
        self.tabBarController?.selectedIndex = 3
    }
    
    var aaChartView : AAChartView? = nil
    var aaChartModel : AAChartModel? = nil
    
    @IBAction func openSideMenu(_ sender: Any) {
        if AppConstants.language == .ar {
            self.sideMenuViewController.presentRightMenuViewController()
        } else {
            self.sideMenuViewController.presentLeftMenuViewController()
        }
        
        //self.sideMenuViewController.presentLeftMenuViewController()
        
    }
    
    func chartSetup(sales : [Float] , transactions : [Int], category :[String]){
        
        let chartViewWidth : CGFloat  = chartView.frame.size.width
        let chartViewHeight : CGFloat = chartView.frame.size.height
        aaChartView = AAChartView()
        aaChartView?.isSeriesHidden = true
        aaChartView?.frame = CGRect(x:0,y:0,width:chartViewWidth,height:chartViewHeight)
        // set the content height of aachartView
        // aaChartView?.contentHeight = self.view.frame.size.height
        self.chartView.addSubview(aaChartView!)
        let gradientColorDic1 = AAGradientColor.linearGradient(
            direction: .toBottomRight,
            startColor: "#9FD6F1", //DodgerBlue, alpha 透明度 1
            endColor: "#F4FAFD"//DodgerBlue, alpha 透明度 0.1
        )
        let gradientColorDic2 = AAGradientColor.linearGradient(
            direction: .toBottomRight,
            startColor: "#FDDBB1", //DodgerBlue, alpha 透明度 1
            endColor: "#FFFAF5"//DodgerBlue, alpha 透明度 0.1
        )
        aaChartModel = AAChartModel()
            .chartType(.areaspline)
            .animationType(.linear)
            .legendEnabled(true)
            .markerSymbol(.circle)
            .markerRadius(0)
            .title("")
            .xAxisTickInterval(0)
            .yAxisMax(Float(sales.max()!))
            .categories(category)
            .markerSymbolStyle(.borderBlank)
            .dataLabelsEnabled(false)
            .series([
                AASeriesElement()
                    .name("Sales")
                    .fillColor(gradientColorDic1)
                    .fillOpacity(5.0)
                    .color(AAColor.rgbaColor(0, 101, 166, 1.0))
                    .data(sales),
                AASeriesElement()
                    .name("No. of Transactions")
                    .fillOpacity(5.0)
                    .color(AAColor.rgbaColor(241, 142, 0, 1.0))
                    .fillColor(gradientColorDic2)
                    .data(transactions),
            ])
        //     let wholeContentString ='<span style=\"' + 'color:lightGray; font-size:13px\"' + '>Time: ' + this.x + ' year</span><br/>';
        
        let myTooltip = AATooltip()
            .useHTML(true)
            .formatter(#"""
                    function () {
                            let colorsArr = ["#0065A6", "#F18E00"];
                            let wholeContentString ='<span style=\"' + 'color:lightGray; font-size:13px\"' + '>Date :' + this.x + ' 2020</span><br/>';
                            for (let i = 0;i < 2;i++) {
                                let thisPoint = this.points[i];
                                let yValue = thisPoint.y;
                                if (yValue != 0) {
                                    let spanStyleStartStr = '<span style=\"' + 'color:'+ colorsArr[i] + '; font-size:13px\"' + '>◉ ';
                                    let spanStyleEndStr = '</span> <br/>';
                                    wholeContentString += spanStyleStartStr + thisPoint.series.name + ': ' + thisPoint.y + spanStyleEndStr;
                                }
                            }
                            return wholeContentString;
                        }
                    """#)
            .backgroundColor("#ffffff")
            .borderRadius(10.0)
            .borderWidth(0.0)
        // .borderColor("#050505")
        
        
        let aaOptions = AAOptionsConstructor.configureChartOptions(aaChartModel!)
        aaOptions.tooltip = myTooltip
        aaOptions.plotOptions?.series?.events = ["legendItemClick":false]
        aaChartView?.aa_drawChartWithChartOptions(aaOptions)
    }
    var viewModel : RegistrationViewControllerViewModelProtocol?
    
    
    @IBOutlet weak var lblNoChartDataAvailable: UILabel!
    
    func setUp() {
        creditViewCurved.layer.cornerRadius = cornerRadius
        performanceViewCurved.layer.cornerRadius = cornerRadius
        curvedviewShadow(view: creditViewCurved)
        curvedviewShadow(view: performanceViewCurved)
        curvedviewShadow(view: yellowCurvedView)
        /*
        curvedviewShadow(view: calendarview)
        calendarview.delegate = self
        calendarview.dataSource = self
        calendarAppearanceSetup(calendar: calendarview)
        
        //calendarview.select(Date())
        
        //        let jsonDateformatter = DateFormatter()
        //        jsonDateformatter.dateFormat = "yyyy-MM-dd"
        //        let startDate = Date() //Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        //        calendarview.select(jsonDateformatter.string(from: startDate).dateFromFormat("yyyy-MM-dd"))
        
        let startDate = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: Date()))
        calendarview.select(startDate)
         */
        
        if AppConstants.jsonStartDate == "" || AppConstants.jsonEndDate == ""
        {
            
            currentMonthData()
        }else{
            let startDate = AppConstants.jsonStartDate.dateFromFormat("yyyy-MM-dd")
            let endDate = AppConstants.jsonEndDate.dateFromFormat("yyyy-MM-dd")
            //calendarview.select(AppConstants.jsonStartDate.dateFromFormat("yyyy-MM-dd"))
            
            if AppConstants.jsonStartDate == AppConstants.jsonEndDate {
                let selectedDateRange = startDate!.monthh.prefix(3) + " - " + String(endDate!.day) + ", " + endDate!.yearr
                btnSelectDate.setTitle(selectedDateRange, for: .normal)
                
            }else{
                
                let startDate = startDate!.monthh.prefix(3) + " " + String(startDate!.day) + " - "
                let endDate = endDate!.monthh.prefix(3) + " " + String(endDate!.day) + ", " + endDate!.yearr
                let selectedDateRange = startDate + endDate
                btnSelectDate.setTitle(selectedDateRange, for: .normal)
                
            }
            
        }
        
        lblSalesAmount.text = "KD 0.000".localiz()
        self.lblSalesAmount.attributedText = self.lblSalesAmount.text!.attributedString(fontsize: 20)
        lblSalesTransactions.text = "0 " + "Transactions".localiz()
        
        lblCreditBankAmount.text = "KD 0.000".localiz()
        self.lblCreditBankAmount.attributedText = self.lblCreditBankAmount.text!.attributedString(fontsize: 17)
        viewModel = RegistrationViewControllerViewModel()
        chartView.isHidden = true
        CreditViewController.selectedFilter(button: btnApplyFilter)
        //        if AppConstants.UserData.merchantRole == "Admin"
        //        {
        //            AppConstants.isCif = true
        //            corporateDashRequest(startDate: AppConstants.jsonStartDate, endDate: AppConstants.jsonEndDate, cif: AppConstants.selectedFilter!.cif)
        //        }else{
        //            AppConstants.isCif = false
        //            merchantDashRequest(startDate: AppConstants.jsonStartDate, endDate: AppConstants.jsonEndDate)
        //        }
        
        /*
         if AppConstants.UserData.merchantRole == "Admin"
         {
         AppConstants.isCif = true
         corporateDashRequest(startDate: AppConstants.jsonStartDate, endDate: AppConstants.jsonEndDate, cif: AppConstants.selectedFilter!.cif)
         } else {
         AppConstants.isCif = false
         merchantDashRequest(startDate: AppConstants.jsonStartDate, endDate: AppConstants.jsonEndDate)
         }
         
         calendarview.scope = .week
         */
        // calendarview.reloadData()
        
        if AppConstants.UserData.merchantRole == "Admin"
        {
            if AppConstants.isCif {
                corporateDashRequest(startDate: AppConstants.jsonStartDate, endDate: AppConstants.jsonEndDate, cif: AppConstants.selectedFilter!.cif)
            } else {
                merchantDashRequest(startDate: AppConstants.jsonStartDate, endDate: AppConstants.jsonEndDate)
            }
        } else {
            merchantDashRequest(startDate: AppConstants.jsonStartDate, endDate: AppConstants.jsonEndDate)
        }
//        calendarview.scope = .week
        
    }
    
    
    var API_REQUEST = ""
    var corporateDashboard = "corporateDashboard"
    var merchantDashboard = "merchantDashboard"
    var corpPerformance = "performanceCorp"
    var merchPerformance = "performanceMerch"
    var merchantNoArray : [String] = []
    
    func decodeResult<T: Decodable>(model: T.Type, result: NSDictionary) -> (model: T?, error: Error?) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
            let modelObject = try JSONDecoder().decode(model.self, from: jsonData)
            return (modelObject, nil)
        } catch let error {
            return (nil, error)
        }
    }
    
    func currentMonthData(){
        
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale(identifier: "en")
        dateformatter.dateFormat = "dd MMM, yyyy"
        let jsonDateformatter = DateFormatter()
        jsonDateformatter.locale = Locale(identifier: "en")
        jsonDateformatter.dateFormat = "yyyy-MM-dd"
        let startDate = Date() // Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let stringStartDate = startDate.monthh.prefix(3)
        print(stringStartDate)
        AppConstants.jsonStartDate = jsonDateformatter.string(from: startDate)
        
        let endDate = Date() //Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let stringEndDate = String(endDate.day) + ", " + endDate.yearr
        print(stringEndDate)
        AppConstants.jsonEndDate = jsonDateformatter.string(from: endDate)
        let selectedDateRange = stringStartDate + " - " + stringEndDate
        btnSelectDate.setTitle(selectedDateRange, for: .normal)
        
    }
    
    func setAmounts(amount : String) -> String{
        return (Double(amount)!.rounded(digits: 3).calculate)
    }
    
    //    private func bindUI() throws {
    private func bindUI() {
        
        self.viewModel?.alertMessage.bind({ [weak self] in
            MBProgressHUD.hide(for: self!.view, animated: true)
            self?.showAlertDismissOnly(message: $0)
        })
        
        
        self.viewModel?.response.bind({ [weak self] in
            
            if let response = $0 {
                MBProgressHUD.hide(for: self!.view, animated: true)
                
                print("My IV is :: \(response.iv)")
                print("My payload is :: \(response.payload)")
                
                //                let ivStr = "MXhCT3NDMEZHd2tGaVAyRg=="
                //                let payloadStr = "XqO3Av1QmMW6gtItIZOsTxaPbfdwgwRfWYBIHix2G0bOLClNHjeyGnYm1F92QtYwdS77BVmSMuO3ym3B0Wy+ih+0XsE982ZRKNXQGG/2fi0UQJaBJ/1U8QAWyGQlich5dit4yuBevA0/zWOZ7T+a332aq180jmz2Fwjt6+mB+m9svd1XD51ABcEmbapXcZyGnX7+i88q9UTehFInUGXPysDxbhuVCjU1lGQ="
                
                
                let userStatus = DataDecryption().decryption(jsonModel: PayloadRes(iv: response.iv, payload: response.payload))
                //                let userStatus = DataDecryption().decryption(jsonModel: PayloadRes(iv: ivStr, payload: payloadStr))
                
                if userStatus != nil {
                    
                    let status : String = userStatus?.value(forKey: "status") as? String ?? ""
                    
                    if status == "" {
                        print("Recall API")
                        if  self!.API_REQUEST == self!.corporateDashboard {
                            
                            self?.corporateDashRequest(startDate: AppConstants.jsonStartDate, endDate: AppConstants.jsonEndDate, cif: AppConstants.selectedFilter!.cif)
                            
                        } else {
                            self?.merchantDashRequest(startDate: AppConstants.jsonStartDate, endDate: AppConstants.jsonEndDate)
                        }
                        
                    } else {
                        
                        let message : String = userStatus?.value(forKey: "message") as! String
                        let status : String = userStatus?.value(forKey: "status") as! String
                        if status == "Success"{
                            let errorCode : String = userStatus?.value(forKey: "errorCode") as! String
                            if  self!.API_REQUEST == self!.corporateDashboard {
                                
                                if errorCode == "L128"
                                {
                                    let object = self!.decodeResult(model: corporateDashboardResponse.self, result: userStatus!)
                                    let dashboard = object.model
                                    if let salesDetail = dashboard?.saleDetails?[0]
                                    {
                                        self!.performanceCorporateRequest(startDate: AppConstants.jsonStartDate, endDate:  AppConstants.jsonEndDate)
                                        
                                        self!.ccCount = salesDetail.ccCount
                                        self!.ccAmount = salesDetail.ccAmount
                                        self!.dcCount = salesDetail.dcCount
                                        self!.dcAmount = salesDetail.dcAmount
                                        self!.domesticCount = salesDetail.domesticCount
                                        self!.domesticAmount = salesDetail.domesticAmount
                                        self!.internationalCount = salesDetail.intlCount
                                        self!.internationalAmount = salesDetail.intlAmount
                                        self!.lblSalesTransactions.text = salesDetail.totalCount + " " + "Transactions".localiz()
                                        
                                        let formatter = NumberFormatter()
                                        formatter.locale = Locale(identifier: "en_US") // USA: Locale(identifier: "en_US")
                                        formatter.numberStyle = .decimal
                                        //formatter.minimumFractionDigits = 3
                                        formatter.maximumFractionDigits = 3
                                        let number = formatter.number(from:  salesDetail.totalAmount)
                                        
                                        print(number!)
                                        // self!.lblSalesAmount.text =  "KD "  + number!.doubleValue.withCommas()
                                        
                                        self!.lblSalesAmount.text =  "KD "  + self!.setAmounts(amount: salesDetail.totalAmount)
                                        
                                        self!.slAmount = salesDetail.totalAmount
                                        
                                        self!.lblContactlessDescpt.text = "\((dashboard?.contactless)!) % " + "of total Face to Face transactions were Contactless".localiz()
                                        
                                        self!.lblCreditBankAmount.text = "KD " + self!.setAmounts(amount: (dashboard?.settledAmount ?? "0.000"))
                                        self!.lblSalesAmount.attributedText = self!.lblSalesAmount.text!.attributedString(fontsize: 20)
                                        self!.lblCreditBankAmount.attributedText = self!.lblCreditBankAmount.text!.attributedString(fontsize: 17)
                                        self!.cvSales.reloadData()
                                    } else {
                                        self!.showAlertWith(message: AlertMessage(title: "Dashboard".localiz(), body: "Invalid data.".localiz()))
                                    }
                                    
                                } else {
                                    self!.showAlertWith(message: AlertMessage(title: "Dashboard".localiz(), body: message.localiz()))
                                }
                            } else {
                                
                                if errorCode == "L128" {
                                    
                                    self!.performanceMerchantRequest(startDate:AppConstants.jsonStartDate, endDate:AppConstants.jsonEndDate)
                                    let object = self!.decodeResult(model: corporateDashboardResponse.self, result: userStatus!)
                                    let dashboard = object.model
                                    if let salesDetail = dashboard?.saleDetails?[0] {
                                        
                                        self!.ccCount = salesDetail.ccCount
                                        self!.ccAmount = salesDetail.ccAmount
                                        self!.dcCount = salesDetail.dcCount
                                        self!.dcAmount = salesDetail.dcAmount
                                        self!.domesticCount = salesDetail.domesticCount
                                        self!.domesticAmount = salesDetail.domesticAmount
                                        self!.internationalCount = salesDetail.intlCount
                                        self!.internationalAmount = salesDetail.intlAmount
                                        self!.lblSalesTransactions.text = salesDetail.totalCount + " " + "Transactions".localiz()
                                        
                                        let formatter = NumberFormatter()
                                        formatter.locale = Locale(identifier: "en_US") // USA: Locale(identifier: "en_US")
                                        formatter.numberStyle = .decimal
                                        formatter.minimumFractionDigits = 3
                                        formatter.maximumFractionDigits = 3
                                        let number = formatter.number(from:  salesDetail.totalAmount)
                                        print(number!)
                                        //self!.lblSalesAmount.text =  "KD "  + number!.doubleValue.withCommas()
                                        self!.lblSalesAmount.text =  "KD "  + self!.setAmounts(amount: salesDetail.totalAmount)
                                        
                                        self!.slAmount = salesDetail.totalAmount
                                        
                                        self!.lblContactlessDescpt.text = "\((dashboard?.contactless)!) % " + "of total Face to Face transactions were Contactless".localiz()
                                        
                                        self!.lblCreditBankAmount.text = "KD " + self!.setAmounts(amount: (dashboard?.settledAmount)!)
                                        self!.lblSalesAmount.attributedText = self!.lblSalesAmount.text!.attributedString(fontsize: 20)
                                        self!.lblCreditBankAmount.attributedText = self!.lblCreditBankAmount.text!.attributedString(fontsize: 17)
                                        self!.cvSales.reloadData()
                                        
                                    } else {
                                        self!.showAlertWith(message: AlertMessage(title: "Dashboard".localiz(), body: "Invalid data.".localiz()))
                                    }
                                    
                                } else {
                                    self!.showAlertWith(message: AlertMessage(title: "Dashboard".localiz(), body: message.localiz()))
                                }
                            }
                            
                        } else {
                            self!.showAlertWith(message: AlertMessage(title: "Dashboard".localiz(), body: message.localiz()))
                        }
                    }
                    
                    
                    
                } else {
                    
                }
            }
            
        })
        
    }
    
    func arabicSetup() {
        
        btnPerfViewMore.setTitle("View More".localiz(), for: .normal)
        btnViewMore.setTitle("View More".localiz(), for: .normal)
        lblNoChartDataAvailable.text = lblNoChartDataAvailable.text!.localiz()
        lblSales.text = "Gross Sales".localiz()
        performanceLabel.text = performanceLabel.text?.localiz()
        
        if AppConstants.language == .ar {
            
            lblCreditBankAmount.textAlignment = NSTextAlignment.left
            lblContactlessDescpt.textAlignment = .right
            performanceLabel.textAlignment = .right
            lblSales.textAlignment = .right
            lblSalesTransactions.textAlignment = .right
        } else {
            
            lblCreditBankAmount.textAlignment = NSTextAlignment.right
            lblContactlessDescpt.textAlignment = .left
            performanceLabel.textAlignment = .left
            lblSales.textAlignment = .left
            lblSalesTransactions.textAlignment = .left
        }
        
    }
    
    @IBOutlet weak var btnViewMore: UIButton!
    
    //    var bgImagView = UIImageView()
    @IBOutlet weak var graphBgImagView: UIImageView!
    
    
    @IBOutlet weak var btnPerfViewMore: UIButton!
    //private func bindGraphUI() throws -> Bool {
    private func bindGraphUI() {
        
        self.viewModel?.alertMessage.bind({ [weak self] in
            MBProgressHUD.hide(for: self!.view, animated: true)
            self?.showAlertDismissOnly(message: $0)
        })
        
        self.viewModel?.response.bind({ [weak self] in
            
            if let response = $0 {
                MBProgressHUD.hide(for: self!.view, animated: true)
                
                print("My IV is :: \(response.iv)")
                print("My payload is :: \(response.payload)")
                
                
                let userStatus = DataDecryption().decryption(jsonModel: PayloadRes(iv: response.iv, payload: response.payload))
                
                if userStatus != nil {
                    
                    MBProgressHUD.hide(for: self!.view, animated: true)
                    let status : String = userStatus?.value(forKey: "status") as? String ?? ""
                    //                                        if status == "" {
                    //                                            throw true
                    //                                        }
                    if status == "" {
                        print("Recall API")
                        if self!.API_REQUEST == self!.corpPerformance {
                            
                            self?.performanceCorporateRequest(startDate: AppConstants.jsonStartDate, endDate: AppConstants.jsonEndDate)
                            
                        } else {
                            
                            self?.performanceMerchantRequest(startDate: AppConstants.jsonStartDate, endDate: AppConstants.jsonEndDate)
                        }
                        
                    } else {
                        
                        let message : String = userStatus?.value(forKey: "message") as! String
                        let status : String = userStatus?.value(forKey: "status") as? String ?? ""
                        
                        if status == "Success"{
                            let errorCode : String = userStatus?.value(forKey: "errorCode") as! String
                            if self!.API_REQUEST == self!.corpPerformance
                            {
                                if errorCode == "L128"
                                {
                                    let object = self!.decodeResult(model: performanceResp.self, result: userStatus!)
                                    let performance = object.model
                                    if performance!.performance.count > 0 {
                                        var transactions : [Double] = []
                                        var amounts : [Double] = []
                                        var dateList : [String] = []
                                        var fulldateList : [String] = []
                                        for i in 0..<performance!.performance.count {
                                            
                                            transactions.append(Double(performance!.performance[i].txnCount)!)
                                            if  let date = performance!.performance[i].duration.dateFromFormat("yyyy-MM-dd")
                                            {
                                                //                                                dateList.append(String(date.day))
                                                //                                                fulldateList.append(String(date.day) + " " + date.monthh + " " + date.yearr)
                                                dateList.append(String(date.day) + " " + date.monthh)
                                                fulldateList.append(String(date.day) + " " + date.monthh + " " + date.yearr)
                                                
                                            } else {
                                                dateList.append(performance!.performance[i].duration)
                                                fulldateList.append(performance!.performance[i].duration)
                                            }
                                            
                                            amounts.append(Double(performance!.performance[i].txnAmount)!)
                                        }
                                        
                                        self!.chartView.isHidden = false
                                        self!.setLineGraph(sales: amounts, transactions: transactions, dates: dateList, fulldate: fulldateList)
                                        //  self!.chartSetup(sales: amounts, transactions: transactions, category: dateList)
                                        self!.lblNoChartDataAvailable.isHidden = true
                                        self?.graphBgImagView.isHidden = true
                                    }
                                } else {
                                    
                                    self!.chartView.isHidden = true
                                    self!.lblNoChartDataAvailable.isHidden = false
                                    self!.lblNoChartDataAvailable.text = ""
                                    
                                    self?.graphBgImagView.isHidden = false
                                    
                                    
                                    if AppConstants.language == .ar {
                                        
                                        self?.graphBgImagView.image = UIImage(named: "chartEmptyAr")
                                    } else {
                                        self?.graphBgImagView.image = UIImage(named: "chartEmptyEn")
                                    }
                                    
                                    //self!.showAlertWith(message: AlertMessage(title: "Dashboard".localiz(), body: message))
                                }
                            }else{
                                
                                if errorCode == "L128"
                                {
                                    let object = self!.decodeResult(model: performanceResp.self, result: userStatus!)
                                    let performance = object.model
                                    if performance!.performance.count > 0 {
                                        var transactions : [Double] = []
                                        var amounts : [Double] = []
                                        var dateList : [String] = []
                                        var fulldateList : [String] = []
                                        for i in 0..<performance!.performance.count{
                                            
                                            transactions.append(Double(performance!.performance[i].txnCount)!)
                                            if  let date = performance!.performance[i].duration.dateFromFormat("yyyy-MM-dd")
                                            {
                                                dateList.append(String(date.day) + " " + date.monthh)
                                                fulldateList.append(String(date.day) + " " + date.monthh + " " + date.yearr)
                                            } else {
                                                dateList.append(performance!.performance[i].duration)
                                                fulldateList.append(performance!.performance[i].duration)
                                            }
                                            
                                            amounts.append(Double(performance!.performance[i].txnAmount)!)
                                        }
                                        
                                        self!.chartView.isHidden = false
                                        self!.setLineGraph(sales: amounts, transactions: transactions, dates: dateList, fulldate: fulldateList)
                                        // self!.chartSetup(sales: amounts, transactions: transactions, category: dateList)
                                        self!.lblNoChartDataAvailable.isHidden = true
                                        self?.graphBgImagView.isHidden = true
                                    }
                                } else {
                                    
                                    self!.chartView.isHidden = true
                                    self!.lblNoChartDataAvailable.isHidden = false
                                    self!.lblNoChartDataAvailable.text = ""
                                    
                                    self?.graphBgImagView.isHidden = false
                                    
                                    if AppConstants.language == .ar {
                                        self?.graphBgImagView.image = UIImage(named: "chartEmptyAr")
                                    } else {
                                        self?.graphBgImagView.image = UIImage(named: "chartEmptyEn")
                                    }
                                    
                                    // self!.showAlertWith(message: AlertMessage(title: "Dashboard".localiz(), body: message.localiz()))
                                }
                            }
                            
                        } else {
                            self!.showAlertWith(message: AlertMessage(title: "Dashboard".localiz(), body: message.localiz()))
                        }
                    }
                    
                    
                } else {
                    
                }
            }
            
        })
        
    }
    
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
//        self.calendarViewHeight.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendarAppearanceSetup(calendar:FSCalendar){
        
        //s  calendar.appearance.weekdayTextColor = UIColor.red
        //  calendar.appearance.headerTitleColor = UIColor.red
        calendar.appearance.eventDefaultColor = UIColor.clear
        // calendar.appearance.selectionColor = UIColor.blue
        calendar.appearance.headerDateFormat = "yyyy/MM"
        calendar.appearance.todayColor = UIColor.clear
        calendar.appearance.borderRadius = 0
        calendar.appearance.titleFont = UIFont(name: "FrutigerRoman", size: 17)
        calendar.allowsMultipleSelection = false
        
        // calendar.appearance.headerMinimumDissolvedAlpha = 1.0
        
    }
    func curvedviewShadow(view:UIView){
        
        view.layer.cornerRadius = 8
        view.layer.shadowOpacity = 0.35
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowRadius = 3.0
        view.layer.shadowColor = UIColor.BurganColor.brandGray.lgiht.cgColor
        view.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner,.layerMaxXMinYCorner]
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        setUp()
        //        arabicSetup()
        
        //        fatalError()
        
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.networkStatusChanged(_:)), name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        definesPresentationContext = true
        
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        scrollView.addSubview(refreshControl)
        
        self.loopThroughSubViewAndMirrorImage(subviews: self.view.subviews)
        
        lblNotificationsCount.isHidden = true
        if DashBoardViewController.firstTimeReport {
            print("reports")
        }else{
            //            DashBoardViewController.firstTimeReport = true
            //            let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ReportBubbleViewController") as? ReportBubbleViewController
            //            controller!.transitioningDelegate = self
            //            controller!.modalPresentationStyle = .custom
            //            controller!.reportType = 0
            //            controller!.modalPresentationCapturesStatusBarAppearance = true
            //            controller!.interactiveTransition = interactiveTransition
            //                             interactiveTransition.attach(to: controller!)
            //                     //  self.navigationController?.pushViewController(controller!, animated: true)
            //            self.present(controller!, animated: true, completion: nil)
        }
        
        DashBoardViewController.firstTimeReport = true
        let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ReportBubbleViewController") as? ReportBubbleViewController
        controller!.transitioningDelegate = self
        controller!.modalPresentationStyle = .custom
        controller!.reportType = 0
        controller!.modalPresentationCapturesStatusBarAppearance = true
        controller!.interactiveTransition = interactiveTransition
        interactiveTransition.attach(to: controller!)
        //  self.navigationController?.pushViewController(controller!, animated: true)
        //self.present(controller!, animated: true, completion: nil)
        
        if UserDefaults.standard.value(forKey: "isFirstTime") != nil
        {
            UserDefaults.standard.removeObject(forKey: "isFirstTime")
            self.present(controller!, animated: true, completion: nil)
        }
        
        if AppConstants.UserData.merchantRole == "Admin" {
            AppConstants.isCif = true
        } else {
            AppConstants.isCif = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if let tabController = self.parent as? UITabBarController {
            tabController.navigationItem.title = "Dashboard".localiz()
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        //        UserDefaults.standard.removeObject(forKey: "ClearBtnTapped")
        
        setUp()
        arabicSetup()
        
    }
    
    // MARK: - refresh
    @objc func refresh()
    {
        setUp()
        arabicSetup()
        
        refreshControl.endRefreshing()
    }
    
    
    
    static var firstTimeReport = false
    let transition = BubbleTransition()
    let interactiveTransition = BubbleInteractiveTransition()
    @IBOutlet weak var btnNavMenu: UIButton!
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = btnNavMenu.center
        transition.bubbleColor = UIColor.clear
        return transition
    }
    // MARK: UIViewControllerTransitioningDelegate
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = btnNavMenu.center
        transition.bubbleColor = UIColor.clear
        return transition
    }
    
    
    func selectDateRange(startDate: Date, endDate: Date) {
        
        if startDate == endDate {
            AppConstants.jsonStartDate = startDate.stringFromFormat("yyyy-MM-dd")
            AppConstants.jsonEndDate = endDate.stringFromFormat("yyyy-MM-dd")
            let selectedDateRange = startDate.monthh.prefix(3) + " - " + String(startDate.day) + ", " + startDate.yearr
            btnSelectDate.setTitle(selectedDateRange, for: .normal)
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
            btnSelectDate.setTitle(sDate + " - " + eDate + " " + endDate.yearr, for: .normal)
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
         btnSelectDate.setTitle(sDate + " - " + eDate + " " + endDate.yearr, for: .normal)
         
         */
        
        /*
         if AppConstants.selectedFilter!.selectedAccounts.count != 0 && AppConstants.selectedFilter!.selectedBrands.count != 0 && AppConstants.selectedFilter!.selectedLocations.count != 0
         {
         corporateDashRequest(startDate: AppConstants.jsonStartDate, endDate: AppConstants.jsonEndDate, cif: AppConstants.selectedFilter!.cif)
         }else{
         merchantDashRequest(startDate: AppConstants.jsonStartDate, endDate: AppConstants.jsonEndDate)
         }
         */
        
        //mak
        /*
         if AppConstants.selectedFilter!.selectedAccounts.count != 0 && AppConstants.selectedFilter!.selectedBrands.count != 0 && AppConstants.selectedFilter!.selectedLocations.count != 0
         {
         merchantDashRequest(startDate: AppConstants.jsonStartDate, endDate: AppConstants.jsonEndDate)
         
         }else{
         corporateDashRequest(startDate: AppConstants.jsonStartDate, endDate: AppConstants.jsonEndDate, cif: AppConstants.selectedFilter!.cif)
         
         }
         */
        
        if AppConstants.UserData.merchantRole == "Admin" {
            
            if AppConstants.isCif {
                corporateDashRequest(startDate: AppConstants.jsonStartDate, endDate: AppConstants.jsonEndDate, cif: AppConstants.selectedFilter!.cif)
            }else{
                merchantDashRequest(startDate: AppConstants.jsonStartDate, endDate: AppConstants.jsonEndDate)
            }
        } else {
            merchantDashRequest(startDate: AppConstants.jsonStartDate, endDate: AppConstants.jsonEndDate)
        }
    }
    
    func performanceCorporateRequest(startDate:String, endDate:String)
    {
        
        let performanceParam : [String : Any] = ["type":"cif",
                                                 "cif" : AppConstants.selectedFilter!.cif,
                                                 "deviceId" : AppConstants.UserData.deviceID,
                                                 "startDate": startDate, "endDate":endDate]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.viewModel?.serviceRequest(param: performanceParam, apiName: RequestItemsType.getPerformanceGraphContactlessTxn)
        API_REQUEST = corpPerformance
        self.bindGraphUI()
        
        //        do {
        //            let msg = try self.bindGraphUI()
        //            print(msg)
        //        } catch {
        //
        //            print("Throw Errors")
        //        }
        
    }
    func performanceMerchantRequest(startDate:String, endDate:String)
    {
        //        let merchant : [String]  = ["\(AppConstants.merchantNumber)"]
        let merchant = AppConstants.merchantNumber.map { String($0) }
        
        
        let performanceParam : [String : Any] = ["type":"mid",
                                                 "deviceId" : AppConstants.UserData.deviceID,
                                                 "startDate": startDate, "endDate":endDate,
                                                 "merchantNum" :merchant]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.viewModel?.serviceRequest(param: performanceParam, apiName: RequestItemsType.getPerformanceGraphContactlessTxn)
        API_REQUEST = merchPerformance
        self.bindGraphUI()
        //        do {
        //            let msg = try self.bindGraphUI()
        //            print(msg)
        //        } catch {
        //
        //            print("Throw Errors")
        //        }
        
    }
    
    func corporateDashRequest(startDate:String, endDate:String, cif : String)
    {
        let performanceParam : [String : Any] = ["type":"cif",
                                                 "cif" : cif,
                                                 "deviceId" : AppConstants.UserData.deviceID,
                                                 "startDate": startDate, "endDate":endDate]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.viewModel?.serviceRequest(param: performanceParam, apiName: RequestItemsType.getDashboardData)
        API_REQUEST = corporateDashboard
        self.bindUI()
        
        //        do {
        //            let msg: () = try self.bindUI()
        //            print(msg)
        //        } catch {
        //
        //            print("Throw Errors")
        //        }
        
    }
    
    func merchantDashRequest(startDate : String , endDate : String){
        
        //        let merchant : [String]  = ["\(AppConstants.merchantNumber)"]
        let merchant = AppConstants.merchantNumber.map { String($0) }
        
        
        //        let dashboardParam : [String : Any] = ["type":"mid",
        //                                                "deviceId" : AppConstants.UserData.deviceID,
        //                                                "startDate": startDate, "endDate":endDate,
        //                                                "merchantNum" :merchant
        //                                            ]
        let dashboardParam : [String : Any] = ["type":"mid",
                                               "deviceId" : AppConstants.UserData.deviceID,
                                               "startDate": startDate,
                                               "endDate":endDate,
                                               "merchantNum" :merchant
        ]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.viewModel?.serviceRequest(param: dashboardParam, apiName: RequestItemsType.getDashboardData)
        API_REQUEST = merchantDashboard
        self.bindUI()
        
        //        do {
        //            let msg: () = try self.bindUI()
        //            print(msg)
        //        } catch {
        //
        //            print("Throw Errors")
        //        }
    }
    
    func selectTimeRange(startTimeValue: String, endTimeValue: String) {
        //unused
    }
    func selectTimeRange(startTimeValue : String , endTimeValue : String, statTimeAMPM : String, endTimeAMPM : String) {
        
    }
    
    let weekdays = ["S","M","T","W","T","F","S"]
    
}

public extension Sequence {
    func merchants<U : Hashable>(_ key: (Iterator.Element) -> U) -> [U:[Iterator.Element]] {
        var dict: [U:[Iterator.Element]] = [:]
        for el in self {
            let key = key(el)
            if case nil = dict[key]?.append(el) { dict[key] = [el] }
        }
        return dict
    }
}

extension UIView {
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.name = "bottom"
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
        
        
    }
    
    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func removeLayer(layerName: String) {
        for item in self.layer.sublayers ?? [] where item.name == layerName {
            item.removeFromSuperlayer()
        }
    }
    
    
}
extension Formatter {
    static let number = NumberFormatter()
}
extension Locale {
    static let englishUS: Locale = .init(identifier: "en_US")
    static let frenchFR: Locale = .init(identifier: "fr_FR")
    static let portugueseBR: Locale = .init(identifier: "pt_BR")
    // ... and so on
}
extension Numeric {
    func formattedd(with groupingSeparator: String? = nil, style: NumberFormatter.Style, locale: Locale = .current) -> String {
        Formatter.number.locale = locale
        Formatter.number.numberStyle = style
        if let groupingSeparator = groupingSeparator {
            Formatter.number.groupingSeparator = groupingSeparator
        }
        return Formatter.number.string(for: self) ?? ""
    }
    // Localized
    var currency:   String { formattedd(style: .currency) }
    // Fixed locales
    var currencyUS: String { formattedd(style: .currency, locale: .englishUS) }
    var currencyFR: String { formattedd(style: .currency, locale: .frenchFR) }
    var currencyBR: String { formattedd(style: .currency, locale: .portugueseBR) }
    // ... and so on
    var calculate: String {formattedd(with: ",", style: .decimal, locale: .englishUS)}
    //var calculator: String { formatted(groupingSeparator: ",", style: .decimal) }
}
extension Double {
    func rounded(digits: Int) -> Double {
        let multiplier = pow(10.0, Double(digits))
        return (self * multiplier).rounded() / multiplier
    }
}


extension Double {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 3
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}

/*
 let formatter = NumberFormatter()
 formatter.locale = Locale(identifier: "en_US") // USA: Locale(identifier: "en_US")
 formatter.numberStyle = .decimal
 let number = formatter.number(from:  salesDetail.totalAmount)
 print(number!)
 
 self!.lblSalesAmount.text =  "KD "  + number!.doubleValue.withCommas()
 */
