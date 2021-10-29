//
//  BulkPaymentFileUploadApiModel.swift
//  Burgan
//
//  Created by Pratik on 26/07/21.
//  Copyright © 2021 1st iMac. All rights reserved.
//

import Foundation

struct BulkPaymentUploadFileApi: Codable {
    var status: String?
    var message: String?
    var errorCode: String?
    var filename: String?
    var UploadedTime: String?
    var NoOfContacts: String?
    var FileSize: String?
    var BulkSmsRefId: String?
}


/*
 {"status":"Success","message":"Data Available","errorCode":"L128","filename":"bulkTemplate1627023479.2362099.xlsx","UploadedTime":"10:15","NoOfContacts":"2","FileSize":"3.482","BulkSmsRefId":"TP2641021431"}
 */
