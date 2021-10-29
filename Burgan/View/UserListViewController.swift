/*
//
//  AddUserViewController.swift
//  Burgan
//
//  Created by Malti Maurya on 26/03/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit

class UserListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tbUserList: UITableView!
    var userListArray : [userData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
//        let m = MerchantNumber(mid: "814289017", outletNumber: ["29409094"])
//        let l = LocationNameList(locationName: "Hawally", merchantNumber: [m])
//        let b = BrandNameList(brandName: "zahrat Alshaams Boutique", locationNameList: [l])
//        let h = Hierarchy(accountNumber: "2063261758", brandNameList: [b])
//        userListArray.append(userData(userID: "234452", name: "vani", mobile: "987625231", emailID: "abc@gmail.com", status: "Active", isViewEnabled: true, isReportsEnabled: true, hierarchy: [h,h]))
     refreshControl = UIRefreshControl()
         refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
         refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
         self.tbUserList.addSubview(refreshControl)
        self.navigationController?.isNavigationBarHidden = true
        self.viewModel = RegistrationViewControllerViewModel()
        let param : [String : Any] = ["cif" : AppConstants.UserData.cif,
                                      "deviceId" : AppConstants.UserData.deviceID]
         MBProgressHUD.showAdded(to: self.view, animated: true)
        self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.getUserList)
                self.bindUI()
    }
    // MARK: - refresh
       @objc func refresh()
       {
           self.viewModel = RegistrationViewControllerViewModel()
           let param : [String : Any] = ["cif" : AppConstants.UserData.cif,
                                         "deviceId" : AppConstants.UserData.deviceID]
            MBProgressHUD.showAdded(to: self.view, animated: true)
           self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.getUserList)
                   self.bindUI()
           refreshControl.endRefreshing()
       }
    
    @IBAction func goBack(_ sender: Any) {
        
        let controller = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController)!
        controller.selectedIndex = 2
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
  
    @IBAction func addUser(_ sender: Any) {
        
        let controller = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddUserViewController") as? AddUserViewController)!
        controller.showUserDetail = false; self.navigationController?.pushViewController(controller, animated: true)
    }
    var viewModel : RegistrationViewControllerViewModelProtocol?
    
    func decodeResult<T: Decodable>(model: T.Type, result: NSDictionary) -> (model: T?, error: Error?) {
                      do {
                          let jsonData = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
                          let modelObject = try JSONDecoder().decode(model.self, from: jsonData)
                          return (modelObject, nil)
                      } catch let error {
                          return (nil, error)
                      }
                  }
    var refreshControl: UIRefreshControl!

        private func bindUI() {
               
               self.viewModel?.alertMessage.bind({ [weak self] in
                MBProgressHUD.hide(for: self!.view, animated: true)
                   self?.showAlertDismissOnly(message: $0)
               })
               
               
               
               self.viewModel?.response.bind({ [weak self] in
                   
                   if let response = $0 {
                     MBProgressHUD.hide(for: self!.view, animated: true)
                           
                           let userStatus = DataDecryption().decryption(jsonModel: PayloadRes(iv: response.iv, payload: response.payload))
                           
                           if userStatus != nil {
                               
                               
                               
                               let message : String = userStatus?.value(forKey: "message") as! String
                               let status : String = userStatus?.value(forKey: "status") as! String
                               if status == "Success"{
                                   let errorCode : String = userStatus?.value(forKey: "errorCode") as! String
                                if errorCode == "L128"{
                                    print(message)
                                    let object = self!.decodeResult(model: userListResp.self, result: userStatus!)
                                    if let userlist = object.model
                                    {
                                        if userlist.data!.count > 0 {
                                            self!.userListArray = userlist.data!
                                            self!.tbUserList.reloadData()
                                        }
                                    
                                    }else
                                    {
                                          self!.showAlertWith(message: AlertMessage(title: "User List", body: "Invalid Data."))
                                    }
                                   
                                   
                                }else{
                                    self!.showAlertWith(message: AlertMessage(title: "Transactions", body: message))
                                }
                                
                               }else{
                                self!.showAlertWith(message: AlertMessage(title: "Transactions", body: message))
                            }
                            
                        }
                        
                    }
                    
                
                
               })
            
        }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userListArray.count
    }
    @IBAction func searchBar(_ sender: Any) {
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tbUserListCell", for: indexPath) as! tbUserListCell
        cell.lblPhoneNo.text = userListArray[indexPath.row].mobile
        cell.lblStatus.text = userListArray[indexPath.row].status
        cell.lblUserName.text = userListArray[indexPath.row].name
        
        return cell
    }
   

        //With this we can edit UITableview ex. Swipe to Delete
        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
          return true
        }

        //Select tableview Editing Style (insert and Delete)-> if custom icon than set None
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.none
        }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddUserViewController") as? AddUserViewController)!
        controller.showUserDetail = true;
        controller.userDetail = userListArray[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
        
    }

        func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
            let delete = UITableViewRowAction(style: .destructive, title: "\u{1F6AB}\n Deactivate") { action, index in
                   print("deactivate button tapped")
                let cell = tableView.cellForRow(at: indexPath) as! tbUserListCell
               
                cell.lblUserName.textColor = UIColor.BurganColor.brandGray.medium
                cell.lblStatus.textColor = UIColor.BurganColor.brandGray.medium
                cell.lblPhoneNo.textColor = UIColor.BurganColor.brandGray.medium
                cell.lblDBACount.textColor = UIColor.BurganColor.brandGray.medium
                cell.lblStatus.text = "Deactivated"
                
               }
          
            let suspend = UITableViewRowAction(style: .default, title: "⛔️\n Suspend") { action, index in
                   print("suspend button tapped")
                  let cell = tableView.cellForRow(at: indexPath) as! tbUserListCell
                cell.lblStatus.text = "Suspended"
                cell.lblStatus.textColor = UIColor.BurganColor.brandOrange.orange
         
               }
            
       
            suspend.backgroundColor = UIColor.BurganColor.brandYellow.light
            delete.backgroundColor = UIColor.BurganColor.brandOrange.lightOrange

               return [delete, suspend]
    }
    
    
}
*/


/*
// By Sanket

//
//  AddUserViewController.swift
//  Burgan
//
//  Created by Malti Maurya on 26/03/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit

class UserListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{
    @IBOutlet weak var tbUserList: UITableView!
    
    // SANKET 1 jul 2020
    
    @IBOutlet weak var toolbarView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchBackView: UIView!
    
    var userListArray : [userData] = []
    var userListArray1 : [userData] = []
    var searchArr = [userData]()
    var searchedText = String()

    // SANKET 1 jul 2020 OVER
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SANKET 1 jul 2020
        searchBackView.isHidden = true
        searchTextField.setLeftPadding()
        searchTextField.layer.cornerRadius = searchTextField.frame.height / 2
        searchTextField.delegate = self
        searchTextField.tintColor = .white
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        // SANKET 1 jul 2020 OVER
        
        
//        let m = MerchantNumber(mid: "814289017", outletNumber: ["29409094"])
//        let l = LocationNameList(locationName: "Hawally", merchantNumber: [m])
//        let b = BrandNameList(brandName: "zahrat Alshaams Boutique", locationNameList: [l])
//        let h = Hierarchy(accountNumber: "2063261758", brandNameList: [b])
//        userListArray.append(userData(userID: "234452", name: "vani", mobile: "987625231", emailID: "abc@gmail.com", status: "Active", isViewEnabled: true, isReportsEnabled: true, hierarchy: [h,h]))
     refreshControl = UIRefreshControl()
         refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
         refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
         self.tbUserList.addSubview(refreshControl)
        self.navigationController?.isNavigationBarHidden = true
        self.viewModel = RegistrationViewControllerViewModel()
        let param : [String : Any] = ["cif" : AppConstants.UserData.cif,
                                      "deviceId" : AppConstants.UserData.deviceID]
         MBProgressHUD.showAdded(to: self.view, animated: true)
        self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.getUserList)
                self.bindUI()
    }
    
    // SANKET 1 jul 2020
    
    @objc func textFieldDidChange(textField: UITextField)
    {
        //your code
        searchedText = textField.text!
        searchArr.removeAll()
        userListArray.removeAll()
        for i in 0 ..< userListArray1.count
        {
            let obj = userListArray1[i]
            if (obj.name?.contains(searchedText))!
            {
                searchArr.append(obj)
            }
        }
        
        print(searchArr)
        tbUserList.reloadData()
        
    }
    
    // SANKET 1 jul 2020 OVER
    
    
    // MARK: - refresh
       @objc func refresh()
       {
           self.viewModel = RegistrationViewControllerViewModel()
           let param : [String : Any] = ["cif" : AppConstants.UserData.cif,
                                         "deviceId" : AppConstants.UserData.deviceID]
            MBProgressHUD.showAdded(to: self.view, animated: true)
           self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.getUserList)
                   self.bindUI()
           refreshControl.endRefreshing()
       }
    
    @IBAction func goBack(_ sender: Any) {
        
        let controller = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController)!
        controller.selectedIndex = 2
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
  
    @IBAction func addUser(_ sender: Any) {
        
        let controller = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddUserViewController") as? AddUserViewController)!
        controller.showUserDetail = false; self.navigationController?.pushViewController(controller, animated: true)
    }
    var viewModel : RegistrationViewControllerViewModelProtocol?
    
    func decodeResult<T: Decodable>(model: T.Type, result: NSDictionary) -> (model: T?, error: Error?) {
                      do {
                          let jsonData = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
                          let modelObject = try JSONDecoder().decode(model.self, from: jsonData)
                          return (modelObject, nil)
                      } catch let error {
                          return (nil, error)
                      }
                  }
    var refreshControl: UIRefreshControl!

        private func bindUI() {
               
               self.viewModel?.alertMessage.bind({ [weak self] in
                MBProgressHUD.hide(for: self!.view, animated: true)
                   self?.showAlertDismissOnly(message: $0)
               })
               
               
               
               self.viewModel?.response.bind({ [weak self] in
                   
                   if let response = $0 {
                     MBProgressHUD.hide(for: self!.view, animated: true)
                           
                           let userStatus = DataDecryption().decryption(jsonModel: PayloadRes(iv: response.iv, payload: response.payload))
                           
                           if userStatus != nil {
                               
                               
                               
                               let message : String = userStatus?.value(forKey: "message") as! String
                               let status : String = userStatus?.value(forKey: "status") as! String
                               if status == "Success"{
                                   let errorCode : String = userStatus?.value(forKey: "errorCode") as! String
                                if errorCode == "L128"{
                                    print(message)
                                    let object = self!.decodeResult(model: userListResp.self, result: userStatus!)
                                    if let userlist = object.model
                                    {
                                        if userlist.data!.count > 0 {
                                            self!.userListArray = userlist.data!
                                            self!.tbUserList.reloadData()
                                        }
                                    
                                    }else
                                    {
                                          self!.showAlertWith(message: AlertMessage(title: "User List", body: "Invalid Data."))
                                    }
                                   
                                   
                                }else{
                                    self!.showAlertWith(message: AlertMessage(title: "Transactions", body: message))
                                }
                                
                               }else{
                                self!.showAlertWith(message: AlertMessage(title: "Transactions", body: message))
                            }
                            
                        }
                        
                    }
                    
                
                
               })
            
        }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if searchArr.count > 0
        {
            return searchArr.count
        }
        else
        {
            return userListArray.count
        }
        
    }
    
    // SANKET 1 jul 2020
    
    @IBAction func closeSearchView_BtnTap(_ sender: Any)
    {
        
        userListArray = userListArray1
        userListArray1.removeAll()
        searchBackView.isHidden = true
        searchArr.removeAll()
        searchedText = ""
        searchTextField.text = ""
        tbUserList.reloadData()
    }
    
    @IBAction func searchBar(_ sender: Any)
    {
        userListArray1 = userListArray
        userListArray.removeAll()
        searchBackView.isHidden = false
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tbUserListCell", for: indexPath) as! tbUserListCell

        if searchArr.count > 0
        {
            cell.lblPhoneNo.text = searchArr[indexPath.row].mobile
            cell.lblStatus.text = searchArr[indexPath.row].status
            cell.lblUserName.text = searchArr[indexPath.row].name
        }
        else{
            cell.lblPhoneNo.text = userListArray[indexPath.row].mobile
            cell.lblStatus.text = userListArray[indexPath.row].status
            cell.lblUserName.text = userListArray[indexPath.row].name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddUserViewController") as? AddUserViewController)!
        controller.showUserDetail = true;
        if searchArr.count > 0
        {
            controller.userDetail = searchArr[indexPath.row]
        }
        else
        {
            print(userListArray[indexPath.row])
            controller.userDetail = userListArray[indexPath.row]
        }
        
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
   // SANKET 1 jul 2020 OVER

        //With this we can edit UITableview ex. Swipe to Delete
        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
          return true
        }

        //Select tableview Editing Style (insert and Delete)-> if custom icon than set None
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.none
        }
    

    

        func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
            let delete = UITableViewRowAction(style: .destructive, title: "\u{1F6AB}\n Deactivate") { action, index in
                   print("deactivate button tapped")
                let cell = tableView.cellForRow(at: indexPath) as! tbUserListCell
               
                cell.lblUserName.textColor = UIColor.BurganColor.brandGray.medium
                cell.lblStatus.textColor = UIColor.BurganColor.brandGray.medium
                cell.lblPhoneNo.textColor = UIColor.BurganColor.brandGray.medium
                cell.lblDBACount.textColor = UIColor.BurganColor.brandGray.medium
                cell.lblStatus.text = "Deactivated"
                
               }
          
            let suspend = UITableViewRowAction(style: .default, title: "⛔️\n Suspend") { action, index in
                   print("suspend button tapped")
                  let cell = tableView.cellForRow(at: indexPath) as! tbUserListCell
                cell.lblStatus.text = "Suspended"
                cell.lblStatus.textColor = UIColor.BurganColor.brandOrange.orange
         
               }
            
       
            suspend.backgroundColor = UIColor.BurganColor.brandYellow.light
            delete.backgroundColor = UIColor.BurganColor.brandOrange.lightOrange

               return [delete, suspend]
    }
    
    
}


// SANKET 1 jul 2020

private var kAssociationKeyMaxLength: Int = 0
extension UITextField
{
    func setLeftPadding()
    {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = UITextField.ViewMode.always
    }
}
// SANKET 1 jul 2020 OVER

*/


// 2
// Second Code By Sanket

//
//  AddUserViewController.swift
//  Burgan
//
//  Created by Malti Maurya on 26/03/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit

class UserListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{
    @IBOutlet weak var tbUserList: UITableView!
    
    // SANKET 1 jul 2020
    
    @IBOutlet weak var toolbarView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchBackView: UIView!
    
    var userListArray : [userData] = []
    var userListArray1 : [userData] = []
    var searchArr = [userData]()
    var searchedText = String()

    // SANKET 1 jul 2020 OVER
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.networkStatusChanged(_:)), name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        definesPresentationContext = true

        
        self.loopThroughSubViewAndMirrorImage(subviews: self.view.subviews)
        
        // SANKET 1 jul 2020
        searchBackView.isHidden = true
        searchTextField.setLeftPadding()
        searchTextField.layer.cornerRadius = searchTextField.frame.height / 2
        searchTextField.delegate = self
        searchTextField.tintColor = .white
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        // SANKET 1 jul 2020 OVER
        
        
//        let m = MerchantNumber(mid: "814289017", outletNumber: ["29409094"])
//        let l = LocationNameList(locationName: "Hawally", merchantNumber: [m])
//        let b = BrandNameList(brandName: "zahrat Alshaams Boutique", locationNameList: [l])
//        let h = Hierarchy(accountNumber: "2063261758", brandNameList: [b])
//        userListArray.append(userData(userID: "234452", name: "vani", mobile: "987625231", emailID: "abc@gmail.com", status: "Active", isViewEnabled: true, isReportsEnabled: true, hierarchy: [h,h]))
     refreshControl = UIRefreshControl()
         refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
         refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
         self.tbUserList.addSubview(refreshControl)
        self.navigationController?.isNavigationBarHidden = true
        /*
        self.viewModel = RegistrationViewControllerViewModel()
        let param : [String : Any] = ["cif" : AppConstants.UserData.cif,
                                      "deviceId" : AppConstants.UserData.deviceID]
         MBProgressHUD.showAdded(to: self.view, animated: true)
        self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.getUserList)
        self.bindUI()
        */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel = RegistrationViewControllerViewModel()
        let param : [String : Any] = ["cif" : AppConstants.UserData.cif,
                                      "deviceId" : AppConstants.UserData.deviceID]
         MBProgressHUD.showAdded(to: self.view, animated: true)
        self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.getUserList)
        self.bindUI(indexPath: 0, isViewEnabledVal: false, isFromAPI: false)
    }
    // SANKET 1 jul 2020
    
    @objc func textFieldDidChange(textField: UITextField)
    {
        //your code
        searchedText = textField.text!
        searchArr.removeAll()
        userListArray.removeAll()
        for i in 0 ..< userListArray1.count
        {
            let obj = userListArray1[i]
//            if (obj.name?.contains(searchedText))!
//            {
//                searchArr.append(obj)
//            }
            if (obj.name?.range(of: searchedText, options: .caseInsensitive)) != nil {
                // match
                
                searchArr.append(obj)
            } else {
                // no match
            }
            
        }
        print(searchArr)
        tbUserList.reloadData()
    }
    
    // SANKET 1 jul 2020 OVER
    
    
    // MARK: - refresh
       @objc func refresh()
       {
           self.viewModel = RegistrationViewControllerViewModel()
           let param : [String : Any] = ["cif" : AppConstants.UserData.cif,
                                         "deviceId" : AppConstants.UserData.deviceID]
            MBProgressHUD.showAdded(to: self.view, animated: true)
           self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.getUserList)
            self.bindUI(indexPath: 0, isViewEnabledVal: false, isFromAPI: false)
           refreshControl.endRefreshing()
       }
    
    @IBAction func goBack(_ sender: Any) {
        
//        let controller = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController)!
//        controller.selectedIndex = 2
//        self.navigationController?.pushViewController(controller, animated: true)
        self.navigationController?.popViewController(animated: true)
    }
  
    @IBAction func addUser(_ sender: Any) {
        
        let controller = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddUserViewController") as? AddUserViewController)!
        controller.showUserDetail = false;
        self.navigationController?.pushViewController(controller, animated: true)
    }
    var viewModel : RegistrationViewControllerViewModelProtocol?
    
    func decodeResult<T: Decodable>(model: T.Type, result: NSDictionary) -> (model: T?, error: Error?) {
                      do {
                          let jsonData = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
                          let modelObject = try JSONDecoder().decode(model.self, from: jsonData)
                          return (modelObject, nil)
                      } catch let error {
                          return (nil, error)
                      }
                  }
    var refreshControl: UIRefreshControl!

        // private func bindUI() {
    private func bindUI(indexPath:Int, isViewEnabledVal : Bool, isFromAPI : Bool) {
               
            self.viewModel?.alertMessage.bind({ [weak self] in
                MBProgressHUD.hide(for: self!.view, animated: true)
                self?.showAlertDismissOnly(message: $0)
            })
               
               
               
               self.viewModel?.response.bind({ [weak self] in
                   
                   if let response = $0 {
                     MBProgressHUD.hide(for: self!.view, animated: true)
                           
                    let userStatus = DataDecryption().decryption(jsonModel: PayloadRes(iv: response.iv, payload: response.payload))
                           
                    if userStatus != nil {
                            
                        let status : String = userStatus?.value(forKey: "status") as? String ?? ""
                        if status == "" {
                            
                            if isFromAPI == true {
                                self?.API(indexPath: indexPath, isViewEnabledVal: isViewEnabledVal)
                            } else {
                                
                                let param : [String : Any] = ["cif" : AppConstants.UserData.cif,
                                                              "deviceId" : AppConstants.UserData.deviceID]
                                 MBProgressHUD.showAdded(to: self!.view, animated: true)
                                self!.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.getUserList)
                                self!.bindUI(indexPath: 0, isViewEnabledVal: false, isFromAPI: false)
                            }
                            
                        } else {
                            let message : String = userStatus?.value(forKey: "message") as! String
                               let status : String = userStatus?.value(forKey: "status") as! String
                               if status == "Success"{
                                   let errorCode : String = userStatus?.value(forKey: "errorCode") as! String
                                if errorCode == "L128"{
//                                    print(message)
                                    let object = self!.decodeResult(model: userListResp.self, result: userStatus!)
                                    if let userlist = object.model
                                    {
                                        if userlist.data!.count > 0 {
                                            self!.userListArray = userlist.data!
                                            self!.tbUserList.reloadData()
                                        }
                                    } else {
                                          self!.showAlertWith(message: AlertMessage(title: "User List", body: "Invalid Data."))
                                    }
                                } else if errorCode == "S101" {
                                    self!.showAlertWith(message: AlertMessage(title: "User".localiz(), body: message))
                                    self?.refresh()
                                } else {
                                    self!.showAlertWith(message: AlertMessage(title: "User".localiz(), body: message))
                                }
                                
                               } else {
                                self!.showAlertWith(message: AlertMessage(title: "User".localiz(), body: message))
                            }
                        }
                            
                               
                        }
                    }
               })
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if searchArr.count > 0
        {
            return searchArr.count
        }
        else
        {
            return userListArray.count
        }
        
    }
    
    // SANKET 1 jul 2020
    
    @IBAction func closeSearchView_BtnTap(_ sender: Any) {
        userListArray = userListArray1
        userListArray1.removeAll()
        searchBackView.isHidden = true
        searchArr.removeAll()
        searchedText = ""
        searchTextField.text = ""
        tbUserList.reloadData()
    }
    
    @IBAction func searchBar(_ sender: Any)
    {
        userListArray1 = userListArray
        userListArray.removeAll()
        searchBackView.isHidden = false
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tbUserListCell", for: indexPath) as! tbUserListCell

        if searchArr.count > 0 {
            cell.lblPhoneNo.text = searchArr[indexPath.row].mobile
            cell.lblStatus.text = searchArr[indexPath.row].status?.localiz()
            cell.lblUserName.text = searchArr[indexPath.row].name
        } else {
            cell.lblPhoneNo.text = userListArray[indexPath.row].mobile
            cell.lblStatus.text = userListArray[indexPath.row].status?.localiz()
            cell.lblUserName.text = userListArray[indexPath.row].name
        }
        
        
        if searchArr.count > 0 {
            
            if searchArr[indexPath.row].status == "Pending"
            {
                cell.lblStatus.textColor = UIColor(hexString: "FFAA00")
            }
            else if searchArr[indexPath.row].status == "Deactivated"
            {
                cell.lblStatus.textColor = UIColor(hexString: "EE7910")
            }
            else if searchArr[indexPath.row].status == "Active"
            {
                cell.lblStatus.textColor = UIColor(hexString: "16B091")
            }
            
        } else {
           
            if userListArray[indexPath.row].status == "Pending"
            {
                cell.lblStatus.textColor = UIColor(hexString: "FFAA00")
            }
            else if userListArray[indexPath.row].status == "Deactivated"
            {
                cell.lblStatus.textColor = UIColor(hexString: "EE7910")
            }
            else if userListArray[indexPath.row].status == "Active"
            {
                cell.lblStatus.textColor = UIColor(hexString: "16B091")
            }
            
        }
        
        
//        if userListArray[indexPath.row].status == "Pending"
//        {
//            cell.lblStatus.textColor = UIColor(hexString: "FFAA00")
//        }
//        else if userListArray[indexPath.row].status == "Deactivated"
//        {
//            cell.lblStatus.textColor = UIColor(hexString: "EE7910")
//        }
//        else if userListArray[indexPath.row].status == "Active"
//        {
//            cell.lblStatus.textColor = UIColor(hexString: "16B091")
//        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddUserViewController") as? AddUserViewController)!
        controller.showUserDetail = true;
        if searchArr.count > 0
        {
            controller.userDetail = searchArr[indexPath.row]
        }
        else
        {
            print(userListArray[indexPath.row])
            controller.userDetail = userListArray[indexPath.row]
        }
        
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
   // SANKET 1 jul 2020 OVER

        //With this we can edit UITableview ex. Swipe to Delete
        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
          return true
        }

        //Select tableview Editing Style (insert and Delete)-> if custom icon than set None
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.none
        }

    
    // Sanket
    let merchant : String  = "\(AppConstants.merchantNumber)"
    /*
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        
        
        if searchArr.count > 0
        {
            if searchArr[indexPath.row].status == "Pending"
            {
                let delete = UITableViewRowAction(style: .destructive, title: "\u{1F6AB}\n Deactivate") { action, index in
                    print("deactivate button tapped")
                    let cell = tableView.cellForRow(at: indexPath) as! tbUserListCell
                    
                    cell.lblUserName.textColor = UIColor.BurganColor.brandGray.medium
                    cell.lblStatus.textColor = UIColor.BurganColor.brandGray.medium
                    cell.lblPhoneNo.textColor = UIColor.BurganColor.brandGray.medium
                    cell.lblDBACount.textColor = UIColor.BurganColor.brandGray.medium
                    cell.lblStatus.text = "Deactivated"
                    
                    self.API(indexPath: indexPath.row, isViewEnabledVal: false)
                    
                }
                delete.backgroundColor = UIColor.BurganColor.brandOrange.lightOrange
                return [delete]
            }
            else if searchArr[indexPath.row].status == "Deactivated"
            {
                let activate = UITableViewRowAction(style: .default, title: "⛔\n Activate") { action, index in
                    let cell = tableView.cellForRow(at: indexPath) as! tbUserListCell
                    cell.lblStatus.text = "Suspended"
                    cell.lblStatus.textColor = UIColor.BurganColor.brandOrange.orange
                    self.API(indexPath: indexPath.row, isViewEnabledVal: true)
                    
                }
                
                activate.backgroundColor = UIColor.BurganColor.brandOrange.lightOrange
                return [activate]
            }
            else
            {
                let delete = UITableViewRowAction(style: .destructive, title: "\u{1F6AB}\n Deactivate") { action, index in
                    print("deactivate button tapped")
                    let cell = tableView.cellForRow(at: indexPath) as! tbUserListCell
                    
                    cell.lblUserName.textColor = UIColor.BurganColor.brandGray.medium
                    cell.lblStatus.textColor = UIColor.BurganColor.brandGray.medium
                    cell.lblPhoneNo.textColor = UIColor.BurganColor.brandGray.medium
                    cell.lblDBACount.textColor = UIColor.BurganColor.brandGray.medium
                    cell.lblStatus.text = "Deactivated"
                    self.API(indexPath: indexPath.row, isViewEnabledVal: false)
                    
                }
                delete.backgroundColor = UIColor.BurganColor.brandOrange.lightOrange
                return [delete]
            }
        }
        else
        {
            if userListArray[indexPath.row].status == "Pending"
            {
                let delete = UITableViewRowAction(style: .destructive, title: "\u{1F6AB}\n Deactivate") { action, index in
                    print("deactivate button tapped")
                    let cell = tableView.cellForRow(at: indexPath) as! tbUserListCell
                    
                    cell.lblUserName.textColor = UIColor.BurganColor.brandGray.medium
                    cell.lblStatus.textColor = UIColor.BurganColor.brandGray.medium
                    cell.lblPhoneNo.textColor = UIColor.BurganColor.brandGray.medium
                    cell.lblDBACount.textColor = UIColor.BurganColor.brandGray.medium
                    cell.lblStatus.text = "Deactivated"
                    self.API(indexPath: indexPath.row, isViewEnabledVal: false)
                    
                }
                delete.backgroundColor = UIColor.BurganColor.brandOrange.lightOrange
                return [delete]
            }
            else if userListArray[indexPath.row].status == "Deactivated"
            {
                
                let activate = UITableViewRowAction(style: .default, title: "⛔\n Activate") { action, index in
                    let cell = tableView.cellForRow(at: indexPath) as! tbUserListCell
                    cell.lblStatus.text = "Activate"
                    cell.lblStatus.textColor = UIColor.black
                    self.API(indexPath: indexPath.row, isViewEnabledVal: true)
                }
                
                activate.backgroundColor = UIColor.BurganColor.brandOrange.lightOrange
                return [activate]
            }
            else
            {
                let delete = UITableViewRowAction(style: .destructive, title: "\u{1F6AB}\n Deactivate") { action, index in
                    print("deactivate button tapped")
                    let cell = tableView.cellForRow(at: indexPath) as! tbUserListCell
                    
                    cell.lblUserName.textColor = UIColor.BurganColor.brandGray.medium
                    cell.lblStatus.textColor = UIColor.BurganColor.brandGray.medium
                    cell.lblPhoneNo.textColor = UIColor.BurganColor.brandGray.medium
                    cell.lblDBACount.textColor = UIColor.BurganColor.brandGray.medium
                    cell.lblStatus.text = "Deactivated"
                    self.API(indexPath: indexPath.row, isViewEnabledVal: false)
                }
                delete.backgroundColor = UIColor.BurganColor.brandOrange.lightOrange
                return [delete]
            }
        }
    }
    
    */
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt  indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        if searchArr.count > 0
        {
            if searchArr[indexPath.row].status == "Pending"
            {
                
                let delete = UIContextualAction(style: .normal, title:  "Deactivate".localiz(), handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                    print("deactivate button tapped")
                    let cell = tableView.cellForRow(at: indexPath) as! tbUserListCell
                    
                    cell.lblUserName.textColor = UIColor.BurganColor.brandGray.medium
                    cell.lblStatus.textColor = UIColor.BurganColor.brandGray.medium
                    cell.lblPhoneNo.textColor = UIColor.BurganColor.brandGray.medium
                    cell.lblDBACount.textColor = UIColor.BurganColor.brandGray.medium
                    cell.lblStatus.text = "Deactivated"
                    
                    self.API(indexPath: indexPath.row, isViewEnabledVal: false)
                })
                // delete.image = UIImage(named: "deactivate")?.paintOver(colorHex: "FF4D2A")
                if let cgImageX =  UIImage(named: "deactivate")?.cgImage {
                     delete.image = ImageWithoutRender(cgImage: cgImageX, scale: UIScreen.main.nativeScale, orientation: .up)
                }
                delete.title = "Deactivate".localiz()
                delete.backgroundColor = UIColor.BurganColor.brandOrange.lightOrange
                return UISwipeActionsConfiguration(actions: [delete])
                
                //                        let delete = UITableViewRowAction(style: .destructive, title: "\u{1F6AB}\n Deactivate") { action, index in
                //                            print("deactivate button tapped")
                //                            let cell = tableView.cellForRow(at: indexPath) as! tbUserListCell
                //
                //                            cell.lblUserName.textColor = UIColor.BurganColor.brandGray.medium
                //                            cell.lblStatus.textColor = UIColor.BurganColor.brandGray.medium
                //                            cell.lblPhoneNo.textColor = UIColor.BurganColor.brandGray.medium
                //                            cell.lblDBACount.textColor = UIColor.BurganColor.brandGray.medium
                //                            cell.lblStatus.text = "Deactivated"
                //
                //                            self.API(indexPath: indexPath.row, isViewEnabledVal: false)
                //
                //                        }
                //
                //                        delete.backgroundColor = UIColor.BurganColor.brandOrange.lightOrange
                //                        return [delete]
            }
            else if searchArr[indexPath.row].status == "Deactivated"
            {
                let activate = UIContextualAction(style: .normal, title:  "Activate".localiz(), handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                    print("deactivate button tapped")
                    let cell = tableView.cellForRow(at: indexPath) as! tbUserListCell
                    
                    cell.lblUserName.textColor = UIColor.BurganColor.brandGray.medium
                    cell.lblStatus.textColor = UIColor.BurganColor.brandGray.medium
                    cell.lblPhoneNo.textColor = UIColor.BurganColor.brandGray.medium
                    cell.lblDBACount.textColor = UIColor.BurganColor.brandGray.medium
                    cell.lblStatus.text = "Suspended"
                    
                    self.API(indexPath: indexPath.row, isViewEnabledVal: true)
                })
                // activate.image = UIImage(named: "activate")?.paintOver(colorHex: "16B091")
                if let cgImageX =  UIImage(named: "activate")?.cgImage {
                     activate.image = ImageWithoutRender(cgImage: cgImageX, scale: UIScreen.main.nativeScale, orientation: .up)
                }
                activate.title = "Activate".localiz()
                activate.backgroundColor = UIColor.BurganColor.brandGreen.lightGreen
                return UISwipeActionsConfiguration(actions: [activate])
                //                       let activate = UITableViewRowAction(style: .default, title: "⛔\n Activate") { action, index in
                //                            let cell = tableView.cellForRow(at: indexPath) as! tbUserListCell
                //                            cell.lblStatus.text = "Suspended"
                //                            cell.lblStatus.textColor = UIColor.BurganColor.brandOrange.orange
                //                            self.API(indexPath: indexPath.row, isViewEnabledVal: true)
                //
                //                        }
                //
                //                        activate.backgroundColor = UIColor.BurganColor.brandOrange.lightOrange
                //                        return [activate]
            }
            else
            {
                let delete = UIContextualAction(style: .normal, title:  "Deactivate".localiz(), handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                    print("deactivate button tapped")
                    let cell = tableView.cellForRow(at: indexPath) as! tbUserListCell
                    
                    cell.lblUserName.textColor = UIColor.BurganColor.brandGray.medium
                    cell.lblStatus.textColor = UIColor.BurganColor.brandGray.medium
                    cell.lblPhoneNo.textColor = UIColor.BurganColor.brandGray.medium
                    cell.lblDBACount.textColor = UIColor.BurganColor.brandGray.medium
                    cell.lblStatus.text = "Deactivated"
                    
                    self.API(indexPath: indexPath.row, isViewEnabledVal: false)
                })
                // delete.image = UIImage(named: "deactivate")?.paintOver(colorHex: "FF4D2A")
                if let cgImageX =  UIImage(named: "deactivate")?.cgImage {
                     delete.image = ImageWithoutRender(cgImage: cgImageX, scale: UIScreen.main.nativeScale, orientation: .up)
                }
                delete.title = "Deactivate".localiz()
                delete.backgroundColor = UIColor.BurganColor.brandOrange.lightOrange
                return UISwipeActionsConfiguration(actions: [delete])
                //                        let delete = UITableViewRowAction(style: .destructive, title: "\u{1F6AB}\n Deactivate") { action, index in
                //                            print("deactivate button tapped")
                //                         let cell = tableView.cellForRow(at: indexPath) as! tbUserListCell
                //
                //                         cell.lblUserName.textColor = UIColor.BurganColor.brandGray.medium
                //                         cell.lblStatus.textColor = UIColor.BurganColor.brandGray.medium
                //                         cell.lblPhoneNo.textColor = UIColor.BurganColor.brandGray.medium
                //                         cell.lblDBACount.textColor = UIColor.BurganColor.brandGray.medium
                //                         cell.lblStatus.text = "Deactivated"
                //                            self.API(indexPath: indexPath.row, isViewEnabledVal: false)
                //
                //                         }
                //                        delete.backgroundColor = UIColor.BurganColor.brandOrange.lightOrange
                //                        return [delete]
            }
        }
        else
        {
            if userListArray[indexPath.row].status == "Pending"
            {
                let delete = UIContextualAction(style: .normal, title:  "Deactivate".localiz(), handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                    print("deactivate button tapped")
                    let cell = tableView.cellForRow(at: indexPath) as! tbUserListCell
                    
                    cell.lblUserName.textColor = UIColor.BurganColor.brandGray.medium
                    cell.lblStatus.textColor = UIColor.BurganColor.brandGray.medium
                    cell.lblPhoneNo.textColor = UIColor.BurganColor.brandGray.medium
                    cell.lblDBACount.textColor = UIColor.BurganColor.brandGray.medium
                    cell.lblStatus.text = "Deactivated"
                    
                    self.API(indexPath: indexPath.row, isViewEnabledVal: false)
                })
                // delete.image = UIImage(named: "deactivate")?.paintOver(colorHex: "FF4D2A")
                if let cgImageX =  UIImage(named: "deactivate")?.cgImage {
                     delete.image = ImageWithoutRender(cgImage: cgImageX, scale: UIScreen.main.nativeScale, orientation: .up)
                }
                delete.title = "Deactivate".localiz()
                delete.backgroundColor = UIColor.BurganColor.brandOrange.lightOrange
                return UISwipeActionsConfiguration(actions: [delete])
                //                        let delete = UITableViewRowAction(style: .destructive, title: "\u{1F6AB}\n Deactivate") { action, index in
                //                            print("deactivate button tapped")
                //                         let cell = tableView.cellForRow(at: indexPath) as! tbUserListCell
                //
                //                         cell.lblUserName.textColor = UIColor.BurganColor.brandGray.medium
                //                         cell.lblStatus.textColor = UIColor.BurganColor.brandGray.medium
                //                         cell.lblPhoneNo.textColor = UIColor.BurganColor.brandGray.medium
                //                         cell.lblDBACount.textColor = UIColor.BurganColor.brandGray.medium
                //                         cell.lblStatus.text = "Deactivated"
                //                        self.API(indexPath: indexPath.row, isViewEnabledVal: false)
                //
                //                         }
                //                        delete.backgroundColor = UIColor.BurganColor.brandOrange.lightOrange
                //                        return [delete]
            }
            else if userListArray[indexPath.row].status == "Deactivated"
            {
                let activate = UIContextualAction(style: .normal, title:  "Activate".localiz(), handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                    print("deactivate button tapped")
                    let cell = tableView.cellForRow(at: indexPath) as! tbUserListCell
                    
                    cell.lblUserName.textColor = UIColor.BurganColor.brandGray.medium
                    cell.lblStatus.textColor = UIColor.BurganColor.brandGray.medium
                    cell.lblPhoneNo.textColor = UIColor.BurganColor.brandGray.medium
                    cell.lblDBACount.textColor = UIColor.BurganColor.brandGray.medium
                    cell.lblStatus.text = "Activate".localiz()
                    
                    self.API(indexPath: indexPath.row, isViewEnabledVal: true)
                })
                // activate.image = UIImage(named: "activate")?.paintOver(colorHex: "16B091")
                if let cgImageX =  UIImage(named: "activate")?.cgImage {
                     activate.image = ImageWithoutRender(cgImage: cgImageX, scale: UIScreen.main.nativeScale, orientation: .up)
                }
                activate.title = "Activate".localiz()
                activate.backgroundColor = UIColor.BurganColor.brandGreen.lightGreen
                return UISwipeActionsConfiguration(actions: [activate])
                //                        let activate = UITableViewRowAction(style: .default, title: "⛔\n Activate") { action, index in
                //                                   let cell = tableView.cellForRow(at: indexPath) as! tbUserListCell
                //                                 cell.lblStatus.text = "Activate"
                //                                 cell.lblStatus.textColor = UIColor.black
                //                            self.API(indexPath: indexPath.row, isViewEnabledVal: true)
                //                                }
                //
                //                        activate.backgroundColor = UIColor.BurganColor.brandOrange.lightOrange
                //                        return [activate]
            }
            else
            {
                let delete = UIContextualAction(style: .normal, title:  "Deactivate".localiz(), handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                    print("deactivate button tapped")
                    let cell = tableView.cellForRow(at: indexPath) as! tbUserListCell
                    
                    cell.lblUserName.textColor = UIColor.BurganColor.brandGray.medium
                    cell.lblStatus.textColor = UIColor.BurganColor.brandGray.medium
                    cell.lblPhoneNo.textColor = UIColor.BurganColor.brandGray.medium
                    cell.lblDBACount.textColor = UIColor.BurganColor.brandGray.medium
                    cell.lblStatus.text = "Deactivated".localiz()
                    
                    self.API(indexPath: indexPath.row, isViewEnabledVal: false)
                })
                
                // delete.image = UIImage(named: "deactivate")?.paintOver(colorHex: "FF4D2A")
                if let cgImageX =  UIImage(named: "deactivate")?.cgImage {
                     delete.image = ImageWithoutRender(cgImage: cgImageX, scale: UIScreen.main.nativeScale, orientation: .up)
                }
                delete.title = "Deactivate".localiz()
                delete.backgroundColor = UIColor.BurganColor.brandOrange.lightOrange
                return UISwipeActionsConfiguration(actions: [delete])
                //                        let delete = UITableViewRowAction(style: .destructive, title: "\u{1F6AB}\n Deactivate") { action, index in
                //                            print("deactivate button tapped")
                //                         let cell = tableView.cellForRow(at: indexPath) as! tbUserListCell
                //
                //                         cell.lblUserName.textColor = UIColor.BurganColor.brandGray.medium
                //                         cell.lblStatus.textColor = UIColor.BurganColor.brandGray.medium
                //                         cell.lblPhoneNo.textColor = UIColor.BurganColor.brandGray.medium
                //                         cell.lblDBACount.textColor = UIColor.BurganColor.brandGray.medium
                //                         cell.lblStatus.text = "Deactivated"
                //                          self.API(indexPath: indexPath.row, isViewEnabledVal: false)
                //                         }
                //                        delete.backgroundColor = UIColor.BurganColor.brandOrange.lightOrange
                //                        return [delete]
            }
        }
        
        
    }
    
    func API(indexPath:Int, isViewEnabledVal : Bool)
    {
        var merchantNumber : [Int] = []
        var heirarchyArr : [Hierarchy] = []
        
        if self.searchArr.count > 0 {
            heirarchyArr = (self.searchArr[indexPath].hierarchy)!
        } else {
            heirarchyArr = (self.userListArray[indexPath].hierarchy)!
        }
        
        for i in 0..<heirarchyArr.count{
            for j in 0..<heirarchyArr[i].brandNameList.count{
                for k in 0..<heirarchyArr[i].brandNameList[j].locationNameList.count{
                    for l in 0..<heirarchyArr[i].brandNameList[j].locationNameList[k].merchantNumber.count
                    {
                        let m : Int = Int(heirarchyArr[i].brandNameList[j].locationNameList[k].merchantNumber[l].mid)!
                        merchantNumber.append(m)
                    }
                }
            }
        }
        
        let merchantNum : String  = "\(merchantNumber)"

        
        if self.searchArr.count > 0
        {

            let param : [String : Any] = ["cif" : AppConstants.selectedFilter!.cif,
                                            "deviceId" : AppConstants.UserData.deviceID,
                                            "userID" : self.searchArr[indexPath].userID!,
                                            "name" : self.searchArr[indexPath].name!,
                                            "mobile" : self.searchArr[indexPath].mobile!,
                                            "emailID" : self.searchArr[indexPath].emailID!,
                                            "isViewEnabled" : isViewEnabledVal,
                                            "isReportsEnabled" : true,
                                            "merchantNum" : merchantNum
                                                ]
           print(param)
            MBProgressHUD.showAdded(to: self.view, animated: true)
           self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.modifyUser)

        }
        else
        {
            let param : [String : Any] = ["cif" : AppConstants.selectedFilter!.cif,
                                            "deviceId" : AppConstants.UserData.deviceID,
                                            "userID" : self.userListArray[indexPath].userID!,
                                            "name" : self.userListArray[indexPath].name!,
                                            "mobile" : self.userListArray[indexPath].mobile!,
                                            "emailID" : self.userListArray[indexPath].emailID!,
                                            "isViewEnabled" : isViewEnabledVal,
                                            "isReportsEnabled" : true,
                                            "merchantNum" : merchantNum
                                                ]
                           print(param)
                            MBProgressHUD.showAdded(to: self.view, animated: true)
                           self.viewModel?.serviceRequest(param: param, apiName: RequestItemsType.modifyUser)

        }

        self.bindUI(indexPath: indexPath, isViewEnabledVal: isViewEnabledVal, isFromAPI: true)
    }
    
    // SANKET OVER
    
}




extension UIImage {
    
    func paintOver(colorHex: String) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let renderedImage = renderer.image { _ in
            UIColor.init(hexString: colorHex).set()
            self.withRenderingMode(.alwaysTemplate).draw(in: CGRect(origin: .zero, size: size))
        }
        
        return renderedImage
    }
}

class ImageWithoutRender: UIImage {
    override func withRenderingMode(_ renderingMode: UIImage.RenderingMode) -> UIImage {
        return self
    }
}
