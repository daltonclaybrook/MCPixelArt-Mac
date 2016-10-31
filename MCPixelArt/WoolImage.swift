//
//  WoolImage.swift
//  MCPixelArt
//
//  Created by Dalton Claybrook on 10/29/16.
//  Copyright © 2016 Claybrook Software, LLC. All rights reserved.
//

import Foundation

struct WoolImage<T:Image> {
    let image: T
    let woolIndexes: [Int]
}
