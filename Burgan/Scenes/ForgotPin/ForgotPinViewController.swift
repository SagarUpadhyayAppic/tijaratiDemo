//
//  ForgotPinViewController.swift
//  Burgan
//
//  Created by Malti Maurya on 07/05/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit
import LanguageManager_iOS

class ForgotPinViewController : UIViewController, UITextFieldDelegate, selectProviderDelegate
{
    
    @IBOutlet weak var curvedView: UIScrollView!
    
    @IBOutlet var ivLogo: UIImageView!

    @IBOutlet weak var lblEnterOTP: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblverifyOTP: UILabel!
    @IBOutlet weak var lblCreateNewPin: UILabel!
    @IBOutlet weak var lblConfirmNewPin: UILabel!
    @IBOutlet weak var lblTitleCreateNewPin: UILabel!
    @IBOutlet weak var lblcongrats: UILabel!
    @IBOutlet weak var lblLoginNow: UILabel!
    
    @IBOutlet weak var congratulationStackView: UIStackView!
    @IBOutlet weak var btnFionishArrowImg: UIImageView!
    @IBOutlet weak var btnFinish: GradientLayer!
    @IBOutlet weak var btnEye: UIButton!
    @IBOutlet weak var confirmPinView: OTPInputView!
    @IBOutlet weak var newPinView: OTPInputView!
    @IBOutlet weak var setPinStackView: UIStackView!
    @IBOutlet weak var forgotPInImage: UIImageView!
    @IBOutlet weak var registerStackView: UIStackView!
    @IBOutlet weak var btnNextArrowImg: UIImageView!
    
    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var OTPView: OTPInputView!
    @IBOutlet weak var btnNext: GradientLayer!
    
    @IBOutlet weak var btnLanguage: UIButton!
    
    @IBOutlet weak var congratsBack_Btn: UIButton!
    @IBOutlet weak var setPinBack_Btn: UIButton!
    @IBOutlet weak var registerBack_Btn: UIButton!
    
    var selectedProvider : serviceProviderList?
    var serviceProviderArray = [serviceProviderList]()
    var role : String = ""
    @IBOutlet weak var btnChangeNetworkProvider: UIButton!
    @IBOutlet weak var lblSelectedNetworkProviderName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.networkStatusChanged(_:)), name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
         definesPresentationContext = true
        
        
        self.loopThroughSubViewAndMirrorImage(subviews: self.view.subviews)
        
        self.navigationController?.isNavigationBarHidden = true
        curvedView.layer.cornerRadius = CGFloat.CornerRadius.popup.radius
        tfMobileNo.delegate = self
        btnNext.layer.cornerRadius = CGFloat.CornerRadius.button.radius
        btnFinish.layer.cornerRadius = CGFloat.CornerRadius.button.radius
        btnLogin.layer.cornerRadius = CGFloat.CornerRadius.button.radius
        buttonShadow(btn: btnFinish, shadowOpacity: 1.0)
        buttonShadow(btn: btnLogin, shadowOpacity: 1.0)
        buttonShadow(btn: btnNext, shadowOpacity: 1.0)
        codeView(codeView: OTPView, digits: 6)
        codeView(codeView: confirmPinView, digits: 6)
        codeView(codeView: newPinView, digits: 6)
        tfMobileNo.addTarget(self, action: #selector(textFieldsIsNotEmpty),
        for: .editingChanged)
        showRegisterScreen(showOTP: false)
        disabledButton(btn: btnNext, imgArrow: btnNextArrowImg)
        self.viewModel =  ForgotPinViewControllerViewModel()
        
        if AppConstants.language == .en {
            btnLanguage.setTitle("عربى", for: .normal)
            ivLogo.image = UIImage(named: "tijarati_En")
            
        } else {
            btnLanguage.setTitle("English", for: .normal)
            ivLogo.image = UIImage(named: "tijarati_Ar")
        }
        
        if AppConstants.language == .ar
        {
            OTPView.transform = CGAffineTransform(scaleX: -1, y: 1)
            newPinView.transform = CGAffineTransform(scaleX: -1, y: 1)
            confirmPinView.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
                
        arabicSetup()
        
        self.enabledButton(btn: self.btnNext, imgArrow: self.btnNextArrowImg)
        self.btnType = 1
        self.showRegisterScreen(showOTP: true)
        
        //disabledButton(btn: btnNext, imgArrow: btnNextArrowImg)
        forgotPin()
    }
    
    func arabicSetup()
    {
        btnLanguage.setTitle(btnLanguage.title(for: .normal)!.localiz(), for: .normal)
        lbldescription.text = lbldescription.text!.localiz()
        lblTitle.text = lblTitle.text!.localiz()
        lblCreateNewPin.text = lblCreateNewPin.text?.localiz()
        lblConfirmNewPin.text = lblConfirmNewPin.text?.localiz()
        lblTitleCreateNewPin.text = lblTitleCreateNewPin.text?.localiz()
        lblcongrats.text = lblcongrats.text?.localiz()
        lblLoginNow.text = lblLoginNow.text?.localiz()
        btnLogin.setTitle("LOGIN".localiz(), for: .normal)
        btnNext.setTitle("NEXT".localiz(), for: .normal)
        btnResend.setTitle("Resend OTP ?".localiz(), for: .normal)
        btnFinish.setTitle("Finish".localiz(), for: .normal)
        btnChangeNetworkProvider.setTitle("Change Network Provider ?".localiz(), for: .normal)

        
        if AppConstants.language == .en {
            lblCreateNewPin.textAlignment = .left
        }else{
            lblCreateNewPin.textAlignment = .right
        }
    }
    
    var showLoginPin = false

    @IBAction func showPassword(_ sender: Any) {
        
        if showLoginPin {
            confirmPinView.isSecureEntry = true
            showLoginPin = false
            btnEye.setImage(UIImage(named: "ic_eye"), for: .normal)
        } else {
            confirmPinView.isSecureEntry = false
            showLoginPin = true
            btnEye.setImage(UIImage(named: "ic_show_pswd"), for: .normal)
        }
    }
    
    @available(iOS 13.0, *)
    @IBAction func changeLanguage(_ sender: UIButton) {
        var selectedLanguage: Languages = .en
        if AppConstants.language == .en {
            btnLanguage.setTitle("English", for: .normal)
            AppConstants.language = .ar
            selectedLanguage = .ar
        }else{
            btnLanguage.setTitle("عربى", for: .normal)
            AppConstants.language = .en
            selectedLanguage = .en
        }
        // change the language
        LanguageManager.shared.setLanguage(language: selectedLanguage, viewControllerFactory: { title -> UIViewController in let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                            
            return storyboard.instantiateViewController(identifier: "nav")
        }) { view in
            // do custom animation
            view.transform = CGAffineTransform(scaleX: 2, y: 2)
            view.alpha = 0
        }
    }
    
    
    func codeView(codeView:OTPInputView,digits:Int) {
        codeView.numberOfDigits = digits
        
          codeView.bottomBorderColor = UIColor.BurganColor.brandGray.lgiht
          codeView.textColor = UIColor.BurganColor.brandGray.black
          codeView.acceptableCharacters = "0123456789"
          codeView.keyboardType = .numberPad
          codeView.animationType = .none
        
        codeView.font = UIFont.init(name:"Monsterrat-Medium", size: 15)
        
        
    }
    @IBOutlet weak var btnLogin: GradientLayer!
    @IBAction func goToOTPScreen(_ sender: Any) {
        for _ in 0..<self.OTPView.text.count {
            self.OTPView.clearText()
        }
        showRegisterScreen(showOTP: true)
    }
    var apiRequestType = ""
    var OTP_VERIFY = "verifyOtp"
    var RESEND_OTP = "resendOTP"
    var SET_PIN = "setPin"
    var FORGOT_PIN = "forgetPIN"
    var SERVICE_PROVIDER = "servicePrvdr"
    var viewModel: ForgotPinViewControllerViewModelProtocol?
    var btnType = 0
    var deviceID : String?
    
    @IBAction func login(_ sender: Any) {
        let controller = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RegistrationViewController") as? RegistrationViewController)!
        controller.showLoginScreen = true
        self.navigationController?.pushViewController(controller, animated: true)
                                         
    }
    @IBAction func finish(_ sender: Any) {
        if newPinView.text == "" || newPinView.text.isEmpty
        {
            showAlertWith(message: AlertMessage(title: "Set PIN".localiz(), body: "Please enter new PIN.".localiz()))
        }else if confirmPinView.text == "" || confirmPinView.text.isEmpty{
            showAlertWith(message: AlertMessage(title: "Set PIN".localiz(), body: "Please enter confirmation PIN.".localiz()))

        }
        else if newPinView.text.count != 6 {
            
            showAlertWith(message: AlertMessage(title: "Set PIN".localiz(), body: "Enter valid new PIN".localiz()))
            
        }
        else if confirmPinView.text.count != 6 {
            showAlertWith(message: AlertMessage(title: "Set PIN".localiz(), body: "Enter valid confirm PIN".localiz()))
               
        }
        else if newPinView.text != confirmPinView.text
        {
            showAlertWith(message: AlertMessage(title: "Set PIN".localiz(), body: "Confirmation PIN and new PIN should be same".localiz()))

            
        }else{
            disabledButton(btn: btnFinish, imgArrow: btnFionishArrowImg)
            setPIN()
        }
        
    }
    @IBOutlet weak var phoneNoView: UIView!
    @IBAction func next(_ sender: Any) {
        if btnType == 0{

            if !tfMobileNo.text!.isEmpty || tfMobileNo.text! != ""
            {
                disabledButton(btn: btnNext, imgArrow: btnNextArrowImg)
                forgotPin()
                
            }else{
                showAlertWith(message: AlertMessage(title: "Forgot Password".localiz(), body: "Please enter mobile number to continue.".localiz()))
            }
        }else{
            if OTPView.text != "" || !OTPView.text.isEmpty{
                disabledButton(btn: btnNext, imgArrow: btnNextArrowImg)
                setOTP()
            }else{
                showAlertWith(message: AlertMessage(title: "Forgot Password".localiz(), body: "Please enter OTP to continue.".localiz()))
            }
           
            
        }
    }
    @objc func textFieldsIsNotEmpty(sender: UITextField) {

    sender.text = sender.text?.trimmingCharacters(in: .whitespaces)
    if(tfMobileNo.text?.count == 8){
        self.enabledButton(btn: btnNext, imgArrow: btnNextArrowImg)
     

    }else{
        self.disabledButton(btn: btnNext, imgArrow: btnNextArrowImg)

    }

    }
    
    @IBAction func gotoSetPin(_ sender: Any) {
        showSetPINScreen()
    }
    func forgotPin()
    {
        deviceID  = UIDevice.current.identifierForVendor!.uuidString
        
        //let param : [String : Any] = ["cif" : tfMobileNo.text!,"deviceId" : deviceID!]
        let param : [String : Any] = ["cif" : AppConstants.UserData.cif,"deviceId" : deviceID!]
         MBProgressHUD.showAdded(to: self.view, animated: true)
        self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.forgetPIN)
        apiRequestType = FORGOT_PIN
        self.bindUI()
        
    }
    @IBOutlet weak var lbldescription: UILabel!
    @IBAction func resendOTP(_ sender: Any) {
//        if OTPView.text != "" || !OTPView.text.isEmpty{
//            disabledButton(btn: btnNext, imgArrow: btnNextArrowImg)
//            resendOTP()
//         }else{
//            showAlertWith(message: AlertMessage(title: "Forgot Password".localiz(), body: "Please enter OTP sent to continue.".localiz()))
//         }
        
        disabledButton(btn: btnNext, imgArrow: btnNextArrowImg)
        resendOTP()
        
    }
    
    var timer: Timer?
    var totalTime = 30
        
    private func startOtpTimer() {
        self.totalTime = 30
        self.btnResend.isUserInteractionEnabled = false
//        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        var bgTask : UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
        bgTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            UIApplication.shared.endBackgroundTask(bgTask)
        })
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        RunLoop.current.add(self.timer!, forMode: .default)
    }
        
        @objc func updateTimer() {
                print(self.totalTime)
            let timeStr = self.timeFormatted(self.totalTime)
            
            self.btnResend.setTitle(timeStr, for: .normal)
    //            self.lblTimer.text = self.timeFormatted(self.totalTime) // will show timer
                if totalTime != 0 {
                    totalTime -= 1  // decrease counter timer
                } else {
                    if let timer = self.timer {
                        timer.invalidate()
                        self.timer = nil
                        self.btnResend.isUserInteractionEnabled = true
                        self.btnResend.setTitle("Resend OTP ?".localiz(), for: .normal)
                    }
                }
            }
    
   func timeFormatted(_ totalSeconds: Int) -> String {
       let seconds: Int = totalSeconds % 60
       let minutes: Int = (totalSeconds / 60) % 60
    return String(format: "Resend in ".localiz() + "%02d:%02d", minutes, seconds)
   }
    
    
    @IBOutlet weak var tfMobileNo: UITextField!
    func buttonShadow(btn:UIButton,shadowOpacity:CGFloat){
        btn.layer.shadowColor = UIColor.BurganColor.brandBlue.light.cgColor
        btn.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        btn.layer.shadowOpacity = Float(shadowOpacity)
        btn.layer.shadowRadius = 5.0
        btn.layer.masksToBounds = false
    }
    func setOTP(){
        let param : [String : Any] = ["cif" : AppConstants.UserData.cif,
                                      "deviceId" : deviceID!,
                                      "otp": OTPView.text] // "123456"
         MBProgressHUD.showAdded(to: self.view, animated: true)
        self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.verifyOTP)
        
        apiRequestType = OTP_VERIFY
        self.bindUI()
    }
    func resendOTP(){
//        let param : [String : Any] = ["cif" : tfMobileNo.text!,"deviceId" : deviceID!]
        let param : [String : Any] = ["cif" : AppConstants.UserData.cif,"deviceId" : deviceID!]
         MBProgressHUD.showAdded(to: self.view, animated: true)
        self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.resendOTP)
        apiRequestType = RESEND_OTP
        self.bindUI()
    }
    func setPIN(){
        let param : [String : Any] = ["cif" : AppConstants.UserData.cif,
                                      "mPIN" : newPinView.text,
                                      "isTouchIDEnabled":false,
                                      "isFaceIDEnabled":false,
                                      "touchID":"","faceID":"",
                                      "deviceId":deviceID!]
         MBProgressHUD.showAdded(to: self.view, animated: true)
        self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.setPIN)
        apiRequestType = SET_PIN
        self.bindUI()
    }
    
    func showRegisterScreen(showOTP : Bool){
        congratulationStackView.isHidden = true
        congratsBack_Btn.isHidden = true
        setPinStackView.isHidden = true
        setPinBack_Btn.isHidden = true
        registerStackView.isHidden = false
        registerBack_Btn.isHidden = false
        
        if showOTP{
            OTPView.isHidden = false
            //MAk
            let string = AppConstants.UserData.cif //tfMobileNo.text!
            let characters = Array(string)
            print(characters)
            var tempAry = [Character]()
            
            for i in 0..<characters.count {
                /*
                if characters.count - 1 == i {
                    // last position
                    tempAry.append(characters[i])
                } else if characters.count - 2 == i {
                    // secomd last position
                    tempAry.append(characters[i])
                } else {
                    tempAry.append("*")
                }
                */
                if i >= characters.count - 4 {
                    tempAry.append(characters[i])
                } else {
                    tempAry.append("X")
                }
            }
            let str = String(tempAry)
            //mak over
            
//            lbldescription.text = "OTP has been sent to " + tfMobileNo.text!
            lbldescription.text = ""
            lblverifyOTP.text = "Verify OTP that has been sent to your registered mobile number ".localiz() + str
            lblEnterOTP.text = "Enter OTP".localiz()
            btnResend.isHidden = false
            phoneNoView.isHidden = true
            forgotPInImage.isHidden = false
            lblTitle.text = "Forgot PIN ?".localiz()
            btnType = 1
            
    
        } else {
            btnType = 0
            forgotPInImage.isHidden = false
            lblTitle.text = "Forgot PIN ?".localiz()
            btnResend.isHidden = true
            phoneNoView.isHidden = false
            OTPView.isHidden = true
            lblEnterOTP.text = "Registered Mobile Number".localiz()
            lbldescription.text = "Don't worry ! Let's reset your password in 2 easy steps".localiz()
            lblverifyOTP.text = ""
            
        }
    }
    func showSetPINScreen(){
        
        // Below 2 for loop is to clear the text of PIN view
        
        for _ in 0..<self.confirmPinView.text.count {
            self.confirmPinView.clearText()
        }
        
        for _ in 0..<self.newPinView.text.count {
            self.newPinView.clearText()
        }
        
        congratulationStackView.isHidden = true
        congratsBack_Btn.isHidden = true
        setPinStackView.isHidden = false
        setPinBack_Btn.isHidden = false
        registerStackView.isHidden = true
        registerBack_Btn.isHidden = true

        let desiredOffset = CGPoint(x: 0, y: -self.curvedView.contentInset.top)
        self.curvedView.setContentOffset(desiredOffset, animated: true)
    }
    func showCongratulationScreen(){
        congratulationStackView.isHidden = false
        congratsBack_Btn.isHidden = false
        setPinStackView.isHidden = true
        setPinBack_Btn.isHidden = true
        registerStackView.isHidden = true
        registerBack_Btn.isHidden = true

       }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == tfMobileNo && textField.text != "" ){
            if(textField.text?.count == 8){
                enabledButton(btn: btnNext, imgArrow: btnNextArrowImg)
                
            }else{
                showAlertWith(message: AlertMessage(title: "Forgot PIN".localiz(), body: "Please enter valid phone number".localiz()))            }
            
        }
        
    }
    func disabledButton(btn:GradientLayer,imgArrow:UIImageView){
        btn.isUserInteractionEnabled = false
        buttonShadow(btn: btn, shadowOpacity: 0.0)
        imgArrow.image = UIImage(named: "ic_right_arrow")
        btn.setTitleColor(UIColor.BurganColor.brandWhite.white3, for: .normal)
        
        btn.color1 = UIColor.BurganColor.brandGray.lgiht
        btn.color2 = UIColor.BurganColor.brandGray.lgiht
        btn.color3 = UIColor.BurganColor.brandGray.lgiht
        
    }
    func enabledButton(btn:GradientLayer,imgArrow:UIImageView ){
        
        imgArrow.image = UIImage(named: "ic_white_right_arrow")
        buttonShadow(btn: btn, shadowOpacity: 1.0)
        btn.isUserInteractionEnabled = true
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.color1 = UIColor(displayP3Red: 0/255.0, green: 136/255.0, blue: 208/255.0, alpha: 1)
        btn.color2 = UIColor(displayP3Red: 0/255.0, green: 115/255.0, blue: 185/255.0, alpha: 1)
        btn.color3 = UIColor(displayP3Red: 0/255.0, green: 94/255.0, blue: 161/255.0, alpha: 1)
    }
    
    
    @IBOutlet weak var curvedViewHeight: NSLayoutConstraint!
    private func bindUI() {
        self.viewModel?.alertMessage.bind({ [weak self] in
            MBProgressHUD.hide(for: self!.view, animated: true)
            
            if self?.apiRequestType == self?.OTP_VERIFY {
                self?.enabledButton(btn: self!.btnNext, imgArrow: self!.btnNextArrowImg)
            } else if self?.apiRequestType == self?.RESEND_OTP {
                self?.enabledButton(btn: self!.btnNext, imgArrow: self!.btnNextArrowImg)
            }  else if self?.apiRequestType == self?.SERVICE_PROVIDER {
                self?.enabledButton(btn: self!.btnNext, imgArrow: self!.btnNextArrowImg)
            } else if self?.apiRequestType == self?.SET_PIN {
                self?.enabledButton(btn: self!.btnFinish, imgArrow: self!.btnFionishArrowImg)
            } else {
                self?.enabledButton(btn: self!.btnNext, imgArrow: self!.btnNextArrowImg)
            }
            
            self?.showAlertDismissOnly(message: $0)
        })
        
        
        
        self.viewModel?.response.bind({ [weak self] in
            
            if let response = $0 {
              if  let userStatus = DataDecryption().decryption(jsonModel: PayloadRes(iv: response.iv, payload: response.payload))
              {
                MBProgressHUD.hide(for: self!.view, animated: true)
                
                let status : String = userStatus.value(forKey: "status") as? String ?? ""
                
                if status == "" {
                    
                    if self?.apiRequestType == self?.OTP_VERIFY {
                        
                        self?.setOTP()
                        
                    } else if self?.apiRequestType == self?.RESEND_OTP {
                        self?.resendOTP()
                    } else if self?.apiRequestType == self?.SET_PIN {
                        self?.setPIN()
                    }  else if self?.apiRequestType == self?.SERVICE_PROVIDER {
                        self?.submitProvider(serviceprovider: self?.selectedProvider?.name ?? "")
                    } else {
                        self?.forgotPin()
                    }
                    
                } else {
                    
                                    let status : String = userStatus.value(forKey: "status") as! String
                                      let msg : String = userStatus.value(forKey: "message") as! String
                                    if(status == "Success")
                                    {
                                        
                                        
                                        if self?.apiRequestType == self?.OTP_VERIFY{
                                            self?.enabledButton(btn: self!.btnNext, imgArrow: self!.btnNextArrowImg)
                                            let errorCode : String = userStatus.value(forKey: "errorCode") as! String
                                            if errorCode == "S101"
                                            {
                                                self?.showSetPINScreen()
                                            }else{
                                                for _ in 0..<self!.OTPView.text.count {
                                                    
                                                    self!.OTPView.clearText()
                                                }
                                                self?.showAlertWith(message: AlertMessage(title: "Set PIN".localiz(), body: msg.localiz()))
                                            }
                                            
                                        }else if self?.apiRequestType == self?.RESEND_OTP{
                                            self?.enabledButton(btn: self!.btnNext, imgArrow: self!.btnNextArrowImg)
                                            
                                            let errorCode : String = userStatus.value(forKey: "errorCode") as! String
                                            if errorCode == "L120"
                                            {
                                                self?.showRegisterScreen(showOTP: true)
                                                            
                                                self?.lblverifyOTP.text = "Resend OTP that has been sent to your registered mobile number".localiz()
                                                
                                                //self?.codeView(codeView: self!.OTPView, digits: 6)
                                                //self?.OTPView.becomeFirstResponder()
                                                
                                                for _ in 0..<self!.OTPView.text.count {
                                                    
                                                    self!.OTPView.clearText()
                                                }
                                                
                                                //let _ = self?.OTPView.becomeFirstResponder()

                                                self?.startOtpTimer()
                                            }
                                            
                                        }else if self?.apiRequestType == self?.SET_PIN{
                                            self?.enabledButton(btn: self!.btnFinish, imgArrow: self!.btnFionishArrowImg)

                                            let errorCode : String = userStatus.value(forKey: "errorCode") as! String
                                            if errorCode == "S101"{
                                                 self?.showCongratulationScreen()
                                                
                                            }else{
                                                self?.showAlertWith(message: AlertMessage(title: "Set PIN".localiz(), body: msg.localiz()))
                                            }
                                        } else if self?.apiRequestType == self?.SERVICE_PROVIDER {
                                            
                                            self?.enabledButton(btn: self!.btnNext, imgArrow: self!.btnNextArrowImg)
                                            let errorCode : String = userStatus.value(forKey: "errorCode") as! String
                                            let msg : String = userStatus.value(forKey: "message") as! String
                                            
                                            if(errorCode == "S101") {
                                               print("Do Nothing...")
                                            } else {
                                                self?.showAlertWith(message: AlertMessage(title: "".localiz(), body: msg.localiz()))
                                            }
                                            
                                        } else
                                        {
                                            self?.enabledButton(btn: self!.btnNext, imgArrow: self!.btnNextArrowImg)
                                            let errorCode : String = userStatus.value(forKey: "errorCode") as! String
                                        
                                            self?.role = userStatus.value(forKey: "role") as! String
                                            
                                            let serviceProviderName = userStatus.value(forKey: "mobileOperator") as! String
                                            self?.lblSelectedNetworkProviderName.text = "Your selected network provider is".localiz() + " " + serviceProviderName
                                            
                                            let arrServiceProvider = userStatus.value(forKey: "serviceProvider") as! [String]
                                            if(arrServiceProvider.count > 0) {
                                                for i in 0..<arrServiceProvider.count {
                                                    let serviceProviderObj = arrServiceProvider[i]
                                                    var serviceProvider = serviceProviderList()
                                                    if(serviceProviderObj.contains("ooredoo")) {
                                                        serviceProvider.providerImg = "ic_ooredoo"
                                                    } else if(serviceProviderObj.contains("zain")) {
                                                        serviceProvider.providerImg = "ic_zain"
                                                    } else {
                                                        serviceProvider.providerImg = "ic_viva"
                                                    }
                                                    serviceProvider.name = serviceProviderObj
                                                    self?.serviceProviderArray.append(serviceProvider)
                                                }
                                            }
                                            
                                           if errorCode == "L120"{
                                                self?.btnType = 1
                                                self?.showRegisterScreen(showOTP: true)
                                            self?.startOtpTimer()
                                                
                                            }else {
                                            self?.showAlertWith(message: AlertMessage(title: "Forgot PIN".localiz(), body: msg.localiz()))
                                            }
                                            
                                            
                                        }
                                    }else
                                    {
                                        self?.showAlertWith(message: AlertMessage(title: "Forgot PIN".localiz(), body: msg.localiz()))
                                        print(msg)
                                    }
                }
                

                
            }
                }else{
                MBProgressHUD.hide(for: self!.view, animated: true)
                               self!.showAlertWith(message: AlertMessage(title: "Tijarati".localiz(), body: "Sorry, Failed to load data.".localiz()))
                                          }
        })
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        /*
        if btnType == 1 {
            showRegisterScreen(showOTP: false)
        } else {
            let controller = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RegistrationViewController") as? RegistrationViewController)!
            controller.showLoginScreen = true
            self.navigationController?.pushViewController(controller, animated: true)
        }
        */
        
        let controller = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RegistrationViewController") as? RegistrationViewController)!
        controller.showLoginScreen = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func changeNetworkProviderButtonTapped(_ sender: UIButton) {
        
        if role == "Admin" {
            showAlertWith(message: AlertMessage(title: "".localiz(), body: "Please contact with merchant services to update your network provider".localiz()))
        } else {
            let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ServiceProviderViewController") as? ServiceProviderViewController
            
            controller?.delegate = self
            controller?.serviceproviderArr = serviceProviderArray
            self.presentAsStork(controller!, height: 500.0, cornerRadius: CGFloat.CornerRadius.popup.radius, showIndicator: false, showCloseButton: false, complection: nil)
        }
    }
    
    func selectedProvider(service: serviceProviderList) {
        if(service.name != ""){
            selectedProvider = service
            submitProvider(serviceprovider: service.name!)
            lblSelectedNetworkProviderName.text = "Your selected network provider is".localiz() + " \(service.name!)"
        }
    }
    
    func submitProvider(serviceprovider : String){
        let param : [String : Any] = ["cif" :  AppConstants.UserData.cif,
                                      "deviceId" : deviceID!,
                                      "serviceProvider":serviceprovider]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.getServiceProvider)
        apiRequestType = SERVICE_PROVIDER
        self.bindUI()
    }
}
