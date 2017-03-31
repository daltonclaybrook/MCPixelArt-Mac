//
//  GradientView.swift
//  MCPixelArt
//
//  Created by Dalton Claybrook on 3/30/17.
//  Copyright © 2017 Claybrook Software, LLC. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {
    override var bounds: CGRect { didSet { updateView() } }
    override var frame: CGRect { didSet { updateView() } }
    
    var startColor = UIColor(white: 0.0, alpha: 0.5) { didSet { updateView() } }
    var endColor = UIColor.clear { didSet { updateView() } }
    var startPoint = CGPoint(x: 0.5, y: 1.0) { didSet { updateView() } }
    var endPoint = CGPoint(x: 0.5, y: 0.0) { didSet { updateView() } }
    
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
    }
    
    //MARK: Private
    
    private func configureView() {
        layer.addSublayer(gradientLayer)
        updateView()
    }
    
    private func updateView() {
        backgroundColor = .clear
        gradientLayer.frame = bounds
        gradientLayer.colors = [ startColor.cgColor, endColor.cgColor ]
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
    }
}
