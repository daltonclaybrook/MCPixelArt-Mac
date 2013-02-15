//
//  AppDelegate.h
//  MCPixelArt
//
//  Created by Dalton Claybrook on 2/13/13.
//  Copyright (c) 2013 Claybrook Software, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ImageLogic.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSTextFieldDelegate, NSOpenSavePanelDelegate>

@property (nonatomic, strong) ImageLogic *imageLogic;
@property (nonatomic, strong) Schematic *schematic;
@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *sizeField;
@property (weak) IBOutlet NSSlider *slider;

@property (weak) IBOutlet NSPanel *previewImagePanel;
@property (weak) IBOutlet NSImageView *previewImageView;
@property (nonatomic, strong) WoolImage *woolImage;

- (IBAction)imageChanged:(id)sender;
- (IBAction)sliderChanged:(id)sender;
- (IBAction)create:(id)sender;
- (IBAction)saveSchematic:(id)sender;

@end
