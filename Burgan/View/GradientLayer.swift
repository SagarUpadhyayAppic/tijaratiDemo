//
//  GradientLayer.swift
//  Burgan
//
//  Created by Malti Maurya on 17/03/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit
@IBDesignable
class GradientLayer: UIButton {

    override class var layerClass: AnyClass { return CAGradientLayer.self }

    private var gradientLayer: CAGradientLayer { return layer as! CAGradientLayer }

    @IBInspectable var color1: UIColor = UIColor(displayP3Red: 0/255.0, green: 136/255.0, blue: 208/255.0, alpha: 1) { didSet { updateColors() } }
    @IBInspectable var color2: UIColor = UIColor(displayP3Red: 0/255.0, green: 115/255.0, blue: 185/255.0, alpha: 1)  { didSet { updateColors() } }
    @IBInspectable var color3: UIColor = UIColor(displayP3Red: 0/255.0, green: 94/255.0, blue: 161/255.0, alpha: 1)  { didSet { updateColors() } }

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        configureGradient()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureGradient()
    }

    private func configureGradient() {
        gradientLayer.startPoint = CGPoint(x: 1, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        updateColors()
    }

    private func updateColors() {
        gradientLayer.colors = [color1.cgColor, color2.cgColor, color3.cgColor]
    }

}
