//
//  PixelationView.m
//  MCPixelArt
//
//  Created by Dalton Claybrook on 2/15/13.
//  Copyright (c) 2013 Claybrook Software, LLC. All rights reserved.
//

#import "PixelationView.h"

@implementation PixelationView

- (void)awakeFromNib {
    [self setImageScaling:NSScaleToFit];
}

- (void)setImage:(NSImage *)newImage {
    CGFloat bottomPadding = 20.5f;
    NSSize newSize;
    if (newImage.size.width/newImage.size.height >= 634.0f/470.0f) {
        //Width is greater than ratio
        newSize = NSMakeSize(634.0f, (newImage.size.height * 634.0f/newImage.size.width));
    } else {
        newSize = NSMakeSize((newImage.size.width * 470.0f/newImage.size.height), 470.0f);
    }
    NSRect superBounds = [self.superview bounds];
    NSPoint newOrigin = NSMakePoint((superBounds.size.width-newSize.width)/2.0, (superBounds.size.height-newSize.height)/2.0+bottomPadding);
    
    [self setFrame:NSMakeRect(newOrigin.x, newOrigin.y, newSize.width, newSize.height)];
    
    [super setImage:newImage];
}

- (void)drawRect:(NSRect)dirtyRect {
    [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationNone];
    [[NSGraphicsContext currentContext] setShouldAntialias:NO];
    
    [super drawRect:dirtyRect];
}

@end
