//
//  HomeViewController.swift
//  Burgan
//
//  Created by Malti Maurya on 17/03/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit

class HomeViewController: UITabBarController, UITabBarControllerDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarSetup()
        settingUpTabBar()
    }
  
    func navigationBarSetup(){
        self.navigationController?.navigationBar.setGradientBackground()
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title  = "Dashboard".localiz()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
    
        navBar.tintColor = UIColor.white
        self.navigationController?.isNavigationBarHidden = true
    }
    @IBOutlet weak var navBar: UIBarButtonItem!
    
  
    @objc func toggleSideMenu(_ sender: Any)
    {
        //self.navigationController?.popViewController(animated: true)
    }
    
    private func settingUpTabBar(){
        self.delegate = self
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let paymentsVC = mainStoryboard.instantiateViewController(withIdentifier: "PaymentTab") as! UINavigationController
        let dashboardVC = mainStoryboard.instantiateViewController(withIdentifier: "DashBoardViewController") as! DashBoardViewController
        let transactionsTabVC = mainStoryboard.instantiateViewController(withIdentifier: "TransactionsTab") as! UINavigationController
        let creditToTabVC = mainStoryboard.instantiateViewController(withIdentifier: "creditToTab") as! UINavigationController

        if AppConstants.ezpayOutletNumber != ""{
            self.viewControllers = [paymentsVC, dashboardVC, transactionsTabVC, creditToTabVC]
            self.selectedIndex = 1
            tabBar.items?[0].title = "Payments".localiz()
            tabBar.items?[1].title = "Dashboard".localiz()
            tabBar.items?[2].title = "Transactions".localiz()
            tabBar.items?[3].title = "Credit".localiz()
        }else{
            self.viewControllers = [dashboardVC, transactionsTabVC, creditToTabVC]
            self.selectedIndex = 0
            tabBar.items?[0].title = "Dashboard".localiz()
            tabBar.items?[1].title = "Transactions".localiz()
            tabBar.items?[2].title = "Credit".localiz()
        }
        
    }
    
}
