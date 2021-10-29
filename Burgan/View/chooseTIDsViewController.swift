//
//  chooseTIDsViewController.swift
//  Burgan
//
//  Created by Malti Maurya on 08/04/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit
import ExpyTableView
import SPStorkController

class chooseTIDsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate
{
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tbTIDList: ExpyTableView!
    @IBOutlet weak var btnSelectAll: UIButton!
    @IBOutlet weak var MIDsCollectionView: UICollectionView!
    weak var delegate : selectMIDsDelegate?
    var selectLocations : [LocationNameList] = []
   var searchLocations : [LocationNameList] = []
    var selectedData : [[String : Any]] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //searchLocations = selectLocations
        print(searchLocations)
        
        self.SelectAllMID()
        
        self.loopThroughSubViewAndAlignTextfieldText(subviews: self.view.subviews)
        
        tbTIDList.dataSource = self
        tbTIDList.delegate = self
        
        tbTIDList.rowHeight = 60
        tbTIDList.estimatedRowHeight = 60
        
        //Alter the animations as you want
        tbTIDList.expandingAnimation = .fade
        tbTIDList.collapsingAnimation = .fade
        
        searchBar.placeholder = "Search for MID".localiz()
        
        searchBar.barTintColor = UIColor.clear
        searchBar.backgroundColor = UIColor.clear
        searchBar.isTranslucent = true
        searchBar.delegate  = self
        if #available(iOS 13, *) {
            searchBar.searchTextField.font = UIFont(name: UIFont.Frutiger.light.rawValue, size: 15.0)
            self.searchBar.searchTextField.backgroundColor = .clear
          } else {
            // show sad face emoji
        }
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBarDelegates()
        tbTIDList.reloadData()
        
        if AppConstants.language == .ar {
            searchBar.semanticContentAttribute = .forceRightToLeft
        } else {
            searchBar.semanticContentAttribute = .forceLeftToRight
        }
        
        tbTIDList.reloadData()
    }
    
    @IBAction func addMIDs(_ sender: Any) {
        if merchantNumber.count > 0 {
            delegate?.selectMIDs(merchantNumber: merchantNumber)
            self.dismiss(animated: true, completion: nil)
        }else{
            showAlertDismissOnly(message: AlertMessage(title: "Select MID".localiz(), body: "Select at least one merchant ID to continue.".localiz()))
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        searchBarDelegates()
    }
    
    private func searchBarDelegates(){
        configureSearchBarTextField()
        searchBar.backgroundColor = UIColor.clear
    }
    
    func configureSearchBarTextField() {
        for subView in searchBar.subviews  {
            for subsubView in subView.subviews  {
                if let textField = subsubView as? UITextField {
                    var bounds: CGRect
                    bounds = textField.frame
                    bounds.size.height = 35 //(set height whatever you want)
                    textField.bounds = bounds
                    textField.layer.cornerRadius = 5
                    textField.layer.borderWidth = 1.0
                    textField.layer.borderColor = UIColor.BurganColor.brandBlue.light.cgColor //UIColor(red:0.00, green:0.87, blue:0.39, alpha:1.0).cgColor
                    textField.backgroundColor = UIColor.white
                }
            }
        }
    }
    
    //MARK: UISearchbar Delegates Methods
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
          // searchActive = true
      }

      func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
          // searchActive = false
      }

      func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
          //searchActive = false;

        searchBar.text = nil
        searchBar.resignFirstResponder()
        self.searchBar.showsCancelButton = false
        self.tbTIDList.resignFirstResponder()
        self.searchLocations = self.selectLocations
        self.tbTIDList.reloadData()
      }

      func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
          // searchActive = false
        searchBar.resignFirstResponder()
      }

      func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
      }

      
      func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        //self.searchActive = true;
        self.searchBar.showsCancelButton = true

        searchLocations.removeAll()
        
        guard !searchText.isEmpty  else { searchLocations = selectLocations; tbTIDList.reloadData(); return }

//        searchLocations = selectLocations.filter{
//            //$0.locationName.lowercased().contains(searchText.lowercased())
//            //users = users.filter { $0.pets.contains(where: { petArr.contains($0) }) }
//
//            $0.merchantNumber.contains(where: { $0.mid.contains(searchText) })
//
//        }
        
        var filteredLocationListAry : [LocationNameList] = []
        
        for i in 0..<selectLocations.count {
        
            //var mylocationDict :  LocationNameList?
            
            let locationNameStr = selectLocations[i].locationName
            var merchantAry : [MerchantNumber] = []
            
            
            for j in 0..<selectLocations[i].merchantNumber.count {
                                
                let myIndexPath = IndexPath(item: j+1, section: i)
                print("Selected sub row : \(myIndexPath.row)")
                print("Selected sub row : \(myIndexPath.section)")
                
                let mid = selectLocations[myIndexPath.section].merchantNumber[myIndexPath.row-1].mid
                print(mid)
                
                if mid.contains(searchText) {
                    merchantAry.append(selectLocations[myIndexPath.section].merchantNumber[myIndexPath.row-1])
                }
            }
            
            //mylocationDict = LocationNameList.init(locationName: locationNameStr, merchantNumber: merchantAry)
//            mylocationDict?.locationName = locationNameStr
//            mylocationDict?.merchantNumber = merchantAry
            
            //filteredLocationListAry.append(mylocationDict!)
            
            if merchantAry.count > 0 {
                filteredLocationListAry.append(LocationNameList.init(locationName: locationNameStr, merchantNumber: merchantAry))
            }
        }
        
        searchLocations = filteredLocationListAry
        
        tbTIDList.reloadData()
    }
    
    //var selectAll = false
    @IBAction func selectAllCell(_ sender: Any) {
        
        /*
        if(selectAll){
            //selectAll = false
            //tbTIDList.reloadData()
            
        } else {
            
            /*
            selectAll = true
            
            for section in 0..<tbTIDList.numberOfSections {
                for row in 0..<tbTIDList.numberOfRows(inSection: section) {
                    let indexPath = IndexPath(row: row, section: section)
                         
                    tbTIDList.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                    tbTIDList.delegate?.tableView?(tbTIDList, didSelectRowAt: indexPath)
                }
            }
            */
            
            self.SelectAllMID()
        }
        */
        
        self.SelectAllMID()
    }
    
    func SelectAllMID() -> Void {
        
        /*
        self.btnSelectAll.setImage(UIImage(named: "ic_checkbox_enabled"), for: .normal)
        selectAll = true
        
        self.selectedData.removeAll()
        self.merchantNumber.removeAll()

        for i in 0..<searchLocations.count {
        
            let sectionNo : Int = i
            var MID : [String] = []
            
            for j in 0..<searchLocations[i].merchantNumber.count {
                
                let myIndexPath = IndexPath(item: j+1, section: i)
                print("Selected sub row : \(myIndexPath.row)")
                
                let mid = searchLocations[myIndexPath.section].merchantNumber[myIndexPath.row-1].mid
                print(mid)
                MID.append(mid)
                merchantNumber.append(mid)
            }
            
            let myDict = [ "section" : sectionNo,
                           "MID" : MID] as [String : Any]
            
            self.selectedData.append(myDict)
        }
        
        print(self.selectedData)
        
        self.tbTIDList.reloadData()
        
        for section in 0..<tbTIDList.numberOfSections {
            for row in 0..<tbTIDList.numberOfRows(inSection: section) {
                let indexPath = IndexPath(row: row, section: section)
                     
                tbTIDList.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                tbTIDList.delegate?.tableView?(tbTIDList, didSelectRowAt: indexPath)
            }
        }
        
        self.MIDsCollectionView.reloadData()
        */
        
        self.btnSelectAll.setImage(UIImage(named: "ic_checkbox_enabled"), for: .normal)
        //selectAll = true
        
        self.merchantNumber.removeAll()

        for i in 0..<searchLocations.count {
                    
            for j in 0..<searchLocations[i].merchantNumber.count {
                
                let myIndexPath = IndexPath(item: j+1, section: i)
                print("Selected sub row : \(myIndexPath.row)")
                
                let mid = searchLocations[myIndexPath.section].merchantNumber[myIndexPath.row-1].mid
                print(mid)
                merchantNumber.append(mid)
            }
        }
                
        self.tbTIDList.reloadData()
        
        for section in 0..<tbTIDList.numberOfSections {
            
            tbTIDList.expand(section)
        }
        
        self.MIDsCollectionView.reloadData()
    }
    
    @IBAction func ClearAll_Btn_Tapped(_ sender: Any) {
        
        self.ClearAllMID()
    }
    
    func ClearAllMID() -> Void {
        
        /*
        self.btnSelectAll.setImage(UIImage(named: "ic_checkbox_disabled"), for: .normal)
        selectAll = false
        
        self.selectedData.removeAll()
        self.merchantNumber.removeAll()
        
        for i in 0..<searchLocations.count {
        
            let sectionNo : Int = i
            let MID : [String] = []
            
            let myDict = [ "section" : sectionNo,
                           "MID" : MID] as [String : Any]
            
            self.selectedData.append(myDict)
        }
        
        print(self.selectedData)
        
        self.tbTIDList.reloadData()
        
        for section in 0..<tbTIDList.numberOfSections {
            for row in 0..<tbTIDList.numberOfRows(inSection: section) {
                let indexPath = IndexPath(row: row, section: section)
                     
                tbTIDList.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                tbTIDList.delegate?.tableView?(tbTIDList, didSelectRowAt: indexPath)
            }
        }
        
        self.MIDsCollectionView.reloadData()
        */
        
        self.btnSelectAll.setImage(UIImage(named: "ic_checkbox_disabled"), for: .normal)
        //selectAll = false
        
        self.merchantNumber.removeAll()
        self.tbTIDList.reloadData()
        self.MIDsCollectionView.reloadData()

    }
    
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cvMIDCell", for: indexPath) as! cvCompanyLocationListCell
        cell.layer.cornerRadius = 5
        cell.lblName.text = "MIDs : " + String(merchantNumber.count)
        
        if AppConstants.language == .ar {
            cell.lblName.textAlignment = .right
        } else {
            cell.lblName.textAlignment = .left
        }
        
        return cell
    }
    
    var merchantNumber : [String] = []
    var merchantcount = 0

}

//MARK: ExpyTableViewDataSourceMethods
extension chooseTIDsViewController: ExpyTableViewDataSource, tbCompanyNameCellDelegate {
    
    func tableView(_ tableView: ExpyTableView, canExpandSection section: Int) -> Bool {
        return true
    }
    
    func tableView(_ tableView: ExpyTableView, expandableCellForSection section: Int) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: "tbTidNameCell")) as! tbCompanyNameCell
        cell.layoutMargins = UIEdgeInsets.zero
        cell.contentView.layer.shadowOpacity = 0.35
        cell.contentView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cell.contentView.layer.shadowRadius = 3.0
        cell.contentView.layer.shadowColor = UIColor.BurganColor.brandGray.lgiht.cgColor
        cell.lblName.text = searchLocations[section].locationName
        cell.lblLocationCount.text = String(searchLocations[section].merchantNumber.count)
        cell.hideSeparator()
        cell.tag = section
        cell.ivCheckBox.tag = section
        cell.delegate = self
        
        /*
        let myDictAry = selectedData.filter{ $0["section"] as! Int == section }
        print("myDictAry : \(myDictAry)")

        if myDictAry.count > 0 {
                       
            let myDict = selectedData.filter{ $0["section"] as! Int == section }.first
            print("myDictAry : \(myDict!)")
                       
            var merchantNos : [String] = []
            merchantNos = myDict!["MID"] as! [String]
            
            if merchantNos.count == searchLocations[section].merchantNumber.count {
                cell.ivCheckBox.setImage(UIImage(named: "ic_checkbox_enabled"), for: .normal)
                cell.lblName.textColor = UIColor.black
                
                //tbTIDList.expand(section)
                
            } else {
                cell.ivCheckBox.setImage(UIImage(named: "ic_checkbox_disabled"), for: .normal)
                cell.lblName.textColor = UIColor.BurganColor.brandGray.lgiht
                //tbTIDList.collapse(section)
            }
                 
        } else {
                       
            cell.ivCheckBox.setImage(UIImage(named: "ic_checkbox_disabled"), for: .normal)
            cell.lblName.textColor = UIColor.BurganColor.brandGray.lgiht
            //tbTIDList.collapse(section)
        }
        */
        
        var isBool : Bool = true
        
        for i in 0..<searchLocations[section].merchantNumber.count {
                                
            if merchantNumber.contains("\(searchLocations[section].merchantNumber[i].mid)") {
                
            } else {
                isBool = false
            }
        }
        
        if isBool == true {
            cell.ivCheckBox.setImage(UIImage(named: "ic_checkbox_enabled"), for: .normal)
            cell.lblName.textColor = UIColor.black
        } else {
            cell.ivCheckBox.setImage(UIImage(named: "ic_checkbox_disabled"), for: .normal)
            cell.lblName.textColor = UIColor.BurganColor.brandGray.lgiht
        }
        
        if AppConstants.language == .ar {
            cell.lblName.textAlignment = .right
        } else {
            cell.lblName.textAlignment = .left
        }
    
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // tbComapnyHeight.constant = 80 * 2
        return searchLocations.count
    }
    
    func btnSelectAllSectionTapped(cell: tbCompanyNameCell) {
        
        //Get the indexpath of cell where button was tapped
        let indexPath = self.tbTIDList.indexPath(for: cell)
        print(indexPath!.row)
        print(indexPath!.section)
        print("Cell Tag \(cell.tag)")
        
        
        if (cell.ivCheckBox.currentImage?.isEqual(UIImage(named: "ic_checkbox_enabled")))! {
            
            // Deselect all option because its already selected
            
            for i in 0..<searchLocations[cell.tag].merchantNumber.count {
                                    
                if merchantNumber.contains("\(searchLocations[cell.tag].merchantNumber[i].mid)") {
                    merchantNumber.removeAll{$0 == "\(searchLocations[cell.tag].merchantNumber[i].mid)"}
                } else {
                }
            }
            
            self.tbTIDList.reloadSections(IndexSet(integer: indexPath!.section), with: .none)
            
        } else {
            
            //Select all opotions
            
            for i in 0..<searchLocations[cell.tag].merchantNumber.count {
                                
                if merchantNumber.contains("\(searchLocations[cell.tag].merchantNumber[i].mid)") {
                    
                } else {
                    merchantNumber.append("\(searchLocations[cell.tag].merchantNumber[i].mid)")
                }
            }
            
            self.tbTIDList.reloadSections(IndexSet(integer: indexPath!.section), with: .none)
            
            tbTIDList.expand(indexPath!.section)
        }
        
            MIDsCollectionView.reloadData()

            
            // below code is for select all check box
            var isSelectAll : Bool = true
            
            for section in 0..<searchLocations.count {
                            
                for myRow in 0..<searchLocations[section].merchantNumber.count {
                    
                    if merchantNumber.contains("\(searchLocations[section].merchantNumber[myRow].mid)") {
                        
                    } else {
                        isSelectAll = false
                    }
                }
            }
            
            if isSelectAll == true {
                btnSelectAll.setImage(UIImage(named: "ic_checkbox_enabled"), for: .normal)
            } else {
                btnSelectAll.setImage(UIImage(named: "ic_checkbox_disabled"), for: .normal)
            }
            
            
        
        /*
        if (cell.ivCheckBox.currentImage?.isEqual(UIImage(named: "ic_checkbox_enabled")))! {
            
            // Deselect all option because its already selected
            let merchantNos : [String] = []
            let myDictAry = selectedData.filter{ $0["section"] as! Int == indexPath!.section }
            print("myDictAry : \(myDictAry)")

            if myDictAry.count > 0 {
                
                let myDict = selectedData.filter{ $0["section"] as! Int == indexPath!.section }.first
                print("myDictAry : \(myDict!)")
                
                
                if let row = self.selectedData.firstIndex(where: {$0["section"] as! Int == indexPath!.section}) {
                    selectedData[row] = ["section" : indexPath!.section,
                                         "MID" : merchantNos]
                }
                
                self.tbTIDList.reloadSections(IndexSet(integer: indexPath!.section), with: .none)
                
                for i in 0..<searchLocations[cell.tag].merchantNumber.count {
                                        
                    if merchantNumber.contains("\(searchLocations[cell.tag].merchantNumber[i].mid)") {
                        merchantNumber.removeAll{$0 == "\(searchLocations[cell.tag].merchantNumber[i].mid)"}
                    } else {
                    }
                }
                
                                
            }
            
        } else {
            
            //Select all opotions
            var merchantNos : [String] = []
            
            for i in 0..<searchLocations[cell.tag].merchantNumber.count {
                
                merchantNos.append("\(searchLocations[cell.tag].merchantNumber[i].mid)")
                
                if merchantNumber.contains("\(searchLocations[cell.tag].merchantNumber[i].mid)") {
                    
                } else {
                    merchantNumber.append("\(searchLocations[cell.tag].merchantNumber[i].mid)")
                }
            }
            

            let myDictAry = selectedData.filter{ $0["section"] as! Int == indexPath!.section }
            print("myDictAry : \(myDictAry)")

            if myDictAry.count > 0 {
                
                let myDict = selectedData.filter{ $0["section"] as! Int == indexPath!.section }.first
                print("myDictAry : \(myDict!)")
                
                
                if let row = self.selectedData.firstIndex(where: {$0["section"] as! Int == indexPath!.section}) {
                    selectedData[row] = ["section" : indexPath!.section,
                                         "MID" : merchantNos]
                }
                
                self.tbTIDList.reloadSections(IndexSet(integer: indexPath!.section), with: .none)
                
                tbTIDList.expand(indexPath!.section)
                
                for i in 0..<searchLocations[cell.tag].merchantNumber.count {
                                        
                    if merchantNumber.contains("\(searchLocations[cell.tag].merchantNumber[i].mid)") {
                        
                    } else {
                        merchantNumber.append("\(searchLocations[cell.tag].merchantNumber[i].mid)")
                    }
                }
                
            } else {
                
                //cell.ivCheckBox.image = UIImage(named: "ic_checkbox_disabled")
                //cell.lblName.textColor = UIColor.BurganColor.brandGray.lgiht
            }
        }
        */
        
        
        // 1
        /*
        if cell.check == true {
            
            tbTIDList.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            tbTIDList.delegate?.tableView?(tbTIDList, didSelectRowAt: indexPath!)
            
            cell.check = false
            cell.ivCheckBox.setImage(UIImage(named: "ic_checkbox_disabled"), for: .normal)
            //cell.ivCheckBox.image = UIImage(named: "ic_checkbox_disabled")
            cell.lblName.textColor = UIColor.BurganColor.brandGray.lgiht
            cell.imageViewArrow.transform = CGAffineTransform(rotationAngle: 0)

            
            for i in 0..<searchLocations[cell.tag].merchantNumber.count {
                let myIndexPath = IndexPath(item: i+1, section: cell.tag)
                print("Deselected sub row : \(myIndexPath.row)")
//                let cell = tbTIDList.cellForRow(at: myIndexPath) as! tbTIDMIDCell
//                cell.check = false
//                cell.ivCheckBox.image = UIImage(named: "ic_checkbox_disabled")
//                let mid = selectLocations[myIndexPath.section].merchantNumber[myIndexPath.row-1].mid
//                cell.lblName.textColor = UIColor.BurganColor.brandGray.lgiht
//                merchantNumber.removeAll{$0 == mid}
            }
            
        } else {
            
            tbTIDList.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            tbTIDList.delegate?.tableView?(tbTIDList, didSelectRowAt: indexPath!)

//            // your code here
//            self?.digitalBooks_TblView.selectRow(at: indexPath, animated: true, scrollPosition: UITableView.ScrollPosition(rawValue: 0)!)
//            self?.tableView(self!.digitalBooks_TblView, didSelectRowAt: indexPath)

            cell.check = true
            cell.ivCheckBox.setImage(UIImage(named: "ic_checkbox_enabled"), for: .normal)
            //cell.ivCheckBox.image = UIImage(named: "ic_checkbox_enabled")
            cell.lblName.textColor = UIColor.black
            cell.imageViewArrow.transform = CGAffineTransform(rotationAngle: (CGFloat.pi / 2) + (CGFloat.pi / 2))

            
            for i in 0..<searchLocations[cell.tag].merchantNumber.count {
                let myIndexPath = IndexPath(item: i+1, section: cell.tag)
                print("Selected sub row : \(myIndexPath.row)")
//                let cell = tbTIDList.cellForRow(at: myIndexPath) as! tbTIDMIDCell
//                cell.check = true
//                cell.ivCheckBox.image = UIImage(named: "ic_checkbox_enabled")
//                cell.lblName.textColor = UIColor.black
//                let mid = selectLocations[myIndexPath.section].merchantNumber[myIndexPath.row-1].mid
//                print(mid)
//                merchantNumber.append(mid)
            }
        }
        
        */
        
    }
}

//MARK: ExpyTableView delegate methods
extension chooseTIDsViewController: ExpyTableViewDelegate {
    
    func tableView(_ tableView: ExpyTableView, expyState state: ExpyState, changeForSection section: Int) {
        
        switch state {
        case .willExpand:
            print("WILL EXPAND")
            
        case .willCollapse:
            print("WILL COLLAPSE")
            
        case .didExpand:
            print("DID EXPAND")
            
        case .didCollapse:
            print("DID COLLAPSE")
        }
    }
}

//       extension SelectLocationViewController {
//           func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//               return (section % 3 == 0) ? "iPhone Models" : nil
//           }
//       }


extension chooseTIDsViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        if (tableView.cellForRow(at: indexPath) as? tbTIDMIDCell) != nil {
            
            // 1
            /*
            let cell = tableView.cellForRow(at: indexPath) as! tbTIDMIDCell
            
            if !cell.check {
                cell.check = true
                cell.ivCheckBox.image = UIImage(named: "ic_checkbox_enabled")
                cell.lblName.textColor = UIColor.black
                let mid = searchLocations[indexPath.section].merchantNumber[indexPath.row-1].mid
                merchantNumber.append(mid)
              
            } else {
                cell.check = false
                cell.ivCheckBox.image = UIImage(named: "ic_checkbox_disabled")
                let mid = searchLocations[indexPath.section].merchantNumber[indexPath.row-1].mid
                cell.lblName.textColor = UIColor.BurganColor.brandGray.lgiht
                merchantNumber.removeAll{$0 == mid}
                
            }
            */
            
            // 2
            /*
            let cell = tableView.cellForRow(at: indexPath) as! tbTIDMIDCell
            let mid = searchLocations[indexPath.section].merchantNumber[indexPath.row-1].mid

            
            let myDictAry = selectedData.filter{ $0["section"] as! Int == indexPath.section }
            print("myDictAry : \(myDictAry)")

            if myDictAry.count > 0 {
                
                let myDict = selectedData.filter{ $0["section"] as! Int == indexPath.section }.first
                print("myDictAry : \(myDict!)")
                
                var merchantNos : [String] = []
                merchantNos = myDict!["MID"] as! [String]
                
                if merchantNos.contains(mid) {
                   
                    cell.ivCheckBox.image = UIImage(named: "ic_checkbox_enabled")
                    cell.lblName.textColor = UIColor.black
                    
                    merchantNos.removeAll{$0 == mid}
                    
                    merchantNumber.removeAll{$0 == mid}
                    
                    if let row = self.selectedData.firstIndex(where: {$0["section"] as! Int == indexPath.section}) {
                        selectedData[row] = ["section" : indexPath.section,
                                             "MID" : merchantNos]
                    }
                    
                    self.tbTIDList.reloadSections(IndexSet(integer: indexPath.section), with: .none)
                    
                } else {
                    
                    cell.ivCheckBox.image = UIImage(named: "ic_checkbox_disabled")
                    cell.lblName.textColor = UIColor.BurganColor.brandGray.lgiht
                    
                    merchantNos.append(mid)
                    
                    merchantNumber.append(mid)
                    
                    if let row = self.selectedData.firstIndex(where: {$0["section"] as! Int == indexPath.section}) {
                        selectedData[row] = ["section" : indexPath.section,
                                             "MID" : merchantNos]
                    }
                    
                    self.tbTIDList.reloadSections(IndexSet(integer: indexPath.section), with: .none)
                    
                }
                
            } else {
                
                cell.ivCheckBox.image = UIImage(named: "ic_checkbox_disabled")
                cell.lblName.textColor = UIColor.BurganColor.brandGray.lgiht
            }
            */
            
            let cell = tableView.cellForRow(at: indexPath) as! tbTIDMIDCell
            let mid = searchLocations[indexPath.section].merchantNumber[indexPath.row-1].mid
            
            if merchantNumber.contains(mid) {
               
                cell.ivCheckBox.image = UIImage(named: "ic_checkbox_enabled")
                cell.lblName.textColor = UIColor.black
                                
                merchantNumber.removeAll{$0 == mid}
                                
            } else {
                
                cell.ivCheckBox.image = UIImage(named: "ic_checkbox_disabled")
                cell.lblName.textColor = UIColor.BurganColor.brandGray.lgiht
                                
                merchantNumber.append(mid)
                
            }
            
            self.tbTIDList.reloadSections(IndexSet(integer: indexPath.section), with: .none)

            
            // below code is for select all check box
            var isSelectAll : Bool = true
            
            for section in 0..<searchLocations.count {
                            
                for myRow in 0..<searchLocations[section].merchantNumber.count {
                    
                    if merchantNumber.contains("\(searchLocations[section].merchantNumber[myRow].mid)") {
                        
                    } else {
                        isSelectAll = false
                    }
                }
            }
            
            if isSelectAll == true {
                btnSelectAll.setImage(UIImage(named: "ic_checkbox_enabled"), for: .normal)
            } else {
                btnSelectAll.setImage(UIImage(named: "ic_checkbox_disabled"), for: .normal)
            }
            
            
            
            
        } else if((tableView.cellForRow(at: indexPath) as? tbCompanyNameCell) != nil) {
            
            // 1
            /*
            let cell = tableView.cellForRow(at: indexPath) as! tbCompanyNameCell
            if !cell.check {
                cell.check = true
                //cell.ivCheckBox.image = UIImage(named: "ic_checkbox_enabled")
                cell.lblName.textColor = UIColor.black
                cell.imageViewArrow.transform = CGAffineTransform(rotationAngle: 0)
              
            } else {
                cell.check = false
                //cell.ivCheckBox.image = UIImage(named: "ic_checkbox_disabled")
                cell.lblName.textColor = UIColor.BurganColor.brandGray.lgiht
                cell.imageViewArrow.transform = CGAffineTransform(rotationAngle: (CGFloat.pi / 2) + (CGFloat.pi / 2))
            }
            */
            
        } else {
            print("empty cell")
        }
        
        print("DID SELECT row: \(indexPath.row), section: \(indexPath.section)")
          MIDsCollectionView.reloadData()
    }
    
    
}



//MARK: UITableView Data Source Methods
extension chooseTIDsViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        merchantcount = searchLocations[section].merchantNumber.count + 1
        return merchantcount

    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"tbTIDMIDCell") as! tbTIDMIDCell
        
        if AppConstants.language == .ar {
            cell.lblName.textAlignment = .right
        } else {
            cell.lblName.textAlignment = .left
        }
        
        if searchLocations[indexPath.section].merchantNumber.count > 0{
            cell.layoutMargins = UIEdgeInsets.zero
            cell.tag = indexPath.row
            cell.lblName.text = "MID : " +  searchLocations[indexPath.section].merchantNumber[indexPath.row-1].mid
            cell.hideSeparator()
            
            /*
            let myDictAry = selectedData.filter{ $0["section"] as! Int == indexPath.section }
            print("myDictAry : \(myDictAry)")

            if myDictAry.count > 0 {
                
                let myDict = selectedData.filter{ $0["section"] as! Int == indexPath.section }.first
                print("myDictAry : \(myDict!)")
                
                var merchantNos : [String] = []
                merchantNos = myDict!["MID"] as! [String]
                
                if merchantNos.contains(searchLocations[indexPath.section].merchantNumber[indexPath.row-1].mid) {
                   
                    cell.ivCheckBox.image = UIImage(named: "ic_checkbox_enabled")
                    cell.lblName.textColor = UIColor.black
                    
                } else {
                    
                    cell.ivCheckBox.image = UIImage(named: "ic_checkbox_disabled")
                    cell.lblName.textColor = UIColor.BurganColor.brandGray.lgiht
                }
                
            } else {
                
                cell.ivCheckBox.image = UIImage(named: "ic_checkbox_disabled")
                cell.lblName.textColor = UIColor.BurganColor.brandGray.lgiht
            }
            */
            
            if merchantNumber.contains(searchLocations[indexPath.section].merchantNumber[indexPath.row-1].mid) {
               
                cell.ivCheckBox.image = UIImage(named: "ic_checkbox_enabled")
                cell.lblName.textColor = UIColor.black
                
            } else {
                
                cell.ivCheckBox.image = UIImage(named: "ic_checkbox_disabled")
                cell.lblName.textColor = UIColor.BurganColor.brandGray.lgiht
            }
            
        }
       
        //  tbComapnyHeight.constant = 60 + tbComapnyHeight.constant
        return cell
        
    }
}
