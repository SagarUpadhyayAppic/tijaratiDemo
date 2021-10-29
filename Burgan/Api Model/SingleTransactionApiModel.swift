//
//  SingleTransactionApiModel.swift
//  Burgan
//
//  Created by Pratik on 26/07/21.
//  Copyright © 2021 1st iMac. All rights reserved.
//

import Foundation

struct SingleTransactionApi: Codable {
    var status, message, errorCode: String?
    var transaction: [singlePaymentTransactionData]?
}

// MARK: - Transaction
struct singlePaymentTransactionData: Codable {
    let txnid: String?
    let cardNum: String?
    let network, amount, txnStatus, mobileNum: String?
    let date, time: String?
    let isDomestic: String?
    let bulkSMSRefID: String?
    let paymentURL: String?
    let transactionDescription: String?
    let email: String?
    let payerName: String?

    enum CodingKeys: String, CodingKey {
        case txnid, cardNum, network, amount, txnStatus, mobileNum, date, time, isDomestic
        case bulkSMSRefID = "bulkSmsRefId"
        case paymentURL
        case transactionDescription = "description"
        case email
        case payerName
    }
}
