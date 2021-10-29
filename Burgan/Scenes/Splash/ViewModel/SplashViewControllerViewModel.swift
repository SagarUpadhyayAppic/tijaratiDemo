//
//  SplashViewControllerViewModel.swift
//  Burgan
//
//  Created by Malti Maurya on 22/04/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit
import Alamofire

protocol SplashViewControllerViewModelProtocol {
    var alertMessage: Dynamic<AlertMessage> { get set }
      var appKey: Dynamic<AppKey?> { get set }
      func getAppKey()
      func failTest()
}

class SplashViewControllerViewModel: NSObject, SplashViewControllerViewModelProtocol {

    // MARK: - Vars & Lets

     var alertMessage: Dynamic<AlertMessage> = Dynamic(AlertMessage(title: "", body: ""))
     var appKey: Dynamic<AppKey?>   = Dynamic(nil)
    private let apiManager = Apimanager(sessionManager: SessionManager(), retrier: APIManagerRetrier())
      
    func getAppKey() {
        self.apiManager.call(type: RequestItemsType.getKey)
        {(res: Result<AppKey?>) in
            switch res {
                
            case .success(let response):
                self.appKey.value = response
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
