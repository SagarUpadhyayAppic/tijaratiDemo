//
//  LocationListTbCell.swift
//  Burgan
//
//  Created by Malti Maurya on 29/05/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import Foundation

class LocationListTbCell: UICollectionViewCell {
    
    @IBOutlet weak var lblLocatioName: PaddingLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 5
    }
}
