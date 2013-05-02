//
//  PixelationView.m
//  MCPixelArt
//
//  Created by Dalton Claybrook on 2/15/13.
//  Copyright (c) 2013 Claybrook Software, LLC. All rights reserved.
//

#import "PixelationView.h"

//static CGFloat acceptibleDif = 0.001f;

@interface PixelationView ()

- (BOOL)validateFrame:(NSRect)frame;

@end

@implementation PixelationView

- (void)awakeFromNib {
    [self setImageScaling:NSScaleToFit];
}

- (void)setImage:(NSImage *)newImage {
    [super setImage:newImage];
    
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
}

- (void)setFrame:(NSRect)frameRect {
    if ([self validateFrame:frameRect]) {
        [super setFrame:frameRect];
    }
}

- (void)drawRect:(NSRect)dirtyRect {
    [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationNone];
    [[NSGraphicsContext currentContext] setShouldAntialias:NO];
    
    [super drawRect:dirtyRect];
}

#pragma mark Private Methods

- (BOOL)validateFrame:(NSRect)frame {
    //For some reason, the animation that occurs when you save a schematic
    //causes the frame to be reset to its value in MainMenu.xib, thus, this
    //method exists. If you know why and fix it, submit a pull request.
    
    if (self.image == nil) return YES;
    CGFloat difference = fabsf((self.image.size.width/self.image.size.height) - (frame.size.width/frame.size.height));
    //if ((self.image.size.width/self.image.size.height) == (frame.size.width/frame.size.height)) {
    NSLog(@"dif: %f", difference);
    if (difference < 0.001) {
        return YES;
    }
    return NO;
}

@end
