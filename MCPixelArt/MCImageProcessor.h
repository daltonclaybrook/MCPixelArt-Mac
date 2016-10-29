//
//  ImageLogic.h
//  MCPixelArt
//
//  Created by Dalton Claybrook on 2/13/13.
//  Copyright (c) 2013 Claybrook Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCPixelArt-Swift.h"
#import "Schematic.h"
#import "WoolImage.h"

@interface MCImageProcessor : NSObject

@property (nonatomic, strong, readonly) id<MCColorTransformer> colorTransformer;

- (instancetype)initWithColorTransformer:(id<MCColorTransformer>)transformer;

- (WoolImage *)processImage:(id<MCImage>)image size:(CGSize)size;

@end
