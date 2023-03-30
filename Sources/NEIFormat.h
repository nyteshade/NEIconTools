//
//  NEIconFormat.h
//  Icon Stamper
//
//  Created by Brielle Harrison on 3/27/23.
//  Copyright © 2023 Brielle Harrison. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef CGFloat NEIOSSupport;
typedef uint16 NEIFeature;
typedef uint32_t NEIIdentifier;
typedef size_t NEIExpectedSize;
typedef CGSize NEIPixelSize;

extern const size_t kVariedSizeICNS;

extern const NEIOSSupport kOSUnknown;
extern const NEIOSSupport kOS1_0;
extern const NEIOSSupport kOS6_0;
extern const NEIOSSupport kOS7_0;
extern const NEIOSSupport kOS8_5;
extern const NEIOSSupport kOS10_0;
extern const NEIOSSupport kOS10_5;
extern const NEIOSSupport kOS10_7;
extern const NEIOSSupport kOS10_8;

extern const NEIFeature kICNS_ARGB;
extern const NEIFeature kICNS_PNG;
extern const NEIFeature kICNS_JPG2000;
extern const NEIFeature kICNS_24BIT;
extern const NEIFeature kICNS_8BIT;
extern const NEIFeature kICNS_4BIT;
extern const NEIFeature kICNS_1BIT;
extern const NEIFeature kICNS_MASK;
extern const NEIFeature kICNS_RETINA;

@interface NEIFormat : NSObject<NSCopying>
@property (readonly) NEIIdentifier id;
@property (readonly) NEIExpectedSize length;
@property (readonly) NEIPixelSize pixelSize;
@property (readonly) NEIFeature features;
@property (readonly) NEIOSSupport minOSSupport;
@property (readonly, retain) NSString *about;

@property (readonly, retain) NSString* iconFilename;
@property (readonly) NEIIdentifier iconType;
@property (readonly) NEIPixelSize iconSize;
@property (readonly) CGFloat iconArea;

- (NSString*)prefix:(NSString*)prefix;
- (NSString*)prefix:(NSString*)prefix removeExtension:(bool)removeExtension;
- (NSString*)keyfix;
- (NSString*)keyfix:(NSString*)prefix;

- (CGFloat)area;

- (BOOL)retina;
- (BOOL)supportsJPEG2000;
- (BOOL)supportsPNG;
- (BOOL)supportsARGB;
- (BOOL)supports24Bit;
- (BOOL)supports8Bit;
- (BOOL)supports4Bit;
- (BOOL)supports1Bit;
- (BOOL)supports1BitWithMask;

+ (NSArray<NEIFormat*>*) standardFormats;
+ (NSArray<NEIFormat*>*) allIconFormats;
+ (NSArray<NEIFormat*>*) allFormats;

+ (instancetype)identifier:(uint32_t)identifier;
+ (instancetype)matchingType:(CGFloat)widthOrHeight
                preferRetina:(BOOL)preferRetina;

+ (instancetype) kICON; // 1-bit mono icon
+ (instancetype) kICN_; // 1-bit mono icon with 1-bit mask
+ (instancetype) kicm_; // 1 bit mono icon with 1-bit mask
+ (instancetype) kicm4; // 4 bit icon
+ (instancetype) kicm8; // 8 bit icon
+ (instancetype) kics_; // 1-bit mono icon with 1-bit mask
+ (instancetype) kics4; // 4-bit icon
+ (instancetype) kics8; // 8 bit icon
+ (instancetype) kis32; // 24-bit RGB icon
+ (instancetype) ks8mk; // 8-bit mask
+ (instancetype) kicl4; // 4-bit icon
+ (instancetype) kicl8; // 8-bit icon
+ (instancetype) kil32; // 24-bit RGB icon
+ (instancetype) kl8mk; // 8-bit mask
+ (instancetype) kich_; // 1-bit mono icon with 1-bit mask
+ (instancetype) kich4; // 4-bit icon
+ (instancetype) kich8; // 8-bit icon
+ (instancetype) kih32; // 24-bit RGB icon
+ (instancetype) kh8mk; // 8-bit mask
+ (instancetype) kit32; // 24-bit RGB icon
+ (instancetype) kt8mk; // 8-bit mask
+ (instancetype) kicp4; // JPEG 2000† or PNG† format or 24-bit RGB icon[2]
+ (instancetype) kicp5; // JPEG 2000† or PNG† format or 24-bit RGB icon[2]
+ (instancetype) kicp6; // JPEG 2000† or PNG† format
+ (instancetype) kic07; // JPEG 2000 or PNG format
+ (instancetype) kic08; // JPEG 2000 or PNG format
+ (instancetype) kic09; // JPEG 2000 or PNG format
+ (instancetype) kic10; // JPEG 2000 or PNG format (512x512@2x "retina" in 10.8)
+ (instancetype) kic11; // JPEG 2000 or PNG format (16x16@2x "retina")
+ (instancetype) kic12; // JPEG 2000 or PNG format (32x32@2x "retina")
+ (instancetype) kic13; // JPEG 2000 or PNG format (128x128@2x "retina")
+ (instancetype) kic14; // JPEG 2000 or PNG format (256x256@2x "retina")
+ (instancetype) kic04; // ARGB or JPEG 2000† or PNG† format
+ (instancetype) kic05; // ARGB or JPEG 2000† or PNG† format (16x16@2x "retina")
+ (instancetype) kicsb; // ARGB or JPEG 2000† or PNG† format
+ (instancetype) kicsB; // JPEG 2000 or PNG format (18x18@2x "retina")
+ (instancetype) ksb24; // JPEG 2000 or PNG format
+ (instancetype) kSB24; // JPEG 2000 or PNG format (24x24@2x "retina")
+ (instancetype) kTOC_; // "Table of Contents" a list of all image types in the file, and their sizes (added in Mac OS X 10.7). A TOC is written out as an identifier (4 bytes) and size (4 bytes). Each subsequent record (8 bytes each) maps to the icon formats found in the file. The data isn't included in this phase.
+ (instancetype) kicnV; // 4-byte big endian float - equal to the bundle version number of Icon Composer.app that created the icon
+ (instancetype) kname; // Usage unknown (all tested files use either "icon"[3] or "template"[4]).
+ (instancetype) kinfo; // Info binary plist. Usage unknown (only name field seems to be used).
+ (instancetype) ksbtp; // Nested "template" icns file. Usage unknown.
+ (instancetype) kslct; // Nested "selected" icns file. Usage unknown.
+ (instancetype) kdark; // '\xFD\xD9\x2F\xA8' Nested "dark" icns file. Allows automatic icon switching in Dark mode. (added in macOS 10.14).

+ (instancetype)nearestNEIFormatForImage:(NSImage*)image;
@end

NS_ASSUME_NONNULL_END
