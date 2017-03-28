//
//  MCWoolImage.swift
//  MCPixelArt
//
//  Created by Dalton Claybrook on 10/30/16.
//  Copyright © 2016 Claybrook Software, LLC. All rights reserved.
//

import AppKit

@objc class MCWoolImage: NSObject {
    
    init(woolImage: WoolImage<NSImage>) {
        self.woolImage = woolImage
    }
    
    private let woolImage: WoolImage<NSImage>
    var image: Any {
        return woolImage.image
    }
    var imageSize: CGSize {
        return woolImage.image.size
    }
    var woolIndexes: [Int] {
        return woolImage.woolIndexes
    }
}
