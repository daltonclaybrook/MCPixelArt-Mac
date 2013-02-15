//
//  ImageLogic.m
//  MCPixelArt
//
//  Created by Dalton Claybrook on 2/13/13.
//  Copyright (c) 2013 Claybrook Software, LLC. All rights reserved.
//

#import "ImageLogic.h"
#import "MCWoolColors.h"

@interface ImageLogic ()

@property (nonatomic, strong) MCWoolColors *woolColors;

- (CGContextRef)createARGBBitmapContextFromImage:(CGImageRef)inImage;
-(NSImage *)createImageFromArray:(unsigned char *)myBuffer andRect:(CGRect)rect;

@end

@implementation ImageLogic

@synthesize image = _image, aspectRatio = _aspectRatio, woolColors = _woolColors;

- (id)init {
    self = [super init];
    if (self) {
        _woolColors = [[MCWoolColors alloc] init];
    }
    return self;
}

- (void)setImage:(NSImage *)image {
    _image = image;
    _aspectRatio = image.size.width/image.size.height;
}

- (NSImage *)processImageWithSize:(CGSize)size {
    [self.image setScalesWhenResized:YES];
    
    NSImage *smallImage = [[NSImage alloc] initWithSize:NSSizeFromCGSize(size)];
    [smallImage lockFocus];
    [self.image setSize:NSSizeFromCGSize(size)];
    [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
    [self.image compositeToPoint:NSZeroPoint operation:NSCompositeCopy];
    [smallImage unlockFocus];
    
    // create the image somehow, load from file, draw into it...
    CGImageSourceRef source;
    
    source = CGImageSourceCreateWithData((__bridge CFDataRef)[smallImage TIFFRepresentation], NULL);
    CGImageRef cgImage =  CGImageSourceCreateImageAtIndex(source, 0, NULL);
    
    CGContextRef context = [self createARGBBitmapContextFromImage:cgImage];
    if (context == NULL) return nil;
    
    size_t width = CGImageGetWidth(cgImage);
    size_t height = CGImageGetHeight(cgImage);
    CGRect rect = CGRectMake(0, 0, width, height);
    
    CGContextDrawImage(context, rect, cgImage);
    
    unsigned char *data = CGBitmapContextGetData(context);
    unsigned char *newData = (unsigned char *)malloc(width*height*4);
    CGContextRelease(context);
    
    if (data != NULL) {
        for (int i=0; i<width*height*4; i+=4) {
            NSColor *oldColor = [NSColor colorWithCalibratedRed:data[i+1]/255.0 green:data[i+2]/255.0 blue:data[i+3]/255.0 alpha:data[i]/255.0];
            NSColor *newColor = [self.woolColors woolColorFromTrueColor:oldColor];
            newData[i] = 255;
            newData[i+1] = (int)(newColor.redComponent * 255.0);
            newData[i+2] = (int)(newColor.greenComponent * 255.0);
            newData[i+3] = (int)(newColor.blueComponent * 255.0);
        }
        free(data);
    }
    
    Schematic *schematic = [[Schematic alloc] init];
    [schematic createSchematicWithIndeces:self.woolColors.woolIndeces andSize:CGSizeMake(width, height)];
    
    NSImage *newImage = [self createImageFromArray:newData andRect:NSMakeRect(0, 0, width, height)];
    free(newData);
    
    return newImage;
}

- (CGContextRef)createARGBBitmapContextFromImage:(CGImageRef)inImage {
    
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    void *bitmapData;
    unsigned long bitmapByteCount;
    unsigned long bitmapBytesPerRow;
    
    // Get image width, height. We'll use the entire image.
    size_t width = CGImageGetWidth(inImage);
    size_t height = CGImageGetHeight(inImage);
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow = (width * 4);
    bitmapByteCount = (bitmapBytesPerRow * height);
    
    // Use the generic RGB color space.
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL) return NULL;
    
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        CGColorSpaceRelease(colorSpace);
        return NULL;
    }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (bitmapData,
                                     width,
                                     height,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst);
    if (context == NULL) free (bitmapData);
    
    // Make sure and release colorspace before returning
    CGColorSpaceRelease(colorSpace);
    
    return context;
}

-(NSImage *)createImageFromArray:(unsigned char *)myBuffer andRect:(CGRect)rect {
    char* rgba = (char*)malloc(rect.size.width*rect.size.height*4);
    for(int i=0; i < rect.size.width*rect.size.height; ++i) {
        rgba[4*i] = myBuffer[4*i];
        rgba[4*i+1] = myBuffer[4*i+1];
        rgba[4*i+2] = myBuffer[4*i+2];
        rgba[4*i+3] = myBuffer[4*i+3];
    }
    //CGColorSpaceCreateDe
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapContext = CGBitmapContextCreate(
                                                       rgba,
                                                       rect.size.width,
                                                       rect.size.height,
                                                       8, // bitsPerComponent
                                                       4*rect.size.width, // bytesPerRow
                                                       colorSpace,
                                                       kCGImageAlphaNoneSkipFirst);
    
    CFRelease(colorSpace);
    
    CGImageRef cgImage = CGBitmapContextCreateImage(bitmapContext);
    NSRect sizeRect = NSRectFromCGRect(rect);
    NSImage *newImage = [[NSImage alloc] initWithCGImage:cgImage size:NSMakeSize(sizeRect.size.width, sizeRect.size.height)];
    
    CFRelease(cgImage);
    CFRelease(bitmapContext);
    free(rgba);
    
    return newImage;
}

@end
