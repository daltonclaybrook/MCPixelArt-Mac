//
//  AppDelegate.m
//  MCPixelArt
//
//  Created by Dalton Claybrook on 2/13/13.
//  Copyright (c) 2013 Claybrook Software, LLC. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize imageLogic = _imageLogic, window = _window, sizeField = _sizeField, slider = _slider;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self.slider setMinValue:0.0];
    [self.slider setMaxValue:0.0];
    self.slider.floatValue = 0.0f;
    [self.slider sendActionOn:NSLeftMouseDraggedMask];
    
    if (self.imageLogic == nil) {
        self.imageLogic = [[ImageLogic alloc] init];
    }
    
    //Schematic *schematic = [[Schematic alloc] init];
}

- (IBAction)imageChanged:(id)sender {
    [self.imageLogic setImage:[(NSImageView *)sender image]];
    [self.slider setMinValue:10.0];
    [self.slider setMaxValue:self.imageLogic.image.size.width];
}

- (IBAction)create:(id)sender {
    NSImage *newImage = [self.imageLogic processImageWithSize:CGSizeMake((int)self.slider.floatValue, (int)(self.slider.floatValue/self.imageLogic.aspectRatio))];
    [self.finalWell setImage:newImage];
}

- (IBAction)sliderChanged:(id)sender {
    [self.sizeField setStringValue:[NSString stringWithFormat:@"%i x %i", (int)self.slider.floatValue, (int)(self.slider.floatValue/self.imageLogic.aspectRatio)]];
}

@end
