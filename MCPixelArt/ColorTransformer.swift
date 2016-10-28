//
//  ColorTransformer.swift
//  MCPixelArt
//
//  Created by Dalton Claybrook on 10/28/16.
//  Copyright © 2016 Claybrook Software, LLC. All rights reserved.
//

import Foundation

protocol Color {
    var redValue: CGFloat { get }
    var greenValue: CGFloat { get }
    var blueValue: CGFloat { get }
    
    func differenceByComparring(to color: Self) -> CGFloat
}

protocol ColorTransformer {
    func transform<T:Color>(color: T) -> T
}
