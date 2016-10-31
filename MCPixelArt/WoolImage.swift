//
//  WoolImage.swift
//  MCPixelArt
//
//  Created by Dalton Claybrook on 10/29/16.
//  Copyright © 2016 Claybrook Software, LLC. All rights reserved.
//

import Foundation

struct WoolImage {
    let image: Image
    let woolIndexes: [Int]
}

@objc class MCWoolImage: NSObject {
    
    init(woolImage: WoolImage) {
        self.woolImage = woolImage
    }
    
    private let woolImage: WoolImage
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
