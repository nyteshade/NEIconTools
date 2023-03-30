//
//  NEIconFormat.m
//  Icon Stamper
//
//  Created by Brielle Harrison on 3/27/23.
//  Copyright © 2023 Brielle Harrison. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "NEIFormat.h"

typedef struct {
  NEIIdentifier osType;
  NEIExpectedSize length;
  NEIPixelSize pixelSize;
  NEIFeature imageTypes;
  NEIOSSupport minOSSupport;
  NSString* description;
} ICNSType;

const size_t kVariedSizeICNS = -129.0;
const size_t kSizeNotApplicableICNS = -130.0;

const NEIOSSupport kOSUnknown = -128.0;
const NEIOSSupport kOS1_0 = 1.0;
const NEIOSSupport kOS6_0 = 6.0;
const NEIOSSupport kOS7_0 = 7.0;
const NEIOSSupport kOS8_5 = 8.5;
const NEIOSSupport kOS10_0 = 10.0;
const NEIOSSupport kOS10_5 = 10.5;
const NEIOSSupport kOS10_7 = 10.7;
const NEIOSSupport kOS10_8 = 10.8;

const NEIFeature kICNS_ARGB = 2;
const NEIFeature kICNS_PNG = 4;
const NEIFeature kICNS_JPG2000 = 8;
const NEIFeature kICNS_24BIT = 16;
const NEIFeature kICNS_8BIT = 32;
const NEIFeature kICNS_4BIT = 64;
const NEIFeature kICNS_1BIT = 128;
const NEIFeature kICNS_MASK = 256;
const NEIFeature kICNS_RETINA = 512;

const NEIFeature kICNS_META = 1024;

const ICNSType _kICON = { 'ICON', 128, (CGSize){ 32, 32 }, kICNS_1BIT, kOS1_0, @"1-bit mono icon" };
const ICNSType _kICN_ = { 'ICN#', 256, (CGSize){ 32, 32 }, kICNS_1BIT | kICNS_MASK, kOS6_0, @"1-bit mono icon with 1-bit mask" };
const ICNSType _kicm_ = { 'icm#', 48, (CGSize){ 16, 12 }, kICNS_1BIT | kICNS_MASK, kOS6_0, @"1 bit mono icon with 1-bit mask" };
const ICNSType _kicm4 = { 'icm4', 96, (CGSize){ 16, 12 }, kICNS_4BIT, kOS7_0, @"4 bit icon" };
const ICNSType _kicm8 = { 'icm8', 192, (CGSize){ 16, 12 }, kICNS_8BIT, kOS7_0, @"8 bit icon" };
const ICNSType _kics_ = { 'ics#', 64, (CGSize){ 16, 16 }, kICNS_1BIT | kICNS_MASK, kOS6_0, @"1-bit mono icon with 1-bit mask" };
const ICNSType _kics4 = { 'ics4', 128, (CGSize){ 16, 16 }, kICNS_4BIT, kOS7_0, @"4-bit icon" };
const ICNSType _kics8 = { 'ics8', 256, (CGSize){ 16, 16 }, kICNS_8BIT, kOS7_0, @"8 bit icon" };
const ICNSType _kis32 = { 'is32', 768, (CGSize){ 16, 16 }, kICNS_24BIT, kOS8_5, @"24-bit RGB icon" };
const ICNSType _ks8mk = { 's8mk', 256, (CGSize){ 16, 16 }, kICNS_8BIT | kICNS_MASK, kOS8_5, @"8-bit mask" };
const ICNSType _kicl4 = { 'icl4', 512, (CGSize){ 32, 32 }, kICNS_4BIT, kOS7_0, @"4-bit icon" };
const ICNSType _kicl8 = { 'icl8', 1024, (CGSize){ 32, 32 }, kICNS_8BIT, kOS7_0, @"8-bit icon" };
const ICNSType _kil32 = { 'il32', 3072, (CGSize){ 32, 32 }, kICNS_24BIT, kOS8_5, @"24-bit RGB icon" };
const ICNSType _kl8mk = { 'l8mk', 1024, (CGSize){ 32, 32 }, kICNS_8BIT | kICNS_MASK, kOS8_5, @"8-bit mask" };
const ICNSType _kich_ = { 'ich#', 576, (CGSize){ 48, 48 }, kICNS_1BIT | kICNS_MASK, kOS8_5, @"1-bit mono icon with 1-bit mask" };
const ICNSType _kich4 = { 'ich4', 1152, (CGSize){ 48, 48 }, kICNS_4BIT, kOS8_5, @"4-bit icon" };
const ICNSType _kich8 = { 'ich8', 2304, (CGSize){ 48, 48 }, kICNS_8BIT, kOS8_5, @"8-bit icon" };
const ICNSType _kih32 = { 'ih32', 6912, (CGSize){ 48, 48 }, kICNS_24BIT, kOS8_5, @"24-bit RGB icon" };
const ICNSType _kh8mk = { 'h8mk', 2304, (CGSize){ 48, 48 }, kICNS_8BIT | kICNS_MASK, kOS8_5, @"8-bit mask" };
const ICNSType _kit32 = { 'it32', 49156, (CGSize){ 128, 128 }, kICNS_24BIT, kOS10_0, @"24-bit RGB icon" };
const ICNSType _kt8mk = { 't8mk', 16384, (CGSize){ 128, 128 }, kICNS_MASK, kOS10_0, @"8-bit mask" };
const ICNSType _kicp4 = { 'icp4', kVariedSizeICNS, (CGSize){ 16, 16 }, kICNS_JPG2000 | kICNS_PNG | kICNS_24BIT, kOS10_7, @"JPEG 2000† or PNG† format or 24-bit RGB icon[2]" };
const ICNSType _kicp5 = { 'icp5', kVariedSizeICNS, (CGSize){ 32, 32 }, kICNS_JPG2000 | kICNS_PNG | kICNS_24BIT, kOS10_7, @"JPEG 2000† or PNG† format or 24-bit RGB icon[2]" };
const ICNSType _kicp6 = { 'icp6', kVariedSizeICNS, (CGSize){ 48, 48 }, kICNS_JPG2000 | kICNS_PNG, kOS10_7, @"JPEG 2000† or PNG† format" };
const ICNSType _kic07 = { 'ic07', kVariedSizeICNS, (CGSize){ 128, 128 }, kICNS_JPG2000 | kICNS_PNG, kOS10_7, @"JPEG 2000 or PNG format" };
const ICNSType _kic08 = { 'ic08', kVariedSizeICNS, (CGSize){ 256, 256 }, kICNS_JPG2000 | kICNS_PNG, kOS10_5, @"JPEG 2000 or PNG format" };
const ICNSType _kic09 = { 'ic09', kVariedSizeICNS, (CGSize){ 512, 512 }, kICNS_JPG2000 | kICNS_PNG, kOS10_5, @"JPEG 2000 or PNG format" };
const ICNSType _kic10 = { 'ic10', kVariedSizeICNS, (CGSize){ 1024, 1024 }, kICNS_JPG2000 | kICNS_PNG | kICNS_RETINA, kOS10_7, @"JPEG 2000 or PNG format (512x512@2x \"retina\" in 10.8)" };
const ICNSType _kic11 = { 'ic11', kVariedSizeICNS, (CGSize){ 32, 32 }, kICNS_JPG2000 | kICNS_PNG | kICNS_RETINA, kOS10_8, @"JPEG 2000 or PNG format (16x16@2x \"retina\")" };
const ICNSType _kic12 = { 'ic12', kVariedSizeICNS, (CGSize){ 64, 64 }, kICNS_JPG2000 | kICNS_PNG | kICNS_RETINA, kOS10_8, @"JPEG 2000 or PNG format (32x32@2x \"retina\")" };
const ICNSType _kic13 = { 'ic13', kVariedSizeICNS, (CGSize){ 256, 256 }, kICNS_JPG2000 | kICNS_PNG | kICNS_RETINA, kOS10_8, @"JPEG 2000 or PNG format (128x128@2x \"retina\")" };
const ICNSType _kic14 = { 'ic14', kVariedSizeICNS, (CGSize){ 512, 512 }, kICNS_JPG2000 | kICNS_PNG | kICNS_RETINA, kOS10_8, @"JPEG 2000 or PNG format (256x256@2x \"retina\")" };
const ICNSType _kic04 = { 'ic04', 1024, (CGSize){ 16, 16 }, kICNS_ARGB | kICNS_JPG2000 | kICNS_PNG, kOSUnknown, @"ARGB or JPEG 2000† or PNG† format" };
const ICNSType _kic05 = { 'ic05', 4096, (CGSize){ 32, 32 }, kICNS_ARGB | kICNS_JPG2000 | kICNS_PNG | kICNS_RETINA, kOSUnknown, @"ARGB or JPEG 2000† or PNG† format (16x16@2x \"retina\")" };
const ICNSType _kicsb = { 'icsb', 1296, (CGSize){ 18, 18 }, kICNS_ARGB | kICNS_JPG2000 | kICNS_PNG, kOSUnknown, @"ARGB or JPEG 2000† or PNG† format" };
const ICNSType _kicsB = { 'icsB', kVariedSizeICNS, (CGSize){ 36, 36 }, kICNS_JPG2000 | kICNS_PNG | kICNS_RETINA, kOSUnknown, @"JPEG 2000 or PNG format (18x18@2x \"retina\")" };
const ICNSType _ksb24 = { 'sb24', kVariedSizeICNS, (CGSize){ 24, 24 }, kICNS_JPG2000 | kICNS_PNG, kOSUnknown, @"JPEG 2000 or PNG format" };
const ICNSType _kSB24 = { 'SB24', kVariedSizeICNS, (CGSize){ 48, 48 }, kICNS_JPG2000 | kICNS_PNG | kICNS_RETINA, kOSUnknown, @"JPEG 2000 or PNG format (24x24@2x \"retina\")" };

const ICNSType _kTOC_ = { 'TOC ', kSizeNotApplicableICNS, (CGSize){ 0, 0 }, kICNS_META, kOSUnknown, @"\"Table of Contents\" a list of all image types in the file, and their sizes (added in Mac OS X 10.7)"};
const ICNSType _kicnV = { 'icnV', kSizeNotApplicableICNS, (CGSize){ 0, 0 }, kICNS_META, kOSUnknown, @"4-byte big endian float - equal to the bundle version number of Icon Composer.app that created the icon"};
const ICNSType _kname = { 'name', kSizeNotApplicableICNS, (CGSize){ 0, 0 }, kICNS_META, kOSUnknown, @"Usage unknown (all tested files use either \"icon\"[3] or \"template\"[4])."};
const ICNSType _kinfo = { 'info', kSizeNotApplicableICNS, (CGSize){ 0, 0 }, kICNS_META, kOSUnknown, @"Info binary plist. Usage unknown (only name field seems to be used)."};
const ICNSType _ksbtp = { 'sbtp', kSizeNotApplicableICNS, (CGSize){ 0, 0 }, kICNS_META, kOSUnknown, @"Nested \"template\" icns file. Usage unknown."};
const ICNSType _kslct = { 'slct', kSizeNotApplicableICNS, (CGSize){ 0, 0 }, kICNS_META, kOSUnknown, @"Nested \"selected\" icns file. Usage unknown."};
const ICNSType _kdark = { '\xFD\xD9\x2F\xA8', kSizeNotApplicableICNS, (CGSize){ 0, 0 }, kICNS_META, kOSUnknown, @"Nested \"dark\" icns file. Allows automatic icon switching in Dark mode. (added in macOS 10.14)"};


@interface NEIFormat()
- (instancetype) init;
- (instancetype) initFromIcnsType:(ICNSType)type;

- (void)osType:(NEIIdentifier)osType;
- (void)length:(NEIExpectedSize)length;
- (void)pixelSize:(NEIPixelSize)pixelSize;
- (void)imageFormat:(NEIFeature)imageTypes;
- (void)minOS:(NEIOSSupport)minOS;
- (void)about:(NSString*)about;

+ (instancetype) t:(NEIIdentifier)osType
                 l:(NEIExpectedSize)length
                 p:(NEIPixelSize)pixelSize
                 f:(NEIFeature)imageTypes
                 o:(NEIOSSupport)minOSSupport
                 a:(NSString*)description;
@end

@implementation NEIFormat
// MARK: - Instance Methods

- (id)copyWithZone:(NSZone *)zone
{
  NEIFormat *copy = [NEIFormat t:self.id
                                     l:self.length
                                     p:self.pixelSize
                                     f:self.features
                                     o:self.minOSSupport
                                     a:self.about];
  return copy;
}

- (NSString*)prefix:(NSString*)prefix
{
  return [self prefix:prefix removeExtension:NO];
}

- (NSString*)prefix:(NSString*)prefix removeExtension:(bool)removeExtension
{
  NSString* result = [NSString stringWithFormat:@"%@%@",
                      prefix, self.iconFilename];
  
  if (removeExtension)
    result = [result stringByDeletingPathExtension];
  
  return result;
}

- (NSString*)keyfix
{
  return [self keyfix:@"icon"];
}

- (NSString*)keyfix:(NSString*)prefix
{
  return [[self prefix:prefix removeExtension:YES]
          stringByReplacingOccurrencesOfString:@"@" withString:@"_"];
}

- (NEIIdentifier)iconType
{
  return self.id;
}

- (NEIPixelSize)iconSize
{
  return self.pixelSize;
}

- (CGFloat)iconArea
{
  return self.pixelSize.width * self.pixelSize.height;
}

- (NSString*)iconFilename
{
  NSMutableString *string = [NSMutableString new];
  uint16 width = (uint16)self.iconSize.width;
  uint16 height = (uint16)self.iconSize.height;
  bool retina = [self retina];
  
  if (retina)
  {
    width /= 2;
    height /= 2;
  }
  
  [string appendString:@"_"];
  [string appendFormat:@"%dx%d", width, height];
  
  if (retina)
    [string appendString:@"@2x"];
  
  [string appendString:@".png"];
  
  return string;
}

- (CGFloat)area
{
  return self.pixelSize.width * self.pixelSize.height;
}

- (BOOL)retina
{
  return (self.features & kICNS_RETINA) == kICNS_RETINA;
}

- (BOOL)supportsJPEG2000
{
  return (self.features & kICNS_JPG2000) == kICNS_JPG2000;
}

- (BOOL)supportsPNG
{
  return (self.features & kICNS_PNG) == kICNS_PNG;
}

- (BOOL)supportsARGB
{
  return (self.features & kICNS_ARGB) == kICNS_ARGB;
}

- (BOOL)supports24Bit
{
  return (self.features & kICNS_24BIT) == kICNS_24BIT;
}

- (BOOL)supports8Bit
{
  return (self.features & kICNS_8BIT) == kICNS_8BIT;
}

- (BOOL)supports4Bit
{
  return (self.features & kICNS_4BIT) == kICNS_4BIT;
}

- (BOOL)supports1Bit
{
  return (
    ((self.features & kICNS_1BIT) == kICNS_1BIT) &&
    ((self.features & kICNS_MASK) != kICNS_MASK)
  );
}


- (BOOL)supports1BitWithMask
{
  return (
    ((self.features & kICNS_1BIT) == kICNS_1BIT) &&
    ((self.features & kICNS_MASK) == kICNS_MASK)
  );
}



// MARK: - Static Initializers
+ (instancetype) t:(NEIIdentifier)osType
                 l:(NEIExpectedSize)length
                 p:(NEIPixelSize)pixelSize
                 f:(NEIFeature)imageTypes
                 o:(NEIOSSupport)minOSSupport
                 a:(NSString*)about
{
  NEIFormat* format = [NEIFormat new];
  if (format)
  {
    [format osType:osType];
    [format length:length];
    [format pixelSize:pixelSize];
    [format imageFormat:imageTypes];
    [format minOS:minOSSupport];
    [format about:about];
  }
  return format;
}

// MARK: Static Formats
+ (instancetype) kICON { static NEIFormat *fmt = nil; if (!fmt) { fmt = [[NEIFormat alloc] initFromIcnsType:_kICON]; } return fmt; };
+ (instancetype) kICN_ { static NEIFormat *fmt = nil; if (!fmt) { fmt = [[NEIFormat alloc] initFromIcnsType:_kICN_]; } return fmt; };
+ (instancetype) kicm_ { static NEIFormat *fmt = nil; if (!fmt) { fmt = [[NEIFormat alloc] initFromIcnsType:_kicm_]; } return fmt; };
+ (instancetype) kicm4 { static NEIFormat *fmt = nil; if (!fmt) { fmt = [[NEIFormat alloc] initFromIcnsType:_kicm4]; } return fmt; };
+ (instancetype) kicm8 { static NEIFormat *fmt = nil; if (!fmt) { fmt = [[NEIFormat alloc] initFromIcnsType:_kicm8]; } return fmt; };
+ (instancetype) kics_ { static NEIFormat *fmt = nil; if (!fmt) { fmt = [[NEIFormat alloc] initFromIcnsType:_kics_]; } return fmt; };
+ (instancetype) kics4 { static NEIFormat *fmt = nil; if (!fmt) { fmt = [[NEIFormat alloc] initFromIcnsType:_kics4]; } return fmt; };
+ (instancetype) kics8 { static NEIFormat *fmt = nil; if (!fmt) { fmt = [[NEIFormat alloc] initFromIcnsType:_kics8]; } return fmt; };
+ (instancetype) kis32 { static NEIFormat *fmt = nil; if (!fmt) { fmt = [[NEIFormat alloc] initFromIcnsType:_kis32]; } return fmt; };
+ (instancetype) ks8mk { static NEIFormat *fmt = nil; if (!fmt) { fmt = [[NEIFormat alloc] initFromIcnsType:_ks8mk]; } return fmt; };
+ (instancetype) kicl4 { static NEIFormat *fmt = nil; if (!fmt) { fmt = [[NEIFormat alloc] initFromIcnsType:_kicl4]; } return fmt; };
+ (instancetype) kicl8 { static NEIFormat *fmt = nil; if (!fmt) { fmt = [[NEIFormat alloc] initFromIcnsType:_kicl8]; } return fmt; };
+ (instancetype) kil32 { static NEIFormat *fmt = nil; if (!fmt) { fmt = [[NEIFormat alloc] initFromIcnsType:_kil32]; } return fmt; };
+ (instancetype) kl8mk { static NEIFormat *fmt = nil; if (!fmt) { fmt = [[NEIFormat alloc] initFromIcnsType:_kl8mk]; } return fmt; };
+ (instancetype) kich_ { static NEIFormat *fmt = nil; if (!fmt) { fmt = [[NEIFormat alloc] initFromIcnsType:_kich_]; } return fmt; };
+ (instancetype) kich4 { static NEIFormat *fmt = nil; if (!fmt) { fmt = [[NEIFormat alloc] initFromIcnsType:_kich4]; } return fmt; };
+ (instancetype) kich8 { static NEIFormat *fmt = nil; if (!fmt) { fmt = [[NEIFormat alloc] initFromIcnsType:_kich8]; } return fmt; };
+ (instancetype) kih32 { static NEIFormat *fmt = nil; if (!fmt) { fmt = [[NEIFormat alloc] initFromIcnsType:_kih32]; } return fmt; };
+ (instancetype) kh8mk { static NEIFormat *fmt = nil; if (!fmt) { fmt = [[NEIFormat alloc] initFromIcnsType:_kh8mk]; } return fmt; };
+ (instancetype) kit32 { static NEIFormat *fmt = nil; if (!fmt) { fmt = [[NEIFormat alloc] initFromIcnsType:_kit32]; } return fmt; };
+ (instancetype) kt8mk { static NEIFormat *fmt = nil; if (!fmt) { fmt = [[NEIFormat alloc] initFromIcnsType:_kt8mk]; } return fmt; };
+ (instancetype) kicp4 { static NEIFormat *fmt = nil; if (!fmt) { fmt = [[NEIFormat alloc] initFromIcnsType:_kicp4]; } return fmt; };
+ (instancetype) kicp5 { static NEIFormat *fmt = nil; if (!fmt) { fmt = [[NEIFormat alloc] initFromIcnsType:_kicp5]; } return fmt; };
+ (instancetype) kicp6 { static NEIFormat *fmt = nil; if (!fmt) { fmt = [[NEIFormat alloc] initFromIcnsType:_kicp6]; } return fmt; };
+ (instancetype) kic07 { static NEIFormat *fmt = nil; if (!fmt) { fmt = [[NEIFormat alloc] initFromIcnsType:_kic07]; } return fmt; };
+ (instancetype) kic08 { static NEIFormat *fmt = nil; if (!fmt) { fmt = [[NEIFormat alloc] initFromIcnsType:_kic08]; } return fmt; };
+ (instancetype) kic09 { static NEIFormat *fmt = nil; if (!fmt) { fmt = [[NEIFormat alloc] initFromIcnsType:_kic09]; } return fmt; };
+ (instancetype) kic10 { static NEIFormat *fmt = nil; if (!fmt) { fmt = [[NEIFormat alloc] initFromIcnsType:_kic10]; } return fmt; };
+ (instancetype) kic11 { static NEIFormat *fmt = nil; if (!fmt) { fmt = [[NEIFormat alloc] initFromIcnsType:_kic11]; } return fmt; };
+ (instancetype) kic12 { static NEIFormat *fmt = nil; if (!fmt) { fmt = [[NEIFormat alloc] initFromIcnsType:_kic12]; } return fmt; };
+ (instancetype) kic13 { static NEIFormat *fmt = nil; if (!fmt) { fmt = [[NEIFormat alloc] initFromIcnsType:_kic13]; } return fmt; };
+ (instancetype) kic14 { static NEIFormat *fmt = nil; if (!fmt) { fmt = [[NEIFormat alloc] initFromIcnsType:_kic14]; } return fmt; };
+ (instancetype) kic04 { static NEIFormat *fmt = nil; if (!fmt) { fmt = [[NEIFormat alloc] initFromIcnsType:_kic04]; } return fmt; };
+ (instancetype) kic05 { static NEIFormat *fmt = nil; if (!fmt) { fmt = [[NEIFormat alloc] initFromIcnsType:_kic05]; } return fmt; };
+ (instancetype) kicsb { static NEIFormat *fmt = nil; if (!fmt) { fmt = [[NEIFormat alloc] initFromIcnsType:_kicsb]; } return fmt; };
+ (instancetype) kicsB { static NEIFormat *fmt = nil; if (!fmt) { fmt = [[NEIFormat alloc] initFromIcnsType:_kicsB]; } return fmt; };
+ (instancetype) ksb24 { static NEIFormat *fmt = nil; if (!fmt) { fmt = [[NEIFormat alloc] initFromIcnsType:_ksb24]; } return fmt; };
+ (instancetype) kSB24 { static NEIFormat *fmt = nil; if (!fmt) { fmt = [[NEIFormat alloc] initFromIcnsType:_kSB24]; } return fmt; };

+ (instancetype) kTOC_ { static NEIFormat *fmt = nil; if (!fmt) { fmt = [[NEIFormat alloc] initFromIcnsType:_kTOC_]; } return fmt; };
+ (instancetype) kicnV { static NEIFormat *fmt = nil; if (!fmt) { fmt = [[NEIFormat alloc] initFromIcnsType:_kicnV]; } return fmt; };
+ (instancetype) kname { static NEIFormat *fmt = nil; if (!fmt) { fmt = [[NEIFormat alloc] initFromIcnsType:_kname]; } return fmt; };
+ (instancetype) kinfo { static NEIFormat *fmt = nil; if (!fmt) { fmt = [[NEIFormat alloc] initFromIcnsType:_kinfo]; } return fmt; };
+ (instancetype) ksbtp { static NEIFormat *fmt = nil; if (!fmt) { fmt = [[NEIFormat alloc] initFromIcnsType:_ksbtp]; } return fmt; };
+ (instancetype) kslct { static NEIFormat *fmt = nil; if (!fmt) { fmt = [[NEIFormat alloc] initFromIcnsType:_kslct]; } return fmt; };
+ (instancetype) kdark { static NEIFormat *fmt = nil; if (!fmt) { fmt = [[NEIFormat alloc] initFromIcnsType:_kdark]; } return fmt; };

+ (instancetype)nearestNEIFormatForImage:(NSImage*)image
{
  NSSize inputSize = [image size];
  CGFloat inputArea = inputSize.width * inputSize.height;
  CGFloat minDifference = CGFLOAT_MAX;
  NEIFormat* nearestType = nil;
  
  for (NEIFormat* format in [self allIconFormats])
  {
    CGFloat typeArea = [format area];
    CGFloat difference = fabs(typeArea - inputArea);
    
    if (difference < minDifference)
    {
      minDifference = difference;
      nearestType = format;
    }
  }

  return nearestType;
}

+ (NSArray<NEIFormat*>*)standardFormats
{
  return @[
    [NEIFormat kicp4],
    [NEIFormat kic11],
    [NEIFormat kicp5],
    [NEIFormat kic12],
    [NEIFormat kicp6],
    [NEIFormat kic07],
    [NEIFormat kic13],
    [NEIFormat kic08],
    [NEIFormat kic14],
    [NEIFormat kic09],
    [NEIFormat kic10]
  ];
}

+ (NSArray<NEIFormat*>*) allIconFormats;
{
  return @[
    [NEIFormat kICON], [NEIFormat kICN_], [NEIFormat kicm_],
    [NEIFormat kicm4], [NEIFormat kicm8], [NEIFormat kics_],
    [NEIFormat kics4], [NEIFormat kics8], [NEIFormat kis32],
    [NEIFormat ks8mk], [NEIFormat kicl4], [NEIFormat kicl8],
    [NEIFormat kil32], [NEIFormat kl8mk], [NEIFormat kich_],
    [NEIFormat kich4], [NEIFormat kich8], [NEIFormat kih32],
    [NEIFormat kh8mk], [NEIFormat kit32], [NEIFormat kt8mk],
    [NEIFormat kicp4], [NEIFormat kicp5], [NEIFormat kicp6],
    [NEIFormat kic07], [NEIFormat kic08], [NEIFormat kic09],
    [NEIFormat kic10], [NEIFormat kic11], [NEIFormat kic12],
    [NEIFormat kic13], [NEIFormat kic14], [NEIFormat kic04],
    [NEIFormat kic05], [NEIFormat kicsb], [NEIFormat kicsB],
    [NEIFormat ksb24], [NEIFormat kSB24]
  ];
}

+ (NSArray<NEIFormat*>*) allFormats
{
  return @[
    [NEIFormat kICON], [NEIFormat kICN_], [NEIFormat kicm_],
    [NEIFormat kicm4], [NEIFormat kicm8], [NEIFormat kics_],
    [NEIFormat kics4], [NEIFormat kics8], [NEIFormat kis32],
    [NEIFormat ks8mk], [NEIFormat kicl4], [NEIFormat kicl8],
    [NEIFormat kil32], [NEIFormat kl8mk], [NEIFormat kich_],
    [NEIFormat kich4], [NEIFormat kich8], [NEIFormat kih32],
    [NEIFormat kh8mk], [NEIFormat kit32], [NEIFormat kt8mk],
    [NEIFormat kicp4], [NEIFormat kicp5], [NEIFormat kicp6],
    [NEIFormat kic07], [NEIFormat kic08], [NEIFormat kic09],
    [NEIFormat kic10], [NEIFormat kic11], [NEIFormat kic12],
    [NEIFormat kic13], [NEIFormat kic14], [NEIFormat kic04],
    [NEIFormat kic05], [NEIFormat kicsb], [NEIFormat kicsB],
    [NEIFormat ksb24], [NEIFormat kSB24],

    [NEIFormat kTOC_], [NEIFormat kicnV], [NEIFormat kname],
    [NEIFormat kinfo], [NEIFormat ksbtp], [NEIFormat kslct],
    [NEIFormat kdark]
  ];
}

+ (instancetype)identifier:(uint32_t)identifier
{
  for (NEIFormat* fmt in [self allFormats])
  {
    if (fmt.id == identifier)
      return fmt;
    
    if (identifier == (uint32_t)'dark' && fmt.id == [[self kdark] id])
      return fmt;
  }
  
  return nil;
}

+ (instancetype)matchingType:(CGFloat)widthOrHeight
                preferRetina:(BOOL)preferRetina
{
  NEIFormat* possibleFormat = nil;
  
  for (NEIFormat* fmt in [self allIconFormats])
  {
    if (fmt.pixelSize.width == widthOrHeight)
    {
      if (preferRetina)
      {
        if ([fmt retina])
          return fmt;
        else
          possibleFormat = fmt;
      }
      else
        return fmt;
    }
  }
  
  if (possibleFormat)
    return possibleFormat;
  
  return nil;
}

// MARK: Private Initializers

- (instancetype) init
{
  return [super init];
}

- (instancetype) initFromIcnsType:(ICNSType)type
{
  self = [super init];
  if (self)
  {
    [self osType:type.osType];
    [self length:type.length];
    [self pixelSize:type.pixelSize];
    [self imageFormat:type.imageTypes];
    [self minOS:type.minOSSupport];
    [self about:type.description];
  }
  return self;
}

// MARK: Private Setters -
- (void)osType:(NEIIdentifier)osType { _id = osType; }
- (void)length:(NEIExpectedSize)length { _length = length; }
- (void)pixelSize:(NEIPixelSize)pixelSize { _pixelSize = pixelSize; }
- (void)imageFormat:(NEIFeature)imageTypes { _features = imageTypes; }
- (void)minOS:(NEIOSSupport)minOS { _minOSSupport = minOS; }
- (void)about:(NSString*)about { _about = about; }

@end
