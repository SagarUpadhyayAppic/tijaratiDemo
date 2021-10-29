//
//  TbPerformanceListCell.swift
//  Burgan
//
//  Created by Malti Maurya on 19/03/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit
import AAInfographics
import Charts

class TbPerformanceListCell: UITableViewCell, ChartViewDelegate {
    
    
    @IBOutlet weak var curvedView: UIView!
    @IBOutlet weak var lblTransactions: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblPerformanceName: UILabel!
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var ivDropdown: UIImageView!
    @IBOutlet weak var graphBottom: UIStackView!
    
    @IBOutlet weak var chartViewWidth: NSLayoutConstraint!
    var aaChartView : AAChartView? = nil
    var aaChartModel : AAChartModel? = nil
    @IBOutlet weak var detailChartView: LineChartView!
    @IBOutlet weak var infoHeight: NSLayoutConstraint!
    override  func awakeFromNib() {
        super.awakeFromNib()
        
        
        curvedView.layer.cornerRadius = 10
        // shadow
        curvedView.layer.shadowColor = UIColor.black.cgColor
        curvedView.layer.shadowOffset = CGSize(width: 3, height: 3)
        curvedView.layer.shadowOpacity = 0.1
        curvedView.layer.shadowRadius = 1.0
    //   lblAmount.attributedText = lblAmount.text!.attributedString(fontsize: 17)
        showSmallChart()
    }
    
    func hideSmallChart() {
        chartViewWidth.constant = 0
        chartView.isHidden = true
        detailChartView.isHidden = false
        graphBottom.isHidden = false
        infoHeight.constant = 100
//        ivDropdown.image = UIImage(named: "ic_down_arrow_black")
        ivDropdown.image = UIImage(named: "ic_up_arrow_grey")

    }
      
    func setLineGraph(sales: [Double], transactions: [Double], dates : [String], fulldate : [String]) {
                    
        chartView.delegate = self
                        
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = false
        //chartView.setVisibleXRangeMaximum(5)
        chartView.doubleTapToZoomEnabled = false
                
        //chartView.xAxis.labelWidth = 25.0
        chartView.xAxis.setLabelCount(sales.count, force: false)
        //chartView.xAxis.gridLineDashLengths = [10, 10]
        //chartView.xAxis.gridLineDashPhase = 0
        chartView.xAxis.labelTextColor = UIColor.BurganColor.brandBlue.medium
        // chartView.xAxis.labelFont = UIFont(name: "OpenSans", size: 10)!
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.granularity = 1.0
        chartView.xAxis.granularityEnabled = true
        chartView.xAxis.enabled = false
        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = false
        chartView.isUserInteractionEnabled = false
        let leftAxis = chartView.leftAxis
        leftAxis.removeAllLimitLines()
        
        //leftAxis.axisMinimum = 0
        leftAxis.axisMinimum = 0
        leftAxis.gridLineDashLengths = [0, 0]
        leftAxis.drawLimitLinesBehindDataEnabled = false
        // leftAxis.labelFont = UIFont(name: "OpenSans-Bold", size: 10)!
        leftAxis.labelTextColor =  UIColor.BurganColor.brandBlue.medium
        leftAxis.drawGridLinesEnabled = true
        leftAxis.gridColor =  UIColor(hexString: "B0DAEA", alpha: 0.3)  //UIColor.BurganColor.brandBlue.medium
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
        let transtring = transactions.map{String(format: "%.3f", $0)}
           
            
        let marker = XYCustomMarker( color:  UIColor.BurganColor.brandGray.light, font: UIFont.systemFont(ofSize: 10), textColor: UIColor.BurganColor.brandBlue.medium, insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8), xAxisValueFormatter: IndexAxisValueFormatter(values: dates), yAxisValueFormatter: rightAxis.valueFormatter!, CompletionStr: dates)
                    
        marker.minimumSize = CGSize(width: 50, height: 50)
        let vc: MyMarkerVC = (MyMarkerVC.viewFromXib() as? MyMarkerVC)!
        vc.chartView = chartView
        vc.arrayPassVal(correctAry: dates, incorrectAry: salesstring, unansweredAry:transtring , fromWhere: "resultView")
                    
        chartView.marker = vc
        chartView.drawMarkers = true
//        var markerBackCol = UIColor()
//        var markerLblCol = UIColor()
        
        
                
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .currency
//        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1.0
            
        let cFormatter = NumberFormatter()
        cFormatter.numberStyle = .none
        //        pFormatter.maximumFractionDigits = 1
        cFormatter.multiplier = 1.0
        //pFormatter.percentSymbol = "min"
        // pFormatter.positiveSuffix = "K"
//        chartView.data?.setValueFormatter(pFormatter)
//        chartView.dataSet.valueFormatter = pFormatter
                
        chartView.rightAxis.valueFormatter = DefaultValueFormatter(formatter: pFormatter) as? IAxisValueFormatter
        chartView.leftAxis.valueFormatter = DefaultValueFormatter(formatter: cFormatter) as? IAxisValueFormatter
        chartView.leftAxis.labelTextColor = UIColor.BurganColor.brandBlue.medium
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
            
        chartView.xAxis.labelPosition = .bottom
 
//        chartView.xAxis.labelWidth = 25.0
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dates)
                            
    
        chartView.legend.form = .line
        chartView.legend.enabled = false
        chartView.xAxis.setLabelCount(dates.count, force: false)
        chartView.xAxis.granularity = 1.0
        chartView.xAxis.granularityEnabled = true
        chartView.xAxis.labelWidth = 0

//        chartView.setVisibleXRangeMaximum(3)
                
        //let dataArray:[Double] = [1.0,13.0,17.0,23.0,37.0,45.0,59.0,62.0,75.0,82.0,88.0,95.0,100.0]
    
        detailChartView.delegate = self
                                   
        detailChartView.chartDescription?.enabled = false
        detailChartView.dragEnabled = true
        detailChartView.setScaleEnabled(true)
        detailChartView.pinchZoomEnabled = false
        //chartView.setVisibleXRangeMaximum(5)
        detailChartView.doubleTapToZoomEnabled = false
                            
        //chartView.xAxis.labelWidth = 25.0
        detailChartView.xAxis.setLabelCount(sales.count, force: false)
        //chartView.xAxis.gridLineDashLengths = [10, 10]
        //chartView.xAxis.gridLineDashPhase = 0
        detailChartView.xAxis.labelTextColor = UIColor.BurganColor.brandBlue.medium
    // chartView.xAxis.labelFont = UIFont(name: "OpenSans", size: 10)!
        detailChartView.xAxis.drawGridLinesEnabled = false
        detailChartView.xAxis.granularity = 1.0
        detailChartView.xAxis.granularityEnabled = true
        
        
        let leftAxis1 = detailChartView.leftAxis
        leftAxis1.removeAllLimitLines()
        
        //leftAxis.axisMinimum = 0
        leftAxis1.axisMinimum = 0
        leftAxis1.gridLineDashLengths = [0, 0]
        leftAxis1.drawLimitLinesBehindDataEnabled = false
    // leftAxis.labelFont = UIFont(name: "OpenSans-Bold", size: 10)!
        leftAxis1.labelTextColor =  UIColor.BurganColor.brandBlue.medium
        leftAxis1.drawGridLinesEnabled = true
        leftAxis1.gridColor = UIColor(hexString: "B0DAEA", alpha: 0.3) // UIColor.BurganColor.brandBlue.medium
        leftAxis1.gridLineWidth = 1
        leftAxis1.valueFormatter = LargeValueFormatter(appendix: "")
        leftAxis1.axisLineWidth = 0
                           
        let rightAxis1 = detailChartView.rightAxis
        rightAxis1.removeAllLimitLines()
                                 
        //leftAxis.axisMinimum = 0
        rightAxis1.axisMinimum = transactions.min()!
        rightAxis1.axisMaximum = transactions.max()!
        rightAxis.gridLineDashLengths = [0, 0]
        rightAxis1.drawLimitLinesBehindDataEnabled = false
        // leftAxis.labelFont = UIFont(name: "OpenSans-Bold", size: 10)!
        rightAxis1.labelTextColor =  UIColor.BurganColor.brandOrange.orange
        rightAxis1.drawGridLinesEnabled = false
        rightAxis1.gridColor =   UIColor.BurganColor.brandOrange.orange
        rightAxis1.gridLineWidth = 2
        rightAxis1.valueFormatter = LargeValueFormatter(appendix: "")
        rightAxis1.axisLineWidth = 0
                       
                     
//        detailChartView.marker = vc
//        detailChartView.drawMarkers = true
        
        var mytime = [String]()
        for i in 0..<dates.count {
            if  let date = dates[i].dateFromFormat("dd MMMM")
            {
                print(date)
                mytime.append(fulldate[i])
                
            } else {
                //mytime.append(dates[i])
                mytime.append(self.convertDateToSpecificFormat(date: dates[i], currentFormat: "HH", desiredFormat: "HH:ss a"))
            }
        }
        
        let marker1 = XYCustomMarker( color:  UIColor.BurganColor.brandGray.light, font: UIFont.systemFont(ofSize: 10), textColor: UIColor.BurganColor.brandBlue.medium, insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8), xAxisValueFormatter: IndexAxisValueFormatter(values: dates), yAxisValueFormatter: rightAxis.valueFormatter!, CompletionStr: dates)
                    
        marker1.minimumSize = CGSize(width: 50, height: 50)
        let vc1: MyMarkerVC = (MyMarkerVC.viewFromXib() as? MyMarkerVC)!
        vc1.chartView = detailChartView
//        vc1.arrayPassVal(correctAry: dates, incorrectAry: salesstring, unansweredAry:transtring , fromWhere: "resultView")
        vc1.arrayPassVal(correctAry: mytime, incorrectAry: salesstring, unansweredAry:transtring , fromWhere: "resultView")

                    
        detailChartView.marker = vc1
        detailChartView.drawMarkers = true
        
        
                           //        var markerBackCol = UIColor()
                       
                           //pFormatter.percentSymbol = "min"
                          // pFormatter.positiveSuffix = "K"
                   //        chartView.data?.setValueFormatter(pFormatter)
                   //        chartView.dataSet.valueFormatter = pFormatter
                           
        detailChartView.rightAxis.valueFormatter = DefaultValueFormatter(formatter: pFormatter) as? IAxisValueFormatter
        detailChartView.leftAxis.valueFormatter = DefaultValueFormatter(formatter: cFormatter) as? IAxisValueFormatter
        detailChartView.leftAxis.labelTextColor = UIColor.BurganColor.brandBlue.medium
        detailChartView.rightAxis.labelTextColor = UIColor.BurganColor.brandOrange.orange
        // chartView.leftAxis.labelFont = UIFont(name: "OpenSans", size: 10)!
        
        
//        detailChartView.leftAxis.axisMinimum = 0
//        detailChartView.leftAxis.axisMaximum = sales.max()!
//        detailChartView.rightAxis.axisMinimum = transactions.min()!
//        detailChartView.rightAxis.axisMaximum = transactions.max()!
        
        detailChartView.leftAxis.resetCustomAxisMin()
        detailChartView.leftAxis.resetCustomAxisMax()
        detailChartView.rightAxis.resetCustomAxisMin()
        detailChartView.rightAxis.resetCustomAxisMax()
                       
         // Below line hide the right Axis from chart 
        detailChartView.rightAxis.enabled = false
                       
        detailChartView.xAxis.labelPosition = .bottom
                           
                       
        detailChartView.xAxis.labelWidth = 25.0
        
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
        detailChartView.xAxis.valueFormatter=xAxis.valueFormatter
        // By Me Over
        
//        detailChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dates)
                                               
                 
                                               
        //     chartView.marker = marker
        detailChartView.legend.form = .line
        detailChartView.legend.enabled = false
        detailChartView.xAxis.setLabelCount(dates.count, force: false)
        detailChartView.xAxis.granularity = 1.0
        detailChartView.xAxis.granularityEnabled = true
        detailChartView.xAxis.labelRotationAngle = -90.0
                      
//                           detailChartView.setVisibleXRangeMaximum(3)
                           
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
        
        let data = LineChartData(dataSets: [set1, set2])
        
        
        chartView.data = data
        chartView.setNeedsDisplay()
        detailChartView.data = data
        detailChartView.setNeedsDisplay()
    }
      
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

    func showSmallChart(){
           chartViewWidth.constant = 217
        detailChartView.isHidden = true
        graphBottom.isHidden = true
        chartView.isHidden = false
        infoHeight.constant = 170

//        ivDropdown.image = UIImage(named: "ic_up_arrow_grey")
        ivDropdown.image = UIImage(named: "ic_down_arrow_black")

       }
    
    func chartDeatilSetup(sales : [Float] , transactions : [Int], category :[String]){
          let gradientColorDic1 = AAGradientColor.linearGradient(
                               direction: .toBottomRight,
                               startColor: "#9FD6F1",
                               endColor: "#F4FAFD"
                           )
                     let gradientColorDic2 = AAGradientColor.linearGradient(
                                     direction: .toBottomRight,
                                     startColor: "#FDDBB1",
                                     endColor: "#FFFAF5"
                                 )
                let chartViewWidth : CGFloat  = detailChartView.frame.size.width
                    let chartViewHeight : CGFloat = detailChartView.frame.size.height
                       aaChartView = AAChartView()
                    aaChartView?.isSeriesHidden = true
                       aaChartView?.frame = CGRect(x:0,y:0,width:chartViewWidth,height:chartViewHeight)
                       // set the content height of aachartView
                       // aaChartView?.contentHeight = self.view.frame.size.height
                       self.detailChartView.addSubview(aaChartView!)
                    aaChartModel = AAChartModel()
                    .chartType(.areaspline)//Can be any of the chart types listed under `AAChartType`.
                    .animationType(.linear)
                    .title("")//The chart title
                    .legendEnabled(true)
                        .markerSymbol(.circle)
                             .categories(category)
                        .xAxisTickInterval(0)
                                   .yAxisMax(Float(sales.max()!))
                .markerRadius(0)
                    .subtitle("")//The chart subtitle
                    .dataLabelsEnabled(false) //Enable or disable the data labels. Defaults to false
                   // .categories(["S", "M", "T", "W", "T", "F",
                  //  "S"])
                    .series([
                         AASeriesElement()
                            .name("Sales".localiz())
                                                   .fillColor(gradientColorDic1)
                                                   .fillOpacity(5.0)
                                                   .color(AAColor.rgbaColor(0, 101, 166, 1.0))
                                                   .data(sales),
                                               AASeriesElement()
                                                .name("No. of Transactions".localiz())
                                                   .fillOpacity(5.0)
                                                   .color(AAColor.rgbaColor(241, 142, 0, 1.0))
                                                   .fillColor(gradientColorDic2)
                                                   .data(transactions),
                            ])
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
                                                       wholeContentString += spanStyleStartStr + thisPoint.series.name + ': ' + thisPoint.y  + spanStyleEndStr;
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
                           aaChartView?.aa_drawChartWithChartOptions(aaOptions)
         

    }
    func chartSetup(sales : [Float] , transactions : [Int], category :[String]){
         
        let gradientColorDic1 = AAGradientColor.linearGradient(
                       direction: .toBottomRight,
                       startColor: "#9FD6F1",
                       endColor: "#F4FAFD"
                   )
             let gradientColorDic2 = AAGradientColor.linearGradient(
                             direction: .toBottomRight,
                             startColor: "#FDDBB1",
                             endColor: "#FFFAF5"
                         )
         let chartViewWidth : CGFloat  = chartView.frame.size.width
         let chartViewHeight : CGFloat = chartView.frame.size.height
            aaChartView = AAChartView()
    
            aaChartView?.frame = CGRect(x:0,y:0,width:chartViewWidth,height:chartViewHeight)
            // set the content height of aachartView
            // aaChartView?.contentHeight = self.view.frame.size.height
            self.chartView.addSubview(aaChartView!)
        self.aaChartView!.isUserInteractionEnabled = false
         aaChartModel = AAChartModel()
             .chartType(.areaspline)//Can be any of the chart types listed under `AAChartType`.
            .animationType(.linear)
        .yAxisLabelsEnabled(true)
         .title("")//The chart title
        .legendEnabled(false)
         .markerSymbol(.circle)
        .tooltipEnabled(false)
        .touchEventEnabled(false)
            .xAxisGridLineWidth(0.0)
        .xAxisLabelsEnabled(true)
            .xAxisTickInterval(0)
            .yAxisMax(Float(sales.max()!))
            .markerRadius(0.0)
         .subtitle("")//The chart subtitle
         .dataLabelsEnabled(false) //Enable or disable the data labels. Defaults to false
         .categories(category)
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
                aaChartView?.aa_drawChartWithChartOptions(aaOptions)

        
        
     }
}
