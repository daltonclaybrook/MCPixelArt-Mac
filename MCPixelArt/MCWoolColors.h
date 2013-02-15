//
//  MCWoolColors.h
//  MCPixelArt
//
//  Created by Dalton Claybrook on 2/13/13.
//  Copyright (c) 2013 Claybrook Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCWoolColors : NSObject

@property (nonatomic, strong, readonly) NSArray *woolArray;

- (NSUInteger)woolIndexFromTrueColor:(NSColor *)color;

@end
