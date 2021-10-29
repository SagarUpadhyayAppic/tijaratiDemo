//
//  BulkPaymentInitiateApiModel.swift
//  Burgan
//
//  Created by Pratik on 26/07/21.
//  Copyright © 2021 1st iMac. All rights reserved.
//

import Foundation

struct BulkPaymentInitiateApi: Codable {
    var status: String?
    var message: String?
    var errorCode: String?
    var NoOfContacts: String?
    var BulkSmsRefId: String?
}

/*
 {"status":"Success","message":"Data Available","errorCode":"L128","NoOfContacts":"30","BulkSmsRefId":"100"}
 */
