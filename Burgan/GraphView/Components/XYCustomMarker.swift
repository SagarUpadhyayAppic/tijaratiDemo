//
//  XYCustomMarker.swift
//  ChartsDemo
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation
import Charts

open class XYCustomMarker: BalloonMarker
{
    open var xAxisValueFormatter: IAxisValueFormatter?
    open var yAxisValueFormatter: IAxisValueFormatter?
    open var values = [String]()
    
    fileprivate var yFormatter = NumberFormatter()
    
    public init(color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets, xAxisValueFormatter: IAxisValueFormatter, yAxisValueFormatter : IAxisValueFormatter,CompletionStr:[String])
    {
        super.init(color: color, font: font, textColor: textColor, insets: insets)
        self.xAxisValueFormatter = xAxisValueFormatter
        self.yAxisValueFormatter = yAxisValueFormatter
        self.values = CompletionStr
        
        yFormatter.minimumFractionDigits = 1
        yFormatter.maximumFractionDigits = 1
    }
    
    open override func refreshContent(entry: ChartDataEntry, highlight: Highlight)
    {
        let x = entry.x
        let y = entry.y
        var indxpath = Int()
        
        indxpath = Int(x)
    
      //  setLabel(xAxisValueFormatter!.stringForValue(x, axis: nil) + "\n" + yAxisValueFormatter!.stringForValue(y, axis: nil) + "%" + "\n" + "✅ \(values[indxpath])")
         setLabel(xAxisValueFormatter!.stringForValue(x, axis: nil))

    }
}
