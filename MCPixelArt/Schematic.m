//
//  Schematic.m
//  MCPixelArt
//
//  Created by Dalton Claybrook on 2/13/13.
//  Copyright (c) 2013 Claybrook Software, LLC. All rights reserved.
//

#import "Schematic.h"

@interface Schematic ()

@property (nonatomic, strong) NSDictionary *masterCompound;
@property (nonatomic) unsigned long bytesConsumed;

- (NSDictionary *)createMasterCompoundFromData:(NSData *)data;
- (id)readFirstObject:(NSData *)data andTag:(BOOL)readTag orTagID:(int8_t)tagID;
- (NSString *)readFirstString:(NSData *)data;
- (NSArray *)processListData:(NSData *)data atIndex:(unsigned long)index;
- (NSDictionary *)processCompoundData:(NSData *)data atIndex:(unsigned long)index;

@end

@implementation Schematic

@synthesize schemData = _schemData, masterCompound = _masterCompound, bytesConsumed = _bytesConsumed;

- (NSData *)createSchematicWithIndeces:(NSArray *)wool andSize:(CGSize)size replacingWhiteWool:(BOOL)replace {    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSString *elementName = nil;
    int16_t nameLength = 0;
    int8_t tag = 0;
    int32_t listLength = 0;
    int32_t byteLength = 0;
    NSEnumerator *woolEnum = [wool objectEnumerator];
    
    //Main Compound
    tag = TAG_Compound;
    elementName = @"Schematic";
    nameLength = elementName.length;
    nameLength = CFSwapInt16HostToBig(nameLength);
    [data appendBytes:&tag length:1];
    [data appendBytes:&nameLength length:2];
    [data appendData:[elementName dataUsingEncoding:NSUTF8StringEncoding]];
    
    //Height short
    tag = TAG_Short;
    elementName = @"Height";
    nameLength = elementName.length;
    nameLength = CFSwapInt16HostToBig(nameLength);
    [data appendBytes:&tag length:1];
    [data appendBytes:&nameLength length:2];
    [data appendData:[elementName dataUsingEncoding:NSUTF8StringEncoding]];
    int16_t height = (int16_t)size.height;
    NSLog(@"height: %i", height);
    height = CFSwapInt16HostToBig(height);
    [data appendBytes:&height length:2];
    
    //Length short
    elementName = @"Length";
    nameLength = elementName.length;
    nameLength = CFSwapInt16HostToBig(nameLength);
    [data appendBytes:&tag length:1];
    [data appendBytes:&nameLength length:2];
    [data appendData:[elementName dataUsingEncoding:NSUTF8StringEncoding]];
    int16_t length = 1;
    length = CFSwapInt16HostToBig(length);
    [data appendBytes:&length length:2];
    
    //Width short
    elementName = @"Width";
    nameLength = elementName.length;
    nameLength = CFSwapInt16HostToBig(nameLength);
    [data appendBytes:&tag length:1];
    [data appendBytes:&nameLength length:2];
    [data appendData:[elementName dataUsingEncoding:NSUTF8StringEncoding]];
    int16_t width = (int16_t)size.width;
    NSLog(@"width: %i", width);
    width = CFSwapInt16HostToBig(width);
    [data appendBytes:&width length:2];
    
    //Entities
    tag = TAG_List;
    elementName = @"Entities";
    nameLength = elementName.length;
    nameLength = CFSwapInt16HostToBig(nameLength);
    listLength = 0;
    listLength = CFSwapInt32HostToBig(listLength);
    [data appendBytes:&tag length:1];
    [data appendBytes:&nameLength length:2];
    [data appendData:[elementName dataUsingEncoding:NSUTF8StringEncoding]];
    tag = TAG_Byte;
    [data appendBytes:&tag length:1];
    [data appendBytes:&listLength length:4];
    
    //TileEntities
    tag = TAG_List;
    elementName = @"TileEntities";
    nameLength = elementName.length;
    nameLength = CFSwapInt16HostToBig(nameLength);
    listLength = 0;
    listLength = CFSwapInt32HostToBig(listLength);
    [data appendBytes:&tag length:1];
    [data appendBytes:&nameLength length:2];
    [data appendData:[elementName dataUsingEncoding:NSUTF8StringEncoding]];
    tag = TAG_Byte;
    [data appendBytes:&tag length:1];
    [data appendBytes:&listLength length:4];
    
    //Materials
    tag = TAG_String;
    elementName = @"Materials";
    nameLength = elementName.length;
    nameLength = CFSwapInt16HostToBig(nameLength);
    [data appendBytes:&tag length:1];
    [data appendBytes:&nameLength length:2];
    [data appendData:[elementName dataUsingEncoding:NSUTF8StringEncoding]];
    elementName = @"Alpha";
    nameLength = elementName.length;
    nameLength = CFSwapInt16HostToBig(nameLength);
    [data appendBytes:&nameLength length:2];
    [data appendData:[elementName dataUsingEncoding:NSUTF8StringEncoding]];
    
    //Data
    tag = TAG_Byte_Array;
    elementName = @"Data";
    nameLength = elementName.length;
    nameLength = CFSwapInt16HostToBig(nameLength);
    byteLength = (int32_t)wool.count;
    byteLength = CFSwapInt32HostToBig(byteLength);
    [data appendBytes:&tag length:1];
    [data appendBytes:&nameLength length:2];
    [data appendData:[elementName dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendBytes:&byteLength length:4];
    for (NSNumber *woolID in woolEnum) {
        int8_t woolInt = [woolID intValue];
        [data appendBytes:&woolInt length:1];
    }
    
    //Blocks
    tag = TAG_Byte_Array;
    elementName = @"Blocks";
    nameLength = elementName.length;
    nameLength = CFSwapInt16HostToBig(nameLength);
    byteLength = (int32_t)wool.count;
    byteLength = CFSwapInt32HostToBig(byteLength);
    [data appendBytes:&tag length:1];
    [data appendBytes:&nameLength length:2];
    [data appendData:[elementName dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendBytes:&byteLength length:4];
    for (int i=0; i<wool.count; i++) {
        int8_t woolID = [[wool objectAtIndex:i] intValue];
        int8_t blockID = 35;
        if ((replace == YES) && (woolID == 0)) {
            blockID = 0;
        }
        [data appendBytes:&blockID length:1];
    }
    
    //End
    tag = TAG_End;
    [data appendBytes:&tag length:1];
    
    NSData *encodedData = [data gzippedData];
    
    return encodedData;
}

- (NSDictionary *)createMasterCompoundFromData:(NSData *)data {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    uint8_t byte;
    [data getBytes:&byte length:1];
    if (byte!=TAG_Compound) {
        return nil;
    }
    
    NSString *key = [self readFirstString:[data subdataWithRange:NSMakeRange(1, data.length-1)]];
    id object = [self processCompoundData:data atIndex:1+2+key.length];
    [dictionary setObject:object forKey:key];
    
    return dictionary;
}

- (id)readFirstObject:(NSData *)data andTag:(BOOL)readTag orTagID:(int8_t)tagID {
    uint8_t byte;
    unsigned long byteIndex = 0;
    if (readTag) {
        [data getBytes:&byte length:1];
        byteIndex++;
    } else {
        byte = tagID;
    }

    switch (byte) {
        case TAG_End: {
            return nil;
        }
        case TAG_Byte: {
            uint8_t newByte;
            [data getBytes:&newByte range:NSMakeRange(byteIndex, 1)];
            NSNumber *number = [NSNumber numberWithInt:newByte];
            [self setBytesConsumed:byteIndex+1];
            return number;
        }
        case TAG_Short: {
            uint16_t newShort;
            [data getBytes:&newShort range:NSMakeRange(byteIndex, 2)];
            newShort = CFSwapInt16BigToHost(newShort);
            NSNumber *number = [NSNumber numberWithShort:newShort];
            [self setBytesConsumed:byteIndex+2];
            return number;
        }
        case TAG_Int: {
            uint32_t newInt;
            [data getBytes:&newInt range:NSMakeRange(byteIndex, 4)];
            newInt = CFSwapInt32BigToHost(newInt);
            NSNumber *number = [NSNumber numberWithInt:newInt];
            [self setBytesConsumed:byteIndex+4];
            return number;
        }
        case TAG_Long: {
            uint64_t newLong;
            [data getBytes:&newLong range:NSMakeRange(byteIndex, 8)];
            newLong = CFSwapInt64BigToHost(newLong);
            NSNumber *number = [NSNumber numberWithLong:newLong];
            [self setBytesConsumed:byteIndex+8];
            return number;
        }
        case TAG_Float: {
            NSSwappedFloat newFloat;
            [data getBytes:&newFloat range:NSMakeRange(byteIndex, 4)];
            float newFloat2 = NSSwapBigFloatToHost(newFloat);
            NSNumber *number = [NSNumber numberWithFloat:newFloat2];
            [self setBytesConsumed:byteIndex+4];
            return number;
        }
        case TAG_Double: {
            NSSwappedDouble newDouble;
            [data getBytes:&newDouble range:NSMakeRange(byteIndex, 8)];
            double newDouble2 = NSSwapBigDoubleToHost(newDouble);
            NSNumber *number = [NSNumber numberWithDouble:newDouble2];
            [self setBytesConsumed:byteIndex+8];
            return number;
        }
        case TAG_Byte_Array: {
            uint32_t byteArraySize;
            [data getBytes:&byteArraySize range:NSMakeRange(byteIndex, 4)];
            byteArraySize = CFSwapInt32BigToHost(byteArraySize);
            NSData *byteArray = [data subdataWithRange:NSMakeRange(byteIndex+4, byteArraySize)];
            [self setBytesConsumed:byteIndex+4+byteArraySize];
            return byteArray;
        }
        case TAG_String: {
            NSString *newString = [self readFirstString:[data subdataWithRange:NSMakeRange(byteIndex, data.length-byteIndex)]];
            [self setBytesConsumed:byteIndex+newString.length+2];
            return newString;
        }
        case TAG_List: {
            NSArray *list = [self processListData:data atIndex:byteIndex];
            self.bytesConsumed+=byteIndex;
            return list;
        }
        case TAG_Compound: {
            NSDictionary *compound = [self processCompoundData:data atIndex:byteIndex];
            self.bytesConsumed+=byteIndex;
            return compound;
        }
        case TAG_Int_Array: {
            NSLog(@"TAG_Int_Array. Will add support later.");
            return nil;
        }
        default: {
            NSLog(@"unrecognized tag: %i. Returning...", byte);
            return nil;
        }
    }
}

- (NSString *)readFirstString:(NSData *)data {
    int16_t stringLen;
    [data getBytes:&stringLen length:2];
    stringLen = CFSwapInt16BigToHost(stringLen);
    
    unsigned char stringBuffer[stringLen];
    [data getBytes:&stringBuffer range:NSMakeRange(2, stringLen)];
    NSString *name = [[NSString alloc] initWithBytes:&stringBuffer length:stringLen encoding:NSUTF8StringEncoding];
    
    return name;
}

- (NSArray *)processListData:(NSData *)data atIndex:(unsigned long)index {
    unsigned long byteIndex = index;
    
    int8_t tagID;
    int32_t length;
    NSMutableArray *list = [NSMutableArray array];
    [data getBytes:&tagID range:NSMakeRange(byteIndex, 1)];
    [data getBytes:&length range:NSMakeRange(byteIndex+1, 4)];
    length = CFSwapInt32BigToHost(length);
    byteIndex+=5;
    
    for (unsigned long i=0; i<length; i++) {
        id object = [self readFirstObject:[data subdataWithRange:NSMakeRange(byteIndex, data.length-byteIndex)] andTag:NO orTagID:tagID];
        byteIndex+=self.bytesConsumed;
        [list addObject:object];
    }
    self.bytesConsumed = byteIndex;
    
    return list;
}

- (NSDictionary *)processCompoundData:(NSData *)data atIndex:(unsigned long)index {
    unsigned long byteIndex = index;
    NSMutableDictionary *compound = [NSMutableDictionary dictionary];
    
    while (1) {
        int8_t tagID;
        [data getBytes:&tagID range:NSMakeRange(byteIndex, 1)];
        byteIndex++;
        NSString *key = nil;
        if (tagID != 0) {
            key = [self readFirstString:[data subdataWithRange:NSMakeRange(byteIndex, data.length-byteIndex)]];
            byteIndex+=2+key.length;
        }
        id object = [self readFirstObject:[data subdataWithRange:NSMakeRange(byteIndex, data.length-byteIndex)] andTag:NO orTagID:tagID];
        if (object) {
            [compound setObject:object forKey:key];
            byteIndex+=self.bytesConsumed;
        } else {
            NSLog(@"breaking compound");
            break;
        }
    }
    
    return compound;
}

@end
