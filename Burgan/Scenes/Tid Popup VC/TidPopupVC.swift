//
//  TidPopupVC.swift
//  Burgan
//
//  Created by Sagar Upadhyay on 27/08/21.
//  Copyright © 2021 1st iMac. All rights reserved.
//

import UIKit

class TidPopupVC: UIViewController {
    class var instance: TidPopupVC {
        struct Static {
            static let instance: TidPopupVC = TidPopupVC()
        }
        return Static.instance
    }
    private var listener: TidPopupVCDelegate?
    
    @IBOutlet weak var popupBackView: UIView!
    @IBOutlet weak var titleBackView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var listTableViewHeightConstraint: NSLayoutConstraint!
    
    var selectedIndex = 1
    var isFist = true
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func proceedButtonAction(_ sender: Any) {
        self.dismiss(animated: true) {
            AppConstants.selectedFilter!.companyName = AppConstants.cifDataList[self.selectedIndex].companyName
            AppConstants.cifCompanyName = AppConstants.cifDataList[self.selectedIndex].companyName
            AppConstants.ezpayOutletNumber = AppConstants.cifDataList[self.selectedIndex].ezpayOutletNumber
            AppConstants.UserData.companyCIF = AppConstants.cifDataList[self.selectedIndex].cif
            TidPopupVC.instance.sendDismissedAction()
        }
    }
    
}

extension TidPopupVC {
    func setupUI() {
        popupBackView.layer.cornerRadius = 10
        popupBackView.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner,.layerMaxXMinYCorner]
        titleBackView.layer.cornerRadius = 10
        titleBackView.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner,.layerMaxXMinYCorner]
        
        titleLabel.text = "Select CIF".localiz()
        proceedButton.setTitle("Proceed".localiz(), for: .normal)
        
        listTableView.register(UINib(nibName: "TidPopupTableViewCell", bundle: nil), forCellReuseIdentifier: "TidPopupTableViewCell")
        listTableView.reloadData()
        listTableViewHeightConstraint.constant = listTableView.contentSize.height < 400 ? (listTableView.contentSize.height + 60) : 400
        view.layoutIfNeeded()
        
    }
}


extension TidPopupVC: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppConstants.cifDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TidPopupTableViewCell", for: indexPath) as! TidPopupTableViewCell
        let object = AppConstants.cifDataList[indexPath.row]
        cell.titleLabel.text = object.companyName
        if isFist{
            cell.radioImage.image = UIImage(named: object.cif == AppConstants.UserData.companyCIF ? "ic_radio_enabled" : "ic_radio_circle")
        }else{
            cell.radioImage.image = UIImage(named: selectedIndex == indexPath.row ? "ic_radio_enabled" : "ic_radio_circle")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isFist = false
        selectedIndex = indexPath.row
        listTableView.reloadData()
    }
    
    
}

extension TidPopupVC{
    
    func setListener(listener: TidPopupVCDelegate){
        self.listener = listener
    }
    
    func sendDismissedAction() {
        listener?.didiVCDismiss()
    }
}


protocol TidPopupVCDelegate:class {
    func didiVCDismiss()
}
