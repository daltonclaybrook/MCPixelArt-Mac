//
//  ImageLogic.h
//  MCPixelArt
//
//  Created by Dalton Claybrook on 2/13/13.
//  Copyright (c) 2013 Claybrook Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Schematic.h"
#import "WoolImage.h"

@interface ImageLogic : NSObject

@property (nonatomic, strong) NSImage *image;
@property (nonatomic, readonly) CGFloat aspectRatio;

- (WoolImage *)processImageWithSize:(CGSize)size;

@end
