//
//  tbFilterListCell.swift
//  Burgan
//
//  Created by Malti Maurya on 31/03/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit

class tbFilterListCell: UITableViewCell {
    
    
    @IBOutlet weak var ivCheckBox: UIImageView!
    
    @IBOutlet weak var lblMIDCount: UILabel!
    @IBOutlet weak var lblName: UILabel!
    var selectedCell : Bool = false
    
    func selected()
    {
        lblName.textColor = UIColor.black
         ivCheckBox.image = UIImage(named: "ic_checkbox_enabled")
        lblMIDCount.textColor = UIColor.black
    }
    
    func deSelected()
    {
        lblName.textColor = UIColor.BurganColor.brandGray.lgiht
        lblMIDCount.textColor = UIColor.BurganColor.brandGray.lgiht
         ivCheckBox.image = UIImage(named: "ic_checkbox_disabled")
    }
}
