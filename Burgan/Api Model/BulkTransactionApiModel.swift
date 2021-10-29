//
//  BulkTransactionApiModel.swift
//  Burgan
//
//  Created by Pratik on 23/07/21.
//  Copyright © 2021 1st iMac. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct BulkPaymentTransactionApi: Codable {
    var status, message, errorCode: String?
    var transaction: [BulkPaymentTransactionData]?
}

// MARK: - Transaction
struct BulkPaymentTransactionData: Codable {
    let txnid, successContactCount, totalContactCount: String?
    let cardNum: String?
    let network, amount, txnStatus, mobileNum: String?
    let date, time: String?
    let isDomestic: String?
    let bulkSMSRefID: String?
    let paymentURL: String?
    let fileName, transactionDescription, email: String?
    let payerName: String?

    enum CodingKeys: String, CodingKey {
        case txnid, successContactCount, totalContactCount, cardNum, network, amount, txnStatus, mobileNum, date, time, isDomestic
        case bulkSMSRefID = "bulkSmsRefId"
        case paymentURL, fileName
        case transactionDescription = "description"
        case email
        case payerName
    }
}
