//
//  tbLocationListCell.swift
//  Burgan
//
//  Created by Malti Maurya on 23/03/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit

class cvCompanyLocationListCell: UICollectionViewCell {

    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5
    }
}
