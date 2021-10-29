//
//  tbCompanyLocationProfileCell.swift
//  Burgan
//
//  Created by Malti Maurya on 24/03/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit
import ExpyTableView


//MARK: Used Table View Classes

class tbCityNameCell: UITableViewCell, ExpyTableViewHeaderCell{
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    
    @IBOutlet weak var ivArrow: UIImageView!
    
    @IBOutlet weak var curvedView: UIView!
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //set the values for top,left,bottom,right margins
        let margins = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        contentView.frame = contentView.frame.inset(by: margins)
    }
    
    func changeState(_ state: ExpyState, cellReuseStatus cellReuse: Bool) {
        
        switch state {
        case .willExpand:
            print("WILL EXPAND")
            hideSeparator()
            arrowDown(animated: !cellReuse)
            
        case .willCollapse:
            print("WILL COLLAPSE")
            arrowRight(animated: !cellReuse)
            
        case .didExpand:
            print("DID EXPAND")
            
        case .didCollapse:
            showSeparator()
            print("DID COLLAPSE")
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    private func arrowDown(animated: Bool) {
        UIView.animate(withDuration: (animated ? 0.3 : 0)) {
            self.ivArrow.transform = CGAffineTransform(rotationAngle: (CGFloat.pi / 2 + CGFloat.pi / 2 ))
        }
    }
    
    private func arrowRight(animated: Bool) {
        UIView.animate(withDuration: (animated ? 0.3 : 0)) {
            self.ivArrow.transform = CGAffineTransform(rotationAngle: 0)
        }
    }
}

class tbLocationProfileCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblSubtitle: UILabel!
    
    @IBOutlet weak var curvedView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}


