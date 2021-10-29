//
//  Cal.swift
//  Burgan
//
//  Created by Malti Maurya on 06/06/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import Foundation


class Cal: UIViewController, WWCalendarTimeSelectorProtocol, WWCalendarRowProtocol {
    
    
    func WWCalendarRowDateIsEnable(_ date: Date) -> Bool {
        selector.WWCalendarRowDateIsEnable(date)
    }
    
    func WWCalendarRowGetDetails(_ row: Int) -> (type: WWCalendarRowType, startDate: Date) {
        selector.WWCalendarRowGetDetails(row)
    }
    
    func WWCalendarRowDidSelect(_ date: Date) {
        selector.WWCalendarRowDidSelect(date)
    }
    
  
  
    
    fileprivate var singleDate: Date = Date()
    fileprivate var multipleDates: [Date] = []
     let selector = UIStoryboard(name: "WWCalendarTimeSelector", bundle: nil).instantiateViewController(withIdentifier: "WWCalendarTimeSelector") as! WWCalendarTimeSelector

    override func viewDidLoad() {
        super.viewDidLoad()
      
            selector.delegate = self
             selector.optionCurrentDate = singleDate
             selector.optionCurrentDates = Set(multipleDates)
        selector.optionCurrentDateRange.setStartDate(Date().beginningOfMonth)
        selector.optionCurrentDateRange.setEndDate(Date().endOfMonth)
        selector.optionSelectionType = WWCalendarTimeSelectorSelection.range
        selector.view.frame = CGRect(x: 10, y: 10, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(selector.view)
        

    }
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
         print("Selected \n\(date)\n---")
         singleDate = date
     }
    var startDate = ""
    var endDate = ""
     
     func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, dates: [Date]) {
         print("Selected Multiple Dates \n\(dates)\n---")
         if let date = dates.first {
             singleDate = date
            
         }
         else {
           
        }
         multipleDates = dates
        startDate = dates.first!.stringFromFormat("dd-MM-yyyy")
                   endDate = dates.last!.stringFromFormat("dd-MM-yyyy")
        print("startdate : " , startDate)
        print("endDate : " , endDate)
     }

}

 
