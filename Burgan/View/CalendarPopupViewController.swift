//
//  CalendarPopupViewController.swift
//  Burgan
//
//  Created by Malti Maurya on 07/04/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit
import FSCalendar


class CalendarPopupViewController: UIViewController, WWClockProtocoll,  UIGestureRecognizerDelegate , FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance  {
    
    
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en")
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    weak var calendarClockdelegate : calendarDelegate?
    
    
    // Fonts & Colors
    
    open var optionClockFontAMPM = UIFont.systemFont(ofSize: 18)
    open var optionClockFontAMPMHighlight = UIFont.systemFont(ofSize: 20)
    open var optionClockFontColorAMPM = UIColor.black
    open var optionClockFontColorAMPMHighlight = UIColor.white
    open var optionClockBackgroundColorAMPMHighlight = UIColor.brown
    open var optionClockFontHour = UIFont.systemFont(ofSize: 16)
    open var optionClockFontHourHighlight = UIFont.systemFont(ofSize: 18)
    open var optionClockFontColorHour = UIColor.init(netHex: 0x7F9DB8)
    open var optionClockFontColorHourHighlight = UIColor.white
    open var optionClockBackgroundColorHourHighlight = UIColor.init(netHex: 0xF18E00)
    open var optionClockBackgroundColorHourHighlightNeedle = UIColor.init(netHex: 0xF18E00)
    open var optionClockFontMinute = UIFont.systemFont(ofSize: 12)
    open var optionClockFontMinuteHighlight = UIFont.systemFont(ofSize: 14)
    open var optionClockFontColorMinute = UIColor.init(netHex: 0xF18E00)
    open var optionClockFontColorMinuteHighlight = UIColor.white
    open var optionClockBackgroundColorMinuteHighlight = UIColor.init(netHex: 0xF18E00)
    open var optionClockBackgroundColorMinuteHighlightNeedle = UIColor.init(netHex: 0xF18E00)
    open var optionClockBackgroundColorFace = UIColor(white: 0.9, alpha: 1)
    open var optionClockBackgroundColorCenter = UIColor.init(netHex: 0xF18E00)
    
    
    
    open var optionSelectorPanelFontColorTime = UIColor(white: 1, alpha: 0.5)
    open var optionSelectorPanelFontColorTimeHighlight = UIColor.white
    
    open var optionSelectorPanelBackgroundColor = UIColor.brown.withAlphaComponent(0.9)
    
    open var optionMainPanelBackgroundColor = UIColor.white
    open var optionBottomPanelBackgroundColor = UIColor.white
    
    
    fileprivate var isFirstLoad = false
    
    @IBOutlet weak var clockView: WWClockk!
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    
    @IBOutlet weak var tabView: UIView!
    
    
    @IBOutlet weak var timeViewBarView: UIView!
    @IBOutlet weak var ivTimeView: UIImageView!
    @IBOutlet weak var dateViewBarView: UIView!
    @IBOutlet weak var ivDateView: UIImageView!
    @IBOutlet weak var divlbl: UIView!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var btnYear: UIButton!
    @IBOutlet weak var btnMonth: UIButton!
    @IBOutlet weak var btnWeek: UIButton!
    @IBOutlet weak var lblSelectedDate: UILabel!
    @IBOutlet weak var clockStackView: UIStackView!
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var calendarStackView: UIStackView!
    @IBOutlet weak var lblFromTime: UILabel!
    @IBOutlet weak var btnFromTimeAM: UIButton!
    @IBOutlet weak var btnFromTimePM: UIButton!
    @IBOutlet weak var lblToTime: UILabel!
    
    @IBOutlet weak var kyomokiCalendarview: UIView!
    @IBOutlet weak var btnToTimePM: UIButton!
    @IBOutlet weak var btnToTimeAM: UIButton!
    var  popuptype = 0
    var isFromTime : String?
    var isToTime : String?
    var isFromAMPM : String = "AM"
    var isToAMPM : String = "PM"
    
    var isFromPage = String()
    
    
    @IBAction func toTimeAM(_ sender: Any) {
        isToAMPM = "AM"
        btnToTimeAM.layer.opacity = 1
        btnToTimePM.layer.opacity = 0.5
        WWClockSwitchAMPM(isAM: true, isPM: false)
        
    }
    
    @IBAction func toTimePM(_ sender: Any) {
        isToAMPM = "PM"
        btnToTimeAM.layer.opacity = 0.5
        btnToTimePM.layer.opacity = 1
        WWClockSwitchAMPM(isAM: false, isPM: true)
        
    }
    
    @IBAction func fromTimeAM(_ sender: Any) {
        isFromAMPM = "AM"
        btnFromTimeAM.layer.opacity = 1
        btnFromTimePM.layer.opacity = 0.5
        WWClockSwitchAMPM(isAM: true, isPM: false)
    }
    
    @IBAction func fromTimePM(_ sender: Any) {
        isFromAMPM = "PM"
        btnFromTimeAM.layer.opacity = 0.5
        btnFromTimePM.layer.opacity = 1
        WWClockSwitchAMPM(isAM: false, isPM: true)
        
    }
    
    @IBAction func timePickerSelectionChange(_ sender: UIDatePicker) {
        
        print(sender.date)
        print(convertDateToFormat(date: sender.date, desiredFormat: "a"))
        
        if isToTimeSelected {
            
            /*
             let inputFormatter = DateFormatter()
             inputFormatter.dateFormat = "hh:mm a"
             // let timeStr = startTime! + " " + isFromAMPM
             let timeStr = "10:37 pm"
             print(timeStr)
             let tempdate = inputFormatter.date(from: timeStr)
             
             if tempdate! > sender.date {
             // Alert
             showAlertDismissOnly(message: AlertMessage(title: "".localiz(), body: "TO date must be greator tha FROM date".localiz()))
             
             } else {
             
             // endTime = sender.date.stringFromFormat("hh':'mm':'ss").lowercased()
             endTime = sender.date.stringFromFormat("hh':'mm").lowercased()
             lblToTime.text = sender.date.stringFromFormat("h':'mm").lowercased()
             
             switch convertDateToFormat(date: sender.date, desiredFormat: "a") {
             case "AM":
             isToAMPM = "AM"
             btnToTimeAM.layer.opacity = 1
             btnToTimePM.layer.opacity = 0.5
             break
             case "PM":
             isToAMPM = "PM"
             btnToTimeAM.layer.opacity = 0.5
             btnToTimePM.layer.opacity = 1
             break
             default:
             print("Default...")
             }
             
             }
             */
            
            // endTime = sender.date.stringFromFormat("hh':'mm':'ss").lowercased()
            endTime = sender.date.stringFromFormat("hh':'mm").lowercased()
            lblToTime.text = sender.date.stringFromFormat("h':'mm").lowercased()
            
            switch convertDateToFormat(date: sender.date, desiredFormat: "a") {
            case "AM":
                isToAMPM = "AM"
                btnToTimeAM.layer.opacity = 1
                btnToTimePM.layer.opacity = 0.5
                break
            case "PM":
                isToAMPM = "PM"
                btnToTimeAM.layer.opacity = 0.5
                btnToTimePM.layer.opacity = 1
                break
            default:
                print("Default...")
            }
            
            
        }else{
            
            // startTime = sender.date.stringFromFormat("hh':'mm':'ss").lowercased()
            startTime = sender.date.stringFromFormat("hh':'mm").lowercased()
            lblFromTime.text = sender.date.stringFromFormat("hh':'mm").lowercased()
            
            switch convertDateToFormat(date: sender.date, desiredFormat: "a") {
            case "AM":
                isFromAMPM = "AM"
                btnFromTimeAM.layer.opacity = 1
                btnFromTimePM.layer.opacity = 0.5
                break
            case "PM":
                isFromAMPM = "PM"
                btnFromTimeAM.layer.opacity = 0.5
                btnFromTimePM.layer.opacity = 1
                break
            default:
                print("Default...")
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timePicker.setValue(UIColor.white, forKeyPath: "textColor")
        // timePicker.setValue(false, forKeyPath: "highlightsToday")
        timePicker.locale = Locale(identifier: "en")
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat =  "hh:mm a"
        //        let date = dateFormatter.date(from: "12:00 AM")
        //        timePicker.date = date ?? Date()
        timePicker.date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: Date())) ?? Date()
        
        
        
        if isFromPage == "reports" {
            self.btnWeek.isHidden = true
            self.btnMonth.isHidden = true
        } else {
            self.btnWeek.isHidden = false
            self.btnMonth.isHidden = false
        }
        
        arabic()
        addView.clipsToBounds = true
        addView.layer.cornerRadius = 10
        addView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        calendarSetup()
        clockSetup(clock: clockView)
        deselectButton(btn: btnWeek)
        deselectButton(btn: btnYear)
        deselectButton(btn: btnMonth)
        if(popuptype == 0)
        {
            calendarStackView.isHidden = false
            clockStackView.isHidden = true
            tabView.isHidden = true
            lblSelectedDate.isHidden = false
            kyomokiCalendarview.isHidden = false
            divlbl.isHidden = false
            tabViewHeight.constant = 0
            
        }else if(popuptype == 1)
        {
            calendarStackView.isHidden = false
            clockStackView.isHidden = true
            tabView.isHidden = false
            tabViewHeight.constant = 50
            divlbl.isHidden = true
            kyomokiCalendarview.isHidden = true
            lblSelectedDate.isHidden = true
            dateViewBarView.backgroundColor = UIColor.white
            ivDateView.image? = (ivDateView.image?.withRenderingMode(.alwaysTemplate))!
            ivDateView.tintColor = UIColor.white
            ivTimeView.image? = (ivTimeView.image?.withRenderingMode(.alwaysTemplate))!
            ivTimeView.tintColor = UIColor.init(netHex: 0x7F9DB8)
            
            
            timeViewBarView.backgroundColor = UIColor.clear
        }else
        {
            startTime = AppConstants.startTime
            endTime = AppConstants.endTime
            calendarStackView.isHidden = true
            clockStackView.isHidden = false
            tabView.isHidden = false
            tabViewHeight.constant = 50
            kyomokiCalendarview.isHidden = true
            lblSelectedDate.isHidden = true
            divlbl.isHidden = true
            dateViewBarView.backgroundColor = UIColor.clear
            ivDateView.image? = (ivDateView.image?.withRenderingMode(.alwaysTemplate))!
            ivDateView.tintColor = UIColor.init(netHex: 0x7F9DB8)
            ivTimeView.image? = (ivTimeView.image?.withRenderingMode(.alwaysTemplate))!
            ivTimeView.tintColor = UIColor.white
            
            timeViewBarView.backgroundColor = UIColor.white
        }
        createTapGeusture()
        //        selectButton(btn: btnWeek)
        //        deselectButton(btn: btnYear)
        //        deselectButton(btn: btnMonth)
        
    }
    
    @IBOutlet weak var btnApply: UIButton!
    
    func arabic(){
        btnApply.setTitle("APPLY".localiz(), for: .normal)
        btnMonth.setTitle(" " + "This Month".localiz() + " ", for: .normal)
        btnWeek.setTitle(" " +  "This Week".localiz() + " ", for: .normal)
        btnYear.setTitle(" " + "This Year".localiz() + " ", for: .normal)
        
        for obj in  fsCalendar.calendarWeekdayView.weekdayLabels {
            
            obj.text = obj.text?.localiz()
        }
        
    }
    
    func createTapGeusture(){
        
        let tapToTime = UITapGestureRecognizer(target: self, action: #selector(self.selectToDate))
        lblToTime.isUserInteractionEnabled = true;
        self.lblToTime.addGestureRecognizer(tapToTime)
        
        let tapFromTime = UITapGestureRecognizer(target: self, action: #selector(self.selectFromDate))
        lblFromTime.isUserInteractionEnabled = true;
        self.lblFromTime.addGestureRecognizer(tapFromTime)
        
        let tapDate = UITapGestureRecognizer(target: self, action: #selector(self.showCalendar))
        dateView.isUserInteractionEnabled = true;
        self.dateView.addGestureRecognizer(tapDate)
        
        let tapTime = UITapGestureRecognizer(target: self, action: #selector(self.showClock))
        timeView.isUserInteractionEnabled = true;
        self.timeView.addGestureRecognizer(tapTime)
    }
    @IBOutlet weak var tabViewHeight: NSLayoutConstraint!
    
    @objc func selectFromDate(sender: UITapGestureRecognizer){
        
        // timePicker.minimumDate = nil
        
        isToTimeSelected = false
        lblFromTime.layer.opacity = 1
        lblToTime.layer.opacity = 0.5
        btnFromTimeAM.layer.opacity = 1
        btnFromTimePM.layer.opacity = 0.5
        clockView.delegate.WWClockSwitchAMPM(isAM: false, isPM: true)
        
    }
    
    @objc func selectToDate(sender: UITapGestureRecognizer){
        
        // timePicker.minimumDate = timePicker.date
        
        isToTimeSelected = true
        lblFromTime.layer.opacity = 0.5
        lblToTime.layer.opacity = 1
        btnToTimeAM.layer.opacity = 0.5
        btnToTimePM.layer.opacity = 1
        clockView.delegate.WWClockSwitchAMPM(isAM: false, isPM: true)
        
    }
    
    @objc func showCalendar(sender: UITapGestureRecognizer){
        
        calendarStackView.isHidden = false
        clockStackView.isHidden = true
        dateViewBarView.backgroundColor = UIColor.white
        ivDateView.image? = (ivDateView.image?.withRenderingMode(.alwaysTemplate))!
        ivDateView.tintColor = UIColor.white
        ivTimeView.image? = (ivTimeView.image?.withRenderingMode(.alwaysTemplate))!
        ivTimeView.tintColor = UIColor.init(netHex: 0x7F9DB8)
        
        timeViewBarView.backgroundColor = UIColor.clear
    }
    
    
    @objc func showClock(sender: UITapGestureRecognizer){
        
        calendarStackView.isHidden = true
        clockStackView.isHidden = false
        dateViewBarView.backgroundColor = UIColor.clear
        ivDateView.image? = (ivDateView.image?.withRenderingMode(.alwaysTemplate))!
        ivDateView.tintColor = UIColor.init(netHex: 0x7F9DB8)
        ivTimeView.image? = (ivTimeView.image?.withRenderingMode(.alwaysTemplate))!
        ivTimeView.tintColor = UIColor.white
        timeViewBarView.backgroundColor = UIColor.white
    }
    
    @IBAction func addDateRange(_ sender: Any) {
        if popuptype == 2 {
            
            if startTime != nil && endTime != nil {
                //            calendarClockdelegate?.selectTimeRange(startTimeValue: startTime!, endTimeValue: endTime!)
                calendarClockdelegate?.selectTimeRange(startTimeValue: startTime!, endTimeValue: endTime!, statTimeAMPM: isFromAMPM, endTimeAMPM: isToAMPM)
                self.dismiss(animated: true, completion: nil)
                
            } else {
                showAlertWith(message: AlertMessage(title: "Select Time".localiz()
                    , body: "Please select time range".localiz()))
            }
            
        } else {
            
            if startDate != nil && endDate != nil {
                calendarClockdelegate?.selectDateRange(startDate: startDate!, endDate: endDate!)
                self.dismiss(animated: true, completion: nil)
                
            } else if startDate != nil || endDate != nil {
                calendarClockdelegate?.selectDateRange(startDate: startDate!, endDate: startDate!)
                self.dismiss(animated: true, completion: nil)
                
            } else {
                showAlertDismissOnly(message: AlertMessage(title: "Select Date".localiz(), body: "Please select date range.".localiz()))
            }
        }
        //        self.dismiss(animated: true, completion: nil)
    }
    
    var startTime : String?
    var endTime : String?
    
    var startDate: Date? {
        didSet {
            startDate = startDate?.startOfDay
        }
    }
    
    var endDate: Date? {
        didSet {
            endDate = endDate?.endOfDayy
        }
    }
    
    var selectedDateArray: [Date] = [] {
        didSet {
            // sort the array
            selectedDateArray = fsCalendar.selectedDates.sorted()
            
            switch selectedDateArray.count {
            case 0:
                startDate = nil
                endDate = nil
            case 1:
                startDate = selectedDateArray.first
                endDate = nil
            case _ where selectedDateArray.count > 1:
                startDate = selectedDateArray.first
                endDate = selectedDateArray.last
                
                var nextDay = Calendar.current.date(byAdding: .day, value: 1, to: startDate!)
                while nextDay!.startOfDay <= endDate! {
                    fsCalendar.select(nextDay)
                    nextDay = Calendar.current.date(byAdding: .day, value: 1, to: nextDay!)
                    
                }
            default:
                return
            }
        }
    }
    
    
    @IBAction func thisWeek(_ sender: Any) {
        selectedDateArray.forEach { (date) in
            self.fsCalendar.deselect(date)
        }
        selectedDateArray.removeAll()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "MMM dd, yyyy"
        lblSelectedDate.text =  Date().beginningOfWeek.monthh + " " + String(Date().beginningOfWeek.day) + " - " + Date().beginningOfWeek.monthh + String(Date().day)
        let dateArray = Date.dates(from: Date().beginningOfWeek, to: Date())
        
        dateArray.forEach { (date) in
            self.fsCalendar.select(date, scrollToDate: false)
        }
        
        selectedDateArray = dateArray
        lblCurrentMonthName.text = Date().monthh.localiz() + " " + Date().yearr
        lblNextMonthName.text = Calendar.current.date(byAdding: .month, value: 1, to: Date())!.monthh + " " +  Calendar.current.date(byAdding: .month, value: 1, to: Date())!.yearr
        self.fsCalendar.reloadData()
        selectButton(btn: btnWeek)
        deselectButton(btn: btnYear)
        deselectButton(btn: btnMonth)
        
    }
    
    func deselectButton(btn:UIButton){
        
        btn.layer.cornerRadius = 10
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.borderWidth = 0.5
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.clear
    }
    func selectButton(btn:UIButton){
        btn.backgroundColor = UIColor.init(netHex: 0xF18E00)
        btn.setTitleColor(UIColor.white, for: .normal)
        
    }
    var setDefaultTimeSlot = false
    @IBAction func setDefaultTimeSlot(_ sender: Any) {
        if(setDefaultTimeSlot){
            btnDefaultTime.setImage(UIImage(named: ""), for: .normal)
            setDefaultTimeSlot = false
            btnDefaultTime.layer.cornerRadius = 3
            btnDefaultTime.layer.borderColor = UIColor.white.cgColor
            btnDefaultTime.setImage(UIImage(named: ""), for: .normal)
            btnDefaultTime.layer.borderWidth = 2
        }else{
            setDefaultTimeSlot = true
            btnDefaultTime.setImage(UIImage(named: "ic_checked_box_white"), for: .normal)
            btnDefaultTime.layer.borderWidth = 0
            
        }
    }
    
    @IBOutlet weak var btnDefaultTime: UIButton!
    @IBAction func thisYear(_ sender: Any) {
        selectedDateArray.forEach { (date) in
            self.fsCalendar.deselect(date)
        }
        selectedDateArray.removeAll()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "MMM dd, yyyy"
        lblSelectedDate.text =  Date().beginningOfYear.monthh + " " + String(Date().beginningOfYear.day) + " - " + Date().beginningOfYear.monthh + " " + String(Date().day)
        let dateArray = Date.dates(from: Date().beginningOfYear, to: Date())
        
        dateArray.forEach { (date) in
            self.fsCalendar.select(date, scrollToDate: false)
        }
        
        selectedDateArray = dateArray
        lblCurrentMonthName.text = Date().monthh.localiz() + " " + Date().yearr
        lblNextMonthName.text = Calendar.current.date(byAdding: .month, value: 1, to: Date())!.monthh + " " +  Calendar.current.date(byAdding: .month, value: 1, to: Date())!.yearr
        self.fsCalendar.reloadData()
        selectButton(btn: btnYear)
        deselectButton(btn: btnWeek)
        deselectButton(btn: btnMonth)
    }
    
    @IBAction func thisMonth(_ sender: Any) {
        selectedDateArray.forEach { (date) in
            self.fsCalendar.deselect(date)
        }
        selectedDateArray.removeAll()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "MMM dd, yyyy"
        lblSelectedDate.text =  Date().beginningOfMonth.monthh + " " + String(Date().beginningOfMonth.day) + " - " + Date().beginningOfMonth.monthh + " " + String(Date().day)
        let dateArray = Date.dates(from: Date().beginningOfMonth, to: Date())
        
        dateArray.forEach { (date) in
            self.fsCalendar.select(date, scrollToDate: false)
        }
        
        selectedDateArray = dateArray
        lblCurrentMonthName.text = Date().monthh.localiz() + " " + Date().yearr
        lblNextMonthName.text = Calendar.current.date(byAdding: .month, value: 1, to: Date())!.monthh + " " +  Calendar.current.date(byAdding: .month, value: 1, to: Date())!.yearr
        self.fsCalendar.reloadData()
        selectButton(btn: btnMonth)
        deselectButton(btn: btnWeek)
        deselectButton(btn: btnYear)
    }
    
    
    
    
    
    
    open var optionCurrentDate = Date().minute < 30 ? Date().beginningOfHour : Date().beginningOfHour + 1.hour
    func WWClockGetTime() -> Date {
        return optionCurrentDate
    }
    open var optionStyleBlurEffect: UIBlurEffect.Style = .dark
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if isFirstLoad {
            isFirstLoad = false // Temp fix for i6s+ bug?s
            clockView.setNeedsDisplay()
            
        }
    }
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isFirstLoad = false
    }
    
    func WWClockSwitchAMPM(isAM: Bool, isPM: Bool) {
        var newHour = optionCurrentDate.hour
        if isAM && newHour >= 12 {
            newHour = newHour - 12
        }
        if isPM && newHour < 12 {
            newHour = newHour + 12
        }
        
        optionCurrentDate = optionCurrentDate.change(hour: newHour)
        clockView.setNeedsDisplay()
    }
    
    
    var isToTimeSelected = false
    
    func WWClockSetHourMilitary(_ hour: Int) {
        optionCurrentDate = optionCurrentDate.change(hour: hour)
        clockView.setNeedsDisplay()
        let timeText = optionCurrentDate.stringFromFormat("hh':'mm a").lowercased()
        print(timeText)
        
        if isToTimeSelected {
            endTime = optionCurrentDate.stringFromFormat("hh':'mm':'ss").lowercased()
            lblToTime.text = optionCurrentDate.stringFromFormat("h':'mm").lowercased()
        }else{
            startTime = optionCurrentDate.stringFromFormat("hh':'mm':'ss").lowercased()
            //            lblFromTime.text = optionCurrentDate.stringFromFormat("hh':'mm").lowercased()
        }
        
        
    }
    
    func WWClockSetMinute(_ minute: Int) {
        optionCurrentDate = optionCurrentDate.change(minute: minute)
        clockView.setNeedsDisplay()
        let timeText = optionCurrentDate.stringFromFormat("hh':'mma").lowercased()
        print(timeText)
    }
    open var optionTimeStep: WWCalendarTimeSelectorTimeStepp = .fifteenMinutes
    
    
    func clockSetup(clock : WWClockk){
        clock.delegate = self
        clock.minuteStep = optionTimeStep
        clock.backgroundColorClockFace = optionClockBackgroundColorFace
        
        clock.backgroundColorClockFaceCenter = optionClockBackgroundColorCenter
        clock.fontAMPM = optionClockFontAMPM
        clock.fontAMPMHighlight = optionClockFontAMPMHighlight
        clock.fontColorAMPM = optionClockFontColorAMPM
        clock.fontColorAMPMHighlight = optionClockFontColorAMPMHighlight
        clock.backgroundColorAMPMHighlight = optionClockBackgroundColorAMPMHighlight
        clock.fontHour = optionClockFontHour
        clock.fontHourHighlight = optionClockFontHourHighlight
        clock.fontColorHour = optionClockFontColorHour
        clock.fontColorHourHighlight = optionClockFontColorHourHighlight
        clock.backgroundColorHourHighlight = optionClockBackgroundColorHourHighlight
        clock.backgroundColorHourHighlightNeedle = optionClockBackgroundColorHourHighlightNeedle
        clock.fontMinute = optionClockFontMinute
        clock.fontMinuteHighlight = optionClockFontMinuteHighlight
        clock.fontColorMinute = optionClockFontColorMinute
        clock.fontColorMinuteHighlight = optionClockFontColorMinuteHighlight
        clock.backgroundColorMinuteHighlight = optionClockBackgroundColorMinuteHighlight
        clock.backgroundColorMinuteHighlightNeedle = optionClockBackgroundColorMinuteHighlightNeedle
        
        //        lblFromTime.text = clock.delegate.WWClockGetTime().stringFromFormat("hh':'mm")
        lblFromTime.layer.opacity = 1
        lblToTime.layer.opacity = 0.5
        btnFromTimeAM.layer.opacity = 1
        btnFromTimePM.layer.opacity = 0.5
        lblToTime.text = "11:59"
        btnToTimeAM.layer.opacity = 0.5
        btnToTimePM.layer.opacity = 0.5
        isFirstLoad = true
        clockView.delegate = self
        clockView.delegate.WWClockSwitchAMPM(isAM: true, isPM: false)
    }
    
    
    @IBOutlet weak var fsCalendar: FSCalendar!
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    func calendarSetup(){
        fsCalendar.allowsMultipleSelection = true
        fsCalendar.backgroundColor = UIColor.clear
        fsCalendar.placeholderType = .none
        fsCalendar.appearance.calendar.contentView.backgroundColor = UIColor.clear
        fsCalendar.appearance.eventSelectionColor = UIColor.clear
        fsCalendar.appearance.eventDefaultColor = UIColor.clear
        
        fsCalendar.today = nil // Hide the today circle
        fsCalendar.register(CalendarCollectionViewCell.self, forCellReuseIdentifier: "cell")
        //        calendar.clipsToBounds = true // Remove top/bottom line
        
        fsCalendar.swipeToChooseGesture.isEnabled = true //
        //        let scopeGesture = UIPanGestureRecognizer(target: fsCalendar, action: #selector(fsCalendar.handleScopeGesture(_:)));
        //        fsCalendar.addGestureRecognizer(scopeGesture)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startdateGlobal = dateFormatter.date(from: AppConstants.jsonStartDate) ?? Date()
        let endDateGlobal = dateFormatter.date(from: AppConstants.jsonEndDate) ?? Date()
        lblSelectedDate.text =  startdateGlobal.monthh + " " + String(startdateGlobal.day) + " - " + endDateGlobal.monthh + " " +  String(endDateGlobal.day)
        
        let dateArray = Date.dates(from: startdateGlobal, to: endDateGlobal)
        
        dateArray.forEach { (date) in
            self.fsCalendar.select(date, scrollToDate: false)
        }
        
        selectedDateArray = dateArray
        lblCurrentMonthName.text = startdateGlobal.monthh.localiz() + " " + startdateGlobal.yearr
        lblNextMonthName.text = Calendar.current.date(byAdding: .month, value: 1, to: startdateGlobal)!.monthh + " " +  Calendar.current.date(byAdding: .month, value: 1, to: startdateGlobal)!.yearr
        selectButton(btn: btnMonth)
        deselectButton(btn: btnYear)
        deselectButton(btn: btnWeek)
        
        fsCalendar.currentPage = startdateGlobal
        var i : Int = 0
        
        for obj in  fsCalendar.calendarWeekdayView.weekdayLabels {
            
            if i == 0 {
                obj.text = "sun".localiz()
            } else if i == 1 {
                obj.text = "M".localiz()
            } else if i == 2 {
                obj.text = "tue".localiz()
            }  else if i == 3 {
                obj.text = "W".localiz()
            }  else if i == 4 {
                obj.text = "T".localiz()
            }  else if i == 5 {
                obj.text = "F".localiz()
            } else if i == 6 {
                obj.text = "S".localiz()
            }
            //            obj.text = obj.text?.localiz()
            
            i = i + 1
        }
        
    }
    
    
    
    @IBOutlet weak var lblNextMonthName: UILabel!
    @IBOutlet weak var lblCurrentMonthName: UILabel!
    
    // MARK:- FSCalendarDataSource
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        deselectButton(btn: btnWeek)
        deselectButton(btn: btnYear)
        deselectButton(btn: btnMonth)
        
        if date.isAfterDate(date.endOfDayy!) {
            calendar.deselect(date)
        } else {
            //selectedDateArray.append(date)
            
            if selectedDateArray.count >= 2 {
                selectedDateArray.removeAll()
                for d in calendar.selectedDates {
                    calendar.deselect(d)
                }
                calendar.select(date)
                selectedDateArray.append(date)
                
            } else {
                selectedDateArray.append(date)
            }
        }
        self.configureVisibleCells()
        performDateSelection(calendar)
    }
    private func performDateSelection(_ calendar: FSCalendar) {
        let sorted = calendar.selectedDates.sorted { $0 < $1 }
        if let firstDate = sorted.first, let lastDate = sorted.last {
            //            let ranges = datesRange(from: firstDate, to: lastDate)
            self.lblSelectedDate.text = "\(self.convertDateToFormat(date: firstDate, desiredFormat: "MMM dd")) - \(self.convertDateToFormat(date: lastDate, desiredFormat: "MMM dd"))"
        } else if let firstDate = sorted.first {
            self.lblSelectedDate.text = "\(self.convertDateToFormat(date: firstDate, desiredFormat: "MMM dd")) - \(self.convertDateToFormat(date: firstDate, desiredFormat: "MMM dd"))"
        } else {
            self.lblSelectedDate.text = "Please Select Date Range"
            
        }
    }
    
    func datesRange(from: Date, to: Date) -> [Date] {
        if from > to { return [Date]() }
        var tempDate = from
        var array = [tempDate]
        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }
        return array
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Calendar.current.date(byAdding: .month, value: -6, to: Date())!
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
        //        let cell = calendar.dequeueReusableCell(withIdentifier: "CalendarPopupCell", for: date, at: position) as! CalendarPopupCell
        
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if calendar.selectedDates.count > 2 {
            let datesToDeselect: [Date] = calendar.selectedDates.filter{ $0 > date }
            datesToDeselect.forEach{ calendar.deselect($0) }
            calendar.select(date) // adds back the end date that was just deselected so it matches selectedDateArray
        }
        selectedDateArray = selectedDateArray.filter{ $0 < date }
        selectedDateArray.forEach{calendar.select($0)}
        self.configureVisibleCells()
        
        performDateSelection(calendar)
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        self.configure(cell: cell, for: date, at: position)
    }
    //
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        //         if self.gregorian.isDateInToday(date) {
        //             return "今"
        //         }
        return nil
    }
    //
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 2
    }
    //
    //    // MARK:- FSCalendarDelegate
    //
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.fsCalendar.frame.size.height = bounds.height
    }
    //
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition)   -> Bool {
        return monthPosition == .current
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return monthPosition == .current
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        
        
        //        let currentMonth = calendar.month(of: calendar.currentPage)
        //        print("this is the current Month \(currentMonth)")
        print("this is the current Month \(calendar.currentPage)")
        
        //self.lblCurrentMonthName.text = self.convertDateToFormat(date: calendar.currentPage, desiredFormat: "MMMM, yyyy")
        
        self.lblCurrentMonthName.text = self.convertDateToFormat(date: calendar.currentPage, desiredFormat: "MMMM").localiz() + self.convertDateToFormat(date: calendar.currentPage, desiredFormat: ", yyyy")
        
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: calendar.currentPage)
        //        let nextYear = Calendar.current.date(byAdding: .yearForWeekOfYear, value: 1, to: calendar.currentPage)
        
        self.lblNextMonthName.text = self.convertDateToFormat(date: nextMonth!, desiredFormat: "MMMM, yyyy")
        //"\(nextMonth ?? ""), \(nextYear ?? <#default value#>)"
    }
    
    func convertDateToSpecificFormat(date: String, currentFormat: String, desiredFormat: String) -> String
    {
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en")
        inputFormatter.dateFormat = currentFormat
        let showDate = inputFormatter.date(from: date)
        inputFormatter.dateFormat = desiredFormat
        let resultString = inputFormatter.string(from: showDate!)
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
    
    // MARK: - Private functions
    
    private func configureVisibleCells() {
        fsCalendar.visibleCells().forEach { (cell) in
            let date = fsCalendar.date(for: cell)
            let position = fsCalendar.monthPosition(for: cell)
            self.configure(cell: cell, for: date!, at: position)
        }
    }
    
    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        
        let diyCell = (cell as! CalendarCollectionViewCell)
        // Custom today circle
        diyCell.circleImageView.isHidden = !self.gregorian.isDateInToday(date)
        // Configure selection layer
        if position == .current {
            
            var selectionType = SelectionType.none
            
            if fsCalendar.selectedDates.contains(date) {
                let previousDate = self.gregorian.date(byAdding: .day, value: -1, to: date)!
                let nextDate = self.gregorian.date(byAdding: .day, value: 1, to: date)!
                if fsCalendar.selectedDates.contains(date) {
                    if fsCalendar.selectedDates.contains(previousDate) && fsCalendar.selectedDates.contains(nextDate) {
                        selectionType = .middle
                    }
                    else if fsCalendar.selectedDates.contains(previousDate) && fsCalendar.selectedDates.contains(date) {
                        selectionType = .rightBorder
                    }
                    else if fsCalendar.selectedDates.contains(nextDate) {
                        selectionType = .leftBorder
                    }
                    else {
                        selectionType = .single
                    }
                }
            }
            else {
                selectionType = .none
            }
            if selectionType == .none {
                diyCell.selectionLayer.isHidden = true
                return
            }
            diyCell.selectionLayer.isHidden = false
            diyCell.selectionType = selectionType
            
        } else {
            diyCell.circleImageView.isHidden = true
            diyCell.selectionLayer.isHidden = true
        }
    }
    
    
    
}
extension Date {
    
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
    static var yesterdayd: Date { return Date().dayBefore }
    static var tomorrowd:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var monthd: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.monthh != monthh
    }
}

extension Date {
    
    
    func isSameDate(_ comparisonDate: Date) -> Bool {
        let order = Calendar.current.compare(self, to: comparisonDate, toGranularity: .day)
        return order == .orderedSame
    }
    
    func isBeforeDate(_ comparisonDate: Date) -> Bool {
        let order = Calendar.current.compare(self, to: comparisonDate, toGranularity: .day)
        
        return order == .orderedAscending
    }
    
    func isAfterDate(_ comparisonDate: Date) -> Bool {
        let order = Calendar.current.compare(self, to: comparisonDate, toGranularity: .day)
        return order == .orderedDescending
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDayy: Date? {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)
    }
}
