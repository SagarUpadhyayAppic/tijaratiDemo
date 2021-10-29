//
//  NavigationDrawerViewController.swift
//  Burgan
//
//  Created by Malti Maurya on 27/03/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit
import BubbleTransition
import SPStorkController
import IQKeyboardManagerSwift
import LanguageManager_iOS


protocol reportsDelegate : class {
    func goToReports()
}

class NavigationDrawerViewController: UIViewController, RESideMenuDelegate, UIViewControllerTransitioningDelegate, reportsDelegate {
    
    @IBOutlet weak var btnTransition: UIButton!
    @IBOutlet weak var ivUserImage: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
        
    let transition = BubbleTransition()
    let interactiveTransition = BubbleInteractiveTransition()
    
    var isBubbleView = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loopThroughSubViewAndAlignLabelText(subviews: self.view.subviews)
        self.loopThroughSubViewAndMirrorImage(subviews: self.view.subviews)
        
        isBubbleView = true
        lblUserName.text = AppConstants.UserData.name
    }
    
    //
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //       if let controller = segue.destination as? ReportBubbleViewController {
    //         controller.transitioningDelegate = self
    //         controller.modalPresentationStyle = .custom
    //         controller.modalPresentationCapturesStatusBarAppearance = true
    //         controller.interactiveTransition = interactiveTransition
    //         interactiveTransition.attach(to: controller)
    //       }
    //     }
    //
    // MARK: UIViewControllerTransitioningDelegate
    
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = btnTransition.center
        transition.bubbleColor = UIColor.clear
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = btnTransition.center
        transition.bubbleColor = UIColor.clear
        return transition
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition
    }
    
    @IBAction func showReports(_ sender: Any) {
        isBubbleView = false
        if(isBubbleView) {
            isBubbleView = false
            
            let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ReportBubbleViewController") as? ReportBubbleViewController
            controller!.transitioningDelegate = self
            controller!.modalPresentationStyle = .custom
            controller?.delegate = self;
            if AppConstants.UserData.isReportsEnabled == "1"
            {
                controller?.reportType = 1
            }else{
                controller?.reportType = 2
            }
            
            controller!.modalPresentationCapturesStatusBarAppearance = true
            controller!.interactiveTransition = interactiveTransition
            interactiveTransition.attach(to: controller!)
            //  self.navigationController?.pushViewController(controller!, animated: true)
            self.present(controller!, animated: true, completion: nil)
        } else {
            let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ReportListViewController") as? ReportListViewController
            self.navigationController?.pushViewController(controller!, animated: true)
            
        }
    }
    
    func goToReports() {
        let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ReportListViewController") as? ReportListViewController
        self.navigationController?.pushViewController(controller!, animated: true)
    }
    
    @IBAction func profileButtonTapped(_ sender: UIButton) {
        let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func showServices(_ sender: Any) {
        let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ServicePopUpViewController") as? ServicePopUpViewController
        presentAsStork(controller!, height: 300, cornerRadius: 8, showIndicator: false, showCloseButton: false)
    }
    
    @IBAction func TandC(_ sender: Any) {
        
        let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "T_CViewController") as? T_CViewController
        controller?.isFrom = "menu"
        controller?.modalPresentationStyle = .overCurrentContext // .fullScreen
        self.present(controller!, animated: true, completion: nil)
        //self.navigationController?.pushViewController(controller!, animated: true)
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
             
             // UserDefaults.standard.removeObject(forKey: "loginDetails")
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
         let restoreDeviceToken = UserDefaults.standard.value(forKey: "DeviceToken") as? String ?? ""
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
         //        LanguageManager.shared.defaultLanguage = .en
         LanguageManager.shared.defaultLanguage = AppConstants.language
         UserDefaults.standard.synchronize()
         
         AppConstants.jsonStartDate = ""
         AppConstants.jsonEndDate = ""
         
         let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegistrationViewController") as! RegistrationViewController
         
         rootVC.showLoginScreen = false
         self.navigationController?.pushViewController(rootVC, animated: true)
         //        UserDefaults.standard.removeObject(forKey: "priorityOne")
         //        UserDefaults.standard.removeObject(forKey: "priorityTwo")
         //        UserDefaults.standard.removeObject(forKey: "priorityThree")
         //        UserDefaults.standard.removeObject(forKey: "priorityNo")
         //
         //        UserDefaults.standard.removeObject(forKey: "loginDetails")
         //
         //        UserDefaults.standard.removeObject(forKey: "AutoUpdateSwitch")
         //        UserDefaults.standard.removeObject(forKey: "NotificationSwitch")
         //
         //        UserDefaults.standard.synchronize()
         
         */
        
    }
    
    
}
