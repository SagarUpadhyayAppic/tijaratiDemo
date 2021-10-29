//
//  AppExtensions.swift
//  PaperVideo
//
//  Created by 1st iMac on 11/03/20.
//  Copyright © 2020 appic. All rights reserved.
//

import UIKit
extension UIViewController {
    
    // MARK: - Public methods
    
    func showAlertWith(message: AlertMessage , style: UIAlertController.Style = .alert) {
        let alertController = UIAlertController(title: message.title.localiz(), message: message.body.localiz(), preferredStyle: style)
        let action = UIAlertAction(title: "Ok".localiz(), style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    func showAlertDismissOnly(message: AlertMessage , style: UIAlertController.Style = .alert) {
        let alertController = UIAlertController(title: message.title.localiz(), message: message.body.localiz(), preferredStyle: style)
        let action = UIAlertAction(title: "Ok".localiz(), style: .default) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    //    func shouldHideLoader(isHidden: Bool) {
    //        if isHidden {
    //            MBProgressHUD.hide(for: self.view, animated: true)
    //        } else {
    //            MBProgressHUD.showAdded(to: self.view, animated: true)
    //        }
    //    }
    
    
    func presentView() {
        
        let story = UIStoryboard.init(name: "New", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "NoInternetConnectionVC") as! NoInternetConnectionVC
        vc.modalPresentationStyle = .overCurrentContext
//        navigationController?.pushViewController(vc, animated: false)
            self.present(vc, animated: false, completion: nil)
    }
        
        @objc func networkStatusChanged(_ notification: Notification) {
            if let userInfo = notification.userInfo {
                let status = userInfo["Status"] as! String
                print(status)
                
                // Offline
                // WiFi
                
                if status == "Offline"
                {
                    presentView()
                }
                else
                {
                    dismissVIew()
                }
            }
        }
        
        
        
        func dismissVIew()
        {
            self.dismiss(animated: false, completion: nil)
//            navigationController?.popViewController(animated: false)
        }
        
    
}


private var kAssociationKeyMaxLength: Int = 0
extension UITextField {
    
    @IBInspectable var maxLength: Int {
        get {
            if let length = objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int {
                return length
            } else {
                return Int.max
            }
        }
        set {
            objc_setAssociatedObject(self, &kAssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
            addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
        }
    }
    
    @objc func checkMaxLength(textField: UITextField) {
        guard let prospectiveText = self.text,
            prospectiveText.count > maxLength
            else {
                return
        }
        
        let selection = selectedTextRange
        
        let indexEndOfText = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        let substring = prospectiveText[..<indexEndOfText]
        text = String(substring)
        
        selectedTextRange = selection
    }
    
    func setLeftPadding()
    {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = UITextField.ViewMode.always
    }
    
    func setRightPadding()
    {
        let paddingView = UIView(frame: CGRect(x: self.frame.width - 20, y: 0, width: 10, height: self.frame.height))
        self.rightView = paddingView
        self.rightViewMode = UITextField.ViewMode.always
    }
    
    func emailValidation() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self.text)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func phoneValidation() -> Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self.text!, options: [], range: NSMakeRange(0, self.text!.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.text!.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
}


extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message.localiz()
        messageLabel.textColor = UIColor(hexString: "0065A6") //.black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: UIFont.Frutiger.light.rawValue, size: 15.0) //UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

public extension UITextField {
    override var textInputMode: UITextInputMode? {
        return UITextInputMode.activeInputModes.filter { $0.primaryLanguage == "en" }.first ?? super.textInputMode
    }
}

extension String {
    var containsNonEnglishNumbers: Bool {
        return !isEmpty && range(of: "[^0-9]", options: .regularExpression) == nil
    }

    var english: String {
        return self.applyingTransform(StringTransform.toLatin, reverse: false) ?? self
    }
}
