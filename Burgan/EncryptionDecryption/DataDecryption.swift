//
//  DataDecrypter.swift
//  Burgan
//
//  Created by Malti Maurya on 29/04/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import Foundation
import CryptoSwift

class DataDecryption{
    


func decryption(jsonModel:PayloadRes) -> NSDictionary?  {
    
    let rawkey = Data(base64Encoded: DataEncryption.SKEY!)
    
    if let string = String(bytes: rawkey!, encoding: .utf8) {
        print("My RawKey :: \(string)")
    } else {
        print("not a valid UTF-8 sequence")
    }
    let iv = Data(base64Encoded: jsonModel.iv)
    do {
        
        let encryptedData = Data(base64Encoded: jsonModel.payload,options: .ignoreUnknownCharacters)
        let array: [UInt8] = Array(iv!)
        let keyArr: [UInt8] = Array(rawkey!)
        let gcm = GCM(iv: array, mode: .combined)
        let aes = try AES(key: keyArr, blockMode: gcm, padding: .iso78164)
        let decrypted = try aes.decrypt(encryptedData!.bytes)
        let decryptionString = String(bytes: decrypted, encoding: .utf8)
        if let data = decryptionString!.data(using: String.Encoding.utf8) {
    
            let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
            print(decryptionString!)
            return jsonDictionary!
        }
    } catch {
        print("decryption Failed Catch Block")
        print(error)
        print("decryption Failed Catch Block1")
    }
return nil
}
    


    func aesDecrypt(key:String,iv:String,payload:String) throws -> String {
        
        let decrypted = try AES(key: key, iv: iv, padding: .noPadding).decrypt([UInt8].init(base64: payload))
        return String(bytes: decrypted, encoding: .utf8)!
    }

}


