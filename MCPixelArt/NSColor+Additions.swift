//
//  NSColor+Additions.swift
//  MCPixelArt
//
//  Created by Dalton Claybrook on 10/28/16.
//  Copyright © 2016 Claybrook Software, LLC. All rights reserved.
//

import AppKit

extension NSColor: Color {
    var redValue: CGFloat {
        return redComponent
    }
    var greenValue: CGFloat {
        return greenComponent
    }
    var blueValue: CGFloat {
        return blueComponent
    }

    static func create(r: CGFloat, g: CGFloat, b: CGFloat) -> Self {
        return self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    func differenceByComparring(to color: NSColor) -> CGFloat {
        let _color1 = self.usingColorSpace(NSColorSpace.genericCMYK)
        let _color2 = color.usingColorSpace(NSColorSpace.genericCMYK)
        guard let color1 = _color1, let color2 = _color2 else { return CGFloat.greatestFiniteMagnitude }
        
        return sqrt(pow((color2.cyanComponent-color1.cyanComponent), 2.0) + pow((color2.magentaComponent-color1.magentaComponent), 2.0) + pow((color2.yellowComponent-color1.yellowComponent), 2.0) + pow((color2.blackComponent-color1.blackComponent), 2.0))
    }
}
