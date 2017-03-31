//
//  WoolImage.swift
//  MCPixelArt
//
//  Created by Dalton Claybrook on 10/29/16.
//  Copyright © 2016 Claybrook Software, LLC. All rights reserved.
//

#if os(iOS)
    import UIKit
    typealias WoolImageT = WoolImage<UIImage>
#elseif os(OSX)
    import AppKit
    typealias WoolImageT = WoolImage<NSImage>
#endif

struct WoolImage<T:Image> {
    var name: String?
    let image: T
    let woolIndexes: [Int]
}
