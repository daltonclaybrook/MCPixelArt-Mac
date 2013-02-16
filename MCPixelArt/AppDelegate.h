//
//  AppDelegate.h
//  MCPixelArt
//
//  Created by Dalton Claybrook on 2/13/13.
//  Copyright (c) 2013 Claybrook Software, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#import "ImageLogic.h"
#import "PixelationView.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSTextFieldDelegate, NSOpenSavePanelDelegate>

@property (nonatomic, strong) ImageLogic *imageLogic;
@property (nonatomic, strong) Schematic *schematic;
@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *sizeField;
@property (weak) IBOutlet NSSlider *slider;
@property (weak) IBOutlet NSButton *previewButton;
@property (weak) IBOutlet NSTextField *dropImageLabel;
@property (weak) IBOutlet NSProgressIndicator *loadingSpinner;

@property (weak) IBOutlet NSPanel *previewImagePanel;
@property (nonatomic, strong) IBOutlet PixelationView *previewImageView;
@property (weak) IBOutlet NSButton *airCheckBox;
@property (nonatomic, strong) WoolImage *woolImage;

- (IBAction)imageChanged:(id)sender;
- (IBAction)sliderChanged:(id)sender;
- (IBAction)preview:(id)sender;
- (IBAction)saveSchematic:(id)sender;

@end
