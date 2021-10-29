//
//  CollectPaymentInitiateBtnClickViewController.swift
//  Burgan
//
//  Created by Pratik on 15/07/21.
//  Copyright © 2021 1st iMac. All rights reserved.
//

import UIKit

class CollectPaymentInitiateBtnClickViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tijaratiMsgLbl: UILabel!
    @IBOutlet var backBtnRef: UIButton!
    @IBOutlet var shareBtnRef: UIButton!
    @IBOutlet var copyBtnRef: UIButton!
    @IBOutlet var textViewRef: UITextView!
    @IBOutlet var viewRef: UIView!

    var text = ""
    var selectedLang = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        copyBtnRef.layer.cornerRadius = 22
        viewRef.layer.cornerRadius = 5
        shareBtnRef.layer.cornerRadius = 15
        shareBtnRef.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        textViewRef.text = text
        
        if selectedLang == "AR" {
            textViewRef.textAlignment = .right
        } else {
            textViewRef.textAlignment = .left
        }
        
        arabicSetup()
    }
    
    func arabicSetup(){
        titleLabel.text = titleLabel.text?.localiz()
        tijaratiMsgLbl.text = tijaratiMsgLbl.text?.localiz()
        shareBtnRef.setTitle("SHARE".localiz(), for: .normal)
        copyBtnRef.setTitle("Copy".localiz(), for: .normal)
        if AppConstants.language == .ar {
            copyBtnRef.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -5)
            textViewRef.textAlignment = .right
        } else {
            copyBtnRef.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 5)
            textViewRef.textAlignment = .left
        }
    }

}

//MARK:- BUTTON ACTION
extension CollectPaymentInitiateBtnClickViewController{
    @IBAction func shareBtnTap(_ sender: UIButton){
        let someText:String = "\(textViewRef.text ?? "")"
        //let objectsToShare:URL = URL(string: "https://www.burgan.com/Pages/Home.aspx")!
       let sharedObjects:[AnyObject] = [someText as AnyObject]
       let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
       activityViewController.popoverPresentationController?.sourceView = self.view

        // activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook,UIActivity.ActivityType.postToTwitter,UIActivity.ActivityType.mail]
        activityViewController.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
            if completed {
                self.backToDashBoard()
            }
         }
       self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func copyBtnTap(_ sender: UIButton){
        UIPasteboard.general.string = textViewRef.text
    }
    
    @IBAction func backBtnTap(_ sender: UIButton){
        self.dismiss(animated: true) {
            self.backToDashBoard()
        }
    }
    
    func backToDashBoard(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let dashboardVc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        
         let controller = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RootViewController") as? RootViewController)!
         appDelegate.window?.rootViewController = controller
         appDelegate.window?.makeKeyAndVisible()
         
        
        
//        let controller = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RootViewController") as? RootViewController)!
//       self.navigationController?.pushViewController(controller, animated: true)
        
        
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RootViewController") as! RootViewController
//        let navigationController = UINavigationController()
//        navigationController.pushViewController(nextViewController, animated: true)
//        appDelegate.window?.rootViewController = navigationController
//        appDelegate.window?.makeKeyAndVisible()
    }
    
}



