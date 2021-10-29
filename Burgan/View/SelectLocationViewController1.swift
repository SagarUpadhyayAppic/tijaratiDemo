//
//  ServiceProviderController.swift
//  Burgan
//
//  Created by Malti Maurya on 19/03/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit
//import  ExpyTableView
//protocol sectionCollapseDelegate:class {
//    func sectionCollapse(sender:tbLocationHeaderCell)
//}
protocol selectLocationMerchantDelegate : class {
    func selectMerchantLoaction(account : [String], brand : [String], location : [String])
}
class SelectLocationViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,selectLocationMerchantDelegate {
    
    /*
    func selectMerchantLoaction(account : [String], brand : [String], location : [String]) {
        let priorityNo : Int = UserDefaults.standard.value(forKey: "priorityNo") as! Int
        merchantNumbers.removeAll()
        if account.count > 0
        {
            
            if priorityNo == 1
            {
                
                
                SelectLocationViewController.selectedfinalBrand.removeAll()
                SelectLocationViewController.selectedfinalLocation.removeAll()
                SelectLocationViewController.selectedfinalAcc = account
                
                for i in 0..<selectedHeirarchy.count
                {
                    for j in 0..<account.count
                    {
                        if account[j] == selectedHeirarchy[i].accountNumber
                        {
                            
                            for k in 0..<selectedHeirarchy[j].brandNameList.count
                            {
                                SelectLocationViewController.selectedfinalBrand.append(selectedHeirarchy[j].brandNameList[k].brandName)
                                SelectLocationViewController.selectedfinalLocation.append(contentsOf: selectedHeirarchy[j].brandNameList[k].locationNameList.map{$0.locationName})
                                
                                for l in 0..<selectedHeirarchy[j].brandNameList[k].locationNameList.count
                                {
                                    for m in 0..<selectedHeirarchy[j].brandNameList[k].locationNameList[l].merchantNumber.count
                                    {
                                        merchantNumbers.append(Int(selectedHeirarchy[j].brandNameList[k].locationNameList[l].merchantNumber[m].mid)!)
                                    }
//                                    merchantNumbers.append(contentsOf: selectedHeirarchy[j].brandNameList[k].locationNameList[l].merchantNumber.map{$0.mid})
                                }
                            }
                            
                        }
                        
                    }
                }
                
                originalBrands =  Array(Set(SelectLocationViewController.selectedfinalBrand))
                originalLocations = Array(Set(SelectLocationViewController.selectedfinalLocation))
                
                
                
            }else if priorityNo == 2 {
                
                SelectLocationViewController.selectedfinalAcc = account
                let priorityOneName = UserDefaults.standard.value(forKey: "priorityOne") as! String
                if priorityOneName == "b"
                {
                    
                    let brandlist =  SelectLocationViewController.selectedfinalBrand
                    SelectLocationViewController.selectedfinalLocation.removeAll()
                    for i in 0..<selectedHeirarchy.count
                    {
                        for j in 0..<selectedHeirarchy[i].brandNameList.count
                        {
                            let b = brandlist.filter{$0 == selectedHeirarchy[i].brandNameList[j].brandName}
                            if b.count > 0
                            {
                                SelectLocationViewController.selectedfinalLocation.append(contentsOf: selectedHeirarchy[i].brandNameList[j].locationNameList.map{$0.locationName})
                                
                            }
                        }
                        
                    }
                    
                }else if priorityOneName == "l"
                {
                    SelectLocationViewController.selectedfinalBrand.removeAll()
                    let locationlist = SelectLocationViewController.selectedfinalLocation
                    for i in 0..<selectedHeirarchy.count
                    {
                        for j in 0..<selectedHeirarchy[i].brandNameList.count
                        {
                            for k in 0..<selectedHeirarchy[i].brandNameList[j].locationNameList.count
                            {
                                let l = locationlist.filter{$0 == selectedHeirarchy[i].brandNameList[j].locationNameList[k].locationName}
                                if l.count > 0
                                {
                                    SelectLocationViewController.selectedfinalBrand.append(selectedHeirarchy[i].brandNameList[j].brandName)
                                }
                            }
                        }
                    }
                }else{
                    print(priorityOneName)
                }
                
                
            }else{
                
                SelectLocationViewController.selectedfinalAcc = account
            }
        }else if brand.count > 0
        {
            if priorityNo == 1
            {
                SelectLocationViewController.selectedfinalBrand = brand
                SelectLocationViewController.selectedfinalLocation.removeAll()
                SelectLocationViewController.selectedfinalAcc.removeAll()
                for i in 0..<selectedHeirarchy.count
                {
                    for j in 0..<brand.count
                    {
                        let b : [BrandNameList] = selectedHeirarchy[i].brandNameList.filter{$0.brandName == brand[j]}
                        if b.count > 0
                        {
                            SelectLocationViewController.selectedfinalAcc.append(selectedHeirarchy[i].accountNumber)
                            for k in 0..<b.count
                            {
                                SelectLocationViewController.selectedfinalLocation.append(contentsOf: b[k].locationNameList.map{$0.locationName})
                                
                            }
                            
                            
                        }
                    }
                }
                
                originalLocations = Array(Set(SelectLocationViewController.selectedfinalLocation))
                originalAccounts = Array(Set(SelectLocationViewController.selectedfinalAcc))
                
            }else if priorityNo == 2
            {
                SelectLocationViewController.selectedfinalBrand = brand
                let priorityOneName = UserDefaults.standard.value(forKey: "priorityOne") as! String
                if priorityOneName == "a"
                {
                    SelectLocationViewController.selectedfinalLocation.removeAll()
                    let accountlist = SelectLocationViewController.selectedfinalAcc
                    for i in 0..<selectedHeirarchy.count
                    {
                        let a = accountlist.filter{$0 == selectedHeirarchy[i].accountNumber}
                        if a.count > 0
                        {
                            for j in 0..<selectedHeirarchy[i].brandNameList.count
                            {
                                let b = brand.filter{$0 == selectedHeirarchy[i].brandNameList[j].brandName}
                                if b.count > 0
                                {
                                    SelectLocationViewController.selectedfinalLocation.append(contentsOf: selectedHeirarchy[i].brandNameList[j].locationNameList.map{$0.locationName})
                                }
                            }
                        }
                        
                    }
                    
                    
                }else if priorityOneName == "l"
                {
                    SelectLocationViewController.selectedfinalAcc.removeAll()
                    let locationList = SelectLocationViewController.selectedfinalLocation
                    for i in 0..<selectedHeirarchy.count
                    {
                        for j in 0..<selectedHeirarchy[i].brandNameList.count
                        {
                            let b = brand.filter{$0 == selectedHeirarchy[i].brandNameList[j].brandName}
                            if b.count > 0
                            {
                                for k in 0..<selectedHeirarchy[i].brandNameList[j].locationNameList.count
                                {
                                    let l = locationList.filter{$0 == selectedHeirarchy[i].brandNameList[j].locationNameList[k].locationName}
                                    if l.count > 0
                                    {
                                        SelectLocationViewController.selectedfinalAcc.append(selectedHeirarchy[i].accountNumber)
                                    }
                                    
                                }
                                
                            }
                            
                        }}
                }
                
            }else{
                SelectLocationViewController.selectedfinalBrand = brand
            }
            
        }else if location.count > 0
        {
            if priorityNo == 1
            {
                SelectLocationViewController.selectedfinalBrand.removeAll()
                SelectLocationViewController.selectedfinalLocation = location
                SelectLocationViewController.selectedfinalAcc.removeAll()
                
                for i in 0..<selectedHeirarchy.count
                {
                    
                    for j in 0..<selectedHeirarchy[i].brandNameList.count
                    {
                        for k in 0..<location.count
                        {
                            let l : [LocationNameList] = selectedHeirarchy[i].brandNameList[j].locationNameList.filter{$0.locationName == location[k]}
                            if l.count > 0
                            {
                                SelectLocationViewController.selectedfinalBrand.append(selectedHeirarchy[i].brandNameList[j].brandName)
                                SelectLocationViewController.selectedfinalAcc.append(selectedHeirarchy[i].accountNumber)
                            }
                        }
                        
                    }
                }
                
                originalBrands = Array(Set(SelectLocationViewController.selectedfinalBrand))
                originalAccounts = Array(Set(SelectLocationViewController.selectedfinalAcc))
                
                
            }else if priorityNo == 2
            {
                
                SelectLocationViewController.selectedfinalLocation = location
                let priorityOneName = UserDefaults.standard.value(forKey: "priorityOne") as! String
                if priorityOneName == "a"
                {
                    SelectLocationViewController.selectedfinalBrand.removeAll()
                    let accountlist = SelectLocationViewController.selectedfinalAcc
                    for i in 0..<selectedHeirarchy.count
                    {
                        let a = accountlist.filter{$0 == selectedHeirarchy[i].accountNumber}
                        if a.count > 0
                        {
                            for j in 0..<selectedHeirarchy[i].brandNameList.count
                            {
                                for k in 0..<selectedHeirarchy[i].brandNameList[j].locationNameList.count{
                                    let l = location.filter{$0 == selectedHeirarchy[i].brandNameList[j].locationNameList[k].locationName}
                                    if l.count > 0
                                    {
                                        SelectLocationViewController.selectedfinalBrand.append(selectedHeirarchy[i].brandNameList[j].brandName)
                                    }
                                    
                                }
                            }
                        }
                    }
                    
                }else if priorityOneName == "b"
                {
                    SelectLocationViewController.selectedfinalAcc.removeAll()
                    let brandlist = SelectLocationViewController.selectedfinalBrand
                    for i in 0..<selectedHeirarchy.count
                    {
                        for j in 0..<selectedHeirarchy[i].brandNameList.count
                        {
                            let b = brandlist.filter{$0 == selectedHeirarchy[i].brandNameList[j].brandName}
                            if b.count > 0
                            {
                                SelectLocationViewController.selectedfinalAcc.append(selectedHeirarchy[i].accountNumber)
                            }
                        }
                    }
                    
                }
                
            }else{
                SelectLocationViewController.selectedfinalLocation = location
            }
        }else{
            print("errrr")
        }
        
        for i in 0..<selectedHeirarchy.count
        {
            for j in 0..<selectedHeirarchy[i].brandNameList.count
            {
                if SelectLocationViewController.selectedfinalLocation.count > 0
                {
                    for k in 0..<selectedHeirarchy[i].brandNameList[j].locationNameList.count
                    {
                        let l = SelectLocationViewController.selectedfinalLocation.filter{$0 == selectedHeirarchy[i].brandNameList[j].locationNameList[k].locationName}
                        if l.count > 0
                        {
                            for m in 0..<selectedHeirarchy[i].brandNameList[j].locationNameList[k].merchantNumber.count
                            {
                                let m : Int = Int(selectedHeirarchy[i].brandNameList[j].locationNameList[k].merchantNumber[m].mid)!
                                merchantNumbers.append(m)
                            }
                        }
                    }
                }
            }
        }
        AppConstants.merchantNumber = merchantNumbers
        SelectLocationViewController.selectedfinalBrand = Array(Set(SelectLocationViewController.selectedfinalBrand))
        SelectLocationViewController.selectedfinalLocation = Array(Set(SelectLocationViewController.selectedfinalLocation))
        /*
        if UserDefaults.standard.value(forKey: "priorityOne") != nil
        {
            if UserDefaults.standard.value(forKey: "priorityOne") as? String ?? "" == "b"
            {
                lblAccntNumbrCount.text = String(SelectLocationViewController.selectedfinalAcc.count)
                lblBrandCount.text = String(originalBrands.count)
                lblLocationCountView.text = String(SelectLocationViewController.selectedfinalLocation.count)
                       
            } else if UserDefaults.standard.value(forKey: "priorityOne") as? String ?? "" == "a"
            {
                lblAccntNumbrCount.text = String(originalAccounts.count)
                lblBrandCount.text = String(SelectLocationViewController.selectedfinalBrand.count)
                lblLocationCountView.text = String(SelectLocationViewController.selectedfinalLocation.count)
                    
            } else {
                lblAccntNumbrCount.text = String(SelectLocationViewController.selectedfinalAcc.count)
                lblBrandCount.text = String(SelectLocationViewController.selectedfinalBrand.count)
                lblLocationCountView.text = String(originalLocations.count)
                    
            }
        }
        */
        
        lblAccntNumbrCount.text = String(originalAccounts.count)
        lblBrandCount.text = String(originalBrands.count)
        lblLocationCountView.text = String(originalLocations.count)
        
       
        selectedFilter = selectedFilterData(companyName: selectFilterData!.companyName, selectedAccounts: SelectLocationViewController.selectedfinalAcc, selectedBrands: SelectLocationViewController.selectedfinalBrand, selectedLocations: SelectLocationViewController.selectedfinalLocation, cif: selectFilterData!.cif, selectedMerchants: AppConstants.merchantNumber, hiearchy: selectedHeirarchy)
        cvCompanyLocationList.reloadData()
    }
    
    */
    
    
//    From below function if you wanna remove then remove only //maltiiii code
    /*
    func selectMerchantLoaction(account : [String], brand : [String], location : [String]) {
        let priorityNo : Int = UserDefaults.standard.value(forKey: "priorityNo") as! Int
        merchantNumbers.removeAll()
        if account.count > 0
        {
            
            if priorityNo == 1
            {

                SelectLocationViewController.selectedfinalBrand.removeAll()
                SelectLocationViewController.selectedfinalLocation.removeAll()
                SelectLocationViewController.selectedfinalAcc = account
                
                for i in 0..<selectedHeirarchy.count
                {
                    for j in 0..<account.count
                    {
                        if account[j] == selectedHeirarchy[i].accountNumber
                        {
                            
                            for k in 0..<selectedHeirarchy[j].brandNameList.count
                            {
                                SelectLocationViewController.selectedfinalBrand.append(selectedHeirarchy[j].brandNameList[k].brandName)
                                SelectLocationViewController.selectedfinalLocation.append(contentsOf: selectedHeirarchy[j].brandNameList[k].locationNameList.map{$0.locationName})
                                
                                for l in 0..<selectedHeirarchy[j].brandNameList[k].locationNameList.count
                                {
                                    for m in 0..<selectedHeirarchy[j].brandNameList[k].locationNameList[l].merchantNumber.count
                                    {
                                        merchantNumbers.append(Int(selectedHeirarchy[j].brandNameList[k].locationNameList[l].merchantNumber[m].mid)!)
                                    }
                                    //                                    merchantNumbers.append(contentsOf: selectedHeirarchy[j].brandNameList[k].locationNameList[l].merchantNumber.map{$0.mid})
                                }
                            }
                            
                        }
                        
                    }
                    
                }
                
                originalBrands =  Array(Set(SelectLocationViewController.selectedfinalBrand))
                originalLocations = Array(Set(SelectLocationViewController.selectedfinalLocation))
            }else if priorityNo == 2
            {
                SelectLocationViewController.selectedfinalAcc = account
                let priorityOneName = UserDefaults.standard.value(forKey: "priorityOne") as! String
                if priorityOneName == "b"
                {
                    
                    let brandlist =  SelectLocationViewController.selectedfinalBrand
                    SelectLocationViewController.selectedfinalLocation.removeAll()
                    for i in 0..<selectedHeirarchy.count
                    {
                        let a = account.filter{$0 == selectedHeirarchy[i].accountNumber}
                        if a.count > 0
                        {
                            for k in 0..<selectedHeirarchy[i].brandNameList.count
                                                   {
                                                       let b = brandlist.filter{$0 == selectedHeirarchy[i].brandNameList[k].brandName}
                                                       if b.count > 0
                                                       {
                                                           SelectLocationViewController.selectedfinalLocation.append(contentsOf: selectedHeirarchy[i].brandNameList[k].locationNameList.map{$0.locationName})
                                                           
                                                       }
                                                   }
                        }
                       
                        
                    }
                    
                }else if priorityOneName == "l"
                {
                    SelectLocationViewController.selectedfinalBrand.removeAll()
                    let locationlist = SelectLocationViewController.selectedfinalLocation
                    for i in 0..<selectedHeirarchy.count
                    {
                        let a = account.filter{$0 == selectedHeirarchy[i].accountNumber}
                        if a.count > 0
                        {
                            for j in 0..<selectedHeirarchy[i].brandNameList.count
                            {
                                for k in 0..<selectedHeirarchy[i].brandNameList[j].locationNameList.count
                                {
                                    let l = locationlist.filter{$0 == selectedHeirarchy[i].brandNameList[j].locationNameList[k].locationName}
                                    if l.count > 0
                                    {
                                        SelectLocationViewController.selectedfinalBrand.append(selectedHeirarchy[i].brandNameList[j].brandName)
                                    }
                                }
                            }
                        }
                        
                    }
                }else{
                    print(priorityOneName)
                }
                
                
            }else{
              
                //SelectLocationViewController.selectedfinalAcc = account
                
                //maltiiiiii
                let brandArray : [String] =  SelectLocationViewController.selectedfinalBrand

                let locationArray : [String] = SelectLocationViewController.selectedfinalLocation
                
                for i in 0..<selectedHeirarchy.count
                            {
                                let a = account.filter{$0 == selectedHeirarchy[i].accountNumber}
                                if a.count > 0
                                {
                                    
                                    for j in 0..<selectedHeirarchy[i].brandNameList.count
                                    {
                                        let b = brandArray.filter{$0 == selectedHeirarchy[i].brandNameList[j].brandName}
                                        if b.count > 0
                                        {
                                            for k in 0..<selectedHeirarchy[i].brandNameList[j].locationNameList.count
                                            {
                                                let l = locationArray.filter{$0 == selectedHeirarchy[i].brandNameList[j].locationNameList[k].locationName}
                                                if l.count > 0
                                                {
                                                    for m in 0..<selectedHeirarchy[i].brandNameList[j].locationNameList[k].merchantNumber.count
                                                    {
                                                        let merchant = selectedHeirarchy[i].brandNameList[j].locationNameList[k].merchantNumber[m].mid
                                                        merchantNumbers.append(Int(merchant)!)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    
                                    
                                }
                            }
                
                SelectLocationViewController.selectedfinalAcc = account
                
                //maltiiiiii
            }
        }else if brand.count > 0
        {
            if priorityNo == 1
            {
                SelectLocationViewController.selectedfinalBrand = brand
                SelectLocationViewController.selectedfinalLocation.removeAll()
                SelectLocationViewController.selectedfinalAcc.removeAll()
                for i in 0..<selectedHeirarchy.count
                {
                    for j in 0..<brand.count
                    {
                        let b : [BrandNameList] = selectedHeirarchy[i].brandNameList.filter{$0.brandName == brand[j]}
                        if b.count > 0
                        {
                            SelectLocationViewController.selectedfinalAcc.append(selectedHeirarchy[i].accountNumber)
                            for k in 0..<b.count
                            {
                                SelectLocationViewController.selectedfinalLocation.append(contentsOf: b[k].locationNameList.map{$0.locationName})
                                
                            }

                        }
                    }
                }
                
                
                
                originalAccounts = Array(Set(SelectLocationViewController.selectedfinalAcc))
                originalLocations  = Array(Set(SelectLocationViewController.selectedfinalLocation))
                
            }else if priorityNo == 2
            {
                SelectLocationViewController.selectedfinalBrand = brand
                let priorityOneName = UserDefaults.standard.value(forKey: "priorityOne") as! String
                if priorityOneName == "a"
                {
                    SelectLocationViewController.selectedfinalLocation.removeAll()
                    let accountlist = SelectLocationViewController.selectedfinalAcc
                    for i in 0..<selectedHeirarchy.count
                    {
                        let a = accountlist.filter{$0 == selectedHeirarchy[i].accountNumber}
                        if a.count > 0
                        {
                            for j in 0..<selectedHeirarchy[i].brandNameList.count
                            {
                                let b = brand.filter{$0 == selectedHeirarchy[i].brandNameList[j].brandName}
                                if b.count > 0
                                {
                                    SelectLocationViewController.selectedfinalLocation.append(contentsOf: selectedHeirarchy[i].brandNameList[j].locationNameList.map{$0.locationName})
                                }
                            }
                        }
                        
                    }
                    
                } else if priorityOneName == "l" {
                    SelectLocationViewController.selectedfinalAcc.removeAll()
                    let locationList = SelectLocationViewController.selectedfinalLocation
                    for i in 0..<selectedHeirarchy.count
                    {
                        for j in 0..<selectedHeirarchy[i].brandNameList.count
                        {
                            let b = brand.filter{$0 == selectedHeirarchy[i].brandNameList[j].brandName}
                            if b.count > 0
                            {
                                for k in 0..<selectedHeirarchy[i].brandNameList[j].locationNameList.count
                                {
                                    let l = locationList.filter{$0 == selectedHeirarchy[i].brandNameList[j].locationNameList[k].locationName}
                                    if l.count > 0
                                    {
                                        SelectLocationViewController.selectedfinalAcc.append(selectedHeirarchy[i].accountNumber)
                                    }
                                }
                            }
                        }}
                }
                
            } else {
                
                // SelectLocationViewController.selectedfinalBrand = brand
                
                //maltiii
                let accountArray = SelectLocationViewController.selectedfinalAcc
                let locationArray = SelectLocationViewController.selectedfinalLocation
                
                for i in 0..<selectedHeirarchy.count
                {
                    let a = accountArray.filter{$0 == selectedHeirarchy[i].accountNumber}
                    if a.count > 0
                    {
                        for j in 0..<selectedHeirarchy[i].brandNameList.count
                        {
                            let b = brand.filter{$0 == selectedHeirarchy[i].brandNameList[j].brandName}
                            if b.count > 0
                            {
                                for k in 0..<selectedHeirarchy[i].brandNameList[j].locationNameList.count
                                {
                                    let l = locationArray.filter{$0 == selectedHeirarchy[i].brandNameList[j].locationNameList[k].locationName}
                                    if l.count > 0
                                    {
                                        for m in 0..<selectedHeirarchy[i].brandNameList[j].locationNameList[k].merchantNumber.count
                                        {
                                            
                                            let merchant = selectedHeirarchy[i].brandNameList[j].locationNameList[k].merchantNumber[m].mid
                                            merchantNumbers.append(Int(merchant)!)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                SelectLocationViewController.selectedfinalBrand = brand
                //maltiiiii
            }
            
        }else if location.count > 0
        {
            if priorityNo == 1
            {
                SelectLocationViewController.selectedfinalBrand.removeAll()
                SelectLocationViewController.selectedfinalLocation = location
                SelectLocationViewController.selectedfinalAcc.removeAll()
                
                for i in 0..<selectedHeirarchy.count
                {
                    for j in 0..<selectedHeirarchy[i].brandNameList.count
                    {
                        for k in 0..<location.count
                        {
                            let l : [LocationNameList] = selectedHeirarchy[i].brandNameList[j].locationNameList.filter{$0.locationName == location[k]}
                            if l.count > 0
                            {
                                SelectLocationViewController.selectedfinalBrand.append(selectedHeirarchy[i].brandNameList[j].brandName)
                                SelectLocationViewController.selectedfinalAcc.append(selectedHeirarchy[i].accountNumber)
                            }
                        }
                        
                    }
                }
                
                originalAccounts = Array(Set(SelectLocationViewController.selectedfinalAcc))
                originalBrands  = Array(Set(SelectLocationViewController.selectedfinalBrand))
                
            } else if priorityNo == 2 {
                
                
                SelectLocationViewController.selectedfinalLocation = location
                let priorityOneName = UserDefaults.standard.value(forKey: "priorityOne") as! String
                if priorityOneName == "a"
                {
                    SelectLocationViewController.selectedfinalBrand.removeAll()
                    let accountlist = SelectLocationViewController.selectedfinalAcc
                    for i in 0..<selectedHeirarchy.count
                    {
                        let a = accountlist.filter{$0 == selectedHeirarchy[i].accountNumber}
                        if a.count > 0
                        {
                            for j in 0..<selectedHeirarchy[i].brandNameList.count
                            {
                                for k in 0..<selectedHeirarchy[i].brandNameList[j].locationNameList.count{
                                    let l = location.filter{$0 == selectedHeirarchy[i].brandNameList[j].locationNameList[k].locationName}
                                    if l.count > 0
                                    {
                                        SelectLocationViewController.selectedfinalBrand.append(selectedHeirarchy[i].brandNameList[j].brandName)
                                    }
                                    
                                }
                            }
                        }
                    }
                }else if priorityOneName == "b"
                {
                    SelectLocationViewController.selectedfinalAcc.removeAll()
                    let brandlist = SelectLocationViewController.selectedfinalBrand
                    for i in 0..<selectedHeirarchy.count
                    {
                        for j in 0..<selectedHeirarchy[i].brandNameList.count
                        {
                            let b = brandlist.filter{$0 == selectedHeirarchy[i].brandNameList[j].brandName}
                            if b.count > 0
                            {
                                SelectLocationViewController.selectedfinalAcc.append(selectedHeirarchy[i].accountNumber)
                            }
                        }
                    }
                    
                }
                
            }else{
                // SelectLocationViewController.selectedfinalLocation = location
                
                //maltiiii
                let accountArray = SelectLocationViewController.selectedfinalAcc
                let brandArray = SelectLocationViewController.selectedfinalBrand
                for i in 0..<selectedHeirarchy.count
                {
                    let a = accountArray.filter{$0 == selectedHeirarchy[i].accountNumber}
                    if a.count > 0
                    {
                        for j in 0..<selectedHeirarchy[i].brandNameList.count
                        {
                            let b = brandArray.filter{$0 == selectedHeirarchy[i].brandNameList[j].brandName}
                            if b.count > 0
                            {
                                for k in 0..<selectedHeirarchy[i].brandNameList[j].locationNameList.count
                                {
                                    let l = location.filter{$0 == selectedHeirarchy[i].brandNameList[j].locationNameList[k].locationName}
                                    if l.count > 0
                                    {
                                        for m in 0..<selectedHeirarchy[i].brandNameList[j].locationNameList[k].merchantNumber.count
                                        {
                                            let merchant = selectedHeirarchy[i].brandNameList[j].locationNameList[k].merchantNumber[m].mid
                                            merchantNumbers.append(Int(merchant)!)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                SelectLocationViewController.selectedfinalLocation = location
                //maltiiii
                
            }
        }else{
            print("errrr")
        }
        
        //maltiiii
        /*
        for i in 0..<selectedHeirarchy.count
        {
            let a = SelectLocationViewController.selectedfinalAcc.filter{$0 == selectedHeirarchy[i].accountNumber}
            if a.count > 0
            {
                for j in 0..<selectedHeirarchy[i].brandNameList.count
                           {
                               if SelectLocationViewController.selectedfinalLocation.count > 0
                               {
                                   for k in 0..<selectedHeirarchy[i].brandNameList[j].locationNameList.count
                                   {
                                       let l = SelectLocationViewController.selectedfinalLocation.filter{$0 == selectedHeirarchy[i].brandNameList[j].locationNameList[k].locationName}
                                       if l.count > 0
                                       {
                                           for m in 0..<selectedHeirarchy[i].brandNameList[j].locationNameList[k].merchantNumber.count
                                           {
                                               let m : Int = Int(selectedHeirarchy[i].brandNameList[j].locationNameList[k].merchantNumber[m].mid)!
                                               merchantNumbers.append(m)
                                           }
                                       }
                                   }
                               }
                           }
            }
           
        }
        */
        //maltiiii
        
        
        AppConstants.merchantNumber = merchantNumbers
        SelectLocationViewController.selectedfinalBrand = Array(Set(SelectLocationViewController.selectedfinalBrand))
        SelectLocationViewController.selectedfinalLocation = Array(Set(SelectLocationViewController.selectedfinalLocation))
        
        lblAccntNumbrCount.text = String(originalAccounts.count)
        lblBrandCount.text = String(originalBrands.count)
        lblLocationCountView.text = String(originalLocations.count)
        
        selectedFilter = selectedFilterData(companyName: selectFilterData!.companyName, selectedAccounts: SelectLocationViewController.selectedfinalAcc, selectedBrands: SelectLocationViewController.selectedfinalBrand, selectedLocations: SelectLocationViewController.selectedfinalLocation, cif: selectFilterData!.cif, selectedMerchants: AppConstants.merchantNumber, hiearchy: selectedHeirarchy)
        cvCompanyLocationList.reloadData()
    }
    */
    
        func selectMerchantLoaction(account : [String], brand : [String], location : [String]) {
            
            let priorityNo : Int = UserDefaults.standard.value(forKey: "priorityNo") as! Int
            merchantNumbers.removeAll()
            if account.count > 0 {
                    
                if priorityNo == 1 {

                    SelectLocationViewController.selectedfinalBrand.removeAll()
                    SelectLocationViewController.selectedfinalLocation.removeAll()
                    SelectLocationViewController.selectedfinalAcc = account
                        
                    for i in 0..<selectedHeirarchy.count {
                        
                        for j in 0..<account.count {
                            
                            if account[j] == selectedHeirarchy[i].accountNumber {
                                    
                                for k in 0..<selectedHeirarchy[j].brandNameList.count {
                                    
                                    SelectLocationViewController.selectedfinalBrand.append(selectedHeirarchy[j].brandNameList[k].brandName)
                                    SelectLocationViewController.selectedfinalLocation.append(contentsOf: selectedHeirarchy[j].brandNameList[k].locationNameList.map{$0.locationName})
                                        
                                    for l in 0..<selectedHeirarchy[j].brandNameList[k].locationNameList.count {
                                        
                                        for m in 0..<selectedHeirarchy[j].brandNameList[k].locationNameList[l].merchantNumber.count {
                                            
                                            merchantNumbers.append(Int(selectedHeirarchy[j].brandNameList[k].locationNameList[l].merchantNumber[m].mid)!)
                                        }
    //                                    merchantNumbers.append(contentsOf: selectedHeirarchy[j].brandNameList[k].locationNameList[l].merchantNumber.map{$0.mid})
                                    }
                                }
                            }
                        }
                            
                    }
                        
                    originalBrands =  Array(Set(SelectLocationViewController.selectedfinalBrand))
                    originalLocations = Array(Set(SelectLocationViewController.selectedfinalLocation))
                    
                } else if priorityNo == 2 {
                    
                    SelectLocationViewController.selectedfinalAcc = account
                    let priorityOneName = UserDefaults.standard.value(forKey: "priorityOne") as! String
                    if priorityOneName == "b" {
                            
                            let brandlist =  SelectLocationViewController.selectedfinalBrand
                            SelectLocationViewController.selectedfinalLocation.removeAll()
                            for i in 0..<selectedHeirarchy.count
                            {
                                let a = account.filter{$0 == selectedHeirarchy[i].accountNumber}
                                if a.count > 0
                                {
                                    for k in 0..<selectedHeirarchy[i].brandNameList.count
                                                           {
                                                               let b = brandlist.filter{$0 == selectedHeirarchy[i].brandNameList[k].brandName}
                                                               if b.count > 0
                                                               {
                                                                   SelectLocationViewController.selectedfinalLocation.append(contentsOf: selectedHeirarchy[i].brandNameList[k].locationNameList.map{$0.locationName})
                                                                //maltiii
                                                                   for l in 0..<selectedHeirarchy[i].brandNameList[k].locationNameList.count
                                                                                                                       {
                                                                                                                        let mids = selectedHeirarchy[i].brandNameList[k].locationNameList[l].merchantNumber
                                                                                                                        for m in 0..<mids.count
                                                                                                                        {
                                                                                                                            merchantNumbers.append(Int(mids[m].mid)!)
                                                                                                                        }
                                                                                                                       }
                                                                //maltiiii
                                                               }
                                                           }
                                }
                               
                                
                            }
                        
                        originalLocations = Array(Set(SelectLocationViewController.selectedfinalLocation))

                            
                        } else if priorityOneName == "l"
                        {
                            SelectLocationViewController.selectedfinalBrand.removeAll()
                            let locationlist = SelectLocationViewController.selectedfinalLocation
                            for i in 0..<selectedHeirarchy.count
                            {
                                let a = account.filter{$0 == selectedHeirarchy[i].accountNumber}
                                if a.count > 0
                                {
                                    for j in 0..<selectedHeirarchy[i].brandNameList.count
                                    {
                                        for k in 0..<selectedHeirarchy[i].brandNameList[j].locationNameList.count
                                        {
                                            let l = locationlist.filter{$0 == selectedHeirarchy[i].brandNameList[j].locationNameList[k].locationName}
                                            if l.count > 0
                                            {
                                                SelectLocationViewController.selectedfinalBrand.append(selectedHeirarchy[i].brandNameList[j].brandName)
                                                
                                                //maltiiii
                                                for m in 0..<selectedHeirarchy[i].brandNameList[j].locationNameList[k].merchantNumber.count
                                                {
                                                    let mid = selectedHeirarchy[i].brandNameList[j].locationNameList[k].merchantNumber[m].mid
                                                    merchantNumbers.append(Int(mid)!)
                                                }
                                                //maltiiii
                                            }
                                        }
                                    }
                                }
                                
                            }
                            
                            originalBrands =  Array(Set(SelectLocationViewController.selectedfinalBrand))

                        }else{
                            print(priorityOneName)
                        }
                        
                        
                    }else{
                        //maltiiiiii
                        let brandArray : [String] =  SelectLocationViewController.selectedfinalBrand

                        let locationArray : [String] = SelectLocationViewController.selectedfinalLocation
                        
                        for i in 0..<selectedHeirarchy.count
                                    {
                                        let a = account.filter{$0 == selectedHeirarchy[i].accountNumber}
                                        if a.count > 0
                                        {
                                            
                                            for j in 0..<selectedHeirarchy[i].brandNameList.count
                                            {
                                                let b = brandArray.filter{$0 == selectedHeirarchy[i].brandNameList[j].brandName}
                                                if b.count > 0
                                                {
                                                    for k in 0..<selectedHeirarchy[i].brandNameList[j].locationNameList.count
                                                    {
                                                        let l = locationArray.filter{$0 == selectedHeirarchy[i].brandNameList[j].locationNameList[k].locationName}
                                                        if l.count > 0
                                                        {
                                                            for m in 0..<selectedHeirarchy[i].brandNameList[j].locationNameList[k].merchantNumber.count
                                                            {
                                                                let merchant = selectedHeirarchy[i].brandNameList[j].locationNameList[k].merchantNumber[m].mid
                                                                merchantNumbers.append(Int(merchant)!)
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            
                                            
                                        }
                                    }
                        
                        SelectLocationViewController.selectedfinalAcc = account
                        
                        //maltiiiiii
                    }
                }else if brand.count > 0
                {
                    if priorityNo == 1
                    {
                        SelectLocationViewController.selectedfinalBrand = brand
                        SelectLocationViewController.selectedfinalLocation.removeAll()
                        SelectLocationViewController.selectedfinalAcc.removeAll()
                        for i in 0..<selectedHeirarchy.count
                        {
                            for j in 0..<brand.count
                            {
                                let b : [BrandNameList] = selectedHeirarchy[i].brandNameList.filter{$0.brandName == brand[j]}
                                if b.count > 0
                                {
                                    SelectLocationViewController.selectedfinalAcc.append(selectedHeirarchy[i].accountNumber)
                                    for k in 0..<b.count
                                    {
                                        SelectLocationViewController.selectedfinalLocation.append(contentsOf: b[k].locationNameList.map{$0.locationName})
                                        //maltiii
                                        for l in 0..<b[k].locationNameList.count
                                        {
                                            for m in 0..<b[k].locationNameList[l].merchantNumber.count
                                            {
                                                let mid = b[k].locationNameList[l].merchantNumber[m].mid
                                                merchantNumbers.append(Int(mid)!)
                                            }
                                        }
                                        //maltiiii
                                    }

                                }
                            }
                        }
                        
                        
                        
                        originalAccounts = Array(Set(SelectLocationViewController.selectedfinalAcc))
                        originalLocations  = Array(Set(SelectLocationViewController.selectedfinalLocation))
                        
                    }else if priorityNo == 2
                    {
                        SelectLocationViewController.selectedfinalBrand = brand
                        let priorityOneName = UserDefaults.standard.value(forKey: "priorityOne") as! String
                        if priorityOneName == "a"
                        {
                            SelectLocationViewController.selectedfinalLocation.removeAll()
                            let accountlist = SelectLocationViewController.selectedfinalAcc
                            for i in 0..<selectedHeirarchy.count
                            {
                                let a = accountlist.filter{$0 == selectedHeirarchy[i].accountNumber}
                                if a.count > 0
                                {
                                    for j in 0..<selectedHeirarchy[i].brandNameList.count
                                    {
                                        let b = brand.filter{$0 == selectedHeirarchy[i].brandNameList[j].brandName}
                                        if b.count > 0
                                        {
                                            SelectLocationViewController.selectedfinalLocation.append(contentsOf: selectedHeirarchy[i].brandNameList[j].locationNameList.map{$0.locationName})
                                            //maltiii
                                            for k in 0..<selectedHeirarchy[i].brandNameList[j].locationNameList.count
                                            {
                                                for l in 0..<selectedHeirarchy[i].brandNameList[j].locationNameList[k].merchantNumber.count
                                                {
                                                    let mid = selectedHeirarchy[i].brandNameList[j].locationNameList[k].merchantNumber[l].mid
                                                    merchantNumbers.append(Int(mid)!)
                                                }
                                            }
                                            //maltiii
                                        }
                                    }
                                }
                                
                            }
                            
                            originalLocations  = Array(Set(SelectLocationViewController.selectedfinalLocation))
                            
                        }else if priorityOneName == "l"
                        {
                            SelectLocationViewController.selectedfinalAcc.removeAll()
                            let locationList = SelectLocationViewController.selectedfinalLocation
                            for i in 0..<selectedHeirarchy.count
                            {
                                for j in 0..<selectedHeirarchy[i].brandNameList.count
                                {
                                    let b = brand.filter{$0 == selectedHeirarchy[i].brandNameList[j].brandName}
                                    if b.count > 0
                                    {
                                        for k in 0..<selectedHeirarchy[i].brandNameList[j].locationNameList.count
                                        {
                                            let l = locationList.filter{$0 == selectedHeirarchy[i].brandNameList[j].locationNameList[k].locationName}
                                            if l.count > 0
                                            {
                                                SelectLocationViewController.selectedfinalAcc.append(selectedHeirarchy[i].accountNumber)
                                                //maltiii
                                                for m in 0..<selectedHeirarchy[i].brandNameList[j].locationNameList[k].merchantNumber.count
                                                {
                                                    let mid = selectedHeirarchy[i].brandNameList[j].locationNameList[k].merchantNumber[m].mid
                                                    merchantNumbers.append(Int(mid)!)
                                                }
                                                //maltiiii
                                            }
                                            
                                        }
                                        
                                    }
                                    
                                }
                                
                            }
                            
                            originalAccounts = Array(Set(SelectLocationViewController.selectedfinalAcc))

                        }
                        
                    }else{
                        //maltiii
                        let accountArray = SelectLocationViewController.selectedfinalAcc
                        let locationArray = SelectLocationViewController.selectedfinalLocation
                        
                        for i in 0..<selectedHeirarchy.count
                        {
                            let a = accountArray.filter{$0 == selectedHeirarchy[i].accountNumber}
                            if a.count > 0
                            {
                                for j in 0..<selectedHeirarchy[i].brandNameList.count
                                {
                                    let b = brand.filter{$0 == selectedHeirarchy[i].brandNameList[j].brandName}
                                    if b.count > 0
                                    {
                                        for k in 0..<selectedHeirarchy[i].brandNameList[j].locationNameList.count
                                        {
                                            let l = locationArray.filter{$0 == selectedHeirarchy[i].brandNameList[j].locationNameList[k].locationName}
                                            if l.count > 0
                                            {
                                                for m in 0..<selectedHeirarchy[i].brandNameList[j].locationNameList[k].merchantNumber.count
                                                {
                                                    
                                                    let merchant = selectedHeirarchy[i].brandNameList[j].locationNameList[k].merchantNumber[m].mid
                                                    merchantNumbers.append(Int(merchant)!)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        SelectLocationViewController.selectedfinalBrand = brand
                        //maltiiiii
                    }
                    
                }else if location.count > 0
                {
                    if priorityNo == 1
                    {
                        SelectLocationViewController.selectedfinalBrand.removeAll()
                        SelectLocationViewController.selectedfinalLocation = location
                        SelectLocationViewController.selectedfinalAcc.removeAll()
                        
                        for i in 0..<selectedHeirarchy.count
                        {
                            
                            for j in 0..<selectedHeirarchy[i].brandNameList.count
                            {
                                for k in 0..<location.count
                                {
                                    let l : [LocationNameList] = selectedHeirarchy[i].brandNameList[j].locationNameList.filter{$0.locationName == location[k]}
                                    if l.count > 0
                                    {
                                        SelectLocationViewController.selectedfinalBrand.append(selectedHeirarchy[i].brandNameList[j].brandName)
                                        SelectLocationViewController.selectedfinalAcc.append(selectedHeirarchy[i].accountNumber)
                                        //maltiii
                                        for ll in 0..<l.count
                                        {
                                            for m in 0..<l[ll].merchantNumber.count
                                            {
                                                let mid = l[ll].merchantNumber[m].mid
                                                merchantNumbers.append(Int(mid)!)
                                            }
                                        }
                                        //maltiii
                                    }
                                }
                                
                            }
                        }
                        
                        originalAccounts = Array(Set(SelectLocationViewController.selectedfinalAcc))
                        originalBrands  = Array(Set(SelectLocationViewController.selectedfinalBrand))
                        
                    }else if priorityNo == 2
                    {
                        
                        
                        SelectLocationViewController.selectedfinalLocation = location
                        let priorityOneName = UserDefaults.standard.value(forKey: "priorityOne") as! String
                        if priorityOneName == "a"
                        {
                            SelectLocationViewController.selectedfinalBrand.removeAll()
                            let accountlist = SelectLocationViewController.selectedfinalAcc
                            for i in 0..<selectedHeirarchy.count
                            {
                                let a = accountlist.filter{$0 == selectedHeirarchy[i].accountNumber}
                                if a.count > 0
                                {
                                    for j in 0..<selectedHeirarchy[i].brandNameList.count
                                    {
                                        for k in 0..<selectedHeirarchy[i].brandNameList[j].locationNameList.count{
                                            let l = location.filter{$0 == selectedHeirarchy[i].brandNameList[j].locationNameList[k].locationName}
                                            if l.count > 0
                                            {
                                                SelectLocationViewController.selectedfinalBrand.append(selectedHeirarchy[i].brandNameList[j].brandName)
                                                //maltiiii
                                                for l in 0..<selectedHeirarchy[i].brandNameList[j].locationNameList[k].merchantNumber.count
                                                {
                                                    let mid = selectedHeirarchy[i].brandNameList[j].locationNameList[k].merchantNumber[l].mid
                                                    merchantNumbers.append(Int(mid)!)
                                                }
                                                //maltiii
                                            }
                                            
                                        }
                                    }
                                }
                            }
                            
                            originalBrands  = Array(Set(SelectLocationViewController.selectedfinalBrand))
                            
                        }else if priorityOneName == "b"
                        {
                            SelectLocationViewController.selectedfinalAcc.removeAll()
                            let brandlist = SelectLocationViewController.selectedfinalBrand
                            for i in 0..<selectedHeirarchy.count
                            {
                                for j in 0..<selectedHeirarchy[i].brandNameList.count
                                {
                                    let b = brandlist.filter{$0 == selectedHeirarchy[i].brandNameList[j].brandName}
                                    if b.count > 0
                                    {
                                        //maltiiii
                                        for k in 0..<selectedHeirarchy[i].brandNameList[j].locationNameList.count
                                       {
                                        let l = location.filter{$0 == selectedHeirarchy[i].brandNameList[j].locationNameList[k].locationName}
                                        if l.count > 0
                                        {
                                            SelectLocationViewController.selectedfinalAcc.append(selectedHeirarchy[i].accountNumber)
                                            for l in 0..<selectedHeirarchy[i].brandNameList[j].locationNameList[k].merchantNumber.count
                                              {
                                                let mid = selectedHeirarchy[i].brandNameList[j].locationNameList[k].merchantNumber[l].mid
                                                merchantNumbers.append(Int(mid)!)
                                            }
                                        }
                                        
                                      
                                          
                                        }
                                        //maltiiii
                                    }
                                }
                            }
                            originalAccounts = Array(Set(SelectLocationViewController.selectedfinalAcc))

                        }
                        
                    }else{
                        //maltiiii
                        let accountArray = SelectLocationViewController.selectedfinalAcc
                        let brandArray = SelectLocationViewController.selectedfinalBrand
                        for i in 0..<selectedHeirarchy.count
                        {
                            let a = accountArray.filter{$0 == selectedHeirarchy[i].accountNumber}
                            if a.count > 0
                            {
                                for j in 0..<selectedHeirarchy[i].brandNameList.count
                                {
                                    let b = brandArray.filter{$0 == selectedHeirarchy[i].brandNameList[j].brandName}
                                    if b.count > 0
                                    {
                                        for k in 0..<selectedHeirarchy[i].brandNameList[j].locationNameList.count
                                        {
                                            let l = location.filter{$0 == selectedHeirarchy[i].brandNameList[j].locationNameList[k].locationName}
                                            if l.count > 0
                                            {
                                                for m in 0..<selectedHeirarchy[i].brandNameList[j].locationNameList[k].merchantNumber.count
                                                {
                                                    let merchant = selectedHeirarchy[i].brandNameList[j].locationNameList[k].merchantNumber[m].mid
                                                    merchantNumbers.append(Int(merchant)!)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        SelectLocationViewController.selectedfinalLocation = location
                        //maltiiii
                    }
                }else{
                    print("errrr")
                }
                //maltiiiii
        //        for i in 0..<selectedHeirarchy.count
        //        {
        //            let a = SelectLocationViewController.selectedfinalAcc.filter{$0 == selectedHeirarchy[i].accountNumber}
        //            if a.count > 0
        //            {
        //                for j in 0..<selectedHeirarchy[i].brandNameList.count
        //                           {
        //                               if SelectLocationViewController.selectedfinalLocation.count > 0
        //                               {
        //                                   for k in 0..<selectedHeirarchy[i].brandNameList[j].locationNameList.count
        //                                   {
        //                                       let l = SelectLocationViewController.selectedfinalLocation.filter{$0 == selectedHeirarchy[i].brandNameList[j].locationNameList[k].locationName}
        //                                       if l.count > 0
        //                                       {
        //                                           for m in 0..<selectedHeirarchy[i].brandNameList[j].locationNameList[k].merchantNumber.count
        //                                           {
        //                                               let m : Int = Int(selectedHeirarchy[i].brandNameList[j].locationNameList[k].merchantNumber[m].mid)!
        //                                               merchantNumbers.append(m)
        //                                           }
        //                                       }
        //                                   }
        //                               }
        //                           }
        //            }
        //
        //        }
                
                //maltiiii
            AppConstants.merchantNumber = merchantNumbers
            SelectLocationViewController.selectedfinalAcc = Array(Set(SelectLocationViewController.selectedfinalAcc))
            SelectLocationViewController.selectedfinalBrand = Array(Set(SelectLocationViewController.selectedfinalBrand))
            SelectLocationViewController.selectedfinalLocation = Array(Set(SelectLocationViewController.selectedfinalLocation))
            
                
                lblAccntNumbrCount.text = String(originalAccounts.count)
                lblBrandCount.text = String(originalBrands.count)
                lblLocationCountView.text = String(originalLocations.count)
                
                selectedFilter = selectedFilterData(companyName: selectFilterData!.companyName, selectedAccounts: SelectLocationViewController.selectedfinalAcc, selectedBrands: SelectLocationViewController.selectedfinalBrand, selectedLocations: SelectLocationViewController.selectedfinalLocation, cif: selectFilterData!.cif, selectedMerchants: AppConstants.merchantNumber, hiearchy: selectedHeirarchy)
                cvCompanyLocationList.reloadData()
            }
    
    @IBOutlet weak var cvCompanyLocationList: UICollectionView!
    @IBOutlet weak var cvCompanyList: UICollectionView!
    weak var delegate : popupDelegate?
    var isFromProfile = false
    var selectedIndx = -1
    @IBOutlet weak var selectLocationView: UIView!
    var thereIsCellTapped = false
    var selectAll : Bool = false
    @IBOutlet weak var selectAccountNumberView: UIView!
    @IBOutlet weak var selectBrandView: UIView!
    @IBOutlet weak var lblLocationCountView: UILabel!
    @IBOutlet weak var lblBrandCount: UILabel!
    @IBOutlet weak var lblAccntNumbrCount: UILabel!
    weak var delegateFilter : applyFilterDelegate?
    
    var filterData : [FilterDatum] = []
    var selectedFilter : selectedFilterData?
    var originalAccounts : [String] = []
    var originalBrands : [String] = []
    var originalLocations : [String] = []
    var selectedHeirarchy : [Hierarchy] = []
    var merchantNumbers : [Int] = []
    var selectFilterData : FilterDatum?
    
    static var selectedfinalAcc : [String] = []
    static var selectedfinalBrand : [String] = []
    static var selectedfinalLocation : [String] = []
    
    @IBOutlet weak var lblSelectAccNo: UILabel!
    @IBOutlet weak var lblSelectBrand: UILabel!
    @IBOutlet weak var lblSelectLocation: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loopThroughSubViewAndMirrorImage(subviews: self.view.subviews)
        
        tapGesture()
        SelectLocationViewController.selectedfinalAcc.removeAll()
        SelectLocationViewController.selectedfinalBrand.removeAll()
        SelectLocationViewController.selectedfinalLocation.removeAll()
        
        cvCompanyList.delegate = self
        cvCompanyLocationList.allowsSelection = false
        if AppConstants.locationFilterData != nil {
            filterData = AppConstants.locationFilterData?.filterData ?? []
            cvCompanyList.reloadData()
            cvCompanyLocationList.reloadData()
        }
        
//        UserDefaults.standard.setValue(0, forKey: "priorityNo")
        if  UserDefaults.standard.value(forKey: "priorityNo") == nil
        {
            UserDefaults.standard.setValue(0, forKey: "priorityNo")

        }
        
        
        lblAccntNumbrCount.text = String(AppConstants.selectedFilter!.selectedAccounts.count)
        lblBrandCount.text = String(AppConstants.selectedFilter!.selectedBrands.count)
        lblLocationCountView.text = String(AppConstants.selectedFilter!.selectedLocations.count)
        selectedFilter = AppConstants.selectedFilter
        
        
        if AppConstants.language == .en {
           
            lblSelectAccNo.textAlignment = .left
            lblSelectBrand.textAlignment = .left
            lblSelectLocation.textAlignment = .left

        }else{
            
            lblSelectAccNo.textAlignment = .right
            lblSelectBrand.textAlignment = .right
            lblSelectLocation.textAlignment = .right
        }
        
        
    }
    
    func tapGesture(){
        let tapAccntNoGesture = UITapGestureRecognizer(target: self, action: #selector(self.selectAccountNumber))
        self.selectAccountNumberView.addGestureRecognizer(tapAccntNoGesture)
        
        let tapBrandGesture = UITapGestureRecognizer(target: self, action: #selector(self.selectBrand))
        self.selectBrandView.addGestureRecognizer(tapBrandGesture)
        
        let tapLocationGesture = UITapGestureRecognizer(target: self, action: #selector(self.selectLocation))
        self.selectLocationView.addGestureRecognizer(tapLocationGesture)
        
    }
    
    @objc func selectAccountNumber(sender: UITapGestureRecognizer){
        
        popupType(type: 0)
    }
    
    
    
    @objc func selectBrand(sender: UITapGestureRecognizer){
        
        popupType(type: 1)
        
    }
    @objc func selectLocation(sender: UITapGestureRecognizer){
        
        popupType(type: 2)
        
    }
    var isFilterSelected = false
    func popupType(type:Int){
        let controller = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FilterSelectionViewController") as? FilterSelectionViewController)!
        isFilterSelected = true
        if type == 0
        {
            if UserDefaults.standard.value(forKey: "priorityOne") != nil
            {
                if UserDefaults.standard.value(forKey: "priorityOne") as? String ?? "" == "a"
                {
                    controller.selectedAccounts = SelectLocationViewController.selectedfinalAcc
                    controller.originalAccounts = originalAccounts
                               
                } else if UserDefaults.standard.value(forKey: "priorityTwo") != nil {
                    
                    if UserDefaults.standard.value(forKey: "priorityTwo") as? String ?? "" == "a" {
                        controller.selectedAccounts = SelectLocationViewController.selectedfinalAcc
                        controller.originalAccounts = originalAccounts
                    } else {
                        
                        if SelectLocationViewController.selectedfinalAcc.count > 0
                        {
                             controller.originalAccounts = SelectLocationViewController.selectedfinalAcc
                        }else{
                             controller.originalAccounts = originalAccounts
                        }
                        controller.selectedAccounts = SelectLocationViewController.selectedfinalAcc
                        
                    }
                }
                else {
                    if SelectLocationViewController.selectedfinalAcc.count > 0
                    {
                         controller.originalAccounts = SelectLocationViewController.selectedfinalAcc
                    }else{
                         controller.originalAccounts = originalAccounts
                    }
                    controller.selectedAccounts = SelectLocationViewController.selectedfinalAcc
                }
                
            } else {
                controller.selectedAccounts = SelectLocationViewController.selectedfinalAcc
                controller.originalAccounts = originalAccounts
            }
    
        } else if type == 1 {
            
            if UserDefaults.standard.value(forKey: "priorityOne") != nil{
                if UserDefaults.standard.value(forKey: "priorityOne") as? String ?? "" == "b"
                {
                    controller.originalBrands = originalBrands
                    controller.selectedBrands = SelectLocationViewController.selectedfinalBrand
                    
                } else if UserDefaults.standard.value(forKey: "priorityTwo") != nil {
                    
                    if UserDefaults.standard.value(forKey: "priorityTwo") as? String ?? "" == "b" {
                        controller.originalBrands = originalBrands
                        controller.selectedBrands = SelectLocationViewController.selectedfinalBrand
                    } else {
                        
                        if SelectLocationViewController.selectedfinalBrand.count > 0
                        {
                             controller.originalBrands = SelectLocationViewController.selectedfinalBrand
                        }else{
                              controller.originalBrands = originalBrands
                        }
                        controller.selectedBrands = SelectLocationViewController.selectedfinalBrand
                        
                    }
                }
                else{
                    if SelectLocationViewController.selectedfinalBrand.count > 0
                    {
                         controller.originalBrands = SelectLocationViewController.selectedfinalBrand
                    }else{
                          controller.originalBrands = originalBrands
                    }
                    controller.selectedBrands = SelectLocationViewController.selectedfinalBrand
                }
            }else{
                controller.originalBrands = originalBrands
                                       
                controller.selectedBrands = SelectLocationViewController.selectedfinalBrand
            }
            
          
        } else {
            
            if UserDefaults.standard.value(forKey: "priorityOne") != nil{
                // MAK
                if UserDefaults.standard.value(forKey: "priorityOne") as? String ?? "" == "l"  {
                    
                    controller.selectedLocations = SelectLocationViewController.selectedfinalLocation
                    controller.originalLocations = originalLocations
                              
                } else if UserDefaults.standard.value(forKey: "priorityTwo") != nil {
                    
                    if UserDefaults.standard.value(forKey: "priorityTwo") as? String ?? "" == "l" {
                        controller.selectedLocations = SelectLocationViewController.selectedfinalLocation
                        controller.originalLocations = originalLocations
                    } else {
                        
                        if SelectLocationViewController.selectedfinalLocation.count > 0 {
                            controller.originalLocations = SelectLocationViewController.selectedfinalLocation
                        }else{
                            controller.originalLocations = originalLocations
                        }
                        controller.selectedLocations = SelectLocationViewController.selectedfinalLocation
                    }
                }
                else {
                    
                    if SelectLocationViewController.selectedfinalLocation.count > 0 {
                        controller.originalLocations = SelectLocationViewController.selectedfinalLocation
                    }else{
                        controller.originalLocations = originalLocations
                    }
                    controller.selectedLocations = SelectLocationViewController.selectedfinalLocation
                }
            } else {
                controller.selectedLocations = SelectLocationViewController.selectedfinalLocation
                controller.originalLocations = originalLocations
            }
          
        }
        
        
        controller.popupType = type
        controller.selectLocationMerchantdelegate = self
        
        var height :CGFloat = 350
        if type == 0{
            height = height + CGFloat(60 * originalAccounts.count)
        }else if type == 1{
            height = height + CGFloat(60 * originalBrands.count)
        }else{
            height = height + CGFloat(60 * originalLocations.count)
        }
        
        presentAsStork(controller, height: height, cornerRadius: 8.0, showIndicator: false, showCloseButton: false)
    }
    
    
    @IBAction func assign(_ sender: Any) {
        
        if(isFromProfile){
            //delegate?.notifyVia(showNotifyPopup: true)
//            self.dismiss(animated: true, completion: nil)
            
            // CHANGE BY MAKAU
//            FilterSelectionViewController.isAccountSelected = false
//            FilterSelectionViewController.isBrandSelected = false
//            FilterSelectionViewController.isLocationSelected = false
            var cif = false
            if isFilterSelected {
                if  (selectFilterData!.accountList.count == SelectLocationViewController.selectedfinalAcc.count) && (selectFilterData!.brandList.count == SelectLocationViewController.selectedfinalBrand.count) && (selectFilterData!.locationList.count == SelectLocationViewController.selectedfinalLocation.count)
                {
                    if AppConstants.UserData.merchantRole == "Admin"
                    {
                        cif = true
                    }else{
                        cif = false
                    }
                }else{
                    cif = false
                }
                
                AppConstants.selectedFilter = selectedFilter
                
            }else{
                if  (selectFilterData!.accountList.count == originalAccounts.count) && (selectFilterData!.brandList.count == originalBrands.count) && (selectFilterData!.locationList.count == originalLocations.count)
                {
                    cif = true
                }else{
                               
                    cif = false
                }
            }
            delegateFilter?.applyFilter(heirarchy: AppConstants.selectedFilter!, isCif: cif)
                       
            self.dismiss(animated: true, completion: nil)
            
        }else{
            
//            FilterSelectionViewController.isAccountSelected = false
//            FilterSelectionViewController.isBrandSelected = false
//            FilterSelectionViewController.isLocationSelected = false
            var cif = false
            if isFilterSelected {
                if  (selectFilterData!.accountList.count == SelectLocationViewController.selectedfinalAcc.count) && (selectFilterData!.brandList.count == SelectLocationViewController.selectedfinalBrand.count) && (selectFilterData!.locationList.count == SelectLocationViewController.selectedfinalLocation.count)
                {
                    if AppConstants.UserData.merchantRole == "Admin"
                    {
                        cif = true
                    }else{
                        cif = false
                    }
                }else{
                    cif = false
                }
                
                
                AppConstants.selectedFilter = selectedFilter
            }else
            {
                if  (selectFilterData!.accountList.count == originalAccounts.count) && (selectFilterData!.brandList.count == originalBrands.count) && (selectFilterData!.locationList.count == originalLocations.count)
                {
                    cif = true
                }else{
                    
                    cif = false
                }
            }
            delegateFilter?.applyFilter(heirarchy: AppConstants.selectedFilter!, isCif: cif)
            
            self.dismiss(animated: true, completion: nil)
            
            
        }
        //mak
        /*
        if(isFromProfile){
            delegate?.notifyVia(showNotifyPopup: true)
            self.dismiss(animated: true, completion: nil)
        }else{
            FilterSelectionViewController.isAccountSelected = false
            FilterSelectionViewController.isBrandSelected = false
            FilterSelectionViewController.isLocationSelected = false
            var cif = false
            if isFilterSelected {
                if  (selectFilterData!.accountList.count == SelectLocationViewController.selectedfinalAcc.count) && (selectFilterData!.brandList.count == SelectLocationViewController.selectedfinalAcc.count) && (selectFilterData!.locationList.count == SelectLocationViewController.selectedfinalAcc.count)
                {
                    if AppConstants.UserData.merchantRole == "Admin"
                    {
                        cif = true
                    }else{
                        cif = false
                    }
                }else{
                    cif = false
                }
                
                
                AppConstants.selectedFilter = selectedFilter
            }else
            {
                cif = true
            }
            delegateFilter?.applyFilter(heirarchy: AppConstants.selectedFilter!, isCif: cif)
            
            self.dismiss(animated: true, completion: nil)
            
            
        }
        */
    }
    
    @IBAction func clearSearchList(_ sender: Any) {
        /*
        SelectLocationViewController.selectedfinalAcc.removeAll()
        SelectLocationViewController.selectedfinalBrand.removeAll()
        SelectLocationViewController.selectedfinalLocation.removeAll()
        selectedFilter = AppConstants.originalSelectFilter
        
        UserDefaults.standard.removeObject(forKey: "priorityOne")
        UserDefaults.standard.removeObject(forKey: "priorityTwo")
        UserDefaults.standard.removeObject(forKey: "priorityNo")
        UserDefaults.standard.synchronize()
        UserDefaults.standard.setValue(0, forKey: "priorityNo")
        var heirarchyArr : [Hierarchy] = (AppConstants.locationFilterData?.filterData[0].hierarchy)!
        let filterdata : FilterDatum = AppConstants.locationFilterData!.filterData[0]
        for i in 0..<heirarchyArr.count{
                                           for j in 0..<heirarchyArr[i].brandNameList.count{
                                               for k in 0..<heirarchyArr[i].brandNameList[j].locationNameList.count{
                                                   for l in 0..<heirarchyArr[i].brandNameList[j].locationNameList[k].merchantNumber.count
                                                   {
                                                       AppConstants.merchantNumber.append(Int(heirarchyArr[i].brandNameList[j].locationNameList[k].merchantNumber[l].mid)!)
                                                   }
                                               }
                                           }
                                       }
        AppConstants.selectedFilter = selectedFilterData(companyName: filterdata.companyName, selectedAccounts: filterdata.accountList, selectedBrands: filterdata.brandList, selectedLocations: filterdata.locationList, cif: filterdata.cif, selectedMerchants: AppConstants.merchantNumber, hiearchy: filterdata.hierarchy)
                                       AppConstants.originalSelectFilter = AppConstants.selectedFilter
                          
        cvCompanyList.reloadData()
        cvCompanyLocationList.reloadData()
        */
        
        selectedFilter = AppConstants.originalSelectFilter
        UserDefaults.standard.removeObject(forKey: "priorityOne")
        UserDefaults.standard.removeObject(forKey: "priorityTwo")
        UserDefaults.standard.removeObject(forKey: "priorityThree")
        UserDefaults.standard.removeObject(forKey: "priorityNo")
        UserDefaults.standard.synchronize()
        UserDefaults.standard.setValue(0, forKey: "priorityNo")
        
        SelectLocationViewController.selectedfinalAcc.removeAll()
        SelectLocationViewController.selectedfinalBrand.removeAll()
        SelectLocationViewController.selectedfinalLocation.removeAll()
        
        FilterSelectionViewController.isAccountSelected = false
        FilterSelectionViewController.isBrandSelected = false
        FilterSelectionViewController.isLocationSelected = false
        
        isFilterSelected = false
        var heirarchyArr : [Hierarchy] = (AppConstants.locationFilterData?.filterData[0].hierarchy)!
        let filterdata : FilterDatum = AppConstants.locationFilterData!.filterData[0]
        for i in 0..<heirarchyArr.count{
            for j in 0..<heirarchyArr[i].brandNameList.count{
                for k in 0..<heirarchyArr[i].brandNameList[j].locationNameList.count{
                    for l in 0..<heirarchyArr[i].brandNameList[j].locationNameList[k].merchantNumber.count
                    {
                        AppConstants.merchantNumber.append(Int(heirarchyArr[i].brandNameList[j].locationNameList[k].merchantNumber[l].mid)!)
                    }
                }
            }
        }
        
        AppConstants.selectedFilter = selectedFilterData(companyName: filterdata.companyName, selectedAccounts: filterdata.accountList, selectedBrands: filterdata.brandList, selectedLocations: filterdata.locationList, cif: filterdata.cif, selectedMerchants: AppConstants.merchantNumber, hiearchy: filterdata.hierarchy)
        
        AppConstants.originalSelectFilter = AppConstants.selectedFilter
        
        lblBrandCount.text = String(filterdata.brandList.count)
        lblLocationCountView.text = String(filterdata.locationList.count)
        lblAccntNumbrCount.text = String(filterdata.accountList.count)
        
        cvCompanyList.reloadData()
        
        cvCompanyLocationList.reloadData()
    }
    
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cvCompanyList {
            return filterData.count
        } else {
            return 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView == cvCompanyList)
        {
            let cell = collectionView.cellForItem(at: indexPath) as! cvCompanyNameCell
            
            if cell.isSelected {
                
                UserDefaults.standard.removeObject(forKey: "priorityOne")
                UserDefaults.standard.removeObject(forKey: "priorityTwo")
                UserDefaults.standard.removeObject(forKey: "priorityThree")
                UserDefaults.standard.removeObject(forKey: "priorityNo")
                UserDefaults.standard.synchronize()
                UserDefaults.standard.setValue(0, forKey: "priorityNo")
                
                SelectLocationViewController.selectedfinalAcc.removeAll()
                SelectLocationViewController.selectedfinalBrand.removeAll()
                SelectLocationViewController.selectedfinalLocation.removeAll()
                
                FilterSelectionViewController.isAccountSelected = false
                FilterSelectionViewController.isBrandSelected = false
                FilterSelectionViewController.isLocationSelected = false

                isFilterSelected = false
                
                cell.selectedView()
                originalAccounts = filterData[indexPath.row].accountList
                lblAccntNumbrCount.text = String(originalAccounts.count)
                
                selectFilterData = filterData[indexPath.row]
                lblBrandCount.text = String(filterData[indexPath.row].brandList.count)
                lblAccntNumbrCount.text = String(filterData[indexPath.row].accountList.count)
                lblLocationCountView.text = String(filterData[indexPath.row].locationList.count)
                AppConstants.merchantNumber.removeAll()
                for i in 0..<filterData[indexPath.row].hierarchy.count
                {
                    for j in 0..<filterData[indexPath.row].hierarchy[i].brandNameList.count
                    {
                        for k in 0..<filterData[indexPath.row].hierarchy[i].brandNameList[j].locationNameList.count
                        {
                            for l in 0..<filterData[indexPath.row].hierarchy[i].brandNameList[j].locationNameList[k].merchantNumber.count
                            {
                                AppConstants.merchantNumber.append(Int(filterData[indexPath.row].hierarchy[i].brandNameList[j].locationNameList[k].merchantNumber[l].mid)!)
                                
                            }
                        }
                    }
                }
                originalBrands = filterData[indexPath.row].brandList
                originalLocations = filterData[indexPath.row].locationList
                selectedFilter = selectedFilterData(companyName: filterData[indexPath.row].companyName, selectedAccounts: filterData[indexPath.row].accountList, selectedBrands: filterData[indexPath.row].brandList, selectedLocations: filterData[indexPath.row].locationList, cif: filterData[indexPath.row].cif, selectedMerchants: AppConstants.merchantNumber, hiearchy: filterData[indexPath.row].hierarchy)
                AppConstants.selectedFilter = selectedFilter
                cvCompanyLocationList.reloadData()
                cvCompanyList.reloadData()
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if(collectionView == cvCompanyList){
            let cell = collectionView.cellForItem(at: indexPath) as! cvCompanyNameCell
            cell.deselectedView()
        }
    }
    
    //Original
    /*
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if(collectionView == cvCompanyList){
            
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: cvCompanyNameCell.self), for: indexPath) as! cvCompanyNameCell
            cell.lblName.text = filterData[indexPath.row].companyName
            
            if filterData[indexPath.row].companyName == AppConstants.selectedFilter?.companyName
            {
                if UserDefaults.standard.value(forKey: "priorityOne") as? String ?? "" == "a" {
                        
                    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
                    cell.selectedView()
                    selectFilterData = filterData[indexPath.row]
                    selectedHeirarchy = filterData[indexPath.row].hierarchy
                    cell.isSelected = true
                    lblAccntNumbrCount.text = String(selectFilterData!.accountList.count)
                    lblBrandCount.text = String(AppConstants.selectedFilter!.selectedBrands.count)
                    lblLocationCountView.text = String(AppConstants.selectedFilter!.selectedLocations.count)
                    originalAccounts = selectFilterData!.accountList
                    originalBrands = AppConstants.selectedFilter!.selectedBrands
                    originalLocations = AppConstants.selectedFilter!.selectedLocations
                    SelectLocationViewController.selectedfinalAcc = AppConstants.selectedFilter!.selectedAccounts
                                                     
                }else if UserDefaults.standard.value(forKey: "priorityOne") as? String ?? "" == "b" {
                    
                    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
                    cell.selectedView()
                       
                    selectFilterData = filterData[indexPath.row]
                    selectedHeirarchy = filterData[indexPath.row].hierarchy
                    cell.isSelected = true
                    originalAccounts = AppConstants.selectedFilter!.selectedAccounts
                    originalBrands = selectFilterData!.brandList
                    originalLocations = AppConstants.selectedFilter!.selectedLocations
                    SelectLocationViewController.selectedfinalBrand = AppConstants.selectedFilter!.selectedBrands
                    lblAccntNumbrCount.text = String(AppConstants.selectedFilter!.selectedAccounts.count)
                    lblBrandCount.text = String(selectFilterData!.brandList.count)
                    lblLocationCountView.text = String(AppConstants.selectedFilter!.selectedLocations.count)
                }else if UserDefaults.standard.value(forKey: "priorityOne") as? String ?? "" == "l" {
                        
                    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
                    cell.selectedView()
                    selectFilterData = filterData[indexPath.row]
                    selectedHeirarchy = filterData[indexPath.row].hierarchy
                    cell.isSelected = true
                    originalAccounts = AppConstants.selectedFilter!.selectedAccounts
                    originalBrands = AppConstants.selectedFilter!.selectedBrands
                    originalLocations = selectFilterData!.locationList
                    SelectLocationViewController.selectedfinalLocation = AppConstants.selectedFilter!.selectedLocations
                    lblAccntNumbrCount.text = String(AppConstants.selectedFilter!.selectedAccounts.count)
                    lblBrandCount.text = String(AppConstants.selectedFilter!.selectedBrands.count)
                    lblLocationCountView.text = String(selectFilterData!.brandList.count)
                    
                }else{
                    
                    originalAccounts = AppConstants.selectedFilter!.selectedAccounts
                    originalBrands = AppConstants.selectedFilter!.selectedBrands
                    originalLocations = AppConstants.selectedFilter!.selectedLocations
                    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
                    cell.selectedView()
                    selectFilterData = filterData[indexPath.row]
                    selectedHeirarchy = filterData[indexPath.row].hierarchy
                    cell.isSelected = true
                }
            }
            
            return cell
            
        } else {
            
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: cvCompanyLocationListCell.self), for: indexPath) as! cvCompanyLocationListCell
            cell.layer.cornerRadius = 5
            if indexPath.row == 0 {
                if SelectLocationViewController.selectedfinalAcc.count > 0
                {
                    cell.lblName.text = "Acc No.: " + String(SelectLocationViewController.selectedfinalAcc.count)
                }else{
                    cell.lblName.text = "Acc No.: " + String(AppConstants.selectedFilter!.selectedAccounts.count)
                }
                
            }else if indexPath.row == 1{
                if SelectLocationViewController.selectedfinalBrand.count > 0
                {
                    cell.lblName.text = "Brand : " + String(SelectLocationViewController.selectedfinalBrand.count)
                }else{
                    cell.lblName.text = "Brand : " + String(AppConstants.selectedFilter!.selectedBrands.count)
                }
                
            }else{
                if SelectLocationViewController.selectedfinalLocation.count > 0
                {
                    cell.lblName.text = "Location :" + String(SelectLocationViewController.selectedfinalLocation.count)
                }else{
                    cell.lblName.text = "Location :" + String(AppConstants.selectedFilter!.selectedLocations.count)
                }
            }
            
            return cell
        }
        
       
        
        
        
        
    }
     */
    
    
    // By mAlu 1
    /*
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if(collectionView == cvCompanyList) {
            
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: cvCompanyNameCell.self), for: indexPath) as! cvCompanyNameCell
            cell.lblName.text = filterData[indexPath.row].companyName
            
            if filterData[indexPath.row].companyName == AppConstants.selectedFilter?.companyName
            {
                cell.selectedView()
                 selectFilterData = filterData[indexPath.row]
                selectedHeirarchy = filterData[indexPath.row].hierarchy
                cell.isSelected = true
                
                if UserDefaults.standard.value(forKey: "priorityOne") as? String ?? "" == "a" {
                    
                    if UserDefaults.standard.value(forKey: "priorityTwo") as? String ?? "" == "b" {
                       
                        
                    } else if UserDefaults.standard.value(forKey: "priorityTwo") as? String ?? "" == "l" {
                        
                        var origLocations : [String] = []
                        var brandlist : [BrandNameList] = []
                        origLocations.removeAll()
                        
                        for i in 0..<selectFilterData!.hierarchy.count {
                            
                                for j in 0..<AppConstants.selectedFilter!.selectedAccounts.count
                                {
                                    if selectFilterData!.hierarchy[i].accountNumber ==  AppConstants.selectedFilter!.selectedAccounts[j]
                                    {
                                        for k in 0..<selectFilterData!.hierarchy[i].brandNameList.count
                                        {
                                            brandlist.append(selectFilterData!.hierarchy[i].brandNameList[k])
                                            for l in 0..<selectFilterData!.hierarchy[i].brandNameList[k].locationNameList.count
                                            {
                                                origLocations.append(selectFilterData!.hierarchy[i].brandNameList[k].locationNameList[l].locationName)
                                            }
                                        }
                                    }
                                                       
                                 }
                        }
                        
                        origLocations = Array(Set(origLocations))
                        lblAccntNumbrCount.text = String(selectFilterData!.accountList.count)
                        lblBrandCount.text = String(AppConstants.selectedFilter!.selectedBrands.count)
                           
                        lblLocationCountView.text = String(origLocations.count)
                                                originalAccounts = selectFilterData!.accountList
                        originalBrands = AppConstants.selectedFilter!.selectedBrands
                        originalLocations = origLocations
                        SelectLocationViewController.selectedfinalAcc = AppConstants.selectedFilter!.selectedAccounts
                        SelectLocationViewController.selectedfinalLocation = AppConstants.selectedFilter!.selectedLocations
                        
                    } else {
                        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
                                        
                        lblAccntNumbrCount.text = String(selectFilterData!.accountList.count)
                        lblBrandCount.text = String(AppConstants.selectedFilter!.selectedBrands.count)
                        lblLocationCountView.text = String(AppConstants.selectedFilter!.selectedLocations.count)
                        originalAccounts = selectFilterData!.accountList
                        originalBrands = AppConstants.selectedFilter!.selectedBrands
                        originalLocations = AppConstants.selectedFilter!.selectedLocations
                        SelectLocationViewController.selectedfinalAcc = AppConstants.selectedFilter!.selectedAccounts
                    }
                    
                 
                    
                } else if UserDefaults.standard.value(forKey: "priorityOne") as? String ?? "" == "b" {
                    
                    if UserDefaults.standard.value(forKey: "priorityTwo") as? String ?? "" == "a" {

                                           
                    } else if UserDefaults.standard.value(forKey: "priorityTwo") as? String ?? "" == "l" {
                                           
                               
                                                                                  
                    } else {
                        
                        originalAccounts = AppConstants.selectedFilter!.selectedAccounts
                        originalBrands = selectFilterData!.brandList
                        originalLocations = AppConstants.selectedFilter!.selectedLocations
                        SelectLocationViewController.selectedfinalBrand = AppConstants.selectedFilter!.selectedBrands
                        lblAccntNumbrCount.text = String(AppConstants.selectedFilter!.selectedAccounts.count)
                        lblBrandCount.text = String(selectFilterData!.brandList.count)
                        lblLocationCountView.text = String(AppConstants.selectedFilter!.selectedLocations.count)
                    }
                    
                    
                 
                } else if UserDefaults.standard.value(forKey: "priorityOne") as? String ?? "" == "l" {
                    
                    if UserDefaults.standard.value(forKey: "priorityTwo") as? String ?? "" == "a" {
                                                         
                    } else if UserDefaults.standard.value(forKey: "priorityTwo") as? String ?? "" == "b" {
                        
                        // july 7
                        
                        var origBrand : [String] = []
                        var accountlist : [String] = []
                        origBrand.removeAll()
                        
                        for i in 0..<selectFilterData!.hierarchy.count {
                            
                                for j in 0..<AppConstants.selectedFilter!.selectedAccounts.count
                                {
                                    if selectFilterData!.hierarchy[i].accountNumber ==  AppConstants.selectedFilter!.selectedAccounts[j]
                                    {
                                        accountlist.append(selectFilterData!.hierarchy[i].accountNumber)

                                        for k in 0..<selectFilterData!.hierarchy[i].brandNameList.count
                                        {
                                            origBrand.append(selectFilterData!.hierarchy[i].brandNameList[k].brandName)
                                        }
                                    }
                            }
                        }
                        
                        origBrand = Array(Set(origBrand))
                        
                        
                        lblAccntNumbrCount.text = String(AppConstants.selectedFilter!.selectedAccounts.count)
                        lblBrandCount.text = String(origBrand.count)
                        lblLocationCountView.text = String(selectFilterData!.locationList.count)
                        
                        
                        // idhar se samaj nahi aa raha plese chek
                        originalAccounts = selectFilterData!.accountList
                        originalBrands = AppConstants.selectedFilter!.selectedBrands
                        originalLocations = origLocations
                        
                        
                        SelectLocationViewController.selectedfinalAcc = AppConstants.selectedFilter!.selectedAccounts
                        SelectLocationViewController.selectedfinalLocation = AppConstants.selectedFilter!.selectedLocations
                        
                        
                        // july 7 over
                        
                                                              
                    } else {
                        
                        originalAccounts = AppConstants.selectedFilter!.selectedAccounts
                        originalBrands = AppConstants.selectedFilter!.selectedBrands
                        originalLocations = selectFilterData!.locationList
                        SelectLocationViewController.selectedfinalLocation = AppConstants.selectedFilter!.selectedLocations
                        lblAccntNumbrCount.text = String(AppConstants.selectedFilter!.selectedAccounts.count)
                        lblBrandCount.text = String(AppConstants.selectedFilter!.selectedBrands.count)
                        lblLocationCountView.text = String(selectFilterData!.brandList.count)
                    }
                   
                   
                } else {
                    
                    originalAccounts = AppConstants.selectedFilter!.selectedAccounts
                    originalBrands = AppConstants.selectedFilter!.selectedBrands
                    originalLocations = AppConstants.selectedFilter!.selectedLocations
                    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
                    cell.selectedView()
                    selectFilterData = filterData[indexPath.row]
                    selectedHeirarchy = filterData[indexPath.row].hierarchy
                    cell.isSelected = true
                }
                
            }
           
            return cell
            
            
        } else {
            
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: cvCompanyLocationListCell.self), for: indexPath) as! cvCompanyLocationListCell
            cell.layer.cornerRadius = 5
            if indexPath.row == 0 {
                if SelectLocationViewController.selectedfinalAcc.count > 0
                {
                    cell.lblName.text = "Acc No.: " + String(SelectLocationViewController.selectedfinalAcc.count)
                }else{
                    cell.lblName.text = "Acc No.: " + String(AppConstants.selectedFilter!.selectedAccounts.count)
                }
                
            }else if indexPath.row == 1{
                if SelectLocationViewController.selectedfinalBrand.count > 0
                {
                    cell.lblName.text = "Brand : " + String(SelectLocationViewController.selectedfinalBrand.count)
                }else{
                    cell.lblName.text = "Brand : " + String(AppConstants.selectedFilter!.selectedBrands.count)
                }
                
            }else{
                if SelectLocationViewController.selectedfinalLocation.count > 0
                {
                    cell.lblName.text = "Location :" + String(SelectLocationViewController.selectedfinalLocation.count)
                }else{
                    cell.lblName.text = "Location :" + String(AppConstants.selectedFilter!.selectedLocations.count)
                }
            }
            
            
            return cell
        }
    }
    */
    
    // By Malu 2
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == cvCompanyList){
            
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: cvCompanyNameCell.self), for: indexPath) as! cvCompanyNameCell
            cell.lblName.text = filterData[indexPath.row].companyName
            
            if filterData[indexPath.row].companyName == AppConstants.selectedFilter?.companyName
            {
                cell.selectedView()
                 selectFilterData = filterData[indexPath.row]
                selectedHeirarchy = filterData[indexPath.row].hierarchy
                cell.isSelected = true
                
                if UserDefaults.standard.value(forKey: "priorityOne") as? String ?? "" == "a"
                {
                    
                    if UserDefaults.standard.value(forKey: "priorityTwo") as? String ?? "" == "b"
                    {
                        var origBrand : [String] = []
                        for i in 0..<selectFilterData!.hierarchy.count
                        {
                            for j in 0..<AppConstants.selectedFilter!.selectedAccounts.count
                            {
                                if selectFilterData!.hierarchy[i].accountNumber ==  AppConstants.selectedFilter!.selectedAccounts[j]
                                {
                                    for k in 0..<selectFilterData!.hierarchy[i].brandNameList.count
                                    {
                                        origBrand.append(selectFilterData!.hierarchy[i].brandNameList[k].brandName)
                                    }
                                }
                            }
                        }
                        origBrand = Array(Set(origBrand))
                        lblAccntNumbrCount.text = String(selectFilterData!.accountList.count)
                        lblBrandCount.text = String(origBrand.count)
                        lblLocationCountView.text = String(AppConstants.selectedFilter!.selectedLocations.count)
                                 originalAccounts = selectFilterData!.accountList
                                               originalBrands = origBrand
                                               originalLocations = AppConstants.selectedFilter!.selectedLocations
                                                   SelectLocationViewController.selectedfinalAcc = AppConstants.selectedFilter!.selectedAccounts
                                                    SelectLocationViewController.selectedfinalBrand = AppConstants.selectedFilter!.selectedBrands
                        
                    }else if UserDefaults.standard.value(forKey: "priorityTwo") as? String ?? "" == "l"
                    {
                        var origLocations : [String] = []
                            for i in 0..<selectFilterData!.hierarchy.count
                             {
                                for j in 0..<AppConstants.selectedFilter!.selectedAccounts.count
                                {
                                    if selectFilterData!.hierarchy[i].accountNumber ==  AppConstants.selectedFilter!.selectedAccounts[j]
                                    {
                                        for k in 0..<selectFilterData!.hierarchy[i].brandNameList.count
                                        {
                                           
                                            for l in 0..<selectFilterData!.hierarchy[i].brandNameList[k].locationNameList.count
                                            {
                                                origLocations.append(selectFilterData!.hierarchy[i].brandNameList[k].locationNameList[l].locationName)
                                            }
                                        }
                                    }
                                                       
                                 }
                        }
                        origLocations = Array(Set(origLocations))
                        lblAccntNumbrCount.text = String(selectFilterData!.accountList.count)
                        lblBrandCount.text = String(AppConstants.selectedFilter!.selectedBrands.count)
                           
                        lblLocationCountView.text = String(origLocations.count)
                                                originalAccounts = selectFilterData!.accountList
                        originalBrands = AppConstants.selectedFilter!.selectedBrands
                        originalLocations = origLocations
                            SelectLocationViewController.selectedfinalAcc = AppConstants.selectedFilter!.selectedAccounts
                             SelectLocationViewController.selectedfinalLocation = AppConstants.selectedFilter!.selectedLocations
                        
                    }else{
                        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
                                        
                                         lblAccntNumbrCount.text = String(selectFilterData!.accountList.count)
                                         lblBrandCount.text = String(AppConstants.selectedFilter!.selectedBrands.count)
                                         lblLocationCountView.text = String(AppConstants.selectedFilter!.selectedLocations.count)
                                         originalAccounts = selectFilterData!.accountList
                                         originalBrands = AppConstants.selectedFilter!.selectedBrands
                                         originalLocations = AppConstants.selectedFilter!.selectedLocations
                                         SelectLocationViewController.selectedfinalAcc = AppConstants.selectedFilter!.selectedAccounts
                    }
                    
                 
                    
                }else if UserDefaults.standard.value(forKey: "priorityOne") as? String ?? "" == "b"
                {
                    if UserDefaults.standard.value(forKey: "priorityTwo") as? String ?? "" == "a"
                              {
                                var origAccounts : [String] = []
                                for i in 0..<selectFilterData!.hierarchy.count
                                {
                                    for j in 0..<selectFilterData!.hierarchy[i].brandNameList.count
                                    {
                                        for k in 0..<AppConstants.selectedFilter!.selectedBrands.count
                                        {
                                              if selectFilterData!.hierarchy[i].brandNameList[j].brandName == AppConstants.selectedFilter!.selectedBrands[k]
                                              {
                                                origAccounts.append(selectFilterData!.hierarchy[i].accountNumber)
                                            }
                                        }
                                      
                                    }
                                }
                                origAccounts = Array(Set(origAccounts))
                              originalAccounts = origAccounts
                                    originalBrands = selectFilterData!.brandList
                                   originalLocations = AppConstants.selectedFilter!.selectedLocations
                                SelectLocationViewController.selectedfinalBrand = AppConstants.selectedFilter!.selectedBrands
                                SelectLocationViewController.selectedfinalAcc = AppConstants.selectedFilter!.selectedAccounts
                                   lblAccntNumbrCount.text = String(origAccounts.count)
                                                                       lblBrandCount.text = String(selectFilterData!.brandList.count)
                                                                       lblLocationCountView.text = String(AppConstants.selectedFilter!.selectedLocations.count)
                                           
                                       }else if UserDefaults.standard.value(forKey: "priorityTwo") as? String ?? "" == "l"
                                       {
                                    
                                        var origLocations : [String] = []
                                        for i in 0..<selectFilterData!.hierarchy.count
                                        {
                                            for j in 0..<selectFilterData!.hierarchy[i].brandNameList.count
                                            {
                                                for k in 0..<AppConstants.selectedFilter!.selectedBrands.count
                                                {
                                                
                                                    if selectFilterData!.hierarchy[i].brandNameList[j].brandName == AppConstants.selectedFilter!.selectedBrands[k]
                                                    {
                                                        
                                                        for l in 0..<selectFilterData!.hierarchy[i].brandNameList[j].locationNameList.count
                                                        {
                                                            origLocations.append(selectFilterData!.hierarchy[i].brandNameList[j].locationNameList[l].locationName)
                                                            
                                                        }
                                                    }
                                                    
                                                }
                                            }
                                        }
                               origLocations = Array(Set(origLocations))
                                                            originalAccounts = AppConstants.selectedFilter!.selectedAccounts
                                                                  originalBrands = selectFilterData!.brandList
                                                                 originalLocations = origLocations
                                                              SelectLocationViewController.selectedfinalBrand = AppConstants.selectedFilter!.selectedBrands
                                                              SelectLocationViewController.selectedfinalLocation = AppConstants.selectedFilter!.selectedLocations
                                                                 lblAccntNumbrCount.text = String(AppConstants.selectedFilter!.selectedAccounts.count)
                                                                                                     lblBrandCount.text = String(selectFilterData!.brandList.count)
                                                                                                     lblLocationCountView.text = String(origLocations.count)
                                                                         
                                                                                  
                    }else{
                        
                                           originalAccounts = AppConstants.selectedFilter!.selectedAccounts
                                           originalBrands = selectFilterData!.brandList
                                           originalLocations = AppConstants.selectedFilter!.selectedLocations
                                           SelectLocationViewController.selectedfinalBrand = AppConstants.selectedFilter!.selectedBrands
                                           lblAccntNumbrCount.text = String(AppConstants.selectedFilter!.selectedAccounts.count)
                                           lblBrandCount.text = String(selectFilterData!.brandList.count)
                                           lblLocationCountView.text = String(AppConstants.selectedFilter!.selectedLocations.count)
                    }
                    
                    
                 
                }else if UserDefaults.standard.value(forKey: "priorityOne") as? String ?? "" == "l"
                {
                    if UserDefaults.standard.value(forKey: "priorityTwo") as? String ?? "" == "a"
                           {
                              
                            var origAcc : [String] = []
                            for  i in 0..<selectFilterData!.hierarchy.count
                            {
                                for j in 0..<selectFilterData!.hierarchy[i].brandNameList.count
                                {
                                    for k in 0..<selectFilterData!.hierarchy[i].brandNameList[j].locationNameList.count
                                    {
                                        for l in 0..<AppConstants.selectedFilter!.selectedLocations.count
                                        {
                                            if AppConstants.selectedFilter!.selectedLocations[l] == selectFilterData!.hierarchy[i].brandNameList[j].locationNameList[k].locationName
                                            {
                                                origAcc.append(selectFilterData!.hierarchy[i].accountNumber)
                                            }
                                        }
                                    }
                                }
                            }
                                                         
                               origAcc = Array(Set(origAcc))
                            originalAccounts = origAcc
                                                                      originalBrands = AppConstants.selectedFilter!.selectedBrands
                                                                      originalLocations = selectFilterData!.locationList
                                                                      SelectLocationViewController.selectedfinalLocation = AppConstants.selectedFilter!.selectedLocations
                            SelectLocationViewController.selectedfinalAcc = AppConstants.selectedFilter!.selectedAccounts
                                                                      lblAccntNumbrCount.text = String(origAcc.count)
                                                                      lblBrandCount.text = String(AppConstants.selectedFilter!.selectedBrands.count)
                                                                      lblLocationCountView.text = String(selectFilterData!.locationList.count)
                    
                    }else if UserDefaults.standard.value(forKey: "priorityTwo") as? String ?? "" == "b"
                 {
                    var origBrand : [String] = []
                    for i in 0..<selectFilterData!.hierarchy.count
                    {
                        for j in 0..<selectFilterData!.hierarchy[i].brandNameList.count
                        {
                            for k in 0..<selectFilterData!.hierarchy[i].brandNameList[j].locationNameList.count
                            {
                                for l in 0..<AppConstants.selectedFilter!.selectedLocations.count
                                {
                                
                                if AppConstants.selectedFilter!.selectedLocations[l] == selectFilterData!.hierarchy[i].brandNameList[j].locationNameList[k].locationName
                                {
                                    origBrand.append(selectFilterData!.hierarchy[i].brandNameList[j].brandName)
                                }
                                
                                }
                            }
                        }
                    }
                                                           
                    origBrand = Array(Set(origBrand))
                    originalAccounts = AppConstants.selectedFilter!.selectedAccounts
                                                              originalBrands = origBrand
                                                              originalLocations = selectFilterData!.locationList
                                                              SelectLocationViewController.selectedfinalLocation = AppConstants.selectedFilter!.selectedLocations
                    SelectLocationViewController.selectedfinalBrand = AppConstants.selectedFilter!.selectedBrands
                                                              lblAccntNumbrCount.text = String(AppConstants.selectedFilter!.selectedAccounts.count)
                                                              lblBrandCount.text = String(origBrand.count)
                                                              lblLocationCountView.text = String(selectFilterData!.locationList.count)
                    }else{
                        originalAccounts = AppConstants.selectedFilter!.selectedAccounts
                                           originalBrands = AppConstants.selectedFilter!.selectedBrands
                                           originalLocations = selectFilterData!.locationList
                                           SelectLocationViewController.selectedfinalLocation = AppConstants.selectedFilter!.selectedLocations
                                           lblAccntNumbrCount.text = String(AppConstants.selectedFilter!.selectedAccounts.count)
                                           lblBrandCount.text = String(AppConstants.selectedFilter!.selectedBrands.count)
                                           lblLocationCountView.text = String(selectFilterData!.locationList.count)
                        
                    }
                   
                   
                }else{
                    originalAccounts = AppConstants.selectedFilter!.selectedAccounts
                    originalBrands = AppConstants.selectedFilter!.selectedBrands
                    originalLocations = AppConstants.selectedFilter!.selectedLocations
                    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
                    cell.selectedView()
                    selectFilterData = filterData[indexPath.row]
                    selectedHeirarchy = filterData[indexPath.row].hierarchy
                    cell.isSelected = true
                }
                
                
                
                
                
            }
            
            
            
            return cell
            
            
        }else{
            
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: cvCompanyLocationListCell.self), for: indexPath) as! cvCompanyLocationListCell
            cell.layer.cornerRadius = 5
            if indexPath.row == 0 {
                if SelectLocationViewController.selectedfinalAcc.count > 0
                {
                    cell.lblName.text = "Acc No.:".localiz() + " " +  String(SelectLocationViewController.selectedfinalAcc.count)
                }else{
                    cell.lblName.text = "Acc No.:".localiz() + " " +  String(AppConstants.selectedFilter!.selectedAccounts.count)
                }
                
            }else if indexPath.row == 1{
                if SelectLocationViewController.selectedfinalBrand.count > 0
                {
                    cell.lblName.text = "Brand :".localiz() + " " +  String(SelectLocationViewController.selectedfinalBrand.count)
                }else{
                    cell.lblName.text = "Brand :".localiz() + " " + String(AppConstants.selectedFilter!.selectedBrands.count)
                }
                
            }else{
                if SelectLocationViewController.selectedfinalLocation.count > 0
                {
                    cell.lblName.text = "Location :".localiz() + " " +  String(SelectLocationViewController.selectedfinalLocation.count)
                }else{
                    cell.lblName.text = "Location :".localiz() + " " +  String(AppConstants.selectedFilter!.selectedLocations.count)
                }
            }
            
            
            return cell
        }
    }
    
    
    func heirarchySelectionLogic(filterData : FilterDatum){
        originalLocations.removeAll()
        originalBrands.removeAll()
        AppConstants.merchantNumber.removeAll()
        
        
        if filterData.hierarchy.count > 0
        {
            for i in 0..<originalAccounts.count {
                let accountList : [String] = originalAccounts
                let accountFilteredHierarchy = filterData.hierarchy.filter{
                    $0.accountNumber == accountList[i]
                }
                if accountFilteredHierarchy.count > 0
                {
                    
                    
                    for j in 0..<accountFilteredHierarchy.count
                    {
                        
                        let accountFiletredBrands = accountFilteredHierarchy[j].brandNameList
                        if accountFiletredBrands.count > 0
                        {
                            for k in 0..<accountFiletredBrands.count{
                                originalBrands.append(accountFiletredBrands[k].brandName)
                                let brandFilteredlocationArr = accountFiletredBrands[k].locationNameList
                                if brandFilteredlocationArr.count > 0
                                {
                                    for l in 0..<brandFilteredlocationArr.count{
                                        SelectLocationViewController.selectedfinalLocation.append(brandFilteredlocationArr[l].locationName)
                                        if brandFilteredlocationArr[l].merchantNumber.count > 0
                                        {
                                            for m in 0..<brandFilteredlocationArr[l].merchantNumber.count {
                                                merchantNumbers.append(Int(brandFilteredlocationArr[l].merchantNumber[m].mid)!)
                                            }
                                        }else{
                                            print("filter : ","no merchants")
                                        }
                                    }
                                }else{
                                    print("filter : ","no locations")
                                }
                            }
                        }else{
                            print("filter : ","no brands")
                        }
                    }
                    
                    lblBrandCount.text = String(originalBrands.count)
                    lblLocationCountView.text = String(originalLocations.count)
                    selectedFilter = selectedFilterData(companyName: filterData.companyName, selectedAccounts: originalAccounts, selectedBrands: originalBrands, selectedLocations: originalLocations, cif: filterData.cif, selectedMerchants: AppConstants.merchantNumber, hiearchy: selectedHeirarchy)
                    
                }else{
                    print("filter : ","no heirarchy of selected account")
                }
            }
            
            
        }else{
            print("filter : ","no heirarchy")
        }
        
        
        
        
        cvCompanyLocationList.reloadData()
        
    }
    
    
    @IBOutlet weak var flowlayout: UICollectionViewFlowLayout!
        {
        didSet {
            flowlayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            
        }
    }
    
    
    
    //    func sectionCollapse(sender: tbLocationHeaderCell) {
    //                print("selected index",sender.tag)
    //                if selectedIndx != sender.tag {
    //                    self.thereIsCellTapped = true
    //                    self.selectedIndx = sender.tag
    //                    sender.btnCheck.setImage(UIImage(named: "ic_check_filled.png"), for: .normal)
    //                    sender.lblName.textColor = UIColor.black
    //                    sender.ivArrow.transform = CGAffineTransform(rotationAngle: 0)
    //
    //                }
    //                else {
    //                    // there is no cell selected anymore
    //                    self.thereIsCellTapped = false
    //                    self.selectedIndx = -1
    //                    sender.btnCheck.setImage(UIImage(named: "ic_check_empty.png"), for: .normal)
    //                    sender.lblName.textColor = UIColor.BurganColor.brandGray.lgiht
    //                    sender.ivArrow.transform = CGAffineTransform(rotationAngle: (CGFloat.pi / 2))
    //
    //                }
    //                tbLocationList.beginUpdates()
    //                tbLocationList.endUpdates()
    //      }
    
    
}

//       //MARK: ExpyTableViewDataSourceMethods
//       extension SelectLocationViewController: ExpyTableViewDataSource {
//
//           func tableView(_ tableView: ExpyTableView, canExpandSection section: Int) -> Bool {
//               return true
//           }
//
//           func tableView(_ tableView: ExpyTableView, expandableCellForSection section: Int) -> UITableViewCell {
//               let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: tbCompanyNameCell.self)) as! tbCompanyNameCell
//              // cell.lblName.text = sampleData[section].first!
//               cell.layoutMargins = UIEdgeInsets.zero
//               cell.showSeparator()
//               return cell
//           }
//       }
//
//       //MARK: ExpyTableView delegate methods
//       extension SelectLocationViewController: ExpyTableViewDelegate {
//           func tableView(_ tableView: ExpyTableView, expyState state: ExpyState, changeForSection section: Int) {
//
//               switch state {
//               case .willExpand:
//                   print("WILL EXPAND")
//
//               case .willCollapse:
//                   print("WILL COLLAPSE")
//
//               case .didExpand:
//                   print("DID EXPAND")
//
//               case .didCollapse:
//                   print("DID COLLAPSE")
//               }
//           }
//       }
//
////       extension SelectLocationViewController {
////           func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
////               return (section % 3 == 0) ? "iPhone Models" : nil
////           }
////       }
//
//
//       extension SelectLocationViewController {
//           func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//               //If you don't deselect the row here, seperator of the above cell of the selected cell disappears.
//               //Check here for detail: https://stackoverflow.com/questions/18924589/uitableviewcell-separator-disappearing-in-ios7
//
//               tableView.deselectRow(at: indexPath, animated: false)
//
//               //This solution obviously has side effects, you can implement your own solution from the given link.
//               //This is not a bug of ExpyTableView hence, I think, you should solve it with the proper way for your implementation.
//               //If you have a generic solution for this, please submit a pull request or open an issue.
//
//               print("DID SELECT row: \(indexPath.row), section: \(indexPath.section)")
//           }
//
//
//          func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//               if indexPath.section == selectedIndx && thereIsCellTapped{
//                   return 60
//               }else{
//                   return 0
//               }
//           }
//        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//            return 60
//        }
//
//       }
//
//
//
//       //MARK: UITableView Data Source Methods
//       extension SelectLocationViewController {
//           func numberOfSections(in tableView: UITableView) -> Int {
//               return 3
//           }
//
//           func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//               // Please see https://github.com/okhanokbay/ExpyTableView/issues/12
//               // The cell instance that you return from expandableCellForSection: data source method is actually the first row of belonged section. Thus, when you return 4 from numberOfRowsInSection data source method, first row refers to expandable cell and the other 3 rows refer to other rows in this section.
//               // So, always return the total row count you want to see in that section
//
//             //  print("Row count for section \(section) is \(sampleData[section].count)")
//               return 2 // +1 here is for BuyTableViewCell
//           }
//
//
//        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//             let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "tbLocationHeaderCell") as? tbLocationHeaderCell
//                 headerView?.tag = section
//            headerView?.delegate = self
//
//                   return headerView
//        }
//
//           func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//
//                   let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: tbLocationNameCell.self)) as! tbLocationNameCell
//                   //cell.lblName.text = (sampleData[indexPath.section])[indexPath.row]
//                   cell.layoutMargins = UIEdgeInsets.zero
//                   cell.hideSeparator()
//                   return cell
//
//           }
//       }
extension UITextField {
    
    func underlined() {
        
        let border = CALayer()
        let width = CGFloat(3.0)
        border.borderColor = UIColor.red.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: width)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        
    }
    
}
extension Array {
    func removingDuplicates<T: Equatable>(byKey key: KeyPath<Element, T>)  -> [Element] {
        var result = [Element]()
        var seen = [T]()
        for value in self {
            let key = value[keyPath: key]
            if !seen.contains(key) {
                seen.append(key)
                result.append(value)
            }
        }
        return result
    }
}
