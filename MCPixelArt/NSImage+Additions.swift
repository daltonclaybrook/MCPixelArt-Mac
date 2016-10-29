//
//  NSImage+Additions.swift
//  MCPixelArt
//
//  Created by Dalton Claybrook on 10/29/16.
//  Copyright © 2016 Claybrook Software, LLC. All rights reserved.
//

import AppKit

extension NSImage: Image {
    
    static func fromCGImage(_ image: CGImage, size: CGSize) -> Self {
        let nsSize = NSSize(width: size.width, height: size.height)
        return self.init(cgImage: image, size: nsSize)
    }
    
    func toCGImage() -> CGImage {
        let source = CGImageSourceCreateWithData(self.tiffRepresentation as! CFData, nil)!
        return CGImageSourceCreateImageAtIndex(source, 0, nil)!
    }
}
