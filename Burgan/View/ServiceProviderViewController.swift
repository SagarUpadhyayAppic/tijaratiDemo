//
//  ServiceProviderDialogView.swift
//  Burgan
//
//  Created by 1st iMac on 13/03/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit
import SPStorkController

class ServiceProviderViewController : UIViewController, UITableViewDelegate, UITableViewDataSource
{
  
    @IBOutlet var bottomBtnCurvedview: UIView!
    
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet var tbServiceProvider: UITableView!
    var selectedProvider  : serviceProviderList? = nil
    weak var delegate : selectProviderDelegate?
    var serviceproviderArr : [serviceProviderList]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnAdd.setTitle("CONFIRM".uppercased(), for: .normal)
        tbServiceProvider.reloadData()
        bottomBtnCurvedview.clipsToBounds = true
        bottomBtnCurvedview.layer.cornerRadius = 10
        bottomBtnCurvedview.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        bottomBtnCurvedview.backgroundColor = UIColor.BurganColor.brandGray.lgiht
        btnAdd.isUserInteractionEnabled = false
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
  
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    var panScrollable: UIScrollView? {
        return nil
    }
    

    var anchorModalToLongForm: Bool {
        return false
    }
    
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as!  tbServiceProviderCell
        bottomBtnCurvedview.backgroundColor = UIColor.BurganColor.brandBlue.medium
        btnAdd.setTitleColor(UIColor.white, for: .normal)
        cell.ivSelectProvider.image = UIImage(named: "ic_radio_enabled")
        cell.lblServiceName.textColor = UIColor.black
        selectedProvider = serviceproviderArr![indexPath.row]
        btnAdd.isUserInteractionEnabled = true
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as!  tbServiceProviderCell
        cell.ivSelectProvider.image = UIImage(named: "ic_radio_circle")
        cell.lblServiceName.textColor = UIColor.BurganColor.brandGray.lgiht

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceproviderArr!.count
    }
    
    @IBAction func addProvider(_ sender: Any) {
        
        delegate?.selectedProvider(service: selectedProvider!)
        self.dismiss(animated: true, completion: nil)
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tbServiceProviderCell", for: indexPath) as! tbServiceProviderCell
        cell.ivService.image = UIImage(named:  serviceproviderArr![indexPath.row].providerImg!)
        cell.lblServiceName.text = serviceproviderArr![indexPath.row].name
        return cell
    }
    
 
}
