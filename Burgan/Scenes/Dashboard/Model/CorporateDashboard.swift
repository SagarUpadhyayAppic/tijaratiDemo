//
//  CorporateDashboard.swift
//  Burgan
//
//  Created by Malti Maurya on 30/05/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import Foundation

// MARK: - corporateDashboard
struct corporateDashboardResponse: Codable {
    let contactless, errorCode, message: String?
    let saleDetails: [SaleDetails]?
    let settledAmount, status: String?
}

// MARK: - SaleDetails
struct SaleDetails: Codable {
    let ccAmount: String
    let ccCount: String
    let dcAmount: String
    let dcCount: String
    let domesticAmount: String
    let domesticCount: String
    let intlAmount: String
    let intlCount: String
    let totalAmount: String
    let totalCount: String

    enum CodingKeys: String, CodingKey {
        case ccAmount = "cc_Amount"
        case ccCount = "cc_Count"
        case dcAmount = "dc_Amount"
        case dcCount = "dc_Count"
        case domesticAmount = "domestic_Amount"
        case domesticCount = "domestic_Count"
        case intlAmount = "international_Amount"
        case intlCount = "international_Count"
        case totalAmount = "totalAmount"
        case totalCount = "totalCount"
    }
}



// MARK: - corporateSalesResp
struct corporateSalesResp: Codable {
    let status, message, errorCode: String?
    let saleDetails: [SaleDetailArr]?
}

// MARK: - SaleDetailArr
struct SaleDetailArr: Codable {
    let locationName, ccCount, ccAmount, dcCount: String?
    let dcAmount, domesticCount, domesticAmount, intlCount: String?
    let intlAmount, totalCount, totalAmount: String?

    enum CodingKeys: String, CodingKey {
        case locationName
        case ccCount = "cc_Count"
        case ccAmount = "cc_Amount"
        case dcCount = "dc_Count"
        case dcAmount = "dc_Amount"
        case domesticCount = "domestic_Count"
        case domesticAmount = "domestic_Amount"
        case intlCount = "international_Count"
        case intlAmount = "international_Amount"
        case totalCount = "totalCount"
        case totalAmount = "totalAmount"
    }
}
// MARK: - transactionsResp
struct transactionsResp: Codable {
    let status, message, errorCode, settledAmount: String?
    let totalCount, totalAmount, voidCount, voidAmount: String?
    let failedCount, failedAmount, refundCount, refundAmount: String?
    let ccCount, ccAmount, dcCount, dcAmount: String?
    let ddcCount, ddcAmount, idcCount, idcAmount: String?
    let dccCount, dccAmount, iccCount, iccAmount: String?

    let ecommAmount, ecommCount, othersAmount, othersCount: String?
    let posAmt, posTxnCount, posDebitCardAmt, posDebitCardTxnCount: String?
    let posInternationalAmt, posInternationalTxnCount, posDomesticAmt, posDomesticTxnCount: String?
    let ecommAmt, ecommTxnCount, ecommDebitCardAmt, ecommDebitCardTxnCount: String?
    let ecommInternationalAmt, ecommInternationalTxnCount, ecommDomesticAmt, ecommDomesticTxnCount: String?
    let eZPayAmt, eZPayTxnCount, eZPayDebitCardAmt, eZPayDebitCardTxnCount: String?
    let eZPayInternationalAmt, eZPayInternationalTxnCount, eZPayDomesticAmt, eZPayDomesticTxnCount: String?
    let inprogressCount, inprogressAmount, linkExpiredCount, linkExpiredAmount: String?
    let linkDeclinedCount, linkDeclinedAmount, allTransactionAmount: String?
    
    
    
    enum CodingKeys: String, CodingKey {
        case status, message, errorCode, settledAmount, totalCount, totalAmount, voidCount, voidAmount, failedCount
        case failedAmount = "failedAmount"
        case refundCount, refundAmount
        case ccCount = "cc_Count"
        case ccAmount = "cc_Amount"
        case dcCount = "dc_Count"
        case dcAmount = "dc_Amount"
        case ddcCount = "ddc_Count"
        case ddcAmount = "ddc_Amount"
        case idcCount = "idc_Count"
        case idcAmount = "idc_Amount"
        case dccCount = "dcc_Count"
        case dccAmount = "dcc_Amount"
        case iccCount = "icc_Count"
        case iccAmount = "icc_Amount"
        
        case ecommAmount = "ecomm_Amount"
        case ecommCount = "ecomm_Count"
        case othersAmount = "others_Amount"
        case othersCount = "others_Count"
        case posAmt, posTxnCount, posDebitCardAmt, posDebitCardTxnCount, posInternationalAmt, posInternationalTxnCount, posDomesticAmt, posDomesticTxnCount, ecommAmt, ecommTxnCount, ecommDebitCardAmt, ecommDebitCardTxnCount, ecommInternationalAmt, ecommInternationalTxnCount, ecommDomesticAmt, ecommDomesticTxnCount, eZPayAmt, eZPayTxnCount, eZPayDebitCardAmt, eZPayDebitCardTxnCount, eZPayInternationalAmt, eZPayInternationalTxnCount, eZPayDomesticAmt, eZPayDomesticTxnCount, inprogressCount, inprogressAmount, linkExpiredCount, linkExpiredAmount, linkDeclinedCount, linkDeclinedAmount, allTransactionAmount
    }
    
}


// MARK: - transactionDetailResp
struct transactionDetailResp: Codable {
    let status: String?
    let transaction: [Transaction]?
    let message, errorCode: String?
}

//// MARK: - Transaction
//struct Transaction: Codable {
//    let txnid, cardNum, network, amount: String?
//    let txnStatus: String?
//    let mobileNum: String?
//    let date: String?
//    let time: String?
//}

struct Transaction: Codable {
    let txnid: String?
    let cardNum: String?
    let network, amount, txnStatus, mobileNum: String?
    let date, time, isDomestic, location: String?
    let bulkSMSRefID: String?
    let paymentURL: String?
    let transactionDescription: String?
    let email: String?
    let payerName: String?

    enum CodingKeys: String, CodingKey {
        case txnid, cardNum, network, amount, txnStatus, mobileNum, date, time, isDomestic
        case location = "Location"
        case bulkSMSRefID = "bulkSmsRefId"
        case paymentURL
        case transactionDescription = "description"
        case email
        case payerName
    }
}

// MARK: - creditToBankResp
struct creditToBankResp: Codable {
    let status, message, errorCode: String?
    let locationCredit: [LocationCredit]?
}

// MARK: - LocationCredit
struct LocationCredit: Codable {
    let locationName, amount: String?
    let merchantList: [MerchantList]?
}

// MARK: - MerchantList
struct MerchantList: Codable {
    let mid: String?
    let splitAmount: [SplitAmount]?
}

// MARK: - SplitAmount
struct SplitAmount: Codable {
    let network, totalAmount, netAmount, refNo: String?
    let splitAmountMdr, mdr: String?

    enum CodingKeys: String, CodingKey {
        case network, totalAmount, netAmount, refNo
        case splitAmountMdr = " mdr"
        case mdr = "mdr"
    }
}


// MARK: - profileResp
struct profileResp: Codable {
    let status, message, errorCode, companyName: String
    let mobileNum, emailID, userCount: String
}


// MARK: - userListResp

struct userListResp: Codable {
    let status, message, errorCode: String
    let data: [userData]?
}

// MARK: - userData
struct userData: Codable {
    let userID, name, mobile, emailID: String?
    let status: String?
    let isViewEnabled, isReportsEnabled: String?
    let hierarchy: [Hierarchy]?
    let reportList: [String]?
}


// MARK: - performanceResp
struct performanceResp: Codable {
    let status, message, errorCode: String
    let performance: [Performance]
}

// MARK: - Performance
struct Performance: Codable {
    let txnCount, txnAmount, duration: String
}



// MARK: - transactionResp
struct transactionResp: Codable {
    let status, message, errorCode, settledAmount: String
    let totalCount, totalAmount, voidCount, voidAmount: String
    let failedCount, failedAmount, refundCount, refundAmount: String
    let ccCount, ccAmount, dcCount, dcAmount: String
    let ddcCount, ddcAmount, idcCount, idcAmount: String
    let dccCount, dccAmount, iccCount, iccAmount: String

    enum CodingKeys: String, CodingKey {
        case status, message, errorCode, settledAmount, totalCount, totalAmount, voidCount, voidAmount, failedCount
        case failedAmount = "failedAmount"
        case refundCount, refundAmount
        case ccCount = "cc_Count"
        case ccAmount = "cc_Amount"
        case dcCount = "dc_Count"
        case dcAmount = "dc_Amount"
        case ddcCount = "ddc_Count"
        case ddcAmount = "ddc_Amount"
        case idcCount = "idc_Count"
        case idcAmount = "idc_Amount"
        case dccCount = "dcc_Count"
        case dccAmount = "dcc_Amount"
        case iccCount = "icc_Count"
        case iccAmount = "icc_Amount"
    }
}


// MARK: - transactionCardDetailResp
struct transactionCardDetailResp: Codable {
    let status: String
    let transaction: [TransactionArr]
    let message, errorCode: String
}

// MARK: - Transaction
struct TransactionArr: Codable {
    let txnid, cardNum, network, amount: String
    let txnStatus: String
    let mobileNum: String?
    let dateTime: String
}


// MARK: - feeDetailResp
struct feeDetailResp: Codable {
    let status, deviceModel, installationFee, monthRent: String
    let transactionFeeKNET, transactionFeeOthers: String

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case deviceModel = "deviceModel"
        case installationFee = "installationFee"
        case monthRent = "monthRent"
        case transactionFeeKNET = "transactionFee_KNET"
        case transactionFeeOthers = "transactionFee_Others"
    }
}




// MARK: - performanceListResponse
struct performanceListResponse: Codable {
    let status, message, errorCode: String
    let performance: [PerformanceData]
}

// MARK: - PerformanceData
struct PerformanceData: Codable {
    let locationName: String
    let graphData: [GraphDatum]
}

// MARK: - GraphDatum
struct GraphDatum: Codable {
    let txnCount: String?
    let txnAmount, duration: String

    enum CodingKeys: String, CodingKey {
        case txnCount, txnAmount, duration
    }
}


// MARK: - GetAcceptTNCData
struct GetAcceptTNCData: Codable {
    let status, message, errorCode: String?
}
