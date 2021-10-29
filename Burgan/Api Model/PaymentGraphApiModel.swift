//
//  PaymentGraphApiModel.swift
//  Burgan
//
//  Created by Pratik on 23/07/21.
//  Copyright © 2021 1st iMac. All rights reserved.
//

import Foundation

struct PaymentGraphApi: Codable {
    var message: String?
    var errorCode: String?
    var status: String?
    var eZPayAvailableBalance: String?
    var eZPayTotalAmount: String?
    var eZPayExpireOn: String?
    var eZPayAvailableTransactionLimit: String?
    var eZPayTransactionLimit: String?
    var eZPayTransactionLimitExpireOn: String?
}

/*
 {"status":"Success","message":"Data Available","errorCode":"L128","eZPayAvailableBalance":"200.000","eZPayTotalAmount":"500.000","eZPayExpireOn":"02-08-2021","eZPayAvailableTransactionLimit":"200.00","eZPayTransactionLimit":"500.00","eZPayTransactionLimitExpireOn":"02-08-2021"}
 */
