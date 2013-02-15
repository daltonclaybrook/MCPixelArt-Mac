//
//  MCWoolColors.h
//  MCPixelArt
//
//  Created by Dalton Claybrook on 2/13/13.
//  Copyright (c) 2013 Claybrook Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCWoolColors : NSObject

@property (nonatomic, strong, readonly) NSArray *colorsArray;
@property (nonatomic, strong) NSMutableArray *woolIndeces;

- (NSColor *)woolColorFromTrueColor:(NSColor *)color;

@end
