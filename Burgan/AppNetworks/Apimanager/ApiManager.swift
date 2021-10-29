//
//  ApiManager.swift
//  DFinder
//
//  Created by Pathak on 22/11/19.
//  Copyright © 2019 Pathak. All rights reserved.
//

import Alamofire
import Foundation

class Apimanager {
    
    // MARK: - Vars & Lets
    
  //  private let sessionManager: SessionManager
    private let retrier: APIManagerRetrier
    static let networkEnviroment: NetworkEnvironment = .dev
    
    // MARK: - Public methods
    private var sessionManager: Alamofire.SessionManager = {

        var serverTrustPolicies = [String: ServerTrustPolicy]()
        
        // UAT
        if let path = Bundle.main.path(forResource: "burganbank", ofType: "cer") {
        
        // LIVE
        //if let path = Bundle.main.path(forResource: "burganNewProduction", ofType: "cer") {
            do {
                let localCertificate = try Data(contentsOf: URL(fileURLWithPath: path))
                  
                let certDataRef = localCertificate as CFData
                var cert: SecCertificate = SecCertificateCreateWithData(nil, certDataRef)!
                        
                        
                let serverTrustPolicy = ServerTrustPolicy.pinCertificates(certificates: [cert], validateCertificateChain: true, validateHost: true)

                // UAT
                
                serverTrustPolicies = [
                    "BurganBNK" :  serverTrustPolicy
                ]
                
                
                // LIVE
//                serverTrustPolicies = [
//                     "mwext.burgan.com" :  serverTrustPolicy
//                ]
                
              } catch {
                   // handle error
              }
        }
        
        /*
        let pathToCert = Bundle.main.path(forResource: "burganbank", ofType: "cer")
        let localCertificate : NSData = NSData(contentsOfFile: pathToCert!)
//        let localCertificate : NSData = NSData(contentsOfFile: pathToCert! )!

        let certDataRef = localCertificate as CFData
        var cert: SecCertificate = SecCertificateCreateWithData(nil, certDataRef)!
        
        
        let serverTrustPolicy = ServerTrustPolicy.pinCertificates(certificates: [cert], validateCertificateChain: true, validateHost: true)
//        let serverTrustPolicy = ServerTrustPolicy.pinCertificates( certificates: [SecCertificateCreateWithData(nil, localCertificate)], validateCertificateChain : true, validateHost : true)

        let serverTrustPolicies = [
             "mwextpp.burgan.com:9067" :  serverTrustPolicy
        ]
        */

        /*
         // Create the server trust policies
         let serverTrustPolicies: [String: ServerTrustPolicy] = [

              "mwextpp.burgan.com:9067": .disableEvaluation
         ]
        */

        // Create URL Session Configuration
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        // Create custom manager
        // With SSL Pinning
         let manager = Alamofire.SessionManager(
              configuration: config,
              serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
         )
        
//        let cert = PKCS12.init(mainBundleResource: "Tijarati2Way", resourceType: "p12", password: "password")
//        manager.delegate.sessionDidReceiveChallenge = { session, challenge in
//            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodClientCertificate {
//                return (URLSession.AuthChallengeDisposition.useCredential, cert.urlCredential());
//            }
//            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
//                return (URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!));
//            }
//            return (URLSession.AuthChallengeDisposition.performDefaultHandling, Optional.none);
//        }
        
         return manager
        
        // Create custom manager
//        // Without SSL Pinning
//        let manager1 = Alamofire.SessionManager(configuration: config, serverTrustPolicyManager: nil)
//        return manager1
        
    }()

    func call(type: EndPointType, params: Parameters? = nil, handler: @escaping (Result<[String: Any]>)-> Void) {
        self.sessionManager.request(type.url,
                                    method: type.httpMethod,
                                    parameters: params,
                                    encoding: type.encoding,
                                    headers: type.headers).validate().responseJSON{ response in
            
                                    switch response.result{
                
                                    case .success(let value as [String: Any]):
                                        handler(.success(value))
                                        break
                                    case .failure(_):
                                
                                        
                                        handler(.failure(self.parseApiError(data: response.data)))
                                        break
                                    default:
                                        fatalError("received non-dictionary JSON response")
                                        }
            }
        
        }
    
    // UAT
    let userCredential = URLCredential(user: "BBMintOak",
                                       password: "manage",
                                       persistence: .permanent)
    
    // LIVE
//    let userCredential = URLCredential(user: "BBMintOak",
//    password: "M!nt0@kB3",
//    persistence: .permanent)

   // URLCredentialStorage.shared.setDefaultCredential(userCredential, for: protectionSpace)
    func call<T>(type: EndPointType, params: Parameters? = nil, handler: @escaping (Result<T>) -> Void) where T: Codable {
        print("MY URL IS :: ",type.url)
        
        let delegate: Alamofire.SessionDelegate = self.sessionManager.delegate
               delegate.sessionDidReceiveChallenge = { session, challenge in
                    var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
                    var credential: URLCredential?
                    if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                         disposition = URLSession.AuthChallengeDisposition.useCredential
                         credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
                    } else {
                         if challenge.previousFailureCount > 0 {
                              disposition = .cancelAuthenticationChallenge
                         } else {
                            credential = self.userCredential
                          //  credential = self.sessionManager.session.configuration.urlCredentialStorage?.defaultCredential(for: challenge.protectionSpace)
                              if credential != nil {
                                   disposition = .useCredential
                              }
                         }
                    }
                return (disposition, credential)
               }

       
        self.sessionManager.request(type.url,
                                    method: type.httpMethod,
                                    parameters: params,
                                    encoding: type.encoding,
                                    headers: type.headers).validate().responseJSON { (data) in
                                        do {
                                            guard let jsonData = data.data else {
                                                throw AlertMessage(title: "Error", body: "No data")
                                            }
                                            if let string = String(bytes: jsonData, encoding: .utf8) {
                                                print("Byte Data :: \(string)")
                                            } else {
                                                print("not a valid UTF-8 sequence")
                                            }
                                            
                                            print(data.result)
                                            print("jsonData :: \(jsonData)")
                                            let result = try JSONDecoder().decode(T.self, from: jsonData)
                                            handler(.success(result))
                                            print("Result :: \(result)")
                                            self.resetNumberOfRetries()
                                        } catch {
                                            if let error = error as? AlertMessage {
                                                return handler(.failure(error))
                                            }

                                            handler(.failure(self.parseApiError(data: data.data)))
                                        }
        }
    }
    
    // MARK: - Private methods
    
    private func resetNumberOfRetries() {
        self.retrier.numberOfRetries = 0
    }
    
    private func parseApiError(data: Data?) -> AlertMessage {
        let decoder = JSONDecoder()
        if let jsonData = data, let error = try? decoder.decode(NetworkError.self, from: jsonData) {
            return AlertMessage(title: AppConstants.errorAlertTitle, body: error.key ?? error.message)
        }
        return AlertMessage(title: AppConstants.errorAlertTitle, body: AppConstants.genericErrorMessage)
    }
    
    // MARK: - Initialization
    
    init(sessionManager: SessionManager, retrier: APIManagerRetrier) {
        self.sessionManager = sessionManager
        self.retrier = retrier
        self.sessionManager.retrier = self.retrier
    }
    
}
extension Decodable {
    static func map(JSONString:String) -> Self? {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(Self.self, from: Data(from: JSONString.utf8))
        } catch let error {
            print(error)
            return nil
        }
    }
    init(from: Any) throws {
        let data = try JSONSerialization.data(withJSONObject: from, options: .prettyPrinted)
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:sszzz"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        self = try decoder.decode(Self.self, from: data)
    }

}
