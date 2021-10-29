//
//  GradientlayerView.swift
//  Burgan
//
//  Created by Malti Maurya on 18/03/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit

@IBDesignable
class GradientlayerView: UIView {

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
    func setupConstraints() {
        guard let parentView = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
        leftAnchor.constraint(equalTo: parentView.leftAnchor).isActive = true
        parentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        parentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }


    private func updateColors() {
        gradientLayer.colors = [color1.cgColor, color2.cgColor, color3.cgColor]
    }

}
extension UINavigationBar {
    func setGradientBackground() {
        guard let backgroundView = value(forKey: "backgroundView") as? UIView else { return }
        guard (backgroundView.subviews.first(where: { $0 is GradientlayerView }) as? GradientlayerView) != nil else {
            let gradientView = GradientlayerView()
            backgroundView.addSubview(gradientView)
            gradientView.setupConstraints()
            return
        }
       // gradientView.set(colors: colors, startPoint: startPoint, endPoint: endPoint, locations: locations)
    }
}
