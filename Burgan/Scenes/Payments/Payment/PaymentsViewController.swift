//
//  PaymentsViewController.swift
//  Burgan
//
//  Created by Mayank on 05/07/21.
//  Copyright © 2021 1st iMac. All rights reserved.
//

import UIKit
import MBProgressHUD

class PaymentsViewController: UIViewController {
    
    lazy var _setupUIOnce: () = { self.setupUIOnce() }()
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var btnNavMenu: UIButton!
    @IBOutlet weak var cvSales: UICollectionView!
    @IBOutlet weak var lblSalesTransactions: UILabel!
    @IBOutlet weak var lblSalesAmount: UILabel!
    @IBOutlet weak var pagerControl: UIPageControl!
    @IBOutlet weak var lblSales: UILabel!
    @IBOutlet weak var lblpays: UILabel!
    @IBOutlet weak var ivSalesCardBg: UIImageView!
    @IBOutlet weak var eZpatCvRef: UICollectionView!
    @IBOutlet weak var transactionTvRef: UITableView!
    @IBOutlet weak var recentTransactionBtnRef: UIButton!
    @IBOutlet weak var bulkTransactionBtnRef: UIButton!
    @IBOutlet weak var transactionTvHeightRef: NSLayoutConstraint!
    
    @IBOutlet weak var initialPaymentBtnRef: UIButton!
    
    @IBOutlet weak var dateDropDownBtnRef: UIButton!
    @IBOutlet weak var tidNoDropDownBtnRef: UIButton!
    
    var showRecentTransaction = true
    var showBulkTransaction = false
    
    //DATE DROP DOWN VIEW
    @IBOutlet weak var dateViewRef: UIView!
    
    //CARD VIEW
    @IBOutlet weak var eZpayCardViewRef: UIView!
    @IBOutlet weak var transactionCardViewRef: UIView!
    
    //Gauge Meter Page Indicator
    @IBOutlet weak var gaugeMeterPageControlRef: UIPageControl!
    
    //api
    var viewModel : RegistrationViewControllerViewModelProtocol?
    var salesSummaryViewModel : RegistrationViewControllerViewModelProtocol?
    var salesGraphViewModel : RegistrationViewControllerViewModelProtocol?
    
    var recentTransactionData = SingleTransactionApi()
    var bulkTransactionData = FileUploadHistoryResponse()
    var PaymentSalesSummaryData = PaymentSalesSummaryApi()
    var paymentGraphData = PaymentGraphApi()
    
    var hud: MBProgressHUD = MBProgressHUD()
    
    
    let yourAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 12),
        .foregroundColor: #colorLiteral(red: 0.4980392157, green: 0.6156862745, blue: 0.7215686275, alpha: 1),
        .underlineStyle: NSUnderlineStyle.single.rawValue
    ]
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        TidPopupVC.instance.setListener(listener: self)
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if AppConstants.jsonStartDate == "" || AppConstants.jsonEndDate == "" {
            currentMonthData()
        } else {
            let startDate = AppConstants.jsonStartDate.dateFromFormat("yyyy-MM-dd")
            let endDate = AppConstants.jsonEndDate.dateFromFormat("yyyy-MM-dd")
            
            if AppConstants.jsonStartDate == AppConstants.jsonEndDate {
                let selectedDateRange = startDate!.monthh.prefix(3) + " - " + String(endDate!.day) + ", " + endDate!.yearr
                dateDropDownBtnRef.setTitle(selectedDateRange, for: .normal)
                
            } else {
                
                let startDate = startDate!.monthh.prefix(3) + " " + String(startDate!.day) + " - "
                let endDate = endDate!.monthh.prefix(3) + " " + String(endDate!.day) + ", " + endDate!.yearr
                let selectedDateRange = startDate + endDate
                dateDropDownBtnRef.setTitle(selectedDateRange, for: .normal)
            }
        }
        tidNoDropDownBtnRef.setTitle(AppConstants.cifCompanyName == "" ? "Payments" : AppConstants.cifCompanyName, for: .normal)
        arabicSetup()
        // API Call
        paymentGraph()
        
    }
    
    func showMBProgressHud(hudView: UIView) {
        
        hud = MBProgressHUD.showAdded(to: hudView, animated: true)

        // hud.bezelView.layer.cornerRadius = 5
        // hud.bezelView.backgroundColor = .clear
        // hud.backgroundView.style = .solidColor
        // hud.backgroundView.color = UIColor(white: 0, alpha: 0.3)
        hud.bezelView.color = UIColor.clear // Your backgroundcolor

        hud.bezelView.style = .solidColor // you should change the bezelview style to solid color.

     }
    
    func hideMBProgressHud(hudView: UIView) {
        MBProgressHUD.hide(for: hudView, animated: true)
    }
    
    @IBAction func tidButtonAction(_ sender: Any) {
        let controller = UIStoryboard.init(name: "TidPopup", bundle: Bundle.main).instantiateViewController(withIdentifier: "TidPopupVC") as? TidPopupVC
        controller?.modalPresentationStyle = .overCurrentContext
        present(controller!, animated: true, completion: nil)
    }
    
    @IBAction func openSideMenu(_ sender: Any) {
        if AppConstants.language == .ar {
            self.sideMenuViewController.presentRightMenuViewController()
        } else {
            self.sideMenuViewController.presentLeftMenuViewController()
        }
        
        //self.sideMenuViewController.presentLeftMenuViewController()
        
    }
    
    func paymentSalesSummary(){
        salesSummaryViewModel = RegistrationViewControllerViewModel()
        
        let param : [String : Any] = [
            "type" : "mid",
            "cif" : AppConstants.UserData.companyCIF,
            "eZPayOutletNumber": AppConstants.ezpayOutletNumber,
            "deviceId": AppConstants.UserData.deviceID,
            "startDate" : AppConstants.jsonStartDate,
            "endDate" : AppConstants.jsonEndDate,
        ]
        // MBProgressHUD.showAdded(to: self.ivSalesCardBg, animated: true)
        showMBProgressHud(hudView: self.ivSalesCardBg)
        
        self.salesSummaryViewModel?.serviceRequest(param: param, apiName: RequestItemsType.paymentSalesSummary)
        paymentSalesSummaryApi()
        
    }
    
    func paymentGraph(){
        salesGraphViewModel = RegistrationViewControllerViewModel()
        
        let param : [String : Any] = [
            "type" : "mid",
            "cif" : AppConstants.UserData.companyCIF,
            "eZPayOutletNumber": AppConstants.ezpayOutletNumber,
            "deviceId": AppConstants.UserData.deviceID,
            "startDate" : AppConstants.jsonStartDate,
            "endDate" : AppConstants.jsonEndDate,
        ]
//        MBProgressHUD.showAdded(to: self.eZpayCardViewRef, animated: true)
        showMBProgressHud(hudView: self.eZpayCardViewRef)
        
        self.salesGraphViewModel?.serviceRequest(param: param, apiName: RequestItemsType.paymentSalesGraph)
        paymentSalesGraphApi()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        gaugeMeterPageControlRef?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        gaugeMeterPageControlRef?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    
    
}

extension PaymentsViewController {
    
    func setupUI() {
        transactionTvRef.separatorStyle = .none
        transactionTvRef.tableFooterView = UIView()
        
        recentTransactionBtnRef.layer.borderWidth = 1
        bulkTransactionBtnRef.layer.borderWidth = 1
        
        recentTransactionBtnRef.layer.borderColor = UIColor.init(hexString: "005B9D").cgColor // #colorLiteral(red: 0, green: 0.3568627451, blue: 0.6156862745, alpha: 1)
        bulkTransactionBtnRef.layer.borderColor = UIColor.init(hexString: "005B9D").cgColor // #colorLiteral(red: 0, green: 0.3555235369, blue: 0.6150870715, alpha: 1)
        
        recentTransactionBtnRef.layer.cornerRadius = 5
        bulkTransactionBtnRef.layer.cornerRadius = 5
        
        initialPaymentBtnRef.layer.cornerRadius = 5
        
        self.navigationController?.navigationBar.isHidden = true
        
        dateDropDownBtnRef.addRightIcon(image: UIImage(named: "downblack")!)
        tidNoDropDownBtnRef.addRightIcon(image: UIImage(named: "Icon WhiteDown")!)
        lblSalesAmount.attributedText = lblSalesAmount.text!.attributedString(fontsize: 20)
        
        ///DATE VIEW
        dateViewRef.layer.cornerRadius = 15
        dateViewRef.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        currentMonthData()
        
        ///CARD VIEW CORNER RADIUS
        curvedviewShadow(view: eZpayCardViewRef)
        curvedviewShadow(view: transactionCardViewRef)
        
    }
    
    func arabicSetup(){
        lblSales.text = lblSales.text?.localiz()
        lblpays.text = lblpays.text?.localiz()
        initialPaymentBtnRef.setTitle("INITIATE PAYMENT".localiz(), for: .normal)
        recentTransactionBtnRef.setTitle("Recent".localiz(), for: .normal)
        bulkTransactionBtnRef.setTitle("Bulk".localiz(), for: .normal)
        if AppConstants.language == .ar {
            recentTransactionBtnRef.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner]
            bulkTransactionBtnRef.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            lblSalesAmount.textAlignment = .right
            lblSales.textAlignment = .right
            lblSalesTransactions.textAlignment = .right
        } else {
            recentTransactionBtnRef.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            bulkTransactionBtnRef.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
            lblSalesAmount.textAlignment = .left
            lblSales.textAlignment = .left
            lblSalesTransactions.textAlignment = .left
        }
        
    }
    
    func setupLayout() {
        _ = _setupUIOnce
    }
    
    func setupUIOnce() {
        
    }
    
    func reloadTable(){
        if showRecentTransaction{
            if recentTransactionData.transaction?.count != 0 && recentTransactionData.transaction?.count != nil{
                let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: transactionTvRef.bounds.size.width, height: transactionTvRef.bounds.size.height))
                noDataLabel.text          = ""
                transactionTvRef.backgroundView  = noDataLabel
            }else{
                let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: transactionTvRef.bounds.size.width, height: transactionTvRef.bounds.size.height))
                noDataLabel.text          = "No Data Available".localiz()
                noDataLabel.textColor     = .black
                noDataLabel.textAlignment = .center
                noDataLabel.numberOfLines = 0
                transactionTvRef.backgroundView  = noDataLabel
                transactionTvRef.isScrollEnabled = false
            }
        }else if showBulkTransaction{
            if bulkTransactionData.transaction?.count != 0 && bulkTransactionData.transaction?.count != nil{
                let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: transactionTvRef.bounds.size.width, height: transactionTvRef.bounds.size.height))
                noDataLabel.text          = ""
                transactionTvRef.backgroundView  = noDataLabel
            }else{
                let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: transactionTvRef.bounds.size.width, height: transactionTvRef.bounds.size.height))
                noDataLabel.text          = "No Data Available".localiz()
                noDataLabel.textColor     = .black
                noDataLabel.textAlignment = .center
                noDataLabel.numberOfLines = 0
                transactionTvRef.backgroundView  = noDataLabel
                transactionTvRef.isScrollEnabled = false
            }
        }
        transactionTvRef.reloadData()
    }
    
    func curvedviewShadow(view:UIView){
        
        view.layer.cornerRadius = 8
        view.layer.shadowOpacity = 0.35
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowRadius = 3.0
        view.layer.shadowColor = UIColor.BurganColor.brandGray.lgiht.cgColor
        view.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner,.layerMaxXMinYCorner]
    }
    
    //    func currentMonthData() {
    //
    //        let startDate = AppConstants.jsonStartDate.dateFromFormat("yyyy-MM-dd") ?? Date()
    //        let endDate = AppConstants.jsonEndDate.dateFromFormat("yyyy-MM-dd") ?? Date()
    //
    //        if AppConstants.jsonStartDate == AppConstants.jsonEndDate {
    //            let selectedDateRange = startDate.monthh.prefix(3) + " - " + String(endDate.day) + ", " + endDate.yearr
    //
    //            dateDropDownBtnRef.setTitle(selectedDateRange, for: .normal)
    //
    //        } else {
    //
    //            let selectedDateRange = startDate.monthh.prefix(3) + " " + String(startDate.day) + " - "
    //            let myEndDate = endDate.monthh.prefix(3) + String(endDate.day) + ", " + endDate.yearr
    //
    //            dateDropDownBtnRef.setTitle(selectedDateRange + myEndDate, for: .normal)
    //        }
    //    }
    
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
        dateDropDownBtnRef.setTitle(selectedDateRange, for: .normal)
    }
    
}

//MARK:- BUTTON ACTION
extension PaymentsViewController{
    
    @IBAction func initiatePaymentBtnTap(_ sender: UIButton){
        let vc = InitiatePaymentViewController(nibName: "InitiatePaymentViewController", bundle: nil)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func recentTransactionBtnTap(_ sender: UIButton){
        recentTransactionBtnRef.backgroundColor = UIColor.init(hexString: "005B9D") // #colorLiteral(red: 0, green: 0.3568627451, blue: 0.6156862745, alpha: 1)
        bulkTransactionBtnRef.backgroundColor = .white
        
        recentTransactionBtnRef.setTitleColor(UIColor.white, for: .normal)
        bulkTransactionBtnRef.setTitleColor(UIColor.init(hexString: "005B9D"), for: .normal)
        
        showRecentTransaction = true
        showBulkTransaction = false
        
        viewModel = RegistrationViewControllerViewModel()
        
        let param : [String : Any] = [
            "type":"mid",
            "cif" : AppConstants.UserData.companyCIF,
            "eZPayOutletNumber": AppConstants.ezpayOutletNumber,
            "merchantNum": AppConstants.merchantNumber,
            "deviceId": AppConstants.UserData.deviceID,
            "startDate" : AppConstants.jsonStartDate,
            "endDate" : AppConstants.jsonEndDate,
            "cardType" : "SingleTransaction",
            "txnStatus": "Success"
        ]
//        MBProgressHUD.showAdded(to: self.transactionCardViewRef, animated: true)
        showMBProgressHud(hudView: self.transactionCardViewRef)
        
        self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.bulkTransaction)
        recentTransactionApi()
        
        transactionTvRef.reloadData()
    }
    
    @IBAction func bulkTransactionBtnTap(_ sender: UIButton){
        recentTransactionBtnRef.backgroundColor = .white
        bulkTransactionBtnRef.backgroundColor = UIColor.init(hexString: "005B9D") // #colorLiteral(red: 0, green: 0.3555235369, blue: 0.6150870715, alpha: 1)
        
        bulkTransactionBtnRef.setTitleColor(UIColor.white, for: .normal)
        recentTransactionBtnRef.setTitleColor(UIColor.init(hexString: "005B9D"), for: .normal)
        
        
        showRecentTransaction = false
        showBulkTransaction = true
        
        previousOrderAPI()
        
        
        reloadTable()
    }
    
    @IBAction func selectDateBtnTap(_ sender: UIButton) {
        
        let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CalendarPopupViewController") as? CalendarPopupViewController
        controller?.popuptype = 0
        controller?.calendarClockdelegate = self
        presentAsStork(controller!, height: 650, cornerRadius: 8, showIndicator: false, showCloseButton: false)
    }
}

//MARK:- CALENDER FUNC
extension PaymentsViewController: calendarDelegate{
    func selectDateRange(startDate: Date, endDate: Date) {
        if startDate == endDate {
            AppConstants.jsonStartDate = startDate.stringFromFormat("yyyy-MM-dd")
            AppConstants.jsonEndDate = endDate.stringFromFormat("yyyy-MM-dd")
            let selectedDateRange = startDate.monthh.prefix(3) + " - " + String(startDate.day) + ", " + startDate.yearr
            dateDropDownBtnRef.setTitle(selectedDateRange, for: .normal)
            
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
            dateDropDownBtnRef.setTitle(sDate + " - " + eDate + " " + endDate.yearr, for: .normal)
        }
        
        paymentGraph()
        
    }
    
    func selectTimeRange(startTimeValue: String, endTimeValue: String, statTimeAMPM: String, endTimeAMPM: String) {
        
    }
    
    
}

//MARK:- COLLECTIONVIEW METHODS
extension PaymentsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cvSales{
            let count = 1
            pagerControl.numberOfPages = count
            pagerControl.isHidden = !(count > 1)
            return count
        }
        let count = 2
        gaugeMeterPageControlRef.numberOfPages = count
        gaugeMeterPageControlRef.isHidden = !(count > 1)
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == cvSales{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cvSalesCell", for: indexPath) as! cvSalesCell
            
            cell.progressView.layer.cornerRadius = 5
            cell.progressView.clipsToBounds = true
            cell.progressView.layer.sublayers![1].cornerRadius = 5
            cell.progressView.subviews[1].clipsToBounds = true
            
            if let creditAmount = PaymentSalesSummaryData.ezPayCreditAmt, let creditTansaction = PaymentSalesSummaryData.ezPayCreditTxnCount{
                cell.lblAmount1.text = "KD " + setAmounts(amount: creditAmount)
                
                cell.lblTransctn1.text = creditTansaction + "Transactions".localiz()
            }else{
                cell.lblAmount1.text = "KD " + setAmounts(amount: "0.000")
                cell.lblTransctn1.text = "0" + " " + "Transactions".localiz()
            }
            cell.lblAmount1.attributedText = cell.lblAmount1.text!.attributedString(fontsize: 17)
            
            if let debitAmount = PaymentSalesSummaryData.ezPayDebitAmt, let debitTansaction = PaymentSalesSummaryData.ezPayDebitTxnCount{
                cell.lblAmount2.text = "KD " + setAmounts(amount: debitAmount)
                
                cell.lblTrnsctn2.text = debitTansaction + "Transactions".localiz()
            }else{
                cell.lblAmount2.text = "KD " + setAmounts(amount: "0.000")
                cell.lblTrnsctn2.text = "0" + " " + "Transactions".localiz()
            }
            cell.lblAmount2.attributedText = cell.lblAmount2.text!.attributedString(fontsize: 17)
            
            if let creditAmount = PaymentSalesSummaryData.ezPayCreditAmt, let debitAmount = PaymentSalesSummaryData.ezPayDebitAmt, let totalAmount = PaymentSalesSummaryData.ezPayTotalAmount{
                let credAmt = CGFloat((creditAmount as NSString).floatValue)
                let debAmt = CGFloat((debitAmount as NSString).floatValue)
                let totalAmt = CGFloat((totalAmount as NSString).floatValue)
                let finalValue = debAmt + credAmt
                let progress = debAmt / finalValue
                print("Progress:- \(progress)")
                
                cell.progressView.setProgress( Float(progress), animated: true)
                
            }
            
            if AppConstants.language == .ar{
                cell.lblTitle1.textAlignment = .right
                cell.lblTitle2.textAlignment = .left
                cell.lblAmount1.textAlignment = .right
                cell.lblAmount2.textAlignment = .left
                cell.lblTransctn1.textAlignment = .right
                cell.lblTrnsctn2.textAlignment = .left
            }else{
                cell.lblTitle1.textAlignment = .left
                cell.lblTitle2.textAlignment = .right
                cell.lblAmount1.textAlignment = .left
                cell.lblAmount2.textAlignment = .right
                cell.lblTransctn1.textAlignment = .left
                cell.lblTrnsctn2.textAlignment = .right
            }
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eZpayCell", for: indexPath) as! eZpayCVC
        
        if indexPath.row == 0 {
            
            cell.leftTitleLabel.text = "Available Balance".localiz()
            cell.rightTitleLabel.text = "Amount".localiz()
            
            cell.gaugeMeterViewRef.numberOfMajorTicks = 10
            cell.gaugeMeterViewRef.numberOfMinorTicks = 3
            cell.gaugeMeterViewRef.gaugeAngle = 90
            cell.gaugeMeterViewRef.gaugeTrackColor = UIColor.init(hexString: "005B9D")
            cell.gaugeMeterViewRef.gaugeTrackWidth = 25
            cell.gaugeMeterViewRef.gaugeValueTrackWidth = 25
            cell.gaugeMeterViewRef.gaugeType = .gauge
            
            
            if let maxValue = paymentGraphData.eZPayTotalAmount,let availableAmountValue = paymentGraphData.eZPayAvailableBalance{
                cell.gaugeMeterViewRef.gaugeMaxValue = 100
                let maxvalue = CGFloat((maxValue as NSString).floatValue) == 0.0 ? 100.0 : CGFloat((maxValue as NSString).floatValue)
                let value = (CGFloat((availableAmountValue as NSString).floatValue)/maxvalue) * 100
                cell.gaugeMeterViewRef.gaugeValue = value
            }
            
            if let availableBalance = paymentGraphData.eZPayAvailableBalance{
                cell.availableBalanceLblRef.text = "KD " + setAmounts(amount: availableBalance)
            }
            cell.availableBalanceLblRef.attributedText =  cell.availableBalanceLblRef.text!.attributedString(fontsize: 15)
            
            if let totalAmount = paymentGraphData.eZPayTotalAmount{
                cell.totalAmountLblRef.text = "KD " + setAmounts(amount: totalAmount)
            }
            cell.totalAmountLblRef.attributedText =  cell.totalAmountLblRef.text!.attributedString(fontsize: 15)
            
            if let expiresOn = paymentGraphData.eZPayExpireOn{
                ///FORMATTING DATE
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd" // "dd-MM-yyyy"
                
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "dd MMM"
                if let date = dateFormatterGet.date(from: expiresOn) {
                    let formatedExpireDate = dateFormatterPrint.string(from: date)
                    cell.expireOnLblRef.text = "expires on".localiz() + " \(formatedExpireDate)"
                    
                } else {
                    cell.expireOnLblRef.text = "expires on".localiz()
                    print("There was an error decoding the string")
                }
            }
            
            if AppConstants.language == .ar{
                cell.leftTitleLabel.textAlignment = .right
                cell.rightTitleLabel.textAlignment = .left
                cell.totalAmountLblRef.textAlignment = .left
                cell.availableBalanceLblRef.textAlignment = .right
                cell.expireOnLblRef.textAlignment = .left
            }else{
                cell.leftTitleLabel.textAlignment = .left
                cell.rightTitleLabel.textAlignment = .right
                cell.totalAmountLblRef.textAlignment = .right
                cell.availableBalanceLblRef.textAlignment = .left
                cell.expireOnLblRef.textAlignment = .right
            }
            
        }
        if indexPath.row == 1 {
            
            cell.leftTitleLabel.text = "Available Transactions".localiz()
            cell.rightTitleLabel.text = "Total Transactions".localiz()
            
            cell.gaugeMeterViewRef.numberOfMajorTicks = 10
            cell.gaugeMeterViewRef.numberOfMinorTicks = 3
            cell.gaugeMeterViewRef.gaugeAngle = 90
            cell.gaugeMeterViewRef.gaugeTrackColor = UIColor.init(hexString: "005B9D")
            cell.gaugeMeterViewRef.gaugeTrackWidth = 25
            cell.gaugeMeterViewRef.gaugeValueTrackWidth = 25
            cell.gaugeMeterViewRef.gaugeType = .gauge
            
            
            if let maxValue = paymentGraphData.eZPayTransactionLimit,let availableTransactionLimitValue = paymentGraphData.eZPayAvailableTransactionLimit{
                cell.gaugeMeterViewRef.gaugeMaxValue = 100
                let maxvalue = CGFloat((maxValue as NSString).floatValue) == 0.0 ? 100.0 : CGFloat((maxValue as NSString).floatValue)
                let value = (CGFloat((availableTransactionLimitValue as NSString).floatValue)/maxvalue) * 100
                cell.gaugeMeterViewRef.gaugeValue = value
                
            }
            
            if let availableBalance = paymentGraphData.eZPayAvailableTransactionLimit{
                cell.availableBalanceLblRef.text = availableBalance //"KD " + setAmounts(amount: availableBalance)
            }
            // cell.availableBalanceLblRef.attributedText =  cell.availableBalanceLblRef.text!.attributedString(fontsize: 15)
            
            if let totalAmount = paymentGraphData.eZPayTransactionLimit{
                cell.totalAmountLblRef.text = totalAmount // "KD " + setAmounts(amount: totalAmount)
            }
            // cell.totalAmountLblRef.attributedText =  cell.totalAmountLblRef.text!.attributedString(fontsize: 15)
            
            if let expiresOn = paymentGraphData.eZPayTransactionLimitExpireOn{
                ///FORMATTING DATE
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd"
                
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "dd MMM"
                if let date = dateFormatterGet.date(from: expiresOn) {
                    let formatedExpireDate = dateFormatterPrint.string(from: date)
                    cell.expireOnLblRef.text = "expires on".localiz() + " \(formatedExpireDate)"
                    
                } else {
                    cell.expireOnLblRef.text = "expires on".localiz()
                    print("There was an error decoding the string")
                }
            }
            
            if AppConstants.language == .ar{
                cell.leftTitleLabel.textAlignment = .right
                cell.rightTitleLabel.textAlignment = .left
                cell.totalAmountLblRef.textAlignment = .left
                cell.availableBalanceLblRef.textAlignment = .right
                cell.expireOnLblRef.textAlignment = .left
            }else{
                cell.leftTitleLabel.textAlignment = .left
                cell.rightTitleLabel.textAlignment = .right
                cell.totalAmountLblRef.textAlignment = .right
                cell.availableBalanceLblRef.textAlignment = .left
                cell.expireOnLblRef.textAlignment = .right
            }
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bound = collectionView.bounds
        
        return CGSize(width: (bound.width/1), height: bound.height)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
        
    }
}

//MARK:- TABLEVIEW METHOD
extension PaymentsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showRecentTransaction{
            if let count = recentTransactionData.transaction?.count{
                transactionTvHeightRef.constant = CGFloat(Float(count * 90))
                return count
            }
        }else if showBulkTransaction{
            if let count = bulkTransactionData.transaction?.count{
                transactionTvHeightRef.constant = CGFloat(Float(count * 90))
                return count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RTransaction", for: indexPath) as! RecentTransactionTVC
        cell.selectionStyle = .none
        
        if showRecentTransaction{
            cell.recentTransactionViewRef.isHidden = false
            cell.bulkTransactionViewRef.isHidden = true
            
            cell.paymentMode1logoImgRef.isHidden = true
            cell.paymentMode2logoImgRef.isHidden = true
            let object = recentTransactionData.transaction?[indexPath.row]
            if let netowrk = object?.network{
                cell.transactionNameLblRef.text = netowrk.lowercased() == "knet" ? "Tijarati Pay" : netowrk
            }
            cell.transactionNameLblRef.text = object?.cardNum ?? ""
            cell.transactionNameLblRef.textAlignment = AppConstants.language == .ar ? .right : .left
            
            switch object?.txnStatus?.lowercased() {
            case "success":
                cell.txnStatusIcon.image = UIImage(named: "success")
                break
                
            case "failed":
                cell.txnStatusIcon.image = UIImage(named: "Same color as declined")
                break
                
            case "void":
                cell.txnStatusIcon.image = UIImage(named: "Icon Void")
                break
                
//            case "inprogress":
//                cell.paymentMode2logoImgRef.image = UIImage(named: "in-progress")
//                break
                
            case "refund":
                cell.txnStatusIcon.image = UIImage(named: "Icon Refunds")
                break
                
            case "linkexpired":
                cell.txnStatusIcon.image = UIImage(named: "Icon link expired1")
                break
                
            case "linkdeclined":
                cell.txnStatusIcon.image = UIImage(named: "Icon link declined")
                break
                
            default:
                cell.txnStatusIcon.image = UIImage(named: "in-progress")
                break
            }
            
            if let amount = object?.amount{
                cell.transactionAmountLblRef.text = "KD " + setAmounts(amount: amount)
                cell.transactionAmountLblRef.attributedText =  cell.transactionAmountLblRef.text!.attributedString(fontsize: 14)
            }
            
            if let transDate = object?.date, let transTime = object?.time {
                //, let txId = recentTransactionData.transaction?[indexPath.row].txnid{
                
                ///FORMATTING DATE
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd"
                
                ///FORMATING TIME
                let timeFormatterGet = DateFormatter()
                timeFormatterGet.dateFormat = "HH:mm:ss"
                
                if let date = dateFormatterGet.date(from: transDate)
                   , let time = timeFormatterGet.date(from: transTime)
                {
                    dateFormatterGet.dateFormat = "dd MMM yyyy"
                    let formatedTransDate = dateFormatterGet.string(from: date)
                    timeFormatterGet.dateFormat = "HH:mm"
                    let formatedTransTime = timeFormatterGet.string(from: time)
                    cell.txId_DateTimeLblRef.text = "TX ID".localiz() + ": \(object?.txnid ?? "N.A.") | \(formatedTransDate) | \(formatedTransTime)"
//                    cell.txId_DateTimeLblRef.text = "TX ID: \(txId) | \(formatedTransDate) | \(formatedTransTime)"
                    
                } else {
                    print("There was an error decoding the string")
                }
            }
            
            
        }else if showBulkTransaction{
            cell.recentTransactionViewRef.isHidden = true
            cell.bulkTransactionViewRef.isHidden = false
            cell.bulkViewAllBtnRef.tag = indexPath.row
            cell.bulkViewAllBtnRef.addTarget(self, action: #selector(bulkViewAllBtnTap(_:)), for: .touchUpInside)
            
            if let accountNo = bulkTransactionData.transaction?[indexPath.row].fileName{
                cell.bulkTransactionNameLblRef.text = accountNo
            }
            
            //            if let amount = bulkTransactionData.transaction?[indexPath.row].amount{
            //                cell.transactionAmountLblRef.text = "KD " + setAmounts(amount: amount)
            //                cell.transactionAmountLblRef.attributedText =  cell.transactionAmountLblRef.text!.attributedString(fontsize: 18)
            //            }
            
            if let contacts = bulkTransactionData.transaction?[indexPath.row].noOfContacts{
                cell.bulkContactLblRef.text = "\(contacts) " + "Customers".localiz()
            }
            
            if let transDate = bulkTransactionData.transaction?[indexPath.row].date, let transTime = bulkTransactionData.transaction?[indexPath.row].time{
                
                //cell.bulkDateTimeLblRef.text = "\(transDate) | \(transTime)"
                
                ///FORMATTING DATE
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd"
                
                ///FORMATING TIME
                let timeFormatterGet = DateFormatter()
                timeFormatterGet.dateFormat = "HH:mm:ss"
                
                if let date = dateFormatterGet.date(from: transDate), let time = timeFormatterGet.date(from: transTime) {
                    dateFormatterGet.dateFormat = "dd MMM yyy"
                    let formatedTransDate = dateFormatterGet.string(from: date)
                    timeFormatterGet.dateFormat = "HH:mm"
                    let formatedTransTime = timeFormatterGet.string(from: time)
                    cell.bulkDateTimeLblRef.text = "\(formatedTransDate) | \(formatedTransTime)"
                    
                } else {
                    print("There was an error decoding the string")
                }
            }
        }
        
        let attributeString = NSMutableAttributedString(
            string: "View All".localiz(),
            attributes: yourAttributes
        )
        cell.bulkViewAllBtnRef.setAttributedTitle(attributeString, for: .normal)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if showRecentTransaction{
            
            let vc = UIStoryboard(name: "Payment", bundle: nil).instantiateViewController(withIdentifier: "TransactionsDetailViewController") as! TransactionsDetailViewController
            vc.modalPresentationStyle = .popover
            let object = recentTransactionData.transaction?[indexPath.row]
            
            if let amount = object?.amount{
                vc.amountValue = "KD " + setAmounts(amount: amount)
            }
            
            if let network = object?.network{
                vc.paymentModeValue = network
            }
            
            if let transDate = object?.date, let transTime = object?.time{
                
                ///FORMATTING DATE
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd"
                
                ///FORMATING TIME
                let timeFormatterGet = DateFormatter()
                timeFormatterGet.dateFormat = "HH:mm:ss"
                
                if let date = dateFormatterGet.date(from: transDate)
                   , let time = timeFormatterGet.date(from: transTime)
                {
                    dateFormatterGet.dateFormat = "dd MMM yyyy"
                    let formatedTransDate = dateFormatterGet.string(from: date)
                    timeFormatterGet.dateFormat = "hh:mm a"
                    let formatedTransTime = timeFormatterGet.string(from: time)
                    vc.dateValue = formatedTransDate
                    vc.timeValue = formatedTransTime
                    
                } else {
                    print("There was an error decoding the string")
                }
            }

            if let transactionId = object?.txnid{
                vc.transactionIdValue = transactionId
            }
            
            if let mobileNumber = object?.mobileNum{
                vc.contackNumberValue = mobileNumber
            }
            
            if let transactionStatus = object?.txnStatus{
                vc.statusValue = transactionStatus
            }
            
            vc.descriptionValue = object?.transactionDescription ?? ""
            
            vc.paymentURL = object?.paymentURL ?? ""
            
            vc.emailIdValue = object?.email ?? ""
            
            vc.payerNameValue = object?.payerName ?? ""
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func bulkViewAllBtnTap(_ sender: UIButton){
        let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CardTransactionListViewController") as? CardTransactionListViewController
        controller?.cardType = "bulkTransactionViewAll"
        controller?.fileName = bulkTransactionData.transaction?[sender.tag].fileName ?? ""
        controller?.noOfContact = "\(bulkTransactionData.transaction?[sender.tag].noOfContacts ?? "") " + "Customers".localiz()
        controller?.bulkSmsRefId = bulkTransactionData.transaction?[sender.tag].bulkSMSRefID ?? ""
        controller?.isFromPayment = true
        controller?.startDate =  AppConstants.jsonStartDate
        controller?.endDate = AppConstants.jsonEndDate
        controller?.txnStatus = "Success"
        controller?.titleStr = "Bulk".localiz() + " Transaction List".localiz()
        self.navigationController?.pushViewController(controller!, animated: false)
        
    }
    
}

extension PaymentsViewController{
    func previousOrderAPI() {
        
        viewModel = RegistrationViewControllerViewModel()
        
        let merchantNumber = AppConstants.merchantNumber.map { String($0) }
        
        let param : [String : Any] = [
            "type" : "mid",
            "cif" : AppConstants.UserData.companyCIF,
            "merchantNum" : merchantNumber,
            "deviceId": AppConstants.UserData.deviceID
        ]
        
//        MBProgressHUD.showAdded(to: self.view, animated: true)
        showMBProgressHud(hudView: self.view)

        self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.fileUploadHistory)
        bindFileUploadHistoryAPI()
    }
    
    func bindFileUploadHistoryAPI(){
        
        self.viewModel?.alertMessage.bind({ [weak self] in
            self?.hideMBProgressHud(hudView: self!.view)
            
            self?.showAlertDismissOnly(message: $0)
        })
        
        
        self.viewModel?.response.bind({ [weak self] in
            
            if let response = $0 {
                
                self?.hideMBProgressHud(hudView: self!.view)
                
                if   let userStatus = DataDecryption().decryption(jsonModel: PayloadRes(iv: response.iv, payload: response.payload))
                {
                    let status : String = userStatus.value(forKey: "status") as? String ?? ""
                    if status == "" {
                        
                        let merchantNumber = AppConstants.merchantNumber.map { String($0) }
                        
                        let param : [String : Any] = [
                            "type" : "mid",
                            "cif" : AppConstants.UserData.companyCIF,
                            "merchantNum" : merchantNumber,
                            "deviceId": AppConstants.UserData.deviceID
                        ]
                        
                        self?.showMBProgressHud(hudView: self!.view)

                        self!.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.fileUploadHistory)
                        self?.bindFileUploadHistoryAPI()
                        
                    } else {
                        
                        let message : String = userStatus.value(forKey: "message") as! String
                        let status : String = userStatus.value(forKey: "status") as! String
                        if status == "Success"{
                            let errorCode : String = userStatus.value(forKey: "errorCode") as! String
                            if errorCode == "L128"{
                                print("Message:-\(message)")
                                let object = self!.decodeResult(model: FileUploadHistoryResponse.self, result: userStatus)
                                if let objectModel = object.model{
                                    self?.bulkTransactionData = objectModel
                                }
                                print("MYDATA:- \(userStatus.allKeys)")
                                
                                DispatchQueue.main.async {
                                    self?.reloadTable()
                                }
                                
                            }
                            
                        } else {
                            self!.showAlertWith(message: AlertMessage(title: "Payments".localiz(), body: message.localiz()))
                        }
                    }
                    
                }
                
            } else {
                self!.showAlertWith(message: AlertMessage(title: "Tijarati".localiz(), body: "Sorry, Failed to load data.".localiz()))
            }
            
        })
        
    }
}

//MARK:- API CALL
extension PaymentsViewController{
    func decodeResult<T: Decodable>(model: T.Type, result: NSDictionary) -> (model: T?, error: Error?) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
            let modelObject = try JSONDecoder().decode(model.self, from: jsonData)
            return (modelObject, nil)
        } catch let error {
            return (nil, error)
        }
    }
    
    func recentTransactionApi(){
        
        self.viewModel?.alertMessage.bind({ [weak self] in
            self?.hideMBProgressHud(hudView: self!.transactionCardViewRef)
            self?.showAlertDismissOnly(message: $0)
        })
        
        
        self.viewModel?.response.bind({ [weak self] in
            
            if let response = $0 {
                
                self?.hideMBProgressHud(hudView: self!.transactionCardViewRef)
                
                if   let userStatus = DataDecryption().decryption(jsonModel: PayloadRes(iv: response.iv, payload: response.payload))
                {
                    let status : String = userStatus.value(forKey: "status") as? String ?? ""
                    if status == "" {
                        
                        let param : [String : Any] = [
                            "type":"mid",
                            "cif" : AppConstants.UserData.companyCIF,
                            "eZPayOutletNumber": AppConstants.ezpayOutletNumber,
                            "merchantNum": AppConstants.merchantNumber,
                            "deviceId": AppConstants.UserData.deviceID,
                            "startDate" : AppConstants.jsonStartDate,
                            "endDate" : AppConstants.jsonEndDate,
                            "cardType" : "SingleTransaction",
                            "txnStatus": "Success"
                        ]
                        
                        self?.showMBProgressHud(hudView: self!.transactionCardViewRef)
                        
                        self!.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.bulkTransaction)
                        self!.previousOrderAPI()
                        
                    } else {
                        
                        let message : String = userStatus.value(forKey: "message") as! String
                        let status : String = userStatus.value(forKey: "status") as! String
                        if status == "Success"{
                            let errorCode : String = userStatus.value(forKey: "errorCode") as! String
                            if errorCode == "L128"{
                                print("Message:-\(message)")
                                let object = self!.decodeResult(model: SingleTransactionApi.self, result: userStatus)
                                if let objectModel = object.model{
                                    self?.recentTransactionData = objectModel
                                }
                                print("MYDATA:- \(userStatus.allKeys)")
                                
                                DispatchQueue.main.async {
                                    self?.reloadTable()
                                }
                                
                            }
                            
                        } else {
                            self!.showAlertWith(message: AlertMessage(title: "Payments".localiz(), body: message.localiz()))
                        }
                    }
                    
                }
                
            } else {
                self!.showAlertWith(message: AlertMessage(title: "Tijarati".localiz(), body: "Sorry, Failed to load data.".localiz()))
            }
            
        })
        
    }
    
    func paymentSalesDataApi(){
        
        self.viewModel?.alertMessage.bind({ [weak self] in
            self?.hideMBProgressHud(hudView: self!.view)
            
            self?.showAlertDismissOnly(message: $0)
        })
        
        
        self.viewModel?.response.bind({ [weak self] in
            
            if let response = $0 {
                
                self?.hideMBProgressHud(hudView: self!.view)
                
                if   let userStatus = DataDecryption().decryption(jsonModel: PayloadRes(iv: response.iv, payload: response.payload))
                {
                    let status : String = userStatus.value(forKey: "status") as? String ?? ""
                    if status == "" {
                        
                        let param : [String : Any] = [
                            "type" : "mid",
                            "cif" : AppConstants.UserData.companyCIF,
                            "eZPayOutletNumber": AppConstants.ezpayOutletNumber,
                            "deviceId": AppConstants.UserData.deviceID,
                            "startDate" : AppConstants.jsonStartDate,
                            "endDate" : AppConstants.jsonEndDate,
                        ]
                        
                        self?.showMBProgressHud(hudView: self!.view)
                        
                        self!.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.paymentSalesSummary)
                        self!.paymentSalesDataApi()
                        
                    } else {
                        
                        let message : String = userStatus.value(forKey: "message") as! String
                        let status : String = userStatus.value(forKey: "status") as! String
                        if status == "Success"{
                            let errorCode : String = userStatus.value(forKey: "errorCode") as! String
                            if errorCode == "L128"{
                                print("Message:-\(message)")
                                let object = self!.decodeResult(model: PaymentSalesSummaryApi.self, result: userStatus)
                                if let objectModel = object.model{
                                    self?.PaymentSalesSummaryData = objectModel
                                }
                                print("MYDATA:- \(userStatus.allKeys)")
                                
                                DispatchQueue.main.async {
                                    self?.cvSales.reloadData()
                                }
                                
                            }
                            
                        } else {
                            self!.showAlertWith(message: AlertMessage(title: "Payments".localiz(), body: message.localiz()))
                        }
                    }
                    
                }
                
            } else {
                self!.showAlertWith(message: AlertMessage(title: "Tijarati".localiz(), body: "Sorry, Failed to load data.".localiz()))
            }
        })
    }
    
    
    func paymentSalesSummaryApi(){
        
        self.salesSummaryViewModel?.alertMessage.bind({ [weak self] in
            self?.hideMBProgressHud(hudView: self!.ivSalesCardBg)
            self?.showAlertDismissOnly(message: $0)
        })
        
        
        self.salesSummaryViewModel?.response.bind({ [weak self] in
            
            if let response = $0 {
                
                self?.hideMBProgressHud(hudView: self!.ivSalesCardBg)
                
                if   let userStatus = DataDecryption().decryption(jsonModel: PayloadRes(iv: response.iv, payload: response.payload))
                {
                    let status : String = userStatus.value(forKey: "status") as? String ?? ""
                    if status == "" {
                        
                        let param : [String : Any] = [
                            "type" : "mid",
                            "cif" : AppConstants.UserData.companyCIF,
                            "eZPayOutletNumber": AppConstants.ezpayOutletNumber,
                            "deviceId": AppConstants.UserData.deviceID,
                            "startDate" : AppConstants.jsonStartDate,
                            "endDate" : AppConstants.jsonEndDate,
                        ]
                        
                        self?.showMBProgressHud(hudView: self!.ivSalesCardBg)
                        
                        self!.salesSummaryViewModel?.serviceRequest(param: param, apiName: RequestItemsType.paymentSalesSummary)
                        self!.paymentSalesGraphApi()
                        
                    } else {
                        
                        let message : String = userStatus.value(forKey: "message") as! String
                        let status : String = userStatus.value(forKey: "status") as! String
                        if status == "Success"{
                            let errorCode : String = userStatus.value(forKey: "errorCode") as! String
                            if errorCode == "L128"{
                                print("Message:-\(message)")
                                let object = self!.decodeResult(model: PaymentSalesSummaryApi.self, result: userStatus)
                                
                                if let objectModel = object.model{
                                    self?.PaymentSalesSummaryData = objectModel
                                }
                                
                                if let totalAmount = object.model?.ezPayTotalAmount{
                                    self?.lblSalesAmount.text = "KD " + setAmounts(amount: totalAmount)
                                    self?.lblSalesAmount.attributedText = self?.lblSalesAmount.text!.attributedString(fontsize: 20)
                                }
                                
                                if let totalTransaction = object.model?.ezPayTotalTxnCount {
                                    self?.lblSalesTransactions.text = "\(totalTransaction) " + "Transactions".localiz()
                                } else {
                                    self?.lblSalesTransactions.text = "0 " + "Transactions".localiz()
                                }
                                
                                //recent transaction api calling
                                self?.viewModel = RegistrationViewControllerViewModel()
                                
                                let param : [String : Any] = [
                                    "type":"mid",
                                    "cif" : AppConstants.UserData.companyCIF,
                                    "eZPayOutletNumber": AppConstants.ezpayOutletNumber,
                                    "merchantNum": AppConstants.merchantNumber,
                                    "deviceId": AppConstants.UserData.deviceID,
                                    "startDate" : AppConstants.jsonStartDate,
                                    "endDate" : AppConstants.jsonEndDate,
                                    "cardType" : "SingleTransaction",
                                    "txnStatus": "Success"
                                ]
                                
                                self?.showMBProgressHud(hudView: self!.transactionCardViewRef)
                                
                                self?.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.bulkTransaction)
                                self?.recentTransactionApi()
                                
                                
                                DispatchQueue.main.async {
                                    self?.cvSales.reloadData()
                                }
                            }
                        } else {
                            self?.showAlertWith(message: AlertMessage(title: "Payments".localiz(), body: message.localiz()))
                        }
                    }
                }
            } else {
                self?.showAlertWith(message: AlertMessage(title: "Tijarati".localiz(), body: "Sorry, Failed to load data.".localiz()))
            }
            
        })
        
    }
    
    func paymentSalesGraphApi(){
        
        self.salesGraphViewModel?.alertMessage.bind({ [weak self] in
            self?.hideMBProgressHud(hudView: self!.eZpayCardViewRef)
            self?.showAlertDismissOnly(message: $0)
        })
        
        self.salesGraphViewModel?.response.bind({ [weak self] in
            
            if let response = $0 {
                
                self?.hideMBProgressHud(hudView: self!.eZpayCardViewRef)
                
                if   let userStatus = DataDecryption().decryption(jsonModel: PayloadRes(iv: response.iv, payload: response.payload)) {
                    
                    let status : String = userStatus.value(forKey: "status") as? String ?? ""
                    if status == "" {
                        
                        let param : [String : Any] = [
                            "type" : "mid",
                            "cif" : AppConstants.UserData.companyCIF,
                            "eZPayOutletNumber": AppConstants.ezpayOutletNumber,
                            "deviceId": AppConstants.UserData.deviceID,
                            "startDate" : AppConstants.jsonStartDate,
                            "endDate" : AppConstants.jsonEndDate,
                        ]
                        
                        self?.showMBProgressHud(hudView: self!.eZpayCardViewRef)
                        
                        self?.salesGraphViewModel?.serviceRequest(param: param, apiName: RequestItemsType.paymentSalesGraph)
                        self?.paymentSalesGraphApi()
                        
                    } else {
                        
                        let message : String = userStatus.value(forKey: "message") as! String
                        let status : String = userStatus.value(forKey: "status") as! String
                        if status == "Success"{
                            let errorCode : String = userStatus.value(forKey: "errorCode") as! String
                            if errorCode == "L128"{
                                print("Message:-\(message)")
                                let object = self?.decodeResult(model: PaymentGraphApi.self, result: userStatus)
                                if let objectModel = object?.model{
                                    self?.paymentGraphData = objectModel
                                }
                                print("MYDATA:- \(userStatus.allKeys)")
                                
                                DispatchQueue.main.async {
                                    self?.eZpatCvRef.reloadData()
                                    self?.paymentSalesSummary()
                                }
                            }
                        } else {
                            self?.showAlertWith(message: AlertMessage(title: "Payments".localiz(), body: message.localiz()))
                        }
                    }
                }
            } else {
                self?.showAlertWith(message: AlertMessage(title: "Tijarati".localiz(), body: "Sorry, Failed to load data.".localiz()))
            }
        })
    }
}


extension PaymentsViewController : TidPopupVCDelegate{
    func didiVCDismiss() {
        tidNoDropDownBtnRef.setTitle(AppConstants.cifCompanyName, for: .normal)
        if AppConstants.jsonStartDate == "" || AppConstants.jsonEndDate == "" {
            currentMonthData()
        } else {
            let startDate = AppConstants.jsonStartDate.dateFromFormat("yyyy-MM-dd")
            let endDate = AppConstants.jsonEndDate.dateFromFormat("yyyy-MM-dd")
            
            if AppConstants.jsonStartDate == AppConstants.jsonEndDate {
                let selectedDateRange = startDate!.monthh.prefix(3) + " - " + String(endDate!.day) + ", " + endDate!.yearr
                dateDropDownBtnRef.setTitle(selectedDateRange, for: .normal)
                
            } else {
                
                let startDate = startDate!.monthh.prefix(3) + " " + String(startDate!.day) + " - "
                let endDate = endDate!.monthh.prefix(3) + " " + String(endDate!.day) + ", " + endDate!.yearr
                let selectedDateRange = startDate + endDate
                dateDropDownBtnRef.setTitle(selectedDateRange, for: .normal)
            }
        }
        arabicSetup()
        // API Call
        paymentGraph()
    }
}
