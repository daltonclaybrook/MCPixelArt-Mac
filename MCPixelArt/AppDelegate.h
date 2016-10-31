//
//  AppDelegate.h
//  MCPixelArt
//
//  Created by Dalton Claybrook on 2/13/13.
//  Copyright (c) 2013 Claybrook Software, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#import "MCPixelArt-Swift.h"
#import "PixelationView.h"
#import "MCSchematic.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSTextFieldDelegate, NSOpenSavePanelDelegate>

@property (nonatomic, strong) MCMacImageProcessor *imageLogic;
@property (nonatomic, strong) MCSchematic *schematic;
@property (assign) IBOutlet NSWindow *window;
@property (unsafe_unretained) IBOutlet NSTextField *sizeField;
@property (unsafe_unretained) IBOutlet NSSlider *slider;
@property (unsafe_unretained) IBOutlet NSButton *previewButton;
@property (strong) IBOutlet NSTextField *dropImageLabel;
@property (unsafe_unretained) IBOutlet NSProgressIndicator *loadingSpinner;

@property (unsafe_unretained) IBOutlet NSPanel *previewImagePanel;
@property (nonatomic, strong) IBOutlet PixelationView *previewImageView;
@property (unsafe_unretained) IBOutlet NSButton *airCheckBox;
@property (nonatomic, strong) MCWoolImage *woolImage;

- (IBAction)imageChanged:(id)sender;
- (IBAction)sliderChanged:(id)sender;
- (IBAction)preview:(id)sender;
- (IBAction)saveSchematic:(id)sender;

@end
