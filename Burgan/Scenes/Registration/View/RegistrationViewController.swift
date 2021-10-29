//
//  RegistrationViewController.swift
//  Burgan
//
//  Created by 1st iMac on 12/03/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit
import MBProgressHUD
import SPStorkController
import IQKeyboardManagerSwift
import SVPinView
import LocalAuthentication
import LanguageManager_iOS


protocol selectProviderDelegate : class
{
    func selectedProvider(service:serviceProviderList)
}

class RegistrationViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource , UIPageViewControllerDelegate, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, selectProviderDelegate, URLSessionDelegate {
    @IBOutlet weak var lblLoginOptionTitle: UILabel!
    
    
    @IBOutlet weak var btnNextArrowImg: UIImageView!
    @IBOutlet var ivLogo: UIImageView!
    @IBOutlet var viewCurved: UIScrollView!
    @IBOutlet var facIDView: UIView!
    @IBOutlet var touchIDView: UIView!
    @IBOutlet var mPinView: UIView!
    @IBOutlet var errorDialog: UIView!
    @IBOutlet var errorLbl: UILabel!
    @IBOutlet var errorDialogOuterview: UIView!
    @IBOutlet var btnKnowMore: UIButton!
    @IBOutlet var closeErrorDialog: UIButton!
    @IBOutlet var errorDialogHeight: NSLayoutConstraint!
    @IBOutlet var errImgView: UIView!
    @IBOutlet var btnRegister: GradientLayer!
    @IBOutlet var touchToggle: UISwitch!
    @IBOutlet var confirmationCodeview: SVPinView!
    @IBOutlet weak var welcomeStackView: UIStackView!
    @IBOutlet weak var lblWelcomeUserName: UILabel!
    @IBOutlet weak var loginPinView: SVPinView!
    @IBOutlet var verificationCodeView: SVPinView!
    @IBOutlet weak var phoneNumberViewHeight: NSLayoutConstraint!
    @IBOutlet weak var svStep1: UIStackView!
    @IBOutlet weak var pinCodeView: SVPinView!
    @IBOutlet weak var pincodeViewHeight: NSLayoutConstraint!
    @IBOutlet var tfMobileNumber: UITextField!
    @IBOutlet weak var btnNext: GradientLayer!
    @IBOutlet weak var phoneNumberView: UIView!
    @IBOutlet var progressBar: UIView!
    @IBOutlet var bannerCollectionView: UICollectionView!
    @IBOutlet var viewScrollContent: UIView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet weak var lblTitleTextfield: UILabel!
    @IBOutlet weak var selectedProvideImg: UIImageView!
    @IBOutlet weak var selectedProviderImgWidth: NSLayoutConstraint!
    @IBOutlet weak var progressBarProviderViewWidth: NSLayoutConstraint!
    @IBOutlet weak var errImgHeight: NSLayoutConstraint!
    @IBOutlet weak var svStep4: UIStackView!
    @IBOutlet weak var svStep3: UIStackView!
    @IBOutlet weak var svStep2: UIStackView!
    @IBOutlet var faceToggle: UISwitch!
    @IBOutlet weak var btnLogin: GradientLayer!
    @IBOutlet weak var btnLanguage: UIButton!
    // SANKET
    @IBOutlet weak var mPinBackBtn: UIButton!
    // SANKET OVER
    
    var viewModel: RegistrationViewControllerViewModelProtocol?
    var AUTH_USER = "authUser"
    var SERVICE_PROVIDER = "servicePrvdr"
    var OTP_VERIFY = "verifyOtp"
    var RESEND_OTP = "resendOTP"
    var SET_PIN = "setPin"
    var VERIFY_PIN = "verifyPin"
    static var usercif = ""
    
    var apiRequestType = ""
    var showLoginScreen = false
    let context = LAContext()
    var error: NSError?
    
    @IBOutlet var loginWithDiffNo_Btn: UIButton!
    
    @IBAction func LoginWithDiffNo_Btn_Tapped(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Confirmation".localiz(), message: "Are you sure you want to login with different mobile number?".localiz(), preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel".localiz(), style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        let ok = UIAlertAction(title: "Ok".localiz(), style: .default) { (action) in
            
            // Clear all the data
            let restoreDeviceToken = UserDefaults.standard.value(forKey: "DeviceToken") as! String
            
            UserDefaults.standard.removeObject(forKey: "priorityOne")
            UserDefaults.standard.removeObject(forKey: "priorityTwo")
            UserDefaults.standard.removeObject(forKey: "priorityThree")
            UserDefaults.standard.removeObject(forKey: "priorityNo")
            
            //UserDefaults.standard.removeObject(forKey: "loginDetails")
            KeyChain.RemoveFromKeychain()
            
            UserDefaults.standard.removeObject(forKey: "AutoUpdateSwitch")
            UserDefaults.standard.removeObject(forKey: "NotificationSwitch")
            UserDefaults.standard.removeObject(forKey: "TouchIDSwitch")
            UserDefaults.standard.removeObject(forKey: "FaceIDSwitch")
            
            UserDefaults.standard.synchronize()
            
            UserDefaults.standard.setValue(restoreDeviceToken, forKey: "DeviceToken")
            
            UserDefaults.standard.synchronize()
            
            AppConstants.jsonStartDate = ""
            AppConstants.jsonEndDate = ""
            
            self.showLoginScreen = false
            
            self.tfMobileNumber.text = ""
            
            // 21/sep/2020
            self.phoneNumberView.isHidden = false
            self.btnType = 0
            self.registerNumberSetup()
            
            self.stackViewToggles(registerPage: false, enterPinPage: true, loginSelectOptionsPage: true, loginPage: true, welcomePage: true)
        }
        alertController.addAction(cancel)
        alertController.addAction(ok)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func login(_ sender: Any) {
        
        if  loginPinView.getPin() == "" {
            self.showAlertWith(message: AlertMessage(title: "LOGIN".localiz(), body: "Please enter mPIN to continue login.".localiz()))
        } else {
            
            loginUser()
            
            //remove once api works
            //            imgLock.image = UIImage(named: "ic_unlock")
            //
            //            let controller = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RootViewController") as? RootViewController)!
            //            self.navigationController?.pushViewController(controller, animated: true)
            //remove once api works
            
        }
    }
    
    
    var btnType = 0
    
    func stackViewToggles(registerPage : Bool, enterPinPage: Bool, loginSelectOptionsPage: Bool, loginPage: Bool, welcomePage : Bool)
    {
        svStep1.isHidden = registerPage
        viewScrollContent.isHidden = registerPage
        svStep2.isHidden = enterPinPage
        svStep4.isHidden = loginSelectOptionsPage
        svStep3.isHidden = loginPage
        welcomeStackView.isHidden = welcomePage
        // SANKET
        mPinBackBtn.isHidden = loginPage
        // SANKET OVER
        let topOffset = CGPoint(x: 0, y: 0)
        viewCurved.setContentOffset(topOffset, animated: false)
        viewCurved.isScrollEnabled = loginSelectOptionsPage ? true : false
        
        //        if !loginSelectOptionsPage {
        //            touchIDView.isHidden = false
        //            facIDView.isHidden = false
        //        }
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
        LanguageManager.shared.setLanguage(language: selectedLanguage,
                                           viewControllerFactory: { title -> UIViewController in
                                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                            
                                            return storyboard.instantiateViewController(identifier: "nav")
        }) { view in
            // do custom animation
            view.transform = CGAffineTransform(scaleX: 2, y: 2)
            view.alpha = 0
        }
    }
    
    
    func biometricAuthentication() {
        
        self.faceIDView.isHidden = true
        self.facIDView.isHidden = true
        
        self.touchIDCheckView.isHidden = true
        self.touchIDView.isHidden = true
        
        
        self.faceToggle.setOn(false, animated: false)
        self.touchToggle.setOn(false, animated: false)
        self.faceToggle.isUserInteractionEnabled = false
        self.touchToggle.isUserInteractionEnabled = false
        if context.canEvaluatePolicy(
            LAPolicy.deviceOwnerAuthenticationWithBiometrics,
            error: &error) {
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                switch context.biometryType {
                case .faceID:
                    self.faceToggle.setOn(true, animated: true)
                    self.isFaceIDEnabled = true
                    // 21/sep/2020
                    //UserDefaults.standard.setValue(true, forKey: "FaceIDSwitch")
                    self.faceToggle.isUserInteractionEnabled = true
                    self.faceIDView.isHidden = false
                    self.facIDView.isHidden = false
                    
                    break
                case .touchID:
                    self.touchToggle.setOn(true, animated: true)
                    self.isTouchIDEnabled = true
                    // 21/sep/2020
                    //UserDefaults.standard.setValue(true, forKey: "TouchIDSwitch")
                    self.touchToggle.isUserInteractionEnabled = true
                    self.touchIDCheckView.isHidden = false
                    self.touchIDView.isHidden = false
                    break
                case .none:
                    print("none")
                    
                    break
                }
            }else {
                
                // Device cannot use biometric authentication
                
                //                if let err = error {
                //                    let strMessage = self.errorMessage(errorCode: err._code)
                //                    self.showAlertWith(message: AlertMessage(title: "Authentication".localiz(), body: strMessage))
                //                }
            }
        }else{
            //            if let err = error {
            //                let strMessage = self.errorMessage(errorCode: err._code)
            //                self.showAlertWith(message: AlertMessage(title: "Authentication".localiz(), body: strMessage))
            //            }
        }
    }
    
    
    @IBAction func touchEnable(_ sender: Any) {
        if isTouchIDEnabled {
            isTouchIDEnabled = false
            // 21/sep/2020
            //UserDefaults.standard.setValue(false, forKey: "TouchIDSwitch")
        }else{
            
            if context.canEvaluatePolicy(
                LAPolicy.deviceOwnerAuthenticationWithBiometrics,
                error: &error) {
                if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                    switch context.biometryType {
                    case .faceID:
                        self.isTouchIDEnabled = false
                        // 21/sep/2020
                        //UserDefaults.standard.setValue(false, forKey: "TouchIDSwitch")
                        self.touchToggle.setOn(false, animated: true)
                        let strMessage = "Touch ID is not enrolled in the device.".localiz()
                        self.showAlertWith(message: AlertMessage(title: "Authentication".localiz(), body: strMessage))
                        
                        break
                    case .touchID:
                        if context.canEvaluatePolicy(
                            LAPolicy.deviceOwnerAuthenticationWithBiometrics,
                            error: &error) {
                            context.evaluatePolicy(
                                .deviceOwnerAuthentication, // deviceOwnerAuthenticationWithBiometrics
                                localizedReason: " ".localiz(), // "Set Touch ID", "Touch ID"
                                reply: { [unowned self] (success, error) -> Void in
                                    DispatchQueue.main.async {
                                        if( success ) {
                                            self.isTouchIDEnabled = true
                                            // 21/sep/2020
                                            //UserDefaults.standard.setValue(true, forKey: "TouchIDSwitch")
                                            
                                        } else {
                                            //If not recognized then
                                            if let error = error {
                                                self.touchToggle.setOn(false, animated: true)
                                                self.isTouchIDEnabled = false
                                                // 21/sep/2020
                                                //UserDefaults.standard.setValue(false, forKey: "TouchIDSwitch")
                                                
                                                let strMessage = self.errorMessage(errorCode: error._code)
                                                self.showAlertWith(message: AlertMessage(title: "Authentication".localiz(), body: strMessage))
                                            }
                                        }
                                    }
                            })
                        }
                        
                        break
                    case .none:
                        print("none")
                        
                        break
                    }
                }else {
                    
                    // Device cannot use biometric authentication
                    
                    if let err = error {
                        self.touchToggle.setOn(false, animated: true)
                        self.isTouchIDEnabled = false
                        // 21/sep/2020
                        //UserDefaults.standard.setValue(false, forKey: "TouchIDSwitch")
                        
                        let strMessage = self.errorMessage(errorCode: err._code)
                        self.showAlertWith(message: AlertMessage(title: "Authentication".localiz(), body: strMessage))
                    }
                }
            }else{
                if let err = error {
                    self.touchToggle.setOn(false, animated: true)
                    self.isTouchIDEnabled = false
                    // 21/sep/2020
                    //UserDefaults.standard.setValue(false, forKey: "TouchIDSwitch")
                    
                    let strMessage = self.errorMessage(errorCode: err._code)
                    self.showAlertWith(message: AlertMessage(title: "Authentication".localiz(), body: strMessage))
                }
            }
        }
    }
    
    
    @IBAction func faceEnable(_ sender: Any) {
        if isFaceIDEnabled {
            isFaceIDEnabled = false
            // 21/sep/2020
            //UserDefaults.standard.setValue(false, forKey: "FaceIDSwitch")
        }else{
            if context.canEvaluatePolicy(
                LAPolicy.deviceOwnerAuthenticationWithBiometrics,
                error: &error) {
                if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                    switch context.biometryType {
                    case .faceID:
                        if context.canEvaluatePolicy(
                            LAPolicy.deviceOwnerAuthenticationWithBiometrics,
                            error: &error) {
                            context.evaluatePolicy(
                                .deviceOwnerAuthentication, // deviceOwnerAuthenticationWithBiometrics
                                localizedReason: " ".localiz(), // "Set Face ID", "Face ID"
                                reply: { [unowned self] (success, error) -> Void in
                                    DispatchQueue.main.async {
                                        if( success ) {
                                            self.isFaceIDEnabled = true
                                            // 21/sep/2020
                                            //UserDefaults.standard.setValue(true, forKey: "FaceIDSwitch")
                                        } else {
                                            //If not recognized then
                                            if let error = error {
                                                self.isFaceIDEnabled = false
                                                // 21/sep/2020
                                                //UserDefaults.standard.setValue(false, forKey: "FaceIDSwitch")
                                                self.faceToggle.setOn(false, animated: true)
                                                
                                                let strMessage = self.errorMessage(errorCode: error._code)
                                                self.showAlertWith(message: AlertMessage(title: "Authentication".localiz(), body: strMessage))
                                            }
                                        }
                                    }
                            })
                        }
                        
                        
                        break
                    case .touchID:
                        self.isFaceIDEnabled = false
                        // 21/sep/2020
                        //UserDefaults.standard.setValue(false, forKey: "FaceIDSwitch")
                        self.faceToggle.setOn(false, animated: true)
                        let strMessage = "Face ID is not enrolled in the device.".localiz()
                        self.showAlertWith(message: AlertMessage(title: "Authentication".localiz(), body: strMessage))
                        break
                    case .none:
                        print("none")
                        
                        break
                    }
                }else {
                    
                    // Device cannot use biometric authentication
                    
                    if let err = error {
                        self.isFaceIDEnabled = false
                        // 21/sep/2020
                        //UserDefaults.standard.setValue(false, forKey: "FaceIDSwitch")
                        self.faceToggle.setOn(false, animated: true)
                        let strMessage = self.errorMessage(errorCode: err._code)
                        self.showAlertWith(message: AlertMessage(title: "Authentication".localiz(), body: strMessage))
                    }
                }
            }else{
                if let err = error {
                    self.isFaceIDEnabled = false
                    // 21/sep/2020
                    //UserDefaults.standard.setValue(false, forKey: "FaceIDSwitch")
                    self.faceToggle.setOn(false, animated: true)
                    let strMessage = self.errorMessage(errorCode: err._code)
                    self.showAlertWith(message: AlertMessage(title: "Authentication", body: strMessage))
                }
            }
            
            
            
        }
    }
    
    func errorDialogsetup(){
        errorDialog.layer.cornerRadius = CGFloat.CornerRadius.popup.radius
        btnKnowMore.layer.cornerRadius = CGFloat.CornerRadius.button.radius
        popupShadow(view: errorDialog)
    }
    
    var timer: Timer?
    var totalTime = 30
    
    private func startOtpTimer() {
        self.totalTime = 30
        self.btnResenOtp.isUserInteractionEnabled = false
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
        
        self.btnResenOtp.setTitle(timeStr, for: .normal)
        //            self.lblTimer.text = self.timeFormatted(self.totalTime) // will show timer
        if totalTime != 0 {
            totalTime -= 1  // decrease counter timer
        } else {
            if let timer = self.timer {
                timer.invalidate()
                self.timer = nil
                self.btnResenOtp.isUserInteractionEnabled = true
                self.btnResenOtp.setTitle("Resend OTP ?".localiz(), for: .normal)
            }
        }
    }
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "Resend in ".localiz() + "%02d:%02d", minutes, seconds)
    }
    
    @IBAction func resendOtp(_ sender: Any) {
        resendOTP()
        
    }
    @IBOutlet weak var btnResenOtp: UIButton!
    func registerNumberSetup(){
        
        btnNext.layer.cornerRadius = CGFloat.CornerRadius.button.radius
        tfMobileNumber.delegate = self
        tfMobileNumber.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                                 for: .editingChanged)
        //curvedView.constant = 550
        stackViewToggles(registerPage: false, enterPinPage: true, loginSelectOptionsPage: true, loginPage: true, welcomePage: true)
        disabledButton(btn: btnNext, imgArrow: btnNextArrowImg)
        progressBarProviderViewWidth.constant = 0
        selectedProviderImgWidth.constant = 0
        pinCodeView.isHidden = true
        btnResenOtp.isHidden = true
        pincodeViewHeight.constant = 0
        // 21/sep/2020
        phoneNumberViewHeight.constant = 60
        lblTitleTextfield.text = "Registered Mobile Number".localiz()
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect.init(x: 0.0, y: 75-1, width: tfMobileNumber.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.gray.cgColor
        tfMobileNumber.borderStyle = UITextField.BorderStyle.none
        tfMobileNumber.layer.addSublayer(bottomLine)
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        
        progressView.label.isHidden = true
        progressView.mode = .customView
        progressBar.addSubview(progressView)
        progressView.hide(animated: true)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        bannerCollectionView.collectionViewLayout = flowLayout
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        
    }
    
    @objc func textFieldsIsNotEmpty(sender: UITextField) {
        
        sender.text = sender.text?.trimmingCharacters(in: .whitespaces)
        if(tfMobileNumber.text?.count == 8){
            self.enabledButton(btn: btnNext, imgArrow: btnNextArrowImg)
            
            selectedProviderImgWidth.constant = 0
            
        }else{
            self.disabledButton(btn: btnNext, imgArrow: btnNextArrowImg)
            
        }
        
    }
    func loginScreen(){
        // curvedView.constant = 450
        btnType = 4
    }
    @IBOutlet weak var errImageHreight: NSLayoutConstraint!
    func otpScreenSetup(){
        
        /*
         if UserDefaults.standard.value(forKey: "loginDetails") != nil {
         //Logged In
         } else {
         // Not logged in user so show TnC page
         let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "T_CViewController") as? T_CViewController
         controller?.isFrom = "register"
         controller?.modalPresentationStyle = .overCurrentContext // .fullScreen
         //self.present(controller!, animated: true, completion: nil)
         //self.navigationController?.pushViewController(controller!, animated: true)
         }
         */
        
        if let receivedData = KeyChain.load(key: "loginDetails") {
            let result = receivedData.to(type: String.self)
            print("result: ", result)
        } else {
            
            // Not logged in user so show TnC page
            let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "T_CViewController") as? T_CViewController
            controller?.isFrom = "register"
            controller?.modalPresentationStyle = .overCurrentContext // .fullScreen
            //self.present(controller!, animated: true, completion: nil)
            //self.navigationController?.pushViewController(controller!, animated: true)
            
        }
        
        phoneNumberView.isHidden = true
        pinCodeView.isHidden = false
        btnResenOtp.isHidden = false
        phoneNumberViewHeight.constant = 0
        pincodeViewHeight.constant = 60
        errImgHeight.constant = 0
        btnType = 1
        errImageHreight.constant  = 0
        errorDialogHeight.constant = 200
        btnKnowMore.setTitle("OK".localiz(), for: .normal)
        errorCloseBtnHwight.constant = 0
        
        pinCodeView.becomeFirstResponderAtIndex = -1
        pinCodeView.clearPin()
        
        let string = tfMobileNumber.text!
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
        
        //        errorLbl.text = "An OTP has been sent on Mob. no " + tfMobileNumber.text!
        errorLbl.text = "An OTP has been sent on Mobile number ".localiz() + str
        
        lblTitleTextfield.text = "Enter OTP".localiz()
        
    }
    
    func otpScreenSetup1(){
        
        phoneNumberView.isHidden = true
        pinCodeView.isHidden = false
        btnResenOtp.isHidden = false
        phoneNumberViewHeight.constant = 0
        pincodeViewHeight.constant = 60
        errImgHeight.constant = 0
        btnType = 1
        errImageHreight.constant  = 0
        errorDialogHeight.constant = 200
        btnKnowMore.setTitle("OK".localiz(), for: .normal)
        errorCloseBtnHwight.constant = 0
        
        pinCodeView.becomeFirstResponderAtIndex = -1
        pinCodeView.clearPin()
        
        let string = tfMobileNumber.text!
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
        
        //        errorLbl.text = "An OTP has been sent on Mob. no " + tfMobileNumber.text!
        errorLbl.text = "An OTP has been sent on Mobile number ".localiz() + str
        
        lblTitleTextfield.text = "Enter OTP".localiz()
        
    }
    
    
    @IBOutlet weak var errorCloseBtnHwight: NSLayoutConstraint!
    func disabledButton(btn:GradientLayer,imgArrow:UIImageView){
        btn.isUserInteractionEnabled = false
        buttonShadow(btn: btn, shadowOpacity: 0.0)
        btn.setTitleColor(UIColor.BurganColor.brandGray.disable, for: .normal)
        imgArrow.setImageColor(color: UIColor.BurganColor.brandGray.disable)
        btn.color1 = UIColor.BurganColor.brandGray.light
        btn.color2 = UIColor.BurganColor.brandGray.light
        btn.color3 = UIColor.BurganColor.brandGray.light
        
    }
    
    func buttonShadow(btn:UIButton,shadowOpacity:CGFloat){
        btn.layer.shadowColor = UIColor.BurganColor.brandBlue.light.cgColor
        btn.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        btn.layer.shadowOpacity = Float(shadowOpacity)
        btn.layer.shadowRadius = 5.0
        btn.layer.masksToBounds = false
    }
    
    func popupShadow(view:UIView){
        view.layer.shadowColor = UIColor.BurganColor.brandGray.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        view.layer.shadowOpacity = 1.0
        view.layer.shadowRadius = 10.0
        view.layer.masksToBounds = false
    }
    
    func showAlert(msg: String, isError: Bool) {
        
        tfMobileNumber.text = ""
        disabledButton(btn: btnNext, imgArrow: btnNextArrowImg)
        
        if pinCodeView.isHidden == false {
            enabledButton(btn: btnNext, imgArrow: btnNextArrowImg)
        }
        
        errorDialogOuterview.isHidden = false
        errorLbl.text = msg
        btnKnowMore.setTitle("OK".localiz(), for: .normal)
        
        if isError{
            errImgView.isHidden = false
            
        } else {
            errImgView.isHidden = true
            
        }
    }
    
    func enabledButton(btn:GradientLayer,imgArrow:UIImageView ){
        
        imgArrow.setImageColor(color: UIColor.white)
        buttonShadow(btn: btn, shadowOpacity: 1.0)
        btn.isUserInteractionEnabled = true
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.color1 = UIColor.BurganColor.brandBlue.medium
        btn.color2 = UIColor.BurganColor.brandBlue.medium
        btn.color3 = UIColor.BurganColor.brandBlue.medium
        
    }
    
    var selectedProvider : serviceProviderList?
    func selectedProvider(service: serviceProviderList) {
        if(service.name != ""){
            submitProvider(serviceprovider: service.name!)
            selectedProvider = service
            
            //remove when api works
            selectedProviderImgWidth.constant = 50
            progressBarProviderViewWidth.constant = 0
            selectedProvideImg.image = UIImage(named: selectedProvider!.providerImg!)
            otpScreenSetup()
            errorDialogOuterview.isHidden = false
            //remove when api works
        }
    }
    
    func codeView(codeView:SVPinView,digits:Int){
        
        codeView.activeBorderLineColor  = UIColor.BurganColor.brandGray.lgiht
        codeView.textColor = UIColor.BurganColor.brandGray.black
        codeView.keyboardType = .numberPad
        codeView.placeholder = ""
        //codeView.becomeFirstResponderAtIndex = 0
        codeView.shouldDismissKeyboardOnEmptyFirstField = false
        codeView.allowsWhitespaces = false
        codeView.borderLineThickness = 1
        codeView.interSpace = 10
        codeView.borderLineColor = UIColor.BurganColor.brandGray.lgiht
        
        // codeView.font = UIFont(name:"Monsterrat-Medium", size: 15)!
        
        codeView.pinLength = digits
        codeView.activeBorderLineThickness = 1
        codeView.fieldBackgroundColor = UIColor.clear
        codeView.activeFieldBackgroundColor = UIColor.clear
        codeView.fieldCornerRadius = 0
        codeView.activeFieldCornerRadius = 0
        
    }
    
    @IBOutlet weak var imgLock: UIImageView!
    @IBAction func goToLoginOptions(_ sender: Any) {
        enabledButton(btn: btnLogin, imgArrow: btnLoginArrowImg)
        stackViewToggles(registerPage: true, enterPinPage: true, loginSelectOptionsPage: false, loginPage: true, welcomePage: true)
    }
    
    @IBOutlet weak var btnRegisterArrowImg: UIImageView!
    
    @IBOutlet weak var btnLoginArrowImg: UIImageView!
    let yourAttributes : [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
    
    @IBOutlet weak var forgotPswd: UIButton!
    
    
    func setup(){
        btnNext.setTitle("NEXT".uppercased(), for: .normal)
        btnRegister.setTitle("REGISTER".uppercased(), for: .normal)
        btnLogin.setTitle("LOGIN".uppercased(), for: .normal)
        registerNumberSetup()
        errorDialogsetup()
        let attributeString = NSMutableAttributedString(string: "Forgot PIN ?".localiz(),
                                                        attributes: yourAttributes)
        forgotPswd.setAttributedTitle(attributeString, for: .normal)
        forgotPswd.setTitleColor(UIColor.BurganColor.brandGray.medium, for: .normal)
        
        let attributeString1 = NSMutableAttributedString(string: "Login With Different Mobile No.".localiz(),
                                                         attributes: yourAttributes)
        loginWithDiffNo_Btn.setAttributedTitle(attributeString1, for: .normal)
        
        
        mPinView.layer.borderColor = UIColor.BurganColor.brandGray.light.cgColor
        mPinView.layer.borderWidth = 1
        mPinView.layer.cornerRadius = CGFloat.CornerRadius.popup.radius
        touchIDView.layer.borderColor = UIColor.BurganColor.brandGray.light.cgColor
        touchIDView.layer.borderWidth = 1
        touchIDView.layer.cornerRadius = CGFloat.CornerRadius.popup.radius
        facIDView.layer.borderColor = UIColor.BurganColor.brandGray.light.cgColor
        facIDView.layer.borderWidth = 1
        facIDView.layer.cornerRadius = CGFloat.CornerRadius.popup.radius
        enabledButton(btn: btnRegister, imgArrow: btnRegisterArrowImg)
        btnRegister.layer.cornerRadius = CGFloat.CornerRadius.button.radius
        viewCurved.layer.cornerRadius = CGFloat.CornerRadius.popup.radius
        codeView(codeView: pinCodeView, digits: 6)
        codeView(codeView: loginPinView, digits: 6)
        codeView(codeView: verificationCodeView, digits: 6)
        codeView(codeView: confirmationCodeview, digits: 6)
        verificationCodeView.didFinishCallback = { [weak self] pin in
            
            guard let unwarapSelf = self else {
                return
            }
            print("The pin entered is \(pin)")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                unwarapSelf.confirmationCodeview.becomeFirstResponderAtIndex = 0
                unwarapSelf.confirmationCodeview.clearPin()
            }
            
        }
        enabledButton(btn: btnLogin, imgArrow: btnLoginArrowImg)
        touchToggle.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        faceToggle.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        if AppConstants.language == .en {
            btnLanguage.setTitle("عربى", for: .normal)
            ivLogo.image = UIImage(named: "tijarati_En")
            
        } else {
            btnLanguage.setTitle("English", for: .normal)
            ivLogo.image = UIImage(named: "tijarati_Ar")
        }
        
        btnLogin.layer.cornerRadius = CGFloat.CornerRadius.button.radius
        
    }
    
    
    @IBAction func selectFaceID(_ sender: Any) {
        
        if context.canEvaluatePolicy(
            LAPolicy.deviceOwnerAuthenticationWithBiometrics,
            error: &error) {
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                switch context.biometryType {
                case .faceID:
                    if context.canEvaluatePolicy(
                        LAPolicy.deviceOwnerAuthenticationWithBiometrics,
                        error: &error) {
                        context.evaluatePolicy(
                            .deviceOwnerAuthentication, // deviceOwnerAuthenticationWithBiometrics
                            localizedReason: " ".localiz(), // "Set Face ID", "Face ID"
                            reply: { [unowned self] (success, error) -> Void in
                                DispatchQueue.main.async {
                                    if( success ) {
                                        self.loginSelectedOption = "faceID"
                                        self.loginUser()
                                    } else {
                                        //If not recognized then
                                        if let error = error {
                                            let strMessage = self.errorMessage(errorCode: error._code)
                                            self.showAlertWith(message: AlertMessage(title: "Authentication".localiz(), body: strMessage))
                                        }
                                    }
                                }
                        })
                    }
                    
                    
                    break
                case .touchID:
                    
                    break
                case .none:
                    print("none")
                    
                    break
                }
            } else {
                
                // Device cannot use biometric authentication
                
                if let err = error {
                    let strMessage = self.errorMessage(errorCode: err._code)
                    self.showAlertWith(message: AlertMessage(title: "Authentication".localiz(), body: strMessage))
                }
            }
        } else {
            if let err = error {
                let strMessage = self.errorMessage(errorCode: err._code)
                self.showAlertWith(message: AlertMessage(title: "Authentication".localiz(), body: strMessage))
            }
        }
        
    }
    
    var loginSelectedOption = "mPin"
    @IBAction func selectTouchID(_ sender: Any) {
        
        if context.canEvaluatePolicy(
            LAPolicy.deviceOwnerAuthenticationWithBiometrics,
            error: &error) {
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                switch context.biometryType {
                case .faceID:
                    
                    
                    break
                case .touchID:
                    if context.canEvaluatePolicy(
                        LAPolicy.deviceOwnerAuthenticationWithBiometrics,
                        error: &error) {
                        context.evaluatePolicy(
                            .deviceOwnerAuthentication, //deviceOwnerAuthenticationWithBiometrics
                            localizedReason: " ".localiz(), // "Set Touch ID", "Touch ID"
                            reply: { [unowned self] (success, error) -> Void in
                                DispatchQueue.main.async {
                                    if( success ) {
                                        self.loginSelectedOption = "touchID"
                                        self.loginUser()
                                    } else {
                                        //If not recognized then
                                        if let error = error {
                                            let strMessage = self.errorMessage(errorCode: error._code)
                                            self.showAlertWith(message: AlertMessage(title: "Authentication".localiz(), body: strMessage))
                                        }
                                    }
                                }
                        })
                    }
                    
                    break
                case .none:
                    print("none")
                    
                    break
                }
            } else {
                
                // Device cannot use biometric authentication
                
                if let err = error {
                    let strMessage = self.errorMessage(errorCode: err._code)
                    self.showAlertWith(message: AlertMessage(title: "Authentication".localiz(), body: strMessage))
                }
            }
        } else {
            if let err = error {
                let strMessage = self.errorMessage(errorCode: err._code)
                self.showAlertWith(message: AlertMessage(title: "Authentication".localiz(), body: strMessage))
            }
        }
        
        
    }
    
    @IBAction func selectmPPIN(_ sender: Any) {
        stackViewToggles(registerPage: true, enterPinPage: true, loginSelectOptionsPage: true, loginPage: false, welcomePage: true)
        loginScreen()
        loginSelectedOption = "mPin"
        
        loginPinView.becomeFirstResponderAtIndex = 0
        loginPinView.clearPin()
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == tfMobileNumber && textField.text != "" ){
            if(textField.text?.count == 8){
                enabledButton(btn: btnNext, imgArrow: btnNextArrowImg)
                
            }else{
                
                showAlertWith(message: AlertMessage(title: "Registration".localiz(), body: "Please enter valid phone number".localiz()))          }
            tfMobileNumber.text =  tfMobileNumber.text!.localiz()
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width-10, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bannerCollectionViewCell", for: indexPath) as! bannerCollectionViewCell
        if(indexPath.row == 0){
            cell.bannerImg.image = UIImage(named: "ic_360_reports")
            cell.lblTitle.text = "360 Reports"
            cell.lblDescp.text = "You can now get detailed data about your business in just few clicks."
        }else if indexPath.row == 1 {
            cell.bannerImg.image = UIImage(named: "ic_360_dashboard")
            cell.lblTitle.text = "360 Dashboard"
            cell.lblDescp.text = "Get a wholesome look of how your business is doing with our dashboard."
            
        }else{
            cell.bannerImg.image = UIImage(named: "ic_campaign")
            cell.lblTitle.text = "Campaigns"
            //            cell.lblDescp.text = "Communicate with your customers using campaigns for email, sms & social media."
            cell.lblDescp.text = "Communicate with our customers easily using campaigns through email, sms and social media."
            
        }
        cell.lblTitle.text =  cell.lblTitle.text?.localiz()
        cell.lblDescp.text = cell.lblDescp.text?.localiz()
        return cell
    }
    
    @IBAction func forgotPIN(_ sender: Any) {
        let controller = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ForgotPinViewController") as? ForgotPinViewController)!
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.row
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x)/Int(scrollView.frame.width - 50)
        
    }
    
    
    @IBOutlet weak var btnEye: UIButton!
    
    @IBOutlet weak var btnConfirmPinEye: UIButton!
    var showLoginPin = false
    @IBAction func btnShowPin(_ sender: Any) {
        if showLoginPin{
            loginPinView.shouldSecureText = true
            showLoginPin = false
            btnEye.setImage(UIImage(named: "ic_eye"), for: .normal)
        } else {
            loginPinView.shouldSecureText = false
            showLoginPin = true
            btnEye.setImage(UIImage(named: "ic_show_pswd"), for: .normal)
            
        }
        loginPinView.pastePin(pin: loginPinView.getPin())
        
    }
    var showConfirmPin = false
    
    @IBAction func btnShowConfirmPIN(_ sender: Any) {
        if showConfirmPin{
            confirmationCodeview.shouldSecureText = true
            showConfirmPin = false
            btnConfirmPinEye.setImage(UIImage(named: "ic_eye"), for: .normal)
            
        } else {
            confirmationCodeview.shouldSecureText = false
            showConfirmPin = true
            btnConfirmPinEye.setImage(UIImage(named: "ic_show_pswd"), for: .normal)
            
        }
        confirmationCodeview.pastePin(pin: confirmationCodeview.getPin())
        
        
    }
    @IBAction func registerUser(_ sender: Any) {
        
        func alert(message: AlertMessage , style: UIAlertController.Style = .alert) {
            let alertController = UIAlertController(title: message.title.localiz(), message: message.body.localiz(), preferredStyle: style)
            let action = UIAlertAction(title: "Ok".localiz(), style: .default) { (action) in
                alertController.dismiss(animated: true, completion: nil)
                self.verificationCodeView.becomeFirstResponderAtIndex = 0
                self.confirmationCodeview.clearPin()
                self.verificationCodeView.clearPin()
            }
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }
        
        
        if verificationCodeView.getPin() != ""
        {
            if confirmationCodeview.getPin() != "" {
                
                if  verificationCodeView.getPin().count == 6 {
                    
                    if confirmationCodeview.getPin().count == 6 {
                        
                        if verificationCodeView.getPin() == confirmationCodeview.getPin()
                        {
                            if isFaceIDEnabled {
                                self.authenticate(isFaceDetection: true)
                            }
                            if isTouchIDEnabled {
                                self.authenticate(isFaceDetection: false)
                                
                            }
                            
                            self.setPIN()
                            
                            //remove when api works
                            //              stackViewToggles(registerPage: true, enterPinPage: true, loginSelectOptionsPage: true, loginPage: true, welcomePage: false)
                            //
                            //                                          Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(showLoginPage), userInfo: nil, repeats: false)
                            //                //remove when api works
                        } else {
                            
                            alert(message: AlertMessage(title: "Set PIN".localiz(), body: "Entered PIN and confirmation PIN do not match.".localiz()))
                        }
                        
                    } else {
                        
                        alert(message: AlertMessage(title: "Set PIN".localiz(), body: "Enter valid confirmation PIN".localiz()))
                    }
                } else {
                    
                    alert(message: AlertMessage(title: "Set PIN".localiz(), body: "Enter valid PIN".localiz()))
                }
            } else {
                
                alert(message: AlertMessage(title: "Set PIN".localiz(), body: "Enter confirmation PIN".localiz()))
                
            }
        } else {
            
            alert(message: AlertMessage(title: "Set PIN".localiz(), body: "Enter PIN".localiz()))
        }
    }
    
    
    func authenticate(isFaceDetection : Bool){
        if context.canEvaluatePolicy(
            LAPolicy.deviceOwnerAuthenticationWithBiometrics,
            error: &error) {
            context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason:"Biometric Authentication",
                reply: { [unowned self] (success, error) -> Void in
                    DispatchQueue.main.async {
                        if( success ) {
                            if isFaceDetection {
                                self.faceToggle.isOn = true
                                
                            }else{
                                self.touchToggle.isOn = true
                            }
                        } else {
                            //If not recognized then
                            if let error = error {
                                let strMessage = self.errorMessage(errorCode: error._code)
                                self.showAlertWith(message: AlertMessage(title: "Authentication".localiz(), body: strMessage))
                            }
                        }
                    }
            })
        }
    }
    @objc func showLoginPage(){
        self.stackViewToggles(registerPage: true, enterPinPage: true, loginSelectOptionsPage: false, loginPage: true, welcomePage: true)
    }
    @IBAction func closeErrorDialog(_ sender: Any) {
        
        errorDialogOuterview.isHidden = true
    }
    
    func presentAlert(withTitle title: String, message : String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK".localiz(), style: .default) { action in
                print("You've pressed OK Button")
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    
    @IBOutlet weak var usempinLabel: UILabel!
    @IBOutlet weak var useTouchIdLabel: UILabel!
    @IBOutlet weak var useFaceIdLabel: UILabel!
    @IBOutlet weak var createMpinLabel: UILabel!
    
    func arabicSetup()
    {
        btnLanguage.setTitle(btnLanguage.title(for: .normal)!.localiz(), for: .normal)
        lblTitleTextfield.text = lblTitleTextfield.text!.localiz()
        tfMobileNumber.text = tfMobileNumber.text!.localiz()
        btnLogin.setTitle("LOGIN".localiz(), for: .normal)
        btnNext.setTitle("NEXT".localiz(), for: .normal)
        btnKnowMore.setTitle("OK".localiz(), for: .normal)
        lblLoginOptionTitle.text =  "Please choose how would you like to login".localiz()
        forgotPswd.setTitle("Forgot PIN ?".localiz(), for: .normal)
        btnRegister.setTitle("REGISTER".localiz(), for: .normal)
        btnResenOtp.setTitle("Resend OTP ?".localiz(), for: .normal)
        
        loginWithDiffNo_Btn.setTitle("Login With Different Mobile No.".localiz(), for: .normal)
        
        //        let attributeString = NSMutableAttributedString(string: "Your button text",
        //                                                        attributes: myAttributes)
        //        loginWithDiffNo_Btn.setAttributedTitle(attributeString, for: .normal)
        //
        //        let attributeString = NSMutableAttributedString(string: "Forgot PIN ?".localiz(),
        //                                                        attributes: yourAttributes)
        //        forgotPswd.setAttributedTitle(attributeString, for: .normal)
        
        if AppConstants.language == .ar {
            
            usempinLabel.textAlignment = .right
            useTouchIdLabel.textAlignment = .right
            useFaceIdLabel.textAlignment = .right
            createMpinLabel.textAlignment = .right
            
        } else {
            usempinLabel.textAlignment = .left
            useTouchIdLabel.textAlignment = .left
            useFaceIdLabel.textAlignment = .left
            createMpinLabel.textAlignment = .left
        }
    }
    
    @IBOutlet weak var touchIDCheckView: UIView!
    @IBOutlet weak var faceIDView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.networkStatusChanged(_:)), name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        definesPresentationContext = true
        
        
        self.loopThroughSubViewAndMirrorImage(subviews: self.view.subviews)
        
        AppConstants.UserData.deviceID = UIDevice.current.identifierForVendor!.uuidString
        deviceID  = UIDevice.current.identifierForVendor!.uuidString
        
        //        AppConstants.UserData.deviceID = "79cc094e0eae027a"
        //        deviceID  = "79cc094e0eae027a"
        
        self.setup()
        self.faceToggle.setOn(false, animated: false)
        self.touchToggle.setOn(false, animated: false)
        self.faceToggle.isUserInteractionEnabled = true
        self.touchToggle.isUserInteractionEnabled = true
        self.biometricAuthentication()
        self.navigationController?.isNavigationBarHidden = true
        
        //
        self.navigationController?.isNavigationBarHidden = true
        self.viewModel = RegistrationViewControllerViewModel();
        
        if (showLoginScreen){
            
            //            stackViewToggles(registerPage: true, enterPinPage: true, loginSelectOptionsPage: true, loginPage: false, welcomePage: true)
            
            if UserDefaults.standard.value(forKey: "TouchIDSwitch") != nil {
                let switchState = UserDefaults.standard.value(forKey: "TouchIDSwitch") as! Bool
                print(switchState)
                if switchState == true {
                    self.touchIDView.isHidden = false
                } else {
                    self.touchIDView.isHidden = true
                }
            }
            
            
            if UserDefaults.standard.value(forKey: "FaceIDSwitch") != nil {
                let switchState = UserDefaults.standard.value(forKey: "FaceIDSwitch") as! Bool
                print(switchState)
                if switchState == true {
                    self.facIDView.isHidden = false
                } else {
                    self.facIDView.isHidden = true
                }
            }
            
            
            stackViewToggles(registerPage: true, enterPinPage: true, loginSelectOptionsPage: false, loginPage: true, welcomePage: true)
            
            
        } else {
            stackViewToggles(registerPage: false, enterPinPage: true, loginSelectOptionsPage: true, loginPage: true, welcomePage: true)
        }
        arabicSetup()
        
        startTimer()
    }
    
    func startTimer() {
        
        _ =  Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: true)
    }
    
    
    @objc func scrollAutomatically(_ timer1: Timer) {
        
        if let coll  = bannerCollectionView {
            for cell in coll.visibleCells {
                let indexPath: IndexPath? = coll.indexPath(for: cell)
                if ((indexPath?.row)! < 3 - 1){
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)
                    
                    coll.scrollToItem(at: indexPath1!, at: .right, animated: true)
                }
                else{
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: 0, section: (indexPath?.section)!)
                    coll.scrollToItem(at: indexPath1!, at: .left, animated: true)
                }
            }
        }
    }
    
    
    
    func getFilterData(){
        let param : [String : Any] = ["cif" : AppConstants.UserData.cif,
                                      "deviceId" : AppConstants.UserData.deviceID]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.applyFilter)
        self.bindUIFilter()
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
    
    private func bindUIFilter(){
        
        self.viewModel?.alertMessage.bind({ [weak self] in
            MBProgressHUD.hide(for: self!.view, animated: true)
            self?.showAlertDismissOnly(message: $0)
        })
        
        self.viewModel?.response.bind({ [weak self] in
            
            if let response = $0 {
                
                print("My IV is :: \(response.iv)")
                print("My payload is :: \(response.payload)")
                
                if let userStatus = DataDecryption().decryption(jsonModel: PayloadRes(iv: response.iv, payload: response.payload))
                {
                    MBProgressHUD.hide(for: self!.view, animated: true)
                    
                    let status : String = userStatus.value(forKey: "status") as? String ?? ""
                    
                    if status == "" {
                        
                        self?.getFilterData()
                        
                    } else {
                        
                        let status : String = userStatus.value(forKey: "status") as! String
                        let msg : String = userStatus.value(forKey: "message") as! String
                        if(status == "Success")
                        {
                            let errorCode : String = userStatus.value(forKey: "errorCode") as! String
                            if errorCode == "L128"
                            {
                                if let object = self?.decodeResult(model: LocationFilter.self, result: userStatus)
                                {
                                    let filterDataObject = object.model
                                    AppConstants.locationFilterData  = filterDataObject!
                                    var heirarchyArr : [Hierarchy] = (filterDataObject?.filterData[0].hierarchy)!
                                    
                                    AppConstants.merchantNumber.removeAll()
                                    
                                    for i in 0..<heirarchyArr.count{
                                        for j in 0..<heirarchyArr[i].brandNameList.count{
                                            for k in 0..<heirarchyArr[i].brandNameList[j].locationNameList.count{
                                                for l in 0..<heirarchyArr[i].brandNameList[j].locationNameList[k].merchantNumber.count
                                                {
                                                    let m : Int = Int(heirarchyArr[i].brandNameList[j].locationNameList[k].merchantNumber[l].mid)!
                                                    AppConstants.merchantNumber.append(m)
                                                }
                                            }
                                        }
                                    }
                                    
                                    AppConstants.selectedFilter = selectedFilterData(companyName: filterDataObject!.filterData[0].companyName, selectedAccounts: filterDataObject!.filterData[0].accountList, selectedBrands: filterDataObject!.filterData[0].brandList, selectedLocations: filterDataObject!.filterData[0].locationList, cif: filterDataObject!.filterData[0].cif, selectedMerchants: AppConstants.merchantNumber, hiearchy: filterDataObject!.filterData[0].hierarchy)
                                    AppConstants.originalSelectFilter = AppConstants.selectedFilter
                                    
                                    AppConstants.ezpayOutletNumber = filterDataObject?.filterData[0].ezpayOutletNumber ?? ""
                                    AppConstants.UserData.companyCIF = filterDataObject?.filterData[0].cif ?? ""
                                    AppConstants.cifCompanyName = filterDataObject?.filterData[0].companyName ?? ""
                                    AppConstants.cifDataList.removeAll()
                                    for item in filterDataObject!.filterData {
                                        AppConstants.cifDataList.append(CifData(cif: item.cif, companyName: item.companyName, ezpayOutletNumber: item.ezpayOutletNumber))
                                    }
                                    
                                    let controller = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RootViewController") as? RootViewController)!
                                    self?.navigationController?.pushViewController(controller, animated: true)
                                    
                                    
                                } else {
                                    self?.showAlert(msg: "Invalid data.".localiz(), isError: true)
                                }
                                   
                            } else {
                                self?.showAlert(msg: msg, isError: true)
                            }
                            
                        } else {
                            self?.showAlert(msg: msg, isError: true)
                        }
                        
                    }
                      
                }
                
            } else {
                MBProgressHUD.hide(for: self!.view, animated: true)
                self!.showAlertWith(message: AlertMessage(title: "Tijarati".localiz(), body: "Sorry, Failed to load data.".localiz()))
            }
        })
        
    }
    
    private func bindUI() {
        
        self.viewModel?.alertMessage.bind({ [weak self] in
            MBProgressHUD.hide(for: self!.view, animated: true)
            self?.showAlertDismissOnly(message: $0)
        })
        
        self.viewModel?.response.bind({ [weak self] in
            
            guard let unwrapSelf = self else { return }
            
            if let response = $0 {
                
                print("My IV is :: \(response.iv)")
                print("My payload is :: \(response.payload)")
                
                if  let userStatus = DataDecryption().decryption(jsonModel: PayloadRes(iv: response.iv, payload: response.payload))
                {
                    MBProgressHUD.hide(for: unwrapSelf.view, animated: true)
                    
                    let status : String = userStatus.value(forKey: "status") as? String ?? ""
                    
                    if status == "" {
                        
                        if unwrapSelf.apiRequestType == unwrapSelf.AUTH_USER {
                            unwrapSelf.authenticateUser()
                        } else if unwrapSelf.apiRequestType == unwrapSelf.SERVICE_PROVIDER {
                            unwrapSelf.submitProvider(serviceprovider: (unwrapSelf.selectedProvider?.name)!)
                        } else if unwrapSelf.apiRequestType == unwrapSelf.OTP_VERIFY {
                            unwrapSelf.setOTP()
                        } else if unwrapSelf.apiRequestType == unwrapSelf.RESEND_OTP {
                            unwrapSelf.resendOTP()
                        } else if unwrapSelf.apiRequestType == unwrapSelf.SET_PIN {
                            unwrapSelf.setPIN()
                        } else if unwrapSelf.apiRequestType == unwrapSelf.VERIFY_PIN {
                            unwrapSelf.loginUser()
                        }
                        
                    } else {
                        
                        let status : String = userStatus.value(forKey: "status") as! String
                        let msg : String = userStatus.value(forKey: "message") as! String
                        if(status == "Success") {
                            
                            
                            if unwrapSelf.apiRequestType == unwrapSelf.AUTH_USER {
                                
                                
                                unwrapSelf.enabledButton(btn: unwrapSelf.btnNext, imgArrow: unwrapSelf.btnNextArrowImg)
                                
                                let errorCode : String = userStatus.value(forKey: "errorCode") as! String
                                
                                let msg : String = userStatus.value(forKey: "message") as! String
                                AppConstants.UserData.cif = (unwrapSelf.tfMobileNumber.text!)
                                
                                
                                if(errorCode == "L123") {
                                    
                                    var serviceProviderArray = [serviceProviderList]()
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
                                            serviceProviderArray.append(serviceProvider)
                                        }
                                        let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ServiceProviderViewController") as? ServiceProviderViewController
                                        
                                        controller?.delegate = self
                                        controller?.serviceproviderArr = serviceProviderArray
                                        unwrapSelf.presentAsStork(controller!, height: 500.0, cornerRadius: CGFloat.CornerRadius.popup.radius, showIndicator: false, showCloseButton: false, complection: nil)
                                    }
                                    
                                } else if errorCode == "L120" {
                                    unwrapSelf.errorDialogOuterview.isHidden = false
                                    unwrapSelf.otpScreenSetup()
                                    
                                } else if errorCode == "L115" {
                                    
                                    if userStatus.value(forKey: "istouchIDEnabled") as? String ?? "" == "false" && userStatus.value(forKey: "isfaceIDEnabled") as? String ?? "" == "false" && userStatus.value(forKey: "ismPinEnabled") as? String ?? "" == "false" {
                                        
                                        // if all the 3 ways of verifyPin is false then need to the take the merchant to set pin page
                                        
                                        unwrapSelf.stackViewToggles(registerPage: true, enterPinPage: true, loginSelectOptionsPage: true, loginPage: false, welcomePage: true)
                                        
                                    } else {
                                        
                                        // if anyone of verifyPin is true then show the login option
                                        
                                        if userStatus.value(forKey: "istouchIDEnabled") as? String ?? "" == "true" {
                                            UserDefaults.standard.setValue(true, forKey: "TouchIDSwitch")
                                            unwrapSelf.touchIDView.isHidden = false
                                        } else {
                                            UserDefaults.standard.setValue(false, forKey: "TouchIDSwitch")
                                            unwrapSelf.touchIDView.isHidden = true
                                        }
                                        
                                        if userStatus.value(forKey: "isfaceIDEnabled") as? String ?? "" == "true" {
                                            UserDefaults.standard.setValue(true, forKey: "FaceIDSwitch")
                                            unwrapSelf.facIDView.isHidden = false
                                        } else {
                                            UserDefaults.standard.setValue(false, forKey: "FaceIDSwitch")
                                            unwrapSelf.facIDView.isHidden = true
                                        }
                                        
                                        unwrapSelf.stackViewToggles(registerPage: true, enterPinPage: true, loginSelectOptionsPage: false, loginPage: true, welcomePage: true)
                                        
                                    }
                                    
                                    
                                } else {
                                    
                                    unwrapSelf.showAlert(msg:msg.localiz(), isError: true)
                                }
                                
                                
                            } else if unwrapSelf.apiRequestType == unwrapSelf.SERVICE_PROVIDER {
                                unwrapSelf.enabledButton(btn: unwrapSelf.btnNext, imgArrow: unwrapSelf.btnNextArrowImg)
                                let errorCode : String = userStatus.value(forKey: "errorCode") as! String
                                let msg : String = userStatus.value(forKey: "message") as! String
                                
                                if(errorCode == "S101") {
                                    unwrapSelf.selectedProviderImgWidth.constant = 50
                                    unwrapSelf.progressBarProviderViewWidth.constant = 0
                                    unwrapSelf.selectedProvideImg.image = UIImage(named: (unwrapSelf.selectedProvider?.providerImg)!)
                                    unwrapSelf.otpScreenSetup()
                                    unwrapSelf.errorDialogOuterview.isHidden = false
                                    
                                    
                                } else {
                                    unwrapSelf.errorDialogOuterview.isHidden = false
                                    unwrapSelf.showAlert(msg: msg.localiz(), isError: true)
                                    
                                }
                            } else if unwrapSelf.apiRequestType == unwrapSelf.OTP_VERIFY {
                                unwrapSelf.enabledButton(btn: unwrapSelf.btnNext, imgArrow: unwrapSelf.btnNextArrowImg)
                                let errorCode : String = userStatus.value(forKey: "errorCode") as! String
                                let msg : String = userStatus.value(forKey: "message") as! String
                                
                                if errorCode == "S101"
                                {
                                    unwrapSelf.verificationCodeView.becomeFirstResponderAtIndex = 0
                                    unwrapSelf.confirmationCodeview.clearPin()
                                    unwrapSelf.verificationCodeView.clearPin()
                                    unwrapSelf.stackViewToggles(registerPage: true, enterPinPage: false, loginSelectOptionsPage: true, loginPage: true, welcomePage: true)
                                    unwrapSelf.btnType = 2
                                } else {
                                    unwrapSelf.pinCodeView.becomeFirstResponderAtIndex = -1
                                    unwrapSelf.pinCodeView.clearPin()
                                    unwrapSelf.enabledButton(btn: unwrapSelf.btnNext, imgArrow: unwrapSelf.btnNextArrowImg)
                                    unwrapSelf.showAlert(msg: msg.localiz(), isError: true)
                                }
                                
                            } else if unwrapSelf.apiRequestType == unwrapSelf.RESEND_OTP {
                                
                                let errorCode : String = userStatus.value(forKey: "errorCode") as! String
                                let msg : String = userStatus.value(forKey: "message") as! String
                                if errorCode == "L120"
                                {
                                    unwrapSelf.errorDialogOuterview.isHidden = false
                                    unwrapSelf.otpScreenSetup1()
                                    unwrapSelf.startOtpTimer()
                                } else {
                                    unwrapSelf.pinCodeView.becomeFirstResponderAtIndex = -1
                                    unwrapSelf.pinCodeView.clearPin()
                                    unwrapSelf.showAlert(msg: msg.localiz(), isError: true)
                                    
                                }
                                
                            } else if unwrapSelf.apiRequestType == unwrapSelf.SET_PIN {
                                
                                let errorCode : String = userStatus.value(forKey: "errorCode") as! String
                                let msg : String = userStatus.value(forKey: "message") as! String
                                
                                if errorCode == "S101"{
                                    
                                    unwrapSelf.lblWelcomeUserName.text = userStatus.value(forKey: "merchantName") as? String ?? ""
                                    unwrapSelf.lblWelcomeUserName.textAlignment = .center
                                    
                                    AppConstants.UserData.name = userStatus.value(forKey: "merchantName") as? String ?? ""
                                    
                                    unwrapSelf.stackViewToggles(registerPage: true, enterPinPage: true, loginSelectOptionsPage: true, loginPage: true, welcomePage: false)
                                    
                                    Timer.scheduledTimer(timeInterval: 4.0, target: unwrapSelf, selector: #selector(unwrapSelf.showLoginPage), userInfo: nil, repeats: false)
                                } else {
                                    unwrapSelf.verificationCodeView.becomeFirstResponderAtIndex = -1
                                    unwrapSelf.confirmationCodeview.becomeFirstResponderAtIndex = -1
                                    unwrapSelf.confirmationCodeview.clearPin()
                                    unwrapSelf.verificationCodeView.clearPin()
                                    
                                    
                                    unwrapSelf.showAlert(msg: msg.localiz(), isError: true)
                                }
                            } else if unwrapSelf.apiRequestType == unwrapSelf.VERIFY_PIN {
                                unwrapSelf.enabledButton(btn: unwrapSelf.btnLogin, imgArrow: unwrapSelf.btnLoginArrowImg)
                                let errorCode : String = userStatus.value(forKey: "errorCode") as! String
                                let msg : String = userStatus.value(forKey: "message") as! String
                                
                                if errorCode == "S101"
                                {
                                    /*
                                     //SANKET
                                     var values = [String:Any]()
                                     values["mobileNumber"] = unwrapSelf.tfMobileNumber.text!
                                     values["loginSelectedOption"] = unwrapSelf.loginSelectedOption
                                     UserDefaults.standard.setValue(values, forKey: "loginDetails")
                                     
                                     //SANKET OVER
                                     */
                                    
                                    //SANKET
                                    var values = [String:Any]()
                                    if unwrapSelf.tfMobileNumber.text! == ""
                                    {
                                        values["mobileNumber"] = AppConstants.UserData.cif
                                    }
                                    else
                                    {
                                        values["mobileNumber"] = unwrapSelf.tfMobileNumber.text!
                                    }
                                    
                                    values["loginSelectedOption"] = unwrapSelf.loginSelectedOption
                                    // UserDefaults.standard.setValue(values, forKey: "loginDetails")
                                    
                                    // Add in Keychain
                                    let data = Data(from: "\(values["mobileNumber"] ?? "")")
                                    let status = KeyChain.save(key: "loginDetails", data: data)
                                    print("status: ", status)
                                    
                                    //SANKET OVER
                                    
                                    UserDefaults.standard.removeObject(forKey: "priorityOne")
                                    UserDefaults.standard.removeObject(forKey: "priorityTwo")
                                    UserDefaults.standard.removeObject(forKey: "priorityThree")
                                    UserDefaults.standard.removeObject(forKey: "priorityNo")
                                    UserDefaults.standard.synchronize()
                                    
                                    
                                    unwrapSelf.imgLock.image = UIImage(named: "ic_unlock")
                                    unwrapSelf.getFilterData()
                                    //                                AppConstants.UserData.cif = unwrapSelf.tfMobileNumber.text!
                                    let merchantName  = userStatus.value(forKey: "merchantName")
                                    let isReportsEnabled : String = userStatus.value(forKey: "isReportsEnabled") as! String
                                    let isDashboardEnabled : String = userStatus.value(forKey: "isDashboardEnabled") as! String
                                    let merchantRole = userStatus.value(forKey: "Role")
                                    if merchantRole is NSNull{
                                        AppConstants.UserData.merchantRole = "User"
                                        print("role null")
                                    }else{
                                        AppConstants.UserData.merchantRole = merchantRole as! String
                                        
                                    }
                                    if merchantName is NSNull
                                    {
                                        AppConstants.UserData.name = "User"
                                        print("merchant name null")
                                    }else {
                                        AppConstants.UserData.name = merchantName as! String
                                        
                                    }
                                    AppConstants.UserData.isReportsEnabled = isReportsEnabled
                                    AppConstants.UserData.isDashboardEnabled = isDashboardEnabled
                                    
                                    
                                    
                                }else {
                                    // unwrapSelf.loginPinView.becomeFirstResponderAtIndex = 0
                                    unwrapSelf.loginPinView.clearPin()
                                    unwrapSelf.showAlert(msg: msg.localiz(), isError: true)
                                }
                            }
                        } else {
                            print(status)
                            unwrapSelf.loginPinView.becomeFirstResponderAtIndex = -1
                            unwrapSelf.loginPinView.clearPin()
                            unwrapSelf.showAlert(msg: msg.localiz(), isError: true)
                            unwrapSelf.enabledButton(btn: unwrapSelf.btnNext, imgArrow: unwrapSelf.btnNextArrowImg)
                            unwrapSelf.enabledButton(btn: unwrapSelf.btnLogin, imgArrow: unwrapSelf.btnLoginArrowImg)
                        }
                    }
                    
                    
                    
                    
                }
            }else{
                MBProgressHUD.hide(for: unwrapSelf.view, animated: true)
                unwrapSelf.showAlertWith(message: AlertMessage(title: "Tijarati".localiz(), body: "Sorry, Failed to load data.".localiz()))
            }
        })
    }
    
    
    @IBAction func knowMore(_ sender: Any) {
        errorDialogOuterview.isHidden = true
        
        // below code on 6.oct/2020
        if self.svStep1.isHidden == false {
            
            if self.pinCodeView.isHidden == false {
                
                self.pinCodeView.becomeFirstResponderAtIndex = 0
                self.pinCodeView.clearPin()
            }
            
        } else if self.svStep2.isHidden == false {
            
            self.verificationCodeView.becomeFirstResponderAtIndex = 0
            self.confirmationCodeview.clearPin()
            self.verificationCodeView.clearPin()
            
            
        } else if self.svStep3.isHidden == false {
            
            self.loginPinView.becomeFirstResponderAtIndex = 0
            self.loginPinView.clearPin()
        }
    }
    
    var deviceID : String?
    var isTouchIDEnabled = false
    var isFaceIDEnabled = false
    func authenticateUser()
    {
        AppConstants.UserData.deviceID = deviceID!
        //        AppConstants.UserData.deviceID = "79cc094e0eae027a"
        
        let param : [String : Any] = ["cif" : tfMobileNumber.text!,"deviceId" : deviceID!]
        MBProgressHUD.showAdded(to: self.view, animated: true)
//        self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.authoriseUser)
        self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.authenticateUserV2)
        apiRequestType = AUTH_USER
        self.bindUI()
        
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
    
    func setOTP(){
        let param : [String : Any] = ["cif" : AppConstants.UserData.cif,
                                      "deviceId" : deviceID!,
                                      "otp":pinCodeView.getPin()]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.verifyOTP)
        apiRequestType = OTP_VERIFY
        self.bindUI()
    }
    func resendOTP(){
        let param : [String : Any] = ["cif" : AppConstants.UserData.cif,"deviceId" : deviceID!]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.resendOTP)
        apiRequestType = RESEND_OTP
        self.bindUI()
    }
    var touchId = ""
    var faceId = ""
    
    func setPIN()
    {
        if faceToggle.isOn {
            faceId = "Success"
            facIDView.isHidden = false
        }else{
            facIDView.isHidden = true
        }
        if touchToggle.isOn {
            touchId = "Success"
            touchIDView.isHidden = false
        }else
        {
            touchIDView.isHidden = true
        }
        
        // 21/sep/2020
        if isTouchIDEnabled == true {
            UserDefaults.standard.setValue(true, forKey: "TouchIDSwitch")
        } else {
            UserDefaults.standard.setValue(false, forKey: "TouchIDSwitch")
        }
        
        // 21/sep/2020
        if isFaceIDEnabled == true {
            UserDefaults.standard.setValue(true, forKey: "FaceIDSwitch")
        } else {
            UserDefaults.standard.setValue(false, forKey: "FaceIDSwitch")
        }
        
        
        
        let param : [String : Any] = ["cif" : AppConstants.UserData.cif,
                                      "mPIN" : verificationCodeView.getPin(),
                                      "isTouchIDEnabled":isTouchIDEnabled,
                                      "isFaceIDEnabled":isFaceIDEnabled,
                                      "touchID":touchId,"faceID":faceId,
                                      "deviceId":deviceID!]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.setPIN)
        apiRequestType = SET_PIN
        self.bindUI()
    }
    
    
    func loginUser(){
        deviceID  = UIDevice.current.identifierForVendor!.uuidString
        
        var data = ""
        
        if loginSelectedOption == "mPin" {
            data = loginPinView.getPin()
            
        } else {
            data = "Success"
        }
        
        if UserDefaults.standard.value(forKey: "DeviceToken") != nil {
            
            AppConstants.UserData.deviceToken = UserDefaults.standard.value(forKey: "DeviceToken")! as! String
            
        }else{
            //   self.showAlertWith(message: AlertMessage(title: "Login", body: "Device token not found."))
        }
        disabledButton(btn: btnLogin, imgArrow: btnLoginArrowImg)
        
        let param : [String : Any] = ["cif" :  AppConstants.UserData.cif,
                                      "verify" : loginSelectedOption,
                                      "data":data,
                                      "deviceId":deviceID!,
                                      "appVersion":AppConstants.APP_VERSION,
                                      "fcmToken": AppConstants.UserData.deviceToken ]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.verifyPIN)
        apiRequestType = VERIFY_PIN
        self.bindUI()
    }
    let progressView = MBProgressHUD()
    
    @IBAction func clickNext(_ sender: Any) {
        
        if(btnType == 0)
        {
            
            //     progressBar.isHidden = false
            //     progressView.show(animated: false)
            //     progressBarProviderViewWidth.constant = 50
            authenticateUser()
            disabledButton(btn: btnNext, imgArrow: btnNextArrowImg)
            
            UserDefaults.standard.setValue("Yes", forKey: "isFirstTime")
            
            //remove when api works
            //  let  serviceProviderArr = [serviceProviderList(name: "oredoo", providerImg: "ic_ooredoo"),serviceProviderList(name: "zain", providerImg: "ic_zain"),serviceProviderList(name: "viva", providerImg: "ic_viva")]
            //
            //            let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ServiceProviderViewController") as? ServiceProviderViewController
            //
            //            controller?.delegate = self
            //            controller?.serviceproviderArr = serviceProviderArr
            //            self.presentAsStork(controller!, height: 500.0, cornerRadius: CGFloat.CornerRadius.popup.radius, showIndicator: false, showCloseButton: false, complection: nil)
            
            //remove when api works
        }else if(btnType == 1){
            if(pinCodeView.getPin() != ""){
                disabledButton(btn: btnNext, imgArrow: btnNextArrowImg)
                setOTP()
                
                //remove when api works
                //               stackViewToggles(registerPage: true, enterPinPage: false, loginSelectOptionsPage: true, loginPage: true, welcomePage: true)
                //                btnType = 2
                //remove when api works
            }else{
                showAlertWith(message: AlertMessage(title: "Verify OTP".localiz(), body: "Please enter OTP to continue.".localiz()))
            }
            
        }else if(btnType == 2){
            
            
        }else{
            
            let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
            self.navigationController?.present(controller!, animated: true, completion: nil)
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let bottomOffset = CGPoint(x: 0, y: viewCurved.contentSize.height - viewCurved.bounds.size.height)
        viewCurved.setContentOffset(bottomOffset, animated: true)
        
    }
    
    
    @IBAction func pagerChange(_ sender: Any) {
        
        let page = pageControl.currentPage
        var frame:CGRect = bannerCollectionView.frame
        frame.origin.x = frame.size.width * CGFloat(page)
        frame.origin.y = 0
        bannerCollectionView.scrollRectToVisible(frame, animated: true)
        
    }
    
    // MARK:-
    // MARK: Get error message
    func errorMessage(errorCode:Int) -> String{
        
        var strMessage = ""
        
        switch errorCode {
        case LAError.authenticationFailed.rawValue:
            strMessage = "Authentication Failed".localiz()
            
        case LAError.userCancel.rawValue:
            strMessage = "User Cancel".localiz()
            
        case LAError.userFallback.rawValue:
            strMessage = "User Fallback".localiz()
            
        case LAError.systemCancel.rawValue:
            strMessage = "System Cancel".localiz()
            
        case LAError.passcodeNotSet.rawValue:
            strMessage = "Passcode Not Set".localiz()
        case LAError.biometryNotAvailable.rawValue:
            strMessage = "TouchID Not Available".localiz()
            
        case LAError.biometryNotEnrolled.rawValue:
            strMessage = "TouchID Not Enrolled".localiz()
            
        case LAError.biometryLockout.rawValue:
            strMessage = "TouchID Lockout".localiz()
            
        case LAError.appCancel.rawValue:
            strMessage = "App Cancel".localiz()
            
        case LAError.invalidContext.rawValue:
            strMessage = "Invalid Context".localiz()
            
        default:
            strMessage = "Some error found".localiz()
            
        }
        
        return strMessage
        
    }
    
}
extension UIView{
    func animShow(){
        UIView.animate(withDuration: 2, delay: 0, options: [.curveEaseIn],
                       animations: {
                        self.center.y -= self.bounds.height
                        self.layoutIfNeeded()
        }, completion: nil)
        self.isHidden = false
    }
    func animHide(){
        UIView.animate(withDuration: 2, delay: 0, options: [.curveLinear],
                       animations: {
                        self.center.y += self.bounds.height
                        self.layoutIfNeeded()
                        
        },  completion: {(_ completed: Bool) -> Void in
            self.isHidden = true
        })
    }
    
    
    
}

extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}
extension UINavigationController {
    
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let vc = viewControllers.filter({$0.isKind(of: ofClass)}).last {
            popToViewController(vc, animated: animated)
        }
    }
    
    func popViewControllers(viewsToPop: Int, animated: Bool = true) {
        if viewControllers.count > viewsToPop {
            let vc = viewControllers[viewControllers.count - viewsToPop - 1]
            popToViewController(vc, animated: animated)
        }
    }
    
}
extension String {
    
    var maskEmail: String {
        let email = self
        let components = email.components(separatedBy: "@")
        var maskEmail = ""
        if let first = components.first {
            maskEmail = String(first.enumerated().map { index, char in
                return [0, 1, first.count - 1, first.count - 2].contains(index) ?
                    char : "X"
            })
        }
        if let last = components.last {
            maskEmail = maskEmail + "@" + last
        }
        return maskEmail
    }
    
    
    var maskPhoneNumber: String {
        return String(self.enumerated().map { index, char in
            return [0, 3, self.count - 1, self.count - 2].contains(index) ?
                char : "X"
        })
    }
}
