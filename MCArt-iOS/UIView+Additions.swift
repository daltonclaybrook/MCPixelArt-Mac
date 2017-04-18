//
//  UIView+Additions.swift
//  Packtracker
//
//  Created by Dalton Claybrook on 4/2/16.
//  Copyright © 2016 Claybrook Software. All rights reserved.
//

import UIKit

extension UIView { // Constraints
    
    func constrainEdgesToSuperview() {
        constrainEdgesToSuperview(with: .zero)
    }
    
    func constrainEdgesToSuperview(with inset: UIEdgeInsets) {
        guard let superview=superview else { assertionFailure("must have a superview"); return }
        
        translatesAutoresizingMaskIntoConstraints = false
        superview.leftAnchor.constraint(equalTo: leftAnchor, constant: inset.left).isActive = true
        superview.topAnchor.constraint(equalTo: topAnchor, constant: inset.top).isActive = true
        superview.rightAnchor.constraint(equalTo: rightAnchor, constant: -inset.right).isActive = true
        superview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset.bottom).isActive = true
    }
}

extension UIView { // Actions
    
    class func performWithoutActions(block: () -> ()) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        block()
        CATransaction.commit()
    }
}

extension UIEdgeInsets {
    func dividingByScale(_ scale: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: top/scale, left: left/scale, bottom: bottom/scale, right: right/scale)
    }
}

extension CGRect {
    func byRotatingToMatch(image: UIImage) -> CGRect {
        let transform: CGAffineTransform
        switch image.imageOrientation {
        case .left:
            transform = CGAffineTransform(rotationAngle: .pi / 2.0).translatedBy(x: 0.0, y: -image.size.height)
        case .right:
            transform = CGAffineTransform(rotationAngle: .pi / -2.0).translatedBy(x: -image.size.width, y: 0.0)
        case .down:
            transform = CGAffineTransform(rotationAngle: .pi).translatedBy(x: -image.size.width, y: -image.size.height)
        default:
            transform = CGAffineTransform.identity
        }
        return self.applying(transform.scaledBy(x: image.scale, y: image.scale))
    }
}

extension UIImage {
    func normalized() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
