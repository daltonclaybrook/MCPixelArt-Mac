//
//  AppDelegate.h
//  MCPixelArt
//
//  Created by Dalton Claybrook on 2/13/13.
//  Copyright (c) 2013 Claybrook Software, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ImageLogic.h"
#import "Schematic.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSTextFieldDelegate>

@property (nonatomic, strong) ImageLogic *imageLogic;
@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *sizeField;
@property (weak) IBOutlet NSSlider *slider;

@property (weak) IBOutlet NSImageView *finalWell;

- (IBAction)imageChanged:(id)sender;
- (IBAction)sliderChanged:(id)sender;
- (IBAction)create:(id)sender;

@end
