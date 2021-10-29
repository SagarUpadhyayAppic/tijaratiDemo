//
//  UIView.swift
//  GuageMeterDemo
//
//  Created by Pratik on 13/07/21.
//

import Foundation
import UIKit

extension UIView {
  func addDashedBorder() {
    let color = #colorLiteral(red: 0.7490196078, green: 0.8078431373, blue: 0.8588235294, alpha: 1)

    let shapeLayer:CAShapeLayer = CAShapeLayer()
    let frameSize = self.frame.size
    let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)

    shapeLayer.bounds = shapeRect
    shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
    shapeLayer.fillColor = UIColor.clear.cgColor
    shapeLayer.strokeColor = color.cgColor
    shapeLayer.lineWidth = 1
    shapeLayer.lineJoin = CAShapeLayerLineJoin.round
    shapeLayer.lineDashPattern = [6,3]
    shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 10).cgPath
    //self.layer.masksToBounds = true
    self.layer.addSublayer(shapeLayer)
    
    }
    
    func dropShadow() {

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize.zero
        layer.masksToBounds = false

        layer.shadowOpacity = 0.5
        layer.shadowRadius = 1.0
        layer.rasterizationScale = UIScreen.main.scale
        layer.shouldRasterize = true
    }

}


