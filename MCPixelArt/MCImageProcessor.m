//
//  ImageLogic.m
//  MCPixelArt
//
//  Created by Dalton Claybrook on 2/13/13.
//  Copyright (c) 2013 Claybrook Software, LLC. All rights reserved.
//

#import "MCImageProcessor.h"
#import "MCWoolColors.h"

@implementation MCImageProcessor

- (instancetype)initWithColorTransformer:(id<MCColorTransformer>)transformer
{
    self = [super init];
    if (self)
    {
        _colorTransformer = transformer;
    }
    return self;
}

- (WoolImage *)processImage:(id<MCImage>)image size:(CGSize)size
{
    CGImageRef cgImage = [image toCGImage];
    CGContextRef context = [self createARGBBitmapContextFromSize:size];
    if (context == NULL) return nil;
    
    CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), cgImage);
    
    unsigned char *data = CGBitmapContextGetData(context);
    NSMutableArray *woolIndeces = [NSMutableArray array];
    CGContextRelease(context);
    
    if (data != NULL) {
        BOOL leftToRight = YES;
        for (int y=0; y<size.height; y++) {
            for (int x=0; x<size.width; x++) {
                int modX = (leftToRight) ? x : (int)(size.width-(x+1));
                int constant = (leftToRight) ? 1 : -1;
                
                int index = [MCImageProcessor indexFromPoint:CGPointMake(x, y) size:size];
                NSColor *oldColor = [NSColor colorWithCalibratedRed:data[index+1]/255.0 green:data[index+2]/255.0 blue:data[index+3]/255.0 alpha:data[index]/255.0];
                NSUInteger woolIndex = [self.woolColors woolIndexFromTrueColor:oldColor];
                NSColor *newColor = [self.woolColors.woolArray objectAtIndex:woolIndex];
                [woolIndeces addObject:[NSNumber numberWithInteger:woolIndex]];
                data[index] = 255;
                data[index+1] = (int)(newColor.redComponent * 255.0);
                data[index+2] = (int)(newColor.greenComponent * 255.0);
                data[index+3] = (int)(newColor.blueComponent * 255.0);
                
                
                int quantError[] = {
                    oldColor.redComponent-newColor.redComponent,
                    oldColor.greenComponent-newColor.greenComponent,
                    oldColor.blueComponent-newColor.blueComponent
                };
                
                int ditherIndeces[] = {
                    [MCImageProcessor indexFromPoint:CGPointMake(modX+constant, y) size:size],
                    [MCImageProcessor indexFromPoint:CGPointMake(modX+(constant*2), y+1) size:size],
                    [MCImageProcessor indexFromPoint:CGPointMake(modX-constant, y+1) size:size],
                    [MCImageProcessor indexFromPoint:CGPointMake(modX, y+1) size:size],
                    [MCImageProcessor indexFromPoint:CGPointMake(modX+constant, y+1) size:size],
                    [MCImageProcessor indexFromPoint:CGPointMake(modX, y+2) size:size]
                };
                
                for (int i=0; i<6; i++) {
                    if (ditherIndeces[i] != -1) {
                        data[ditherIndeces[i]+1] += (int)(1.0f/8.0f * (float)quantError[0]);
                        data[ditherIndeces[i]+2] += (int)(1.0f/8.0f * (float)quantError[1]);
                        data[ditherIndeces[i]+3] += (int)(1.0f/8.0f * (float)quantError[2]);
                    }
                }
            }
        }
    } else {
        return nil;
    }
    
    for (int i=0; i<floorf((woolIndeces.count/2.0)); i++) {
        //Reverse array
        [woolIndeces exchangeObjectAtIndex:i withObjectAtIndex:woolIndeces.count-1-i];
    }
    
    WoolImage *newImage = [self createImageFromArray:data andRect:NSMakeRect(0, 0, size.width, size.height)];
    [newImage setWoolData:woolIndeces];
    free(data);
    
    return newImage;
}

- (CGContextRef)createARGBBitmapContextFromSize:(NSSize)size {
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    void *bitmapData;
    unsigned long bitmapByteCount;
    unsigned long bitmapBytesPerRow;
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow = (size.width * 4);
    bitmapByteCount = (bitmapBytesPerRow * size.height);
    
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
                                     size.width,
                                     size.height,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst);
    if (context == NULL) free (bitmapData);
    
    // Make sure and release colorspace before returning
    CGColorSpaceRelease(colorSpace);
    
    return context;
}

-(WoolImage *)createImageFromArray:(unsigned char *)myBuffer andRect:(CGRect)rect {
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
    WoolImage *newImage = [[WoolImage alloc] initWithCGImage:cgImage size:NSMakeSize(sizeRect.size.width, sizeRect.size.height)];
    
    CFRelease(cgImage);
    CFRelease(bitmapContext);
    free(rgba);
    
    return newImage;
}

+ (int)indexFromPoint:(CGPoint)point size:(NSSize)size {
    if ((point.x < 0) || (point.x >= size.width) || (point.y < 0) || (point.y >= size.height)) return -1;
    return (point.y * size.width + point.x) * 4 /*a-r-g-b*/;
}

@end
