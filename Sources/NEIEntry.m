//
//  NEIEntry.m
//  Icon Stamper
//
//  Created by Brielle Harrison on 3/28/23.
//  Copyright © 2023 Brielle Harrison. All rights reserved.
//

#import <AppKit/AppKit.h>
#import <ImageIO/ImageIO.h>
#import "NEIEntry.h"

@interface NEIEntry()
- (CGFloat)colorDistance:(NSColor *)color1 toColor:(NSColor *)color2;
- (NSBitmapImageRep *)bitmapImageRep;
@end

@implementation NEIEntry

- (instancetype)init
{
  return [super init];
}

- (instancetype)initWithFormat:(NEIFormat*)format
{
  self = [super init];
  if (self)
  {
    _format = format;
  }
  return self;
}

- (instancetype)initWithFormat:(NEIFormat*)format andData:(NSData*)data
{
  self = [super init];
  if (self)
  {
    _format = format;
    if (data)
    {
      _data = [data copy];
      _size = (uint32_t)[data length];
    }
  }
  return self;
}

- (instancetype)initWithFormat:(NEIFormat*)format
                       andSize:(uint32_t)size
                       andData:(NSData*)data
{
  self = [self initWithFormat:format andData:data];
  if (self)
    self.size = size;
  return self;
}

- (instancetype)initWithIdentifier:(uint32_t)identifier
{
  return [self initWithFormat:[NEIFormat identifier:identifier]];
}

- (instancetype)initWithIdentifier:(uint32_t)identifier
                           andData:(NSData*)data
{
  return [self initWithFormat:[NEIFormat identifier:identifier]
                      andData: data];
}

- (instancetype)initWithIdentifier:(uint32_t)identifier
                           andSize:(uint32_t)size
                           andData:(NSData*)data
{
  self = [self initWithIdentifier:identifier andData:data];
  if (self)
    self.size = size;
  return self;
}


+ (instancetype)format:(NEIFormat*)format
{
  return [[NEIEntry alloc] initWithFormat:format];
}

+ (instancetype)format:(NEIFormat*)format data:(NSData*)data
{
  return [[NEIEntry alloc] initWithFormat:format andData:data];
}

+ (instancetype)format:(NEIFormat*)format
                  size:(uint32_t)size
                  data:(NSData*)data
{
  return [[NEIEntry alloc] initWithFormat:format andSize:size andData:data];
}

+ (instancetype)identifier:(uint32_t)identifier
{
  return [[NEIEntry alloc] initWithIdentifier:identifier];
}

+ (instancetype)identifier:(uint32_t)identifier data:(NSData*)data
{
  return [[NEIEntry alloc] initWithIdentifier:identifier andData:data];
}

+ (instancetype)identifier:(uint32_t)identifier
                      size:(uint32_t)size
                      data:(NSData*)data
{
  return [[NEIEntry alloc] initWithIdentifier:identifier
                                      andSize:size
                                      andData:data];
}


- (uint32_t)id
{
  if (!_format)
    return 0;
  
  return [_format iconType];
}

- (NSBitmapImageRep *)bitmapImageRep {
  if (!_data) return nil;
  
  CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)self.data, NULL);
  if (!source) {
    return nil;
  }
  
  CGImageRef cgImage = CGImageSourceCreateImageAtIndex(source, 0, NULL);
  if (!cgImage) {
    CFRelease(source);
    return nil;
  }
  
  NSBitmapImageRep *bitmapRep = [[NSBitmapImageRep alloc] initWithCGImage:cgImage];
  CGImageRelease(cgImage);
  CFRelease(source);
  
  return bitmapRep;
}

- (NSData *)dataAsRecommended
{
  if ([_format supportsPNG])
    return [self dataAsPNG];
  else if ([_format supportsJPEG2000])
    return [self dataAsJPEG2000];
  else if ([_format supportsARGB])
    return [self dataAsARGB];
  else if ([_format supports24Bit])
    return [self dataAs24BitRGB];
  else if ([_format supports8Bit])
    return [self dataAs8Bit];
  
  return self.data;
}

- (NSData *)dataAsPNG {
  if (!_data) return nil;
  
  NSBitmapImageRep *bitmapRep = [self bitmapImageRep];
  return [bitmapRep representationUsingType:NSBitmapImageFileTypePNG properties:@{}];
}

- (NSData *)dataAsJPEG2000 {
  if (!_data) return nil;
  
  NSBitmapImageRep *bitmapRep = [self bitmapImageRep];
  return [bitmapRep representationUsingType:NSBitmapImageFileTypeJPEG2000 properties:@{}];
}

- (NSData *)dataAsARGB {
  if (!_data) return nil;
  
  NSBitmapImageRep *bitmapRep = [self bitmapImageRep];
  
  NSInteger width = [bitmapRep pixelsWide];
  NSInteger height = [bitmapRep pixelsHigh];
  NSInteger bytesPerRow = width * 4;
  
  NSMutableData *argbData = [NSMutableData dataWithLength:height * bytesPerRow];
  uint8_t *argbBytes = (uint8_t *)[argbData mutableBytes];
  
  for (NSInteger y = 0; y < height; y++) {
    for (NSInteger x = 0; x < width; x++) {
      NSInteger i = y * width + x;
      NSColor *color = [bitmapRep colorAtX:x y:y];
      CGFloat red, green, blue, alpha;
      [color getRed:&red green:&green blue:&blue alpha:&alpha];
      
      argbBytes[i * 4 + 0] = alpha * 255;
      argbBytes[i * 4 + 1] = red * 255;
      argbBytes[i * 4 + 2] = green * 255;
      argbBytes[i * 4 + 3] = blue * 255;
    }
  }
  
  return [argbData copy];
}

- (NSData *)dataAs24BitRGB {
  if (!_data) return nil;
  
  NSBitmapImageRep *bitmapRep = [self bitmapImageRep];
  
  NSInteger width = [bitmapRep pixelsWide];
  NSInteger height = [bitmapRep pixelsHigh];
  NSInteger bytesPerRow = width * 3;
  
  NSMutableData *rgbData = [NSMutableData dataWithLength:height * bytesPerRow];
  uint8_t *rgbBytes = (uint8_t *)[rgbData mutableBytes];
  
  for (NSInteger y = 0; y < height; y++) {
    for (NSInteger x = 0; x < width; x++) {
      NSInteger i = y * width + x;
      NSColor *color = [bitmapRep colorAtX:x y:y];
      CGFloat red, green, blue;
      [color getRed:&red green:&green blue:&blue alpha:NULL];
      
      rgbBytes[i * 3 + 0] = red * 255;
      rgbBytes[i * 3 + 1] = green * 255;
      rgbBytes[i * 3 + 2] = blue * 255;
    }
  }
  
  return [rgbData copy];
}

- (NSData *)dataAs8Bit {
  if (!_data) return nil;
  
  NSBitmapImageRep *bitmapRep = [self bitmapImageRep];
  return [bitmapRep representationUsingType:NSBitmapImageFileTypeGIF
                                 properties:@{NSImageDitherTransparency:@YES}];
}

- (NSData *)dataAs8BitMask {
  if (!_data) return nil;
  
  NSBitmapImageRep *bitmapRep = [self bitmapImageRep];
  
  NSInteger width = [bitmapRep pixelsWide];
  NSInteger height = [bitmapRep pixelsHigh];
  NSInteger bytesPerRow = width;
  
  NSMutableData *maskData = [NSMutableData dataWithLength:height * bytesPerRow];
  uint8_t *maskBytes = (uint8_t *)[maskData mutableBytes];
  
  for (NSInteger y = 0; y < height; y++) {
    for (NSInteger x = 0; x < width; x++) {
      NSInteger i = y * width + x;
      NSColor *color = [bitmapRep colorAtX:x y:y];
      CGFloat alpha = color.alphaComponent;
      
      maskBytes[i] = alpha * 255;
    }
  }
  
  return [maskData copy];
}

- (NSData *)dataAs4Bit {
  if (!_data) return nil;
  
  NSBitmapImageRep *bitmapRep = [self bitmapImageRep];
  
  NSInteger width = [bitmapRep pixelsWide];
  NSInteger height = [bitmapRep pixelsHigh];
  NSInteger bytesPerRow = (width + 1) / 2;
  
  NSMutableData *fourBitData = [NSMutableData dataWithLength:height * bytesPerRow];
  uint8_t *fourBitBytes = (uint8_t *)[fourBitData mutableBytes];
  
  // You may need to customize this color table based on the specific 4-bit color palette used.
  NSArray<NSColor *> *colorTable = @[
    [NSColor blackColor],
    [NSColor whiteColor],
    [NSColor redColor],
    [NSColor greenColor],
    [NSColor blueColor],
    [NSColor cyanColor],
    [NSColor yellowColor],
    [NSColor magentaColor],
    [NSColor grayColor],
    [NSColor lightGrayColor],
    [NSColor darkGrayColor],
    [NSColor colorWithWhite:0.25 alpha:1.0],
    [NSColor colorWithWhite:0.5 alpha:1.0],
    [NSColor colorWithWhite:0.75 alpha:1.0],
    [NSColor colorWithWhite:0.875 alpha:1.0],
    [NSColor colorWithWhite:0.625 alpha:1.0]
  ];
  
  for (NSInteger y = 0; y < height; y++) {
    for (NSInteger x = 0; x < width; x++) {
      NSInteger i = y * width + x;
      NSColor *color = [bitmapRep colorAtX:x y:y];
      
      // Find the nearest color in the color table.
      NSUInteger nearestColorIndex = 0;
      CGFloat minDistance = CGFLOAT_MAX;
      for (NSUInteger j = 0; j < colorTable.count; j++) {
        CGFloat distance = [self colorDistance:color toColor:colorTable[j]];
        if (distance < minDistance) {
          minDistance = distance;
          nearestColorIndex = j;
        }
      }
      
      if (x % 2 == 0) {
        fourBitBytes[y * bytesPerRow + x / 2] = nearestColorIndex << 4;
      } else {
        fourBitBytes[y * bytesPerRow + x / 2] |= nearestColorIndex;
      }
    }
  }
  
  return [fourBitData copy];
}

- (NSData *)dataAs1BitMonoIcon {
  if (!_data) return nil;
  
  NSBitmapImageRep *bitmapRep = [self bitmapImageRep];
  
  NSInteger width = [bitmapRep pixelsWide];
  NSInteger height = [bitmapRep pixelsHigh];
  NSInteger bytesPerRow = (width + 7) / 8;
  
  NSMutableData *monoData = [NSMutableData dataWithLength:height * bytesPerRow];
  uint8_t *monoBytes = (uint8_t *)[monoData mutableBytes];
  
  for (NSInteger y = 0; y < height; y++) {
    for (NSInteger x = 0; x < width; x++) {
      NSInteger i = y * width + x;
      NSColor *color = [bitmapRep colorAtX:x y:y];
      CGFloat brightness = color.brightnessComponent;
      
      if (x % 8 == 0) {
        monoBytes[y * bytesPerRow + x / 8] = 0;
      }
      
      if (brightness < 0.5) {
        monoBytes[y * bytesPerRow + x / 8] |= (1 << (7 - x % 8));
      }
    }
  }
  
  return [monoData copy];
}

- (NSData *)dataAs1BitMonoIconWithMask {
  if (!_data) return nil;
  
  NSBitmapImageRep *bitmapRep = [self bitmapImageRep];
  
  NSInteger width = [bitmapRep pixelsWide];
  NSInteger height = [bitmapRep pixelsHigh];
  NSInteger bytesPerRow = (width + 7) / 8;
  
  NSMutableData *monoData = [NSMutableData dataWithLength:height * bytesPerRow * 2];
  uint8_t *monoBytes = (uint8_t *)[monoData mutableBytes];
  
  for (NSInteger y = 0; y < height; y++) {
    for (NSInteger x = 0; x < width; x++) {
      NSInteger i = y * width + x;
      NSColor *color = [bitmapRep colorAtX:x y:y];
      CGFloat brightness = color.brightnessComponent;
      CGFloat alpha = color.alphaComponent;
      
      if (x % 8 == 0) {
        monoBytes[y * bytesPerRow + x / 8] = 0;
        monoBytes[(height + y) * bytesPerRow + x / 8] = 0;
      }
      
      if (brightness < 0.5) {
        monoBytes[y * bytesPerRow + x / 8] |= (1 << (7 - x % 8));
      }
      if (alpha >= 0.5) {
        monoBytes[(height + y) * bytesPerRow + x / 8] |= (1 << (7 - x % 8));
      }
    }
  }
  
  return [monoData copy];
}

- (CGFloat)colorDistance:(NSColor *)color1 toColor:(NSColor *)color2 {
  CGFloat rDiff = color1.redComponent - color2.redComponent;
  CGFloat gDiff = color1.greenComponent - color2.greenComponent;
  CGFloat bDiff = color1.blueComponent - color2.blueComponent;
  
  return rDiff * rDiff + gDiff * gDiff + bDiff * bDiff;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
  NEIEntry* copy = [[NEIEntry alloc] initWithIdentifier:self.id
                                                andData:[self.data copy]];
  if (self.size)
    copy.size = self.size;
  
  return copy;
}

@end
