//
//  CalendarCustomCell.swift
//  Burgan
//
//  Created by Malti Maurya on 15/04/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import Foundation
import FSCalendar

import UIKit



class CalendarCustomCell: FSCalendarCell {
    
    weak var selectionLayer: CALayer!
    
    var selectionType: SelectionType = .none {
        didSet {
            setNeedsLayout()
        }
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let border = CALayer()
        border.backgroundColor = UIColor.BurganColor.brandBlue.medium.cgColor
        border.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        border.actions = ["hidden": NSNull()]
        
    //       self.layer.addSublayer(border)
//        let selectionLayer = CAShapeLayer()
//        selectionLayer.fillColor = UIColor.white.cgColor
//        selectionLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(border, below: self.titleLabel!.layer)
        self.selectionLayer = border
        
        self.shapeLayer.isHidden = true
        
        let view = UIView(frame: self.bounds)
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.12)
        self.backgroundView = view;
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       // self.circleImageView.frame = self.contentView.bounds
        self.backgroundView?.frame = self.bounds.insetBy(dx: 1, dy: 1)
        self.selectionLayer.frame = self.contentView.bounds
//
//        if selectionType == .middle {
//            self.selectionLayer.path = UIBezierPath(rect: self.selectionLayer.bounds).cgPath
//        }
//        else if selectionType == .leftBorder {
//            self.selectionLayer.path = UIBezierPath(roundedRect: self.selectionLayer.bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: self.selectionLayer.frame.width / 2, height: self.selectionLayer.frame.width / 2)).cgPath
//        }else if selectionType ==  .bottomBorder{
//
//        }
//        else if selectionType == .rightBorder {
//            self.selectionLayer.path = UIBezierPath(roundedRect: self.selectionLayer.bounds, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: self.selectionLayer.frame.width / 2, height: self.selectionLayer.frame.width / 2)).cgPath
//        }
//        else if selectionType == .single {
//            let diameter: CGFloat = min(self.selectionLayer.frame.height, self.selectionLayer.frame.width)
//            self.selectionLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: self.contentView.frame.height / 2 - diameter / 2, width: diameter, height: diameter)).cgPath
//        }
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        // Override the build-in appearance configuration
        if self.isPlaceholder {
            self.eventIndicator.isHidden = true
            self.titleLabel.textColor = UIColor.lightGray
        }
    }
    
}
