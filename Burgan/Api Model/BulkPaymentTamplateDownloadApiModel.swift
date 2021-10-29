//
//  BulkPaymentTamplateDownloadApiModel.swift
//  Burgan
//
//  Created by Pratik on 22/07/21.
//  Copyright © 2021 1st iMac. All rights reserved.
//

import Foundation

//STRUCT
struct BulkTemplateDownloadApi: Codable {
    var message: String?
    var errorCode: String?
    var Base64: String?
}
