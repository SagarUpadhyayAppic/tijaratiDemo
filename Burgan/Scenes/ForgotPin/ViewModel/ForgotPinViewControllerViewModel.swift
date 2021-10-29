//
//  ForgotPinViewControllerViewModel.swift
//  Burgan
//
//  Created by Malti Maurya on 15/05/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//


import UIKit

import Alamofire

// MARK: - ForgotPinViewControllerViewModel
protocol ForgotPinViewControllerViewModelProtocol {
    var alertMessage: Dynamic<AlertMessage> { get set }
   // var isLoaderHidden: Dynamic<Bool> { get set }
    var response: Dynamic<PayloadRes?> { get set }
    func serviceRequest(param :  [String : Any] , apiName : EndPointType)
    func failTest()
   

}
 

class ForgotPinViewControllerViewModel: NSObject, ForgotPinViewControllerViewModelProtocol {
    
        // MARK: - Vars & Lets
  

    var alertMessage: Dynamic<AlertMessage> = Dynamic(AlertMessage(title: "", body: ""))

    var response: Dynamic<PayloadRes?>  = Dynamic(nil)
    private let apiManager = Apimanager(sessionManager: SessionManager(), retrier: APIManagerRetrier())
    
    
    // MARK: - Public methods
    func serviceRequest(param :  [String : Any], apiName : EndPointType) {
        

        let jsonData = try! JSONSerialization.data(withJSONObject: param)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
//        print(jsonString)
        let payloadParam = DataEncryption().encryption(str: jsonString as! String)
     
        let encryptedParam :Parameters = ["KEY" : payloadParam!.key,
                                          "IV" : payloadParam!.iv,
                                          "PAYLOAD" : payloadParam!.payload]

        self.apiManager.call(type: apiName, params: encryptedParam){(res: Result<PayloadRes?>) in
                switch res {
                case .success(let response):
        
                    self.response.value = response
//              print(response)
                
                    break
                case .failure(let message):
                    print(message.localizedDescription)
                    self.alertMessage.value = message as! AlertMessage
                    break
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
