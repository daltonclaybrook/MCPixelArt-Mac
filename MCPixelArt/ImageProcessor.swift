//
//  ImageProcessor.swift
//  MCPixelArt
//
//  Created by Dalton Claybrook on 10/29/16.
//  Copyright © 2016 Claybrook Software, LLC. All rights reserved.
//

import Foundation
import CoreGraphics

class ImageProcessor<U:Image> {
    
    let transformer: ColorTransformer
    
    init(transformer: ColorTransformer) {
        self.transformer = transformer
    }
    
    //MARK: Public
    
    func process(image: U, size: CGSize) -> WoolImage<U>? {
        let context = createARGBContext(with: size)
        context.draw(image.toCGImage(), in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        guard let ptr = context.data else { return nil }
        
        let data = ptr.bindMemory(to: UInt8.self, capacity: Int(size.width * size.height * 4))
        var woolIndexes = [Int]()
        
        for y in 0..<Int(size.height) {
            for x in 0..<Int(size.width) {
                let index = indexFrom(point: CGPoint(x: x, y: y), size: size)!
                let oldR = CGFloat(data[index+1])/255.0
                let oldG = CGFloat(data[index+2])/255.0
                let oldB = CGFloat(data[index+3])/255.0
                let color = Color(redValue: oldR, greenValue: oldG, blueValue: oldB)
                let (newColor, colorIdx) = transformer.transform(color: color)
                woolIndexes.insert(colorIdx, at: 0)
                
                data[index] = 255
                data[index+1] = min(max(UInt8(newColor.redValue * 255.0), 0), 255)
                data[index+2] = min(max(UInt8(newColor.greenValue * 255.0), 0), 255)
                data[index+3] = min(max(UInt8(newColor.blueValue * 255.0), 0), 255)
                
                let quantError = [
                    Int(oldR*255.0 - newColor.redValue*255.0),
                    Int(oldG*255.0 - newColor.greenValue*255.0),
                    Int(oldB*255.0 - newColor.blueValue*255.0)
                ]
                
                let ditherIndexes = [
                    indexFrom(point: CGPoint(x: x+1, y: y), size: size),
                    indexFrom(point: CGPoint(x: x+2, y: y), size: size),
                    indexFrom(point: CGPoint(x: x-1, y: y+1), size: size),
                    indexFrom(point: CGPoint(x: x, y: y+1), size: size),
                    indexFrom(point: CGPoint(x: x+1, y: y+1), size: size),
                    indexFrom(point: CGPoint(x: x, y: y+2), size: size)
                ]
                
                for ditherIdx in ditherIndexes {
                    if let ditherIdx = ditherIdx {
                        let updated1 = Int(data[ditherIdx+1]) + Int(0.125 * Double(quantError[0]))
                        let updated2 = Int(data[ditherIdx+2]) + Int(0.125 * Double(quantError[1]))
                        let updated3 = Int(data[ditherIdx+3]) + Int(0.125 * Double(quantError[2]))
                        
                        data[ditherIdx+1] = UInt8(min(max(updated1, 0), 255))
                        data[ditherIdx+2] = UInt8(min(max(updated2, 0), 255))
                        data[ditherIdx+3] = UInt8(min(max(updated3, 0), 255))
                    }
                }
            }
        }
        
        let cgImage = context.makeImage()!
        let newImage = U.fromCGImage(cgImage, size: size)
        return WoolImage(image: newImage, woolIndexes: woolIndexes)
    }
    
    //MARK: Private
    
    private func createARGBContext(with size: CGSize) -> CGContext {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitsPerComponent = 8
        let bytesPerRow = Int(size.width * 4)
        let bitmapInfo = CGImageAlphaInfo.premultipliedFirst.rawValue
        
        let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        return context!
    }
    
    private func indexFrom(point: CGPoint, size: CGSize) -> Int? {
        if (point.x < 0) || (point.x >= size.width) || (point.y < 0) || (point.y >= size.height) {
            return nil
        }
        return Int((point.y * size.width + point.x) * 4)
    }
}
