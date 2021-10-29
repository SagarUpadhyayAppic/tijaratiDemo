//
//  ServicePopUpViewController.swift
//  Burgan
//
//  Created by Malti Maurya on 09/04/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit

class ServicePopUpViewController: UIViewController {
    
    @IBOutlet weak var lblemail: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    override func viewDidLoad() {
        
        self.loopThroughSubViewAndAlignTextfieldText(subviews: self.view.subviews)
        self.loopThroughSubViewAndAlignLabelText(subviews: self.view.subviews)
        
        lblPhone.text = "+9651804080"
        lblemail.text = "MerchantServices@burgan.com"
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
