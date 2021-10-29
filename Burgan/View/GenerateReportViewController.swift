//
//  GenerateReportViewController.swift
//  Burgan
//
//  Created by Malti Maurya on 01/04/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit
import SPStorkController
protocol addLocationDelegate : class {
    func addLocation()
}
protocol selectMIDsDelegate : class {
    func selectMIDs(merchantNumber : [String])
}
protocol calendarDelegate : class {
    func selectDateRange(startDate : Date, endDate:Date)
    //    func selectTimeRange(startTimeValue : String , endTimeValue : String)
    func selectTimeRange(startTimeValue : String , endTimeValue : String, statTimeAMPM : String, endTimeAMPM : String)
}

class GenerateReportViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, selectMIDsDelegate, calendarDelegate, applyFilterDelegate {
    
    func applyFilter(heirarchy: selectedFilterData, isCif: Bool) {
        
        lblCompanyName.text = heirarchy.companyName
        lblBrandCount.text = "\(heirarchy.selectedBrands.count)"
        accountCount.text = "\(heirarchy.selectedAccounts.count)"
        AppConstants.cifCompanyName = AppConstants.selectedFilter!.companyName
        AppConstants.UserData.companyCIF = AppConstants.selectedFilter!.cif
        
        var  selectedLocation : [LocationNameList] = []
        for i in 0..<heirarchy.selectedHeirarchy.count {
            for j in 0..<heirarchy.selectedHeirarchy[i].brandNameList.count
            {
                for k in 0..<heirarchy.selectedHeirarchy[i].brandNameList[j].locationNameList.count
                {
                    let l =  heirarchy.selectedLocations.filter{$0 == heirarchy.selectedHeirarchy[i].brandNameList[j].locationNameList[k].locationName}
                    if l.count > 0
                    {
                        selectedLocation.append(heirarchy.selectedHeirarchy[i].brandNameList[j].locationNameList[k])
                    }
                }
            }
        }
        
        selectedMerchantLocation = selectedLocation
        addLocation()
        locationCollectionView.reloadData()
        
        
        for obj in heirarchy.selectedAccounts {
            
            for subObj in heirarchy.selectedHeirarchy {
                
                if obj == subObj.accountNumber {
                    
                    for j in 0..<subObj.brandNameList.count{
                        for k in 0..<subObj.brandNameList[j].locationNameList.count{
                            for l in 0..<subObj.brandNameList[j].locationNameList[k].merchantNumber.count
                            {
                                let m : Int = Int(subObj.brandNameList[j].locationNameList[k].merchantNumber[l].mid)!
                                merchantNumber.append(m)
                            }
                        }
                    }
                }
            }
        }
        
        
        if reportType == 0 {
            
            paymentCurvedViewHeight.constant = 500
            paymentCurvedView.isHidden = false
            
            isTransactionTypeSelection = true
            
        } else if reportType == 1 {
            
            
        } else {
            
            paymentCurvedViewHeight.constant = 0
            paymentCurvedView.isHidden = true
            
        }
        
    }
    
    
    @IBOutlet weak var transactionLbl: UILabel!
    @IBOutlet weak var lblAddID: UILabel!
    
    @IBOutlet weak var transactionTypeLbl: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblPaymentType: UILabel!
    @IBOutlet weak var lblToDate: UILabel!
    @IBOutlet weak var lblFromDate: UILabel!
    @IBOutlet weak var locationCollectionView: UICollectionView!
    @IBOutlet weak var lblMIDCount: UILabel!
    @IBOutlet weak var debitCardCurvedView: GradientLayer!
    @IBOutlet weak var creditCardCurvedView: GradientLayer!
    @IBOutlet weak var transactnTypesCurvedView: GradientLayer!
    @IBOutlet weak var voidCurvedView: GradientLayer!
    @IBOutlet weak var kdCurvedView: GradientLayer!
    @IBOutlet weak var declinedCurvedView: GradientLayer!
    @IBOutlet weak var paymentTypesCurvedView: GradientLayer!
    @IBOutlet weak var selectMIDSwicth: UISwitch!
    @IBOutlet weak var paymentCurvedViewHeight: NSLayoutConstraint!
    @IBOutlet weak var lblLatMonth: UILabel!
    @IBOutlet weak var lblQuarter: UILabel!
    @IBOutlet weak var lblThisWeek: UILabel!
    @IBOutlet weak var lblThisMonth: UILabel!
    @IBOutlet weak var transactionCurvedView: UIView!
    @IBOutlet weak var paymentCurvedView: UIView!
    @IBOutlet weak var MIDCountCurvedView: UIView!
    @IBOutlet weak var selectMIDCurvedView: UIView!
    @IBOutlet weak var locationListViewCurved: UIView!
    @IBOutlet weak var addLocationCurvedView: UIView!
    @IBOutlet weak var dateTimeCurvedView: UIView!
    @IBOutlet weak var selectDuratnCurvedView: UIView!
    @IBOutlet weak var creditBankCurvedView: UIView!
    @IBOutlet weak var settlementCurvedView: UIView!
    @IBOutlet weak var btnGenerate: GradientLayer!
    @IBOutlet weak var btnAddFilter: UIButton!
    @IBOutlet weak var paymentTypeCount: UILabel!
    @IBOutlet weak var transactionTypeCount: UILabel!
    @IBOutlet weak var clearBtn: UILabel!
    @IBOutlet weak var selectAllBtn: UILabel!
    
    @IBOutlet weak var timeRangeCurvedView: UIView!
    @IBOutlet weak var dateRangeCurvedView: UIView!
    @IBOutlet weak var monthCurvedView: GradientLayer!
    @IBOutlet weak var weekCurvedView: GradientLayer!
    @IBOutlet weak var lastQuarterCurvedView: GradientLayer!
    @IBOutlet weak var lastMonthCurvedView: GradientLayer!
    @IBOutlet weak var selectDateCurvedView: GradientLayer!
    @IBOutlet weak var lblSelectedDate: UILabel!
    @IBOutlet weak var lblSelectedTime: UILabel!
    
    //tijarati pay check mark
    @IBOutlet weak var tijaratiPayDebitView: UIView!
    @IBOutlet weak var tijaratiPayCreditView: UIView!
    
    
    @IBOutlet weak var viewTimeSlot: UIView!
    var reportType = 0
    var startDate = ""
    var endDate = ""
    var startTime = AppConstants.startTime
    var endTime = AppConstants.endTime
    
    var startAMPM : String  = "AM"
    var endAMPM : String  = "PM"
    
    //    var merchantNumber : [String]?
    var merchantNumber : [Int] = []
    var transactionTypes : [String] = []
    var paymentType : [String : Any] = [:]
    
    @IBOutlet weak var dateTimeCurvedViewHeight: NSLayoutConstraint!
    
    var isTransactionTypeSelection : Bool = false
    
    
    
    @IBAction func addLocation(_ sender: Any) {
        
        if AppConstants.selectedFilter != nil {
            let controller = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SelectLocationViewController") as? SelectLocationViewController)!
            controller.delegateFilter = self
            presentAsStork(controller, height: 500, cornerRadius: 8.0, showIndicator: false, showCloseButton: false)
        }else{
            showAlertWith(message: AlertMessage(title: "Tijarati".localiz(), body: "No data available to filter.".localiz()))
        }
        
    }
    
    
    
    @IBOutlet weak var lblBrandCount: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var accountCount: UILabel!
    @IBOutlet weak var locationCurvedView: UIView!
    var selectedMerchantLocation : [LocationNameList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transactionLbl.text = "TransactionLbl".localiz()
        
        let main_string = "Add the ID (CID, Account Numbers, Brands, Locations) you want to download the data for.".localiz()
        let string_to_color = "(CID, Account Numbers, Brands, Locations)".localiz()
        
        let range = (main_string as NSString).range(of: string_to_color)
        
        let attribute = NSMutableAttributedString.init(string: main_string)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(hexString: "0065A6") , range: range)
        self.lblAddID.attributedText = attribute
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.networkStatusChanged(_:)), name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        definesPresentationContext = true
        
        
        self.navigationController?.isNavigationBarHidden = true
        
        self.loopThroughSubViewAndAlignTextfieldText(subviews: self.view.subviews)
        self.loopThroughSubViewAndAlignLabelText(subviews: self.view.subviews)
        
        curvedviewShadow(view: transactionCurvedView)
        curvedviewShadow(view: settlementCurvedView)
        curvedviewShadow(view: creditBankCurvedView)
        curvedviewShadow(view: addLocationCurvedView)
        curvedviewShadow(view: selectDuratnCurvedView)
        curvedviewShadow(view: dateTimeCurvedView)
        curvedviewShadow(view: selectMIDCurvedView)
        curvedviewShadow(view: MIDCountCurvedView)
        curvedviewShadow(view: paymentCurvedView)
        locationCurvedView.isHidden = true
        
        curvedviewShadow(view: locationCurvedView)
        curvedview(view: creditBankCurvedView)
        curvedBorderView(view: debitCardCurvedView)
        curvedBorderView(view: declinedCurvedView)
        curvedBorderView(view: voidCurvedView)
        curvedBorderView(view: kdCurvedView)
        curvedviewShadow(view: paymentCurvedView)
        halfCurvedview(view: transactnTypesCurvedView)
        halfCurvedview(view: btnAddFilter)
        halfCurvedview(view: btnGenerate)
        curvedBorderView(view:selectDateCurvedView)
        curvedBorderView(view: creditCardCurvedView)
        paymentTypeCount.layer.cornerRadius = paymentTypeCount.frame.height / 2
        transactionTypeCount.layer.cornerRadius = transactionTypeCount.frame.height / 2
        halfCurvedview(view: paymentTypesCurvedView)
        selectMIDSwicth.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        curvedBorderView(view: weekCurvedView)
        curvedBorderView(view: monthCurvedView)
        curvedBorderView(view: lastMonthCurvedView)
        curvedBorderView(view: lastQuarterCurvedView)
        curvedBorderView(view: dateRangeCurvedView)
        curvedBorderView(view: timeRangeCurvedView)
        
        reportType(type: reportType)
        btnAddFilter.layer.addBorder(edge: [.top,.left,.right], color: UIColor.BurganColor.brandBlue.light, thickness: 1.0)
        paymentTypeCount.layer.cornerRadius = paymentTypeCount.frame.height / 2
        paymentTypeCount.clipsToBounds = true
        transactionTypeCount.layer.cornerRadius  = transactionTypeCount.frame.height / 2
        transactionTypeCount.clipsToBounds = true
        createTapGuesture()
        
        btnGenerate.setTitle("GENERATE".localiz(), for: .normal)
        btnAddFilter.setTitle("ADD MORE FILTERS".localiz(), for: .normal)
        
        lblCredit.text = "Credit Card".localiz()
        lblDebit.text = "Debit Card".localiz()
        lblDeclined.text = "Declined".localiz()
        lblSalesSuccess.text = "Sale Success".localiz()
        lblVoid.text = "Void".localiz()
        
        self.transactionTypeCount.text = "0"
        self.paymentTypeCount.text = "0"
    }
    
    @IBOutlet weak var lblCstmDateTime: UILabel!
    
    @IBOutlet weak var selectDurationCurvedViewHeight: NSLayoutConstraint!
    @IBOutlet weak var customDateTimeHeight: NSLayoutConstraint!
    @IBOutlet weak var customDateTimeStackView: UIStackView!
    var thisWeek = false
    var thisMonth = false
    var lastQuarter = false
    var lastMonth = false
    var customDateTime = false
    
    
    func popupShadow(view:UIView){
        view.layer.shadowColor = UIColor.BurganColor.brandGray.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        view.layer.shadowOpacity = 1.0
        view.layer.shadowRadius = 10.0
        view.layer.masksToBounds = false
    }
    
    func reportType(type:Int){
        switch type {
        case 0:
            transactionCurvedView.isHidden = false
            settlementCurvedView.isHidden = true
            creditBankCurvedView.isHidden = true
            customDateTimeStackView.isHidden = true
            dateTimeCurvedView.isHidden = true
            addLocationCurvedView.isHidden = true
            locationCurvedView.isHidden = true
            selectMIDCurvedView.isHidden = true
            MIDCountCurvedView.isHidden = true
            paymentCurvedView.isHidden = true
            selectDurationCurvedViewHeight.constant = selectDurationCurvedViewHeight.constant - 120
            
        case 1:
            transactionCurvedView.isHidden = true
            settlementCurvedView.isHidden = false
            creditBankCurvedView.isHidden = true
            
            customDateTimeStackView.isHidden = true
            dateTimeCurvedView.isHidden = true
            addLocationCurvedView.isHidden = true
            locationCurvedView.isHidden = true
            selectMIDCurvedView.isHidden = true
            MIDCountCurvedView.isHidden = true
            paymentCurvedView.isHidden = true
            selectDurationCurvedViewHeight.constant = selectDurationCurvedViewHeight.constant - 120
            
            
        case 2:
            transactionCurvedView.isHidden = true
            settlementCurvedView.isHidden = true
            creditBankCurvedView.isHidden = false
            
            customDateTimeStackView.isHidden = true
            dateTimeCurvedView.isHidden = true
            addLocationCurvedView.isHidden = true
            locationCurvedView.isHidden = true
            selectMIDCurvedView.isHidden = true
            MIDCountCurvedView.isHidden = true
            paymentCurvedView.isHidden = true
            selectDurationCurvedViewHeight.constant = selectDurationCurvedViewHeight.constant - 120
            
        default: break
            
        }
    }
    
    func selectMIDs(merchantNumber : [String]) {
        
        customDateTimeStackView.isHidden = true
        addLocationCurvedView.isHidden = true
        locationCurvedView.isHidden = false
        selectMIDCurvedView.isHidden = true
        MIDCountCurvedView.isHidden = false
        paymentCurvedView.isHidden = false
        dateTimeCurvedViewHeight.constant = 140 //90
        viewTimeSlot.isHidden = false
        btnAddFilter.isHidden = false
        lblMIDCount.text = String(merchantNumber.count)
        selectedMerchantArr = merchantNumber
        self.merchantNumber = merchantNumber.map { Int($0)!}
        
        if reportType == 0 {
            
            paymentCurvedViewHeight.constant = 500
            paymentCurvedView.isHidden = false
            
        } else if reportType == 1 {
            
            
        } else {
            
            paymentCurvedViewHeight.constant = 0
            paymentCurvedView.isHidden = true
            
        }
    }
    
    var selectedMerchantArr : [String] = []
    func selectDateRange(startDate: Date, endDate: Date) {
        
        jsonStartDate = startDate
        jsonEndDate = endDate
        let dateFormatter1 = DateFormatter()
        dateFormatter1.locale = Locale(identifier: "en")
        dateFormatter1.dateFormat = "dd MMM yyyy"
        //lblSelectedDate.text = dateFormatter1.string(from: startDate) + " " + "To".localiz() + " " + dateFormatter1.string(from: endDate)
        lblSelectedDate.text = "\(dateFormatter1.string(from: startDate)) " + "-" + " \(dateFormatter1.string(from: endDate))"
        
    }
    
    //    func selectTimeRange(startTimeValue: String, endTimeValue: String) {
    //        startTime = startTimeValue
    //        endTime = endTimeValue
    //        lblSelectedTime.text = startTime + " AM To " + endTime + " PM"
    //    }
    
    func selectTimeRange(startTimeValue : String , endTimeValue : String, statTimeAMPM : String, endTimeAMPM : String) {
        startTime = startTimeValue
        endTime = endTimeValue
        
        startAMPM = statTimeAMPM
        endAMPM = endTimeAMPM
        
        // lblSelectedTime.text = startTime + " \(statTimeAMPM) " + " " + "To".localiz() + " "  + endTime + " \(endTimeAMPM)"
        lblSelectedTime.text =  "\(startTime) \(statTimeAMPM) " + "-" + " \(endTime) \(endTimeAMPM)"
    }
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    func addLocation() {
        customDateTimeStackView.isHidden = true
        addLocationCurvedView.isHidden = true
        locationCurvedView.isHidden = false
        selectMIDCurvedView.isHidden = false
        MIDCountCurvedView.isHidden = true
        paymentCurvedView.isHidden = true
        dateTimeCurvedViewHeight.constant = 140
        viewTimeSlot.isHidden = false
        
    }
    
    
    @IBAction func selectMID(_ sender: Any) {
        
        selectMIDSwicth.setOn(true, animated: true)
        
        let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "chooseTIDsViewController") as? chooseTIDsViewController
        controller?.delegate = self
        controller?.selectLocations = selectedMerchantLocation
        controller?.searchLocations = selectedMerchantLocation
        //presentAsStork(controller!)
        let height : CGFloat = CGFloat(300 + selectedMerchantLocation.count * 300)
        presentAsStork(controller!, height:height, cornerRadius: 8, showIndicator: false, showCloseButton: false)
        
    }
    
    @IBAction func editMID(_ sender: Any) {
        
        let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "chooseTIDsViewController") as? chooseTIDsViewController
        controller?.delegate = self
        controller?.selectLocations = selectedMerchantLocation
        controller?.searchLocations = selectedMerchantLocation
        //presentAsStork(controller!)
        let height : CGFloat = CGFloat(300 + selectedMerchantLocation.count * 300)
        presentAsStork(controller!, height:height, cornerRadius: 8, showIndicator: false, showCloseButton: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedMerchantLocation.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LocationListTbCell", for: indexPath) as! LocationListTbCell
        cell.lblLocatioName.text = selectedMerchantLocation[indexPath.row].locationName
        
        return cell
    }
    
    @IBAction func close(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editDateTime(_ sender: Any) {
        
        dateTimeCurvedView.isHidden = true
        selectDuratnCurvedView.isHidden = false
        customDateTimeStackView.isHidden = false
        addLocationCurvedView.isHidden = true
        locationCurvedView.isHidden = true
        selectMIDCurvedView.isHidden = true
        MIDCountCurvedView.isHidden = true
        paymentCurvedView.isHidden = true
        selectDurationCurvedViewHeight.constant = 460
        
        btnAddFilter.isSelected = false
        
        isTransactionTypeSelection = false
    }
    
    func createTapGuesture(){
        
        let tapCredit = UITapGestureRecognizer(target: self, action: #selector(self.selectAllCredit))
        creditCardCurvedView.isUserInteractionEnabled = true;
        self.creditCardCurvedView.addGestureRecognizer(tapCredit)
        
        let tapDebit = UITapGestureRecognizer(target: self, action: #selector(self.selectAllDebit))
        debitCardCurvedView.isUserInteractionEnabled = true;
        self.debitCardCurvedView.addGestureRecognizer(tapDebit)
        
        let tapClearTransactions = UITapGestureRecognizer(target: self, action: #selector(self.clearTransactionsSelection))
        lblClearTransaction.isUserInteractionEnabled = true;
        self.lblClearTransaction.addGestureRecognizer(tapClearTransactions)
        
        
        let tapKDView = UITapGestureRecognizer(target: self, action: #selector(self.selectSalesSuccess))
        kdCurvedView.isUserInteractionEnabled = true;
        self.kdCurvedView.addGestureRecognizer(tapKDView)
        
        let tapVoidView = UITapGestureRecognizer(target: self, action: #selector(self.selectVoid))
        voidCurvedView.isUserInteractionEnabled = true;
        self.voidCurvedView.addGestureRecognizer(tapVoidView)
        
        let tapDeclineView = UITapGestureRecognizer(target: self, action: #selector(self.selectDeclined))
        declinedCurvedView.isUserInteractionEnabled = true;
        self.declinedCurvedView.addGestureRecognizer(tapDeclineView)
        
        let tapSelectAllPayments = UITapGestureRecognizer(target: self, action: #selector(self.selectAllPayments))
        selectAllBtn.isUserInteractionEnabled = true;
        self.selectAllBtn.addGestureRecognizer(tapSelectAllPayments)
        
        let tapClearPayments = UITapGestureRecognizer(target: self, action: #selector(self.clearPaymentSelection))
        clearBtn.isUserInteractionEnabled = true; self.clearBtn.addGestureRecognizer(tapClearPayments)
        
        let tapCreditFaceToFace = UITapGestureRecognizer(target: self, action: #selector(self.creditFaceToFace))
        faceToFaceCreditView.isUserInteractionEnabled = true; self.faceToFaceCreditView.addGestureRecognizer(tapCreditFaceToFace)
        
        let tapDebitFaceToFace = UITapGestureRecognizer(target: self, action: #selector(self.debitFaceToFace))
        faceToFaceDebitView.isUserInteractionEnabled = true; self.faceToFaceDebitView.addGestureRecognizer(tapDebitFaceToFace)
        
        let tapDebitContactless = UITapGestureRecognizer(target: self, action: #selector(self.debitContactless))
        contactlessDebitView.isUserInteractionEnabled = true; self.contactlessDebitView.addGestureRecognizer(tapDebitContactless)
        
        let tapCreditContactless = UITapGestureRecognizer(target: self, action: #selector(self.creditContactless))
        contactlessCreditView.isUserInteractionEnabled = true; self.contactlessCreditView.addGestureRecognizer(tapCreditContactless)
        
        let tapDebitTijaratiPay = UITapGestureRecognizer(target: self, action: #selector(self.debitTijaratiPay(sender:)))
        tijaratiPayDebitView.isUserInteractionEnabled = true; self.tijaratiPayDebitView.addGestureRecognizer(tapDebitTijaratiPay)
        
        let tapCreditTijaratiPay = UITapGestureRecognizer(target: self, action: #selector(self.creditTijaratiPay(sender:)))
        tijaratiPayCreditView.isUserInteractionEnabled = true; self.tijaratiPayCreditView.addGestureRecognizer(tapCreditTijaratiPay)
        
        let tapCreditEcomm = UITapGestureRecognizer(target: self, action: #selector(self.creditEcommerce))
        ecommerceCreditView.isUserInteractionEnabled = true; self.ecommerceCreditView.addGestureRecognizer(tapCreditEcomm)
        
        let tapDebitEcomm = UITapGestureRecognizer(target: self, action: #selector(self.debitEcommerce))
        ecommerceDebitView.isUserInteractionEnabled = true; self.ecommerceDebitView.addGestureRecognizer(tapDebitEcomm)
        
        let tapShowCalGesture = UITapGestureRecognizer(target: self, action: #selector(self.shwCalendar))
        dateRangeCurvedView.isUserInteractionEnabled = true; self.dateRangeCurvedView.addGestureRecognizer(tapShowCalGesture)
        
        
        let tapShowClockGesture = UITapGestureRecognizer(target: self, action: #selector(self.shwClock))
        timeRangeCurvedView.isUserInteractionEnabled = true; self.timeRangeCurvedView.addGestureRecognizer(tapShowClockGesture)
        
        
        let tapWeekGesture = UITapGestureRecognizer(target: self, action: #selector(self.selectWeek))
        weekCurvedView.isUserInteractionEnabled = true; self.weekCurvedView.addGestureRecognizer(tapWeekGesture)
        
        
        let tapThisMonthGesture = UITapGestureRecognizer(target: self, action: #selector(self.selectThisMonth))
        monthCurvedView.isUserInteractionEnabled = true; self.monthCurvedView.addGestureRecognizer(tapThisMonthGesture)
        
        
        let tapLastMonthGesture = UITapGestureRecognizer(target: self, action: #selector(self.selectLastMonth))
        lastMonthCurvedView.isUserInteractionEnabled = true; self.lastMonthCurvedView.addGestureRecognizer(tapLastMonthGesture)
        
        
        let tapLastQuarterGesture = UITapGestureRecognizer(target: self, action: #selector(self.selectLastQuarter))
        lastQuarterCurvedView.isUserInteractionEnabled = true; self.lastQuarterCurvedView.addGestureRecognizer(tapLastQuarterGesture)
        
        
        let tapCstmDateTimeGesture = UITapGestureRecognizer(target: self, action: #selector(self.selectCustomDateTime))
        selectDateCurvedView.isUserInteractionEnabled = true; self.selectDateCurvedView.addGestureRecognizer(tapCstmDateTimeGesture)
        
        let tapPaymentTypesGesture = UITapGestureRecognizer(target: self, action: #selector(self.shwPaymentTypes))
        paymentTypesCurvedView.isUserInteractionEnabled = true; self.paymentTypesCurvedView.addGestureRecognizer(tapPaymentTypesGesture)
        
        let tapTransactionTypesGesture = UITapGestureRecognizer(target: self, action: #selector(self.shwTransactionTypes))
        transactnTypesCurvedView.isUserInteractionEnabled = true; self.transactnTypesCurvedView.addGestureRecognizer(tapTransactionTypesGesture)
    }
    
    @IBOutlet weak var lblCredit: UILabel!
    @IBOutlet weak var lblDebit: UILabel!
    @IBOutlet weak var ivCredit: UIImageView!
    @IBOutlet weak var ivDebit: UIImageView!
    @IBOutlet weak var lblDeclined: UILabel!
    
    @objc func clearTransactionsSelection(sender: UITapGestureRecognizer)
    {
        btnSelectAllTransactions.setImage(UIImage(named: "ic_checkbox_disabled"), for: .normal)
        transactionTypes.removeAll()
        deselectTransactionType(view: kdCurvedView, lblName: lblSalesSuccess)
        ivKD.image = UIImage(named: "ic_sales_suces")
        
        deselectTransactionType(view: voidCurvedView, lblName: lblVoid)
        ivVoid.image = UIImage(named: "ic_void")
        
        deselectTransactionType(view: declinedCurvedView, lblName: lblDeclined)
        ivDecline.image = UIImage(named: "ic_declined")
        
        self.transactionTypeCount.text = "\(transactionTypes.count)"
    }
    
    @objc func selectAllCredit(sender: UITapGestureRecognizer) {
        
        btnSelectAll.setImage(UIImage.init(named: "ic_checkbox_disabled"), for: .normal)
        creditArray.removeAll()
        
        if creditCardCurvedView.tag == 1 {
            
            creditCardCurvedView.tag = 0
            
            deselectTransactionType(view: creditCardCurvedView, lblName: lblCredit)
            ivCredit.image = UIImage(named: "ic_cards_grey")
            
            deselectPaymentTypes(checkboxImg: ivFacetoFaceCredit, lblPaymentName: lblFaceToFaceCredit)
            deselectPaymentTypes(checkboxImg: ivEcommerceCredit, lblPaymentName: lblEcommerceCredit)
            deselectPaymentTypes(checkboxImg: ivContactlessCredit, lblPaymentName: lblContactLessCredit)
            deselectPaymentTypes(checkboxImg: ivTijaratiPayCredit, lblPaymentName: lblTijaratiPayCredit)
            
            
        } else {
            
            creditCardCurvedView.tag = 1
            
            selectTransactionType(view: creditCardCurvedView, lblName: lblCredit)
            ivCredit.image = UIImage(named: "ic_card")
            
            selectPaymentTypes(checkboxImg: ivFacetoFaceCredit, lblPaymentName: lblFaceToFaceCredit)
            creditArray.append("Face To Face")
            
            selectPaymentTypes(checkboxImg: ivEcommerceCredit, lblPaymentName: lblEcommerceCredit)
            creditArray.append("Ecommerce")
            
            selectPaymentTypes(checkboxImg: ivContactlessCredit, lblPaymentName: lblContactLessCredit)
            creditArray.append("Contactless")
            
            selectPaymentTypes(checkboxImg: ivTijaratiPayCredit, lblPaymentName: lblTijaratiPayCredit)
            creditArray.append("Tijarati Pay")
            
        }
        
        self.paymentTypeCount.text = "\(creditArray.count + debitArray.count)"
    }
    
    @objc func selectAllDebit(sender: UITapGestureRecognizer) {
        
        btnSelectAll.setImage(UIImage.init(named: "ic_checkbox_disabled"), for: .normal)
        debitArray.removeAll()
        
        if debitCardCurvedView.tag == 1 {
            
            debitCardCurvedView.tag = 0
            
            deselectTransactionType(view: debitCardCurvedView, lblName: lblDebit)
            ivDebit.image = UIImage(named: "ic_cards_grey")
            
            deselectPaymentTypes(checkboxImg: ivFaceToFaceDebit, lblPaymentName: lblFaceToFaceDebit)
            deselectPaymentTypes(checkboxImg: ivEcommerceDebit, lblPaymentName: lblEcommerceDebit)
            deselectPaymentTypes(checkboxImg: ivContactlessDebit, lblPaymentName: lblContactLessDebut)
            deselectPaymentTypes(checkboxImg: ivTijaratiPayDebit, lblPaymentName: lblTijaratiPayDebit)
            
            
        } else {
            
            debitCardCurvedView.tag = 1
            
            selectTransactionType(view: debitCardCurvedView, lblName: lblDebit)
            ivDebit.image = UIImage(named: "ic_card")
            
            selectPaymentTypes(checkboxImg: ivFaceToFaceDebit, lblPaymentName: lblFaceToFaceDebit)
            debitArray.append("Face To Face")
            
            selectPaymentTypes(checkboxImg: ivEcommerceDebit, lblPaymentName: lblEcommerceDebit)
            debitArray.append("Ecommerce")
            
            selectPaymentTypes(checkboxImg: ivContactlessDebit, lblPaymentName: lblContactLessDebut)
            debitArray.append("Contactless")
            
            selectPaymentTypes(checkboxImg: ivTijaratiPayDebit, lblPaymentName: lblTijaratiPayDebit)
            debitArray.append("Tijarati Pay")
            
        }
        
        self.paymentTypeCount.text = "\(creditArray.count + debitArray.count)"
    }
    
    @objc func shwCalendar(sender: UITapGestureRecognizer)
    {
        let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CalendarPopupViewController") as? CalendarPopupViewController
        controller?.popuptype = 0
        controller?.calendarClockdelegate = self
        controller?.isFromPage = "reports"
        presentAsStork(controller!, height: 620, cornerRadius: 8, showIndicator: false, showCloseButton: false)
    }
    
    func selectTransactionType(view: GradientLayer,lblName:UILabel){
        view.color1 = UIColor(displayP3Red: 0/255.0, green: 136/255.0, blue: 208/255.0, alpha: 1)
        view.color2 = UIColor(displayP3Red: 0/255.0, green: 115/255.0, blue: 185/255.0, alpha: 1)
        view.color3 = UIColor(displayP3Red: 0/255.0, green: 94/255.0, blue: 161/255.0, alpha: 1)
        view.layer.borderWidth = 0
        lblName.textColor = UIColor.white
        view.tag = 1
    }
    
    func deselectTransactionType(view: GradientLayer,lblName:UILabel){
        view.color1 = UIColor.white
        view.color2 =  UIColor.white
        view.color3 =  UIColor.white
        view.tag = 0
        curvedBorderView(view: view)
        lblName.textColor = UIColor.BurganColor.brandGray.medium
    }
    
    @objc func selectSalesSuccess(sender: UITapGestureRecognizer)
    {
        btnSelectAllTransactions.setImage(UIImage(named: "ic_checkbox_disabled"), for: .normal)
        if kdCurvedView.tag == 1{
            ivKD.image = UIImage(named: "ic_sales_suces")
            deselectTransactionType(view: kdCurvedView, lblName: lblSalesSuccess)
        }else{
            selectTransactionType(view: kdCurvedView, lblName: lblSalesSuccess)
            ivKD.image = UIImage(named: "ic_sales_suces_white")
        }
        if transactionTypes.count > 0
        {
            if transactionTypes.contains("SaleSuccess")
            {
                
                transactionTypes.remove(at: transactionTypes.index(of: "SaleSuccess")!)
                
            }else
            {
                transactionTypes.append("SaleSuccess")
            }
            
        }else{
            
            transactionTypes.append("SaleSuccess")
        }
        
        self.transactionTypeCount.text = "\(transactionTypes.count)"
    }
    
    @IBOutlet weak var ivKD: UIImageView!
    @IBOutlet weak var lblVoid: UILabel!
    @IBOutlet weak var ivVoid: UIImageView!
    @IBOutlet weak var lblSalesSuccess: UILabel!
    @objc func selectVoid(sender: UITapGestureRecognizer)
    {
        btnSelectAllTransactions.setImage(UIImage(named: "ic_checkbox_disabled"), for: .normal)
        if voidCurvedView.tag == 1{
            
            ivVoid.image = UIImage(named: "ic_void")
            deselectTransactionType(view: voidCurvedView, lblName: lblVoid)
        }else{
            
            selectTransactionType(view: voidCurvedView, lblName: lblVoid)
            ivVoid.image = UIImage(named: "ic_void_white")
        }
        if transactionTypes.count > 0
        {
            if transactionTypes.contains("Void")
            {
                
                transactionTypes.remove(at: transactionTypes.index(of: "Void")!)
                
            }else
            {
                transactionTypes.append("Void")
            }
            
        }else{
            
            transactionTypes.append("Void")
        }
        self.transactionTypeCount.text = "\(transactionTypes.count)"
    }
    
    @IBOutlet weak var ivDecline: UIImageView!
    @objc func selectDeclined(sender: UITapGestureRecognizer)
    {
        btnSelectAllTransactions.setImage(UIImage(named: "ic_checkbox_disabled"), for: .normal)
        if declinedCurvedView.tag == 1{
            ivDecline.image = UIImage(named: "ic_declined")
            deselectTransactionType(view: declinedCurvedView, lblName: lblDeclined)
        }else{
            selectTransactionType(view: declinedCurvedView, lblName: lblDeclined)
            ivDecline.image = UIImage(named: "ic_declined_white")
        }
        if transactionTypes.count > 0
        {
            if transactionTypes.contains("Decline")
            {
                
                transactionTypes.remove(at: transactionTypes.index(of: "Decline")!)
                
            }else
            {
                transactionTypes.append("Decline")
            }
            
        }else{
            
            transactionTypes.append("Decline")
        }
        
        self.transactionTypeCount.text = "\(transactionTypes.count)"
    }
    
    
    @objc func shwClock(sender: UITapGestureRecognizer)
    {
        let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CalendarPopupViewController") as? CalendarPopupViewController
        controller?.popuptype = 2
        controller?.calendarClockdelegate = self
        presentAsStork(controller!, height: 620, cornerRadius: 8, showIndicator: false, showCloseButton: false)
    }
    
    @IBOutlet weak var btnSelectAllTransactions: UIButton!
    @IBAction func selectAllTransactions(_ sender: Any) {
        transactionTypes.removeAll()
        btnSelectAllTransactions.setImage(UIImage(named: "ic_checkbox_enabled"), for: .normal)
        selectTransactionType(view: kdCurvedView, lblName: lblSalesSuccess)
        ivKD.image = UIImage(named: "ic_sales_suces_white")
        selectTransactionType(view: voidCurvedView, lblName: lblVoid)
        ivVoid.image = UIImage(named: "ic_void_white")
        selectTransactionType(view: declinedCurvedView, lblName: lblDeclined)
        ivDecline.image = UIImage(named: "ic_declined_white")
        transactionTypes.append("SalesSuccess")
        transactionTypes.append("Void")
        transactionTypes.append("Decline")
        
        self.transactionTypeCount.text = "\(transactionTypes.count)"
        
    }
    @IBOutlet weak var lblClearTransaction: UILabel!
    @IBOutlet weak var selectAllviewTransaction: UIView!
    @IBOutlet weak var selectAllViewPayment: UIView!
    @objc func shwPaymentTypes(sender: UITapGestureRecognizer)
    {
        selectAllViewPayment.isHidden = false
        selectAllviewTransaction.isHidden = true
        paymentTypeStackView.isHidden = false
        transactionTypeStackView.isHidden = true
        paymentTypeCount.backgroundColor = UIColor.white
        paymentTypeCount.textColor = UIColor.BurganColor.brandBlue.dark
        
        transactionTypeCount.backgroundColor = UIColor(displayP3Red: 122.0/255.0, green: 136.0/255.0, blue: 144.0/255.0, alpha: 1)
        transactionTypeCount.textColor = UIColor.white
        
        paymentTypesCurvedView.color1 = UIColor(displayP3Red: 0/255.0, green: 136/255.0, blue: 208/255.0, alpha: 1)
        paymentTypesCurvedView.color2 = UIColor(displayP3Red: 0/255.0, green: 115/255.0, blue: 185/255.0, alpha: 1)
        paymentTypesCurvedView.color3 = UIColor(displayP3Red: 0/255.0, green: 94/255.0, blue: 161/255.0, alpha: 1)
        lblPaymentType.textColor = UIColor.white
        
        transactnTypesCurvedView.color1 = UIColor.white
        transactnTypesCurvedView.color2 = UIColor.white
        transactnTypesCurvedView.color3 = UIColor.white
        transactionTypeLbl.textColor = UIColor(displayP3Red: 122.0/255.0, green: 136.0/255.0, blue: 144.0/255.0, alpha: 1)
        
        paymentCurvedViewHeight.constant = 500
        
    }
    
    @objc func shwTransactionTypes(sender: UITapGestureRecognizer)
    {
        selectAllViewPayment.isHidden = true
        selectAllviewTransaction.isHidden = false
        paymentTypeStackView.isHidden = true
        transactionTypeStackView.isHidden = false
        paymentTypeCount.backgroundColor = UIColor(displayP3Red: 122.0/255.0, green: 136.0/255.0, blue: 144.0/255.0, alpha: 1)
        paymentTypeCount.textColor =  UIColor.white
        transactionTypeCount.backgroundColor = UIColor.white
        transactionTypeCount.textColor = UIColor.BurganColor.brandBlue.dark
        
        transactnTypesCurvedView.color1 = UIColor(displayP3Red: 0/255.0, green: 136/255.0, blue: 208/255.0, alpha: 1)
        transactnTypesCurvedView.color2 = UIColor(displayP3Red: 0/255.0, green: 115/255.0, blue: 185/255.0, alpha: 1)
        transactnTypesCurvedView.color3 = UIColor(displayP3Red: 0/255.0, green: 94/255.0, blue: 161/255.0, alpha: 1)
        lblPaymentType.textColor =  UIColor(displayP3Red: 122.0/255.0, green: 136.0/255.0, blue: 144.0/255.0, alpha: 1)
        
        paymentTypesCurvedView.color1 = UIColor.white
        paymentTypesCurvedView.color2 = UIColor.white
        paymentTypesCurvedView.color3 = UIColor.white
        transactionTypeLbl.textColor = UIColor.white
        
        paymentCurvedViewHeight.constant = 400
        
    }
    
    var jsonStartDate : Date?
    var jsonEndDate : Date?
    var servicePreference : String?
    @IBOutlet weak var paymentTypeStackView: UIStackView!
    @IBOutlet weak var transactionTypeStackView: UIStackView!
    @objc func selectWeek(sender: UITapGestureRecognizer)
    {
        
        thisWeek = true
        thisMonth = false
        lastQuarter = false
        lastMonth = false
        
        let dateArray = Date.dates(from: Date().beginningOfWeek, to: Date())
        
        let currentWeekMonday = Date().currentWeekMonday
        print(currentWeekMonday.description(with: .current))
        
        
        //jsonStartDate = currentWeekMonday
        jsonStartDate = dateArray.first
        jsonEndDate = Date()
        startTime = AppConstants.startTime
        endTime = AppConstants.endTime
        
        selectRect(view: weekCurvedView, lbl: lblThisWeek)
        customDateTime = false
        deSelectRect(view: selectDateCurvedView, lbl: lblCstmDateTime)
        deSelectRect(view: monthCurvedView, lbl: lblThisMonth)
        deSelectRect(view: lastMonthCurvedView, lbl: lblLatMonth)
        deSelectRect(view: lastQuarterCurvedView, lbl: lblQuarter)
        selectDurationCurvedViewHeight.constant = 340
        customDateTimeStackView.isHidden = true
    }
    
    @objc func selectThisMonth(sender: UITapGestureRecognizer)
    {
        thisMonth = true
        lastMonth = false
        thisWeek = false
        lastQuarter = false
        
        let currentMonthStartDate = Date().startOfMonthDate()
        
        let startDateMonth = currentMonthStartDate!
        let endDateMonth =  Date()
        jsonStartDate = startDateMonth
        jsonEndDate = endDateMonth
        
        
        selectRect(view: monthCurvedView, lbl: lblThisMonth)
        customDateTime = false
        deSelectRect(view: selectDateCurvedView, lbl: lblCstmDateTime)
        deSelectRect(view: weekCurvedView, lbl: lblThisWeek)
        deSelectRect(view: lastMonthCurvedView, lbl: lblLatMonth)
        deSelectRect(view: lastQuarterCurvedView, lbl: lblQuarter)
        selectDurationCurvedViewHeight.constant = 340
        customDateTimeStackView.isHidden = true
        startTime = AppConstants.startTime
        endTime = AppConstants.endTime
        
        
    }
    
    func previousMonthDate(){
        startTime = AppConstants.startTime
        endTime = AppConstants.endTime
        let calendar = Calendar.current
        let currentDate = Date()
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale(identifier: "en")
        dateformatter.dateFormat = "dd MMM, yyyy"
        
        var components = calendar.dateComponents([.day, .month, .year], from: currentDate)
        components.month = components.month! - 1
        components.day = 1
        let startDate = calendar.date(from: components)
        let stringStartDate = dateformatter.string(from: startDate!)
        print(stringStartDate)
        jsonStartDate =  startDate!
        
        //        var components1 = calendar.dateComponents([.day, .month, .year], from: currentDate)
        //        components1.month = components1.month!
        //        components1.day = -1
        //        let endDate = calendar.date(from: components1)
        
        var comps2 = DateComponents()
        comps2.month = 1
        comps2.day = -1
        let endDate = Calendar.current.date(byAdding: comps2, to: startDate!)
        print(dateformatter.string(from: endDate!))
        
        let stringEndDate = dateformatter.string(from: endDate!)
        print(stringEndDate)
        jsonEndDate =  endDate!
        
        
    }
    func quarterMonthDate(){
        let calendar = Calendar.current
        let currentDate = Date()
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale(identifier: "en")
        dateformatter.dateFormat = "dd MMM, yyyy"
        
        var components = calendar.dateComponents([.day, .month, .year], from: currentDate)
        components.month = components.month! - 3
        components.day = 1
        let startDate = calendar.date(from: components)
        let stringStartDate = dateformatter.string(from: startDate!)
        print(stringStartDate)
        jsonStartDate =  startDate!
        
        //        var components1 = calendar.dateComponents([.day, .month, .year], from: currentDate)
        //        components1.month = components1.month!
        //        components1.day = -1
        //        let endDate = calendar.date(from: components1)
        
        var comps2 = DateComponents()
        comps2.month = 1
        comps2.day = -1
        let endDate = Calendar.current.date(byAdding: comps2, to: startDate!)
        print(dateformatter.string(from: endDate!))
        
        let stringEndDate = dateformatter.string(from: endDate!)
        print(stringEndDate)
        jsonEndDate = endDate!
        startTime = AppConstants.startTime
        endTime = AppConstants.endTime
        
        
    }
    @objc func selectLastMonth(sender: UITapGestureRecognizer)
    {
        
        lastMonth = true
        thisWeek = false
        thisMonth = false
        lastQuarter = false
        selectRect(view: lastMonthCurvedView, lbl: lblLatMonth)
        customDateTime = false
        deSelectRect(view: selectDateCurvedView, lbl: lblCstmDateTime)
        deSelectRect(view: weekCurvedView, lbl: lblThisWeek)
        deSelectRect(view: monthCurvedView, lbl: lblThisMonth)
        deSelectRect(view: lastQuarterCurvedView, lbl: lblQuarter)
        selectDurationCurvedViewHeight.constant = 340
        customDateTimeStackView.isHidden = true
        previousMonthDate()
        startTime = AppConstants.startTime
        endTime = AppConstants.endTime
        
    }
    
    @objc func selectLastQuarter(sender: UITapGestureRecognizer)
    {
        startTime = AppConstants.startTime
        endTime = AppConstants.endTime
        lastQuarter = true
        thisWeek = false
        thisMonth = false
        lastMonth = false
        selectRect(view: lastQuarterCurvedView, lbl: lblQuarter)
        customDateTime = false
        deSelectRect(view: selectDateCurvedView, lbl: lblCstmDateTime)
        selectDurationCurvedViewHeight.constant = 340
        customDateTimeStackView.isHidden = true
        deSelectRect(view: weekCurvedView, lbl: lblThisWeek)
        deSelectRect(view: monthCurvedView, lbl: lblThisMonth)
        deSelectRect(view: lastMonthCurvedView, lbl: lblLatMonth)
        quarterMonthDate()
        
    }
    @objc func selectCustomDateTime(sender: UITapGestureRecognizer)
    {
        
        
        customDateTime = true
        selectRect(view: selectDateCurvedView, lbl: lblCstmDateTime)
        deSelectRect(view: lastQuarterCurvedView, lbl: lblQuarter)
        deSelectRect(view: lastMonthCurvedView, lbl: lblLatMonth)
        deSelectRect(view: monthCurvedView, lbl: lblThisMonth)
        deSelectRect(view: weekCurvedView, lbl: lblThisWeek)
        thisWeek = false
        thisMonth = false
        lastQuarter = false
        lastMonth = false
        customDateTimeStackView.isHidden = false
        selectDurationCurvedViewHeight.constant = 460
        jsonEndDate = nil
        jsonStartDate = nil
        
    }
    
    @IBAction func addFilter(_ sender: Any) {
        
        if jsonStartDate != nil && jsonEndDate != nil {
            
            if btnAddFilter.isSelected == true {
                
            } else {
                btnAddFilter.isSelected = true
                selectLocation()
            }
            
            
        }else{
            showAlertWith(message: AlertMessage(title: "Reports".localiz(), body: "Please select duration to proceed filter.".localiz()))
        }
        
        
    }
    
    func selectLocation()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "dd MMM yyyy"
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en")
        // formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "hh:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        
        lblFromDate.text = dateFormatter.string(from: jsonStartDate!)
        lblToDate.text = dateFormatter.string(from: jsonEndDate!)
        lblTime.text = startTime + " AM - " + endTime + " PM"
        //        lblSelectedTime.text = formatter.string(from: formatter.date(from: startTime)!) + " - " + formatter.string(from: formatter.date(from: endTime)!)
        
        dateTimeCurvedView.isHidden = false
        selectDuratnCurvedView.isHidden = true
        customDateTimeStackView.isHidden = true
        addLocationCurvedView.isHidden = false
        locationCurvedView.isHidden = true
        selectMIDCurvedView.isHidden = true
        MIDCountCurvedView.isHidden = true
        paymentCurvedView.isHidden = true
    }
    
    
    
    @IBOutlet weak var contactlessCreditView: UIView!
    @IBOutlet weak var ecommerceCreditView: UIView!
    @IBOutlet weak var faceToFaceCreditView: UIView!
    @IBOutlet weak var contactlessDebitView: UIView!
    @IBOutlet weak var ecommerceDebitView: UIView!
    @IBOutlet weak var faceToFaceDebitView: UIView!
    
    @IBOutlet weak var ivFaceToFaceDebit: UIImageView!
    
    @IBOutlet weak var ivContactlessCredit: UIImageView!
    @IBOutlet weak var ivEcommerceCredit: UIImageView!
    @IBOutlet weak var ivFacetoFaceCredit: UIImageView!
    @IBOutlet weak var ivContactlessDebit: UIImageView!
    @IBOutlet weak var ivEcommerceDebit: UIImageView!
    @IBOutlet weak var ivTijaratiPayCredit: UIImageView!
    @IBOutlet weak var ivTijaratiPayDebit: UIImageView!
    
    
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
    
    @IBAction func generateReport(_ sender: Any) {
        //        merchantNumber?.append("12345678")
        //        merchantNum = AppConstants.merchantNumber.map { String($0) }
        
        if jsonEndDate != nil && jsonStartDate != nil {
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en")
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let startDate = dateFormatter.string(from:jsonStartDate!)
            let endDate = dateFormatter.string(from: jsonEndDate!)
            let controller = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ReportsPopupViewController") as? ReportsPopupViewController)!
            controller.popupType = 2
            
            //            controller.endTime = endTime
            //            controller.startTime = startTime
            
            //            controller.endTime = self.convertDateToSpecificFormat(date: endTime, currentFormat: "hh:mm:ss", desiredFormat: "HH:mm:ss")
            //            controller.startTime = self.convertDateToSpecificFormat(date: startTime, currentFormat: "hh:mm:ss", desiredFormat: "HH:mm:ss")
            
            //lblSelectedTime.text =  "\(startTime) \(statTimeAMPM) " + "To" + " \(endTime) \(endTimeAMPM)"
            
            //            controller.endTime = self.convertDateToSpecificFormat(date: "\(endTime) \(endAMPM)" , currentFormat: "hh:mm:ss a", desiredFormat: "HH:mm:ss")
            //            controller.startTime = self.convertDateToSpecificFormat(date: "\(startTime) \(startAMPM) ", currentFormat: "hh:mm:ss a", desiredFormat: "HH:mm:ss")
            
            controller.endTime = self.convertDateToSpecificFormat(date: "\(endTime) \(endAMPM)" , currentFormat: "hh:mm a", desiredFormat: "HH:mm:ss")
            controller.startTime = self.convertDateToSpecificFormat(date: "\(startTime) \(startAMPM) ", currentFormat: "hh:mm a", desiredFormat: "HH:mm:ss")
            
            
            controller.jsonStartDate = startDate
            controller.jsonEndDate = endDate
            
            var merchantNum : [String] = []
            
            if self.merchantNumber.count > 0 {
                
                merchantNum = self.merchantNumber.map { String($0) }
                controller.isFilterSelected = true
                
            } else {
                
                controller.isFilterSelected = false
                
                let heirarchyArr : [Hierarchy] = (AppConstants.locationFilterData?.filterData[0].hierarchy)!
                
                var merchantNumbers : [Int] = []
                
                for i in 0..<heirarchyArr.count{
                    for j in 0..<heirarchyArr[i].brandNameList.count{
                        for k in 0..<heirarchyArr[i].brandNameList[j].locationNameList.count{
                            for l in 0..<heirarchyArr[i].brandNameList[j].locationNameList[k].merchantNumber.count
                            {
                                let m : Int = Int(heirarchyArr[i].brandNameList[j].locationNameList[k].merchantNumber[l].mid)!
                                merchantNumbers.append(m)
                            }
                        }
                    }
                }
                merchantNum = merchantNumbers.map { String($0) }
                
            }
            
            controller.merchantNumber = merchantNum
            //            let paymentParam = ["debit" : debitArray ,
            //                                "credit" : creditArray]
            //            paymentType = paymentParam
            
            if isTransactionTypeSelection == true {
                
                if debitArray.count > 0 && creditArray.count > 0 {
                    let paymentParam = ["debit" : debitArray ,
                                        "credit" : creditArray]
                    paymentType = paymentParam
                    
                } else if debitArray.count > 0 {
                    
                    let paymentParam = ["debit" : debitArray]
                    paymentType = paymentParam
                    
                } else if creditArray.count > 0 {
                    
                    let paymentParam = ["credit" : creditArray]
                    paymentType = paymentParam
                    
                }
                
            } else {
                
                let paymentParam = ["debit" : debitArray ,
                                    "credit" : creditArray]
                paymentType = paymentParam
            }
            
            
            controller.paymentType = paymentType
            controller.transactionType = transactionTypes
            controller.servicePreference = 3
            
            if reportType == 0 {
                
                controller.serviceName = RequestItemsType.getTransactionReports
                controller.pdfName = "Transaction Report"
                
            } else if reportType == 1 {
                
                controller.serviceName = RequestItemsType.getSettlementReports
                controller.pdfName = "Settlement Report"
                
            } else {
                
                controller.serviceName = RequestItemsType.getCreditToBankReports
                controller.pdfName = "Credit To Bank Report"
            }
            
            if isTransactionTypeSelection == true {
                
                if reportType == 0 {
                    
                    if debitArray.count <= 0 && creditArray.count <= 0 {
                        showAlertWith(message: AlertMessage(title: "Reports".localiz(), body: "Please select payment types".localiz()))
                    } else if transactionTypes.count <= 0 {
                        showAlertWith(message: AlertMessage(title: "Reports".localiz(), body: "Please select transaction type".localiz()))
                    } else {
                        presentAsStork(controller, height: 400, cornerRadius: 8.0, showIndicator: false, showCloseButton: false)
                    }
                    
                } else if reportType == 1 {
                    presentAsStork(controller, height: 400, cornerRadius: 8.0, showIndicator: false, showCloseButton: false)
                } else {
                    presentAsStork(controller, height: 400, cornerRadius: 8.0, showIndicator: false, showCloseButton: false)
                }
                
            } else {
                
                presentAsStork(controller, height: 400, cornerRadius: 8.0, showIndicator: false, showCloseButton: false)
                
            }
            
            
            //            presentAsStork(controller, height: 400, cornerRadius: 8.0, showIndicator: false, showCloseButton: false)
            
        }else{
            showAlertWith(message: AlertMessage(title: "Reports".localiz(), body: "Please select at least one duration".localiz()))
        }
        
    }
    
    func selectRect(view:GradientLayer,lbl:UILabel){
        view.color1 = UIColor(displayP3Red: 0/255.0, green: 136/255.0, blue: 208/255.0, alpha: 1)
        view.color2 = UIColor(displayP3Red: 0/255.0, green: 115/255.0, blue: 185/255.0, alpha: 1)
        view.color3 = UIColor(displayP3Red: 0/255.0, green: 94/255.0, blue: 161/255.0, alpha: 1)
        view.layer.borderWidth = 0
        lbl.textColor = UIColor.white
    }
    
    var debitArray : [String] = []
    var creditArray : [String] = []
    
    @objc func creditFaceToFace(sender: UITapGestureRecognizer){
        btnSelectAll.setImage(UIImage.init(named: "ic_checkbox_disabled"), for: .normal)
        selectTransactionType(view: creditCardCurvedView, lblName: lblCredit)
        ivCredit.image = UIImage(named: "ic_card")
        if ivFacetoFaceCredit.tag == 1 {
            
            
            deselectPaymentTypes(checkboxImg: ivFacetoFaceCredit, lblPaymentName: lblFaceToFaceCredit)
        }else{
            
            selectPaymentTypes(checkboxImg: ivFacetoFaceCredit, lblPaymentName: lblFaceToFaceCredit)
        }
        if creditArray.count > 0
        {
            if creditArray.contains("Face To Face")
            {
                
                creditArray.remove(at: creditArray.index(of: "Face To Face")!)
                
            }else
            {
                creditArray.append("Face To Face")
            }
            
        }else{
            
            creditArray.append("Face To Face")
        }
        
        self.paymentTypeCount.text = "\(creditArray.count + debitArray.count)"
    }
    
    @IBOutlet weak var btnSelectAll: UIButton!
    
    func selectPaymentTypes(checkboxImg:UIImageView, lblPaymentName : UILabel){
        
        checkboxImg.image = UIImage(named: "ic_checkbox_enabled")
        lblPaymentName.textColor = UIColor.black
        checkboxImg.tag = 1
        
    }
    
    func deselectPaymentTypes(checkboxImg:UIImageView, lblPaymentName : UILabel){
        
        
        checkboxImg.image = UIImage(named: "ic_checkbox_disabled")
        lblPaymentName.textColor = UIColor.BurganColor.brandGray.medium
        checkboxImg.tag = 0
    }
    
    //MARK:-PAYMENT MODE
    @IBOutlet weak var lblFaceToFaceCredit: UILabel!
    @IBOutlet weak var lblFaceToFaceDebit: UILabel!
    @IBOutlet weak var lblEcommerceCredit: UILabel!
    @IBOutlet weak var lblEcommerceDebit: UILabel!
    @IBOutlet weak var lblContactLessDebut: UILabel!
    @IBOutlet weak var lblContactLessCredit: UILabel!
    @IBOutlet weak var lblTijaratiPayDebit: UILabel!
    @IBOutlet weak var lblTijaratiPayCredit: UILabel!
    
    
    @objc func clearPaymentSelection(sender: UITapGestureRecognizer) {
        
        debitArray.removeAll()
        creditArray.removeAll()
        btnSelectAll.setImage(UIImage.init(named: "ic_checkbox_disabled"), for: .normal)
        
        deselectTransactionType(view: creditCardCurvedView, lblName: lblCredit)
        ivCredit.image = UIImage(named: "ic_cards_grey")
        
        deselectTransactionType(view: debitCardCurvedView, lblName: lblDebit)
        ivDebit.image = UIImage(named: "ic_cards_grey")
        
        deselectPaymentTypes(checkboxImg: ivFaceToFaceDebit, lblPaymentName: lblFaceToFaceDebit)
        deselectPaymentTypes(checkboxImg: ivEcommerceDebit, lblPaymentName: lblEcommerceDebit)
        deselectPaymentTypes(checkboxImg: ivContactlessDebit, lblPaymentName: lblContactLessDebut)
        deselectPaymentTypes(checkboxImg: ivFacetoFaceCredit, lblPaymentName: lblFaceToFaceCredit)
        deselectPaymentTypes(checkboxImg: ivEcommerceCredit, lblPaymentName: lblEcommerceCredit)
        deselectPaymentTypes(checkboxImg: ivContactlessCredit, lblPaymentName: lblContactLessCredit)
        
        deselectPaymentTypes(checkboxImg: ivTijaratiPayDebit, lblPaymentName: lblTijaratiPayDebit)
        
        deselectPaymentTypes(checkboxImg: ivTijaratiPayCredit, lblPaymentName: lblTijaratiPayCredit)
        
        self.paymentTypeCount.text = "\(creditArray.count + debitArray.count)"
    }
    
    @IBAction func SelectAllPayments(_ sender: Any) {
        debitArray.removeAll()
        creditArray.removeAll()
        btnSelectAll.setImage(UIImage.init(named: "ic_checkbox_enabled"), for: .normal)
        
        selectTransactionType(view: creditCardCurvedView, lblName: lblCredit)
        ivCredit.image = UIImage(named: "ic_card")
        
        selectTransactionType(view: debitCardCurvedView, lblName: lblDebit)
        ivDebit.image = UIImage(named: "ic_card")
        
        selectPaymentTypes(checkboxImg: ivFaceToFaceDebit, lblPaymentName: lblFaceToFaceDebit)
        debitArray.append("Face To Face")
        
        selectPaymentTypes(checkboxImg: ivEcommerceDebit, lblPaymentName: lblEcommerceDebit)
        debitArray.append("Ecommerce")
        
        selectPaymentTypes(checkboxImg: ivContactlessDebit, lblPaymentName: lblContactLessDebut)
        debitArray.append("Contactless")
        
        selectPaymentTypes(checkboxImg: ivTijaratiPayDebit, lblPaymentName: lblTijaratiPayDebit)
        debitArray.append("Tijarati Pay")
        
        selectPaymentTypes(checkboxImg: ivFacetoFaceCredit, lblPaymentName: lblFaceToFaceCredit)
        creditArray.append("Face To Face")
        
        selectPaymentTypes(checkboxImg: ivEcommerceCredit, lblPaymentName: lblEcommerceCredit)
        creditArray.append("Ecommerce")
        
        selectPaymentTypes(checkboxImg: ivContactlessCredit, lblPaymentName: lblContactLessCredit)
        creditArray.append("Contactless")
        
        selectPaymentTypes(checkboxImg: ivTijaratiPayCredit, lblPaymentName: lblTijaratiPayCredit)
        creditArray.append("Tijarati Pay")
        
        
        self.paymentTypeCount.text = "\(creditArray.count + debitArray.count)"
    }
    
    @objc func selectAllPayments(sender: UITapGestureRecognizer){
        
        debitArray.removeAll()
        creditArray.removeAll()
        btnSelectAll.setImage(UIImage.init(named: "ic_checkbox_enabled"), for: .normal)
        
        selectTransactionType(view: creditCardCurvedView, lblName: lblCredit)
        ivCredit.image = UIImage(named: "ic_card")
        
        selectTransactionType(view: debitCardCurvedView, lblName: lblDebit)
        ivDebit.image = UIImage(named: "ic_card")
        
        selectPaymentTypes(checkboxImg: ivFaceToFaceDebit, lblPaymentName: lblFaceToFaceDebit)
        debitArray.append("Face To Face")
        
        selectPaymentTypes(checkboxImg: ivEcommerceDebit, lblPaymentName: lblEcommerceDebit)
        debitArray.append("Ecommerce")
        
        selectPaymentTypes(checkboxImg: ivContactlessDebit, lblPaymentName: lblContactLessDebut)
        debitArray.append("Contactless")
        
        selectPaymentTypes(checkboxImg: ivTijaratiPayDebit, lblPaymentName: lblTijaratiPayDebit)
        debitArray.append("Tijarati Pay")
        
        selectPaymentTypes(checkboxImg: ivFacetoFaceCredit, lblPaymentName: lblFaceToFaceCredit)
        creditArray.append("Face To Face")
        
        selectPaymentTypes(checkboxImg: ivEcommerceCredit, lblPaymentName: lblEcommerceCredit)
        creditArray.append("Ecommerce")
        
        selectPaymentTypes(checkboxImg: ivContactlessCredit, lblPaymentName: lblContactLessCredit)
        creditArray.append("Contactless")
        
        selectPaymentTypes(checkboxImg: ivTijaratiPayCredit, lblPaymentName: lblTijaratiPayCredit)
        creditArray.append("Tijarati Pay")
        
        self.paymentTypeCount.text = "\(creditArray.count + debitArray.count)"
    }
    
    
    
    @objc func debitFaceToFace(sender: UITapGestureRecognizer){
        btnSelectAll.setImage(UIImage.init(named: "ic_checkbox_disabled"), for: .normal)
        selectTransactionType(view: debitCardCurvedView, lblName: lblDebit)
        ivDebit.image = UIImage(named: "ic_card")
        if ivFaceToFaceDebit.tag == 1 {
            
            deselectPaymentTypes(checkboxImg: ivFaceToFaceDebit, lblPaymentName: lblFaceToFaceDebit)
            
            
        }else{
            selectPaymentTypes(checkboxImg: ivFaceToFaceDebit, lblPaymentName: lblFaceToFaceDebit)
        }
        if debitArray.count > 0
        {
            if debitArray.contains("Face To Face")
            {
                
                debitArray.remove(at: debitArray.index(of: "Face To Face")!)
                
            }else
            {
                debitArray.append("Face To Face")
            }
            
        }else{
            
            debitArray.append("Face To Face")
        }
        
        self.paymentTypeCount.text = "\(creditArray.count + debitArray.count)"
        
    }
    
    @objc func creditEcommerce(sender: UITapGestureRecognizer){
        btnSelectAll.setImage(UIImage.init(named: "ic_checkbox_disabled"), for: .normal)
        selectTransactionType(view: creditCardCurvedView, lblName: lblCredit)
        ivCredit.image = UIImage(named: "ic_card")
        if ivEcommerceCredit.tag == 1 {
            deselectPaymentTypes(checkboxImg: ivEcommerceCredit, lblPaymentName: lblEcommerceCredit)
            
            
        }else{
            selectPaymentTypes(checkboxImg: ivEcommerceCredit, lblPaymentName: lblEcommerceCredit)
        }
        if creditArray.count > 0
        {
            if creditArray.contains("Ecommerce")
            {
                
                creditArray.remove(at: creditArray.index(of: "Ecommerce")!)
                
            }else
            {
                creditArray.append("Ecommerce")
            }
            
        }else{
            
            creditArray.append("Ecommerce")
        }
        
        self.paymentTypeCount.text = "\(creditArray.count + debitArray.count)"
        
    }
    
    @objc func debitEcommerce(sender: UITapGestureRecognizer){
        
        btnSelectAll.setImage(UIImage.init(named: "ic_checkbox_disabled"), for: .normal)
        selectTransactionType(view: debitCardCurvedView, lblName: lblDebit)
        ivDebit.image = UIImage(named: "ic_card")
        if ivEcommerceDebit.tag == 1 {
            deselectPaymentTypes(checkboxImg: ivEcommerceDebit, lblPaymentName: lblEcommerceDebit)
            
            
        }else{
            selectPaymentTypes(checkboxImg: ivEcommerceDebit, lblPaymentName: lblEcommerceDebit)
        }
        if debitArray.count > 0
        {
            if debitArray.contains("Ecommerce")
            {
                
                debitArray.remove(at: debitArray.index(of: "Ecommerce")!)
                
            }else
            {
                debitArray.append("Ecommerce")
            }
            
        }else{
            
            debitArray.append("Ecommerce")
        }
        self.paymentTypeCount.text = "\(creditArray.count + debitArray.count)"
    }
    
    @objc func creditContactless(sender: UITapGestureRecognizer){
        btnSelectAll.setImage(UIImage.init(named: "ic_checkbox_disabled"), for: .normal)
        selectTransactionType(view: creditCardCurvedView, lblName: lblCredit)
        
        
        if ivContactlessCredit.tag == 1 {
            deselectPaymentTypes(checkboxImg: ivContactlessCredit, lblPaymentName: lblContactLessCredit)
            
            
        }else{
            selectPaymentTypes(checkboxImg: ivContactlessCredit, lblPaymentName: lblContactLessCredit)
        }
        if creditArray.count > 0
        {
            if creditArray.contains("Contactless")
            {
                
                creditArray.remove(at: creditArray.index(of: "Contactless")!)
                
            }else
            {
                creditArray.append("Contactless")
            }
            
        }else{
            
            creditArray.append("Contactless")
        }
        
        self.paymentTypeCount.text = "\(creditArray.count + debitArray.count)"
        
    }
    
    @objc func debitContactless(sender: UITapGestureRecognizer){
        btnSelectAll.setImage(UIImage.init(named: "ic_checkbox_disabled"), for: .normal)
        selectTransactionType(view: debitCardCurvedView, lblName: lblDebit)
        ivDebit.image = UIImage(named: "ic_card")
        if ivContactlessDebit.tag == 1 {
            deselectPaymentTypes(checkboxImg: ivContactlessDebit, lblPaymentName: lblContactLessDebut)
            
            
        }else{
            selectPaymentTypes(checkboxImg: ivContactlessDebit, lblPaymentName: lblContactLessDebut)
        }
        if debitArray.count > 0
        {
            if debitArray.contains("Contactless")
            {
                
                debitArray.remove(at: debitArray.index(of: "Contactless")!)
                
            }else
            {
                debitArray.append("Contactless")
            }
            
        }else{
            
            debitArray.append("Contactless")
        }
        self.paymentTypeCount.text = "\(creditArray.count + debitArray.count)"
    }
    
    @objc func debitTijaratiPay(sender: UITapGestureRecognizer){
        btnSelectAll.setImage(UIImage.init(named: "ic_checkbox_disabled"), for: .normal)
        selectTransactionType(view: debitCardCurvedView, lblName: lblDebit)
        ivDebit.image = UIImage(named: "ic_card")
        if ivTijaratiPayDebit.tag == 1 {
            deselectPaymentTypes(checkboxImg: ivTijaratiPayDebit, lblPaymentName: lblTijaratiPayDebit)
            
            
        }else{
            selectPaymentTypes(checkboxImg: ivTijaratiPayDebit, lblPaymentName: lblTijaratiPayDebit)
        }
        if debitArray.count > 0
        {
            if debitArray.contains("Tijarati Pay")
            {
                
                debitArray.remove(at: debitArray.index(of: "Tijarati Pay")!)
                
            }else
            {
                debitArray.append("Tijarati Pay")
            }
            
        }else{
            
            debitArray.append("Tijarati Pay")
        }
        self.paymentTypeCount.text = "\(creditArray.count + debitArray.count)"
    }
    
    @objc func creditTijaratiPay(sender: UITapGestureRecognizer){
        btnSelectAll.setImage(UIImage.init(named: "ic_checkbox_disabled"), for: .normal)
        selectTransactionType(view: creditCardCurvedView, lblName: lblCredit)
        ivCredit.image = UIImage(named: "ic_card")
        if ivTijaratiPayCredit.tag == 1 {
            deselectPaymentTypes(checkboxImg: ivTijaratiPayCredit, lblPaymentName: lblTijaratiPayCredit)
            
            
        }else{
            selectPaymentTypes(checkboxImg: ivTijaratiPayCredit, lblPaymentName: lblTijaratiPayCredit)
        }
        if creditArray.count > 0
        {
            if creditArray.contains("Tijarati Pay")
            {
                
                creditArray.remove(at: creditArray.index(of: "Tijarati Pay")!)
                
            }else
            {
                creditArray.append("Tijarati Pay")
            }
            
        }else{
            
            creditArray.append("Tijarati Pay")
        }
        self.paymentTypeCount.text = "\(creditArray.count + debitArray.count)"
    }
    
    func deSelectRect(view:GradientLayer,lbl:UILabel){
        view.color1 = UIColor.white
        view.color2 = UIColor.white
        view.color3 = UIColor.white
        view.layer.borderWidth = 1
        lbl.textColor = UIColor(displayP3Red: 122.0/255.0, green: 136.0/255.0, blue: 144.0/255.0, alpha: 1)
    }
    
    func curvedviewShadow(view:UIView){
        
        view.layer.cornerRadius = 8
        view.layer.shadowOpacity = 0.35
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowRadius = 3.0
        view.layer.shadowColor = UIColor.BurganColor.brandGray.lgiht.cgColor
        view.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner,.layerMaxXMinYCorner]
    }
    func curvedview(view:UIView){
        
        view.layer.cornerRadius = 8
        view.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner,.layerMaxXMinYCorner]
    }
    func curvedBorderView(view:UIView){
        
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor(red: 120.0/255.0, green: 144.0/255.0, blue: 156.0/255.0, alpha: 1.0).cgColor
        view.layer.borderWidth = 1
        view.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner,.layerMaxXMinYCorner]
    }
    func halfCurvedview(view:UIView){
        
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
    }
    
}
extension UIScrollView {
    func scrollToBottom(animated: Bool) {
        if self.contentSize.height < self.bounds.size.height { return }
        let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
        self.setContentOffset(bottomOffset, animated: animated)
    }
}

extension Date {
    
    func startOfMonthDate() -> Date? {
        let comp: DateComponents = Calendar.current.dateComponents([.year, .month, .hour], from: Calendar.current.startOfDay(for: self))
        return Calendar.current.date(from: comp)!
    }
    
    
    
    func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.next,
                   weekday,
                   considerToday: considerToday)
    }
    
    func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.previous,
                   weekday,
                   considerToday: considerToday)
    }
    
    func get(_ direction: SearchDirection,
             _ weekDay: Weekday,
             considerToday consider: Bool = false) -> Date {
        
        let dayName = weekDay.rawValue
        
        let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }
        
        assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
        
        let searchWeekdayIndex = weekdaysName.firstIndex(of: dayName)! + 1
        
        let calendar = Calendar(identifier: .gregorian)
        
        if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
            return self
        }
        
        var nextDateComponent = calendar.dateComponents([.hour, .minute, .second], from: self)
        nextDateComponent.weekday = searchWeekdayIndex
        
        let date = calendar.nextDate(after: self,
                                     matching: nextDateComponent,
                                     matchingPolicy: .nextTime,
                                     direction: direction.calendarSearchDirection)
        
        return date!
    }
    
}

// MARK: Helper methods
extension Date {
    func getWeekDaysInEnglish() -> [String] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar.weekdaySymbols
    }
    
    enum Weekday: String {
        case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    }
    
    enum SearchDirection {
        case next
        case previous
        
        var calendarSearchDirection: Calendar.SearchDirection {
            switch self {
            case .next:
                return .forward
            case .previous:
                return .backward
            }
        }
    }
}

extension Calendar {
    static let iso8601 = Calendar(identifier: .iso8601)
}

extension Date {
    var currentWeekMonday: Date {
        return Calendar.iso8601.date(from: Calendar.iso8601.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
    }
}
