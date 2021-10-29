//
//  CustomizationExampleUsedClasses.swift
//  ExpyTableView
//
//  Created by Okhan on 22/06/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import ExpyTableView


//1. delegate method
protocol tbCompanyNameCellDelegate: AnyObject {
    func btnSelectAllSectionTapped(cell: tbCompanyNameCell)
}


//MARK: Used Table View Classes

class tbCompanyNameCell: UITableViewCell, ExpyTableViewHeaderCell{
	
	@IBOutlet weak var lblName: UILabel!
	@IBOutlet weak var imageViewArrow: UIImageView!
//    @IBOutlet weak var ivCheckBox: UIImageView!
    @IBOutlet weak var ivCheckBox: UIButton!
    var check : Bool = false
    @IBOutlet weak var lblLocationCount: UILabel!
    
 //2. create delegate variable
 weak var delegate: tbCompanyNameCellDelegate?
    
    //3. assign this action to close button
    @IBAction func BtnSelectAllTapped(sender: AnyObject) {
        //4. call delegate method
        //check delegate is not nil with `?`
        delegate?.btnSelectAllSectionTapped(cell: self)
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
	
	private func arrowDown(animated: Bool) {
		UIView.animate(withDuration: (animated ? 0.3 : 0)) {
			// self.imageViewArrow.transform = CGAffineTransform(rotationAngle: (CGFloat.pi / 2))
            self.imageViewArrow.transform = CGAffineTransform(rotationAngle: (CGFloat(Double.pi)))
		}
	}
	
	private func arrowRight(animated: Bool) {
		UIView.animate(withDuration: (animated ? 0.3 : 0)) {
			// self.imageViewArrow.transform = CGAffineTransform(rotationAngle: 0)
            self.imageViewArrow.transform = CGAffineTransform.identity
		}
	}
}

class tbLocationNameCell: UITableViewCell {
	@IBOutlet weak var lblName: UILabel!
        @IBOutlet weak var ivCheckBox: UIImageView!
    var check : Bool = false

    
}
class tbTIDMIDCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var ivCheckBox: UIImageView!
    var check : Bool = false

    
}

extension UITableViewCell {

	func showSeparator() {
		DispatchQueue.main.async {
			// self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		}
	}
	
	func hideSeparator() {
		DispatchQueue.main.async {
			// self.separatorInset = UIEdgeInsets(top: 0, left: self.bounds.size.width, bottom: 0, right: 0)
		}
	}
}
