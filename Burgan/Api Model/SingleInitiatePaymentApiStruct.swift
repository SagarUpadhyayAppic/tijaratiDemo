//
//  SingleInitiatePaymentApiStruct.swift
//  Burgan
//
//  Created by Pratik on 23/07/21.
//  Copyright © 2021 1st iMac. All rights reserved.
//

import Foundation

//struct SinglePaymentInitiateApi: Codable {
//    var status: String?
//    var message: String?
//    var errorCode: String?
//    var cardNum: String?
//    var network: String?
//    var txnStatus: String?
//    var mobileNum: String?
//    var date: String?
//    var time: String?
//    var paymentURL: String?
//}

struct SinglePaymentInitiateApi: Codable {
    let status, message, errorCode, cardNum: String?
    let network, amount, txnStatus, mobileNum: String?
    let date, time, responseDescription: String?
    let paymentURL: String?

    enum CodingKeys: String, CodingKey {
        case status, message, errorCode, cardNum, network, amount, txnStatus, mobileNum, date, time
        case responseDescription = "description"
        case paymentURL
    }
}

/*
 new data
 {"status":"Success","message":"Data Available","errorCode":"L128","cardNum":"470350XXXXX4593","network":"eZPay","txnStatus":"SUCCESS","mobileNum":"99727738","date":"27-07-2021","time":"13:54:51","paymentURL":"https://pay.kn/2lpdx"}

 
 {"status":"Success","message":"Data Available","errorCode":"L128","
 txnid":"152891","cardNum":"470350XXXXX4593","network":"eZpay","amount":"29.000","txnStatus"
 :"SUCCESS","mobileNum":"88888888","date":"28-12-2020","time":"00:04:26" , “Description”:”Hi
 this is demo message”,,"PaymentURL":" https:// ottu/ezpaytransaction"}
 */
