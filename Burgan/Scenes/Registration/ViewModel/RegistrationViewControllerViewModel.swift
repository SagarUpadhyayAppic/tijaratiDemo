//
//  RegistrationViewControllerViewModel.swift
//  Burgan
//
//  Created by Malti Maurya on 17/04/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit
import Alamofire


// MARK: - RegistrationViewControllerViewModel
protocol RegistrationViewControllerViewModelProtocol {
    var alertMessage: Dynamic<AlertMessage> { get set }
    // var isLoaderHidden: Dynamic<Bool> { get set }
    var response: Dynamic<PayloadRes?> { get set }
    func serviceRequest(param :  [String : Any] , apiName : EndPointType)
    func failTest()
    
    var TnC_AlertMessage: Dynamic<AlertMessage> { get set }
    var TnC_Data: Dynamic<GetTnCData?> { get set }
    func GetTermsCondition()
}


class RegistrationViewControllerViewModel: NSObject, RegistrationViewControllerViewModelProtocol {
    
    // MARK: - Vars & Lets
    
    var alertMessage: Dynamic<AlertMessage> = Dynamic(AlertMessage(title: "", body: ""))
    
    var response: Dynamic<PayloadRes?>  = Dynamic(nil)
    
    var TnC_AlertMessage: Dynamic<AlertMessage> = Dynamic(AlertMessage(title: "", body: ""))
    var TnC_Data: Dynamic<GetTnCData?>   = Dynamic(nil)
    
    
    private let apiManager = Apimanager(sessionManager: SessionManager(), retrier: APIManagerRetrier())
    
    
    // MARK: - Public methods
    func serviceRequest(param :  [String : Any], apiName : EndPointType) {
        
        let jsonData = try! JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
        let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)
        print(jsonString!)
        let payloadParam = DataEncryption().encryption(str: jsonString ?? "")
        // let pp = DataEncrypter().e(str: jsonString as! String)
        // let payloadParam = DataEncrypter().encrypt(stringToBeEncrypted:jsonString as! String)
        //  let p = PayloadReq(iv: "V9cILK8dAXNMpeg+cKNVKA==", payload: "bksKQLss/Wf5/gGPm51KC6g6GpB07c9Q5srRMnqVOUZp6uuhI+bI9NqXOFT1Oi/WCb/GsLHscBYDO57FCZl4Iy8oqkYxtzL9tpxpltreOHAbwShNflmyh+NZYnA0n3kpig==", key: "AXUHPLbryrq0ymeKTFEUFVPJ9l6FRuCyyvqKk+uY0cU8NOB7nnJfQEKBS1RDB1oswiUT/KYc+jZIDbnqEFYf5aC4+2WYEhxF9EZjfpeUYabvYlikWwoL+URSkL26oGUQ0ZFeQXpEG7uLFkJKWgaGszYDRlo2P/OBjShIAqG5kdiQjwB8Q70CKYq32Q3SmGy2ujIt9miUlAZSH4w6Ux6Zowr5WP4he6slXqbozlyrjrBSihRM+5zvgaQkiMoSZeApmiez9oN6RYaUXht2dKcaSuMBjkORGLY7rgg5RtS6cu1A1K00fxCZFPNG8i7Mps+Wp+UIvHbAhed+vahNi7ALcg==")
        
        let encryptedParam :Parameters = ["KEY" : payloadParam!.key,
                                          "IV" : payloadParam!.iv,
                                          "PAYLOAD" : payloadParam!.payload]
        print("Encrypted Param :: \(encryptedParam)")
        
        // let userStatus = DataDecryption().decryption(jsonModel: PayloadRes(iv: payloadParam!.iv, payload: payloadParam!.payload))
        // print(userStatus!)
        
        
        self.apiManager.call(type: apiName, params: encryptedParam){(res: Result<PayloadRes?>) in
            switch res {
            case .success(let response):
                
                self.response.value = response
                // print(response)
                
                break
            case .failure(let message):
                print(message.localizedDescription)
                self.alertMessage.value = message as! AlertMessage
                break
            }
            
        }
        
    }
    
    func GetTermsCondition() {
        
        if AppConstants.language == .ar {
            
            self.apiManager.call(type: RequestItemsType.getTNCar)
            {(res: Result<GetTnCData?>) in
                switch res {
                    
                case .success(let response):
                    self.TnC_Data.value = response
                    break
                case .failure(let message):
                    print(message.localizedDescription)
                    self.TnC_AlertMessage.value = message as! AlertMessage
                    break
                }
                
            }
            
        } else {
            
            self.apiManager.call(type: RequestItemsType.getTNC)
            {(res: Result<GetTnCData?>) in
                switch res {
                    
                case .success(let response):
                    self.TnC_Data.value = response
                    break
                case .failure(let message):
                    print(message.localizedDescription)
                    self.TnC_AlertMessage.value = message as! AlertMessage
                    break
                }
                
            }
        }
        
        
    }
    
    
    func failTest() {
        self.apiManager.call(type: RequestItemsType.fail) { (res:Result<[String : Any]>) in
            switch res {
            case .success(let response):
                print(response)
                break
            case .failure(let message):
                print(message.localizedDescription)
                self.alertMessage.value = message as! AlertMessage
                break
            }
        }
        
    }
    
    // MARK: - Init
    
    override init() {
        super.init()
    }
    
}
