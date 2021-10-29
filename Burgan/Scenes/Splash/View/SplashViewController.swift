//
//  SplashViewController.swift
//  Burgan
//
//  Created by Malti Maurya on 22/04/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit
import Alamofire

class SplashViewController: UIViewController
{
    
    var viewModel: SplashViewControllerViewModelProtocol?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
      
//        fatalError()
        
//        if AppConstants.isDeviceJailbroken {
        if UIDevice.current.isJailBroken {
            
            let alertController = UIAlertController(title: "Device is Jailbroken", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok".localiz(), style: .default) { (action) in
                alertController.dismiss(animated: true, completion: nil)
                exit(0)
            }
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            self.viewModel = SplashViewControllerViewModel()
            self.viewModel?.getAppKey()
            self.bindUI()
            
        }
        
        /*
        self.viewModel = SplashViewControllerViewModel()
        self.viewModel?.getAppKey()
        self.bindUI()
        */
        
        
//        let controller = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RegistrationViewController") as? RegistrationViewController)!
//           self.navigationController?.pushViewController(controller, animated: true)

       // let data = DataEncryption().encryption(str: "Hello Good Morning")
        //print(data)
    }
    
    /*
    private func bindUI() {
                 self.viewModel?.alertMessage.bind({ [weak self] in
                    self?.showAlertDismissOnly(message: $0)
                 })
               
           
           self.viewModel?.appKey.bind({ [weak self] in
               
           if let response = $0 {
           
               AppConstants.UserData.appKey = response.key
               let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RegistrationViewController") as? RegistrationViewController
            self?.navigationController?.pushViewController(controller!, animated: true)

               }
           })
        
    }
    */
    
    
    private func bindUI() {
          self.viewModel?.alertMessage.bind({ [weak self] in
             self?.showAlertDismissOnly(message: $0)
          })
        
    
    self.viewModel?.appKey.bind({ [weak self] in
        
    if let response = $0 {
     AppConstants.UserData.appKey = response.key
        
        /*
        //SANKET
        if UserDefaults.standard.value(forKey: "loginDetails") != nil
        {
            let loginDetails = UserDefaults.standard.value(forKey: "loginDetails") as! [String:Any]
            let controller = UIStoryboard.init(name: "Main", bundle:    Bundle.main).instantiateViewController(withIdentifier: "RegistrationViewController") as?    RegistrationViewController
            controller?.showLoginScreen = true
            AppConstants.UserData.cif = loginDetails["mobileNumber"] as! String
            self?.navigationController?.pushViewController(controller!, animated: true)
        } else {
            let controller = UIStoryboard.init(name: "Main", bundle:    Bundle.main).instantiateViewController(withIdentifier: "RegistrationViewController") as?    RegistrationViewController
            controller?.showLoginScreen = false
            self?.navigationController?.pushViewController(controller!, animated: true)
        }
        
        //SANKET OVER
        */
        
        if let receivedData = KeyChain.load(key: "loginDetails") {
            let result = receivedData.to(type: String.self)
            print("result: ", result)
            
            let controller = UIStoryboard.init(name: "Main", bundle:    Bundle.main).instantiateViewController(withIdentifier: "RegistrationViewController") as?    RegistrationViewController
            controller?.showLoginScreen = true
            AppConstants.UserData.cif = result
            self?.navigationController?.pushViewController(controller!, animated: true)
            
        } else {
            
            let controller = UIStoryboard.init(name: "Main", bundle:    Bundle.main).instantiateViewController(withIdentifier: "RegistrationViewController") as?    RegistrationViewController
            controller?.showLoginScreen = false
            self?.navigationController?.pushViewController(controller!, animated: true)
            
        }

        }
    })
        
    }
}
