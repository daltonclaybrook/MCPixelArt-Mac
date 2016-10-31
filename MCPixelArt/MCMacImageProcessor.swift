//
//  MCMacImageProcessor.swift
//  MCPixelArt
//
//  Created by Dalton Claybrook on 10/29/16.
//  Copyright © 2016 Claybrook Software, LLC. All rights reserved.
//

import AppKit

@objc class MCMacImageProcessor: NSObject {
    
    private let processor: ImageProcessor<NSImage>
    
    override init() {
        processor = ImageProcessor<NSImage>(transformer: WoolColorTransformer())
        super.init()
    }
    
    func process(image: NSImage, size: CGSize) -> MCWoolImage? {
        let woolImage = processor.process(image: image, size: size)
        return woolImage.flatMap { MCWoolImage(woolImage: $0) }
    }
}
