//
//  AppConstants.swift
//  Burgan
//
//  Created by 1st iMac on 13/03/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import Foundation
import LanguageManager_iOS

class AppConstants
{
    static let defaultAlertTitle = "warning"
    static let errorAlertTitle = "error"
    static let genericErrorMessage = "Something went wrong, please try again."
    static let APP_VERSION = "1.0"
//    static let startTime = "00:00:00"
//    static let endTime = "11:59:59"
    static let startTime = "00:00"
    static let endTime = "11:59"
    static var jsonStartDate = ""
    static var jsonEndDate = ""
    static var locationFilterData : LocationFilter?
    static var merchantNumber : [Int] = []
    static var selectedFilter : selectedFilterData?
    static var originalSelectFilter : selectedFilterData?
    static var isCif = false
    static var isFiltered = false
    static var language = LanguageManager.shared.currentLanguage
    static var ezpayOutletNumber = ""
    static var cifDataList: [CifData] = []
    static var cifCompanyName = ""
    
    internal struct UserData {
        static var deviceToken = "12345"
        static var token = ""
        static var appKey = ""
        static var cif = ""
        static var companyCIF = ""
        static var name = ""
        static var isDashboardEnabled = "0"
        static var isReportsEnabled = "0"
        static var merchantRole = ""
        static var deviceID = ""

      
        //        static var userProfile : User?
        //        static var userTutProfile : Tutors?
    }
    
    internal struct Category {
        //        static var categoryData = [Categories]()
    }
    
    static var isDeviceJailbroken: Bool {

        guard TARGET_IPHONE_SIMULATOR != 1 else { return false }

        // Check 1 : existence of files that are common for jailbroken devices
        if FileManager.default.fileExists(atPath: "/Applications/Cydia.app")
        || FileManager.default.fileExists(atPath: "/Library/MobileSubstrate/MobileSubstrate.dylib")
        || FileManager.default.fileExists(atPath: "/bin/bash")
        || FileManager.default.fileExists(atPath: "/usr/sbin/sshd")
        || FileManager.default.fileExists(atPath: "/etc/apt")
        || FileManager.default.fileExists(atPath: "/private/var/lib/apt/")
        || UIApplication.shared.canOpenURL(URL(string:"cydia://package/com.example.package")!) {

            return true
        }

        // Check 2 : Reading and writing in system directories (sandbox violation)
        let stringToWrite = "Jailbreak Test"
        do {
            try stringToWrite.write(toFile:"/private/JailbreakTest.txt", atomically:true, encoding:String.Encoding.utf8)
            // Device is jailbroken
            return true
        } catch {
            return false
        }
    }
    
    
}
