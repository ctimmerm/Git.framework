//
//  GITObjectHash.h
//  Git.framework
//
//  Created by Geoff Garside on 08/11/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>


extern const NSUInteger GITObjectHashLength;
extern const NSUInteger GITObjectHashPackedLength;

/*!
 * A SHA-1 hash is 160 bits (20 bytes) long. And this is how GIT stores it in pack and index files, as 20 bytes of raw data.
 * For representation purposes and for the filename of loose objects, the SHA-1 hash is displayed as a 40 character hex string.
 * The \c GITObjectHash class provides the functionality to go from packed bytes to the unpacked hex string representation
 * and vice versa.
 */
@interface GITObjectHash : NSObject {
    NSData *data;
}

@property (retain, getter=packedData) NSData *data;

- (id)initWithData:(NSData *)theData;

- (id)initWithString:(NSString *)aString;

- (id)initWithBytes:(uint8_t *)bytes length:(size_t)length;

+ (GITObjectHash *)objectHashWithString:(NSString *)aString;

+ (GITObjectHash *)objectHashWithData:(NSData *)theData;

//! \name Packing and Unpacking SHA1 Hashes
+ (NSData *)packedDataFromString:(NSString *)aString;

+ (NSString *)unpackedStringFromData:(NSData *)theData;

//! \name Getting Packed and Unpacked Forms
/*!
 * Return a 40 character hex string representing the SHA-1 hash.
 *
 * \return a 40 character hex string representing the SHA-1 hash
 */
- (NSString *)unpackedString;

//! \name Testing Equality
/*!
 * Returns a Boolean value that indicates whether the receiver and a given object are equal.
 *
 * \param other The object to be compared to the receiver
 * \return YES if the receiver and other are equal, otherwise NO
 * \sa isEqualToData:
 * \sa isEqualToString:
 * \sa isEqualToObjectHash:
 */
- (BOOL)isEqual: (id)other;

/*!
 * Returns a Boolean value that indicates whether the receiver and a given data object are equal.
 *
 * \param data The data object with which to compare the receiver
 * \return YES if the receiver and data are equal, otherwise NO
 * \sa isEqual:
 * \sa isEqualToString:
 * \sa isEqualToObjectHash:
 */
- (BOOL)isEqualToData: (NSData *)data;

/*!
 * Returns a Boolean value that indicates whether the receiver and a given string are equal.
 *
 * \param str The string with which to compare the receiver
 * \return YES if the receiver and str are equal, otherwise NO
 * \sa isEqual:
 * \sa isEqualToData:
 * \sa isEqualToObjectHash:
 */
- (BOOL)isEqualToString: (NSString *)str;

/*!
 * Returns a Boolean value that indicates whether the receiver and a given ObjectHash are equal.
 *
 * \param hash The ObjectHash with which to compare the receiver
 * \return YES if the receiver and hash are equal, otherwise NO
 * \sa isEqual:
 * \sa isEqualToData:
 * \sa isEqualToString:
 */
- (BOOL)isEqualToObjectHash: (GITObjectHash *)hash;

@end
