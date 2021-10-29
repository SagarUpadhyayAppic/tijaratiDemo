//
//  T&CViewController.swift
//  Burgan
//
//  Created by Mayank on 01/07/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit

class T_CViewController: UIViewController {

    
    @IBOutlet weak var bg_View: UIView!
    @IBOutlet weak var terms_TextView: UITextView!
    @IBOutlet weak var chkBox_ImgView: UIImageView!
    @IBOutlet weak var chkBox_Btn: UIButton!
    @IBOutlet weak var continue_Btn: UIButton!
    
    @IBOutlet weak var chkBoxHeightConst: NSLayoutConstraint!

    var isFrom = String()
    
    
    var viewModel: RegistrationViewControllerViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.networkStatusChanged(_:)), name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
//        Reach().monitorReachabilityChanges()
        
        bg_View.layer.cornerRadius = 20.0
        bg_View.clipsToBounds = true
        
        terms_TextView.layer.cornerRadius = 10.0
        terms_TextView.clipsToBounds = true
        
        continue_Btn.layer.cornerRadius = 10.0
        continue_Btn.clipsToBounds = true
        
        self.viewModel = RegistrationViewControllerViewModel();
        
        if isFrom == "register" {
            
            chkBox_ImgView.image = UIImage(named: "ic_checkbox_disabled")
            continue_Btn.backgroundColor = UIColor.init(hexString: "BFCEDB")
            continue_Btn.setTitleColor(UIColor.init(hexString: "7F9DB8"), for: .normal)
            continue_Btn.setTitle("CONTINUE".localiz(), for: .normal)
            continue_Btn.tag = 1
            
            self.chkBoxHeightConst.constant = 40.0
            
        } else {
            
            continue_Btn.backgroundColor = UIColor.init(hexString: "0065A6")
            continue_Btn.setTitleColor(UIColor.white, for: .normal)            
            continue_Btn.setTitle("OK".localiz(), for: .normal)
            continue_Btn.tag = 2
            
            self.chkBoxHeightConst.constant = 0.0

        }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.viewModel?.GetTermsCondition()
        self.bindTermsCondition()
    }
    


    private func bindTermsCondition() {
        
        self.viewModel?.TnC_AlertMessage.bind({ [weak self] in
            MBProgressHUD.hide(for: self!.view, animated: true)
            self?.showAlertDismissOnly(message: $0)
        })
        
    
        self.viewModel?.TnC_Data.bind({ [weak self] in
        
            if let response = $0 {
                
                MBProgressHUD.hide(for: self!.view, animated: true)
                
                if response.status == "Success" {
                    
                    let errorCode : String = response.errorCode ?? "" //userStatus?.value(forKey: "errorCode") as! String
                    if errorCode == "L120" {
                        
                        let myStr = response.data!
                                            
//                        if let base64Decoded = Data(base64Encoded: response.data!, options: Data.Base64DecodingOptions(rawValue: 0))
//                        .map({ String(data: $0, encoding: .utf8) }) {
//                            // Convert back to a string
//                            print("Decoded: \(base64Decoded ?? "")")
//                        }
                        
                        
                        let mynewStr = myStr.myfromBase64()
                        
                        
//                        let newStr = "TWF5YW5rIFByYWphcGF0aQ==".fromBase64()
//                        //print(newStr!)
//
//                        let newStr2 = "TWF5YW5rIFByYWphcGF0aQ==".base64Decoded()
//                        //print(newStr2)
//
//                        let base64Encoded = "PHA+U2F2ZSB0aGUgZG9jdW1lbnQgYnkgcHJlc3NpbmcgPGtiZD5DdHJsICsgUzwva2JkPjwvcD4="
//
//                        let decodedData = Data(base64Encoded: base64Encoded)!
//                        let decodedString = String(data: decodedData, encoding: .utf8)!
//
//                        print(decodedString)
//
////                    println(decodedString)
                                            
                                            
                        self?.terms_TextView.attributedText = mynewStr?.htmlToAttributedString
                        
                    } else {
                        
                    }

                } else {
            
                    //self?.showAlert(msg: msg, isError: true)
                }
            }
            MBProgressHUD.hide(for: self!.view, animated: true)
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func Continue_Btn_Tapped(_ sender: UIButton) {
        
        if sender.tag == 2 {
            
            self.dismiss(animated: true, completion: nil)
            
        } else {
           
            if chkBox_Btn.isSelected {
                
                let performanceParam : [String : Any] = ["cif" : AppConstants.UserData.cif,
                                                         "deviceId" : AppConstants.UserData.deviceID
                                                        ]
                 MBProgressHUD.showAdded(to: self.view, animated: true)
                self.viewModel?.serviceRequest(param: performanceParam, apiName: RequestItemsType.acceptTnC)
                self.bindUI()
                
            } else {
                
                let alertController = UIAlertController(title: "Alert", message: "Please accept Terms & Condition", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { action in
                    print("You've pressed OK Button")
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func CheckBox_Btn_Tapped(_ sender: UIButton) {
        
        if chkBox_Btn.isSelected {
            chkBox_ImgView.image = UIImage(named: "ic_checkbox_disabled")
            continue_Btn.backgroundColor = UIColor.init(hexString: "BFCEDB")
            continue_Btn.setTitleColor(UIColor.init(hexString: "7F9DB8"), for: .normal)
        } else {
            chkBox_ImgView.image = UIImage(named: "ic_checkbox_enabled")
            continue_Btn.backgroundColor = UIColor.init(hexString: "0065A6")
            continue_Btn.setTitleColor(UIColor.white, for: .normal)
        }
        chkBox_Btn.isSelected = !chkBox_Btn.isSelected
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
                        
                        if status == "" {
                            
                            let performanceParam : [String : Any] = ["cif" : AppConstants.UserData.cif,
                                                                     "deviceId" : AppConstants.UserData.deviceID
                                                                    ]
                             MBProgressHUD.showAdded(to: self!.view, animated: true)
                            self!.viewModel?.serviceRequest(param: performanceParam, apiName: RequestItemsType.acceptTnC)
                            self!.bindUI()
                            
                        } else {
                          
                            let message : String = userStatus?.value(forKey: "message") as! String
                                                    let status : String = userStatus?.value(forKey: "status") as! String
                                                    if status == "Success"{
                                                        let errorCode : String = userStatus?.value(forKey: "errorCode") as! String
                                                        if errorCode == "S101" {
                            //                                print(message)
                                                            let object = self!.decodeResult(model: GetAcceptTNCData.self, result: userStatus!)
                                                            let acceptTNC = object.model
                                                            print(acceptTNC?.message! ?? "")
                                                            
                                                            self?.dismiss(animated: true, completion: nil)
                                                             
                                                        } else {
                                                            
                                                            self!.showAlertWith(message: AlertMessage(title: "Terms & Condition".localiz(), body: message.localiz()))
                                                        }
                                                              
                                                    } else {
                                                        self!.showAlertWith(message: AlertMessage(title: "Terms & Condition".localiz(), body: message.localiz()))
                                                    }
                        }

                                 
                        
                    }
                }
            }
        })
    }
    
}


extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}


extension String {
    func myfromBase64() -> String? {
        guard let data = Data(base64Encoded: self.replacingOccurrences(of: "_", with: "="), options: Data.Base64DecodingOptions(rawValue: 0)) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }
}

extension UIColor {
    
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
    
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
    
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
