//
//  LoactionFilter.swift
//  Burgan
//
//  Created by Malti Maurya on 28/05/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//


import Foundation

// MARK: - AppKey
struct LocationFilter: Codable {
    let status, message, errorCode: String
    let filterData: [FilterDatum]
}

// MARK: - FilterDatum
struct FilterDatum: Codable {
    let cif, companyName: String
    let accountList, brandList, locationList: [String]
    var hierarchy: [Hierarchy]
    let ezpayOutletNumber: String

    enum CodingKeys: String, CodingKey {
        case cif = "Cif"
        case companyName, accountList, brandList, locationList, hierarchy
        case ezpayOutletNumber = "EzpayOutletNumber"
    }
}


struct selectedFilterData
{
    var companyName : String
    var cif : String
    var selectedAccounts : [String]
    var selectedBrands : [String]
    var selectedLocations : [String]
    var selectedMerchants : [Int]
    var selectedHeirarchy : [Hierarchy]
    
    init(companyName : String, selectedAccounts : [String], selectedBrands : [String], selectedLocations : [String], cif : String, selectedMerchants : [Int], hiearchy : [Hierarchy]) {
        self.companyName = companyName
        self.selectedAccounts = selectedAccounts
        self.selectedBrands = selectedBrands
        self.selectedLocations = selectedLocations
        self.cif = cif
        self.selectedMerchants = selectedMerchants
        self.selectedHeirarchy = hiearchy
    }
}

struct CifData {
    var cif: String
    var companyName: String
    var ezpayOutletNumber: String
}

// MARK: - Hierarchy
struct Hierarchy: Codable {
    let accountNumber: String
    let brandNameList: [BrandNameList]
}

// MARK: - BrandNameList
struct BrandNameList: Codable {
    let brandName: String
    let locationNameList: [LocationNameList]
}

//// MARK: - LocationNameList
//struct LocationNameList: Codable {
//    let locationName: String
//    let merchantNumber: [MerchantNumber]
//}

// MARK: - LocationNameList
struct LocationNameList: Codable {
    var locationName: String
    var merchantNumber: [MerchantNumber]
    
    init(locationName : String, merchantNumber : [MerchantNumber]) {
        self.locationName = locationName
        self.merchantNumber = merchantNumber
    }
}

// MARK: - MerchantNumber
struct MerchantNumber: Codable {
    let mid: String
    let outletNumber: [String]
}

