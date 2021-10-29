//
//  BarValueFormatter.swift
//  mintOak
//
//  Created by Appic iMac on 2/12/19.
//  Copyright © 2019 appic. All rights reserved.
//

import UIKit
import Foundation
import Charts

class BarValueFormatter: NSObject, IValueFormatter, IAxisValueFormatter {
    
    public var locations: [String]? = nil
    
    /// An appendix text to be added at the end of the formatted value.
    public var appendix: String?
    
    public init(appendix: [String]? = nil) {
        self.locations = appendix
    }
    
    fileprivate func format(value: Int) -> String {
        return (locations?[value])!
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        //return format(value: Int(value))
        let str = format(value: Int(value))
        
        return str
    }
    
    public func stringForValue(
        _ value: Double,
        entry: ChartDataEntry,
        dataSetIndex: Int,
        viewPortHandler: ViewPortHandler?) -> String {
        
        print("dataSetIndex\(dataSetIndex)")
        
        let str = format(value: dataSetIndex)
        
        return str
    }
}
