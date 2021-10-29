//
//  Registration.swift
//  Burgan
//
//  Created by Malti Maurya on 17/04/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit
import Alamofire


struct PaymentTypes: Codable {
    let debit : [String]
    let credit :  [String]

    enum CodingKeys: String, CodingKey {
        case debit = "debit"
        case credit = "credit"
        
    }
}

struct AuthoriseUser: Codable {
    let cif, deviceID, deviceModel, deviceName: String

    enum CodingKeys: String, CodingKey {
        case cif
        case deviceID = "deviceId"
        case deviceModel, deviceName
    }
}

struct serviceProviderList: Codable {
    var name: String?
    var providerImg: String?
}

// MARK: - GetTnCData
struct GetTnCData: Codable {
    let status, message, errorCode, data: String?
}
