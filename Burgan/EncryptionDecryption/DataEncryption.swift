    //
    //  DataEncrypter.swift
    //  Burgan
    //
    //  Created by Malti Maurya on 29/04/20.
    //  Copyright © 2020 1st iMac. All rights reserved.
    //
    import UIKit
    import CryptoSwift
    import SwiftyRSA


    
    class DataEncryption{
        
        var SIV  = ""
        static var SKEY : String?
        var payload : PayloadReq?
        
        func encryption(str:String)-> PayloadReq?
        {
            let key = randomString(length: 16)
            print("Random Key length : \(key.count)")
            print("Random Key : \(key)")
//            let key = "BNqhat0czqZM3lm3"
            let iv = randomString(length: AES.blockSize)
            do {

                let gcm = GCM(iv: iv.bytes, mode: .combined)
                let aes = try AES(key: key.bytes, blockMode: gcm, padding: .iso78164)
                let encrypted = try aes.encrypt(str.bytes)
                DataEncryption.SKEY = key.base64Encoded()
                print("Random Key base64Encoded : \(DataEncryption.SKEY ?? "")")
                SIV = iv.base64Encoded()!
                let encrtptedSessionKey = rsaEncrypt(rawKey: key)
         
                let data = Data(bytes: encrypted, count: encrypted.count)

                payload = PayloadReq(iv
                    : iv.base64Encoded()!, payload:data.base64EncodedString(), key:encrtptedSessionKey)
                
                
            } catch {
                print(error)
            }
            print(payload)
            return payload
        }
        func generateRandomBytes() -> Data {

            var keyData = Data(count: 32)
            let result = keyData.withUnsafeMutableBytes {
                (mutableBytes: UnsafeMutablePointer<UInt8>) -> Int32 in
                SecRandomCopyBytes(kSecRandomDefault, 32, mutableBytes)
            }
            if result == errSecSuccess {
                //return keyData.base64EncodedString()
                return keyData
            } else {
                print("Problem generating random bytes")
                return Data()
            }
        }
        func rsaEncrypt(rawKey : String) -> String
        {
            var encryptedSessionKey :String = ""
            do {


                let publicKey = try PublicKey(base64Encoded: AppConstants.UserData.appKey)
                print(try publicKey.base64String())
                  let privateKey = try PrivateKey(derNamed: "privateKey")
                print(try privateKey.base64String())
                let clear = try ClearMessage(string: rawKey, using: .utf8)
                   let encrypted = try clear.encrypted(with: publicKey, padding: .OAEP)

                   // Then you can use:
                   let base64String = encrypted.base64String
                       print(base64String)
                encryptedSessionKey = base64String

                     
                       let encryptedmsg = try EncryptedMessage(base64Encoded:base64String)
                       let decrp = try encryptedmsg.decrypted(with: privateKey, padding: .OAEP)

                       // Then you can use:
                       let stringg = try decrp.string(encoding: .utf8)
                       print(stringg)
                   // Do any additional setup after loading the view.
                   }catch{
                       print(error)
                   }
            return encryptedSessionKey
        }
    
        
        func aesEncrypt(key: String, iv: String,str:String) throws -> String {
            let data = str.data(using: String.Encoding.utf8)
            let encrypted = try AES(key: key, iv: iv, padding: .noPadding).encrypt((data?.bytes)!)
            let encData = Data(bytes: encrypted, count: encrypted.count)
            let base64str = encData.base64EncodedString(options: .init(rawValue: 0))
            let result = String(base64str)
            return result
        }
        
        func encryptRsaBase64(_ string: String, withPublickKeyBase64: String) -> String? {
            if let data = string.data(using: .utf8) {
                if let encrypted = RSA.encryptWithRSAPublicKey(data, pubkeyBase64: withPublickKeyBase64, keychainTag: "") {
                    return encrypted.base64EncodedString()
                }
            }
            return nil
        }
        
        /*
        func randomString(length: Int) -> String {
            
            let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            let len = UInt32(letters.length)
            
            var randomString = ""
            
            for _ in 0 ..< length {
                let rand = arc4random_uniform(len)
                var nextChar = letters.character(at: Int(rand))
                randomString += NSString(characters: &nextChar, length: 1) as String
            }
            
            return randomString
        }
        */
        
        func randomString(length: Int) -> String {
          let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
          return String((0..<length).map{ _ in letters.randomElement()! })
        }
        
        
    }
    extension Data {
        func castToCPointer<T>() -> T {
            return self.withUnsafeBytes { $0.pointee }
        }
    }
    extension String {

          func base64Encoded() -> String? {
                if let data = self.data(using: .utf8) {
                    return data.base64EncodedString()
                }
                return nil
            }

        //: ### Base64 decoding a string
            func base64Decoded() -> String? {
                if let data = Data(base64Encoded: self) {
                    return String(data: data, encoding: .utf8)
                }
                return nil
            }

    }
