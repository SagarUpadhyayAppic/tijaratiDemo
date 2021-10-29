//
//  TidPopupTableViewCell.swift
//  Burgan
//
//  Created by Sagar Upadhyay on 27/08/21.
//  Copyright © 2021 1st iMac. All rights reserved.
//

import UIKit

class TidPopupTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var radioImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
