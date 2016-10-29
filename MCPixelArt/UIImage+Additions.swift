//
//  UIImage+Additions.swift
//  MCPixelArt
//
//  Created by Dalton Claybrook on 10/29/16.
//  Copyright © 2016 Claybrook Software, LLC. All rights reserved.
//

import UIKit

extension UIImage: Image {
    static func fromCGImage(_ image: CGImage, size: CGSize) -> Self {
        return self.init(cgImage: image)
    }

    func toCGImage() -> CGImage {
        return self.cgImage!
    }
}
