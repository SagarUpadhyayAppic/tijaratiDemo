//
//  ProfileViewController.swift
//  Burgan
//
//  Created by Malti Maurya on 24/03/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit
import SPStorkController
import IQKeyboardManagerSwift
import LanguageManager_iOS
import LocalAuthentication


protocol AlertDelegate : class{
    func showAlert(msg:String,isError:Bool)
}

protocol profileDelegate : class{
    func selectedLocation(heirarchy : [Hierarchy], companyName: String)
}

protocol LanguageDelegate : class {
    func SelectOnArabicLanguage()
    func SelectOnEnglishLanguage()
}

class ProfileViewController: UIViewController , UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource,AlertDelegate, profileDelegate, LanguageDelegate{
    
    // SANKET 1 jul 2020
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var autoUpdateSwitch: UISwitch!
    // SANKET 1 jul 2020 OVER
    
    
    @IBOutlet weak var lblLanguage: UILabel!
    
    @IBOutlet weak var lblLogout: UILabel!
    @IBOutlet weak var lblAutomaticUpdateStatus: UILabel!
    @IBOutlet weak var lblAutomaticUpdate: UILabel!
    @IBOutlet weak var lblSelectedLanguage: UILabel!
    @IBOutlet weak var lblPinReset: UILabel!
    @IBOutlet weak var lblPushnotiStatus: UILabel!
    @IBOutlet weak var lblPushNotification: UILabel!
    
    @IBOutlet weak var lblTouchIDStatus: UILabel!
    @IBOutlet weak var lblTouchID: UILabel!
    @IBOutlet weak var touchIDSwitch: UISwitch!
    
    @IBOutlet weak var lblFaceIDStatus: UILabel!
    @IBOutlet weak var lblFaceID: UILabel!
    @IBOutlet weak var faceIDSwitch: UISwitch!
    
    var TouchID = "touchID"
    var FaceID = "faceID"
    var GetProfile = "getProfile"
    var apiRequestType = ""
    
    let context = LAContext()
    var error: NSError?
    
    
    func arabic(){
        
        self.searchbar.placeholder = "Search for shop names".localiz()
        
        lblLanguage.text = "Language".localiz()
        lblLogout.text = "Logout".localiz()
        lblAutomaticUpdateStatus.text = lblAutomaticUpdateStatus.text!.localiz()
        lblAutomaticUpdate.text = "Automatic Update".localiz()
        lblTouchID.text = "Touch ID".localiz()
        lblFaceID.text = "Face ID".localiz()
        lblCurrentUser.text = "Current Users".localiz()
        
        if AppConstants.language == .en {
            lblSelectedLanguage.text = "English"
            
            lblUserCount.textAlignment = .left
            lblCurrentUser.textAlignment = .left
            
        } else {
            lblSelectedLanguage.text = "عربي"
            
            lblUserCount.textAlignment = .right
            lblCurrentUser.textAlignment = .right
        }
        lblPushNotification.text = "Push Notifications".localiz()
        lblPinReset.text = "mPIN Reset".localiz()
        lblPushnotiStatus.text =  lblPushnotiStatus.text!.localiz()
    }
    
    
    // SANKET 1 jul 2020
    
    @IBAction func notificationSwitch_Action(_ sender: Any)
    {
        print(notificationSwitch.isOn)
        if notificationSwitch.isOn == true
        {
            lblPushnotiStatus.text = "Enabled".localiz()
            notificationSwitch.setOn(true, animated: true)
            UserDefaults.standard.setValue(true, forKey: "NotificationSwitch")
        }
        else
        {
            lblPushnotiStatus.text = "Disabled".localiz()
            notificationSwitch.setOn(false, animated: true)
            UserDefaults.standard.setValue(false, forKey: "NotificationSwitch")
            
        }
    }
    
    @IBAction func autoUpdateSwitch_Action(_ sender: Any)
    {
        print(autoUpdateSwitch.isOn)
        if autoUpdateSwitch.isOn == true
        {
            lblAutomaticUpdateStatus.text = "Enabled".localiz()
            autoUpdateSwitch.setOn(true, animated: true)
            UserDefaults.standard.setValue(true, forKey: "AutoUpdateSwitch")
        }
        else
        {
            lblAutomaticUpdateStatus.text = "Disabled".localiz()
            autoUpdateSwitch.setOn(false, animated: true)
            UserDefaults.standard.setValue(false, forKey: "AutoUpdateSwitch")
            
        }
        
    }
    
    // SANKET 1 jul 2020 OVER
    
    
    @IBAction func TouchID_Switch_Tapped(_ sender: UISwitch) {
        
        if touchIDSwitch.isOn == true {
            lblTouchIDStatus.text = "Enabled".localiz()
            touchIDSwitch.setOn(true, animated: true)
            UserDefaults.standard.setValue(true, forKey: "TouchIDSwitch")
            
            let param : [String : Any] = ["cif" : AppConstants.UserData.cif,
                                          "deviceId" : AppConstants.UserData.deviceID,
                                          "type" : "touchID",
                                          "status" : "true",
                                          "touchID" : "Success"]
            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.biometricUpdate)
            apiRequestType = TouchID
            self.bindUI()
            
        } else {
            
            lblTouchIDStatus.text = "Disabled".localiz()
            touchIDSwitch.setOn(false, animated: true)
            UserDefaults.standard.setValue(false, forKey: "TouchIDSwitch")
            
            let param : [String : Any] = ["cif" : AppConstants.UserData.cif,
                                          "deviceId" : AppConstants.UserData.deviceID,
                                          "type" : "touchID",
                                          "status" : "false",
                                          "touchID" : "Success"]
            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.biometricUpdate)
            apiRequestType = TouchID
            self.bindUI()
        }
    }
    
    @IBAction func FaceID_Switch_Tapped(_ sender: UISwitch) {
        
        if faceIDSwitch.isOn == true {
            lblFaceIDStatus.text = "Enabled".localiz()
            faceIDSwitch.setOn(true, animated: true)
            UserDefaults.standard.setValue(true, forKey: "FaceIDSwitch")
            
            let param : [String : Any] = ["cif" : AppConstants.UserData.cif,
                                          "deviceId" : AppConstants.UserData.deviceID,
                                          "type" : "faceID",
                                          "status" : "true",
                                          "faceID" : "Success"]
            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.biometricUpdate)
            apiRequestType = FaceID
            self.bindUI()
            
        } else {
            
            lblFaceIDStatus.text = "Disabled".localiz()
            faceIDSwitch.setOn(false, animated: true)
            UserDefaults.standard.setValue(false, forKey: "FaceIDSwitch")
            
            let param : [String : Any] = ["cif" : AppConstants.UserData.cif,
                                          "deviceId" : AppConstants.UserData.deviceID,
                                          "type" : "faceID",
                                          "status" : "false",
                                          "faceID" : "Success"]
            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.biometricUpdate)
            apiRequestType = FaceID
            self.bindUI()
        }
    }
    
    func BiometricAuthentication() {
        
        self.touchIDCurvedView.isHidden = true
        self.faceIDCurvedView.isHidden = true
        
        if context.canEvaluatePolicy(
            LAPolicy.deviceOwnerAuthenticationWithBiometrics,
            error: &error) {
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                switch context.biometryType {
                case .faceID:
                    self.faceIDCurvedView.isHidden = false
                    
                    break
                case .touchID:
                    self.touchIDCurvedView.isHidden = false
                    break
                case .none:
                    print("none")
                    
                    break
                }
            } else {
                
                // Device cannot use biometric authentication
                
                //                if let err = error {
                //                    let strMessage = self.errorMessage(errorCode: err._code)
                //                    self.showAlertWith(message: AlertMessage(title: "Authentication".localiz(), body: strMessage))
                //                }
            }
        } else {
            //            if let err = error {
            //                let strMessage = self.errorMessage(errorCode: err._code)
            //                self.showAlertWith(message: AlertMessage(title: "Authentication".localiz(), body: strMessage))
            //            }
        }
    }
    
    
    
    func selectedLocation(heirarchy: [Hierarchy], companyName: String) {
        
        self.lblCompanyName.text = companyName
        
        var selectedLocations : [LocationNameList] = []
        selectedLocations.removeAll()
        self.mergeLocations.removeAll()
        
        for i in 0..<heirarchy.count
        {
            for k in 0..<heirarchy[i].brandNameList.count
            {
                for j in 0..<heirarchy[i].brandNameList[k].locationNameList.count
                {
                    
                    selectedLocations.append(heirarchy[i].brandNameList[k].locationNameList[j])
                }
            }
        }
        
        
        // Take all location name from selectedLocation Array
        var mySelectedLocation : [String] = []
        
        for obj in selectedLocations {
            
            mySelectedLocation.append(obj.locationName)
        }
        
        // Now remove duplicates from mySelectedLocation
        
        let distinctLocation = Array(Set(mySelectedLocation))
        
        // merge All Tid of distinct Location from selectedLocations array
        
        for locationName in distinctLocation {
            
            //            var mergeObj = MergeLocation(locationName: <#String#>, outletNumber: <#[String]#>)
            //mergeObj?.locationName = locationName
            
            var tempStrAry : [String] = []
            
            
            for obj in selectedLocations {
                
                if locationName == obj.locationName {
                    
                    for i in 0..<obj.merchantNumber.count {
                        
                        tempStrAry = tempStrAry + obj.merchantNumber[i].outletNumber
                    }
                    
                    //mergeObj?.outletNumber = tempStrAry
                }
            }
            
            //self.mergeLocations.append(mergeObj!)
            self.mergeLocations.append(MergeLocation(locationName: locationName, outletNumber: tempStrAry))
        }
        
        print(self.mergeLocations)
        let tempAry = mergeLocations.sorted(by: { $0.locationName < $1.locationName })
        self.mergeLocations.removeAll()
        self.mergeLocations = tempAry
        
        
        
        //        tbComapnyHeight.constant = CGFloat(selectedLocations.count * 100)
        tbComapnyHeight.constant = CGFloat(mergeLocations.count * 70)
        print("Counter & Constant Size : \(CGFloat(mergeLocations.count * 70))")
        tbCompanyLocationList.reloadData()
        let param : [String : Any] = ["cif" : AppConstants.UserData.cif,
                                      "deviceId" : AppConstants.UserData.deviceID]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.getProfile)
        apiRequestType = GetProfile
        self.bindUI()
        
    }
    
    
    //    var selectedLocations : [LocationNameList] = []
    var searchActive : Bool = false
    //    var filteredLocatnArr : [LocationNameList] = []
    var mergeLocations : [MergeLocation] = []
    var filteredLocatnArr : [MergeLocation] = []
    
    @IBOutlet weak var currentUserView: UIView!
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var tbComapnyHeight: NSLayoutConstraint!
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var searchbarView: UIView!
    @IBOutlet weak var companyInfoView: UIView!
    @IBOutlet weak var settingsScrollview: UIScrollView!
    
    @IBOutlet weak var lblAppVersion: UILabel!
    @IBOutlet weak var lblEmailID: UILabel!
    @IBOutlet weak var lblMobileNo: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var btnAccount: UIButton!
    @IBOutlet weak var logoutCurvedView: UIView!
    @IBOutlet weak var updatesCurvedView: UIView!
    @IBOutlet weak var touchIDCurvedView: UIView!
    @IBOutlet weak var faceIDCurvedView: UIView!
    @IBOutlet weak var languageCurvedView: UIView!
    @IBOutlet weak var pinResetCurvedView: UIView!
    @IBOutlet weak var notificationsCurvedView: UIView!
    @IBOutlet weak var accountScrollview: UIScrollView!
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var alertCurvedView: UIView!
    
    
    @IBAction func selectSettings(_ sender: Any) {
        accountScrollview.isHidden = true
        settingsScrollview.isHidden = false
        btnSetting.setTitleColor(UIColor.BurganColor.brandBlue.dark, for: .normal)
        btnAccount.setTitleColor(UIColor.BurganColor.brandGray.medium, for: .normal)
    }
    
    @IBAction func closeAlertView(_ sender: Any) {
        self.alertView.isHidden = true
    }
    
    @IBAction func logout(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Confirmation".localiz(), message: "Are you sure you want to Logout ?".localiz(), preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel".localiz(), style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        let ok = UIAlertAction(title: "Ok".localiz(), style: .default) { (action) in
            
            /*
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
             //            LanguageManager.shared.defaultLanguage = AppConstants.language
             //            LanguageManager.shared.setLanguage(language: AppConstants.language)
             
             UserDefaults.standard.synchronize()
             
             AppConstants.jsonStartDate = ""
             AppConstants.jsonEndDate = ""
             */
            
            let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegistrationViewController") as! RegistrationViewController
            
            // rootVC.showLoginScreen = false
            rootVC.showLoginScreen = true
            self.navigationController?.pushViewController(rootVC, animated: true)
            
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(cancel)
        alertController.addAction(ok)
        self.present(alertController, animated: true, completion: nil)
        
        
        /*
         let restoreDeviceToken = UserDefaults.standard.value(forKey: "DeviceToken") as! String
         //        let appDomain = Bundle.main.bundleIdentifier
         //        UserDefaults.standard.removePersistentDomain(forName: appDomain!)
         
         UserDefaults.standard.removeObject(forKey: "priorityOne")
         UserDefaults.standard.removeObject(forKey: "priorityTwo")
         UserDefaults.standard.removeObject(forKey: "priorityThree")
         UserDefaults.standard.removeObject(forKey: "priorityNo")
         
         UserDefaults.standard.removeObject(forKey: "loginDetails")
         
         UserDefaults.standard.removeObject(forKey: "AutoUpdateSwitch")
         UserDefaults.standard.removeObject(forKey: "NotificationSwitch")
         
         UserDefaults.standard.synchronize()
         
         
         UserDefaults.standard.setValue(restoreDeviceToken, forKey: "DeviceToken")
         LanguageManager.shared.defaultLanguage = AppConstants.language
         
         UserDefaults.standard.synchronize()
         
         AppConstants.jsonStartDate = ""
         AppConstants.jsonEndDate = ""
         
         // By Malti
         /*
         let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegistrationViewController") as! RegistrationViewController
         //        UserDefaults.standard.removeObject(forKey: "priorityOne")
         //        UserDefaults.standard.removeObject(forKey: "priorityTwo")
         //        UserDefaults.standard.removeObject(forKey: "priorityThree")
         //        UserDefaults.standard.removeObject(forKey: "priorityNo")
         //        UserDefaults.standard.synchronize()
         
         rootVC.showLoginScreen = false
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
         appDelegate.window?.rootViewController = rootVC
         */
         
         let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegistrationViewController") as! RegistrationViewController
         
         rootVC.showLoginScreen = false
         self.navigationController?.pushViewController(rootVC, animated: true)
         */
    }
    
    @IBAction func selectAccount(_ sender: Any) {
        accountScrollview.isHidden = false
        settingsScrollview.isHidden = true
        btnSetting.setTitleColor(UIColor.BurganColor.brandGray.medium, for: .normal)
        btnAccount.setTitleColor(UIColor.BurganColor.brandBlue.dark, for: .normal)
        
    }
    func createTapGuesture(){
        
        let selectCompanyTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        companyInfoView.addGestureRecognizer(selectCompanyTap)
        
        let tapResetPIN = UITapGestureRecognizer(target: self, action: #selector(self.resetPIN))
        pinResetCurvedView.isUserInteractionEnabled = true; self.pinResetCurvedView.addGestureRecognizer(tapResetPIN)
        
        let changeLanguage = UITapGestureRecognizer(target: self, action: #selector(self.ChangeLanguage))
        languageCurvedView.isUserInteractionEnabled = true; self.languageCurvedView.addGestureRecognizer(changeLanguage)
        
    }
    
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        
        searchBar.text = nil
        searchBar.resignFirstResponder()
        tbCompanyLocationList.resignFirstResponder()
        self.searchbar.showsCancelButton = false
        tbCompanyLocationList.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchActive = true;
        self.searchbar.showsCancelButton = true
        
        filteredLocatnArr.removeAll()
        guard !searchText.isEmpty  else { filteredLocatnArr = mergeLocations; return }
        
        filteredLocatnArr = mergeLocations.filter{
            $0.locationName.lowercased().contains(searchText.lowercased())
        }
        tbCompanyLocationList.reloadData()
        
    }
    
    @objc func resetPIN(sender: UITapGestureRecognizer)
    {
        let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProfilePopupsViewController") as? ProfilePopupsViewController
        controller?.popupType = 6
        controller?.alertDelegate = self
        presentAsStork(controller!, height: 600, cornerRadius: 8, showIndicator: false, showCloseButton: false)
    }
    
    @objc func ChangeLanguage(sender: UITapGestureRecognizer)
    {
        let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProfilePopupsViewController") as? ProfilePopupsViewController
        controller?.popupType = 5
        controller?.alertDelegate = self
        controller?.languageDelegate = self
        presentAsStork(controller!, height: 300, cornerRadius: 8, showIndicator: false, showCloseButton: false)
    }
    
    func SelectOnArabicLanguage() {
        
        // change the language
        LanguageManager.shared.setLanguage(language: .ar)
        
        let controller = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RootViewController") as? RootViewController)!
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    func SelectOnEnglishLanguage() {
        
        // change the language
        LanguageManager.shared.setLanguage(language: .en)
        
        let controller = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RootViewController") as? RootViewController)!
        self.navigationController?.pushViewController(controller, animated: true)
        
        /*
         self.navigationController?.popToViewController(ofClass: RootViewController.self, animated: true)
         
         LanguageManager.shared.setLanguage(language: .en, viewControllerFactory: { title -> UIViewController in
         
         //            let storyboard = UIStoryboard(name: "Main", bundle: nil)
         //            return storyboard.instantiateViewController(identifier: "RootViewController")
         
         let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
         let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RootViewController") as! RootViewController
         let navigationController = UINavigationController(rootViewController: nextViewController)
         //let appdelegate = UIApplication.shared.delegate as! AppDelegate
         //appdelegate.window!.rootViewController = navigationController
         
         
         return navigationController
         
         }) { view in
         // do custom animation
         view.transform = CGAffineTransform(scaleX: 2, y: 2)
         view.alpha = 0
         }
         */
        
    }
    
    
    @IBOutlet weak var alertCurvedViewHeight: NSLayoutConstraint!
    
    func showAlert(msg: String, isError: Bool) {
        alertView.isHidden = false
        lblAlertDescptn.text = msg
        if isError{
            alertErrorImg.isHidden = false
            btnKNowMore.setTitle("OK".localiz(), for: .normal)
            alertCurvedViewHeight.constant = 350
            
        }else{
            alertErrorImg.isHidden = true
            btnKNowMore.setTitle("OK".localiz(), for: .normal)
            alertCurvedViewHeight.constant = 250
            
        }
    }
    
    
    @IBOutlet weak var tbCompanyLocationList: UITableView!
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    @IBAction func currentUsers(_ sender: Any) {
        
        let controller = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "UserListViewController") as? UserListViewController)!
        self.navigationController?.pushViewController(controller, animated: true)
        
        
    }
    
    @IBAction func openSideMenu(_ sender: Any) {
        //        self.sideMenuViewController.presentLeftMenuViewController()
        
        if AppConstants.language == .ar {
            self.sideMenuViewController.presentRightMenuViewController()
        } else {
            self.sideMenuViewController.presentLeftMenuViewController()
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
         let controller = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RootViewController") as? RootViewController)!
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBOutlet weak var btnKNowMore: GradientLayer!
    @IBAction func knowMore(_ sender: Any) {
        self.alertView.isHidden = true
    }
    @IBOutlet weak var lblAlertDescptn: UILabel!
    @IBOutlet weak var alertErrorImg: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        self.lblAppVersion.text = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        
        self.loopThroughSubViewAndAlignTextfieldText(subviews: self.view.subviews)
        self.loopThroughSubViewAndAlignLabelText(subviews: self.view.subviews)
        self.loopThroughSubViewAndMirrorImage(subviews: self.view.subviews)
        // SANKET 1 jul 2020
        
        lblAutomaticUpdateStatus.text = "Disabled".localiz()
        lblPushnotiStatus.text = "Disabled".localiz()
        
        notificationSwitch.isOn = false
        autoUpdateSwitch.isOn = false
        
        if UserDefaults.standard.value(forKey: "AutoUpdateSwitch") != nil
        {
            let switchState = UserDefaults.standard.value(forKey: "AutoUpdateSwitch") as! Bool
            print(switchState)
            
            if switchState == true
            {
                lblAutomaticUpdateStatus.text = "Enabled".localiz()
                autoUpdateSwitch.setOn(true, animated: true)
            }
            else
            {
                lblAutomaticUpdateStatus.text = "Disabled".localiz()
                autoUpdateSwitch.setOn(false, animated: true)
            }
            
        }
        
        if UserDefaults.standard.value(forKey: "NotificationSwitch") != nil
        {
            let switchState = UserDefaults.standard.value(forKey: "NotificationSwitch") as! Bool
            print(switchState)
            if switchState == true
            {
                lblPushnotiStatus.text = "Enabled".localiz()
                notificationSwitch.setOn(true, animated: true)
            }
            else
            {
                lblPushnotiStatus.text = "Disabled".localiz()
                notificationSwitch.setOn(false, animated: true)
            }
        }
        
        
        if UserDefaults.standard.value(forKey: "TouchIDSwitch") != nil {
            let switchState = UserDefaults.standard.value(forKey: "TouchIDSwitch") as! Bool
            print(switchState)
            if switchState == true {
                lblTouchIDStatus.text = "Enabled".localiz()
                touchIDSwitch.setOn(true, animated: true)
            } else {
                lblTouchIDStatus.text = "Disabled".localiz()
                touchIDSwitch.setOn(false, animated: true)
            }
        }
        
        
        if UserDefaults.standard.value(forKey: "FaceIDSwitch") != nil {
            let switchState = UserDefaults.standard.value(forKey: "FaceIDSwitch") as! Bool
            print(switchState)
            if switchState == true {
                lblFaceIDStatus.text = "Enabled".localiz()
                faceIDSwitch.setOn(true, animated: true)
            } else {
                lblFaceIDStatus.text = "Disabled".localiz()
                faceIDSwitch.setOn(false, animated: true)
            }
        }
        
        // Set FaceID and TouchID
        BiometricAuthentication()
        
        // Set Arabic 
        arabic()
        
        if AppConstants.language == .ar {
            searchbar.semanticContentAttribute = .forceRightToLeft
        } else {
            searchbar.semanticContentAttribute = .forceLeftToRight
        }
        
        // SANKET 1 jul 2020 OVER
        
        curvedviewShadow(view: currentUserView)
        curvedviewShadow(view: searchbarView)
        curvedviewShadow(view: companyInfoView)
        curvedviewShadow(view: tabBarView)
        curvedviewShadow(view: notificationsCurvedView)
        curvedviewShadow(view: pinResetCurvedView)
        curvedviewShadow(view: languageCurvedView)
        curvedviewShadow(view: updatesCurvedView)
        curvedviewShadow(view: touchIDCurvedView)
        curvedviewShadow(view: faceIDCurvedView)
        curvedviewShadow(view: logoutCurvedView)
        lblCompanyName.text = "--"
        lblMobileNo.text = "--"
        lblEmailID.text = "--"
        lblUserCount.text = "0"
        searchbar.barTintColor = UIColor.clear
        searchbar.backgroundColor = UIColor.clear
        searchbar.isTranslucent = true
        searchbar.delegate  = self
        
        searchbar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBarDelegates()
        if #available(iOS 13, *) {
            searchbar.searchTextField.font = UIFont(name: UIFont.Frutiger.light.rawValue, size: 15.0)
            self.searchbar.searchTextField.backgroundColor = .clear
        } else {
            // show sad face emoji
        }
        
        alertView.isHidden = true
        alertCurvedView.layer.cornerRadius = CGFloat.CornerRadius.popup.radius
        btnKNowMore.layer.cornerRadius = CGFloat.CornerRadius.button.radius
        popupShadow(view: alertCurvedView)
        self.selectedLocation(heirarchy: (AppConstants.selectedFilter?.selectedHeirarchy)!, companyName: AppConstants.selectedFilter?.companyName ?? "")
        
        createTapGuesture()
        
        self.viewModel = RegistrationViewControllerViewModel()
        //        let param : [String : Any] = ["cif" : AppConstants.UserData.cif,
        //                                            "deviceId" : AppConstants.UserData.deviceID]
        //         MBProgressHUD.showAdded(to: self.view, animated: true)
        //        self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.getProfile)
        //        self.bindUI()
        
        if AppConstants.UserData.merchantRole == "Admin" {
            self.currentUserView.isHidden = false
        } else {
            self.currentUserView.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchBarDelegates()
        
        self.viewModel = RegistrationViewControllerViewModel()
        let param : [String : Any] = ["cif" : AppConstants.UserData.cif,
                                      "deviceId" : AppConstants.UserData.deviceID]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.getProfile)
        apiRequestType = GetProfile
        self.bindUI()
    }
    
    private func searchBarDelegates(){
        configureSearchBarTextField()
        searchbar.backgroundColor = UIColor.clear
    }
    
    
    var viewModel : RegistrationViewControllerViewModelProtocol?
    func decodeResult<T: Decodable>(model: T.Type, result: NSDictionary) -> (model: T?, error: Error?) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
            let modelObject = try JSONDecoder().decode(model.self, from: jsonData)
            return (modelObject, nil)
        } catch let error {
            return (nil, error)
        }
    }
    @IBOutlet weak var lblUserCount: UILabel!
    @IBOutlet weak var lblCurrentUser: UILabel!
    private func bindUI() {
        
        self.viewModel?.alertMessage.bind({ [weak self] in
            MBProgressHUD.hide(for: self!.view, animated: true)
            self?.showAlertDismissOnly(message: $0)
        })
        
        
        
        self.viewModel?.response.bind({ [weak self] in
            
            if let response = $0 {
                MBProgressHUD.hide(for: self!.view, animated: true)
                do{
                    
                    
                    let userStatus = DataDecryption().decryption(jsonModel: PayloadRes(iv: response.iv, payload: response.payload))
                    
                    if userStatus != nil {
                        
                        MBProgressHUD.hide(for: self!.view, animated: true)
                        
                        let status : String = userStatus?.value(forKey: "status") as? String ?? ""
                        let message : String = userStatus?.value(forKey: "message") as? String ?? ""
                        
                        
                        if status == "" || message == "" {
                            
                            if self?.apiRequestType == self?.TouchID {
                                if self?.touchIDSwitch.isOn == true {
                                    
                                    let param : [String : Any] = ["cif" : AppConstants.UserData.cif,
                                                                  "deviceId" : AppConstants.UserData.deviceID,
                                                                  "type" : "touchID",
                                                                  "status" : "true",
                                                                  "touchID" : "Success"]
                                    MBProgressHUD.showAdded(to: self!.view, animated: true)
                                    self?.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.biometricUpdate)
                                    self?.apiRequestType = self!.TouchID
                                    self?.bindUI()
                                    
                                } else {
                                    
                                    let param : [String : Any] = ["cif" : AppConstants.UserData.cif,
                                                                  "deviceId" : AppConstants.UserData.deviceID,
                                                                  "type" : "touchID",
                                                                  "status" : "false",
                                                                  "touchID" : "Success"]
                                    MBProgressHUD.showAdded(to: self!.view, animated: true)
                                    self?.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.biometricUpdate)
                                    self?.apiRequestType = self!.TouchID
                                    self?.bindUI()
                                }
                            } else if self?.apiRequestType == self?.FaceID {
                                
                                if self?.faceIDSwitch.isOn == true {
                                    
                                    let param : [String : Any] = ["cif" : AppConstants.UserData.cif,
                                                                  "deviceId" : AppConstants.UserData.deviceID,
                                                                  "type" : "faceID",
                                                                  "status" : "true",
                                                                  "faceID" : "Success"]
                                    MBProgressHUD.showAdded(to: self!.view, animated: true)
                                    self?.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.biometricUpdate)
                                    self?.apiRequestType = self!.FaceID
                                    self?.bindUI()
                                    
                                } else {
                                    
                                    let param : [String : Any] = ["cif" : AppConstants.UserData.cif,
                                                                  "deviceId" : AppConstants.UserData.deviceID,
                                                                  "type" : "faceID",
                                                                  "status" : "false",
                                                                  "faceID" : "Success"]
                                    MBProgressHUD.showAdded(to: self!.view, animated: true)
                                    self?.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.biometricUpdate)
                                    self?.apiRequestType = self!.FaceID
                                    self?.bindUI()
                                }
                            } else {
                                
                                let param : [String : Any] = ["cif" : AppConstants.UserData.cif,
                                                              "deviceId" : AppConstants.UserData.deviceID]
                                MBProgressHUD.showAdded(to: self!.view, animated: true)
                                self!.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.getProfile)
                                self?.apiRequestType = self!.GetProfile
                                self!.bindUI()
                                
                            }
                            
                        } else {
                            
                            let message : String = userStatus?.value(forKey: "message") as! String
                            let status : String = userStatus?.value(forKey: "status") as! String
                            if status == "Success"{
                                
                                if self?.apiRequestType == self?.TouchID {
                                    //{"status":"Success","message":"Success","errorCode":"S101"}
                                    let errorCode : String = userStatus?.value(forKey: "errorCode") as! String
                                    if errorCode == "S101" {
                                        
                                    } else {
                                        
                                        if self?.touchIDSwitch.isOn == true {
                                            self?.lblTouchIDStatus.text = "Disabled".localiz()
                                            self?.touchIDSwitch.setOn(false, animated: true)
                                            UserDefaults.standard.setValue(false, forKey: "TouchIDSwitch")
                                        } else {
                                            self?.lblTouchIDStatus.text = "Enabled".localiz()
                                            self?.touchIDSwitch.setOn(true, animated: true)
                                            UserDefaults.standard.setValue(true, forKey: "TouchIDSwitch")
                                        }
                                        
                                        self!.showAlertWith(message: AlertMessage(title: "TouchID".localiz(), body: message.localiz()))
                                    }
                                } else if self?.apiRequestType == self?.FaceID {
                                    let errorCode : String = userStatus?.value(forKey: "errorCode") as! String
                                    if errorCode == "S101" {
                                        
                                    } else {
                                        
                                        if self?.faceIDSwitch.isOn == true {
                                            self?.lblFaceIDStatus.text = "Disabled".localiz()
                                            self?.faceIDSwitch.setOn(false, animated: true)
                                            UserDefaults.standard.setValue(false, forKey: "FaceIDSwitch")
                                        } else {
                                            self?.lblFaceIDStatus.text = "Enabled".localiz()
                                            self?.faceIDSwitch.setOn(true, animated: true)
                                            UserDefaults.standard.setValue(true, forKey: "FaceIDSwitch")
                                        }
                                        
                                        self!.showAlertWith(message: AlertMessage(title: "FaceID".localiz(), body: message.localiz()))
                                    }
                                } else {
                                    
                                    let errorCode : String = userStatus?.value(forKey: "errorCode") as! String
                                    if errorCode == "L128"{
                                        //                                  print(message)
                                        let object = self!.decodeResult(model: profileResp.self, result: userStatus!)
                                        let profile = object.model
                                        
                                        // self!.lblCompanyName.text = profile?.companyName
                                        //                                self!.lblMobileNo.text = profile?.mobileNum.maskPhoneNumber
                                        
                                        let string = (profile?.mobileNum ?? "") as String
                                        let characters = Array(string)
                                        print(characters)
                                        var tempAry = [Character]()
                                        
                                        for i in 0..<characters.count {
                                            
                                            if i >= characters.count - 4 {
                                                tempAry.append(characters[i])
                                            } else {
                                                tempAry.append("X")
                                            }
                                        }
                                        let str = String(tempAry)
                                        self!.lblMobileNo.text = str
                                        //mak over
                                        
                                        if profile?.emailID == nil || profile?.emailID == "NONE" || profile?.emailID == ""
                                        {
                                            self!.lblEmailID.text = "N/A"
                                        }else
                                        {
                                            self!.lblEmailID.text = profile?.emailID.maskEmail
                                        }
                                        
                                        self!.userCount = profile?.userCount ?? "0"
                                        self!.lblUserCount.text = self!.userCount
                                    }else{
                                        self!.showAlertWith(message: AlertMessage(title: "Profile".localiz(), body: message.localiz()))
                                    }
                                }
                                
                                
                                
                            }else{
                                self!.showAlertWith(message: AlertMessage(title: "Profile".localiz(), body: message.localiz()))
                            }
                        }
                    }
                }
            }
            
        })
        
    }
    var userCount = "2"
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if AppConstants.selectedFilter != nil {
            let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProfilePopupsViewController") as? ProfilePopupsViewController
            controller?.popupType = 0
            controller?.profileDelegate = self
            let heightConstant : CGFloat =  CGFloat(120 + AppConstants.locationFilterData!.filterData.count * 100)
            presentAsStork(controller!, height: heightConstant, cornerRadius: 10, showIndicator: false, showCloseButton: false)
        }else{
            showAlertWith(message: AlertMessage(title: "Tijarati".localiz(), body: "Sorry, data not available."))
        }
    }
    
    func popupShadow(view:UIView){
        view.layer.shadowColor = UIColor.BurganColor.brandGray.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        view.layer.shadowOpacity = 1.0
        view.layer.shadowRadius = 10.0
        view.layer.masksToBounds = false
    }
    
    
    func curvedviewShadow(view:UIView){
        
        view.layer.cornerRadius = 8
        view.layer.shadowOpacity = 0.35
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowRadius = 3.0
        view.layer.shadowColor = UIColor.BurganColor.brandGray.lgiht.cgColor
        view.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner,.layerMaxXMinYCorner]
    }
    
    func configureSearchBarTextField() {
        for subView in searchbar.subviews  {
            for subsubView in subView.subviews  {
                if let textField = subsubView as? UITextField {
                    var bounds: CGRect
                    bounds = textField.frame
                    bounds.size.height = 35 //(set height whatever you want)
                    textField.bounds = bounds
                    textField.layer.cornerRadius = 5
                    textField.layer.borderWidth = 1.0
                    textField.layer.borderColor = UIColor.BurganColor.brandBlue.light.cgColor //UIColor(red:0.00, green:0.87, blue:0.39, alpha:1.0).cgColor
                    textField.backgroundColor = UIColor.white
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filteredLocatnArr.count
        }else{
            return mergeLocations.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TbProfileLocationListCell", for: indexPath) as! TbProfileLocationListCell
        
        curvedviewShadow(view: cell.curvedView)
        if searchActive {
            cell.lblName.text = filteredLocatnArr[indexPath.row].locationName
            cell.lblMIDCount.text = String(filteredLocatnArr[indexPath.row].outletNumber.count) + " " + "TIDs".localiz()
        }else{
            cell.lblName.text = mergeLocations[indexPath.row].locationName
            cell.lblMIDCount.text = String(mergeLocations[indexPath.row].outletNumber.count) + " " + "TIDs".localiz()
        }
        if AppConstants.language == .ar{
            cell.lblName.textAlignment = NSTextAlignment.right
            cell.lblMIDCount.textAlignment = .left
        }else{
            cell.lblName.textAlignment = NSTextAlignment.left
            cell.lblMIDCount.textAlignment = .right
        }
        
        cell.ivArrow?.transform = AppConstants.language == .ar ? CGAffineTransform(scaleX: -1, y: 1) : CGAffineTransform(scaleX: 1, y: 1)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProfilePopupsViewController") as? ProfilePopupsViewController)!
        controller.merchant = mergeLocations[indexPath.row].outletNumber
        controller.popupType = 3
        let height : CGFloat = CGFloat(100 + mergeLocations[indexPath.row].outletNumber.count * 90)
        presentAsStork(controller, height: height, cornerRadius: 8.0, showIndicator: false, showCloseButton: false)
    }
    
    
}


// MARK: -
struct MergeLocation {
    var locationName: String
    var outletNumber: [String]
}

