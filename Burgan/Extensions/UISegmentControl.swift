//
//  UISegmentControl.swift
//  Burgan
//
//  Created by Pratik on 19/07/21.
//  Copyright © 2021 1st iMac. All rights reserved.
//

import Foundation
import UIKit

extension UISegmentedControl {

    func removeBorder(){

        self.tintColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        self.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0, green: 0.3960784314, blue: 0.6509803922, alpha: 1)], for: .selected)
        self.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.4980392157, green: 0.6156862745, blue: 0.7215686275, alpha: 1)], for: .normal)
        if #available(iOS 13.0, *) {
            self.selectedSegmentTintColor = UIColor.clear
        }

    }

    func setupSegment() {
        self.removeBorder()
        let segmentUnderlineWidth: CGFloat = self.bounds.width
        let segmentUnderlineHeight: CGFloat = 2.0
        let segmentUnderlineXPosition = self.bounds.minX
        let segmentUnderLineYPosition = self.bounds.size.height - 1.0
        let segmentUnderlineFrame = CGRect(x: segmentUnderlineXPosition, y: segmentUnderLineYPosition, width: segmentUnderlineWidth, height: segmentUnderlineHeight)
        let segmentUnderline = UIView(frame: segmentUnderlineFrame)
        segmentUnderline.backgroundColor = UIColor.clear

        self.addSubview(segmentUnderline)
        self.addUnderlineForSelectedSegment()
    }

    func addUnderlineForSelectedSegment(){

        let underlineWidth: CGFloat = self.bounds.size.width / CGFloat(self.numberOfSegments)
        let underlineHeight: CGFloat = 4.0
        let underlineXPosition = CGFloat(selectedSegmentIndex * Int(underlineWidth))
        let underLineYPosition = self.bounds.size.height - 1.0
        let underlineFrame = CGRect(x: underlineXPosition, y: underLineYPosition, width: underlineWidth, height: underlineHeight)
        let underline = UIView(frame: underlineFrame)
        underline.backgroundColor = #colorLiteral(red: 0, green: 0.3960784314, blue: 0.6509803922, alpha: 1)
        underline.tag = 1
        self.addSubview(underline)

        changeUnderlinePosition()
    }

    func changeUnderlinePosition(){
        guard let underline = self.viewWithTag(1) else {return}
        // let underlineFinalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(self.numberOfSegments - (selectedSegmentIndex + 1))
        var underlineFinalXPosition: CGFloat = 0.0
        if AppConstants.language == .ar {
            underlineFinalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(self.numberOfSegments - (selectedSegmentIndex + 1))
        } else {
            underlineFinalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(selectedSegmentIndex)
        }
        underline.frame.origin.x = underlineFinalXPosition

    }
    
    ///REPLACE SEGMENT ITEMS
    func replaceSegments(segments: Array<String>) {
        self.removeAllSegments()
        for segment in segments {
            self.insertSegment(withTitle: segment, at: self.numberOfSegments, animated: false)
        }
    }
    
    ///SEGMENT MULTILINE
    func makeTitleMultiline(){
      for i in 0...self.numberOfSegments - 1 {
        let label = UILabel(frame: CGRect(x: 0, y: -7, width: (self.frame.width-10)/CGFloat(self.numberOfSegments), height: self.frame.height))
        label.textColor = i == 0 ? UIColor.blue : UIColor.black
        label.text = self.titleForSegment(at: i)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.tag = i
        self.setTitle("", forSegmentAt: i)
        self.subviews[i].addSubview(label)
      }
    }

    func setSelectedTitleColor() {
      for i in 0...self.numberOfSegments - 1 {
        let label = self.subviews[self.numberOfSegments - 1 - i].subviews[1] as? UILabel
        label?.textColor = label?.tag == self.selectedSegmentIndex ? UIColor.red : UIColor.blue
      }
    }
}
