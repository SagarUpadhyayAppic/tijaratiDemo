//
//  PaymentSalesSummaryApiModel.swift
//  Burgan
//
//  Created by Pratik on 23/07/21.
//  Copyright © 2021 1st iMac. All rights reserved.
//

import Foundation

struct PaymentSalesSummaryApi: Codable {
    var message: String?
    var errorCode: String?
    var status: String?
    var ezPayTotalAmount: String?
    var ezPayTotalTxnCount: String?
    var ezPayDebitAmt: String?
    var ezPayDebitTxnCount: String?
    var ezPayCreditAmt: String?
    var ezPayCreditTxnCount: String?
}

/*
 {"status":"Success","message":"Data Available","errorCode":"L128","ezPayTotalAmount":"200.000","ezPayTotalTxnCount":"12","ezPayDebitAmt":"400.000","ezPayDebitTxnCount":"40","ezPayCreditAmt":"400.000","ezPayCreditTxnCount":"20"}
 */
