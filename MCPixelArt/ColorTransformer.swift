//
//  ColorTransformer.swift
//  MCPixelArt
//
//  Created by Dalton Claybrook on 10/28/16.
//  Copyright © 2016 Claybrook Software, LLC. All rights reserved.
//

import Foundation
import CoreGraphics

struct Color {
    let redValue: CGFloat
    let greenValue: CGFloat
    let blueValue: CGFloat
    
    func differenceByComparring(to color: Color) -> CGFloat {
        return sqrt(pow(color.redValue-redValue, 2.0) + pow(color.greenValue-greenValue, 2.0) + pow(color.blueValue-blueValue, 2.0))
    }
}

protocol Image {
    var size: CGSize { get }
    static func fromCGImage(_ image: CGImage, size: CGSize) -> Self
    func toCGImage() -> CGImage
}

protocol ColorTransformer {
    func transform(color: Color) -> (color: Color, index: Int)
}

class WoolColorTransformer: ColorTransformer {

    private let woolColors: [Color]
    
    init() {
        woolColors = [
            Color(redValue: 221.0/255.0, greenValue: 221.0/255.0, blueValue: 221.0/255.0), // White
            Color(redValue: 219.0/255.0, greenValue: 125.0/255.0, blueValue: 62.0/255.0), //Orange
            Color(redValue: 179.0/255.0, greenValue: 80.0/255.0, blueValue: 188.0/255.0), //Magenta
            Color(redValue: 107.0/255.0, greenValue: 138.0/255.0, blueValue: 39.0/255.0), //Light Blue
            Color(redValue: 177.0/255.0, greenValue: 166.0/255.0, blueValue: 39.0/255.0), //Yellow
            Color(redValue: 65.0/255.0, greenValue: 174.0/255.0, blueValue: 56.0/255.0), //Lime
            Color(redValue: 208.0/255.0, greenValue: 132.0/255.0, blueValue: 153.0/255.0), //Pink
            Color(redValue: 64.0/255.0, greenValue: 64.0/255.0, blueValue: 64.0/255.0), //Gray
            Color(redValue: 154.0/255.0, greenValue: 161.0/255.0, blueValue: 161.0/255.0), //Light Gray
            Color(redValue: 46.0/255.0, greenValue: 110.0/255.0, blueValue: 137.0/255.0), //Cyan
            Color(redValue: 126.0/255.0, greenValue: 61.0/255.0, blueValue: 181.0/255.0), //Purple
            Color(redValue: 46.0/255.0, greenValue: 56.0/255.0, blueValue: 141.0/255.0), //Blue
            Color(redValue: 79.0/255.0, greenValue: 50.0/255.0, blueValue: 31.0/255.0), //Brown
            Color(redValue: 53.0/255.0, greenValue: 70.0/255.0, blueValue: 27.0/255.0), //Green
            Color(redValue: 150.0/255.0, greenValue: 52.0/255.0, blueValue: 48.0/255.0), //Red
            Color(redValue: 25.0/255.0, greenValue: 22.0/255.0, blueValue: 22.0/255.0) //Black
        ]
    }
    
    func transform(color: Color) -> (color: Color, index: Int) {
        let mapped = woolColors.enumerated().sorted { color.differenceByComparring(to: $0.1) < color.differenceByComparring(to: $1.1) }.first
        return (mapped!.element, mapped!.offset)
    }
}
