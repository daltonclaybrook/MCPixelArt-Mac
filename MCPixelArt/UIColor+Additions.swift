//
//  UIColor+Additions.swift
//  MCPixelArt
//
//  Created by Dalton Claybrook on 10/28/16.
//  Copyright © 2016 Claybrook Software, LLC. All rights reserved.
//

import UIKit

extension UIColor: Color {
    var redValue: CGFloat {
        var r: CGFloat = 0
        self.getRed(&r, green: nil, blue: nil, alpha: nil)
        return r
    }
    var greenValue: CGFloat {
        var g: CGFloat = 0
        self.getRed(nil, green: &g, blue: nil, alpha: nil)
        return g
    }
    var blueValue: CGFloat {
        var b: CGFloat = 0
        self.getRed(nil, green: nil, blue: &b, alpha: nil)
        return b
    }
    
    static func create(r: CGFloat, g: CGFloat, b: CGFloat) -> Self {
        return self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    func differenceByComparring(to color: UIColor) -> CGFloat {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: nil)
        
        var cr: CGFloat = 0
        var cg: CGFloat = 0
        var cb: CGFloat = 0
        color.getRed(&cr, green: &cg, blue: &cb, alpha: nil)
        
        return sqrt(pow(cr-r, 2.0) + pow(cg-g, 2.0) + pow(cb-b, 2.0))
    }
}
