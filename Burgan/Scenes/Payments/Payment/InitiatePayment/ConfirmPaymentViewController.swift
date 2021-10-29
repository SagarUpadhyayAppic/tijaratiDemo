//
//  ConfirmPaymentViewController.swift
//  Burgan
//
//  Created by Mayank on 20/09/21.
//  Copyright © 2021 1st iMac. All rights reserved.
//

import UIKit

class ConfirmPaymentViewController: UIViewController, XIBed, UIViewControllerTransitioningDelegate {
    
    static func instantiate(cif : String,
                            ezpayOutletNumber : String,
                            emailID : String,
                            amt : String,
                            mobileNo : String,
                            descriptions : String,
                            deviceId : String,
                            name : String,
                            language : String) -> Self {
        let vc = Self.instantiate()
        vc.cif = cif
        vc.ezpayOutletNumber = ezpayOutletNumber
        vc.emailID = emailID
        vc.amt = amt
        vc.mobileNo = mobileNo
        vc.descriptions = descriptions
        vc.deviceId = deviceId 
        vc.name = name
        vc.language = language
        return vc
    }
    
    var cif : String = ""
    var ezpayOutletNumber : String = ""
    var emailID : String = ""
    var amt : String = ""
    var mobileNo : String = ""
    var descriptions : String = ""
    var deviceId : String = ""
    var name : String = ""
    var language : String = ""
    
    var viewModel : RegistrationViewControllerViewModelProtocol?
    
    @IBOutlet weak var containersView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var separatorView: UIView!
    
    @IBOutlet weak var amountStackView: UIStackView!
    @IBOutlet weak var amountTitleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    
    @IBOutlet weak var contactNoStackView: UIStackView!
    @IBOutlet weak var contactNoTitleLabel: UILabel!
    @IBOutlet weak var contactNoLabel: UILabel!
    
    
    @IBOutlet weak var nameStackView: UIStackView!
    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBOutlet weak var emailIdStackView: UIStackView!
    @IBOutlet weak var emailIdTitleLabel: UILabel!
    @IBOutlet weak var emailIdLabel: UILabel!
    
    @IBOutlet weak var confirmPaymentView: UIView!
    @IBOutlet weak var confirmPaymentButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        containersView.layer.cornerRadius = 16.0
        containersView.clipsToBounds = true
        containersView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        confirmPaymentView.layer.cornerRadius = 16.0
        confirmPaymentView.clipsToBounds = true
        confirmPaymentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        self.fillData()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func fillData() {
        
        var amount: String = ("KD " + self.amt)
        self.amountLabel.attributedText = amount.attributedString(fontsize: 15)
        self.contactNoLabel.text = self.mobileNo
        self.nameLabel.text = self.name
        self.emailIdLabel.text = self.emailID
        
        self.amountStackView.isHidden = self.amt.isEmpty
        self.contactNoStackView.isHidden = self.mobileNo.isEmpty
        self.nameStackView.isHidden = self.name.isEmpty
        self.emailIdStackView.isHidden = self.emailID.isEmpty
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmPaymentButtonTapped(_ sender: UIButton) {
       callSinglePaymentInitiateAPI()
    }
    
    func callSinglePaymentInitiateAPI() {
        viewModel = RegistrationViewControllerViewModel()
        
        let param : [String : Any] = ["cif" : self.cif,
                                      "eZPayOutletNumber" : self.ezpayOutletNumber,
                                      "emailId" : self.emailID,
                                      "amt" : self.amt,
                                      "mobileNumber" : self.mobileNo,
                                      "description" : self.descriptions,
                                      "deviceId": self.deviceId,
                                      "name" : self.name,
                                      "language": self.language,
                                      "payeeName" : AppConstants.cifCompanyName
        ]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.singlePaymentInitiate)
        bindSinglePaymentInitiateAPI()
    }
    
    func bindSinglePaymentInitiateAPI(){
        
        self.viewModel?.alertMessage.bind({ [weak self] in
            MBProgressHUD.hide(for: self!.view, animated: true)
            self?.showAlertDismissOnly(message: $0)
        })
        
        
        self.viewModel?.response.bind({ [weak self] in
            
            if let response = $0 {
                
                MBProgressHUD.hide(for: self!.view, animated: true)
                if   let userStatus = DataDecryption().decryption(jsonModel: PayloadRes(iv: response.iv, payload: response.payload))
                {
                    let status : String = userStatus.value(forKey: "status") as? String ?? ""
                    if status == "" {
                        self?.callSinglePaymentInitiateAPI()
                    } else {
                        
                        let message : String = userStatus.value(forKey: "message") as! String
                        let status : String = userStatus.value(forKey: "status") as! String
                        if status == "Success"{
                            let errorCode : String = userStatus.value(forKey: "errorCode") as! String
                            if errorCode == "L128"{
                                print("Message:-\(message)")
                                let object = self?.decodeResult(model: SinglePaymentInitiateApi.self, result: userStatus)
                                
                                print("MYDATA:- \(userStatus.allKeys)")
                                let vc = CollectPaymentInitiateBtnClickViewController(nibName: "CollectPaymentInitiateBtnClickViewController", bundle: nil)
                                guard let linkText = object?.model?.paymentURL else {return}
                                
                                // vc.text = "Dear customer, K-Mart has requested payment for \(object?.model?.amount ?? "KD 0.00").\nTap on the below link to pay:- \n \(linkText)"
                                
//                                vc.text = "Dear customer,".localiz() + " \(AppConstants.cifCompanyName) " + "has requested payment for".localiz() + " KD \(object?.model?.amount ?? "KD 0.00")." + "\nTap on the below link to pay:- \n".localiz() + "\(linkText)"
                                vc.text = linkText
                                vc.selectedLang = self?.language ?? ""
                                vc.modalPresentationStyle = .custom
                                vc.transitioningDelegate = self
                                self?.present(vc, animated: true, completion: nil)
                                
                            } else {
                                self?.showAlertWith(message: AlertMessage(title: "", body: message.localiz()))
                            }
                            
                        }else{
                            self?.showAlertWith(message: AlertMessage(title: "Payments".localiz(), body: message.localiz()))
                        }
                    }
                    
                }
                
            }else{
                self?.showAlertWith(message: AlertMessage(title: "Tijarati".localiz(), body: "Sorry, Failed to load data.".localiz()))
            }
            
        })
        
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        return halfSizeInitiatePaymentPresentation(presentedViewController: presented, presenting: presentingViewController)
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
}
