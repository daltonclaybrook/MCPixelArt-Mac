//
//  MCWoolColors.m
//  MCPixelArt
//
//  Created by Dalton Claybrook on 2/13/13.
//  Copyright (c) 2013 Claybrook Software, LLC. All rights reserved.
//

#import "MCWoolColors.h"

@implementation MCWoolColors

@synthesize woolArray = _woolArray;

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
    }
    return self;
}

- (NSUInteger)woolIndexFromTrueColor:(NSColor *)color {
    CGFloat average = MAXFLOAT;
    NSUInteger closestIndex = 0;
    
    for (int i=0; i<self.woolArray.count; i++) {
        NSColor *woolColor = [self.woolArray objectAtIndex:i];
        CGFloat redDif = fabsf(woolColor.redComponent-color.redComponent);
        CGFloat greenDif = fabsf(woolColor.greenComponent-color.greenComponent);
        CGFloat blueDif = fabsf(woolColor.blueComponent-color.blueComponent);
        CGFloat newAvg = (redDif + greenDif + blueDif)/3.0f;
        if (newAvg<average) {
            average = newAvg;
            closestIndex = i;
        }
    }

    return closestIndex;
}

@end
