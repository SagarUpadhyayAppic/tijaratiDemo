//
//  TransactionsViewController.swift
//  Burgan
//
//  Created by Malti Maurya on 20/03/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit
import FSCalendar

class TransactionsViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance, applyFilterDelegate, calendarDelegate, UIGestureRecognizerDelegate {
    
    func applyFilter(heirarchy: selectedFilterData, isCif: Bool) {
        /*
         AppConstants.isCif = isCif
         btnAppplyFilter.setTitle(AppConstants.selectedFilter!.companyName + "(" + String(AppConstants.selectedFilter!.selectedMerchants.count) + ")  ", for: .normal)
         print("merchantno : " , AppConstants.merchantNumber)
         if isCif
         {
         merchantTransactionReq()
         }else
         {
         corporateTransactionReq()
         }
         */
        
        AppConstants.isCif = isCif
        btnAppplyFilter.setTitle(AppConstants.selectedFilter!.companyName + "(" + String(AppConstants.selectedFilter!.selectedMerchants.count) + ")  ", for: .normal)
        print("merchantno : " , AppConstants.merchantNumber)
        AppConstants.cifCompanyName = AppConstants.selectedFilter!.companyName
        AppConstants.UserData.companyCIF = AppConstants.selectedFilter!.cif
        //mmmmmmalti
        //        if AppConstants.UserData.merchantRole == "Admin"{
        //            if isCif {
        //                merchantTransactionReq()
        //            } else {
        //                corporateTransactionReq()
        //            }
        //        } else {
        //            merchantTransactionReq()
        //        }
        
        if AppConstants.UserData.merchantRole == "Admin" {
            if AppConstants.isCif {
                corporateTransactionReq()
            } else {
                merchantTransactionReq()
            }
        } else {
            merchantTransactionReq()
        }
        
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
        
        /*
         let merchant = AppConstants.merchantNumber.map { String($0) }
         
         let param : [String : Any] = ["type":"cif",
         "cif" : AppConstants.selectedFilter!.cif,
         "merchantNum" : merchant,
         "deviceId" : AppConstants.UserData.deviceID,
         "startDate":  AppConstants.jsonStartDate, "endDate":AppConstants.jsonEndDate]
         MBProgressHUD.showAdded(to: self.view, animated: true)
         self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.getTransactionSummary)
         self.bindUI()
         */
        
        if AppConstants.UserData.merchantRole == "Admin" {
            if AppConstants.isCif {
                corporateTransactionReq()
            } else {
                merchantTransactionReq()
            }
        } else {
            merchantTransactionReq()
        }
        
    }
    
    func selectTimeRange(startTimeValue: String, endTimeValue: String) {
        
    }
    func selectTimeRange(startTimeValue : String , endTimeValue : String, statTimeAMPM : String, endTimeAMPM : String){
        
    }
    
    @IBOutlet weak var lblmpgs: UILabel!
    
    @IBOutlet weak var lbltotalTransactions: UILabel!
    
    @IBOutlet weak var btnAppplyFilter: UIButton!
    @IBOutlet weak var curvedViewTransaction: UIView!
    @IBOutlet weak var creditDetailViewHeight: NSLayoutConstraint!
    @IBOutlet weak var debitDetailViewHeight: NSLayoutConstraint!
    @IBOutlet weak var creditDetailView: UIView!
    @IBOutlet weak var debitDetailView: UIView!
    @IBOutlet weak var lblDebitTransaction: UILabel!
    @IBOutlet weak var lblCreditTransaction: UILabel!
    @IBOutlet weak var lblDebitInternatnlTransactn: UILabel!
    @IBOutlet weak var lblDebitDomesticTRansactn: UILabel!
    @IBOutlet weak var lblDebitInternationlAmt: UILabel!
    @IBOutlet weak var lblDebitDomesticAmt: UILabel!
    @IBOutlet weak var debitProgress: UIProgressView!
    @IBOutlet weak var creditProgressBar: UIProgressView!
    @IBOutlet weak var lblcreditAmt: UILabel!
    @IBOutlet weak var lblCreditInternationlAmt: UILabel!
    @IBOutlet weak var lblCreditDomesticAmt: UILabel!
    @IBOutlet weak var lblDebitAmount: UILabel!
    @IBOutlet weak var lblTRansactnAmount: UILabel!
    @IBOutlet weak var lblCreditDomesticTransactn: UILabel!
    @IBOutlet weak var lblCreditInternationalTransaction: UILabel!
    @IBOutlet weak var btnCreditDetail: UIButton!
    @IBOutlet weak var btnDebitDetail: UIButton!
    @IBOutlet weak var lblSettledAmt: UILabel!
    @IBOutlet weak var curvedTRansactionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var curvedSettledAmt: UIView!
    //@IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var btnSelectMonth: UIButton!
    @IBOutlet weak var lblRefundCount: UILabel!
    @IBOutlet weak var lblFailedCount: UILabel!
    @IBOutlet weak var lblVoidCount: UILabel!
    @IBOutlet weak var lblExpiredCount: UILabel!
    @IBOutlet weak var lblInProgressCount: UILabel!
    @IBOutlet weak var lblDeclinedCount: UILabel!
    
    @IBOutlet weak var calendrviewHeight: NSLayoutConstraint!
    
    ///TOTAL SUCCESSFULL TRANSACTION REF
    @IBOutlet weak var totalSuccessfullTransactionViewRef: UIView!
    
    //DATE DROP DOWN VIEW
    @IBOutlet weak var dateViewRef: UIView!
    
    //SEGMENT CARD TYPES & PAYMENT CHANNELS
    @IBOutlet var cardTypesBtnRef: UIButton!
    @IBOutlet var paymentChannelsBtnRef: UIButton!
    @IBOutlet var paymentChannelViewRef: UIView!
    @IBOutlet var cardTypeViewHeightRef: NSLayoutConstraint!
    @IBOutlet var paymentChannelViewHeightRef: NSLayoutConstraint!
    
    @IBOutlet var posDetailViewRef: UIView!
    @IBOutlet var posDetailViewHeightRef: NSLayoutConstraint!
    var showPosDetailView = false
    @IBOutlet var posDetailViewBtnRef: UIButton!
    @IBOutlet var btnGoToPOSTransactionDetail: UIButton!
    
    @IBOutlet var posPageControlRef: UIPageControl!
    @IBOutlet var posDetailCvRef: UICollectionView!
    
    @IBOutlet var ecommDetailViewRef: UIView!
    @IBOutlet var ecommDetailViewHeightRef: NSLayoutConstraint!
    var showEcommDetailView = false
    @IBOutlet var ecommDetailViewBtnRef: UIButton!
    @IBOutlet var btnGoToEcommTransactionDetail: UIButton!
    
    @IBOutlet var ecommPageControlRef: UIPageControl!
    @IBOutlet var ecommDetailCvRef: UICollectionView!
    
    @IBOutlet weak var lblPosTitle: UILabel!
    @IBOutlet weak var lblEcommTitle: UILabel!
    @IBOutlet weak var lblTijaratiTitle: UILabel!
    
    @IBOutlet var tijaratiDetailViewRef: UIView!
    @IBOutlet var tijaratiDetailViewHeightRef: NSLayoutConstraint!
    var showTijaratiDetailView = false
    @IBOutlet var tijaratiDetailViewBtnRef: UIButton!
    @IBOutlet var btnGoToTijaratiPayTransactionDetail: UIButton!
    
    @IBOutlet var tijaratiPageControlRef: UIPageControl!
    @IBOutlet var tijaratiDetailCvRef: UICollectionView!
    
    
    @IBOutlet var transactionStatsViewRef: UIView!
    @IBOutlet var transactionStats1ViewRef: UIView!
    @IBOutlet var transactionStatsInsideViewRef: UIView!
    
    
    @IBOutlet weak var lblPosAmount: UILabel!
    @IBOutlet weak var lblPosTransaction: UILabel!
    
    @IBOutlet weak var lblEcommAmount: UILabel!
    @IBOutlet weak var lblEcommTransaction: UILabel!
    
    @IBOutlet weak var lblTijaratiAmount: UILabel!
    @IBOutlet weak var lblTijaratiTransaction: UILabel!
    
    
    @IBOutlet weak var lblCreditInter: UILabel!
    @IBOutlet weak var lbldebitTitle: UILabel!
    @IBOutlet weak var lblCreditDomestic: UILabel!
    @IBOutlet weak var lblCreditTitle: UILabel!
    @IBOutlet weak var lbltotalTransactionTitle: UILabel!
    @IBOutlet weak var lblDebitInterTitle: UILabel!
    @IBOutlet weak var lblDebiotDomesticTitle: UILabel!
    
    @IBOutlet weak var btnGoToDebitTransactionDetail: UIButton!
    @IBOutlet weak var btnGoToCreditTransactionDetail: UIButton!
    
    @IBOutlet weak var lblFailedAmt: UILabel!
    @IBOutlet weak var lblRefundAmt: UILabel!
    @IBOutlet weak var lblVoidAmt: UILabel!
    @IBOutlet weak var lblExpiredAmt: UILabel!
    @IBOutlet weak var lblInprogressAmt: UILabel!
    @IBOutlet weak var lblDeclinedAmt: UILabel!
    
    @IBOutlet weak var transactionScrollView: UIScrollView!
    
    @IBOutlet weak var lblMyTitle: UILabel!
    
    @IBOutlet weak var lblSettlmntAmt: UILabel!

    var refreshControl: UIRefreshControl!
    private var currentPage: Date?
    
    private lazy var today: Date = {
        return Date()
    }()
    
    
    var transactionSummaryApi = [transactionsResp]()
    
    var showCardTypes = true
    var showPaymentChannels = false
    
    var voidCnt : Int = 0
    var failedCnt : Int = 0
    var refundCnt : Int = 0
    var inProgressCnt : Int = 0
    var expiredCnt : Int = 0
    var declinedCnt : Int = 0
    
    
    var monthArr :NSDictionary = [1:"Jan",2:"Feb",3:"Mar",4:"Apr",5:"May",6:"Jun",7:"Jul",8:"Aug",9:"Sep",10:"Oct",11:"Nov",12:"Dec"]
    
    
    var showDebitDetail = false
    var showCreditDetail = false
    var viewModel : RegistrationViewControllerViewModelProtocol?
    
    @IBAction func goToCreditTransactionDetail(_ sender: Any) {
        
        let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CardTransactionListViewController") as? CardTransactionListViewController
        controller?.cardType = "credit"
        controller?.startDate =  AppConstants.jsonStartDate
        controller?.endDate = AppConstants.jsonEndDate
        controller?.txnStatus = "Success"
        controller?.titleStr = "Credit Card Transaction List".localiz()
        self.navigationController?.pushViewController(controller!, animated: false)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //            let cell = calendar.cell(for: date, at: monthPosition)
        AppConstants.jsonStartDate = date.stringFromFormat("yyyy-MM-dd")
        AppConstants.jsonEndDate = date.stringFromFormat("yyyy-MM-dd")
        let selectedDateRange = date.monthh.prefix(3) + " - " + String(date.day) + ", " + date.yearr
        btnSelectMonth.setTitle(selectedDateRange, for: .normal)
        //                         corporateTransactionReq()
        // cell?.contentView.addBottomBorderWithColor(color: UIColor.BurganColor.brandBlue.medium, width: 3)
        
        if AppConstants.UserData.merchantRole == "Admin"{
            if AppConstants.isCif {
                corporateTransactionReq()
            } else {
                merchantTransactionReq()
            }
        } else {
            merchantTransactionReq()
        }
        
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //             let cell = calendar.cell(for: date, at: monthPosition)
        // cell?.contentView.removeLayer(layerName: "bottom")
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Calendar.current.date(byAdding: .month, value: -6, to: Date())!
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    
    @IBAction func goToDebitTransactionDetail(_ sender: Any) {
        
        let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CardTransactionListViewController") as? CardTransactionListViewController
        controller?.cardType = "debit"
        controller?.startDate =  AppConstants.jsonStartDate
        controller?.endDate = AppConstants.jsonEndDate
        controller?.txnStatus = "Success"
        controller?.titleStr = "Debit Card Transaction List".localiz() //"Debit Card Transaction List"
        self.navigationController?.pushViewController(controller!, animated: false)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.networkStatusChanged(_:)), name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        definesPresentationContext = true
        
        
        self.loopThroughSubViewAndMirrorImage(subviews: self.view.subviews)
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        self.transactionScrollView.addSubview(refreshControl)
        
        createTapGuesture()
        
        //        arabic()
        //        setup()
        
        paymentChannelViewRef.isHidden = true
        curvedViewTransaction.isHidden = false

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        
        setup()
        arabic()
        
        lblMyTitle.text = "transactionTitle".localiz()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func createTapGuesture(){
        
        lblVoidCount.isUserInteractionEnabled = true
        lblFailedCount.isUserInteractionEnabled = true
        lblRefundCount.isUserInteractionEnabled = true
        lblDeclinedCount.isUserInteractionEnabled = true
        lblInProgressCount.isUserInteractionEnabled = true
        lblExpiredCount.isUserInteractionEnabled = true
        
        
        let selectVoidTap = UITapGestureRecognizer(target: self, action: #selector(self.HandleVoidTap(_:)))
        lblVoidCount.addGestureRecognizer(selectVoidTap)
        
        let selectFailedTap = UITapGestureRecognizer(target: self, action: #selector(self.HandleFailedTap(_:)))
        lblFailedCount.addGestureRecognizer(selectFailedTap)
        
        let selectRefundTap = UITapGestureRecognizer(target: self, action: #selector(self.HandleRefundTap(_:)))
        lblRefundCount.addGestureRecognizer(selectRefundTap)
        
        let selectDeclinedTap = UITapGestureRecognizer(target: self, action: #selector(self.HandleDeclinedTap(_:)))
        lblDeclinedCount.addGestureRecognizer(selectDeclinedTap)
        
        let selectExpiredTap = UITapGestureRecognizer(target: self, action: #selector(self.HandleExpiredTap(_:)))
        lblExpiredCount.addGestureRecognizer(selectExpiredTap)
        
        let selectInProgressTap = UITapGestureRecognizer(target: self, action: #selector(self.HandleInProgressTap(_:)))
        lblInProgressCount.addGestureRecognizer(selectInProgressTap)
        
    }
    
    @objc func HandleVoidTap(_ sender: UITapGestureRecognizer? = nil) {
        
        if self.voidCnt > 0 {
            
            let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CardTransactionListViewController") as? CardTransactionListViewController
            controller?.cardType = "all"
            controller?.startDate =  AppConstants.jsonStartDate
            controller?.endDate = AppConstants.jsonEndDate
            controller?.txnStatus = "Void"
            controller?.titleStr = "Void".localiz() +  " Transaction List".localiz() //"Void Transaction List"
            self.navigationController?.pushViewController(controller!, animated: false)
        }
        
    }
    
    @objc func HandleFailedTap(_ sender: UITapGestureRecognizer? = nil) {
        
        if self.failedCnt > 0 {
            
            let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CardTransactionListViewController") as? CardTransactionListViewController
            controller?.cardType = "all"
            controller?.startDate =  AppConstants.jsonStartDate
            controller?.endDate = AppConstants.jsonEndDate
            controller?.txnStatus = "Failed"
            controller?.titleStr = "Failed".localiz() +  " Transaction List".localiz() //"Failed Transaction List"
            self.navigationController?.pushViewController(controller!, animated: false)
        }
    }
    
    @objc func HandleRefundTap(_ sender: UITapGestureRecognizer? = nil) {
        
        if self.refundCnt > 0 {
            
            let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CardTransactionListViewController") as? CardTransactionListViewController
            controller?.cardType = "all"
            controller?.startDate =  AppConstants.jsonStartDate
            controller?.endDate = AppConstants.jsonEndDate
            controller?.txnStatus = "Refund"
            controller?.titleStr = "Refunded".localiz() +  " Transaction List".localiz() //"Refund Transaction List"
            self.navigationController?.pushViewController(controller!, animated: false)
        }
        
    }
    
    @objc func HandleDeclinedTap(_ sender: UITapGestureRecognizer? = nil) {
        
        if self.declinedCnt > 0 {
            
            let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CardTransactionListViewController") as? CardTransactionListViewController
            controller?.cardType = "all"
            controller?.startDate =  AppConstants.jsonStartDate
            controller?.endDate = AppConstants.jsonEndDate
            controller?.txnStatus = "LinkDeclined"
            controller?.titleStr = "Declined".localiz() +  " Transaction List".localiz() //"Declined Transaction List"
            self.navigationController?.pushViewController(controller!, animated: false)
        }
        
    }
    
    @objc func HandleExpiredTap(_ sender: UITapGestureRecognizer? = nil) {
        
        if self.expiredCnt > 0 {
            
            let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CardTransactionListViewController") as? CardTransactionListViewController
            controller?.cardType = "all"
            controller?.startDate =  AppConstants.jsonStartDate
            controller?.endDate = AppConstants.jsonEndDate
            controller?.txnStatus = "LinkExpired"
            controller?.titleStr = "Link Expired".localiz() +  " Transaction List".localiz()
            self.navigationController?.pushViewController(controller!, animated: false)
        }
        
    }
    
    @objc func HandleInProgressTap(_ sender: UITapGestureRecognizer? = nil) {
        
        if self.inProgressCnt > 0 {
            
            let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CardTransactionListViewController") as? CardTransactionListViewController
            controller?.cardType = "all"
            controller?.startDate =  AppConstants.jsonStartDate
            controller?.endDate = AppConstants.jsonEndDate
            controller?.txnStatus = "inProgress"
            controller?.titleStr = "In Progress".localiz() +  " Transaction List".localiz()
            self.navigationController?.pushViewController(controller!, animated: false)
        }
        
    }
    
    
    @objc func refresh()
    {
        setup()
        arabic()
        refreshControl.endRefreshing()
    }
    
    func setup(){
        
        lblmpgs.text = "MPGS Transaction"
        
        infoView.layer.cornerRadius = 8
        textLayoutSetup()
        curvedviewShadow(view: curvedViewTransaction)
        curvedviewShadow(view: curvedSettledAmt)
        debitProgress.layer.cornerRadius = 8
        
        creditProgressBar.layer.cornerRadius = 8
        
        ///TOTAL SUCCESSFULL TRANSACTION VIEW
        totalSuccessfullTransactionViewRef.layer.cornerRadius = 10
        
        ///DATE VIEW
        dateViewRef.layer.cornerRadius = 15
        dateViewRef.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        cardTypesBtnRef.layer.cornerRadius = 5
        paymentChannelsBtnRef.layer.cornerRadius = 5
        
        ///CARD TYPE AND PAYMENT CHANNEL VIEW
        
        cardTypesBtnRef.layer.borderWidth = 1
        paymentChannelsBtnRef.layer.borderWidth = 1
        
        cardTypesBtnRef.layer.borderColor = UIColor.init(hexString: "0065A6").cgColor // #colorLiteral(red: 0, green: 0.3960784314, blue: 0.6509803922, alpha: 1)
        paymentChannelsBtnRef.layer.borderColor = UIColor.init(hexString: "0065A6").cgColor // #colorLiteral(red: 0, green: 0.3960784314, blue: 0.6509803922, alpha: 1)
        
        paymentChannelViewHeightRef.constant = 0
        
        curvedviewShadow(view: paymentChannelViewRef)
        
        curvedviewShadow(view: transactionStatsViewRef)
        transactionStats1ViewRef.layer.cornerRadius = 5
        transactionStatsInsideViewRef.layer.cornerRadius = 5
        
        infoView.addTopBorderWithColor(color: UIColor.init(hexString: "BFCEDB"), width: 0.5)
        
        
        calendarSetup()
        currentMonthData()
        debitDetailViewHeight.constant = 0
        creditDetailViewHeight.constant = 0
        debitDetailView.isHidden = true
        creditDetailView.isHidden = true
        initialiseData()
        CreditViewController.selectedFilter(button: btnAppplyFilter)
        self.viewModel = RegistrationViewControllerViewModel()
        
        
        if AppConstants.UserData.merchantRole == "Admin" {
            if AppConstants.isCif {
                corporateTransactionReq()
            } else {
                merchantTransactionReq()
            }
        } else {
            merchantTransactionReq()
        }
    }
    
    func initialiseData(){
        
        lblcreditAmt.text = "KD 0.000"
        lblDebitAmount.text = "KD 0.000"
        lblPosAmount.text = "KD 0.000"
        lblEcommAmount.text = "KD 0.000"
        lblTijaratiAmount.text = "KD 0.000"
        lblCreditTransaction.text = "0 " +  "Transactions".localiz()
        lblDebitTransaction.text = "0 " +  "Transactions".localiz()
        lblPosTransaction.text = "0 " +  "Transactions".localiz()
        lblEcommTransaction.text = "0 " +  "Transactions".localiz()
        lblTijaratiTransaction.text = "0 " +  "Transactions".localiz()
        lblTRansactnAmount.text = "KD 0.000"
        lbltotalTransactions.text = "0 " +  "Transactions".localiz()
        lblSettledAmt.text = "KD 0.000"
        lblVoidAmt.text = "KD 0.000"
        lblFailedAmt.text = "KD 0.000"
        lblRefundAmt.text = "KD 0.000"
        lblInprogressAmt.text = "KD 0.000"
        lblExpiredAmt.text = "KD 0.000"
        lblDeclinedAmt.text = "KD 0.000"
        lblRefundCount.text = "0 " + "Refund".localiz()
        lblExpiredCount.text = "0 " + "Link Expired".localiz()
        lblDeclinedCount.text = "0 " + "Declined".localiz()
        lblInProgressCount.text = "0 " + "In Progress".localiz()
        lblFailedCount.text = "0 " + "Failed".localiz()
        lblVoidCount.text = "0 " + "Void".localiz()
        lblDebitDomesticAmt.text = "KD 0.000"
        lblDebitInternationlAmt.text = "KD 0.000"
        lblCreditDomesticAmt.text = "KD 0.000"
        lblCreditInternationlAmt.text =  "KD 0.000"
        lblDebitDomesticTRansactn.text = "0 " +  "Transactions".localiz()
        lblDebitInternatnlTransactn.text = "0 " +  "Transactions".localiz()
        lblCreditDomesticTransactn.text = "0 " +  "Transactions".localiz()
        lblCreditInternationalTransaction.text = "0 " +  "Transactions".localiz()
    }
    
    func textLayoutSetup(){
        lblTRansactnAmount.attributedText = lblTRansactnAmount.text!.attributedString(fontsize: 15)
        lblDebitAmount.attributedText = lblDebitAmount.text!.attributedString(fontsize: 15)
        lblPosAmount.attributedText = lblPosAmount.text!.attributedString(fontsize: 15)
        lblEcommAmount.attributedText = lblEcommAmount.text!.attributedString(fontsize: 15)
        lblTijaratiAmount.attributedText = lblTijaratiAmount.text!.attributedString(fontsize: 15)
        lblcreditAmt.attributedText = lblcreditAmt.text!.attributedString(fontsize: 15)
        lblDebitDomesticAmt.attributedText = lblDebitDomesticAmt.text!.attributedString(fontsize: 15)
        lblDebitInternationlAmt.attributedText = lblDebitInternationlAmt.text!.attributedString(fontsize: 15)
        lblCreditDomesticAmt.attributedText = lblCreditDomesticAmt.text!.attributedString(fontsize: 15)
        lblCreditInternationlAmt.attributedText = lblCreditInternationlAmt.text!.attributedString(fontsize: 15)
        lblSettledAmt.attributedText =  lblSettledAmt.text!.attributedString(fontsize: 15)
        
        lblRefundAmt.attributedText =  lblRefundAmt.text!.attributedString(fontsize: 12)
        lblInprogressAmt.attributedText =  lblInprogressAmt.text!.attributedString(fontsize: 12)
        lblExpiredAmt.attributedText =  lblExpiredAmt.text!.attributedString(fontsize: 12)
        lblDeclinedAmt.attributedText = lblDeclinedAmt.text!.attributedString(fontsize: 12)
        lblFailedAmt.attributedText =  lblFailedAmt.text!.attributedString(fontsize: 12)
        lblVoidAmt.attributedText =  lblVoidAmt.text!.attributedString(fontsize: 12)
    }
    
    func arabic(){
        lbltotalTransactionTitle.text = lbltotalTransactionTitle.text?.localiz()
        cardTypesBtnRef.setTitle("Card Types".localiz(), for: .normal)
        paymentChannelsBtnRef.setTitle("Payment Channels".localiz(), for: .normal)
        
        if AppConstants.language == .ar {
            cardTypesBtnRef.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner]
            paymentChannelsBtnRef.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            
            lblVoidAmt.textAlignment =  NSTextAlignment.right
            lblFailedAmt.textAlignment =  NSTextAlignment.right
            lblRefundAmt.textAlignment =  NSTextAlignment.right
            lblExpiredAmt.textAlignment = .right
            lblInprogressAmt.textAlignment = .right
            lblDeclinedAmt.textAlignment = .right
            
            lbltotalTransactionTitle.textAlignment =  .right
            lblTRansactnAmount.textAlignment = .right
            lbltotalTransactions.textAlignment = .right
            
            lblPosTitle.textAlignment = .right
            lblEcommTitle.textAlignment = .right
            lblTijaratiTitle.textAlignment = .right
            
            lblDebiotDomesticTitle.textAlignment = .right
            lblDebitInterTitle.textAlignment = .left
            
            lblCreditDomestic.textAlignment = .right
            lblCreditInter.textAlignment = .left
            
            lblDebitDomesticAmt.textAlignment =  NSTextAlignment.right
            lblCreditDomesticAmt.textAlignment =  NSTextAlignment.right
            
            lbldebitTitle.textAlignment =  NSTextAlignment.right
            lblCreditTitle.textAlignment =  NSTextAlignment.right
            
            lblmpgs.textAlignment =  NSTextAlignment.right
            
            
            lblDebitAmount.textAlignment = .left
            lblDebitTransaction.textAlignment = .left
            
            lblcreditAmt.textAlignment = .left
            lblCreditTransaction.textAlignment = .left
            
            lblPosAmount.textAlignment = .left
            lblPosTransaction.textAlignment = .left
            
            lblEcommAmount.textAlignment = .left
            lblEcommTransaction.textAlignment = .left
            
            lblTijaratiAmount.textAlignment = .left
            lblTijaratiTransaction.textAlignment = .left
            
            
            lblVoidCount.textAlignment = .left
            lblFailedCount.textAlignment = .left
            lblRefundCount.textAlignment = .left
            lblDeclinedCount.textAlignment = .left
            lblInProgressCount.textAlignment = .left
            lblExpiredCount.textAlignment = .left
            
            lblDebitInterTitle.textAlignment = .left
            lblDebitInternationlAmt.textAlignment = .left
            lblDebitInternatnlTransactn.textAlignment = .left
            
            lblCreditInter.textAlignment = .left
            lblCreditInternationlAmt.textAlignment = .left
            lblCreditInternationalTransaction.textAlignment = .left
            
            lblSettlmntAmt.textAlignment = .right
            
            btnGoToDebitTransactionDetail.imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
            btnGoToCreditTransactionDetail.imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
            btnGoToPOSTransactionDetail.imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
            btnGoToEcommTransactionDetail.imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
            btnGoToTijaratiPayTransactionDetail.imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
            
        } else {
            
            cardTypesBtnRef.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            paymentChannelsBtnRef.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
            
            lblVoidAmt.textAlignment =  NSTextAlignment.left
            lblFailedAmt.textAlignment =  NSTextAlignment.left
            lblRefundAmt.textAlignment =  NSTextAlignment.left
            lblDeclinedAmt.textAlignment = .left
            lblExpiredAmt.textAlignment = .left
            lblInprogressAmt.textAlignment = .left
            
            lbltotalTransactionTitle.textAlignment =  .left
            lblTRansactnAmount.textAlignment = .left
            lbltotalTransactions.textAlignment = .left
            
            lblPosTitle.textAlignment = .left
            lblEcommTitle.textAlignment = .left
            lblTijaratiTitle.textAlignment = .left
            
            lblDebiotDomesticTitle.textAlignment = .left
            lblDebitInterTitle.textAlignment = .right
            
            lblCreditDomestic.textAlignment = .left
            lblCreditInter.textAlignment = .right
            
            lblDebitDomesticAmt.textAlignment =  NSTextAlignment.left
            lblCreditDomesticAmt.textAlignment =  NSTextAlignment.left
            
            lbldebitTitle.textAlignment =  NSTextAlignment.left
            lblCreditTitle.textAlignment =  NSTextAlignment.left
            
            lblmpgs.textAlignment =  NSTextAlignment.left
            
            
            lblDebitAmount.textAlignment = .right
            lblDebitTransaction.textAlignment = .right
            
            lblcreditAmt.textAlignment = .right
            lblCreditTransaction.textAlignment = .right
            
            lblPosAmount.textAlignment = .right
            lblPosTransaction.textAlignment = .right
            
            lblEcommAmount.textAlignment = .right
            lblEcommTransaction.textAlignment = .right
            
            lblTijaratiAmount.textAlignment = .right
            lblTijaratiTransaction.textAlignment = .right
            
            lblVoidCount.textAlignment = .right
            lblFailedCount.textAlignment = .right
            lblRefundCount.textAlignment = .right
            lblDeclinedCount.textAlignment = .right
            lblInProgressCount.textAlignment = .right
            lblExpiredCount.textAlignment = .right
            
            lblDebitInterTitle.textAlignment = .right
            lblDebitInternationlAmt.textAlignment = .right
            lblDebitInternatnlTransactn.textAlignment = .right
            
            lblCreditInter.textAlignment = .right
            lblCreditInternationlAmt.textAlignment = .right
            lblCreditInternationalTransaction.textAlignment = .right
            
            lblSettlmntAmt.textAlignment = .left
            
            btnGoToDebitTransactionDetail.imageView?.transform = CGAffineTransform(scaleX: 1, y: 1)
            btnGoToCreditTransactionDetail.imageView?.transform = CGAffineTransform(scaleX: 1, y: 1)
            btnGoToPOSTransactionDetail.imageView?.transform = CGAffineTransform(scaleX: 1, y: 1)
            btnGoToEcommTransactionDetail.imageView?.transform = CGAffineTransform(scaleX: 1, y: 1)
            btnGoToTijaratiPayTransactionDetail.imageView?.transform = CGAffineTransform(scaleX: 1, y: 1)
            
        }
        lblmpgs.text = lblmpgs.text!.localiz()
        lbltotalTransactionTitle.text = lbltotalTransactionTitle.text!.localiz()
        lblDebiotDomesticTitle.text = lblDebiotDomesticTitle.text!.localiz()
        lblCreditInter.text = lblCreditInter.text!.localiz()
        lblCreditDomestic.text = lblCreditDomestic.text!.localiz()
        lblSettlmntAmt.text = lblSettlmntAmt.text!.localiz()
        lblSettlmntAmt.text = "This tab will be updated once the transaction is settled".localiz()
    }
    
    func currentMonthData(){
        
        let startDate = AppConstants.jsonStartDate.dateFromFormat("yyyy-MM-dd")
        let endDate = AppConstants.jsonEndDate.dateFromFormat("yyyy-MM-dd")
        
        if AppConstants.jsonStartDate == AppConstants.jsonEndDate {
            let selectedDateRange = startDate!.monthh.prefix(3) + " - " + String(endDate!.day) + ", " + endDate!.yearr
            
            btnSelectMonth.setTitle(selectedDateRange, for: .normal)
            
        } else {
            
            let selectedDateRange = startDate!.monthh.prefix(3) + " " + String(startDate!.day) + " - "
            let myEndDate = endDate!.monthh.prefix(3) + String(endDate!.day) + ", " + endDate!.yearr
            
            btnSelectMonth.setTitle(selectedDateRange + myEndDate, for: .normal)
        }
    }
    
    func merchantTransactionReq(){
        
        let merchant = AppConstants.merchantNumber.map { String($0) }
        
        let param : [String : Any] = ["type":"mid",
                                      "merchantNum" : merchant,
                                      "deviceId" : AppConstants.UserData.deviceID,
                                      "startDate": AppConstants.jsonStartDate,
                                      "endDate":AppConstants.jsonEndDate]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.getTransactionSummary)
        self.bindUI()
    }
    
    func corporateTransactionReq(){
        
        let param : [String : Any] = ["type":"cif",
                                      "cif" : AppConstants.selectedFilter!.cif,
                                      "deviceId" : AppConstants.UserData.deviceID,
                                      "startDate": AppConstants.jsonStartDate,
                                      "endDate":AppConstants.jsonEndDate]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.getTransactionSummary)
        self.bindUI()
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
    
    func setAmounts(amount : String) -> String{
        return (Double(amount)?.rounded(digits: 3).calculate)!
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
                            if AppConstants.isCif {
                                self!.corporateTransactionReq()
                            } else {
                                self!.merchantTransactionReq()
                            }
                        } else {
                            self!.merchantTransactionReq()
                        }
                        
                    } else {
                        
                        let message : String = userStatus?.value(forKey: "message") as! String
                        let status : String = userStatus?.value(forKey: "status") as! String
                        if status == "Success"{
                            let errorCode : String = userStatus?.value(forKey: "errorCode") as! String
                            if errorCode == "L128"{
                                //                                  print(message)
                                let object = self!.decodeResult(model: transactionsResp.self, result: userStatus!)
                                if let objectModel = object.model{
                                    self!.transactionSummaryApi = [objectModel]
                                    print("ApiData:- \(self!.transactionSummaryApi)")
                                }
                                
                                if let transactions = object.model {
                                    self!.lblcreditAmt.text = "KD " + self!.setAmounts(amount: (transactions.ccAmount ?? "0.000"))
                                    self!.lblDebitAmount.text = "KD " + self!.setAmounts(amount: (transactions.dcAmount ?? "0.000"))
                                    
                                    self?.lblPosAmount.text = "KD " + (self?.setAmounts(amount: transactions.posAmt ?? "0.000") ?? "0.000")
                                    self?.lblEcommAmount.text = "KD " + (self?.setAmounts(amount: transactions.ecommAmt ?? "0.000") ?? "0.000")
                                    self?.lblTijaratiAmount.text = "KD " + (self?.setAmounts(amount: transactions.eZPayAmt ?? "0.000") ?? "0.000")
                                    
                                    self?.lblPosTransaction.text = (transactions.posTxnCount ?? "0") + " " + "Transactions".localiz()
                                    self?.lblEcommTransaction.text = (transactions.ecommTxnCount ?? "0") + " " + "Transactions".localiz()
                                    self?.lblTijaratiTransaction.text = (transactions.eZPayTxnCount ?? "0") + " " + "Transactions".localiz()
                                    
                                    self?.lblcreditAmt.attributedText = self!.lblcreditAmt.text!.attributedString(fontsize: 15)
                                    self?.lblDebitAmount.attributedText = self?.lblDebitAmount.text!.attributedString(fontsize: 15)
                                    
                                    self?.lblPosAmount.attributedText = self?.lblPosAmount.text?.attributedString(fontsize: 15)
                                    self?.lblEcommAmount.attributedText = self?.lblEcommAmount.text?.attributedString(fontsize: 15)
                                    self?.lblTijaratiAmount.attributedText = self?.lblTijaratiAmount.text?.attributedString(fontsize: 15)
                                    
                                    self!.lblCreditTransaction.text = (transactions.ccCount ?? "0") + " " + "Transactions".localiz()
                                    self!.lblDebitTransaction.text = (transactions.dcCount ?? "0") + " " + "Transactions".localiz()
                                    
                                    // Must Check
                                    let Amt = Double(transactions.ddcAmount ?? "0.000")
                                    let totAmt = Double(transactions.dcAmount ?? "0.000")
                                    self?.debitProgress.setProgress( Float(Amt! / totAmt!), animated: true)
                                    
                                    // Must Check
                                    let cAmt = Double(transactions.dccAmount ?? "0.000")
                                    let cTotAmt = Double(transactions.ccAmount ?? "0.000")
                                    self?.creditProgressBar.setProgress( Float(cAmt! / cTotAmt!), animated: true)
                                    
                                    
                                    
                                    self!.lblTRansactnAmount.text = "KD " + self!.setAmounts(amount: (transactions.totalAmount ?? "0.000"))
                                    self?.lblTRansactnAmount.attributedText = self!.lblTRansactnAmount.text!.attributedString(fontsize: 15)
                                    
                                    self!.lbltotalTransactions.text = (transactions.totalCount ?? "0") + " " + "Transactions".localiz()
                                    self!.lblSettledAmt.text = "KD " + self!.setAmounts(amount: (transactions.settledAmount ?? "0.000"))
                                    //                                self!.lblSettledAmt.text = "KD 12345678.000"
                                    
                                    self!.lblSettledAmt.attributedText = self!.lblSettledAmt.text!.attributedString(fontsize: 15)
                                    
                                    self!.lblVoidAmt.text = "KD " + self!.setAmounts(amount: (transactions.voidAmount ?? "0.000"))
                                    self!.lblVoidAmt.attributedText = self!.lblVoidAmt.text!.attributedString(fontsize: 12)
                                    
                                    self!.lblFailedAmt.text = "KD " + self!.setAmounts(amount: (transactions.failedAmount ?? "0.000"))
                                    self!.lblFailedAmt.attributedText = self!.lblFailedAmt.text!.attributedString(fontsize: 12)
                                    
                                    self!.lblRefundAmt.text = "KD " + self!.setAmounts(amount: (transactions.refundAmount ?? "0.000"))
                                    self!.lblRefundAmt.attributedText = self!.lblRefundAmt.text!.attributedString(fontsize: 12)
                                    
                                    self!.lblExpiredAmt.text = "KD " + self!.setAmounts(amount: (transactions.linkExpiredAmount ?? "0.000"))
                                    self!.lblExpiredAmt.attributedText = self!.lblExpiredAmt.text!.attributedString(fontsize: 12)
                                    
                                    self!.lblInprogressAmt.text = "KD " + self!.setAmounts(amount: (transactions.inprogressAmount ?? "0.000"))
                                    self!.lblInprogressAmt.attributedText = self!.lblInprogressAmt.text!.attributedString(fontsize: 12)
                                    
                                    self!.lblDeclinedAmt.text = "KD " + self!.setAmounts(amount: (transactions.linkDeclinedAmount ?? "0.000"))
                                    self!.lblDeclinedAmt.attributedText = self!.lblDeclinedAmt.text!.attributedString(fontsize: 12)
                                    
                                    self!.lblRefundCount.text = (transactions.refundCount ?? "0") + " " + "Refund".localiz()
                                    self!.lblDeclinedCount.text = (transactions.linkDeclinedCount ?? "0") + " " + "Declined".localiz()
                                    self!.lblFailedCount.text = (transactions.failedCount ?? "0") + " " + "Failed".localiz()
                                    self!.lblVoidCount.text = (transactions.voidCount ?? "0") + " " + "Void".localiz()
                                    self!.lblInProgressCount.text = (transactions.inprogressCount ?? "0") + " " + "In Progress".localiz()
                                    self!.lblExpiredCount.text = (transactions.linkExpiredCount ?? "0") + " " + "Link Expired".localiz()
                                    
                                    
                                    self?.voidCnt = Int(transactions.voidCount ?? "0") ?? 0
                                    self?.failedCnt = Int(transactions.failedCount ?? "0") ?? 0
                                    self?.refundCnt = Int(transactions.refundCount ?? "0") ?? 0
                                    self?.expiredCnt = Int(transactions.linkExpiredCount ?? "0") ?? 0
                                    self?.inProgressCnt = Int(transactions.inprogressCount ?? "0") ?? 0
                                    self?.declinedCnt = Int(transactions.linkDeclinedCount ?? "0") ?? 0
                                    
                                    self!.lblDebitDomesticAmt.text = "KD " + self!.setAmounts(amount: (transactions.ddcAmount ?? "0.000"))
                                    self!.lblDebitDomesticAmt.attributedText = self!.lblDebitDomesticAmt.text!.attributedString(fontsize: 15)
                                    
                                    self!.lblDebitInternationlAmt.text = "KD " + self!.setAmounts(amount: (transactions.idcAmount ?? "0.000"))
                                    self!.lblDebitInternationlAmt.attributedText = self!.lblDebitInternationlAmt.text!.attributedString(fontsize: 15)
                                    
                                    self!.lblCreditDomesticAmt.text = "KD " + self!.setAmounts(amount: (transactions.dccAmount ?? "0.000"))
                                    self!.lblCreditDomesticAmt.attributedText = self!.lblCreditDomesticAmt.text!.attributedString(fontsize: 15)
                                    
                                    self!.lblCreditInternationlAmt.text =  "KD " + self!.setAmounts(amount: (transactions.iccAmount ?? "0.000"))
                                    self!.lblCreditInternationlAmt.attributedText = self!.lblCreditInternationlAmt.text!.attributedString(fontsize: 15)
                                    
                                    
                                    
                                    self!.lblDebitDomesticTRansactn.text = (transactions.ddcCount ?? "0") +  " " + "Transactions".localiz()
                                    self!.lblDebitInternatnlTransactn.text = (transactions.idcCount ?? "0") +  " " + "Transactions".localiz()
                                    self!.lblCreditDomesticTransactn.text = (transactions.dccCount ?? "0") + " " + "Transactions".localiz()
                                    self!.lblCreditInternationalTransaction.text = (transactions.iccCount ?? "0") +  " " + "Transactions".localiz()
                                    // self!.textLayoutSetup()
                                }
                                
                                DispatchQueue.main.async {
                                    self!.posDetailCvRef.reloadData()
                                    self!.ecommDetailCvRef.reloadData()
                                    self!.tijaratiDetailCvRef.reloadData()
                                }
                                
                            } else {
                                self!.showAlertWith(message: AlertMessage(title: "Transactions".localiz(), body: message.localiz()))
                            }
                            
                        } else {
                            self!.showAlertWith(message: AlertMessage(title: "Transactions".localiz(), body: message.localiz()))
                        }
                        
                    }
                    
                    
                }
            }
        })
    }
    
    
    func calendarSetup() {
        //curvedviewShadow(view: calendarView)
        
        //calendarView.delegate = self
        //calendarView.dataSource = self
        //        calendarView.select(Date())
        //        calendarView.select(AppConstants.jsonStartDate.dateFromFormat("yyyy-MM-dd"))
        // btnSelectMonth.setTitle(calendarView.currentPage.monthh + ", " + calendarView.currentPage.yearr + "     ", for: .normal)
        
        //calendarView.scope = .week
        
        //calendarAppearanceSetup(calendar: calendarView)
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
    
    
    
    //    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
    //        [unowned self] in
    //        let panGesture = UIPanGestureRecognizer(target: self.calendarView, action: #selector(self.calendarView.handleScopeGesture(_:)))
    //        panGesture.delegate = self
    //        panGesture.minimumNumberOfTouches = 1
    //        panGesture.maximumNumberOfTouches = 2
    //        return panGesture
    //    }()
    
    
    @IBAction func selectLocation(_ sender: Any) {
        if AppConstants.selectedFilter != nil {
            let controller = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SelectLocationViewController") as? SelectLocationViewController)!
            controller.delegateFilter = self
            presentAsStork(controller, height: 500, cornerRadius: 8.0, showIndicator: false, showCloseButton: false)
        } else {
            showAlertWith(message: AlertMessage(title: "Tijarati".localiz(), body: "No data available to filter.".localiz()))
        }
    }
    @IBAction func selectMonth(_ sender: Any) {
        
        let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CalendarPopupViewController") as? CalendarPopupViewController
        controller?.popuptype = 0
        controller?.calendarClockdelegate = self
        presentAsStork(controller!, height: 650, cornerRadius: 8, showIndicator: false, showCloseButton: false)
    }
    
    @IBAction func openSideMenu(_ sender: Any) {
        //        self.sideMenuViewController.presentLeftMenuViewController()
        
        if AppConstants.language == .ar {
            self.sideMenuViewController.presentRightMenuViewController()
        } else {
            self.sideMenuViewController.presentLeftMenuViewController()
        }
    }
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendrviewHeight.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en")
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    //     func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    //
    //        print("did select date \(self.dateFormatter.string(from: date))")
    //                    let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
    //                    print("selected dates is \(selectedDates)")
    //                    if monthPosition == .next || monthPosition == .previous {
    //                        calendar.setCurrentPage(date, animated: true)
    //
    //                    }
    //
    //        calendarView.select(date)
    //        btnSelectMonth.setTitle(date.month + ", " + date.year + "     ", for: .normal)
    //
    //
    //     }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
    func imageRotatedByDegrees(oldImage: UIImage, deg degrees: CGFloat) -> UIImage {
        //Calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: oldImage.size.width, height: oldImage.size.height))
        let t: CGAffineTransform = CGAffineTransform(rotationAngle: degrees * CGFloat.pi / 180)
        rotatedViewBox.transform = t
        let rotatedSize: CGSize = rotatedViewBox.frame.size
        //Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        //Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        //Rotate the image context
        bitmap.rotate(by: (degrees * CGFloat.pi / 180))
        //Now, draw the rotated/scaled image into the context
        bitmap.scaleBy(x: 1.0, y: -1.0)
        bitmap.draw(oldImage.cgImage!, in: CGRect(x: -oldImage.size.width / 2, y: -oldImage.size.height / 2, width: oldImage.size.width, height: oldImage.size.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    func curvedviewShadow(view:UIView){
        
        view.layer.cornerRadius = 8
        view.layer.shadowOpacity = 0.35
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowRadius = 3.0
        view.layer.shadowColor = UIColor.BurganColor.brandGray.lgiht.cgColor
        view.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner,.layerMaxXMinYCorner]
    }
    
    @IBAction func showDebitDetail(_ sender: Any) {
        
        if(showDebitDetail){
            debitDetailView.isHidden = true
            showDebitDetail = false
            debitDetailViewHeight.constant = 0
            curvedTRansactionViewHeight.constant = 185
            
            //            curvedTRansactionViewHeight.constant = curvedTRansactionViewHeight.constant - 400
            print("show debit call")
        } else {
            debitDetailView.isHidden = false
            showDebitDetail = true
            debitDetailViewHeight.constant = 140
            curvedTRansactionViewHeight.constant = 185
            //           curvedTRansactionViewHeight.constant = curvedTRansactionViewHeight.constant + 550
            
        }
        
        if (showCreditDetail == true && showDebitDetail == true) {
            curvedTRansactionViewHeight.constant = 465
        } else if (showCreditDetail == false && showDebitDetail == false) {
            curvedTRansactionViewHeight.constant = 185
        } else {
            curvedTRansactionViewHeight.constant = 325
        }
        //        if(showCreditDetail){
        //
        //            showCreditDetail = false
        //            creditDetailViewHeight.constant = 0
        //            creditDetailView.isHidden = true
        //            btnCreditDetail.setImage(UIImage(named: "ic_down_arrow_black"), for: .normal)
        //        }
        btnDebitDetail.setImage(imageRotatedByDegrees(oldImage: btnDebitDetail.imageView!.image!, deg: 180), for: .normal)
        
        
    }
    @IBAction func showCreditDetail(_ sender: Any) {
        if(showCreditDetail){
            showCreditDetail = false
            creditDetailViewHeight.constant = 0
            creditDetailView.isHidden = true
            curvedTRansactionViewHeight.constant = 190
            //            curvedTRansactionViewHeight.constant = curvedTRansactionViewHeight.constant - 400
        } else {
            showCreditDetail = true
            creditDetailViewHeight.constant = 140
            creditDetailView.isHidden = false
            curvedTRansactionViewHeight.constant = 190
            //            curvedTRansactionViewHeight.constant = curvedTRansactionViewHeight.constant + 550
        }
        
        if (showCreditDetail == true && showDebitDetail == true) {
            curvedTRansactionViewHeight.constant = 470
        } else if (showCreditDetail == false && showDebitDetail == false) {
            curvedTRansactionViewHeight.constant = 190
        } else {
            curvedTRansactionViewHeight.constant = 330
        }
        
        //        if(showDebitDetail){
        //            btnDebitDetail.setImage(UIImage(named: "ic_down_arrow_black"), for: .normal)
        //            showDebitDetail = false
        //            debitDetailViewHeight.constant = 0
        //            debitDetailView.isHidden = true
        //        }
        btnCreditDetail.setImage(imageRotatedByDegrees(oldImage: btnCreditDetail.imageView!.image!, deg: 180), for: .normal)
    }
    
    @IBOutlet weak var infoView: UIView!
    
}

extension Date {
    var monthh: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
    var yearr: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: self)
    }
}


//MARK:- BUTTON ACTION
extension TransactionsViewController{
    
    @IBAction func cardTypesBtnTap(_ sender: UIButton){
        cardTypesBtnRef.backgroundColor = #colorLiteral(red: 0, green: 0.3555235369, blue: 0.6150870715, alpha: 1)
        paymentChannelsBtnRef.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        cardTypesBtnRef.setTitleColor(UIColor.white, for: .normal)
        paymentChannelsBtnRef.setTitleColor(#colorLiteral(red: 0, green: 0.3555235369, blue: 0.6150870715, alpha: 1), for: .normal)
        paymentChannelViewRef.isHidden = true
        
        showCardTypes = true
        showPaymentChannels = false
        
        if showDebitDetail{
            paymentChannelViewHeightRef.constant = 0
            curvedTRansactionViewHeight.constant = 335
        }else if showCreditDetail{
            paymentChannelViewHeightRef.constant = 0
            curvedTRansactionViewHeight.constant = 335
        }else if (showCreditDetail == true && showDebitDetail == true) {
            curvedTRansactionViewHeight.constant = 470
        } else if (showCreditDetail == false && showDebitDetail == false) {
            curvedTRansactionViewHeight.constant = 185
        }
        else{
            paymentChannelViewHeightRef.constant = 0
            curvedTRansactionViewHeight.constant = 185
        }
        
        showPosDetailView = false
        showEcommDetailView = false
        showTijaratiDetailView = false
        
        posDetailViewRef.isHidden = true
        ecommDetailViewRef.isHidden = true
        tijaratiDetailViewRef.isHidden = true
        
        posDetailViewBtnRef.setImage(UIImage(named: "ic_down_arrow_black"), for: .normal)
        ecommDetailViewBtnRef.setImage(UIImage(named: "ic_down_arrow_black"), for: .normal)
        tijaratiDetailViewBtnRef.setImage(UIImage(named: "ic_down_arrow_black"), for: .normal)
        
        
    }
    
    @IBAction func paymentChannelsBtnTap(_ sender: UIButton){
        cardTypesBtnRef.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        paymentChannelsBtnRef.backgroundColor = #colorLiteral(red: 0, green: 0.3555235369, blue: 0.6150870715, alpha: 1)
        
        paymentChannelsBtnRef.setTitleColor(UIColor.white, for: .normal)
        cardTypesBtnRef.setTitleColor(#colorLiteral(red: 0, green: 0.3555235369, blue: 0.6150870715, alpha: 1), for: .normal)
        paymentChannelViewRef.isHidden = false
        
        showCardTypes = false
        showPaymentChannels = true
        
        //        paymentChannelViewHeightRef.constant = 272
        curvedTRansactionViewHeight.constant = 0
        
        if showPosDetailView{
            paymentChannelViewHeightRef.constant = 412
            curvedTRansactionViewHeight.constant = 0
        }else if showEcommDetailView{
            paymentChannelViewHeightRef.constant = 412
            curvedTRansactionViewHeight.constant = 0
        }else if showTijaratiDetailView{
            paymentChannelViewHeightRef.constant = 412
            curvedTRansactionViewHeight.constant = 0
        }
        else if (showTijaratiDetailView && showEcommDetailView && showPosDetailView){
            paymentChannelViewHeightRef.constant = 692
        }else if (showEcommDetailView == false && showPosDetailView == false && showTijaratiDetailView == true){
            paymentChannelViewHeightRef.constant = 412
        }else if (showEcommDetailView == false && showPosDetailView == true && showTijaratiDetailView == false){
            paymentChannelViewHeightRef.constant = 412
        }else if (showEcommDetailView == true && showPosDetailView == false && showTijaratiDetailView == false){
            paymentChannelViewHeightRef.constant = 412
        }else if (showEcommDetailView == true && showPosDetailView == true && showTijaratiDetailView == false){
            paymentChannelViewHeightRef.constant = 552
        }else if (showEcommDetailView == false && showPosDetailView == true && showTijaratiDetailView == true){
            paymentChannelViewHeightRef.constant = 552
        }else if (showEcommDetailView == true && showPosDetailView == false && showTijaratiDetailView == true){
            paymentChannelViewHeightRef.constant = 552
        } else {
            paymentChannelViewHeightRef.constant = 272
            curvedTRansactionViewHeight.constant = 0
        }
        //        creditDetailView.isHidden = true
        //        debitDetailView.isHidden = true
        
        showDebitDetail = false
        showCreditDetail = false
        
        debitDetailView.isHidden = true
        creditDetailView.isHidden = true
        
        btnCreditDetail.setImage(UIImage(named: "ic_down_arrow_black"), for: .normal)
        btnDebitDetail.setImage(UIImage(named: "ic_down_arrow_black"), for: .normal)
        
    }
    
}

//MARK:- PAYMENT CHANNEL BTN ACTION
extension TransactionsViewController{
    @IBAction func showPosDetail(_ sender: Any) {
        
        if(showPosDetailView){
            posDetailViewRef.isHidden = true
            showPosDetailView = false
            posDetailViewHeightRef.constant = 0
            paymentChannelViewHeightRef.constant = 272
            
            //            curvedTRansactionViewHeight.constant = curvedTRansactionViewHeight.constant - 400
            print("show debit call")
        } else {
            posDetailViewRef.isHidden = false
            showPosDetailView = true
            posDetailViewHeightRef.constant = 140
            paymentChannelViewHeightRef.constant = 272
            //           curvedTRansactionViewHeight.constant = curvedTRansactionViewHeight.constant + 550
            
        }
        if (showTijaratiDetailView && showEcommDetailView && showPosDetailView){
            paymentChannelViewHeightRef.constant = 692
        }else if (showEcommDetailView == false && showPosDetailView == false && showTijaratiDetailView == true){
            paymentChannelViewHeightRef.constant = 412
        }else if (showEcommDetailView == false && showPosDetailView == true && showTijaratiDetailView == false){
            paymentChannelViewHeightRef.constant = 412
        }else if (showEcommDetailView == true && showPosDetailView == false && showTijaratiDetailView == false){
            paymentChannelViewHeightRef.constant = 412
        }else if (showEcommDetailView == true && showPosDetailView == true && showTijaratiDetailView == false){
            paymentChannelViewHeightRef.constant = 552
        }else if (showEcommDetailView == false && showPosDetailView == true && showTijaratiDetailView == true){
            paymentChannelViewHeightRef.constant = 552
        }else if (showEcommDetailView == true && showPosDetailView == false && showTijaratiDetailView == true){
            paymentChannelViewHeightRef.constant = 552
        } else {
            paymentChannelViewHeightRef.constant = 272
        }
        //        if(showCreditDetail){
        //
        //            showCreditDetail = false
        //            creditDetailViewHeight.constant = 0
        //            creditDetailView.isHidden = true
        //            btnCreditDetail.setImage(UIImage(named: "ic_down_arrow_black"), for: .normal)
        //        }
        posDetailViewBtnRef.setImage(imageRotatedByDegrees(oldImage: posDetailViewBtnRef.imageView!.image!, deg: 180), for: .normal)
        
        
    }
    @IBAction func showEcommDetail(_ sender: Any) {
        if(showEcommDetailView){
            showEcommDetailView = false
            ecommDetailViewHeightRef.constant = 0
            ecommDetailViewRef.isHidden = true
            paymentChannelViewHeightRef.constant = 272
            //            curvedTRansactionViewHeight.constant = curvedTRansactionViewHeight.constant - 400
        } else {
            showEcommDetailView = true
            ecommDetailViewHeightRef.constant = 140
            ecommDetailViewRef.isHidden = false
            paymentChannelViewHeightRef.constant = 272
            //            curvedTRansactionViewHeight.constant = curvedTRansactionViewHeight.constant + 550
        }
        
        if (showTijaratiDetailView && showEcommDetailView && showPosDetailView){
            paymentChannelViewHeightRef.constant = 692
        }else if (showEcommDetailView == false && showPosDetailView == false && showTijaratiDetailView == true){
            paymentChannelViewHeightRef.constant = 412
        }else if (showEcommDetailView == false && showPosDetailView == true && showTijaratiDetailView == false){
            paymentChannelViewHeightRef.constant = 412
        }else if (showEcommDetailView == true && showPosDetailView == false && showTijaratiDetailView == false){
            paymentChannelViewHeightRef.constant = 412
        }else if (showEcommDetailView == true && showPosDetailView == true && showTijaratiDetailView == false){
            paymentChannelViewHeightRef.constant = 552
        }else if (showEcommDetailView == false && showPosDetailView == true && showTijaratiDetailView == true){
            paymentChannelViewHeightRef.constant = 552
        }else if (showEcommDetailView == true && showPosDetailView == false && showTijaratiDetailView == true){
            paymentChannelViewHeightRef.constant = 552
        } else {
            paymentChannelViewHeightRef.constant = 272
        }
        ecommDetailViewBtnRef.setImage(imageRotatedByDegrees(oldImage: ecommDetailViewBtnRef.imageView!.image!, deg: 180), for: .normal)
    }
    
    @IBAction func showTijaratiDetail(_ sender: UIButton){
        if(showTijaratiDetailView){
            showTijaratiDetailView = false
            tijaratiDetailViewHeightRef.constant = 0
            tijaratiDetailViewRef.isHidden = true
            paymentChannelViewHeightRef.constant = 272
            //            curvedTRansactionViewHeight.constant = curvedTRansactionViewHeight.constant - 400
        } else {
            showTijaratiDetailView = true
            tijaratiDetailViewHeightRef.constant = 140
            tijaratiDetailViewRef.isHidden = false
            paymentChannelViewHeightRef.constant = 272
            //            curvedTRansactionViewHeight.constant = curvedTRansactionViewHeight.constant + 550
        }
        
        if (showTijaratiDetailView && showEcommDetailView && showPosDetailView){
            paymentChannelViewHeightRef.constant = 692
        }else if (showEcommDetailView == false && showPosDetailView == false && showTijaratiDetailView == true){
            paymentChannelViewHeightRef.constant = 412
        }else if (showEcommDetailView == false && showPosDetailView == true && showTijaratiDetailView == false){
            paymentChannelViewHeightRef.constant = 412
        }else if (showEcommDetailView == true && showPosDetailView == false && showTijaratiDetailView == false){
            paymentChannelViewHeightRef.constant = 412
        }else if (showEcommDetailView == true && showPosDetailView == true && showTijaratiDetailView == false){
            paymentChannelViewHeightRef.constant = 552
        }else if (showEcommDetailView == false && showPosDetailView == true && showTijaratiDetailView == true){
            paymentChannelViewHeightRef.constant = 552
        }else if (showEcommDetailView == true && showPosDetailView == false && showTijaratiDetailView == true){
            paymentChannelViewHeightRef.constant = 552
        } else {
            paymentChannelViewHeightRef.constant = 272
        }
        
        tijaratiDetailViewBtnRef.setImage(imageRotatedByDegrees(oldImage: tijaratiDetailViewBtnRef.imageView!.image!, deg: 180), for: .normal)
    }
    
}

//MARK:- BUTTON ACTION
extension TransactionsViewController {
    @IBAction func goToPosTransactionDetail(_ sender: Any) {
        
        let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CardTransactionListViewController") as? CardTransactionListViewController
        controller?.cardType = "POS"
        controller?.startDate =  AppConstants.jsonStartDate
        controller?.endDate = AppConstants.jsonEndDate
        controller?.txnStatus = "Success"
        controller?.titleStr = "POS Transaction List".localiz()
        self.navigationController?.pushViewController(controller!, animated: false)
    }
    
    @IBAction func goToEcommTransactionDetail(_ sender: Any) {
        
        let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CardTransactionListViewController") as? CardTransactionListViewController
        controller?.cardType = "Ecomm"
        controller?.startDate =  AppConstants.jsonStartDate
        controller?.endDate = AppConstants.jsonEndDate
        controller?.txnStatus = "Success"
        controller?.titleStr = "Ecomm Transaction List".localiz()
        self.navigationController?.pushViewController(controller!, animated: false)
    }
    
    @IBAction func goToTijaratiTransactionDetail(_ sender: Any) {
        
        let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CardTransactionListViewController") as? CardTransactionListViewController
        controller?.cardType = "ezpay"
        controller?.startDate =  AppConstants.jsonStartDate
        controller?.endDate = AppConstants.jsonEndDate
        controller?.txnStatus = "Success"
        controller?.titleStr = "Tijarati Pay".localiz() + " Transaction List".localiz()
        self.navigationController?.pushViewController(controller!, animated: false)
    }
    
}

//MARK:- COLLECTION VIEW METHODS
extension TransactionsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == posDetailCvRef{
            return 2
        }
        if collectionView == ecommDetailCvRef{
            return 2
        }
        if collectionView == tijaratiDetailCvRef{
            return 2
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == posDetailCvRef{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "posDetailCell", for: indexPath) as! EcommDetailCVC
            cell.progressView.layer.cornerRadius = 5
            cell.progressView.clipsToBounds = true
            cell.progressView.layer.sublayers![1].cornerRadius = 5
            cell.progressView.subviews[1].clipsToBounds = true
            
            if indexPath.row == 0{
                cell.lblTitle1.text = "Debit Card".localiz()
                cell.lblTitle2.text = "Credit Card".localiz()
                let count = transactionSummaryApi.count
                
                if count != 0{
                    if let txnDebitAmount = transactionSummaryApi[0].posDebitCardAmt{
                        cell.lblAmount1.text = "KD " + (self.setAmounts(amount: txnDebitAmount))
                        
                        cell.lblAmount1.attributedText = cell.lblAmount1.text!.attributedString(fontsize: 15)
                    }
                    
                    if let txnCreditAmount = transactionSummaryApi[0].posAmt{
                        cell.lblAmount2.text = "KD " + (self.setAmounts(amount: txnCreditAmount))
                        
                        cell.lblAmount2.attributedText = cell.lblAmount2.text!.attributedString(fontsize: 15)
                    }
                    if let creditAmount = transactionSummaryApi[0].posAmt, let debitAmount = transactionSummaryApi[0].posDebitCardAmt{
                        let credAmt = CGFloat((creditAmount as NSString).floatValue)
                        let debAmt = CGFloat((debitAmount as NSString).floatValue)
                        let finalValue = debAmt + credAmt
                        let progress = debAmt / finalValue
                        print("Progress:- \(progress)")
                        
                        cell.progressView.setProgress( Float(progress), animated: true)
                        
                    }
                    
                    if let debitTansaction = transactionSummaryApi[0].posDebitCardTxnCount{
                        cell.lblTransctn1.text = "\(debitTansaction) " + "Transactions".localiz()
                    }
                    
                    if let creditTansaction = transactionSummaryApi[0].posTxnCount{
                        cell.lblTrnsctn2.text = "\(creditTansaction) " + "Transactions".localiz()
                    }
                }
                
            }
            if indexPath.row == 1{
                cell.lblTitle1.text = "International".localiz()
                cell.lblTitle2.text = "Domestic".localiz()
                let count = transactionSummaryApi.count
                
                if count != 0{
                    if let txnInternationalAmount = transactionSummaryApi[0].posInternationalAmt{
                        cell.lblAmount1.text = "KD " + (self.setAmounts(amount: txnInternationalAmount))
                        
                        cell.lblAmount1.attributedText = cell.lblAmount1.text!.attributedString(fontsize: 15)
                    }
                    
                    if let txnDomesticAmount = transactionSummaryApi[0].posDomesticAmt{
                        cell.lblAmount2.text = "KD " + (self.setAmounts(amount: txnDomesticAmount))
                        
                        cell.lblAmount2.attributedText = cell.lblAmount2.text!.attributedString(fontsize: 15)
                    }
                    if let internationalAmount = transactionSummaryApi[0].posInternationalAmt, let domesticAmount = transactionSummaryApi[0].posDomesticAmt{
                        let intAmt = CGFloat((internationalAmount as NSString).floatValue)
                        let domAmt = CGFloat((domesticAmount as NSString).floatValue)
                        let finalValue = intAmt + domAmt
                        let progress = intAmt / finalValue
                        print("Progress:- \(progress)")
                        
                        cell.progressView.setProgress( Float(progress), animated: true)
                        
                    }
                    
                    if let internationalTansaction = transactionSummaryApi[0].posInternationalTxnCount{
                        cell.lblTransctn1.text = "\(internationalTansaction) " + "Transactions".localiz()
                    }
                    
                    if let domesticTansaction = transactionSummaryApi[0].posDomesticTxnCount{
                        cell.lblTrnsctn2.text = "\(domesticTansaction) " + "Transactions".localiz()
                    }
                }
            }
            
            
            if AppConstants.language == .ar{

                cell.lblTitle1.textAlignment = .right
                cell.lblTitle2.textAlignment = .left
                cell.lblAmount1.textAlignment = NSTextAlignment.right
                cell.lblAmount2.textAlignment = NSTextAlignment.left
                cell.lblTransctn1.textAlignment = NSTextAlignment.right
                cell.lblTrnsctn2.textAlignment = NSTextAlignment.left
                
            } else {

                cell.lblTitle1.textAlignment = .left
                cell.lblTitle2.textAlignment = .right
                cell.lblAmount1.textAlignment = NSTextAlignment.left
                cell.lblAmount2.textAlignment = NSTextAlignment.right
                cell.lblTransctn1.textAlignment = NSTextAlignment.left
                cell.lblTrnsctn2.textAlignment = NSTextAlignment.right
            }
            
            return cell
        }
        if collectionView == ecommDetailCvRef{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ecommDetailCell", for: indexPath) as! EcommDetailCVC
            cell.progressView.layer.cornerRadius = 5
            cell.progressView.clipsToBounds = true
            cell.progressView.layer.sublayers![1].cornerRadius = 5
            cell.progressView.subviews[1].clipsToBounds = true
            
            if indexPath.row == 0{
                cell.lblTitle1.text = "Debit Card".localiz()
                cell.lblTitle2.text = "Credit Card".localiz()
                let count = transactionSummaryApi.count
                
                if count != 0{
                    
                    if let txnDebitAmount = transactionSummaryApi[0].ecommDebitCardAmt{
                        cell.lblAmount1.text = "KD " + (self.setAmounts(amount: txnDebitAmount))
                        
                        cell.lblAmount1.attributedText = cell.lblAmount1.text!.attributedString(fontsize: 15)
                    }
                    
                    if let txnCreditAmount = transactionSummaryApi[0].ecommAmt{
                        cell.lblAmount2.text = "KD " + (self.setAmounts(amount: txnCreditAmount))
                        
                        cell.lblAmount2.attributedText = cell.lblAmount2.text!.attributedString(fontsize: 15)
                    }
                    if let creditAmount = transactionSummaryApi[0].ecommAmt, let debitAmount = transactionSummaryApi[0].ecommDebitCardAmt{
                        let credAmt = CGFloat((creditAmount as NSString).floatValue)
                        let debAmt = CGFloat((debitAmount as NSString).floatValue)
                        let finalValue = debAmt + credAmt
                        let progress = debAmt / finalValue
                        print("Progress:- \(progress)")
                        
                        cell.progressView.setProgress( Float(progress), animated: true)
                        
                    }
                    
                    if let debitTansaction = transactionSummaryApi[0].ecommDebitCardTxnCount{
                        cell.lblTransctn1.text = "\(debitTansaction) " + "Transactions".localiz()
                    }
                    
                    if let creditTansaction = transactionSummaryApi[0].ecommTxnCount{
                        cell.lblTrnsctn2.text = "\(creditTansaction) " + "Transactions".localiz()
                    }
                }
                
            }
            if indexPath.row == 1{
                cell.lblTitle1.text = "International".localiz()
                cell.lblTitle2.text = "Domestic".localiz()
                let count = transactionSummaryApi.count
                
                if count != 0{
                    
                    if let txnInternationalAmount = transactionSummaryApi[0].ecommInternationalAmt{
                        cell.lblAmount1.text = "KD " + (self.setAmounts(amount: txnInternationalAmount))
                        
                        cell.lblAmount1.attributedText = cell.lblAmount1.text!.attributedString(fontsize: 15)
                    }
                    
                    if let txnDomesticAmount = transactionSummaryApi[0].ecommDomesticAmt{
                        cell.lblAmount2.text = "KD " + (self.setAmounts(amount: txnDomesticAmount))
                        
                        cell.lblAmount2.attributedText = cell.lblAmount2.text!.attributedString(fontsize: 15)
                    }
                    if let internationalAmount = transactionSummaryApi[0].ecommInternationalAmt, let domesticAmount = transactionSummaryApi[0].ecommDomesticAmt{
                        let intAmt = CGFloat((internationalAmount as NSString).floatValue)
                        let domAmt = CGFloat((domesticAmount as NSString).floatValue)
                        let finalValue = intAmt + domAmt
                        let progress = intAmt / finalValue
                        print("Progress:- \(progress)")
                        
                        cell.progressView.setProgress( Float(progress), animated: true)
                        
                    }
                    
                    if let internationalTansaction = transactionSummaryApi[0].ecommInternationalTxnCount{
                        cell.lblTransctn1.text = "\(internationalTansaction) " + "Transactions".localiz()
                    }
                    
                    if let domesticTansaction = transactionSummaryApi[0].ecommDomesticTxnCount{
                        cell.lblTrnsctn2.text = "\(domesticTansaction) " + "Transactions".localiz()
                    }
                }
                
            }
            
            if AppConstants.language == .ar{

                cell.lblTitle1.textAlignment = .right
                cell.lblTitle2.textAlignment = .left
                cell.lblAmount1.textAlignment = NSTextAlignment.right
                cell.lblAmount2.textAlignment = NSTextAlignment.left
                cell.lblTransctn1.textAlignment = NSTextAlignment.right
                cell.lblTrnsctn2.textAlignment = NSTextAlignment.left
                
            } else {

                cell.lblTitle1.textAlignment = .left
                cell.lblTitle2.textAlignment = .right
                cell.lblAmount1.textAlignment = NSTextAlignment.left
                cell.lblAmount2.textAlignment = NSTextAlignment.right
                cell.lblTransctn1.textAlignment = NSTextAlignment.left
                cell.lblTrnsctn2.textAlignment = NSTextAlignment.right
            }
            
            return cell
        }
        if collectionView == tijaratiDetailCvRef{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tijaratiDetailCell", for: indexPath) as! TijaratiDetailCVC
            cell.progressView.layer.cornerRadius = 5
            cell.progressView.clipsToBounds = true
            cell.progressView.layer.sublayers![1].cornerRadius = 5
            cell.progressView.subviews[1].clipsToBounds = true
            
            if indexPath.row == 0{
                cell.lblTitle1.text = "Debit Card".localiz()
                cell.lblTitle2.text = "Credit Card".localiz()
                let count = transactionSummaryApi.count
                
                if count != 0{
                    
                    if let txnDebitAmount = transactionSummaryApi[0].eZPayDebitCardAmt{
                        cell.lblAmount1.text = "KD " + (self.setAmounts(amount: txnDebitAmount))
                        
                        cell.lblAmount1.attributedText = cell.lblAmount1.text!.attributedString(fontsize: 15)
                    }
                    
                    if let txnCreditAmount = transactionSummaryApi[0].eZPayAmt{
                        cell.lblAmount2.text = "KD " + (self.setAmounts(amount: txnCreditAmount))
                        
                        cell.lblAmount2.attributedText = cell.lblAmount2.text!.attributedString(fontsize: 15)
                    }
                    if let creditAmount = transactionSummaryApi[0].eZPayAmt, let debitAmount = transactionSummaryApi[0].eZPayDebitCardAmt{
                        let credAmt = CGFloat((creditAmount as NSString).floatValue)
                        let debAmt = CGFloat((debitAmount as NSString).floatValue)
                        let finalValue = debAmt + credAmt
                        let progress = debAmt / finalValue
                        print("Progress:- \(progress)")
                        
                        cell.progressView.setProgress( Float(progress), animated: true)
                        
                    }
                    
                    if let debitTansaction = transactionSummaryApi[0].eZPayDebitCardTxnCount{
                        cell.lblTransctn1.text = "\(debitTansaction) " + "Transactions".localiz()
                    }
                    
                    if let creditTansaction = transactionSummaryApi[0].eZPayTxnCount{
                        cell.lblTrnsctn2.text = "\(creditTansaction) " + "Transactions".localiz()
                    }
                }
            }
            if indexPath.row == 1{
                cell.lblTitle1.text = "International".localiz()
                cell.lblTitle2.text = "Domestic".localiz()
                let count = transactionSummaryApi.count
                
                if count != 0{
                    
                    if let txnInternationalAmount = transactionSummaryApi[0].eZPayInternationalAmt{
                        cell.lblAmount1.text = "KD " + (self.setAmounts(amount: txnInternationalAmount))
                        
                        cell.lblAmount1.attributedText = cell.lblAmount1.text!.attributedString(fontsize: 15)
                    }
                    
                    if let txnDomesticAmount = transactionSummaryApi[0].eZPayDomesticAmt{
                        cell.lblAmount2.text = "KD " + (self.setAmounts(amount: txnDomesticAmount))
                        
                        cell.lblAmount2.attributedText = cell.lblAmount2.text!.attributedString(fontsize: 15)
                    }
                    if let internationalAmount = transactionSummaryApi[0].eZPayInternationalAmt, let domesticAmount = transactionSummaryApi[0].eZPayDomesticAmt{
                        let intAmt = CGFloat((internationalAmount as NSString).floatValue)
                        let domAmt = CGFloat((domesticAmount as NSString).floatValue)
                        let finalValue = intAmt + domAmt
                        let progress = intAmt / finalValue
                        print("Progress:- \(progress)")
                        
                        cell.progressView.setProgress( Float(progress), animated: true)
                        
                    }
                    
                    if let internationalTansaction = transactionSummaryApi[0].eZPayInternationalTxnCount{
                        cell.lblTransctn1.text = "\(internationalTansaction) " + "Transactions".localiz()
                    }
                    
                    if let domesticTansaction = transactionSummaryApi[0].eZPayDomesticTxnCount{
                        cell.lblTrnsctn2.text = "\(domesticTansaction) " + "Transactions".localiz()
                    }
                }
            }
            
            if AppConstants.language == .ar{

                cell.lblTitle1.textAlignment = .right
                cell.lblTitle2.textAlignment = .left
                cell.lblAmount1.textAlignment = NSTextAlignment.right
                cell.lblAmount2.textAlignment = NSTextAlignment.left
                cell.lblTransctn1.textAlignment = NSTextAlignment.right
                cell.lblTrnsctn2.textAlignment = NSTextAlignment.left
                
            } else {

                cell.lblTitle1.textAlignment = .left
                cell.lblTitle2.textAlignment = .right
                cell.lblAmount1.textAlignment = NSTextAlignment.left
                cell.lblAmount2.textAlignment = NSTextAlignment.right
                cell.lblTransctn1.textAlignment = NSTextAlignment.left
                cell.lblTrnsctn2.textAlignment = NSTextAlignment.right
            }
            
            return cell
        }
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width - 10, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == posDetailCvRef{
            posPageControlRef?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
            
        }else if scrollView == ecommDetailCvRef{
            ecommPageControlRef?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
            
        }else if scrollView == tijaratiDetailCvRef{
            tijaratiPageControlRef?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
            
        }
        
    }
    
    
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView == posDetailCvRef{
            posPageControlRef?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        }else if scrollView == ecommDetailCvRef{
            ecommPageControlRef?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        }else if scrollView == tijaratiDetailCvRef{
            tijaratiPageControlRef?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        }
    }
    
}

extension CALayer {
    
    func addTopBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
            
        case UIRectEdge.bottom:
            border.frame = CGRect(x:0, y: frame.height - thickness, width: frame.width, height:thickness)
            
        case UIRectEdge.left:
            border.frame = CGRect(x:0, y:0, width: thickness, height: frame.height)
            
        case UIRectEdge.right:
            border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
            
        default: do {}
        }
        
        border.backgroundColor = color.cgColor
        
        addSublayer(border)
    }
}
