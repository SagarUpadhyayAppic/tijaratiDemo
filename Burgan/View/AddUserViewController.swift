//
//  AddUserViewController.swift
//  Burgan
//
//  Created by Malti Maurya on 26/03/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

// original code
/*
 import UIKit
 protocol popupDelegate : class{
 func notifyVia(showNotifyPopup:Bool)
 func showLinkSent()
 func showAccessGranted()
 func selectedReports(reports : [String])
 }
 
 class AddUserViewController : UIViewController, popupDelegate, UITableViewDelegate, UITableViewDataSource, applyFilterDelegate
 {
 func applyFilter(heirarchy: selectedFilterData, isCif: Bool) {
 AppConstants.isCif = isCif
 let formattedArray = (heirarchy.selectedBrands.map{String($0)}).joined(separator: ",")
 
 lblBrandList.text = formattedArray
 tbDBAlist.reloadData()
 }
 
 
 
 
 @IBOutlet weak var lblReportStack: UIStackView!
 var selectedReports : [String] = []
 func selectedReports(reports : [String])
 {
 selectedReports = reports
 
 if reports.count > 0{
 
 for i in 0..<reports.count{
 if reports[i] == "transaction"{
 lblReportStack.isHidden = false
 lblTransactnReport.isHidden = false
 }
 if reports[i] == "settled"
 {
 lblReportStack.isHidden = false
 lblSettlemntReport.isHidden = false
 }
 if reports[i] == "credit"
 {
 lblCreditBankReport.isHidden = false
 }
 }
 if reports.contains("credit"){
 lblCreditBankReport.isHidden = false
 }else{
 lblCreditBankReport.isHidden = true
 }
 if reports.contains("transaction") || reports.contains("settled")
 {
 lblReportStack.isHidden = false
 
 }else{
 lblReportStack.isHidden = true
 }
 
 }
 }
 
 
 
 @IBOutlet weak var btnEditUser: UIButton!
 
 func notifyVia(showNotifyPopup:Bool) {
 if(showNotifyPopup){
 DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
 let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProfilePopupsViewController") as? ProfilePopupsViewController
 controller!.popupType = 2
 
 self.presentAsStork(controller!, height: 300, cornerRadius: 10, showIndicator: false, showCloseButton: false)            }
 
 }
 }
 @IBOutlet weak var accessGrantedPopupView: UIView!
 
 @IBOutlet weak var linkSentPopupView: UIView!
 @IBOutlet weak var lblToolBarTitle: UILabel!
 
 @IBOutlet weak var DBADetailCurvedView: UIView!
 @IBOutlet weak var ivUserName: UIImageView!
 
 @IBOutlet weak var DBADetailCurvedViewHeight: NSLayoutConstraint!
 @IBOutlet weak var curvedReportsView: UIView!
 @IBOutlet weak var curvedDBAView: UIView!
 var showUserDetail = false
 var hasDBAInfo = false
 @IBOutlet weak var tbDBAlist: UITableView!
 @IBOutlet weak var ivPhoneBookView: UIView!
 @IBOutlet weak var reportAccessDetailView: UIView!
 @IBOutlet weak var nameHeight: NSLayoutConstraint!
 @IBOutlet weak var tfUsername: UITextField!
 
 @IBOutlet weak var tfEmailId: UITextField!
 @IBOutlet weak var tfMobileNo: UITextField!
 
 override func viewDidLoad() {
 super.viewDidLoad()
 
 curvedviewShadow(view: curvedDBAView)
 curvedviewShadow(view: curvedReportsView)
 curvedviewShadow(view: DBADetailCurvedView)
 curvedviewShadow(view: reportAccessDetailView)
 lblTransactnReport.layer.cornerRadius = 5
 lblSettlemntReport.layer.cornerRadius = 5
 lblCreditBankReport.layer.cornerRadius = 5
 linksentShadowView.layer.cornerRadius = 8
 popupShadow(view: linksentShadowView)
 accessGrantedShadowView.layer.cornerRadius = 8
 popupShadow(view: accessGrantedShadowView)
 self.navigationController?.isNavigationBarHidden = true
 btnOKLinkSent.layer.cornerRadius = 8
 okAccessGrantedBtn.layer.cornerRadius = 8
 userInfo()
 tapGesture()
 self.viewModel = RegistrationViewControllerViewModel()
 
 
 }
 var isViewEnabled = false
 var isReportsEnabled = false
 @IBOutlet weak var accessGrantedShadowView: UIView!
 @IBAction func okAccesstPopup(_ sender: Any) {
 accessGrantedPopupView.isHidden = true
 curvedReportsView.isHidden = true
 reportAccessDetailView.isHidden = false
 }
 var viewModel : RegistrationViewControllerViewModelProtocol?
 var API_REQUEST = "addUser"
 func decodeResult<T: Decodable>(model: T.Type, result: NSDictionary) -> (model: T?, error: Error?) {
 do {
 let jsonData = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
 let modelObject = try JSONDecoder().decode(model.self, from: jsonData)
 return (modelObject, nil)
 } catch let error {
 return (nil, error)
 }
 }
 private func bindUIUpdateUser() {
 
 self.viewModel?.alertMessage.bind({ [weak self] in
 MBProgressHUD.hide(for: self!.view, animated: true)
 self?.showAlertDismissOnly(message: $0)
 })
 
 
 
 self.viewModel?.response.bind({ [weak self] in
 
 if let response = $0 {
 MBProgressHUD.hide(for: self!.view, animated: true)
 let userStatus = DataDecryption().decryption(jsonModel: PayloadRes(iv: response.iv, payload: response.payload))
 
 if userStatus != nil {
 
 
 
 let message : String = userStatus?.value(forKey: "message") as! String
 let status : String = userStatus?.value(forKey: "status") as! String
 if status == "Success"{
 
 let errorCode : String = userStatus?.value(forKey: "errorCode") as! String
 if errorCode == "S101"{
 self!.showAlertWith(message: AlertMessage(title: "Update User Data", body: message))
 
 
 }else{
 self!.showAlertWith(message: AlertMessage(title: "Update User Data", body: message))
 }
 
 
 }else{
 self!.showAlertWith(message: AlertMessage(title: "Update User Data", body: message))
 }
 
 }
 
 }
 
 
 
 })
 
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
 
 var message = ""
 
 if let msg  = userStatus?.value(forKey: "message")
 {
 message = msg as! String
 }
 var status = "Success"
 
 if  let stat  = userStatus?.value(forKey: "status")
 {
 status = stat  as! String
 }
 if status == "Success"{
 if self!.API_REQUEST == "addUser"{
 let errorCode : String = userStatus?.value(forKey: "errorCode") as! String
 if errorCode == "S101"{
 print(message)
 self!.showAlertWith(message: AlertMessage(title: "Add User", body: message))
 self?.dismiss(animated: true, completion: nil)
 
 }else{
 self!.showAlertWith(message: AlertMessage(title: "Add User", body: message))
 }
 }else{
 
 }
 
 
 }else{
 self!.showAlertWith(message: AlertMessage(title: "Add User", body: message))
 }
 
 }
 
 }
 
 
 })
 
 }
 @IBOutlet weak var okAccessGrantedBtn: GradientLayer!
 func popupShadow(view:UIView){
 view.layer.shadowColor = UIColor.BurganColor.brandGray.black.cgColor
 view.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
 view.layer.shadowOpacity = 1.0
 view.layer.shadowRadius = 10.0
 view.layer.masksToBounds = false
 }
 func tapGesture(){
 let tapDBADetailGesture = UITapGestureRecognizer(target: self, action: #selector(self.showDBADetails))
 ivToggleDBAArrow.isUserInteractionEnabled = true; self.ivToggleDBAArrow.addGestureRecognizer(tapDBADetailGesture)
 
 let tapSelectDBAGesture = UITapGestureRecognizer(target: self, action: #selector(self.selectDBALocation))
 curvedDBAView.isUserInteractionEnabled = true; self.curvedDBAView.addGestureRecognizer(tapSelectDBAGesture)
 
 let tapSelectReportGesture = UITapGestureRecognizer(target: self, action: #selector(self.selectReports))
 curvedReportsView.isUserInteractionEnabled = true; self.curvedReportsView.addGestureRecognizer(tapSelectReportGesture)
 }
 @objc func selectReports(sender: UITapGestureRecognizer){
 let controller = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProfilePopupsViewController") as? ProfilePopupsViewController)!
 controller.popupType = 4
 controller.linkDelegate = self
 presentAsStork(controller, height: 450, cornerRadius: 8.0, showIndicator: false, showCloseButton: false)
 }
 @objc func selectDBALocation(sender: UITapGestureRecognizer){
 if AppConstants.selectedFilter != nil {
 let controller = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SelectLocationViewController") as? SelectLocationViewController)!
 controller.delegateFilter = self
 controller.delegate = self
 controller.isFromProfile = true
 presentAsStork(controller, height: 500, cornerRadius: 8.0, showIndicator: false, showCloseButton: false)
 }else{
 showAlertWith(message: AlertMessage(title: "Burgan", body: "No data available to filter."))
 }
 }
 var isDBADetailOpen = false
 var userDetail : userData?
 @IBOutlet weak var lblBrandList: UILabel!
 var dbaArray : [Hierarchy] = []
 func brandArray(hierarchyArr : [Hierarchy]) -> String{
 var brands : [String] = []
 
 for i in 0..<hierarchyArr.count{
 if hierarchyArr[i].brandNameList.count > 0{
 for k in 0..<hierarchyArr[i].brandNameList.count{
 brands.append(hierarchyArr[i].brandNameList[k].brandName)
 
 }
 }
 }
 let formattedArray = (brands.map{String($0)}).joined(separator: ",")
 return formattedArray
 }
 func userInfo(){
 DBADetailCurvedViewHeight.constant = 160
 
 if(showUserDetail){
 ivUserName.image = UIImage(named: "ic_name_filled")
 nameHeight.constant = 100
 btnAddUser.setTitle("RE-SEND LINk", for: .normal)
 hasDBAInfo =  true
 ivPhoneBookView.isHidden = true
 curvedDBAView.isHidden = true
 curvedReportsView.isHidden = true
 userStatus.isHidden = false
 lblDBAAssigned.isHidden = false
 lblDBAAssigned.text = String(userDetail!.hierarchy!.count) + " DBA's Assigned"
 userStatus.text = userDetail?.status
 
 btnEditUser.isHidden = false
 btnEditDBAList.isHidden = true
 btnEditReports.isHidden = true
 tfUsername.text = userDetail?.name
 tfMobileNo.text = userDetail?.mobile
 tfEmailId.text = userDetail?.emailID
 if userDetail?.isViewEnabled == "false"{
 isViewEnabled = false
 }else{
 isViewEnabled = true
 }
 if userDetail?.isReportsEnabled == "false"{
 isReportsEnabled = false
 }else{
 isReportsEnabled = true
 }
 
 if isViewEnabled{
 DBADetailCurvedView.isHidden = false
 lblDBAAssigned.isHidden = false
 
 if userDetail!.hierarchy!.count > 0{
 dbaArray = userDetail!.hierarchy!
 
 lblBrandList.text =  brandArray(hierarchyArr: userDetail!.hierarchy!)
 tbDBAlist.reloadData()
 }
 }else{
 DBADetailCurvedView.isHidden = true
 lblDBAAssigned.isHidden = true
 }
 if isReportsEnabled{
 reportAccessDetailView.isHidden = false
 
 }else{
 reportAccessDetailView.isHidden = true
 
 }
 
 
 
 
 }else{
 btnAddUser.setTitle("ADD", for: .normal)
 
 ivUserName.image = UIImage(named: "ic_user")
 nameHeight.constant = 60
 ivPhoneBookView.isHidden = false
 if(hasDBAInfo)
 {
 curvedDBAView.isHidden = true
 curvedReportsView.isHidden = true
 DBADetailCurvedView.isHidden = false
 reportAccessDetailView.isHidden = false
 }else{
 curvedDBAView.isHidden = false
 curvedReportsView.isHidden = false
 DBADetailCurvedView.isHidden = true
 reportAccessDetailView.isHidden = true
 }
 btnEditReports.isHidden = false
 btnEditDBAList.isHidden = false
 btnEditUser.isHidden = true
 userStatus.isHidden = true
 lblDBAAssigned.isHidden = true
 
 }
 }
 
 @IBOutlet weak var btnEditDBAList: UIButton!
 @IBAction func editDBAList(_ sender: Any) {
 if AppConstants.selectedFilter != nil {
 let controller = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SelectLocationViewController") as? SelectLocationViewController)!
 controller.delegateFilter = self
 presentAsStork(controller, height: 500, cornerRadius: 8.0, showIndicator: false, showCloseButton: false)
 }else{
 showAlertWith(message: AlertMessage(title: "Burgan", body: "No data available to filter."))
 }
 }
 @IBOutlet weak var userStatus: UILabel!
 @IBOutlet weak var lblDBAAssigned: UILabel!
 @IBOutlet weak var ivToggleDBAArrow: UIImageView!
 @IBAction func goback(_ sender: Any) {
 self.navigationController?.popViewController(animated: true)
 }
 
 @IBOutlet weak var btnAddUser: UIButton!
 @objc func showDBADetails(sender: UITapGestureRecognizer){
 if(isDBADetailOpen){
 isDBADetailOpen = false
 ivToggleDBAArrow.image = UIImage(named: "ic_down_arrow_grey")
 DBADetailCurvedViewHeight.constant = 160
 DBABrandListView.isHidden = false
 DBASeparatorView2.isHidden = false
 DBASeparatorView3.isHidden = false
 
 }else{
 ivToggleDBAArrow.image = UIImage(named: "ic_up_arrow_grey")
 DBABrandListView.isHidden = true
 isDBADetailOpen = true
 DBADetailCurvedViewHeight.constant = 360
 DBASeparatorView2.isHidden =  true
 DBASeparatorView3.isHidden = true
 }
 }
 
 @IBOutlet weak var DBASeparatorView3: UIView!
 @IBOutlet weak var DBASeparatorView2: UIView!
 @IBOutlet weak var DBABrandListView: UIStackView!
 @IBAction func add(_ sender: Any) {
 if showUserDetail {
 let param : [String : Any] = ["cif" : AppConstants.selectedFilter!.cif,
 "deviceId" : AppConstants.UserData.deviceID,
 "userID" : userDetail!.userID,
 "name" : tfUsername.text!,
 "mobile" : tfMobileNo.text!,
 "emailID" : tfEmailId.text!,
 "isViewEnabled" : isViewEnabled,
 "isReportsEnabled" : isReportsEnabled,
 "merchantNum" : AppConstants.merchantNumber,
 "reportList" : selectedReports,
 "LinkShare" : "SMS"]
 MBProgressHUD.showAdded(to: self.view, animated: true)
 self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.modifyList)
 self.bindUIUpdateUser()
 }else{
 let param : [String : Any] = ["cif" : AppConstants.selectedFilter!.cif,
 "deviceId" : AppConstants.UserData.deviceID,
 "name" : tfUsername.text!,
 "mobile" : tfMobileNo.text!,
 "emailID" : tfEmailId.text!,
 "isViewEnabled" : isViewEnabled,
 "isReportsEnabled" : isReportsEnabled,
 "merchantNum" : AppConstants.merchantNumber,
 "reportList" : ["TransactionReport","SettlementReport","CreditToBank"],
 "LinkShare" : "SMS"]
 MBProgressHUD.showAdded(to: self.view, animated: true)
 self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.getUserList)
 self.bindUI()
 }
 
 }
 @IBAction func btnLinkSentPopup(_ sender: Any) {
 linkSentPopupView.isHidden = true
 curvedDBAView.isHidden = true
 DBADetailCurvedView.isHidden = true
 }
 @IBOutlet weak var btnEditReports: UIButton!
 @IBOutlet weak var btnOKLinkSent: GradientLayer!
 @IBAction func editReports(_ sender: Any) {
 let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProfilePopupsViewController") as? ProfilePopupsViewController
 controller!.popupType = 4
 presentAsStork(controller!, height: 450, cornerRadius: 10, showIndicator: false, showCloseButton: false)
 }
 @IBAction func editUserInfo(_ sender: Any) {
 showUserDetail = false
 userInfo()
 }
 func showLinkSent() {
 linkSentPopupView.isHidden = false
 accessGrantedPopupView.isHidden = true
 }
 
 
 @IBAction func closeLinkPopup(_ sender: Any) {
 linkSentPopupView.isHidden = true
 }
 @IBOutlet weak var linksentShadowView: UIView!
 @IBOutlet weak var lblCreditBankReport: PaddingLabel!
 @IBOutlet weak var lblTransactnReport: PaddingLabel!
 @IBOutlet weak var lblSettlemntReport: PaddingLabel!
 func curvedviewShadow(view:UIView){
 
 view.layer.cornerRadius = 8
 view.layer.shadowOpacity = 0.35
 view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
 view.layer.shadowRadius = 3.0
 view.layer.shadowColor = UIColor.BurganColor.brandGray.lgiht.cgColor
 view.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner,.layerMaxXMinYCorner]
 }
 
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 return dbaArray.count
 }
 func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
 guard let tableViewCell = cell as? tbDBACell else { return }
 tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
 
 }
 
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 let cell = tableView.dequeueReusableCell(withIdentifier: "tbDBACell", for: indexPath) as! tbDBACell
 cell.collectionViewOffset = 10
 var brands : [String] = []
 cell.lblAccountNo.text = dbaArray[indexPath.row].accountNumber
 if dbaArray[indexPath.row].brandNameList.count > 0 {
 for i in 0..<dbaArray[indexPath.row].brandNameList.count {
 brands.append(dbaArray[indexPath.row].brandNameList[i].brandName.uppercased())
 
 if dbaArray[indexPath.row].brandNameList[i].locationNameList.count > 0{
 for k in 0..<dbaArray[indexPath.row].brandNameList[i].locationNameList.count {
 locationsArray.append(dbaArray[indexPath.row].brandNameList[i].locationNameList[k])
 
 }
 cell.locationCv.reloadData()
 }
 }
 let formattedArray = (brands.map{String($0)}).joined(separator: ",")
 cell.lblBrand.text = formattedArray
 }
 
 
 return cell
 }
 var locationsArray : [LocationNameList] = []
 }
 extension AddUserViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
 
 func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
 return locationsArray.count
 }
 
 func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
 let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellLocationCv", for: indexPath) as! cvCompanyLocationListCell
 cell.layer.cornerRadius = 3
 
 cell.lblName.text = locationsArray[indexPath.row].locationName
 
 return cell
 }
 
 func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
 return CGSize(width: collectionView.frame.size.width - 10, height: collectionView.frame.size.height)
 }
 func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
 
 }
 func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
 return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
 }
 func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
 return 5;
 }
 
 
 func showAccessGranted() {
 linkSentPopupView.isHidden = true
 accessGrantedPopupView.isHidden = false
 }
 
 
 }
 
 */


// 2
// By Sanket

//
//  AddUserViewController.swift
//  Burgan
//
//  Created by Malti Maurya on 26/03/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit
import ContactsUI

protocol popupDelegate : class{
    func notifyVia(showNotifyPopup:Bool)
    func showLinkSent(Links:[String])
    func showAccessGranted()
    func selectedReports(reports : [String])
}

class AddUserViewController : UIViewController, popupDelegate, UITableViewDelegate, UITableViewDataSource, applyFilterDelegate, CNContactPickerDelegate
{
    func applyFilter(heirarchy: selectedFilterData, isCif: Bool) {
        AppConstants.isCif = isCif
        let formattedArray = Array(Set((heirarchy.selectedBrands.map{String($0)}))).joined(separator: ",")
        //formattedArray = Array(Set(formattedArray))
        lblBrandList.text = formattedArray
        
        lblCIDName.text = heirarchy.companyName
        AppConstants.cifCompanyName = AppConstants.selectedFilter!.companyName
        AppConstants.UserData.companyCIF = AppConstants.selectedFilter!.cif
        
        // by makau
        curvedDBAView.isHidden = true
        //            DBADetailCurvedView.isHidden = true
        DBADetailCurvedView.isHidden = false
        
        //        dbaArray = heirarchy.selectedHeirarchy
        dbaArray.removeAll()
        
        if showUserDetail {
            self.showUserDetailDBAEdit = true
        } else {
            self.showUserDetailDBAEdit = false
        }
        
        for obj in heirarchy.selectedAccounts {
            
            for subObj in heirarchy.selectedHeirarchy {
                
                if obj == subObj.accountNumber {
                    
                    dbaArray.append(subObj)
                }
            }
        }
        
        //        lblBrandList.text =  brandArray(hierarchyArr: heirarchy.selectedHeirarchy)
        let formattedBrands = (heirarchy.selectedBrands.map{String($0)}).joined(separator: ",")
        lblBrandList.text = formattedBrands
        
        tbDBAlist.reloadData()
    }
    
    @IBOutlet weak var resendLinkBtn: UIButton!
    
    @IBAction func resendLinkBtnTap(_ sender: Any)
    {
        print(selectedLinks)
        if selectedLinks.count > 0
        {
            
            if userDetail?.userID != nil
            {
                showUserDetail = true
            }
            else
            {
                showUserDetail = false
            }
            
            if selectedReports.count > 0
            {
                isReportsEnabled = true
                
            }
            else
            {
                isReportsEnabled = false
            }
            
            var merchantNumber : [Int] = []
            for i in 0..<dbaArray.count{
                for j in 0..<dbaArray[i].brandNameList.count{
                    for k in 0..<dbaArray[i].brandNameList[j].locationNameList.count{
                        for l in 0..<dbaArray[i].brandNameList[j].locationNameList[k].merchantNumber.count
                        {
                            let m : Int = Int(dbaArray[i].brandNameList[j].locationNameList[k].merchantNumber[l].mid)!
                            merchantNumber.append(m)
                        }
                    }
                }
            }
            
            if showUserDetail {
                
                //                let myMerchant : String  = "\(AppConstants.merchantNumber)"
                let myMerchant : String  = "\(merchantNumber)"
                
                let param : [String : Any] = ["cif" : AppConstants.selectedFilter!.cif,
                                              "deviceId" : AppConstants.UserData.deviceID,
                                              "userID" : userDetail!.userID!,
                                              "name" : tfUsername.text!,
                                              "mobile" : tfMobileNo.text!,
                                              "emailID" : tfEmailId.text!,
                                              "isViewEnabled" : isViewEnabled,
                                              "isReportsEnabled" : isReportsEnabled,
                                              "merchantNum" : myMerchant,
                                              "reportList" : "\(selectedReports)",
                    "LinkShare" : selectedLinks]
                print(param)
                MBProgressHUD.showAdded(to: self.view, animated: true)
                self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.modifyUser)
                self.bindUIUpdateUser(btnName: "RESENDLINK")
            }else{
                
                //                let myMerchant : [String]  = ["\(AppConstants.merchantNumber)"]
                let myMerchant : [String]  = ["\(merchantNumber)"]
                
                let param : [String : Any] = ["cif" : AppConstants.selectedFilter!.cif,
                                              "deviceId" : AppConstants.UserData.deviceID,
                                              "name" : tfUsername.text!,
                                              "mobile" : tfMobileNo.text!,
                                              "emailID" : tfEmailId.text!,
                                              "isViewEnabled" : isViewEnabled,
                                              "isReportsEnabled" : isReportsEnabled,
                                              "merchantNum" : myMerchant,
                                              "reportList" : selectedReports,
                                              "LinkShare" : selectedLinks]
                print(param)
                MBProgressHUD.showAdded(to: self.view, animated: true)
                self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.addUser)
                self.bindUI(btnName: "RESENDLINK")
            }
        }
        else
        {
            notifyVia(showNotifyPopup: true)
        }
        
    }
    
    @IBOutlet weak var grantAccessTransactionReport_Lbl: UILabel!
    @IBOutlet weak var grantAccessSettlementReport_Lbl: UILabel!
    @IBOutlet weak var grantAccessCreditBank_Lbl: UILabel!
    
    
    @IBOutlet weak var lblReportStack: UIStackView!
    var selectedReports : [String] = []
    func selectedReports(reports : [String])
    {
        selectedReports = reports
        
        if reports.count > 0{
            
            for i in 0..<reports.count{
                if reports[i].contains("Transaction Report"){
                    lblReportStack.isHidden = false
                    lblTransactnReport.isHidden = false
                }
                
                if reports[i].contains("Settlement Report")
                {
                    lblReportStack.isHidden = false
                    lblSettlemntReport.isHidden = false
                }
                
                if reports[i].contains("Credit To Bank Report")
                {
                    lblCreditBankReport.isHidden = false
                }
            }
            if reports.contains(where: { $0.contains("Credit To Bank Report") }){
                lblCreditBankReport.isHidden = false
                grantAccessCreditBank_Lbl.text = "Credit To Bank Report".localiz()
            }else{
                lblCreditBankReport.isHidden = true
                grantAccessCreditBank_Lbl.text = ""
            }
            
            lblReportStack.isHidden = false
            if reports.contains(where: { $0.contains("Transaction Report") })
            {
                lblTransactnReport.isHidden = false
                grantAccessTransactionReport_Lbl.text = "Transaction Report".localiz()
            }
            else
            {
                lblTransactnReport.isHidden = true
                grantAccessTransactionReport_Lbl.text = ""
            }
            
            
            if reports.contains(where: { $0.contains("Settlement Report") })
            {
                lblSettlemntReport.isHidden = false
                grantAccessSettlementReport_Lbl.text = "Settlement Report".localiz()
            }
            else
            {
                lblSettlemntReport.isHidden = true
                grantAccessSettlementReport_Lbl.text = ""
            }
            
            
            //            if reports.contains("TransactionReport") || reports.contains("SettlementReport")
            //            {
            //                lblReportStack.isHidden = false
            //
            //            }else{
            //                lblReportStack.isHidden = true
            //            }
            
        } else {
            
            lblReportStack.isHidden = true
            lblTransactnReport.isHidden = true
            lblReportStack.isHidden = true
            lblSettlemntReport.isHidden = true
            lblCreditBankReport.isHidden = true
            lblCreditBankReport.isHidden = true
            grantAccessCreditBank_Lbl.text = ""
            lblTransactnReport.isHidden = true
            grantAccessTransactionReport_Lbl.text = ""
            lblSettlemntReport.isHidden = true
            grantAccessSettlementReport_Lbl.text = ""
        }
    }
    
    
    @IBOutlet weak var btnEditUser: UIButton!
    
    func notifyVia(showNotifyPopup:Bool) {
        if(showNotifyPopup){
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProfilePopupsViewController") as? ProfilePopupsViewController
                controller!.popupType = 2
                controller?.linkDelegate = self
                self.presentAsStork(controller!, height: self.view.frame.height, cornerRadius: 10, showIndicator: false, showCloseButton: false)            }
            
            
            
        }
    }
    @IBOutlet weak var accessGrantedPopupView: UIView!
    
    @IBOutlet weak var linkSentPopupView: UIView!
    @IBOutlet weak var lblToolBarTitle: UILabel!
    
    @IBOutlet weak var DBADetailCurvedView: UIView!
    @IBOutlet weak var ivUserName: UIImageView!
    
    @IBOutlet weak var DBADetailCurvedViewHeight: NSLayoutConstraint!
    @IBOutlet weak var curvedReportsView: UIView!
    @IBOutlet weak var curvedDBAView: UIView!
    var showUserDetail = false
    var showUserDetailDBAEdit = false
    var hasDBAInfo = false
    @IBOutlet weak var tbDBAlist: UITableView!
    @IBOutlet weak var ivPhoneBookView: UIView!
    @IBOutlet weak var reportAccessDetailView: UIView!
    @IBOutlet weak var nameHeight: NSLayoutConstraint!
    @IBOutlet weak var tfUsername: UITextField!
    
    @IBOutlet weak var tfEmailId: UITextField!
    @IBOutlet weak var tfMobileNo: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.networkStatusChanged(_:)), name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        definesPresentationContext = true
        
        
        self.loopThroughSubViewAndAlignTextfieldText(subviews: self.view.subviews)
        self.loopThroughSubViewAndAlignLabelText(subviews: self.view.subviews)
        self.loopThroughSubViewAndMirrorImage(subviews: self.view.subviews)
        
        curvedviewShadow(view: curvedDBAView)
        curvedviewShadow(view: curvedReportsView)
        curvedviewShadow(view: DBADetailCurvedView)
        curvedviewShadow(view: reportAccessDetailView)
        lblTransactnReport.layer.cornerRadius = 5
        lblSettlemntReport.layer.cornerRadius = 5
        lblCreditBankReport.layer.cornerRadius = 5
        linksentShadowView.layer.cornerRadius = 8
        popupShadow(view: linksentShadowView)
        accessGrantedShadowView.layer.cornerRadius = 8
        popupShadow(view: accessGrantedShadowView)
        self.navigationController?.isNavigationBarHidden = true
        btnOKLinkSent.layer.cornerRadius = 8
        okAccessGrantedBtn.layer.cornerRadius = 8
        userInfo()
        tapGesture()
        self.viewModel = RegistrationViewControllerViewModel()
        
        // tfMobileNo.addTarget(self, action: #selector(didChangeText(field:)), for: .editingChanged)

    }
    
    @IBAction func PhoneBook_Btn_Tapped(_ sender: Any) {
        
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        contactPicker.displayedPropertyKeys =
            [CNContactGivenNameKey
                , CNContactPhoneNumbersKey]
        self.present(contactPicker, animated: true, completion: nil)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController,
                       didSelect contactProperty: CNContactProperty) {
        
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        // You can fetch selected name and number in the following way
        
        /*
         // user name
         let userName:String = contact.givenName
         
         // user phone number
         let userPhoneNumbers:[CNLabeledValue<CNPhoneNumber>] = contact.phoneNumbers
         let firstPhoneNumber:CNPhoneNumber = userPhoneNumbers[0].value
         
         
         // user phone number string
         let primaryPhoneNumberStr:String = firstPhoneNumber.stringValue
         
         print(primaryPhoneNumberStr)
         */
        
        let phoneNumberCount = contact.phoneNumbers.count
        
        guard phoneNumberCount > 0 else {
            dismiss(animated: true)
            //show pop up: "Selected contact does not have a number"
            return
        }
        
        if phoneNumberCount == 1 {
            setNumberFromContact(contactNumber: contact.phoneNumbers[0].value.stringValue)
            
        } else {
            let alertController = UIAlertController(title: "Select one of the numbers".localiz(), message: nil, preferredStyle: .alert)
            
            for i in 0...phoneNumberCount-1 {
                let phoneAction = UIAlertAction(title: contact.phoneNumbers[i].value.stringValue, style: .default, handler: {
                    alert -> Void in
                    self.setNumberFromContact(contactNumber: contact.phoneNumbers[i].value.stringValue)
                })
                alertController.addAction(phoneAction)
            }
            let cancelAction = UIAlertAction(title: "Cancel".localiz(), style: .destructive, handler: {
                alert -> Void in
                
            })
            alertController.addAction(cancelAction)
            
            dismiss(animated: true)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        
    }
    
    func setNumberFromContact(contactNumber: String) {
        
        //UPDATE YOUR NUMBER SELECTION LOGIC AND PERFORM ACTION WITH THE SELECTED NUMBER
        
        var contactNumber = contactNumber.replacingOccurrences(of: "-", with: "")
        contactNumber = contactNumber.replacingOccurrences(of: "(", with: "")
        contactNumber = contactNumber.replacingOccurrences(of: ")", with: "")
        contactNumber = contactNumber.replacingOccurrences(of: " ", with: "")
        guard contactNumber.count >= 8 else {
            dismiss(animated: true) {
                //                self.popUpMessageError(value: 10, message: "Selected contact does not have a valid number")
                print("Selected contact does not have a valid number")
            }
            return
        }
        self.tfMobileNo.text = String(contactNumber.suffix(8))
        
    }
    
    @objc func didChangeText(field: UITextField) {
        if ((field.text?.containsNonEnglishNumbers) != nil) {
            field.text = field.text?.english
        }
    }
    
    var isViewEnabled = true
    var isReportsEnabled = false
    @IBOutlet weak var accessGrantedShadowView: UIView!
    @IBAction func okAccesstPopup(_ sender: Any) {
        accessGrantedPopupView.isHidden = true
        curvedReportsView.isHidden = true
        reportAccessDetailView.isHidden = false
    }
    var viewModel : RegistrationViewControllerViewModelProtocol?
    var API_REQUEST = "addUser"
    func decodeResult<T: Decodable>(model: T.Type, result: NSDictionary) -> (model: T?, error: Error?) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
            let modelObject = try JSONDecoder().decode(model.self, from: jsonData)
            return (modelObject, nil)
        } catch let error {
            return (nil, error)
        }
    }
    private func bindUIUpdateUser(btnName : String) {
        
        self.viewModel?.alertMessage.bind({ [weak self] in
            MBProgressHUD.hide(for: self!.view, animated: true)
            self?.showAlertDismissOnly(message: $0)
        })
        
        self.viewModel?.response.bind({ [weak self] in
            
            if let response = $0 {
                MBProgressHUD.hide(for: self!.view, animated: true)
                let userStatus = DataDecryption().decryption(jsonModel: PayloadRes(iv: response.iv, payload: response.payload))
                
                if userStatus != nil {
                    
                    let status = userStatus?.value(forKey: "status") as? String ?? ""
                    
                    if status == "" {
                        
                        if btnName == "ADD" {
                            self?.add(self!.btnAddUser)
                        } else {
                            self?.resendLinkBtnTap(self!.resendLinkBtn)
                        }
                        
                    } else {
                        
                        let message : String = userStatus?.value(forKey: "message") as! String
                        let status : String = userStatus?.value(forKey: "status") as! String
                        if status == "Success" {
                            
                            let errorCode : String = userStatus?.value(forKey: "errorCode") as! String
                            if errorCode == "S101"{
                                
                                //                                                self!.showAlertWith(message: AlertMessage(title: "Update User Data", body: message))
                                
                                var isWhatsAppOn : Bool = false
                                
                                // Open whatsapp
                                print(self!.selectedLinks)
                                for i in 0 ..< self!.selectedLinks.count {
                                    let link = self!.selectedLinks[i]
                                    print(link)
                                    if link.contains("Whatsapp") {
                                        
                                        isWhatsAppOn = true
                                        /*
                                         let urlWhats = "whatsapp://send?phone=+965\(self!.tfMobileNo.text ?? "")&text=Dear \(self?.tfUsername.text ?? "User") You have been granted viewing rights access to Tijarati,a true business owner\'s app by You have been granted viewing rights access to Tijarati,a true business owner\'s app by \(AppConstants.UserData.name) Download the app now: https://burgan.page.link/u9DC"
                                         */
                                        
                                        /*
                                        let urlWhats = "whatsapp://send?phone=+965\(self!.tfMobileNo.text ?? "")&text=Dear \(self?.tfUsername.text ?? "User") You have been granted viewing rights access to Tijarati,a true business owner\'s app by \(AppConstants.UserData.name). Download the app now: https://burgan.page.link/u9DC"
                                        */
                                        
                                        let urlWhats = "whatsapp://send?phone=+965\(self!.tfMobileNo.text ?? "")&text=\("Dear User, You have been granted access to the Tijarati application, with the rights to display the Business Owner Platform of ".localiz()) \(AppConstants.UserData.name)\(". Download the app now:".localiz()) https://burgan.page.link/u9DC"
                                        
                                        
                                        
                                        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
                                            if let whatsappURL = URL(string: urlString) {
                                                if UIApplication.shared.canOpenURL(whatsappURL) {
                                                    
                                                    UIApplication.shared.open(whatsappURL)
                                                    
                                                    // Alert After scussesfully update user
                                                    let alertController = UIAlertController(title: "Update User Data".localiz(), message: message.localiz(), preferredStyle: .alert)
                                                    let action = UIAlertAction(title: "Ok".localiz(), style: .cancel) { (action) in
                                                        self?.navigationController?.popViewController(animated: true)
                                                    }
                                                    alertController.addAction(action)
                                                    self?.present(alertController, animated: true, completion: nil)
                                                    
                                                } else {
                                                    print("Install Whatsapp")
                                                    //self?.AlertMsg(title: "Install Whatsapp".localiz())
                                                    // Alert After scussesfully update user
                                                    let alertController = UIAlertController(title: "Install Whatsapp".localiz(), message: "", preferredStyle: .alert)
                                                    let action = UIAlertAction(title: "Ok".localiz(), style: .cancel) { (action) in
                                                        
                                                        // Alert After scussesfully update user
                                                        let alertController = UIAlertController(title: "Update User Data".localiz(), message: message.localiz(), preferredStyle: .alert)
                                                        let action = UIAlertAction(title: "Ok".localiz(), style: .cancel) { (action) in
                                                            self?.navigationController?.popViewController(animated: true)
                                                        }
                                                        alertController.addAction(action)
                                                        self?.present(alertController, animated: true, completion: nil)
                                                        
                                                    }
                                                    alertController.addAction(action)
                                                    self?.present(alertController, animated: true, completion: nil)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                if isWhatsAppOn == true {
                                    
                                } else {
                                    
                                    // Alert After scussesfully update user
                                    let alertController = UIAlertController(title: "Update User Data".localiz(), message: message.localiz(), preferredStyle: .alert)
                                    let action = UIAlertAction(title: "Ok".localiz(), style: .cancel) { (action) in
                                        self?.navigationController?.popViewController(animated: true)
                                    }
                                    alertController.addAction(action)
                                    self?.present(alertController, animated: true, completion: nil)
                                    
                                }
                                
                                /*
                                 // Alert After scussesfully update user
                                 let alertController = UIAlertController(title: "Update User Data".localiz(), message: message.localiz(), preferredStyle: .alert)
                                 let action = UIAlertAction(title: "Ok".localiz(), style: .cancel) { (action) in
                                 self?.navigationController?.popViewController(animated: true)
                                 }
                                 alertController.addAction(action)
                                 self?.present(alertController, animated: true, completion: nil)
                                 */
                                
                            }else{
                                self!.showAlertWith(message: AlertMessage(title: "Update User Data".localiz(), body: message))
                            }
                            
                        } else {
                            self!.showAlertWith(message: AlertMessage(title: "Update User Data".localiz(), body: message))
                        }
                        
                    }
                       
                }
                
            }
            
        })
        
    }
    
    private func bindUI(btnName : String) {
        
        self.viewModel?.alertMessage.bind({ [weak self] in
            MBProgressHUD.hide(for: self!.view, animated: true)
            self?.showAlertDismissOnly(message: $0)
        })
        
        
        self.viewModel?.response.bind({ [weak self] in
            
            if let response = $0 {
                MBProgressHUD.hide(for: self!.view, animated: true)
                let userStatus = DataDecryption().decryption(jsonModel: PayloadRes(iv: response.iv, payload: response.payload))
                
                if userStatus != nil {
                    
                    let status = userStatus?.value(forKey: "status") as? String ?? ""
                    
                    if status == "" {
                        
                        if btnName == "ADD" {
                            self?.add(self!.btnAddUser)
                        } else {
                            self?.resendLinkBtnTap(self!.resendLinkBtn)
                        }
                        
                    } else {
                        
                        var message = ""
                        
                        if let msg  = userStatus?.value(forKey: "message")
                        {
                            message = msg as! String
                        }
                        var status = "Success"
                        
                        if  let stat  = userStatus?.value(forKey: "status")
                        {
                            status = stat  as! String
                        }
                        if status == "Success"{
                            if self!.API_REQUEST == "addUser"{
                                let errorCode : String = userStatus?.value(forKey: "errorCode") as! String
                                if errorCode == "S101"{
                                    //                                            print(message)
                                    
                                    let isWhatsAppOn : Bool = false
                                    
                                    print(self!.selectedLinks)
                                    for i in 0 ..< self!.selectedLinks.count {
                                        let link = self!.selectedLinks[i]
                                        print(link)
                                        if link.contains("Whatsapp")
                                        {
                                            /*
                                             let urlWhats = "whatsapp://send?phone=+965\(self!.tfMobileNo.text ?? "")&text=Dear \(self?.tfUsername.text ?? "User") You have been granted viewing rights access to Tijarati,a true business owner\'s app by You have been granted viewing rights access to Tijarati,a true business owner\'s app by \(AppConstants.UserData.name) Download the app now: https://burgan.page.link/u9DC"
                                             */
                                            
                                            /*
                                            let urlWhats = "whatsapp://send?phone=+965\(self!.tfMobileNo.text ?? "")&text=Dear \(self?.tfUsername.text ?? "User") You have been granted viewing rights access to Tijarati,a true business owner\'s app by \(AppConstants.UserData.name). Download the app now: https://burgan.page.link/u9DC"
                                            */
                                            
                                            let urlWhats = "whatsapp://send?phone=+965\(self!.tfMobileNo.text ?? "")&text=\("Dear User, You have been granted access to the Tijarati application, with the rights to display the Business Owner Platform of ".localiz()) \(AppConstants.UserData.name)\(". Download the app now:".localiz()) https://burgan.page.link/u9DC"
                                            
                                            
                                            if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
                                                if let whatsappURL = URL(string: urlString) {
                                                    if UIApplication.shared.canOpenURL(whatsappURL) {
                                                        UIApplication.shared.open(whatsappURL)
                                                        
                                                        let alertController = UIAlertController(title: "Add User".localiz(), message: message.localiz(), preferredStyle: .alert)
                                                        let action = UIAlertAction(title: "Ok".localiz(), style: .cancel) { (action) in
                                                            self?.navigationController?.popViewController(animated: true)
                                                        }
                                                        alertController.addAction(action)
                                                        self?.present(alertController, animated: true, completion: nil)
                                                        
                                                    } else {
                                                        print("Install Whatsapp")
                                                        //self?.AlertMsg(title: "Install Whatsapp".localiz())
                                                        
                                                        let alertController = UIAlertController(title: "Install Whatsapp".localiz(), message: "", preferredStyle: .alert)
                                                        let action = UIAlertAction(title: "Ok".localiz(), style: .cancel) { (action) in
                                                            
                                                            // Alert After scussesfully update user
                                                            let alertController = UIAlertController(title: "Add User".localiz(), message: message.localiz(), preferredStyle: .alert)
                                                            let action = UIAlertAction(title: "Ok".localiz(), style: .cancel) { (action) in
                                                                self?.navigationController?.popViewController(animated: true)
                                                            }
                                                            alertController.addAction(action)
                                                            self?.present(alertController, animated: true, completion: nil)
                                                            
                                                        }
                                                        alertController.addAction(action)
                                                        self?.present(alertController, animated: true, completion: nil)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    
                                    if isWhatsAppOn == true {
                                        
                                    } else {
                                        
                                        // Alert After scussesfully Add user
                                        let alertController = UIAlertController(title: "Add User".localiz(), message: message.localiz(), preferredStyle: .alert)
                                        let action = UIAlertAction(title: "Ok".localiz(), style: .cancel) { (action) in
                                            self?.navigationController?.popViewController(animated: true)
                                        }
                                        alertController.addAction(action)
                                        self?.present(alertController, animated: true, completion: nil)
                                        
                                    }
                                    
                                    /*
                                     let alertController = UIAlertController(title: "Add User".localiz(), message: message.localiz(), preferredStyle: .alert)
                                     let action = UIAlertAction(title: "Ok".localiz(), style: .cancel) { (action) in
                                     self?.navigationController?.popViewController(animated: true)
                                     }
                                     alertController.addAction(action)
                                     self?.present(alertController, animated: true, completion: nil)
                                     */
                                    
                                    
                                    //                                            self?.navigationController?.popViewController(animated: true)
                                    
                                    //                                            self!.showAlertWith(message: AlertMessage(title: "Add User", body: message))
                                    //self?.dismiss(animated: true, completion: nil)
                                }else{
                                    self!.showAlertWith(message: AlertMessage(title: "Add User".localiz(), body: message.localiz()))
                                }
                            }else{
                                
                            }
                            
                            
                        }else{
                            self!.showAlertWith(message: AlertMessage(title: "Add User".localiz(), body: message.localiz()))
                        }
                        
                    }
                    
                    
                    
                }
                
            }
            
            
        })
        
    }
    @IBOutlet weak var okAccessGrantedBtn: GradientLayer!
    func popupShadow(view:UIView){
        view.layer.shadowColor = UIColor.BurganColor.brandGray.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        view.layer.shadowOpacity = 1.0
        view.layer.shadowRadius = 10.0
        view.layer.masksToBounds = false
    }
    func tapGesture(){
        let tapDBADetailGesture = UITapGestureRecognizer(target: self, action: #selector(self.showDBADetails))
        ivToggleDBAArrow.isUserInteractionEnabled = true; self.ivToggleDBAArrow.addGestureRecognizer(tapDBADetailGesture)
        
        let tapSelectDBAGesture = UITapGestureRecognizer(target: self, action: #selector(self.selectDBALocation))
        curvedDBAView.isUserInteractionEnabled = true; self.curvedDBAView.addGestureRecognizer(tapSelectDBAGesture)
        
        let tapSelectReportGesture = UITapGestureRecognizer(target: self, action: #selector(self.selectReports))
        curvedReportsView.isUserInteractionEnabled = true; self.curvedReportsView.addGestureRecognizer(tapSelectReportGesture)
    }
    @objc func selectReports(sender: UITapGestureRecognizer){
        
        if tfUsername.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true
        {
            AlertMsg(title: "Please enter User Name".localiz())
        } else if tfEmailId.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
            AlertMsg(title: "Please enter Email Address".localiz())
        } else if tfEmailId.emailValidation() == false {
            AlertMsg(title: "Please enter valid Email Address".localiz())
        }  else if tfMobileNo.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
            AlertMsg(title: "Please enter Mobile Number".localiz())
        }else if !UAE_MobileValidation(value: tfMobileNo.text!){
            AlertMsg(title: "Please enter 8 digit Mobile Number".localiz())
        }  else {
            let controller = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProfilePopupsViewController") as? ProfilePopupsViewController)!
            controller.popupType = 4
            controller.linkDelegate = self
            presentAsStork(controller, height: 450, cornerRadius: 8.0, showIndicator: false, showCloseButton: false)
        }
    }
    
    @objc func selectDBALocation(sender: UITapGestureRecognizer) {
        
        if tfUsername.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true
        {
            AlertMsg(title: "Please enter User Name".localiz())
        } else if tfEmailId.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
            AlertMsg(title: "Please enter Email Address".localiz())
        } else if tfEmailId.emailValidation() == false {
            AlertMsg(title: "Please enter valid Email Address".localiz())
        }  else if tfMobileNo.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
            AlertMsg(title: "Please enter Mobile Number".localiz())
        }else if !UAE_MobileValidation(value: tfMobileNo.text!){
            AlertMsg(title: "Please enter 8 digit Mobile Number".localiz())
        }  else {
            
            if AppConstants.selectedFilter != nil {
                let controller = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SelectLocationViewController") as? SelectLocationViewController)!
                controller.delegateFilter = self
                controller.delegate = self
                controller.isFromProfile = true
                presentAsStork(controller, height: 500, cornerRadius: 8.0, showIndicator: false, showCloseButton: false)
            }else{
                showAlertWith(message: AlertMessage(title: "Tijarati".localiz(), body: "No data available to filter.".localiz()))
            }
        }
    }
    
    
    var isDBADetailOpen = false
    var userDetail : userData?
    @IBOutlet weak var lblBrandList: UILabel!
    @IBOutlet weak var lblCIDName: UILabel!
    var dbaArray : [Hierarchy] = []
    func brandArray(hierarchyArr : [Hierarchy]) -> String{
        var brands : [String] = []
        
        for i in 0..<hierarchyArr.count{
            if hierarchyArr[i].brandNameList.count > 0{
                for k in 0..<hierarchyArr[i].brandNameList.count{
                    brands.append(hierarchyArr[i].brandNameList[k].brandName)
                    
                }
            }
        }
        let formattedArray = (brands.map{String($0)}).joined(separator: ",")
        return formattedArray
    }
    
    func userInfo(){
        
        DBADetailCurvedViewHeight.constant = 160
        
        if (showUserDetail) {
            lblToolBarTitle.text = "User Details".localiz()
            
            ivUserName.image = UIImage(named: "ic_name_filled")
            nameHeight.constant = 100
            btnAddUser.setTitle("RE-SEND LINK".localiz(), for: .normal)
            resendLinkBtn.isHidden = false
            btnAddUser.isHidden = true
            
            hasDBAInfo =  true
            ivPhoneBookView.isHidden = true
            curvedDBAView.isHidden = true
            curvedReportsView.isHidden = true
            userStatus.isHidden = false
            lblDBAAssigned.isHidden = false
            lblDBAAssigned.text = String(userDetail!.hierarchy!.count) + " DBA's Assigned"
            userStatus.text = userDetail?.status?.localiz()
            
            btnEditUser.isHidden = false
            btnEditDBAList.isHidden = true
            btnEditReports.isHidden = true
            tfUsername.text = userDetail?.name
            tfMobileNo.text = userDetail?.mobile
            tfEmailId.text = userDetail?.emailID
            
            tfUsername.isUserInteractionEnabled = false
            tfMobileNo.isUserInteractionEnabled = false
            tfEmailId.isUserInteractionEnabled = false
            
            if userDetail?.isViewEnabled == "false" {
                isViewEnabled = false
            } else {
                isViewEnabled = true
            }
            
            if userDetail?.isReportsEnabled == "false" {
                isReportsEnabled = false
                selectedReports = []
            } else {
                isReportsEnabled = true
                
                if userDetail?.reportList?.count ?? 0 > 0 {
                    //selectedReports = userDetail!.reportList!
                    
                    for obj in userDetail!.reportList! {
                        selectedReports.append(obj.trimmingCharacters(in: .whitespaces))
                    }
                    print(selectedReports)
                    
                } else {
                    selectedReports = []
                }
                self.selectedReports(reports: selectedReports)
                
            }
            
            
            if isViewEnabled {
                DBADetailCurvedView.isHidden = false
                lblDBAAssigned.isHidden = false
                
                if userDetail!.hierarchy!.count > 0 {
                    dbaArray = userDetail!.hierarchy!
                    lblBrandList.text =  brandArray(hierarchyArr: userDetail!.hierarchy!)
                    tbDBAlist.reloadData()
                    
                    for obj in userDetail!.hierarchy! {
                        
                        for data in AppConstants.locationFilterData!.filterData {
                            
                            if data.accountList.contains(obj.accountNumber) {
                                
                                self.lblCIDName.text = data.companyName
                            }
                        }
                    }
                }
            } else {
                DBADetailCurvedView.isHidden = true
                lblDBAAssigned.isHidden = true
            }
            
            if isReportsEnabled{
                reportAccessDetailView.isHidden = false
            } else {
                reportAccessDetailView.isHidden = true
            }
            
        } else {
            
            lblToolBarTitle.text = "Add User".localiz()
            
            resendLinkBtn.isHidden = true
            btnAddUser.setTitle("ADD".localiz(), for: .normal)
            btnAddUser.isHidden = false
            ivUserName.image = UIImage(named: "ic_user")
            nameHeight.constant = 60
            ivPhoneBookView.isHidden = false
            
            if(hasDBAInfo)
            {
                curvedDBAView.isHidden = true
                curvedReportsView.isHidden = true
                DBADetailCurvedView.isHidden = false
                reportAccessDetailView.isHidden = false
            } else {
                curvedDBAView.isHidden = false
                curvedReportsView.isHidden = false
                DBADetailCurvedView.isHidden = true
                reportAccessDetailView.isHidden = true
            }
            btnEditReports.isHidden = false
            btnEditDBAList.isHidden = false
            btnEditUser.isHidden = true
            userStatus.isHidden = true
            lblDBAAssigned.isHidden = true
        }
    }
    
    @IBOutlet weak var btnEditDBAList: UIButton!
    @IBAction func editDBAList(_ sender: Any) {
        if AppConstants.selectedFilter != nil {
            let controller = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SelectLocationViewController") as? SelectLocationViewController)!
            controller.delegateFilter = self
            presentAsStork(controller, height: 500, cornerRadius: 8.0, showIndicator: false, showCloseButton: false)
        }else{
            showAlertWith(message: AlertMessage(title: "Tijarati".localiz(), body: "No data available to filter.".localiz()))
        }
    }
    @IBOutlet weak var userStatus: UILabel!
    @IBOutlet weak var lblDBAAssigned: UILabel!
    @IBOutlet weak var ivToggleDBAArrow: UIImageView!
    @IBAction func goback(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var btnAddUser: UIButton!
    @objc func showDBADetails(sender: UITapGestureRecognizer){
        if(isDBADetailOpen){
            isDBADetailOpen = false
            ivToggleDBAArrow.image = UIImage(named: "ic_down_arrow_grey")
            DBADetailCurvedViewHeight.constant = 160
            DBABrandListView.isHidden = false
            DBASeparatorView2.isHidden = false
            DBASeparatorView3.isHidden = false
            
        }else{
            ivToggleDBAArrow.image = UIImage(named: "ic_up_arrow_grey")
            DBABrandListView.isHidden = true
            isDBADetailOpen = true
            // DBADetailCurvedViewHeight.constant = 360
            DBADetailCurvedViewHeight.constant = CGFloat(dbaArray.count * 150 + 70)
            DBASeparatorView2.isHidden =  true
            DBASeparatorView3.isHidden = true
        }
    }
    
    @IBOutlet weak var DBASeparatorView3: UIView!
    @IBOutlet weak var DBASeparatorView2: UIView!
    @IBOutlet weak var DBABrandListView: UIStackView!
    let merchant : [String]  = ["\(AppConstants.merchantNumber)"]
    
    func AlertMsg(title: String)
    {
        let alertView = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler:nil)
        alertView.addAction(okAction)
        self.present(alertView, animated: true, completion: nil)
    }
    
    func validate() -> Bool
    {
        if tfUsername.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true
        {
            AlertMsg(title: "Please enter User Name".localiz())
            return false
        } else if tfEmailId.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
            AlertMsg(title: "Please enter Email Address".localiz())
            return false
        } else if tfEmailId.emailValidation() == false {
            AlertMsg(title: "Please enter valid Email Address".localiz())
            return false
        }  else if tfMobileNo.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
            AlertMsg(title: "Please enter Mobile Number".localiz())
            return false
        }else if !UAE_MobileValidation(value: tfMobileNo.text!){
            AlertMsg(title: "Please enter 8 digit Mobile Number".localiz())
            return false
        } else if dbaArray.count <= 0 {
            AlertMsg(title: "Please select the DBA's and Locations".localiz())
            return false
        } else {
            return true
        }
        
        
    }
    
    func UAE_MobileValidation(value: String) -> Bool
    {
        let PHONE_REGEX = "^\\d{8}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
        
    }
    
    
    @IBAction func add(_ sender: Any) {
        
        if validate() {
            
            if selectedLinks.count > 0 {
                
                if userDetail?.userID != nil
                {
                    showUserDetail = true
                }
                else
                {
                    showUserDetail = false
                }
                
                if selectedReports.count > 0
                {
                    isReportsEnabled = true
                    
                }
                else
                {
                    isReportsEnabled = false
                }
                
                var merchantNumber : [Int] = []
                for i in 0..<dbaArray.count{
                    for j in 0..<dbaArray[i].brandNameList.count{
                        for k in 0..<dbaArray[i].brandNameList[j].locationNameList.count{
                            for l in 0..<dbaArray[i].brandNameList[j].locationNameList[k].merchantNumber.count
                            {
                                let m : Int = Int(dbaArray[i].brandNameList[j].locationNameList[k].merchantNumber[l].mid)!
                                merchantNumber.append(m)
                            }
                        }
                    }
                }
                
                //                let merchantNum : String  = "\(merchantNumber)"
                
                if showUserDetail {
                    
                    if showUserDetailDBAEdit {
                        
                        //                        let myMerchant : String  = "\(merchantNumber)"
                        let myMerchant : String  = "\(AppConstants.merchantNumber)"
                        
                        
                        let param : [String : Any] = ["cif" : AppConstants.selectedFilter!.cif,
                                                      "deviceId" : AppConstants.UserData.deviceID,
                                                      "userID" : userDetail!.userID!,
                                                      "name" : tfUsername.text!,
                                                      "mobile" : tfMobileNo.text!,
                                                      "emailID" : tfEmailId.text!,
                                                      "isViewEnabled" : isViewEnabled,
                                                      "isReportsEnabled" : isReportsEnabled,
                                                      "merchantNum" : myMerchant,
                                                      "reportList" : "\(selectedReports)",
                            "LinkShare" : selectedLinks]
                        print(param)
                        MBProgressHUD.showAdded(to: self.view, animated: true)
                        self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.modifyUser)
                        self.bindUIUpdateUser(btnName: "ADD")
                        
                        
                    } else {
                        
                        let myMerchant : String  = "\(merchantNumber)"
                        
                        let param : [String : Any] = ["cif" : AppConstants.selectedFilter!.cif,
                                                      "deviceId" : AppConstants.UserData.deviceID,
                                                      "userID" : userDetail!.userID!,
                                                      "name" : tfUsername.text!,
                                                      "mobile" : tfMobileNo.text!,
                                                      "emailID" : tfEmailId.text!,
                                                      "isViewEnabled" : isViewEnabled,
                                                      "isReportsEnabled" : isReportsEnabled,
                                                      "merchantNum" : myMerchant,
                                                      "reportList" : "\(selectedReports)",
                            "LinkShare" : selectedLinks]
                        print(param)
                        MBProgressHUD.showAdded(to: self.view, animated: true)
                        self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.modifyUser)
                        self.bindUIUpdateUser(btnName: "ADD")
                        
                    }
                    /*
                     //                    let myMerchant : String  = "\(AppConstants.merchantNumber)"
                     let myMerchant : String  = "\(merchantNumber)"
                     
                     let param : [String : Any] = ["cif" : AppConstants.selectedFilter!.cif,
                     "deviceId" : AppConstants.UserData.deviceID,
                     "userID" : userDetail!.userID!,
                     "name" : tfUsername.text!,
                     "mobile" : tfMobileNo.text!,
                     "emailID" : tfEmailId.text!,
                     "isViewEnabled" : isViewEnabled,
                     "isReportsEnabled" : isReportsEnabled,
                     "merchantNum" : myMerchant,
                     "reportList" : "\(selectedReports)",
                     "LinkShare" : selectedLinks]
                     print(param)
                     MBProgressHUD.showAdded(to: self.view, animated: true)
                     self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.modifyUser)
                     self.bindUIUpdateUser()
                     */
                }else{
                    
                    let myMerchant : [String]  = ["\(AppConstants.merchantNumber)"]
                    //                    let myMerchant : [String]  = ["\(merchantNumber)"]
                    
                    
                    let param : [String : Any] = ["cif" : AppConstants.selectedFilter!.cif,
                                                  "deviceId" : AppConstants.UserData.deviceID,
                                                  "name" : tfUsername.text!,
                                                  "mobile" : tfMobileNo.text!,
                                                  "emailID" : tfEmailId.text!,
                                                  "isViewEnabled" : isViewEnabled,
                                                  "isReportsEnabled" : isReportsEnabled,
                                                  "merchantNum" : myMerchant,
                                                  "reportList" : selectedReports,
                                                  "LinkShare" : selectedLinks]
                    print(param)
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                    self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.addUser)
                    self.bindUI(btnName: "ADD")
                }
                
                /*
                 print(selectedLinks)
                 for i in 0 ..< selectedLinks.count
                 {
                 let link = selectedLinks[i]
                 print(link)
                 if link.contains("Whatsapp")
                 {
                 let urlWhats = "whatsapp://send?phone=+965\(tfMobileNo.text ?? "")&text=You have been granted permission to access Tijarati App"
                 if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
                 if let whatsappURL = URL(string: urlString) {
                 if UIApplication.shared.canOpenURL(whatsappURL) {
                 UIApplication.shared.open(whatsappURL)
                 } else {
                 print("Install Whatsapp")
                 AlertMsg(title: "Install Whatsapp".localiz())
                 }
                 }
                 }
                 }
                 }
                 */
            }
            else
            {
                notifyVia(showNotifyPopup: true)
            }
        }
        
    }
    @IBAction func btnLinkSentPopup(_ sender: Any) {
        linkSentPopupView.isHidden = true
        curvedDBAView.isHidden = true
        DBADetailCurvedView.isHidden = true
    }
    @IBOutlet weak var btnEditReports: UIButton!
    @IBOutlet weak var btnOKLinkSent: GradientLayer!
    @IBAction func editReports(_ sender: Any) {
        let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProfilePopupsViewController") as? ProfilePopupsViewController
        controller!.popupType = 4
        controller?.linkDelegate = self
        controller?.selectedReports = self.selectedReports
        presentAsStork(controller!, height: 450, cornerRadius: 10, showIndicator: false, showCloseButton: false)
    }
    @IBAction func editUserInfo(_ sender: Any) {
        //        showUserDetail = false
        //        userInfo()
        
        lblToolBarTitle.text = "Edit User".localiz()
        
        tfUsername.isUserInteractionEnabled = true
        tfMobileNo.isUserInteractionEnabled = false
        tfEmailId.isUserInteractionEnabled = true
        
        resendLinkBtn.isHidden = true
        btnAddUser.setTitle("SAVE".localiz(), for: .normal)
        btnAddUser.isHidden = false
        ivUserName.image = UIImage(named: "ic_user")
        nameHeight.constant = 60
        ivPhoneBookView.isHidden = false
        
        if(hasDBAInfo)
        {
            curvedDBAView.isHidden = true
            curvedReportsView.isHidden = true
            DBADetailCurvedView.isHidden = false
            reportAccessDetailView.isHidden = false
        }else{
            curvedDBAView.isHidden = false
            curvedReportsView.isHidden = false
            DBADetailCurvedView.isHidden = true
            reportAccessDetailView.isHidden = true
        }
        btnEditReports.isHidden = false
        btnEditDBAList.isHidden = false
        btnEditUser.isHidden = true
        userStatus.isHidden = true
        lblDBAAssigned.isHidden = true
    }
    
    var selectedLinks = [String]()
    
    func showLinkSent(Links: [String])
    {
        selectedLinks = Links
        linkSentPopupView.isHidden = true
        accessGrantedPopupView.isHidden = true
    }
    
    
    @IBAction func closeLinkPopup(_ sender: Any) {
        linkSentPopupView.isHidden = true
    }
    @IBOutlet weak var linksentShadowView: UIView!
    @IBOutlet weak var lblCreditBankReport: PaddingLabel!
    @IBOutlet weak var lblTransactnReport: PaddingLabel!
    @IBOutlet weak var lblSettlemntReport: PaddingLabel!
    
    func curvedviewShadow(view:UIView){
        view.layer.cornerRadius = 8
        view.layer.shadowOpacity = 0.35
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowRadius = 3.0
        view.layer.shadowColor = UIColor.BurganColor.brandGray.lgiht.cgColor
        view.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner,.layerMaxXMinYCorner]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dbaArray.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? tbDBACell else { return }
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tbDBACell", for: indexPath) as! tbDBACell
        
        if AppConstants.language == .ar {
            cell.lblBrand.textAlignment = .right
            cell.lblAccountNo.textAlignment = .right
        } else {
            cell.lblBrand.textAlignment = .left
            cell.lblAccountNo.textAlignment = .left
        }
        
        cell.collectionViewOffset = 10
        var brands : [String] = []
        locationsArray.removeAll()
        cell.lblAccountNo.text = dbaArray[indexPath.row].accountNumber
        
        if(showUserDetail) {
            
            if showUserDetailDBAEdit {
                
                if dbaArray[indexPath.row].brandNameList.count > 0 {
                    for i in 0..<dbaArray[indexPath.row].brandNameList.count {
                        
                        // new line condition
                        if (AppConstants.selectedFilter?.selectedBrands.contains(where: { $0.contains(dbaArray[indexPath.row].brandNameList[i].brandName.uppercased()) }))!  {
                            
                            brands.append(dbaArray[indexPath.row].brandNameList[i].brandName.uppercased())
                            
                            if dbaArray[indexPath.row].brandNameList[i].locationNameList.count > 0{
                                for k in 0..<dbaArray[indexPath.row].brandNameList[i].locationNameList.count {
                                    if (AppConstants.selectedFilter?.selectedLocations.contains(where: { $0 == dbaArray[indexPath.row].brandNameList[i].locationNameList[k].locationName }))! {
                                        
                                        locationsArray.append(dbaArray[indexPath.row].brandNameList[i].locationNameList[k])
                                    }
                                    //                                    locationsArray.append(dbaArray[indexPath.row].brandNameList[i].locationNameList[k])
                                }
                                cell.locationCv.reloadData()
                            }
                            
                        }
                        //                brands.append(dbaArray[indexPath.row].brandNameList[i].brandName.uppercased())
                        //
                        //                if dbaArray[indexPath.row].brandNameList[i].locationNameList.count > 0{
                        //                    for k in 0..<dbaArray[indexPath.row].brandNameList[i].locationNameList.count {
                        //                        locationsArray.append(dbaArray[indexPath.row].brandNameList[i].locationNameList[k])
                        //                    }
                        //                    cell.locationCv.reloadData()
                        //                }
                    }
                    let formattedArray = (brands.map{String($0)}).joined(separator: ",")
                    cell.lblBrand.text = formattedArray
                }
                
            } else {
                
                if dbaArray[indexPath.row].brandNameList.count > 0 {
                    for i in 0..<dbaArray[indexPath.row].brandNameList.count {
                        
                        brands.append(dbaArray[indexPath.row].brandNameList[i].brandName.uppercased())
                        
                        if dbaArray[indexPath.row].brandNameList[i].locationNameList.count > 0{
                            for k in 0..<dbaArray[indexPath.row].brandNameList[i].locationNameList.count {
                                locationsArray.append(dbaArray[indexPath.row].brandNameList[i].locationNameList[k])
                            }
                            cell.locationCv.reloadData()
                        }
                    }
                    let formattedArray = (brands.map{String($0)}).joined(separator: ",")
                    cell.lblBrand.text = formattedArray
                }
            }
            
        } else {
            
            if dbaArray[indexPath.row].brandNameList.count > 0 {
                for i in 0..<dbaArray[indexPath.row].brandNameList.count {
                    
                    // new line condition
                    if (AppConstants.selectedFilter?.selectedBrands.contains(where: { $0.contains(dbaArray[indexPath.row].brandNameList[i].brandName.uppercased()) }))!  {
                        
                        brands.append(dbaArray[indexPath.row].brandNameList[i].brandName.uppercased())
                        
                        if dbaArray[indexPath.row].brandNameList[i].locationNameList.count > 0{
                            for k in 0..<dbaArray[indexPath.row].brandNameList[i].locationNameList.count {
                                
                                if (AppConstants.selectedFilter?.selectedLocations.contains(where: { $0 == dbaArray[indexPath.row].brandNameList[i].locationNameList[k].locationName }))! {
                                    
                                    locationsArray.append(dbaArray[indexPath.row].brandNameList[i].locationNameList[k])
                                }
                                //                                locationsArray.append(dbaArray[indexPath.row].brandNameList[i].locationNameList[k])
                            }
                            cell.locationCv.reloadData()
                        }
                        
                    }
                    //                brands.append(dbaArray[indexPath.row].brandNameList[i].brandName.uppercased())
                    //
                    //                if dbaArray[indexPath.row].brandNameList[i].locationNameList.count > 0{
                    //                    for k in 0..<dbaArray[indexPath.row].brandNameList[i].locationNameList.count {
                    //                        locationsArray.append(dbaArray[indexPath.row].brandNameList[i].locationNameList[k])
                    //                    }
                    //                    cell.locationCv.reloadData()
                    //                }
                }
                let formattedArray = (brands.map{String($0)}).joined(separator: ",")
                cell.lblBrand.text = formattedArray
            }
            
        }
        
        return cell
    }
    
    var locationsArray : [LocationNameList] = []
}

extension AddUserViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locationsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellLocationCv", for: indexPath) as! cvCompanyLocationListCell
        cell.layer.cornerRadius = 3
        
        cell.lblName.text = locationsArray[indexPath.row].locationName
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width - 10, height: collectionView.frame.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5;
    }
    
    
    func showAccessGranted() {
        linkSentPopupView.isHidden = true
        accessGrantedPopupView.isHidden = false
    }
    
    
}

extension UIViewController {
    
    //Align Textfield Text
    
    func loopThroughSubViewAndAlignTextfieldText(subviews: [UIView]) {
        if subviews.count > 0 {
            for subView in subviews {
                if subView is UITextField && subView.tag <= 0{
                    let textField = subView as! UITextField
                    textField.textAlignment = AppConstants.language == .ar ? .right: .left
                } else if subView is UITextView && subView.tag <= 0{
                    let textView = subView as! UITextView
                    textView.textAlignment = AppConstants.language == .ar ? .right: .left
                    
                }
                
                loopThroughSubViewAndAlignTextfieldText(subviews: subView.subviews)
            }
        }
    }
    
    
    //Align Label Text
    func loopThroughSubViewAndAlignLabelText(subviews: [UIView]) {
        if subviews.count > 0 {
            for subView in subviews {
                if subView is UILabel && subView.tag <= 0 {
                    let label = subView as! UILabel
                    label.textAlignment = AppConstants.language == .ar ? .right : .left
                }
                loopThroughSubViewAndAlignLabelText(subviews: subView.subviews)
            }
        }
    }
    
    //Align Label Text
    func loopThroughSubViewAndMirrorImage(subviews: [UIView]) {
        if subviews.count > 0 {
            for subView in subviews {
                if subView is UIButton && subView.tag == 999 {
                    let btn = subView as! UIButton
                    
                    btn.imageView?.transform = AppConstants.language == .ar ? CGAffineTransform(scaleX: -1, y: 1) : CGAffineTransform(scaleX: 1, y: 1)
                }
                
                if subView is UIImageView && subView.tag == 999 {
                    let imgView = subView as! UIImageView
                    
                    imgView.transform = AppConstants.language == .ar ? CGAffineTransform(scaleX: -1, y: 1) : CGAffineTransform(scaleX: 1, y: 1)
                }
                
                loopThroughSubViewAndMirrorImage(subviews: subView.subviews)
            }
        }
    }
    
    
}
