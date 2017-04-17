//
//  WoolImage.swift
//  MCPixelArt
//
//  Created by Dalton Claybrook on 10/29/16.
//  Copyright © 2016 Claybrook Software, LLC. All rights reserved.
//

#if os(iOS)
    import UIKit
    typealias ImageT = UIImage
#elseif os(OSX)
    import AppKit
    typealias ImageT = NSImage
#endif

struct WoolImage {
    var name: String?
    let image: ImageT
    let woolIndexes: [Int]
}
