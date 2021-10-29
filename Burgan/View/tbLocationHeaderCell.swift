//
//  tbLocationHeaderCell.swift
//  Burgan
//
//  Created by Malti Maurya on 23/03/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit

class tbLocationHeaderCell: UITableViewHeaderFooterView {
    
    static let reuseIdentifier = "tbLocationHeaderCell"

    
    @IBOutlet weak var btnCheck: UIButton!
    
    @IBOutlet weak var ivArrow: UIImageView!
    @IBOutlet weak var lblLocationCount: UILabel!
    @IBOutlet weak var lblName: UILabel!
//    weak var delegate:sectionCollapseDelegate?
    
    func setExpanded(){
        ivArrow.image = UIImage(named: "ic_right_arrow_cards")
    }
    func setCollapsed()
    {
        ivArrow.image = UIImage(named: "ic_down_arrow_black")

    }
    @IBAction func selectCompany(_ sender: Any) {
//        delegate?.sectionCollapse(sender: self)
    }
    
    
}
