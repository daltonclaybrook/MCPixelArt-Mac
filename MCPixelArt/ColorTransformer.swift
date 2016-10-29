//
//  ColorTransformer.swift
//  MCPixelArt
//
//  Created by Dalton Claybrook on 10/28/16.
//  Copyright © 2016 Claybrook Software, LLC. All rights reserved.
//

import Foundation
import CoreGraphics

protocol Color {
    var redValue: CGFloat { get }
    var greenValue: CGFloat { get }
    var blueValue: CGFloat { get }
    
    static func create(r: CGFloat, g: CGFloat, b: CGFloat) -> Self
    func differenceByComparring(to color: Self) -> CGFloat
}

protocol Image {
    var size: CGSize { get }
    static func fromCGImage(_ image: CGImage, size: CGSize) -> Self
    func toCGImage() -> CGImage
}

protocol ColorTransformer {
    associatedtype U : Color
    func transform(color: U) -> (color: U, index: Int)
}

class WoolColorTransformer<T:Color>: ColorTransformer {
    typealias U = T
    private let woolColors: [U]
    
    init() {
        woolColors = [
            U.create(r: 221.0/255.0, g: 221.0/255.0, b: 221.0/255.0), // White
            U.create(r: 219.0/255.0, g: 125.0/255.0, b: 62.0/255.0), //Orange
            U.create(r: 179.0/255.0, g: 80.0/255.0, b: 188.0/255.0), //Magenta
            U.create(r: 107.0/255.0, g: 138.0/255.0, b: 39.0/255.0), //Light Blue
            U.create(r: 177.0/255.0, g: 166.0/255.0, b: 39.0/255.0), //Yellow
            U.create(r: 65.0/255.0, g: 174.0/255.0, b: 56.0/255.0), //Lime
            U.create(r: 208.0/255.0, g: 132.0/255.0, b: 153.0/255.0), //Pink
            U.create(r: 64.0/255.0, g: 64.0/255.0, b: 64.0/255.0), //Gray
            U.create(r: 154.0/255.0, g: 161.0/255.0, b: 161.0/255.0), //Light Gray
            U.create(r: 46.0/255.0, g: 110.0/255.0, b: 137.0/255.0), //Cyan
            U.create(r: 126.0/255.0, g: 61.0/255.0, b: 181.0/255.0), //Purple
            U.create(r: 46.0/255.0, g: 56.0/255.0, b: 141.0/255.0), //Blue
            U.create(r: 79.0/255.0, g: 50.0/255.0, b: 31.0/255.0), //Brown
            U.create(r: 53.0/255.0, g: 70.0/255.0, b: 27.0/255.0), //Green
            U.create(r: 150.0/255.0, g: 52.0/255.0, b: 48.0/255.0), //Red
            U.create(r: 25.0/255.0, g: 22.0/255.0, b: 22.0/255.0) //Black
        ]
    }
    
    func transform(color: U) -> (color: U, index: Int) {
        let mapped = woolColors.enumerated().sorted { color.differenceByComparring(to: $0.1) < color.differenceByComparring(to: $1.1) }.first!
        return (mapped.element, mapped.offset)
    }
}
