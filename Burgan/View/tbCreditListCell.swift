//
//  tbCreditListCell.swift
//  Burgan
//
//  Created by Malti Maurya on 31/03/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//


import UIKit
import ExpyTableView

//MARK: Used Table View Classes

class tbCreditHeaderCell: UITableViewCell, ExpyTableViewHeaderCell{
    
  
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var btnArrow: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var viewRef: UIView!
    
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
    
    private func arrowDown(animated: Bool) {
        UIView.animate(withDuration: (animated ? 0.3 : 0)) {
            self.btnArrow.transform = CGAffineTransform(rotationAngle: (CGFloat.pi / 2 + CGFloat.pi / 2 ))
        }
    }
    
    private func arrowRight(animated: Bool) {
        UIView.animate(withDuration: (animated ? 0.3 : 0)) {
            self.btnArrow.transform = CGAffineTransform(rotationAngle: 0)
        }
    }
}

class tbCreditContentCell: UITableViewCell {
    
    @IBOutlet weak var netAmtTitle_Lbl: UILabel!

    @IBOutlet weak var gcc_Lbl: UILabel!
    @IBOutlet weak var knet_Lbl: UILabel!
    @IBOutlet weak var master_Lbl: UILabel!
    @IBOutlet weak var visa_Lbl: UILabel!
    
    @IBOutlet weak var lblGcc: UILabel!
    @IBOutlet weak var lblKnet: UILabel!
    @IBOutlet weak var lblMaster: UILabel!
    weak var delegate : creditPopupDelegate?
    @IBOutlet weak var lblVISA: UILabel!
    @IBOutlet weak var lblMID: PaddingLabel!
    
    @IBAction func showVisaDetail(_ sender: Any) {
        delegate?.showVISA(cell: self, BtnTag: (sender as! UIButton).tag)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        lblMID.layer.cornerRadius = 10
        
        gcc_Lbl.text = "GCC"
        knet_Lbl.text = "KNET"
        master_Lbl.text = "MASTER"
        visa_Lbl.text = "VISA"
        
    }
    
}


