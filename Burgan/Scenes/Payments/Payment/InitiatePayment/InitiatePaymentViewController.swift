//
//  InitiatePaymentViewController.swift
//  GuageMeterDemo
//
//  Created by Pratik on 12/07/21.
//

import UIKit
import ContactsUI
import Alamofire
import MBProgressHUD

class InitiatePaymentViewController: UIViewController, UITextFieldDelegate {
    
    ///COLLECT PAYMENT
    @IBOutlet var collectPaymentCollSVRef: UIScrollView!
    @IBOutlet weak var kdLabel: UILabel!
    
    @IBOutlet var collectPaymentBtnRef: UIButton!
    @IBOutlet var bulkPaymentBtnRef: UIButton!
    @IBOutlet var initiatePaymentBtnRef: UIButton!
    @IBOutlet var phoneNoTfRef: UITextField!
    @IBOutlet var nameTfRef: UITextField!
    @IBOutlet var emailIdTfRef: UITextField!
    @IBOutlet var kdTfRef: UITextField!
    @IBOutlet var descriptionTfRef: UITextField!

    @IBOutlet var checkBtnRef: UIButton!
    
    @IBOutlet var uploadProgressBarRef: UIProgressView!
    
    ///BULK PAYMENT COLLECTION
    @IBOutlet var bulkPaymentCollSVRef: UIScrollView!
    @IBOutlet var bulkUploadFileViewRef: UIView!
    @IBOutlet var downloadFormatLblRef: UILabel!
    let text = "Please refer to the format to upload ".localiz() + "Download the format".localiz()

    @IBOutlet var bulkPreviousOrderTvRef: UITableView!
    @IBOutlet var bulkPreviousOrderTvHeightRef: NSLayoutConstraint!
    
    @IBOutlet weak var uploqdFIleTitleLabel: UILabel!
    @IBOutlet weak var previouslyUploadTitleLbl: UILabel!
    @IBOutlet var uploadFileTextViewRef: UIView!
    @IBOutlet var uploadingFileLblRef: UILabel!
    @IBOutlet var uploadingFileNameLblRef: UILabel!
    
    @IBOutlet private var multiRadioButton: [UIButton]! {
        didSet{
            multiRadioButton.forEach { (button) in
                button.setImage(UIImage(named:"radio-off-button"), for: .normal)
                button.setImage(UIImage(named:"radio-on-button"), for: .selected)
                button.setTitleColor(UIColor.init(hexString: "263238"), for: .normal)
                button.setTitleColor(UIColor.init(hexString: "0065A6"), for: .selected)
            }
        }
    }
    
    @IBOutlet weak var selectLanguageLabel: UILabel!

    var showCollectPayment = true
    var showBulkPayment = false
    
    var initiatePaymentLang: String = "EN"
    
    //api
    var viewModel : RegistrationViewControllerViewModelProtocol?

    var bulkTransactionData = BulkPaymentTransactionApi()
    var historyData = FileUploadHistoryResponse()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectPaymentBtnRef.layer.cornerRadius = 5
        bulkPaymentBtnRef.layer.cornerRadius = 5
        
        initiatePaymentBtnRef.layer.cornerRadius = 5
        
        collectPaymentBtnRef.layer.borderWidth = 1
        bulkPaymentBtnRef.layer.borderWidth = 1

        collectPaymentBtnRef.layer.borderColor = UIColor.init(hexString: "0065A6").cgColor
        bulkPaymentBtnRef.layer.borderColor = UIColor.init(hexString: "0065A6").cgColor
        
        ///COLLECT PAYMENT
        collectPaymentMethodCall()
       
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
        
        ///BULK PAYMENT COLLECTION
        bulkPaymentCollectionMethodCall()
        
        BulkPaymentFileConfirmAndSendViewController.instance.setListener(listener: self)
        
        radioButtonSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bulkUploadFileViewRef.addDashedBorder()
        arabicSetup()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //bulkUploadFileViewRef.addDashedBorder()
    }
    
    func radioButtonSetup() -> Void {
        multiRadioButton.forEach { (button) in
            if button.tag == 1 {
                button.isSelected = true
                initiatePaymentLang = "EN"
            }
        }
    }
    
    ///Create two separate actions
    /*
    @IBAction private func maleAction(_ sender: UIButton){
        uncheck()
        sender.checkboxAnimation {
            print(sender.titleLabel?.text ?? "")
            print(sender.isSelected)

        }
    }

    @IBAction private func femaleAction(_ sender: UIButton){
        uncheck()
        sender.checkboxAnimation {
            print(sender.titleLabel?.text ?? "")
            print(sender.isSelected)
        }
    }
    */
    
    //Handle with single Action
    @IBAction private func englishArabicAction(_ sender: UIButton){
        uncheck()
        sender.checkboxAnimation {
            print(sender.titleLabel?.text ?? "")
            print(sender.isSelected)
        }
        
        // NOTE:- here you can recognize with tag weather it is `Male` or `Female`.
        print(sender.tag)
        switch sender.tag {
        case 1:
            initiatePaymentLang = "EN"
            break
        case 2:
            initiatePaymentLang = "AR"
            break
        default:
            print("Default...")
        }
    }
    
    func uncheck(){
        multiRadioButton.forEach { (button) in
            button.isSelected = false
        }
    }
    
    private func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }

    func collectPaymentMethodCall(){
        phoneNoTfRef.attributedPlaceholder = NSAttributedString(string: "Enter a Phone Number".localiz(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hexString: "7F9DB8")])

        nameTfRef.attributedPlaceholder = NSAttributedString(string: "Payer Name".localiz(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hexString: "7F9DB8")])

        emailIdTfRef.attributedPlaceholder = NSAttributedString(string: "Email ID".localiz(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hexString: "7F9DB8")])

        kdTfRef.attributedPlaceholder = NSAttributedString(string: "00.000", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hexString: "7F9DB8")])
        kdLabel.textColor = UIColor.init(hexString: "7F9DB8")
        descriptionTfRef.attributedPlaceholder = NSAttributedString(string: "Description".localiz(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hexString: "7F9DB8")])
        
        initiatePaymentBtnRef.isEnabled = false

        phoneNoTfRef.addTarget(self, action: #selector(self.phoneNoTfValueChanged(_:)), for: UIControl.Event.editingChanged)
        phoneNoTfRef.delegate = self
        
        nameTfRef.addTarget(self, action: #selector(self.nameTfValueChanged(_:)), for: UIControl.Event.editingChanged)
        nameTfRef.delegate = self
        
        emailIdTfRef.addTarget(self, action: #selector(self.emailTfValueChanged(_:)), for: UIControl.Event.editingDidEnd)
        emailIdTfRef.delegate = self
        
        kdTfRef.addTarget(self, action: #selector(self.kDTfValueChanged(_:)), for: UIControl.Event.editingChanged)
        kdTfRef.delegate = self
        
        descriptionTfRef.addTarget(self, action: #selector(self.descriptionTfValueChanged(_:)), for: UIControl.Event.editingChanged)
        descriptionTfRef.delegate = self
        
        bulkPaymentCollSVRef.isHidden = true
    }
    
    func bulkPaymentCollectionMethodCall(){
        //bulkUploadFileViewRef.addDashedBorderssss()
        
        bulkUploadFileViewRef.layer.cornerRadius = 5
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(uploadBlukPaymentFile(_:)))
        bulkUploadFileViewRef.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
        
        downloadTheFormatLblFunc()
        
        bulkPreviousOrderTvRef.register(UINib(nibName: "BulkPreviousOrderTVC", bundle: nil), forCellReuseIdentifier: "cell")
        
        bulkPreviousOrderTvRef.tableFooterView = UIView()
        bulkPreviousOrderTvRef.separatorStyle = .none
        
        uploadProgressBarRef.layer.cornerRadius = 10
        uploadProgressBarRef.clipsToBounds = true
        uploadProgressBarRef.layer.sublayers![1].cornerRadius = 10
        uploadProgressBarRef.subviews[1].clipsToBounds = true

    }
    
    func resetUploadView(){
        uploadFileTextViewRef.isHidden = false
        uploadingFileNameLblRef.text = ""
        uploadProgressBarRef.progress = 0
    }
    
    func arabicSetup(){
        uploqdFIleTitleLabel.text = uploqdFIleTitleLabel.text?.localiz()
        uploadingFileLblRef.text = uploadingFileLblRef.text?.localiz()
        selectLanguageLabel.text = selectLanguageLabel.text?.localiz()
        previouslyUploadTitleLbl.text = previouslyUploadTitleLbl.text?.localiz()
        initiatePaymentBtnRef.setTitle("INITIATE PAYMENT".localiz(), for: .normal)
        collectPaymentBtnRef.setTitle("Collect Payment".localiz(), for: .normal)
        bulkPaymentBtnRef.setTitle("Bulk Payment Collection".localiz(), for: .normal)
        if AppConstants.language == .ar {
            collectPaymentBtnRef.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner]
            bulkPaymentBtnRef.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            phoneNoTfRef.textAlignment = .right
            nameTfRef.textAlignment = .right
            emailIdTfRef.textAlignment = .right
            kdTfRef.textAlignment = .right
            descriptionTfRef.textAlignment = .right
            selectLanguageLabel.textAlignment = .right
        } else {
            collectPaymentBtnRef.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            bulkPaymentBtnRef.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
            phoneNoTfRef.textAlignment = .left
            nameTfRef.textAlignment = .left
            emailIdTfRef.textAlignment = .left
            kdTfRef.textAlignment = .left
            descriptionTfRef.textAlignment = .left
            selectLanguageLabel.textAlignment = .left
        }
        multiRadioButton.forEach { (button) in
            if AppConstants.language == .ar {
                button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -10)
            } else {
                button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
            }
            
        }
    }
    
}

//MARK:- DOCUMENT PICKER
extension InitiatePaymentViewController: UIDocumentPickerDelegate{
    @objc func uploadBlukPaymentFile(_ sender: UIButton){
        let types: [String] = [
            "com.microsoft.excel.xls",
            "org.openxmlformats.spreadsheetml.sheet",
            "public.comma-separated-values-text"
        ]
        let documentPicker = UIDocumentPickerViewController(documentTypes: types, in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        uploadFileTextViewRef.isHidden = true
        uploadingFileNameLblRef.text = "\(myURL.lastPathComponent)"
        //uploadProgressBarRef.progressTintColor = #colorLiteral(red: 0.9450980392, green: 0.5568627451, blue: 0, alpha: 0.3408415333)
        //uploadProgressBarRef.setProgress(0.6, animated: true)
        UIView.animate(withDuration: 3, animations: { () -> Void in
            self.uploadProgressBarRef.setProgress(0.9, animated: true)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            
        print("Picked File Name : \(myURL.lastPathComponent)")
            self.uploadFileTextViewRef.isHidden = true
        
            self.viewModel = RegistrationViewControllerViewModel()
        do{
            let filePath = myURL
            let fileData = try Data.init(contentsOf: filePath)
            let fileStream:String = fileData.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))

        let param : [String : Any] = ["type":"mid",
                                      "cif" : AppConstants.UserData.companyCIF,
                                      "eZPayOutletNumber" : AppConstants.ezpayOutletNumber,
                                      "deviceId": AppConstants.UserData.deviceID,
                                      "File": fileStream,
                                      "fileName": myURL.lastPathComponent
        ]
        
        self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.bulkPaymentUpload)

            self.uploadBlukPaymentFileApi(Base64: fileStream, FileName: myURL.lastPathComponent)

        }catch{
            print(error.localizedDescription)
        }
        }
        
//        let vc = BulkPaymentFileUploadSuccessViewController(nibName: "BulkPaymentFileUploadSuccessViewController", bundle: nil)
//        vc.modalPresentationStyle = .custom
//        vc.transitioningDelegate = self
//        self.present(vc, animated: true, completion: nil)
    }
          


    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("File Picker Cancelled")
        dismiss(animated: true, completion: nil)
    }

}

//MARK:- TEXTFIELD VALUE CHANGE
extension InitiatePaymentViewController{
    @objc func phoneNoTfValueChanged(_ sender: UIButton){
        checkValidation()
    }
    
    @objc func emailTfValueChanged(_ sender: UIButton){
        //        checkValidation()
        if !(emailIdTfRef.text?.isEmpty ?? true) && isValidEmail(emailIdTfRef.text ?? "") == false {
            
            self.showAlertWith(message: AlertMessage(title: "Tijarati Pay".localiz(), body: "Invalid Email ID".localiz()))
//            setInitiatePaymentButton(isEnable: false, bgColorHex: "BFCEDB", titleColorHex: "7F9DB8")
            initiatePaymentBtnRef.isEnabled = false
            initiatePaymentBtnRef.backgroundColor = UIColor.init(hexString: "BFCEDB")
            initiatePaymentBtnRef.setTitleColor(UIColor(hexString: "7F9DB8"), for: .normal)
        }
    }
    
    @objc func nameTfValueChanged(_ sender: UIButton){
        checkValidation()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == kdTfRef {
            kdLabel.textColor = kdTfRef.text == "" ? UIColor.init(hexString: "7F9DB8") : .black
        }
    }
    
    @objc func kDTfValueChanged(_ sender: UIButton){
        if let amountString = kdTfRef.text?.currencyInputFormatting() {
            kdTfRef.text = amountString
        }
        checkValidation()
    }
    
    @objc func descriptionTfValueChanged(_ sender: UIButton){
        checkValidation()
    }
    
    
    func checkValidation() {
        
        func setInitiatePaymentButton(isEnable: Bool, bgColorHex: String, titleColorHex: String) {
            initiatePaymentBtnRef.isEnabled = isEnable
            initiatePaymentBtnRef.backgroundColor = UIColor.init(hexString: bgColorHex)
            initiatePaymentBtnRef.setTitleColor(UIColor(hexString: titleColorHex), for: .normal)
        }
        
        if isValidMobileNo(phoneNoTfRef.text ?? "") == false {
            
            setInitiatePaymentButton(isEnable: false, bgColorHex: "BFCEDB", titleColorHex: "7F9DB8")
            checkBtnRef.setImage(UIImage(named: ""), for: .normal)

        } else if kdTfRef.text == "" {
            
            setInitiatePaymentButton(isEnable: false, bgColorHex: "BFCEDB", titleColorHex: "7F9DB8")
        } else if nameTfRef.text == "" {

            setInitiatePaymentButton(isEnable: false, bgColorHex: "BFCEDB", titleColorHex: "7F9DB8")

        } else if descriptionTfRef.text == "" {

            setInitiatePaymentButton(isEnable: false, bgColorHex: "BFCEDB", titleColorHex: "7F9DB8")

        }
//        else if !(emailIdTfRef.text?.isEmpty ?? true) && isValidEmail(emailIdTfRef.text ?? "") == false {
//
//            self.showAlertWith(message: AlertMessage(title: "Tijarati Pay".localiz(), body: "Invalid Email ID".localiz()))
//            setInitiatePaymentButton(isEnable: false, bgColorHex: "BFCEDB", titleColorHex: "7F9DB8")
//
//        }
        else {

            setInitiatePaymentButton(isEnable: true, bgColorHex: "0065A6", titleColorHex: "FFFFFF")

            checkBtnRef.setImage(UIImage(named: "Icon checked"), for: .normal)

        }
    }
    
}
extension String {

    // formatting text for currency textField
    func currencyInputFormatting() -> String {

        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 3
//        formatter.minimumFractionDigits = 3

        var amountWithPrefix = self

        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")

        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 1000))

        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }

        // return formatter.string(from: number)!
        var myNumber = formatter.string(from: number)!
        if myNumber.contains(".") {
            if myNumber.suffix(2).contains(".") {
                myNumber.append("00")
            } else if myNumber.suffix(3).contains(".") {
                myNumber.append("0")
            }
        } else {
            myNumber.append(".000")
        }
        return myNumber
    }
}


//MARK:- BUTTON ACTION
extension InitiatePaymentViewController: UIViewControllerTransitioningDelegate{
    
    @IBAction func collectPaymentBtnTap(_ sneder: UIButton){
        collectPaymentBtnRef.backgroundColor = UIColor.init(hexString: "0065A6") // #colorLiteral(red: 0, green: 0.3960784314, blue: 0.6509803922, alpha: 1)
        bulkPaymentBtnRef.backgroundColor = .white // #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        collectPaymentBtnRef.setTitleColor(UIColor.white, for: .normal)
        bulkPaymentBtnRef.setTitleColor(UIColor.init(hexString: "0065A6"), for: .normal)
        
        showCollectPayment = true
        showBulkPayment = false
        
        collectPaymentCollSVRef.isHidden = false
        bulkPaymentCollSVRef.isHidden = true
        
        resetCollectPaymentView()
    }
    
    func resetCollectPaymentView() {
        phoneNoTfRef.text = ""
        nameTfRef.text = ""
        emailIdTfRef.text = ""
        kdTfRef.text = ""
        descriptionTfRef.text = ""
        
        radioButtonSetup()
    }

    @IBAction func bulkPaymentBtnTap(_ sneder: UIButton){
        collectPaymentBtnRef.backgroundColor = .white
        bulkPaymentBtnRef.backgroundColor = UIColor.init(hexString: "0065A6")
        
        collectPaymentBtnRef.setTitleColor(UIColor.init(hexString: "0065A6"), for: .normal)
        bulkPaymentBtnRef.setTitleColor(UIColor.white, for: .normal)

        
        showCollectPayment = false
        showBulkPayment = true

        collectPaymentCollSVRef.isHidden = true
        bulkPaymentCollSVRef.isHidden = false
        
        resetUploadView()
        previousOrderAPI()
    }
    
    func previousOrderAPI() {
        
        viewModel = RegistrationViewControllerViewModel()
        
        let merchantNumber = AppConstants.merchantNumber.map { String($0) }
        
        let param : [String : Any] = [
            "type" : "mid",
            "cif" : AppConstants.UserData.companyCIF,
            "merchantNum" : merchantNumber,
            "deviceId": AppConstants.UserData.deviceID
        ]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)

        self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.fileUploadHistory)
        bindFileUploadHistoryAPI()
    }
    
    func bindFileUploadHistoryAPI(){
        
        self.viewModel?.alertMessage.bind({ [weak self] in
            MBProgressHUD.hide(for: self!.view, animated: true)
            self?.showAlertDismissOnly(message: $0)
        })
        
        
        self.viewModel?.response.bind({ [weak self] in
            
            if let response = $0 {
                
                MBProgressHUD.hide(for: self!.view, animated: true)
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
                        
                        MBProgressHUD.showAdded(to: self!.view, animated: true)

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
                                    self?.historyData = objectModel
                                }
                                print("MYDATA:- \(userStatus.allKeys)")
                                
                                DispatchQueue.main.async {
                                    if let count = self?.historyData.dataList?.count {
                                        
                                        self?.bulkPreviousOrderTvHeightRef.constant = CGFloat(Float(count * 72))
                                        //This code will run in the main thread:
                                        var frame = self?.bulkPreviousOrderTvRef.frame
                                        frame?.size.height = self?.bulkPreviousOrderTvRef.contentSize.height ?? 0.0
                                        self?.bulkPreviousOrderTvRef.frame = frame ?? .zero
                                    }
                                    self?.bulkPreviousOrderTvRef.reloadData()
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
    
    @IBAction func pickNumberFromContacts(_ sender: UIButton){
        onClickPickContact()
    }
    
    @IBAction func initiatePaymentBtnTap(_ sneder: UIButton){
        
        if !(emailIdTfRef.text?.isEmpty ?? true) && isValidEmail(emailIdTfRef.text ?? "") == false {
            
            self.showAlertWith(message: AlertMessage(title: "Tijarati Pay".localiz(), body: "Invalid Email ID".localiz()))
            return
        }
        
        if !validate(value: phoneNoTfRef.text ?? "") {
            print("false")
            self.showAlertWith(message: AlertMessage(title: "Tijarati Pay".localiz(), body: "Invalid Phone Number".localiz()))
            return
        }
        
        let vc = ConfirmPaymentViewController.instantiate(cif: AppConstants.UserData.companyCIF,
                                                          ezpayOutletNumber: AppConstants.ezpayOutletNumber,
                                                          emailID: emailIdTfRef.text ?? "",
                                                          amt: kdTfRef.text ?? "",
                                                          mobileNo: phoneNoTfRef.text ?? "",
                                                          descriptions: descriptionTfRef.text ?? "",
                                                          deviceId: AppConstants.UserData.deviceID,
                                                          name: nameTfRef.text ?? "",
                                                          language: initiatePaymentLang)
//        self.show(vc, sender: self)
        vc.modalPresentationStyle = .overCurrentContext
        self.showDetailViewController(vc, sender: self)
//        self.navigationController?.present(vc, animated: true, completion: nil)
        
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        if showBulkPayment{
                return halfSizeBulkPaymentFileUploadSuccessPresentation(presentedViewController: presented, presenting: presentingViewController)

        }
        return halfSizeInitiatePaymentPresentation(presentedViewController: presented, presenting: presentingViewController)
    }

    
    @IBAction func backBtnTap(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- BULK PREVIOUS ORDER TABLEVIEW METHODS
extension InitiatePaymentViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count = historyData.dataList?.count{
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BulkPreviousOrderTVC
        cell.selectionStyle = .none
        
        let data = self.historyData.dataList?[indexPath.row]
        
        cell.fileNameLblRef.text = data?.fileName ?? ""
        
        // cell.fileDate_Contacts_SizeLblRef.text = "\(data?.uploadedTime ?? "00:00") | No. of Contacts: \(data?.noOfContacts ?? "0") | \(data?.fileSize ?? "0 kb")"
        
        //2021-08-05 10:54:16.0
        
        let dateStr = (data?.date ?? "") + " " + (data?.time ?? "")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: dateStr)
        
        let str = "No. of Contacts".localiz()
        
        if date == Date() {
            dateFormatter.dateFormat = "HH:mm"
            
            cell.fileDate_Contacts_SizeLblRef.text = "today at".localiz() + " \(dateFormatter.string(from: date ?? Date())) | \(str): \(data?.noOfContacts ?? "0") | \(data?.fileSize ?? "0")"
        } else {
            dateFormatter.dateFormat = date?.dateFormatWithSuffix()
            print(dateFormatter.string(from: date ?? Date()))
            
            cell.fileDate_Contacts_SizeLblRef.text = "\(dateFormatter.string(from: date ?? Date())) | \(str): \(data?.noOfContacts ?? "0") | \(data?.fileSize ?? "0")"
        }
        
        return cell
    }
}

extension Date {

    func dateFormatWithSuffix() -> String {
        return "dd'\(self.daySuffix())' MMM yyyy"
    }

    func daySuffix() -> String {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components(.day, from: self)
        let dayOfMonth = components.day
        switch dayOfMonth {
        case 1, 21, 31:
            return "st"
        case 2, 22:
            return "nd"
        case 3, 23:
            return "rd"
        default:
            return "th"
        }
    }
}

//MARK:- VALIDATION
extension InitiatePaymentViewController{
    func isValidMobileNo(_ phoneNumber: String) -> Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{7,10}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        let result = phoneTest.evaluate(with: phoneNumber)
        if result == true{
            checkBtnRef.setImage(UIImage(named: "Icon checked"), for: .normal)
        }else{
            checkBtnRef.setImage(UIImage(named: ""), for: .normal)
        }
        return result

    }
    
    // MARK:- Mobile Number Validation [starting with 7,8,9]
    func validate(value: String) -> Bool {
        let PHONE_REGEX = "^(?!(\\d)\\1{9})[5,6,9]\\d{7}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

//MARK:- PICK CONTACTS
extension InitiatePaymentViewController: CNContactPickerDelegate{
    func onClickPickContact(){

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

        // user name
        //let userName:String = contact.givenName

        // user phone number
        let userPhoneNumbers:[CNLabeledValue<CNPhoneNumber>] = contact.phoneNumbers
        let firstPhoneNumber:CNPhoneNumber = userPhoneNumbers[0].value


        // user phone number string
        let primaryPhoneNumberStr:String = firstPhoneNumber.stringValue

        print(primaryPhoneNumberStr)
        self.phoneNoTfRef.text = primaryPhoneNumberStr
        checkValidation()
    }


    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {

    }
}

//MARK:- API CALL
extension InitiatePaymentViewController{
    //    func downloadTemplateApi(){
    //        hud.label.text = "Loading"
    //        hud.show(animated: true)
    //        //var header = [String: String]()
    //        var Parameter = [String: Any]()
    //
    //        let headers : HTTPHeaders = [
    //            // "Authorization": "Bearer \(token)",
    //            "Content-Type" : "application/json"
    //        ]
    //
    //        Parameter = ["cif" : AppConstants.UserData.cif,
    //                     "deviceId" : AppConstants.UserData.deviceID
    //        ]
    //       // self.viewModel?.serviceRequest(param: Parameter, apiName: "https://mwextpp.burgan.com:9067/TijaratiPay/v1/bulkpayment/template" as! EndPointType)
    //
    //        print(Parameter)
    //        print("https://mwextpp.burgan.com:9067/TijaratiPay/v1/bulkpayment/template")
    //        Alamofire.request(URL(string: "https://mwextpp.burgan.com:9067/TijaratiPay/v1/bulkpayment/template")!, method:.post, parameters: Parameter, encoding: JSONEncoding.default, headers:headers).responseJSON { (response) in
    //            switch response.result {
    //            case .success(_):
    //                guard response.data != nil else {return}
    //                do {
    //                    print(response.result)
    ////                    let resultResponse = response.value as! NSDictionary
    ////                    let responseAllkeys = resultResponse.allKeys as! [String]
    ////                    guard let status = resultResponse.value(forKey: "status") else {return}
    //
    //
    //                }
    //
    //
    //                break
    //            case .failure(let error):
    //
    //                print("error:- \(error.localizedDescription)")
    //                break
    //            }
    //            DispatchQueue.main.async {
    //                self.hud.hide(animated: true)
    //            }
    //        }
    //
    //    }
    
    func decodeResult<T: Decodable>(model: T.Type, result: NSDictionary) -> (model: T?, error: Error?) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
            let modelObject = try JSONDecoder().decode(model.self, from: jsonData)
            return (modelObject, nil)
        } catch let error {
            return (nil, error)
        }
    }
    
    func downloadTemplateApi(){
        
        self.viewModel?.alertMessage.bind({ [weak self] in
            MBProgressHUD.hide(for: self!.view, animated: true)
            self?.showAlertDismissOnly(message: $0)
        })
        
        
        self.viewModel?.response.bind({ [weak self] in
            
            if let response = $0 {
                
                MBProgressHUD.hide(for: self!.view, animated: true)
                if   let userStatus = DataDecryption().decryption(jsonModel: PayloadRes(iv: response.iv, payload: response.payload))
                {
                    let status : String = userStatus.value(forKey: "message") as? String ?? ""
                    if status == "" {
                        
                        let param : [String : Any] = ["cif" : AppConstants.UserData.companyCIF,
                                                      "deviceId" : AppConstants.UserData.deviceID
                        ]
                        MBProgressHUD.showAdded(to: self!.view, animated: true)
                        self!.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.bulkPaymentTemplate)
                        self!.downloadTemplateApi()
                        
                    } else {
                        
                        let message : String = userStatus.value(forKey: "message") as! String
                        let status : String = userStatus.value(forKey: "message") as! String
                        if status == "Data Available"{
                            let errorCode : String = userStatus.value(forKey: "errorCode") as! String
                            if errorCode == "L128"{
                                print("Message:-\(message)")
                                let object = self!.decodeResult(model: BulkTemplateDownloadApi.self, result: userStatus)
                                
                                print("MYDATA:- \(userStatus.allKeys)")
                                
                                guard let base64String = object.model?.Base64 else {return}
                                print("Base64String:- \(base64String)")
                                
                                self?.downloadTemplate(data: "\(base64String)", reportName: "bulkTemplate\(Date().timeIntervalSince1970)")
                                
                            }
                            
                        }else{
                            self!.showAlertWith(message: AlertMessage(title: "Payments".localiz(), body: message.localiz()))
                        }
                    }
                    
                }
                
            }else{
                self!.showAlertWith(message: AlertMessage(title: "Tijarati".localiz(), body: "Sorry, Failed to load data.".localiz()))
            }
            
        })
        
    }
    
    func downloadTemplate(data : String,reportName : String){
        do {
            
            let reportdata = Data(base64Encoded: data, options: .ignoreUnknownCharacters)
            var documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let filePath = "\(documentsPath)/" + reportName + ".xlsx"
            try  reportdata!.write(to: URL(fileURLWithPath: filePath))
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentsDirectory = paths[0]
            print(documentsDirectory)
            documentsPath = documentsDirectory
            
            let url = URL(fileURLWithPath: filePath)
            
            let shareItems:Array = [url]
            let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems , applicationActivities: nil)
            
            self.present(activityViewController, animated: true, completion: nil)
            
            activityViewController.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
                if completed {
                    do{
                        try FileManager.default.removeItem(at: url)
                    }catch{
                        print(error)
                    }
                }
            }
            
            
        }catch{
            print(error)
        }
    }
    

    
    func uploadBlukPaymentFileApi(Base64: String, FileName: String){
        
        self.viewModel?.alertMessage.bind({ [weak self] in
            MBProgressHUD.hide(for: self!.view, animated: true)
            self?.showAlertDismissOnly(message: $0)
        })
        
        
        self.viewModel?.response.bind({ [weak self] in
            
            if let response = $0 {
                
                MBProgressHUD.hide(for: self!.view, animated: true)
                if   let userStatus = DataDecryption().decryption(jsonModel: PayloadRes(iv: response.iv, payload: response.payload))
                {
                    let status : String = userStatus.value(forKey: "status") as? String ?? ""
                    if status == "" {
                        
                        let param : [String : Any] = ["type":"mid",
                                                      "cif" : AppConstants.UserData.companyCIF,
                                                      "eZPayOutletNumber" : AppConstants.ezpayOutletNumber,
                                                      "deviceId": AppConstants.UserData.deviceID,
                                                      "File": Base64,
                                                      "fileName": FileName
                        ]
                        MBProgressHUD.showAdded(to: self!.view, animated: true)
                        self!.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.bulkPaymentUpload)
                        self!.uploadBlukPaymentFileApi(Base64: Base64, FileName: FileName)
                        
                    } else {
                        
                        let message : String = userStatus.value(forKey: "message") as! String
                        let status : String = userStatus.value(forKey: "status") as! String
                        if status == "Success"{
                            let errorCode : String = userStatus.value(forKey: "errorCode") as! String
                            if errorCode == "L128"{
                                print("Message:-\(message)")
                                let object = self!.decodeResult(model: BulkPaymentUploadFileApi.self, result: userStatus)
                                
                                print("MYDATA:- \(userStatus.allKeys)")
                               // UIView.animate(withDuration: 3, animations: { () -> Void in
                                    self!.uploadProgressBarRef.setProgress(1.0, animated: true)
                                //})
//                                guard let txnid = object.model?.txnid else {return}
//                                print("Message:- \(txnid)")
                                if let bulkSmsRefId = object.model?.BulkSmsRefId{
                                let param : [String : Any] = [
                                                              "cif" : AppConstants.UserData.companyCIF,
                                    "eZPayOutletNumber" : AppConstants.ezpayOutletNumber,
                                                              "deviceId": AppConstants.UserData.deviceID,
                                    "BulkSmsRefId": bulkSmsRefId,
                                ]
                                self?.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.bulkPaymentInitiate)
                                self?.initiateBlukPaymentApi(BulkSmsRefId: bulkSmsRefId)
                                }
                            }
                            
                        }else{
                            self!.resetUploadView()
                            self!.showAlertWith(message: AlertMessage(title: "Payments".localiz(), body: message.localiz()))
                        }
                    }
                    
                }
                
            }else{
                self!.resetUploadView()
                self!.showAlertWith(message: AlertMessage(title: "Tijarati".localiz(), body: "Sorry, Failed to load data.".localiz()))
            }
            
        })
        
    }

    func initiateBlukPaymentApi(BulkSmsRefId: String){
        
        self.viewModel?.alertMessage.bind({ [weak self] in
            MBProgressHUD.hide(for: self!.view, animated: true)
            self?.showAlertDismissOnly(message: $0)
        })
        
        
        self.viewModel?.response.bind({ [weak self] in
            
            if let response = $0 {
                
                MBProgressHUD.hide(for: self!.view, animated: true)
                if   let userStatus = DataDecryption().decryption(jsonModel: PayloadRes(iv: response.iv, payload: response.payload))
                {
                    let status : String = userStatus.value(forKey: "status") as? String ?? ""
                    if status == "" {
                        
                        let param : [String : Any] = [
                                                      "cif" : AppConstants.UserData.companyCIF,
                                                      "eZPayOutletNumber" : AppConstants.ezpayOutletNumber,
                                                      "deviceId": AppConstants.UserData.deviceID,
                                                      "BulkSmsRefId": BulkSmsRefId,
                        ]
                        MBProgressHUD.showAdded(to: self!.view, animated: true)
                        self!.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.bulkPaymentInitiate)
                        self!.initiateBlukPaymentApi(BulkSmsRefId: BulkSmsRefId)
                        
                    } else {
                        
                        let message : String = userStatus.value(forKey: "message") as! String
                        let status : String = userStatus.value(forKey: "status") as! String
                        if status == "Success"{
                            let errorCode : String = userStatus.value(forKey: "errorCode") as! String
                            if errorCode == "L128"{
                                print("Message:-\(message)")
                                let object = self!.decodeResult(model: BulkPaymentInitiateApi.self, result: userStatus)
                                print(object)
                                print("MYDATA:- \(userStatus.allKeys)")
                                
                                guard let noOfCustomers = object.model?.NoOfContacts else {return}
                                let vc = BulkPaymentFileConfirmAndSendViewController(nibName: "BulkPaymentFileConfirmAndSendViewController", bundle: nil)
                                vc.modalPresentationStyle = .overCurrentContext
                                vc.transitioningDelegate = self
                                vc.emailSentToText = noOfCustomers
                                self!.present(vc, animated: true, completion: nil)
//                                let vc = BulkPaymentFileUploadSuccessViewController(nibName: "BulkPaymentFileUploadSuccessViewController", bundle: nil)
//                                        vc.modalPresentationStyle = .custom
//                                        vc.transitioningDelegate = self
//                                vc.noOfCustomerText = noOfCustomers
//                                        self!.present(vc, animated: true, completion: nil)
                                
                            }
                            
                        }else{
                            self!.showAlertWith(message: AlertMessage(title: "Payments".localiz(), body: message.localiz()))
                        }
                    }
                    
                }
                
            }else{
                self!.showAlertWith(message: AlertMessage(title: "Tijarati".localiz(), body: "Sorry, Failed to load data.".localiz()))
            }
            
        })
        
    }
    
}

extension InitiatePaymentViewController:BulkPaymentFileConfirmAndSendVCDelegate{
    func didiVCDismiss() {
        self.resetUploadView()
        previousOrderAPI()
        arabicSetup()
    }
}

extension InitiatePaymentViewController: UIDocumentInteractionControllerDelegate {

    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }

}

extension InitiatePaymentViewController{
    
    func downloadTheFormatLblFunc(){
        downloadFormatLblRef.text = downloadFormatLblRef.text
        self.downloadFormatLblRef.textColor =  UIColor.init(hexString: "7F9DB8")
        let underlineAttriString = NSMutableAttributedString(string: text)
        let range1 = (text as NSString).range(of: "Download the format".localiz())
                underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
        underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont.init(name: "HelveticaNeue", size: 15) as Any, range: range1)
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(hexString: "0065A6") , range: range1) // #colorLiteral(red: 0.9450980392, green: 0.5568627451, blue: 0, alpha: 1)
        
        downloadFormatLblRef.attributedText = underlineAttriString
        downloadFormatLblRef.isUserInteractionEnabled = true
        downloadFormatLblRef.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
    }
    
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        let termsRange = (text as NSString).range(of: "Download the format".localiz())
       if gesture.didTapAttributedTextInLabel(label: downloadFormatLblRef, inRange: termsRange) {
           print("Tapped Download the Format")
            //downloadTemplateApi()
        
        //
        viewModel = RegistrationViewControllerViewModel()

        let param : [String : Any] = ["cif" : AppConstants.UserData.companyCIF,
                                      "deviceId" : AppConstants.UserData.deviceID]
        
        print("Bulk Payment Template Api:- \(RequestItemsType.bulkPaymentTemplate.url)")
        self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.bulkPaymentTemplate)//"https://mwextpp.burgan.com:9067/TijaratiPay/v1/bulkpayment/template" as! EndPointType)
        downloadTemplateApi()


        //uploadDocApi()

       } else {
           print("Tapped none")
       }
    }

}

class HalfSizePresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let bounds = containerView?.bounds else { return .zero }
        return CGRect(x: 0, y: bounds.height / 2, width: bounds.width, height: bounds.height / 2)
    }
}

class halfSizeInitiatePaymentPresentation: UIPresentationController{
    let blurEffectView: UIVisualEffectView!
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    @objc func dismiss(){
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismiss))
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurEffectView.isUserInteractionEnabled = true
        self.blurEffectView.addGestureRecognizer(tapGestureRecognizer)
    }
    override var frameOfPresentedViewInContainerView: CGRect{
        let theHeight = self.containerView!.frame.height

        return CGRect(origin: CGPoint(x: 0, y: theHeight - 370), size: CGSize(width: self.containerView!.frame.width, height: 370))
    }
    override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.alpha = 0
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.removeFromSuperview()
        })
    }
    override func presentationTransitionWillBegin() {
        self.blurEffectView.alpha = 0
        self.containerView?.addSubview(blurEffectView)
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.alpha = 1
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in

        })
    }
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView!.layer.masksToBounds = true
        presentedView!.layer.cornerRadius = 10
    }
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        self.presentedView?.frame = frameOfPresentedViewInContainerView
        blurEffectView.frame = containerView!.bounds
    }
}

class halfSizeBulkPaymentFileUploadSuccessPresentation: UIPresentationController{
    let blurEffectView: UIVisualEffectView!
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    @objc func dismiss(){
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismiss))
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurEffectView.isUserInteractionEnabled = true
        self.blurEffectView.addGestureRecognizer(tapGestureRecognizer)
    }
    override var frameOfPresentedViewInContainerView: CGRect{
        let theHeight = self.containerView!.frame.height

        return CGRect(origin: CGPoint(x: 0, y: theHeight - 250), size: CGSize(width: self.containerView!.frame.width, height: 250))
    }
    override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.alpha = 0
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.removeFromSuperview()
        })
    }
    override func presentationTransitionWillBegin() {
        self.blurEffectView.alpha = 0
        self.containerView?.addSubview(blurEffectView)
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.alpha = 1
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in

        })
    }
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView!.layer.masksToBounds = true
        presentedView!.layer.cornerRadius = 10
    }
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        self.presentedView?.frame = frameOfPresentedViewInContainerView
        blurEffectView.frame = containerView!.bounds
    }
}





// MARK: - FileUploadHistoryResponse
struct FileUploadHistoryResponse: Codable {
    var status, message, errorCode: String?
    var transaction, dataList: [DataList]?

    enum CodingKeys: String, CodingKey {
        case status, message, errorCode, transaction
        case dataList = "DataList"
    }
}

// MARK: - DataList
struct DataList: Codable {
    let fileName: String?
    let time, date, noOfContacts, fileSize: String?
    let bulkSMSRefID: String?

    enum CodingKeys: String, CodingKey {
        case fileName, time, date
        case noOfContacts = "NoOfContacts"
        case fileSize = "FileSize"
        case bulkSMSRefID = "BulkSmsRefId"
    }
}


extension UIButton {
    //MARK:- Animate check mark
    func checkboxAnimation(closure: @escaping () -> Void){
        guard let image = self.imageView else {return}
        self.adjustsImageWhenHighlighted = false
        self.isHighlighted = false
        
        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
            image.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            
        }) { (success) in
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
                self.isSelected = !self.isSelected
                //to-do
                closure()
                image.transform = .identity
            }, completion: nil)
        }
        
    }
}
