//
//  AppDelegate.m
//  MCPixelArt
//
//  Created by Dalton Claybrook on 2/13/13.
//  Copyright (c) 2013 Claybrook Software, LLC. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

- (void)animateMessage:(NSString *)message;

@end

@implementation AppDelegate

@synthesize imageLogic = _imageLogic, schematic = _schematic, window = _window, sizeField = _sizeField, slider = _slider, previewButton = _previewButton, dropImageLabel = _dropImageLabel, loadingSpinner = _loadingSpinner, previewImagePanel = _previewImagePanel, previewImageView = _previewImageView, airCheckBox = _airCheckBox, woolImage = _woolImage;

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

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}

- (IBAction)imageChanged:(id)sender {
    if (self.dropImageLabel.superview) [self.dropImageLabel removeFromSuperview];
    [self.imageLogic setImage:[(NSImageView *)sender image]];
    [self.previewButton setEnabled:YES];
    [self.slider setMinValue:10.0];
    [self.slider setFloatValue:10.0];
    [self sliderChanged:self.slider];
    [self.slider setMaxValue:self.imageLogic.image.size.width];
}

- (IBAction)preview:(id)sender {
    [self.loadingSpinner startAnimation:self];
    [self.previewButton setEnabled:NO];
    
    dispatch_async (dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        self.woolImage = [self.imageLogic processImageWithSize:CGSizeMake((int)self.slider.floatValue, (int)(self.slider.floatValue/self.imageLogic.aspectRatio))];
        
        dispatch_async (dispatch_get_main_queue (), ^(void) {
            [self.loadingSpinner stopAnimation:self];
            [self.previewButton setEnabled:YES];
            
            NSArray *screenArray = [NSScreen screens];
            NSScreen *screen = [screenArray objectAtIndex:0];
            NSSize screenSize = screen.visibleFrame.size;
            
            if (!self.previewImagePanel.isVisible) {
                [self.previewImagePanel setFrameOrigin:NSMakePoint((screenSize.width-self.previewImagePanel.frame.size.width)/2.0f, screenSize.height-self.previewImagePanel.frame.size.height)];
            }
            [self.airCheckBox setState:0];
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

#pragma mark Private Methods

- (void)animateMessage:(NSString *)message {
    NSView *successView = [[NSView alloc] initWithFrame:NSMakeRect((self.previewImagePanel.frame.size.width-200.0f)/2.0f, (self.previewImagePanel.frame.size.height-200.0f)/2.0f, 200.0f, 200.0f)];
    [successView setWantsLayer:YES];
    [successView.layer setBackgroundColor:[[NSColor colorWithCalibratedWhite:0.0f alpha:0.6f] CGColor]];
    [successView.layer setCornerRadius:20.0f];
    [successView setAlphaValue:0.0f];
    
    CATextLayer *successText = [CATextLayer layer];
    successText.string = message;
    successText.font = (__bridge CFTypeRef)([NSFont boldSystemFontOfSize:20.0f]);
    [successText setFrame:CGRectMake(0, 0, 200.0f, 44)];
    [successText setPosition:CGPointMake(successView.frame.size.width/2.0f, successView.frame.size.height/2.0f)];
    successText.alignmentMode = kCAAlignmentCenter;
    [successView.layer addSublayer:successText];
    
    [self.previewImagePanel.contentView addSubview:successView];
    
    CGFloat animationDuration = 0.4f;
    CGFloat animationYOffset = 10.0f;
    
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setCompletionHandler:^{
        [NSAnimationContext beginGrouping];
        [[NSAnimationContext currentContext] setCompletionHandler:^{
            [NSAnimationContext beginGrouping];
            [[NSAnimationContext currentContext] setCompletionHandler:^{
                [successView removeFromSuperview];
            }];
            [[successView animator] setAlphaValue:0.0f];
            [NSAnimationContext endGrouping];
        }];
        
        [[NSAnimationContext currentContext] setDuration:animationDuration];
        [[NSAnimationContext currentContext] setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [[successView animator] setFrame:NSMakeRect(successView.frame.origin.x, successView.frame.origin.y+animationYOffset, successView.frame.size.width, successView.frame.size.height)];
        [NSAnimationContext endGrouping];
    }];
    
    [[NSAnimationContext currentContext] setDuration:animationDuration];
    [[NSAnimationContext currentContext] setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [[successView animator] setFrame:NSMakeRect(successView.frame.origin.x, successView.frame.origin.y+animationYOffset, successView.frame.size.width, successView.frame.size.height)];
    [[successView animator] setAlphaValue:1.0f];
    [NSAnimationContext endGrouping];
}

#pragma mark NSOpenSavePanelDelegate Methods

- (BOOL)panel:(id)sender validateURL:(NSURL *)url error:(NSError **)outError {
    if (url) {
        NSData *data = [self.schematic createSchematicWithIndeces:self.woolImage.woolData andSize:CGSizeMake(self.woolImage.size.width, self.woolImage.size.height) replacingWhiteWool:self.airCheckBox.state];
        if (data) {
            if ([data writeToURL:url atomically:NO]) {
                [self animateMessage:@"Success"];
            } else {
                [self animateMessage:@"Failure"];
            }
        } else {
            [self animateMessage:@"Failure"];
        }
        return YES;
    } else {
        return NO;
    }
}

@end
