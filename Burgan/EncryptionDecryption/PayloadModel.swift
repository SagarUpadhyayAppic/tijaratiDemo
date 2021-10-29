//
//  PayloadModel.swift
//  Burgan
//
//  Created by Malti Maurya on 29/04/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import Foundation
struct PayloadReq: Codable {
    var iv, payload, key: String

    enum CodingKeys: String, CodingKey {
        case iv = "IV"
        case payload = "PAYLOAD"
        case key = "KEY"
    }
}
struct PayloadRes: Codable {
    let iv, payload: String

    enum CodingKeys: String, CodingKey {
        case iv = "IV"
        case payload = "PAYLOAD"
    }
}



