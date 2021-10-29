//
//  tbCompanyListProfileCell.swift
//  Burgan
//
//  Created by Malti Maurya on 25/03/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit

class tbCompanyListProfileCell: UITableViewCell {
    
    @IBOutlet weak var lblStoreCount: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var ivSelectIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ivSelectIcon.isHidden = true
    }
    
    
    func selectRow(){
        lblStoreCount.textColor = UIColor.BurganColor.brandBlue.medium
        ivSelectIcon.isHidden = false
        
    }
    func deselectRow(){
        
        lblStoreCount.textColor = UIColor.black
        ivSelectIcon.isHidden = true
    }
}
