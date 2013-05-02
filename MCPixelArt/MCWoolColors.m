//
//  MCWoolColors.m
//  MCPixelArt
//
//  Created by Dalton Claybrook on 2/13/13.
//  Copyright (c) 2013 Claybrook Software, LLC. All rights reserved.
//

#import "MCWoolColors.h"

@interface MCWoolColors ()

@property (nonatomic, strong) NSColorSpace *labColorSpace;

- (CGColorSpaceRef)labCGColorSpace;
- (CGFloat)oldCompare:(NSColor *)color1 toColor:(NSColor *)color2;
- (CGFloat)compare:(NSColor *)color1 toColor:(NSColor *)color2;
- (CGFloat)hsbCompare:(NSColor *)color1 toColor:(NSColor *)color2;
- (CGFloat)cmykCompare:(NSColor *)color1 toColor:(NSColor *)color2;

@end

@implementation MCWoolColors

@synthesize woolArray = _woolArray, labColorSpace = _labColorSpace;

- (id)init {
    self = [super init];
    if (self) {
        _woolArray = [[NSArray alloc] initWithObjects:
                        [NSColor colorWithCalibratedRed:221.0f/255.0f  green:221.0f/255.0f  blue:221.0f/255.0f  alpha:1.0f],    //White         0
                        [NSColor colorWithCalibratedRed:219.0f/255.0f green:125.0f/255.0f blue:62.0f/255.0f alpha:1.0f],        //Orange        1
                        [NSColor colorWithCalibratedRed:179.0f/255.0f green:80.0f/255.0f blue:188.0f/255.0f alpha:1.0f],        //Magenta       2
                        [NSColor colorWithCalibratedRed:107.0f/255.0f green:138.0f/255.0f blue:39.0f/255.0f alpha:1.0f],        //Light Blue    3
                        [NSColor colorWithCalibratedRed:177.0f/255.0f green:166.0f/255.0f blue:39.0f/255.0f alpha:1.0f],        //Yellow        4
                        [NSColor colorWithCalibratedRed:65.0f/255.0f green:174.0f/255.0f blue:56.0f/255.0f alpha:1.0f],         //Lime          5
                        [NSColor colorWithCalibratedRed:208.0f/255.0f green:132.0f/255.0f blue:153.0f/255.0f alpha:1.0f],       //Pink          6
                        [NSColor colorWithCalibratedRed:64.0f/255.0f green:64.0f/255.0f blue:64.0f/255.0f alpha:1.0f],          //Gray          7
                        [NSColor colorWithCalibratedRed:154.0f/255.0f green:161.0f/255.0f blue:161.0f/255.0f alpha:1.0f],       //Light Gray    8
                        [NSColor colorWithCalibratedRed:46.0f/255.0f green:110.0f/255.0f blue:137.0f/255.0f alpha:1.0f],        //Cyan          9
                        [NSColor colorWithCalibratedRed:126.0f/255.0f green:61.0f/255.0f blue:181.0f/255.0f alpha:1.0f],        //Purple        10
                        [NSColor colorWithCalibratedRed:46.0f/255.0f green:56.0f/255.0f blue:141.0f/255.0f alpha:1.0f],         //Blue          11
                        [NSColor colorWithCalibratedRed:79.0f/255.0f green:50.0f/255.0f blue:31.0f/255.0f alpha:1.0f],          //Brown         12
                        [NSColor colorWithCalibratedRed:53.0f/255.0f green:70.0f/255.0f blue:27.0f/255.0f alpha:1.0f],          //Green         13
                        [NSColor colorWithCalibratedRed:150.0f/255.0f green:52.0f/255.0f blue:48.0f/255.0f alpha:1.0f],         //Red           14
                        [NSColor colorWithCalibratedRed:25.0f/255.0f green:22.0f/255.0f blue:22.0f/255.0f alpha:1.0f],          //Black         15
                        nil];
        CGColorSpaceRef labCGColorSpace = [self labCGColorSpace];
        _labColorSpace = [[NSColorSpace alloc] initWithCGColorSpace:labCGColorSpace];
        CGColorSpaceRelease(labCGColorSpace);
    }
    return self;
}

- (NSUInteger)woolIndexFromTrueColor:(NSColor *)color {
    CGFloat average = MAXFLOAT;
    NSUInteger closestIndex = 0;
    if (color.alphaComponent < 1.0f) return 0; //White Wool
    
    for (int i=0; i<self.woolArray.count; i++) {
        NSColor *woolColor = [self.woolArray objectAtIndex:i];
#if 1
//        CGFloat redDif = fabsf(woolColor.redComponent-color.redComponent);
//        CGFloat greenDif = fabsf(woolColor.greenComponent-color.greenComponent);
//        CGFloat blueDif = fabsf(woolColor.blueComponent-color.blueComponent);
//        CGFloat newAvg = (redDif + greenDif + blueDif)/3.0f;
        
        //CGFloat newAvg = [self oldCompare:woolColor toColor:color];
        //CGFloat newAvg = [self hsbCompare:woolColor toColor:color];
        CGFloat newAvg = [self cmykCompare:woolColor toColor:color];
#else
        CGFloat newAvg = [self compare:woolColor toColor:color];
#endif
        if (newAvg<average) {
            average = newAvg;
            closestIndex = i;
        }
    }

    return closestIndex;
}

#pragma mark Private Methods

- (CGColorSpaceRef)labCGColorSpace {
    const CGFloat whitePoint[3] = {0.9642, 1.0, 0.8249};
    const CGFloat blackPoint[3] = {0.0, 0.0, 0.0};
    const CGFloat range[4] = {-128.0, 128.0, -128.0, 128.0};
    CGColorSpaceRef labColorSpace = CGColorSpaceCreateLab (whitePoint, blackPoint, range);
    return labColorSpace;
}

- (CGFloat)oldCompare:(NSColor *)color1 toColor:(NSColor *)color2 {
    CGFloat difference = sqrtf(powf((color2.redComponent-color1.redComponent), 2.0f) + powf((color2.greenComponent-color1.greenComponent), 2.0f) + powf((color2.blueComponent-color1.blueComponent), 2.0f));
    return difference;
}

- (CGFloat)compare:(NSColor *)color1 toColor:(NSColor *)color2 {
    //CGColorSpaceRef labCGColorSpace = [self labColorSpace];
    //NSColorSpace *labColorSpace = [[NSColorSpace alloc] initWithCGColorSpace:labCGColorSpace];
    CGColorRef labColor1 = [color1 colorUsingColorSpace:self.labColorSpace].CGColor;
    CGColorRef labColor2 = [color2 colorUsingColorSpace:self.labColorSpace].CGColor;
    const CGFloat *color1Components = CGColorGetComponents(labColor1);
    const CGFloat *color2Components = CGColorGetComponents(labColor2);
    
    CGFloat difference = sqrtf(powf((color2Components[0]-color1Components[0]), 2.0f) + powf((color2Components[1]-color1Components[1]), 2.0f) + powf((color2Components[2]-color1Components[2]), 2.0f));
    //CGColorSpaceRelease(labCGColorSpace);
    
    return difference;
}

- (CGFloat)hsbCompare:(NSColor *)color1 toColor:(NSColor *)color2 {
    CGFloat difference = sqrtf(powf((color2.hueComponent-color1.hueComponent), 2.0f) + powf((color2.saturationComponent-color1.saturationComponent), 2.0f) + powf((color2.brightnessComponent-color1.brightnessComponent), 2.0f));
    return difference;
}

- (CGFloat)cmykCompare:(NSColor *)color1 toColor:(NSColor *)color2 {
    NSColor *cmykColor1 = [color1 colorUsingColorSpace:[NSColorSpace genericCMYKColorSpace]];
    NSColor *cmykColor2 = [color2 colorUsingColorSpace:[NSColorSpace genericCMYKColorSpace]];
    
    CGFloat difference = sqrtf(powf((cmykColor2.cyanComponent-cmykColor1.cyanComponent), 2.0f) + powf((cmykColor2.magentaComponent-cmykColor1.magentaComponent), 2.0f) + powf((cmykColor2.yellowComponent-cmykColor1.yellowComponent), 2.0f) + powf((cmykColor2.blackComponent-cmykColor1.blackComponent), 2.0f));
    return difference;
}

@end
