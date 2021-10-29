//
//  FilterSelectionViewController.swift
//  Burgan
//
//  Created by Malti Maurya on 31/03/20.
//  Copyright ©️ 2020 1st iMac. All rights reserved.
//

import UIKit

class FilterSelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    var popupType  = 0
    var searchActive : Bool = false
    var filteredAccArr: [String] = []
    var filteredBrandArr : [String] = []
    var filteredLocatnArr : [String] = []
    static var isAccountSelected = false
    static var isBrandSelected = false
    static var isLocationSelected = false

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var selectAllBtn: UIButton!
    @IBOutlet weak var tbList: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblClear: UILabel!
    @IBOutlet weak var lblSelectAll: UILabel!
    var selectAll = false
    weak var locationDelegate : addLocationDelegate?
    weak var selectLocationMerchantdelegate : selectLocationMerchantDelegate?
    var selectedAccounts : [String] = []
    var selectedBrands : [String] = []
    var selectedLocations : [String] = []
    var originalAccounts : [String] = []
    var originalBrands : [String] = []
    var originalLocations : [String] = []
    var datatype = ""
    
    
    
    @IBAction func applyFilter(_ sender: Any) {
        locationDelegate?.addLocation()
        let priorityNo : Int = UserDefaults.standard.value(forKey: "priorityNo") as! Int
        
       
        if popupType == 0 {
            if selectedAccounts.count > 0
            {
                if FilterSelectionViewController.isAccountSelected{
                    if UserDefaults.standard.value(forKey: "priorityOne") as? String ?? ""  == "a"
                    {
                         UserDefaults.standard.setValue(1, forKey: "priorityNo")
                    }else if  UserDefaults.standard.value(forKey: "priorityTwo") as? String ?? ""  == "a"
                    {
                        UserDefaults.standard.setValue(2, forKey: "priorityNo")
                    }else{
                        UserDefaults.standard.setValue(3, forKey: "priorityNo")
                    }
                    selectLocationMerchantdelegate?.selectMerchantLoaction(account: selectedAccounts, brand: [], location: [])
                }else{
                    FilterSelectionViewController.isAccountSelected = true
                    if priorityNo == 0 {
                        UserDefaults.standard.setValue("a", forKey: "priorityOne")
                        UserDefaults.standard.setValue(1, forKey: "priorityNo")
                    }else if priorityNo == 1 {
                        UserDefaults.standard.setValue(2, forKey: "priorityNo")
                        UserDefaults.standard.setValue("a", forKey: "priorityTwo")
                                                     
                    }else{
                        UserDefaults.standard.setValue(3, forKey: "priorityNo")
                        UserDefaults.standard.setValue("a", forKey: "priorityThree")
                    }
                    selectLocationMerchantdelegate?.selectMerchantLoaction(account: selectedAccounts, brand: [], location: [])
                }
                          
            }else{
                showAlertWith(message: AlertMessage(title: "Tijarati".localiz(), body: "Select atleast one account to filter.".localiz()))
            }
           
            
            
        }else if popupType == 1{
            if selectedBrands.count > 0 {
                
           
            if FilterSelectionViewController.isBrandSelected{
                
                if UserDefaults.standard.value(forKey: "priorityOne") as? String ?? ""  == "b"
                {
                     UserDefaults.standard.setValue(1, forKey: "priorityNo")
                }else if  UserDefaults.standard.value(forKey: "priorityTwo") as? String ?? ""  == "b"
                {
                    UserDefaults.standard.setValue(2, forKey: "priorityNo")
                }else{
                    UserDefaults.standard.setValue(3, forKey: "priorityNo")
                }
                selectLocationMerchantdelegate?.selectMerchantLoaction(account: [], brand: selectedBrands, location: [])
            }else{
                FilterSelectionViewController.isBrandSelected = true
                if priorityNo == 0 {
                    UserDefaults.standard.setValue("b", forKey: "priorityOne")
                    UserDefaults.standard.setValue(1, forKey: "priorityNo")
                }else if priorityNo == 1
                {
                    UserDefaults.standard.setValue(2, forKey: "priorityNo")
                    UserDefaults.standard.setValue("b", forKey: "priorityTwo")
                                                
                }else{
                    UserDefaults.standard.setValue(3, forKey: "priorityNo")
                    UserDefaults.standard.setValue("b", forKey: "priorityThree")
                }
                selectLocationMerchantdelegate?.selectMerchantLoaction(account: [], brand:selectedBrands, location: [])
                }
                     
            }else{
                showAlertWith(message: AlertMessage(title: "Tijarati".localiz(), body: "Select atleast one brand to filter.".localiz()))

            }
            
        }else{
            
            if selectedLocations.count > 0
            {
                if FilterSelectionViewController.isLocationSelected{
                    if UserDefaults.standard.value(forKey: "priorityOne") as? String ?? ""  == "l"
                    {
                         UserDefaults.standard.setValue(1, forKey: "priorityNo")
                    }else if  UserDefaults.standard.value(forKey: "priorityTwo") as? String ?? ""  == "l"
                    {
                        UserDefaults.standard.setValue(2, forKey: "priorityNo")
                    }else{
                        UserDefaults.standard.setValue(3, forKey: "priorityNo")
                    }
                    selectLocationMerchantdelegate?.selectMerchantLoaction(account: [], brand: [], location: selectedLocations)
                }else{
                    FilterSelectionViewController.isLocationSelected = true
                    if priorityNo == 0 {
                        UserDefaults.standard.setValue("l", forKey: "priorityOne")
                        UserDefaults.standard.setValue(1, forKey: "priorityNo")
                    }else if priorityNo == 1 {
                        UserDefaults.standard.setValue(2, forKey: "priorityNo")
                        UserDefaults.standard.setValue("l", forKey: "priorityTwo")
                                                                        
                    }else{
                        UserDefaults.standard.setValue(3, forKey: "priorityNo")
                        UserDefaults.standard.setValue("l", forKey: "priorityThree")
                                                                    }
                    selectLocationMerchantdelegate?.selectMerchantLoaction(account: [], brand:[], location: selectedLocations)
                }
            }else{
                showAlertWith(message: AlertMessage(title: "Tijarati".localiz(), body: "Select atleast one location to filter.".localiz()))
            }
          
                               
        }
        
       
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loopThroughSubViewAndAlignTextfieldText(subviews: self.view.subviews)
        
        tbList.delegate = self
        tbList.dataSource = self
        if popupType == 0
        {
            lblTitle.text = "Select Account Numbers".localiz()
            searchBar.placeholder = "Search for Account Nos".localiz()
            
            filteredBrandArr.removeAll()
            originalBrands.removeAll()
            selectedBrands.removeAll()
            
            filteredLocatnArr.removeAll()
            originalLocations.removeAll()
            selectedLocations.removeAll()
        }
        else if popupType == 1
        {
            lblTitle.text = "Select store name".localiz()
//            lblTitle.text = "Select Brands".localiz()
            searchBar.placeholder = "Search for Brands".localiz()
            filteredAccArr.removeAll()
            originalAccounts.removeAll()
            selectedAccounts.removeAll()
            filteredLocatnArr.removeAll()
            originalLocations.removeAll()
            selectedLocations.removeAll()
            
        }
        else
        {
            lblTitle.text = "Select Locations".localiz()
            searchBar.placeholder = "Search for Locations".localiz()
            filteredBrandArr.removeAll()
            originalBrands.removeAll()
            selectedBrands.removeAll()
            
            filteredAccArr.removeAll()
            originalAccounts.removeAll()
            selectedAccounts.removeAll()
        }
        searchBar.barTintColor = UIColor.clear
        searchBar.backgroundColor = UIColor.clear
        searchBar.isTranslucent = true
        searchBar.delegate  = self
        
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBarDelegates()
        if #available(iOS 13, *) {
            searchBar.searchTextField.font = UIFont(name: UIFont.Frutiger.light.rawValue, size: 15.0)
            self.searchBar.searchTextField.backgroundColor = .clear
        } else {
            // show sad face emoji
        }
        selectAllList()
        tbList.reloadData()
        tapGesture()
    }
    
    func tapGesture(){
        let tapSelectAllGesture = UITapGestureRecognizer(target: self, action: #selector(self.selectAllList))
        lblSelectAll.isUserInteractionEnabled = true; self.lblSelectAll.addGestureRecognizer(tapSelectAllGesture)
        
        let tapClearAllGesture = UITapGestureRecognizer(target: self, action: #selector(self.clearAll))
        lblClear.isUserInteractionEnabled = true;
        self.lblClear.addGestureRecognizer(tapClearAllGesture)
    }
    
    // sanket 30 jul
    var fromClear : Bool = false
    
    @objc func clearAll(sender: UITapGestureRecognizer){
        selectAllBtn.setImage(UIImage(named: "ic_checkbox_disabled"), for: .normal)
//        fromClear = true
        selectAll = false
        if popupType == 0 {
            
            selectedAccounts.removeAll()
            
        }else if popupType == 1{
            selectedBrands.removeAll()
        }else{
            selectedLocations.removeAll()
        }
        tbList.reloadData()
        
    }
    // sanket 30 jul over
    
    // sanket 31 jul 2020
    @objc func selectAllList(sender: UITapGestureRecognizer? = nil){
        
        /*
        if(selectAll){
            selectAll = false
            lblSelectAll.textColor = UIColor.BurganColor.brandGray.medium
            selectAllBtn.setImage(UIImage(named: "ic_checkbox_disabled"), for: .normal)
            
        }else
        {
            lblSelectAll.textColor = UIColor.black
            selectAllBtn.setImage(UIImage(named: "ic_checkbox_enabled"), for: .normal)
            
            selectAll = true
            
        }
        if popupType == 0 {
            if selectedAccounts.count == 0
            {
                selectedAccounts = originalAccounts
            }
            
        }else if popupType == 1{
            
            if selectedBrands.count == 0
            {
                selectedBrands = originalBrands
            }
            
        }else{
            if selectedLocations.count == 0
            {
                selectedLocations = originalLocations
            }
        }
        tbList.reloadData()
        */
        
//        if(selectAll){
//             selectAll = false
//             lblSelectAll.textColor = UIColor.BurganColor.brandGray.medium
//             selectAllBtn.setImage(UIImage(named: "ic_checkbox_disabled"), for: .normal)
//             if popupType == 0 {
//                 selectedAccounts.removeAll()
//
//                    }else if popupType == 1{
//
//                 selectedBrands.removeAll()
//
//                    }else{
//                 selectedLocations.removeAll()
//                    }
//         }else
//         {
             lblSelectAll.textColor = UIColor.black
             selectAllBtn.setImage(UIImage(named: "ic_checkbox_enabled"), for: .normal)
             
             selectAll = true
             if popupType == 0 {
                
//                if selectedAccounts.count == 0
//                {
//                    selectedAccounts = originalAccounts
//                }
                selectedAccounts.removeAll()
                selectedAccounts = originalAccounts
                        
             }else if popupType == 1{
                        
//                if selectedBrands.count == 0
//                {
//                    selectedBrands = originalBrands
//                }
                selectedBrands.removeAll()
                selectedBrands = originalBrands

             }else{
//                if selectedLocations.count == 0
//                {
//                    selectedLocations = originalLocations
//                }
                selectedLocations.removeAll()
                selectedLocations = originalLocations
        }
             
//         }
        
         tbList.reloadData()
    }
    // sanket 31 jul 2020 over
    
    @IBAction func SelectAllOptions(_ sender: Any) {
        
        lblSelectAll.textColor = UIColor.black
                     selectAllBtn.setImage(UIImage(named: "ic_checkbox_enabled"), for: .normal)
                     
                     selectAll = true
                     if popupType == 0 {
                        if selectedAccounts.count == 0
                        {
                            selectedAccounts = originalAccounts
                        }
        //                selectedAccounts = originalAccounts
                                
                     }else if popupType == 1{
                                
                        if selectedBrands.count == 0
                        {
                            selectedBrands = originalBrands
                        }
        //                        selectedBrands = originalBrands

                     }else{
                        if selectedLocations.count == 0
                        {
                            selectedLocations = originalLocations
                        }
                        
        //                selectedLocations = originalLocations

                }
                     
        //         }
                
                 tbList.reloadData()
        
    }
    
    
    private func searchBarDelegates(){
        configureSearchBarTextField()
        
        searchBar.backgroundColor = UIColor.clear
    }
    override func viewWillAppear(_ animated: Bool) {
        searchBarDelegates()
        
    }
    func configureSearchBarTextField() {
        for subView in searchBar.subviews  {
            for subsubView in subView.subviews  {
                if let textField = subsubView as? UITextField {
                    var bounds: CGRect
                    bounds = textField.frame
                    bounds.size.height = 35 //(set height whatever you want)
                    textField.bounds = bounds
                    let attributeDict = [NSAttributedString.Key.foregroundColor: UIColor.BurganColor.brandGray.lgiht,
                                         NSAttributedString.Key.font:UIFont(name: UIFont.Frutiger.light.rawValue, size: 15.0)]
                    
                    textField.attributedPlaceholder =  NSAttributedString(string: "Search for Account Nos".localiz(), attributes: attributeDict)
                    textField.layer.cornerRadius = 0
                    textField.layer.borderWidth = 1.0
                    textField.layer.borderColor = UIColor(red:0.00, green:0.87, blue:0.39, alpha:1.0).cgColor
                    textField.backgroundColor = UIColor.white
                }
            }
        }
    }
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        
        searchBar.text = nil
        searchBar.resignFirstResponder()
        tbList.resignFirstResponder()
        self.searchBar.showsCancelButton = false
        tbList.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //searchActive = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    // sanket 31 jul 2020
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        fromClear = false
        self.searchActive = true;
        self.searchBar.showsCancelButton = true
        
        if popupType == 0 {
            
            filteredAccArr.removeAll()
            guard !searchText.isEmpty  else { filteredAccArr = originalAccounts;
                self.tbList.reloadData()
                return }
            
            filteredAccArr = originalAccounts.filter{
                $0.lowercased().contains(searchText.lowercased())
            }
            
        }else if popupType == 1{
            filteredBrandArr.removeAll()
            guard !searchText.isEmpty  else { filteredBrandArr = originalBrands;
                self.tbList.reloadData()
                return }
            
            filteredBrandArr = originalBrands.filter{
                $0.lowercased().contains(searchText.lowercased())
            }
            
        }else{
            print(filteredLocatnArr)
            filteredLocatnArr.removeAll()
            guard !searchText.isEmpty  else {
                print(filteredLocatnArr)
                
                filteredLocatnArr = originalLocations;
                self.tbList.reloadData()
                return }
            
            filteredLocatnArr = originalLocations.filter{
                $0.lowercased().contains(searchText.lowercased())
            }
        }
        
        self.tbList.reloadData()
        
    }
    // sanket 31 jul 2020 over
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if popupType == 0{
            if searchActive{
                return filteredAccArr.count
            }else{
               return originalAccounts.count
            }
        }else if popupType == 1{
            if searchActive{
                return filteredBrandArr.count
            }else{

               return originalBrands.count
            }
        }else{
            if searchActive {
                return filteredLocatnArr.count
            }else{
                

          return originalLocations.count
            }
        }
        
    }
    
    // sanket 30 jul
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tbFilterListCell", for: indexPath) as! tbFilterListCell
        cell.lblMIDCount.isHidden = true
        if(selectAll){
            cell.selected()
            cell.selectedCell = true
            
                       if popupType == 0
                       {
                           if searchActive {
                               if selectedAccounts.count > 0
                               {
                                   cell.lblName.text = filteredAccArr[indexPath.row]
                                   for i in 0..<selectedAccounts.count {
                                       if filteredAccArr[indexPath.row] == selectedAccounts[i]
                                        {
                                            cell.selected()
                                            cell.selectedCell = true
                                            break
                                        }
                                        else
                                        {
                                            cell.deSelected()
                                            cell.selectedCell = false
                                        }
                                   }
                               }else{
                                       
                                   cell.lblName.text = filteredAccArr[indexPath.row]
                               }
                               
                           }else{
                               if selectedAccounts.count > 0
                               {
                                    
                                cell.lblName.text = originalAccounts[indexPath.row]
                                
                                for i in 0..<selectedAccounts.count {
                                       if originalAccounts[indexPath.row] == selectedAccounts[i]
                                       {
                                           cell.selected()
                                           cell.selectedCell = true
                                        break
                                       }
                                       else
                                       {
                                            cell.deSelected()
                                            cell.selectedCell = false
                                        }

                                   }
                               }else{
                                       
                                   cell.lblName.text = originalAccounts[indexPath.row]
                               }
                               
                               
                           }
                           
                       }else if popupType == 1{
                           if searchActive {
                               if selectedBrands.count > 0
                               {
                                    cell.lblName.text = filteredBrandArr[indexPath.row]
                                   for i in 0..<selectedBrands.count {
                                       if filteredBrandArr[indexPath.row] == selectedBrands[i]
                                       {
                                           cell.selected()
                                           cell.selectedCell = true
                                        break
                                       }
                                    else
                                    {
                                         cell.deSelected()
                                         cell.selectedCell = false
                                     }
                                   }
                                   
                               }else{
                                       
                                   cell.lblName.text = filteredBrandArr[indexPath.row]
                                   
                               }
                               
                           }else{
                               if selectedBrands.count > 0
                               {
                                    cell.lblName.text = originalBrands[indexPath.row]
                                   for i in 0..<selectedBrands.count {
                                       if originalBrands[indexPath.row] == selectedBrands[i]
                                       {
                                           cell.selected()
                                           cell.selectedCell = true
                                        break
                                       }
                                       else
                                       {
                                            cell.deSelected()
                                            cell.selectedCell = false
                                        }

                                   }
                                   
                               }else{
                                       
                                   cell.lblName.text = originalBrands[indexPath.row]
                                   
                               }
                               
                           }
                       }else{
                           if searchActive{
                               if selectedLocations.count > 0
                               {
                                    cell.lblName.text = filteredLocatnArr[indexPath.row]

                                   for i in 0..<selectedLocations.count {
                                       if filteredLocatnArr[indexPath.row] == selectedLocations[i]
                                       {
                                           cell.selected()
                                           cell.selectedCell = true
                                        break
                                       }
                                       else
                                       {
                                            cell.deSelected()
                                            cell.selectedCell = false
                                        }
                                   }
                                   
                               }else{
                                       
                                   cell.lblName.text = filteredLocatnArr[indexPath.row]
                               }
                           }else{
                               if selectedLocations.count > 0
                               {
                                    cell.lblName.text = originalLocations[indexPath.row]

                                   for i in 0..<selectedLocations.count {
                                       if originalLocations[indexPath.row] == selectedLocations[i]
                                       {
                                           cell.selected()
                                           cell.selectedCell = true
                                        break
                                       }
                                    else
                                    {
                                         cell.deSelected()
                                         cell.selectedCell = false
                                     }
                                       
                                   }
                                   
                               }else{
                                     
                                   cell.lblName.text = originalLocations[indexPath.row]
                                   
                               }
                               
                               
                           }
                           
                       }
        }else{
            cell.selectedCell = false
            cell.deSelected()
            
            
            if popupType == 0
            {
                if searchActive {
                    if selectedAccounts.count > 0
                    {
                        cell.lblName.text = filteredAccArr[indexPath.row]
                        for i in 0..<selectedAccounts.count {
                            if filteredAccArr[indexPath.row] == selectedAccounts[i]
                            {
//                                if fromClear == true
//                                {
//
//                                    cell.deSelected()
//                                    cell.selectedCell = false
//
//                                }else
//                                {
                                    cell.selected()
                                    cell.selectedCell = true
//                                }
                                break
                            }
                            else
                            {
                                 cell.deSelected()
                                 cell.selectedCell = false
                             }

                        }
                    }else{
                            
                        cell.lblName.text = filteredAccArr[indexPath.row]
                    }
                    
                }else{
                    if selectedAccounts.count > 0
                    {
                         cell.lblName.text = originalAccounts[indexPath.row]

                        for i in 0..<selectedAccounts.count {
                            if originalAccounts[indexPath.row] == selectedAccounts[i]
                            {
                                cell.selected()
                                cell.selectedCell = true
                                break
                            }
                            else
                            {
                                 cell.deSelected()
                                 cell.selectedCell = false
                             }
                        }
                    }else{
                            
                        cell.lblName.text = originalAccounts[indexPath.row]
                    }
                    
                    
                }
                
            }else if popupType == 1{
                if searchActive {
                    if selectedBrands.count > 0
                    {
                        cell.lblName.text = filteredBrandArr[indexPath.row]
                         
                        for i in 0..<selectedBrands.count {
                            if filteredBrandArr[indexPath.row] == selectedBrands[i]
                            {
//                                if fromClear == true
//                                {
                                    
//                                    cell.deSelected()
//                                    cell.selectedCell = false
//
//                                }else
//                                {
                                    cell.selected()
                                    cell.selectedCell = true
//                                }
                                break
                            }
                            else
                            {
                                 cell.deSelected()
                                 cell.selectedCell = false
                             }

                        }
                        
                    }else{
                            
                        cell.lblName.text = filteredBrandArr[indexPath.row]
                        
                    }
                    
                }else{
                    if selectedBrands.count > 0
                    {
                         cell.lblName.text = originalBrands[indexPath.row]
                        for i in 0..<selectedBrands.count {
                            if originalBrands[indexPath.row] == selectedBrands[i]
                            {
                                cell.selected()
                                cell.selectedCell = true
                                break
                            }
                            else
                            {
                                 cell.deSelected()
                                 cell.selectedCell = false
                             }

                        }
                        
                    }else{
                            
                        cell.lblName.text = originalBrands[indexPath.row]
                        
                    }
                    
                }
            }else{
                if searchActive{
                    if selectedLocations.count > 0
                    {
                         cell.lblName.text = filteredLocatnArr[indexPath.row]

                        for i in 0..<selectedLocations.count {
                            if filteredLocatnArr[indexPath.row] == selectedLocations[i]
                            {
//                                if fromClear == true
//                                {
//                                    cell.deSelected()
//                                    cell.selectedCell = false
//
//                                }
//                                else
//                                {
                                    cell.selected()
                                    cell.selectedCell = true
//                                }
                                
                                break
                            }
                            else
                            {
                                 cell.deSelected()
                                 cell.selectedCell = false
                             }
                        }
                        
                    }else{
                            
                        cell.lblName.text = filteredLocatnArr[indexPath.row]
                        
                    }
                }else{
                    if selectedLocations.count > 0
                    {
                         cell.lblName.text = originalLocations[indexPath.row]
                        for i in 0..<selectedLocations.count {
                            if originalLocations[indexPath.row] == selectedLocations[i]
                            {
                                cell.selected()
                                cell.selectedCell = true
                                break
                            }
                            else
                            {
                                 cell.deSelected()
                                 cell.selectedCell = false
                             }

                        }
                        
                    }else{
                          
                        cell.lblName.text = originalLocations[indexPath.row]
                        
                    }
                    
                    
                }
                
            }
            
            
            
        }
        
//        if fromClear == true
//        {
//            cell.selected()
//            cell.selectedCell = true
//        }
        
        return cell
    }
    // sanket 30 jul over
    
    // sanket 31 jul 2020
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
         let cell = tableView.cellForRow(at: indexPath) as! tbFilterListCell
        if popupType == 0 {
            if(cell.selectedCell){
             selectedAccounts.removeAll{$0 == originalAccounts[indexPath.row]}
                            cell.selectedCell = false
                            cell.deSelected()
            }else{
                selectedAccounts.append(originalAccounts[indexPath.row])
                cell.selectedCell = true
                             cell.selected()
                
               
            }
        }else if popupType == 1{
            if(cell.selectedCell){
               selectedBrands.removeAll{$0 == originalBrands[indexPath.row]}
               
               cell.deSelected()
            }else{
                selectedBrands.append(originalBrands[indexPath.row])
                cell.selected()
            }
        }else{
            if(cell.selectedCell){
                
                if searchActive == true
                {
                    selectedLocations.removeAll{$0 == filteredLocatnArr[indexPath.row]}
                }
                else
                {
                    selectedLocations.removeAll{$0 == originalLocations[indexPath.row]}
                }
//               selectedLocations.removeAll{$0 == originalLocations[indexPath.row]}
//               selectedLocations.removeAll{$0 == cell.lblName.text}
                print(selectedLocations)
                print(originalLocations)
                             cell.deSelected()
            }else{
                selectedLocations.append(originalLocations[indexPath.row])
//                selectedLocations.append(cell.lblName.text!)

                cell.selected()
              
            }
        }
        tbList.beginUpdates()
        tbList.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! tbFilterListCell
        
        if popupType == 0 {
            if(cell.selectedCell){
                if searchActive == true
                {
                    selectedAccounts.removeAll{$0 == filteredAccArr[indexPath.row]}
                }
                else
                {
                    selectedAccounts.removeAll{$0 == originalAccounts[indexPath.row]}
                }
                
                
                cell.selectedCell = false
                cell.deSelected()
//                if UserDefaults.standard.value(forKey: "priorityOne") as? String ?? "" == "a" {
//                    selectedAccounts.removeAll{$0 == originalAccounts[indexPath.row]}
//                    cell.selectedCell = false
//                    cell.deSelected()
//                } else {
//
//                    selectedAccounts.removeAll{$0 == selectedAccounts[indexPath.row]}
//                    cell.selectedCell = false
//                    cell.deSelected()
//                }
                
                if selectedAccounts.count != originalAccounts.count {
                    selectAllBtn.setImage(UIImage(named: "ic_checkbox_disabled"), for: .normal)
                } else {
                    selectAllBtn.setImage(UIImage(named: "ic_checkbox_enabled"), for: .normal)
                }
                
            }else{
                if searchActive == true
                {
                    selectedAccounts.append(filteredAccArr[indexPath.row])
                }
                else
                {
                    selectedAccounts.append(originalAccounts[indexPath.row])
                }
                
                
                cell.selected()
                cell.selectedCell = true

                if selectedAccounts.count == originalAccounts.count {
                    selectAllBtn.setImage(UIImage(named: "ic_checkbox_enabled"), for: .normal)
                } else {
                    selectAllBtn.setImage(UIImage(named: "ic_checkbox_disabled"), for: .normal)
                }
                
//               if UserDefaults.standard.value(forKey: "priorityOne") as? String ?? "" == "a" {
//                   selectedAccounts.append(originalAccounts[indexPath.row])
//                   cell.selected()
//                   cell.selectedCell = true
//               } else {
//                   selectedAccounts.append(selectedAccounts[indexPath.row])
//                   cell.selected()
//                   cell.selectedCell = true
//               }
            }
        }else if popupType == 1{
            if(cell.selectedCell){
                
                if searchActive == true
                {
                    selectedBrands.removeAll{$0 == filteredBrandArr[indexPath.row]}
                }
                else
                {
                    selectedBrands.removeAll{$0 == originalBrands[indexPath.row]}
                }
                
//               selectedBrands.removeAll{$0 == originalBrands[indexPath.row]}
                cell.selectedCell = false
               cell.deSelected()
//                if UserDefaults.standard.value(forKey: "priorityOne") as? String ?? "" == "b" {
//                    selectedBrands.removeAll{$0 == originalBrands[indexPath.row]}
//                    cell.deSelected()
//                } else {
//                    selectedBrands.removeAll{$0 == selectedBrands[indexPath.row]}
//                    cell.deSelected()
//                }
                
                if selectedBrands.count != originalBrands.count {
                    selectAllBtn.setImage(UIImage(named: "ic_checkbox_disabled"), for: .normal)
                } else {
                    selectAllBtn.setImage(UIImage(named: "ic_checkbox_enabled"), for: .normal)
                }
                
            }else{
                if searchActive == true
                {
                    selectedBrands.append(filteredBrandArr[indexPath.row])
                }
                else
                {
                    selectedBrands.append(originalBrands[indexPath.row])
                }
                
//                selectedBrands.append(originalBrands[indexPath.row])
                cell.selected()
                cell.selectedCell = true
//                if UserDefaults.standard.value(forKey: "priorityOne") as? String ?? "" == "b" {
//                    selectedBrands.append(originalBrands[indexPath.row])
//                    cell.selected()
//                } else {
//                    selectedBrands.append(selectedBrands[indexPath.row])
//                    cell.selected()
//                }
                
                if selectedBrands.count == originalBrands.count {
                    selectAllBtn.setImage(UIImage(named: "ic_checkbox_enabled"), for: .normal)
                } else {
                    selectAllBtn.setImage(UIImage(named: "ic_checkbox_disabled"), for: .normal)
                }
            }
        }else{
            if(cell.selectedCell){
                
                print(searchActive)
                if searchActive == true
                {
                    selectedLocations.removeAll{$0 == filteredLocatnArr[indexPath.row]}
                }
                else
                {
                    selectedLocations.removeAll{$0 == originalLocations[indexPath.row]}
                }
//                selectedLocations.removeAll{$0 == originalLocations[indexPath.row]}
//                selectedLocations.removeAll{$0 == filteredLocatnArr[indexPath.row]}
                cell.selectedCell = false
                cell.deSelected()
//                if UserDefaults.standard.value(forKey: "priorityOne") as? String ?? "" == "l" {
//                    selectedLocations.removeAll{$0 == originalLocations[indexPath.row]}
//                    cell.deSelected()
//                } else {
//                    selectedLocations.removeAll{$0 == selectedLocations[indexPath.row]}
//                    cell.deSelected()
//                }
                
                if selectedLocations.count != originalLocations.count {
                    selectAllBtn.setImage(UIImage(named: "ic_checkbox_disabled"), for: .normal)
                } else {
                    selectAllBtn.setImage(UIImage(named: "ic_checkbox_enabled"), for: .normal)
                }
                
            }else{
                if searchActive == true
                {
                    selectedLocations.append(filteredLocatnArr[indexPath.row])
                }
                else
                {
                    selectedLocations.append(originalLocations[indexPath.row])
                }
//                selectedLocations.append(originalLocations[indexPath.row])
                cell.selected()
                cell.selectedCell = true
//                if UserDefaults.standard.value(forKey: "priorityOne") as? String ?? "" == "l" {
//                    selectedLocations.append(originalLocations[indexPath.row])
//                    cell.selected()
//                } else {
//                    selectedLocations.append(selectedLocations[indexPath.row])
//                    cell.selected()
//                }
                
                if selectedLocations.count == originalLocations.count {
                    selectAllBtn.setImage(UIImage(named: "ic_checkbox_enabled"), for: .normal)
                } else {
                    selectAllBtn.setImage(UIImage(named: "ic_checkbox_disabled"), for: .normal)
                }
            }
        }
        tbList.beginUpdates()
        tbList.endUpdates()
    }
    // sanket 31 jul 2020 over
    
}
