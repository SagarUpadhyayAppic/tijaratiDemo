//
//  WebViewVC.swift
//  Biggit
//
//  Created by Kirtikar on 19/01/18.
//  Copyright © 2018 Appicmobile. All rights reserved.
//

import UIKit
import MBProgressHUD
import WebKit

class WebViewVC: UIViewController,WKNavigationDelegate {

    var webUrlRec = String()
    
    var fileUrlPathStr = String()
    
    var share_Btn: UIButton!
    
    var NavBarTitle = String()
    
    //@IBOutlet weak var myWebView : UIWebView?
    @IBOutlet var myWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myWebView?.navigationDelegate = self
        
        self.navigationItem.title = NavBarTitle
        
        if webUrlRec.count > 0 {
            
            let url = NSURL (string: webUrlRec);
            let requestObj = URLRequest(url: url! as URL);
            myWebView?.load(requestObj);
            
        } else {
            
            let url = URL(fileURLWithPath: fileUrlPathStr)
            let requestObj = URLRequest(url: url)
            
            myWebView?.load(requestObj);
            
            
            
            share_Btn = UIButton(type: .custom)
//            share_Btn.setImage(UIImage(named: "share.png"), for: .normal)
            if #available(iOS 13.0, *) {
                share_Btn.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
            } else {
                // Fallback on earlier versions
            }
            share_Btn.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
            share_Btn.clipsToBounds = true
            share_Btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            share_Btn.addTarget(self, action: #selector(ShareBtnTapped), for: .touchUpInside)
            share_Btn.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
            share_Btn.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
            let item = UIBarButtonItem(customView: share_Btn)
            
            self.navigationItem.setRightBarButtonItems([item], animated: true)
        }
        
        // Do any additional setup after loading the view.
        
        
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    @objc func ShareBtnTapped(sender: UIButton){
        print("Button tapped")
        
        //let pdfData = NSData(contentsOfFile: fileUrlPathStr) as Data?
        let url = URL(fileURLWithPath: fileUrlPathStr)
        
        let shareItems:Array = [url]
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems , applicationActivities: nil)
        //activityViewController.excludedActivityTypes = [UIActivityType.print, UIActivityType.postToWeibo, UIActivityType.copyToPasteboard, UIActivityType.addToReadingList, UIActivityType.postToVimeo, UIActivityType.postToFacebook,UIActivityType.postToTwitter]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func BackBtn (_ sender : Any)
    {
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
