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
        guard let superview=superview else { assertionFailure("must have a superview"); return }
        
        translatesAutoresizingMaskIntoConstraints = false
        superview.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        superview.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        superview.topAnchor.constraint(equalTo: topAnchor).isActive = true
        superview.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
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
