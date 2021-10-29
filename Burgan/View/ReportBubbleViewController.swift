//
//  ReportBubbleViewController.swift
//  Burgan
//
//  Created by Malti Maurya on 09/04/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit
import BubbleTransition
import SVPinView

class ReportBubbleViewController: UIViewController {
    weak var interactiveTransition: BubbleInteractiveTransition?
    weak var delegate  : reportsDelegate?
    
    @IBOutlet weak var otpReportView: UIView!
    @IBOutlet weak var newFeatureView2: UIView!
    @IBOutlet weak var newFeatureView1: UIView!
    @IBOutlet weak var lblVerifyNow: UILabel!
    @IBOutlet weak var lblResend: UILabel!
    @IBOutlet weak var lblReportsBlueBubbleDescptn: UILabel!
    @IBOutlet weak var lblGotit: UILabel!
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var otpView: SVPinView!
    
    @IBOutlet weak var lblgotit: UILabel!
    @IBOutlet weak var btnReports: UIButton!
    @IBOutlet weak var lbldesp3: UILabel!
    @IBOutlet weak var lbltitlereport3: UILabel!
    @IBOutlet weak var lblenterotp: UILabel!
    @IBOutlet weak var lbltitlereport2: UILabel!
    @IBOutlet weak var lbldescp1: UILabel!
    @IBOutlet weak var lbltitlereport: UILabel!
    @IBOutlet weak var lblNewfeature: UILabel!
    
    @IBOutlet weak var otpStackView: UIStackView!
    var reportType = 1
    var viewModel: RegistrationViewControllerViewModelProtocol?
    func arabicSetup(){
        lblReportsBlueBubbleDescptn.text = lblReportsBlueBubbleDescptn.text!.localiz()
        lblVerifyNow.text = lblVerifyNow.text!.localiz()
        lblResend.text = lblResend.text!.localiz()
        lblgotit.text = lblgotit.text!.localiz()
        lblGotit.text = lblGotit.text!.localiz()
        lbldesp3.text = lbldesp3.text!.localiz()
//       lbldescp1.text =  lbldescp1.text!.localiz()
        lbldescp1.text =  "You can now get detailed data about your business in just few clicks.".localiz()
        btnReports.setTitle("Reports".localiz(), for: .normal)
        lbltitlereport3.text = lbltitlereport3.text!.localiz()
        lblenterotp.text = lblenterotp.text!.localiz()
        lbltitlereport2.text = lbltitlereport2.text!.localiz()
        lbltitlereport.text =  lbltitlereport.text!.localiz()
        lblNewfeature.text = lblNewfeature.text!.localiz()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arabicSetup()
        self.viewModel = RegistrationViewControllerViewModel()
           codeView(codeView: otpView, digits: 4)
        otpView.didFinishCallback = { [weak self] pin in
           
            self!.dismiss(animated: true, completion: nil)
             self!.delegate?.goToReports()
         let param : [String : Any] = ["cif" : pin,"deviceId" : AppConstants.UserData.deviceID]
            self!.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.VerifyUser)
            self!.bindUI()
            
        }
        
        if reportType == 0
        {
            newFeatureView1.isHidden = false
            newFeatureView2.isHidden = true
            otpReportView.isHidden = true
        }else if reportType == 1{
            newFeatureView1.isHidden = true
                      newFeatureView2.isHidden = false
                      otpReportView.isHidden = true
        }else if reportType == 2{
            newFeatureView1.isHidden = true
                      newFeatureView2.isHidden = true
                      otpReportView.isHidden = false
            otpStackView.isHidden = true
            lblResend.isHidden = true
            lblGotit.isHidden = true
            
        }else{
            newFeatureView1.isHidden = true
                      newFeatureView2.isHidden = true
                      otpReportView.isHidden = false
            otpStackView.isHidden = true
            lblResend.isHidden = true
            lblGotit.isHidden = false
        }
           createPanGeustures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        arabicSetup()
    }
    
    func createPanGeustures(){
    
    
    let panVerifyNow = UITapGestureRecognizer(target: self, action: #selector(self.verifyPin))
    lblVerifyNow.isUserInteractionEnabled = true; self.lblVerifyNow.addGestureRecognizer(panVerifyNow)
    
    let panResendOtp = UITapGestureRecognizer(target: self, action: #selector(self.resendPin))
        lblResend.isUserInteractionEnabled = true; self.lblResend.addGestureRecognizer(panResendOtp)
        
    let panGotit = UITapGestureRecognizer(target: self, action: #selector(self.gotit))
    lblGotit.isUserInteractionEnabled = true; self.lblGotit.addGestureRecognizer(panGotit)
        
    }
    @objc func gotit(sender: UITapGestureRecognizer){
        delegate?.goToReports()
               self.dismiss(animated: true, completion: nil)
    }
    
    @objc func verifyPin(sender: UITapGestureRecognizer){
        
        otpStackView.isHidden = false
        lblResend.isHidden = false
        lblVerifyNow.isHidden = false
    }
    
    @objc func resendPin(sender: UITapGestureRecognizer){
        let param : [String : Any] = ["cif" : otpView.getPin(),"deviceId" : AppConstants.UserData.deviceID]
        viewModel?.serviceRequest(param: param, apiName: RequestItemsType.VerifyUser)
        bindUI()
    }
  
  
    
    private func bindUI() {
          self.viewModel?.alertMessage.bind({ [weak self] in
            MBProgressHUD.hide(for: self!.view, animated: true)
              self?.showAlertDismissOnly(message: $0)
          })
          
          
          
          self.viewModel?.response.bind({ [weak self] in
              
              if let response = $0 {
                  MBProgressHUD.hide(for: self!.view, animated: true)
                if   let userStatus = DataDecryption().decryption(jsonModel: PayloadRes(iv: response.iv, payload: response.payload)) {
                    
                    let status : String = userStatus.value(forKey: "status") as? String ?? ""
                    
                    if status == "" {
                        
                        let param : [String : Any] = ["cif" : self!.otpView.getPin(),"deviceId" : AppConstants.UserData.deviceID]
                        self!.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.VerifyUser)
                        self!.bindUI()
                        
                    } else {
                       
                        let status : String = userStatus.value(forKey: "status") as! String
                          let msg : String = userStatus.value(forKey: "message") as! String
                        if(status == "Success"){
                           let errorCode = userStatus.value(forKey: "errorCode") as! String
                            if errorCode == "L102"
                            {
                                self!.delegate?.goToReports()
                                              self!.dismiss(animated: true, completion: nil)
                            }else{
                                self?.showAlertDismissOnly(message: AlertMessage(title: "Reports", body: msg))
                            }
                        }
                        
                    }
   
            }
            }else{
                self!.showAlertWith(message: AlertMessage(title: "Tijarati".localiz(), body: "Sorry, Failed to load data.".localiz()))
                                      }
          })
        
    }
    
    
    @IBAction func hideBubble(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func codeView(codeView:SVPinView,digits:Int){
           
           codeView.activeBorderLineColor  = UIColor.white
           codeView.textColor = UIColor.white
           codeView.keyboardType = .numberPad
           codeView.placeholder = ""
           //codeView.becomeFirstResponderAtIndex = 0
           codeView.shouldDismissKeyboardOnEmptyFirstField = false
           codeView.allowsWhitespaces = false
           codeView.borderLineThickness = 1
           codeView.interSpace = 10
           codeView.borderLineColor = UIColor.white
           
           // codeView.font = UIFont(name:"Monsterrat-Medium", size: 15)!
           
           codeView.pinLength = digits
           codeView.activeBorderLineThickness = 1
           codeView.fieldBackgroundColor = UIColor.clear
           codeView.activeFieldBackgroundColor = UIColor.clear
           codeView.fieldCornerRadius = 0
           codeView.activeFieldCornerRadius = 0
       }
    
    @IBAction func goToReports(_ sender: Any) {
        delegate?.goToReports()
        self.dismiss(animated: true, completion: nil)
                       
    }
}
