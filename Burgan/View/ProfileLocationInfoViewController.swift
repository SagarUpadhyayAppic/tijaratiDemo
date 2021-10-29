//
//  ProfileLocationInfoViewController.swift
//  Burgan
//
//  Created by Malti Maurya on 25/03/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit
import ExpyTableView

class ProfileLocationInfoViewController: UIViewController {
 
    @IBOutlet weak var tblocationInfo: ExpyTableView!
    
    @IBAction func goBack(_ sender: Any) {
        let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        controller?.selectedIndex = 2
             self.navigationController?.pushViewController(controller!, animated: true)
    }
    @IBOutlet weak var lblLocationName: UILabel!
    @IBAction func search(_ sender: Any) {
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.networkStatusChanged(_:)), name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        definesPresentationContext = true

        
        self.loopThroughSubViewAndMirrorImage(subviews: self.view.subviews)
    }
    
    func curvedviewShadow(view:UIView){
            
                view.layer.cornerRadius = 8
                view.layer.shadowOpacity = 0.35
                view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
                view.layer.shadowRadius = 3.0
            view.layer.shadowColor = UIColor.BurganColor.brandGray.lgiht.cgColor
                view.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner,.layerMaxXMinYCorner]
        }
 
     
     
}
//MARK: ExpyTableViewDataSourceMethods
       extension ProfileLocationInfoViewController: ExpyTableViewDataSource {
           
           func tableView(_ tableView: ExpyTableView, canExpandSection section: Int) -> Bool {
               return true
           }
           
           func tableView(_ tableView: ExpyTableView, expandableCellForSection section: Int) -> UITableViewCell {
               let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: tbCityNameCell.self)) as! tbCityNameCell
               cell.layoutMargins = UIEdgeInsets.zero
            cell.lblName.text = "Qasir"
            cell.lblSubtitle.text = "2 Terminal IDs"
          curvedviewShadow(view: cell)
               cell.showSeparator()
               return cell
           }
        func numberOfSections(in tableView: UITableView) -> Int {
           // tbComapnyHeight.constant = 80 * 2
                   return 2
               }
               
       }

       //MARK: ExpyTableView delegate methods
       extension ProfileLocationInfoViewController: ExpyTableViewDelegate {
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


       extension ProfileLocationInfoViewController {
           func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
               
               tableView.deselectRow(at: indexPath, animated: false)
            if (tableView.cellForRow(at: indexPath) as? tbLocationProfileCell) != nil {
                   let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProfilePopupsViewController") as? ProfilePopupsViewController
                             controller!.popupType = 1
                                presentAsStork(controller!, height: 550, cornerRadius: 10, showIndicator: false, showCloseButton: false)               }
              
               print("DID SELECT row: \(indexPath.row), section: \(indexPath.section)")
           }
       
           
         

       }



       //MARK: UITableView Data Source Methods
       extension ProfileLocationInfoViewController {
          
           func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
               return 3
           }
      
      
           
           func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
               
              
                   let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: tbLocationProfileCell.self)) as! tbLocationProfileCell
                   cell.layoutMargins = UIEdgeInsets.zero
            cell.lblName.text = "TID : 92401239"
            cell.lblSubtitle.isHidden = true
            curvedviewShadow(view: cell.curvedView)
                   cell.hideSeparator()
          //  tbComapnyHeight.constant = 60 + tbComapnyHeight.constant
                   return cell
               
           }
       }
