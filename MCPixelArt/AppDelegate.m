//
//  AppDelegate.m
//  MCPixelArt
//
//  Created by Dalton Claybrook on 2/13/13.
//  Copyright (c) 2013 Claybrook Software, LLC. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize imageLogic = _imageLogic, schematic = _schematic, window = _window, sizeField = _sizeField, slider = _slider, previewImagePanel = _previewImagePanel, woolImage = _woolImage;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self.slider setMinValue:0.0];
    [self.slider setMaxValue:0.0];
    self.slider.floatValue = 0.0f;
    [self.slider sendActionOn:NSLeftMouseDraggedMask];
    
    if (self.imageLogic == nil) {
        self.imageLogic = [[ImageLogic alloc] init];
    }
    if (self.schematic == nil) {
        self.schematic = [[Schematic alloc] init];
    }
}

- (IBAction)imageChanged:(id)sender {
    [self.imageLogic setImage:[(NSImageView *)sender image]];
    [self.slider setMinValue:10.0];
    [self.slider setDoubleValue:10.0];
    [self.slider setMaxValue:self.imageLogic.image.size.width];
}

- (IBAction)create:(id)sender {
    dispatch_async (dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        self.woolImage = [self.imageLogic processImageWithSize:CGSizeMake((int)self.slider.floatValue, (int)(self.slider.floatValue/self.imageLogic.aspectRatio))];
        
        dispatch_async (dispatch_get_main_queue (), ^(void) {
            NSArray *screenArray = [NSScreen screens];
            NSScreen *screen = [screenArray objectAtIndex:0];
            NSSize screenSize = screen.visibleFrame.size;
            
            [self.previewImagePanel setFrameOrigin:NSMakePoint((screenSize.width-self.previewImagePanel.frame.size.width)/2.0f, (screenSize.height/2.0f))];
            [self.previewImagePanel makeKeyAndOrderFront:self];
            [self.previewImageView setImage:(NSImage *)[self woolImage]];
        });
    });
}

- (IBAction)sliderChanged:(id)sender {
    [self.sizeField setStringValue:[NSString stringWithFormat:@"%i x %i", (int)self.slider.floatValue, (int)(self.slider.floatValue/self.imageLogic.aspectRatio)]];
}

- (IBAction)saveSchematic:(id)sender {
    NSSavePanel *savePanel = [[NSSavePanel alloc] init];
    [savePanel setAllowedFileTypes:[NSArray arrayWithObject:@"schematic"]];
    [savePanel setTitle:@"Save Schematic"];
    [savePanel setDelegate:self];
    
    [savePanel runModal];
}

#pragma mark NSOpenSavePanelDelegate Methods

- (BOOL)panel:(id)sender validateURL:(NSURL *)url error:(NSError **)outError {
    if (url) {
        NSData *data = [self.schematic createSchematicWithIndeces:self.woolImage.woolData andSize:CGSizeMake(self.woolImage.size.width, self.woolImage.size.height)];
        if (data) {
            [data writeToURL:url atomically:NO];
        }
        return YES;
    } else {
        return NO;
    }
}

@end
