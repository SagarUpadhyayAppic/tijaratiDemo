//
//  RequestItems.swift


import Alamofire


// MARK: - Enums

enum NetworkEnvironment {
    case dev
    case production
    case stage
}

enum RequestItemsType {
    
    // MARK: Events
    case authoriseUser
    case authenticateUserV2
    case getKey
    case getTNC
    case getTNCar
    case acceptTnC
    case getServiceProvider
    case verifyOTP
    case resendOTP
    case forgetPIN
    case setPIN
    case VerifyUser
    case changePIN
    case verifyPIN
    case addUser
    case getUserList
    case modifyList
    case modifyUser
    case applyFilter
    case getDashboardData
    case getMerchantDashboardData
    case getSalesList
    case getPerformanceGraphContactlessTxn
    case getPerformanceGraphContactlessTxnMIDLevel
    case getPerformanceList
    case getContactLessList
    case getTransactionSummary
    case getTransactionDetails
    case getCreditToBankInfo
    case getTransactionReports
    case getSettlementReports
    case getCreditToBankReports
    case getProfile
    case getFeeDetails
    case fail
    case biometricUpdate
    case bulkPaymentTemplate
    case singlePaymentInitiate
    case bulkPaymentUpload
    case bulkPaymentInitiate
    case bulkTransaction
    case paymentSalesSummary
    case paymentSalesGraph
    case fileUploadHistory
  //  case events(_: String)
        
}

// MARK: - Extensions
// MARK: - EndPointType

extension RequestItemsType: EndPointType {
    
    // MARK: - Vars & Lets
    
    // UAT OLD
    
//    var baseURL: String {
//        switch Apimanager.networkEnviroment {
//        case .dev: return "https://mwextpp.burgan.com:9067/Burgan360API/v1/"
//        case .production: return "https://mwextpp.burgan.com/Burgan360API/v1/"
//        case .stage: return "https://mwextpp.burgan.com/Burgan360API/v1/"
//        }
//    }
    
    // UAT NEW
    // Updated UAT Base URL
    var baseURL: String {
        switch Apimanager.networkEnviroment {
        case .dev: return "https://mwextpp.burgan.com:9067/"
        case .production: return "https://mwextpp.burgan.com/"
        case .stage: return "https://mwextpp.burgan.com/"
        }
    }

    
    // LIVE

//    var baseURL: String {
//        switch Apimanager.networkEnviroment {
//        case .dev: return "https://mwext.burgan.com:9366/Burgan360API/v1/"
//        case .production: return "https://mwext.burgan.com:9366/Burgan360API/v1/"
//        case .stage: return "https://mwext.burgan.com:9366/Burgan360API/v1/"
//        }
//    }
    
    
    var burganApi: String{
        return "Burgan360API/v1/"
    }
    
    var tijaratiApi: String{
        return "TijaratiPay/v1/"
    }

    
    var version: String {
        return "/v0_1"
    }
    
    var path: String {
        switch self {
        case .authoriseUser :
            return burganApi + "authenticateUser/"
        case .authenticateUserV2 :
            return burganApi + "authenticateUserV2/"
        case .getServiceProvider :
            return burganApi + "serviceProvider/"
        case .verifyOTP :
            return burganApi + "verifyOTP"
        case .resendOTP :
            return burganApi + "resendOTP"
        case .setPIN :
            return burganApi + "setPIN"
        case .changePIN :
            return burganApi + "changePIN"
        case .verifyPIN :
            return burganApi + "verifyPIN"
        case .addUser :
            return burganApi + "addUser"
        case .getUserList :
            return burganApi + "userList"
        case .modifyList :
            return burganApi + "modifyList"
        case .modifyUser :
            return burganApi + "modifyUser"
        case .applyFilter :
            return burganApi + "filterAPI"
        case .getDashboardData :
            return burganApi + "dashboard"
        case .getMerchantDashboardData :
            return burganApi + "merchantDashboard"
        case .getSalesList :
            return burganApi + "saleCounterView"
        case .getPerformanceGraphContactlessTxn :
            return burganApi + "perfGraph"
        case .getPerformanceGraphContactlessTxnMIDLevel :
            return burganApi + "perfGraphMidLevel"
        case .getPerformanceList :
            return burganApi + "perfView"
        case .getContactLessList :
            return burganApi + "contactlessView"
        case .getTransactionSummary :
            return burganApi + "txnSummary"
        case .getTransactionDetails :
            return burganApi + "txnDetailsV2"
        case .getCreditToBankInfo :
            return burganApi + "creditToBank"
        case .getTransactionReports :
            return burganApi + "txnReports"
        case .getSettlementReports :
            return burganApi + "settlementReports"
        case .getCreditToBankReports :
            return burganApi + "creditToBankReports"
        case .getProfile :
            return burganApi + "profile"
        case .getFeeDetails :
            return burganApi + "feeDetails"
        case .fail :
            return burganApi + "fail"
        case .getKey:
            return burganApi + "getKey"
        case .forgetPIN:
            return burganApi + "forgetPIN"
        case .VerifyUser:
            return burganApi + "VerifyUser"
        case .getTNC:
            return burganApi + "getTnC?language=EN"
        case .getTNCar:
            return burganApi + "getTnC?language=AR"
        case .acceptTnC:
            return burganApi + "acceptTnC"
        case .biometricUpdate:
            return burganApi + "biometricUpdate"
        case .bulkPaymentTemplate:
            return tijaratiApi + "bulkpayment/template"
        case .singlePaymentInitiate:
            return tijaratiApi + "singlepayment/initiate"
        case .bulkPaymentUpload:
            return tijaratiApi + "bulkpayment/upload"
        case .bulkPaymentInitiate:
            return tijaratiApi + "bulkpayment/initiate"
        case .bulkTransaction:
            return tijaratiApi + "history"
        case .paymentSalesSummary:
            return tijaratiApi + "sale/summary"
        case .paymentSalesGraph:
            return tijaratiApi + "sale/graph"
        case .fileUploadHistory:
            return tijaratiApi + "fileUploadHistory"

        }
    }
    
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getKey :
            return .get
        case .getTNC :
            return .get
        case .getTNCar :
            return .get
        default:
            return .post
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
            
        default:
            // UAT
           let user = "BBMintOak"
           let password = "manage"
           
           // LIVE
//           let user = "BBMintOak"
//           let password = "M!nt0@kB3"
           
           let credentialData = "\(user):\(password)".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
           let base64Credentials = credentialData.base64EncodedString()

           return ["Authorization": "Basic \(base64Credentials)",
           "Accept": "application/json"]
        }
    }
    
    var url: URL {
        switch self {
        default:
            return URL(string: self.baseURL + self.path)!
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        default:
            return JSONEncoding.default
        }
    }
    
}

