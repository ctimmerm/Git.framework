//
//  GITObjectHash.m
//  Git.framework
//
//  Created by Geoff Garside on 08/11/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import "GITObjectHash.h"


const NSUInteger GITObjectHashLength = 40;
const NSUInteger GITObjectHashPackedLength = 20;
const NSString *hexChars = @"0123456789abcdef";

@implementation GITObjectHash

@synthesize data;

- (id)initWithData:(NSData *)theData {
    self = [super init];
    if ( self ) {
        self.data = theData;
    }
    return self;
}

- (id)initWithString:(NSString *)aString {
    self = [super init];
    if ( self ) {
        self.data = [[self class] packedDataFromString:aString];
    }
    return self;
}

- (id)initWithBytes:(uint8_t *)bytes length:(size_t)length {
    self = [super init];
    if ( self ) {
        NSData *bytesData = [NSData dataWithBytes:bytes length:length];
        if ( length == GITObjectHashLength ) {
            NSString *string = [[NSString alloc] initWithData:bytesData encoding:NSASCIIStringEncoding];
            self.data = [[self class] packedDataFromString:string];
            [string release];
        }
        else if ( length == GITObjectHashPackedLength ) {
            self.data = bytesData;
        }
    }
    return self;
}

+ (GITObjectHash *)objectHashWithString:(NSString *)aString {
    return [[[self alloc] initWithString:aString] autorelease];
}

+ (GITObjectHash *)objectHashWithData:(NSData *)theData {
    return [[[self alloc] initWithData:theData] autorelease];
}

//! \name Packing and Unpacking SHA1 Hashes
+ (NSData *)packedDataFromString:(NSString *)aString {
    NSUInteger length = [aString length];
    if ( length != GITObjectHashLength )
        return nil;
    
    NSUInteger i;
    NSRange range;
    uint8_t raw[GITObjectHashPackedLength];
    
    // In a hex string, each character represents 4 bits.
    // We go through the string 2 characters at a time to form one byte per loop.
    for ( i = 0; i < length; i += 2 ) {
        uint8_t *current = raw + i/2;
        range = [hexChars rangeOfString:[aString substringWithRange:NSMakeRange(i, 1)]];
        *current = range.location << 4;
        range = [hexChars rangeOfString:[aString substringWithRange:NSMakeRange(i + 1, 1)]];
        *current |= range.location;
    }
    return [NSData dataWithBytes:raw length:GITObjectHashPackedLength];
}

+ (NSString *)unpackedStringFromData:(NSData *)theData {
    NSUInteger length = [theData length];
    if ( length != GITObjectHashPackedLength )
        return nil;
    
    NSUInteger i;
    NSMutableString *string = [NSMutableString string];
    const uint8_t *raw = [theData bytes];
    
    // In a hex string, each character represents 4 bits.
    // We go through all bytes and add 2 hex characters for each byte.
    for ( i = 0; i < length; i++ ) {
        [string appendString:[hexChars substringWithRange:NSMakeRange(*raw >> 4, 1)]];
        [string appendString:[hexChars substringWithRange:NSMakeRange(*raw & 0x0f, 1)]];
        raw++;
    }
    return string;
}


//! \name Getting Packed and Unpacked Forms
- (NSString *)unpackedString {
    return [[self class] unpackedStringFromData:data];
}

//! \name Testing Equality
- (BOOL)isEqual:(id)other {
    if ( !other ) return NO;                            // other is nil
    if ( other == self ) return YES;                    // pointers match?

    if ( [other isKindOfClass:[self class]] )           // Same class?
        return [self isEqualToObjectHash:other];
    if ( [other isKindOfClass:[NSString class]] )       // A string?
        return [self isEqualToString:other];
    if ( [other isKindOfClass:[NSData class]] )         // A data?
        return [self isEqualToData:other];

    return NO;                                          // Definitely not then
}

- (BOOL)isEqualToObjectHash: (GITObjectHash *)otherObjectHash {
    if ( !otherObjectHash )
        return NO;
    if ( self == otherObjectHash )
        return YES;
    if ( [data isEqualToData:otherObjectHash.data] )
        return YES;
    return NO;
}

- (BOOL)isEqualToData: (NSData *)theData {
    return [data isEqualToData:theData];
}

- (BOOL)isEqualToString: (NSString *)aString {
    return [[self unpackedString] isEqualToString:aString];
}

- (NSString *)description {
    return [self unpackedString];
}

- (void)dealloc {
    self.data = nil;
    [super dealloc];
}

@end
