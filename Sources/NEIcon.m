//
//  NEIcon.m
//  Icon Stamper
//
//  Created by Brielle Harrison on 3/27/23.
//  Copyright © 2023 Brielle Harrison. All rights reserved.
//

#import "NEIcon.h"
#import "NSError+EasyMessage.h"
#import "NSArray+Filters.h"
#import "NSImage+Sizing.h"

#import <stdio.h>
#import <stdlib.h>
#import <stdarg.h>

@interface NEIcon()
- (NEIEntry *)entryForIdentifier:(uint32_t)type;
- (NEIEntry *)entryForFormat:(NEIFormat*)format;
@end

@implementation NEIcon
- (instancetype)initWithFormat:(NEIFormat*)format withImage:(NSImage*)image
{
  self = [super init];
  if (self)
  {
    _formats = [@[] mutableCopy];
    NSData* data = [image TIFFRepresentation];
    [_formats addObject:[NEIEntry format:format size:[data length] data:data]];
  }
  return self;
}

- (instancetype)initWithIdentifier:(uint32_t)identifier withImage:(NSImage*)image
{
  return [self initWithFormat:[NEIFormat identifier:identifier] withImage:image];
}

- (instancetype)initWithStandardFormatsFromImage:(NSImage*)image
{
  return [self initWithStandardFormatsFromImage:image keepAspects:YES];
}

- (instancetype)initWithStandardFormatsFromImage:(NSImage*)image
                                     keepAspects:(BOOL)keepAspects
{
  self = [super init];
  if (self)
  {
    _formats = [@[] mutableCopy];
    [self addFormatsArray:[NEIFormat standardFormats]];
    [self setImageForAllFormats:image keepAspect:keepAspects];
  }
  return self;
}

+ (instancetype)format:(NEIFormat*)format withImage:(NSImage*)image
{
  return [[NEIcon alloc] initWithFormat:format withImage:image];
}

+ (instancetype)identifier:(uint32_t)identifier withImage:(NSImage*)image
{
  return [[NEIcon alloc] initWithIdentifier:identifier withImage:image];
}

+ (instancetype)standardFormatsFromImage:(NSImage*)image
{
  return [[NEIcon alloc] initWithStandardFormatsFromImage:image];
}


- (void)addFormat:(NEIFormat*)format
{
  [_formats addObject:[NEIEntry format:format]];
}

- (void)addFormat:(NEIFormat*)format withImage:(NSImage* _Nullable)image
{
  NEIEntry *entry = [NEIEntry format:format data:[image TIFFRepresentation]];
  [_formats addObject:entry];
}

- (void)addFormatId:(uint32_t)identifier withImage:(NSImage* _Nullable)image
{
  NEIFormat* format = [NEIFormat identifier:identifier];
  if (!format)
    return;
  
  NEIEntry *entry = [NEIEntry format:format data:[image TIFFRepresentation]];
  [_formats addObject:entry];
}

- (void)addFormats:(NEIFormat*)formats, ...
{
  va_list args;
  va_start(args, formats);
  
  NEIFormat *format = nil;
  while(( format = va_arg(args, NEIFormat*)))
  {
    [_formats addObject:[NEIEntry format:format]];
  }
  
  va_end(args);
}

- (void)addFormatIds:(uint32_t)formats, ...
{
  va_list args;
  va_start(args, formats);
  
  uint32_t identifier;
  while (( identifier = va_arg(args, uint32_t)))
  {
    [_formats addObject:[NEIEntry format:[NEIFormat identifier:identifier]]];
  }
  
  va_end(args);
}

- (void)addFormatsArray:(NSArray<NEIFormat*>* _Nonnull)formats
{
  for (NEIFormat* format in formats)
  {
    [_formats addObject:[NEIEntry format:format]];
  }
}

- (void)removeFormat:(NEIFormat*)format
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier = %@", [format iconType]];
  [_formats removeObjectsInArray:[_formats filteredArrayUsingPredicate:predicate]];
}

- (void)removeFormats:(NEIFormat*)formats, ...
{
  va_list args;
  va_start(args, formats);
  
  
  
  NEIFormat *format = nil;
  while (( format = va_arg(args, NEIFormat*)))
  {
    [self removeFormat:format];
  }
  
  va_end(args);
}

- (void)removeFormatIds:(uint32_t)formats, ...
{
  va_list args;
  va_start(args, formats);
  
  uint32_t identifier;
  while (( identifier = va_arg(args, uint32_t)))
  {
    [self removeFormat:[NEIFormat identifier:identifier]];
  }
  
  va_end(args);

}

- (void)setImage:(NSImage*)image forFormat:(NEIFormat*)format
{
  NEIEntry *entry = [self entryForFormat:format];
  
  if (entry)
    entry.data = [image TIFFRepresentation];
}

- (void)setImage:(NSImage*)image forIdentifier:(uint32_t)identifier
{
  [self setImage:image forFormat:[NEIFormat identifier:identifier]];
}

- (void)setImageForAllFormats:(NSImage*)image keepAspect:(BOOL)keepAspect
{
  NSArray<NEIEntry*>* sortedEntries = [
    _formats sort:^NSComparisonResult(NEIEntry*  _Nonnull left,
                                      NEIEntry*  _Nonnull right) {
    if ([[left format] area] > [[right format] area]) return NSOrderedAscending;
    if ([[left format] area] < [[right format] area]) return NSOrderedDescending;
    return NSOrderedSame;
  }];
  
  for (NEIEntry* entry in sortedEntries)
  {
    NSImage* useImage;
    
    if (CGSizeEqualToSize(image.size, [[entry format] pixelSize]))
      useImage = image;
    else
    {
      useImage = [image isSquare]
      ? [NSImage image:image scaledToFillSize:[[entry format] pixelSize]]
      : [NSImage image:image scaledToFitSize:[[entry format] pixelSize]];
    }

    entry.data = [useImage TIFFRepresentation];
    entry.size = (uint32_t)[entry.data length];
  }
}

- (NSImage*)imageForFormat:(NEIFormat*)format
{
  NEIEntry* entry = [self entryForFormat:format];
  NSData* data = (entry) ? entry.data : nil;
  
  if (!data)
    return nil;
  
  return [[NSImage alloc] initWithData:data];
}

- (NSImage*)imageForIdentifier:(uint32_t)identifier
{
  return [self imageForFormat:[NEIFormat identifier:identifier]];
}

- (BOOL)writeToFile:(NSString *)path
{
  NSMutableData* outputData = [NSMutableData data];
  NSMutableDictionary<NEIEntry*,NSData*>* staging = [NSMutableDictionary new];
  
  uint32_t header = CFSwapInt32HostToBig('icns');
  [outputData appendBytes:&header length:sizeof(uint32_t)];
  
  uint32_t fileSize = sizeof(uint32_t) * 2; // Initial size for 'icns' header and file size
  for (NEIEntry *entry in _formats) {
    fileSize += entry.size;
  }
  uint32_t fileSizeSwapped = CFSwapInt32HostToBig(fileSize);
  [outputData appendBytes:&fileSizeSwapped length:sizeof(uint32_t)];
  
  // Create 'TOC ' entry if it doesn't exist
  NEIEntry *tocEntry = [self entryForIdentifier:'TOC '];
  if (!tocEntry) {
    NSMutableData *tocData = [NSMutableData data];
    for (NEIEntry *entry in _formats) {
      NSData* entryData = [entry dataAsRecommended];
      uint32_t typeSwapped = CFSwapInt32HostToBig(entry.id);
      uint32_t sizeSwapped = CFSwapInt32HostToBig((uint32_t)entryData.length + 8);
      [tocData appendBytes:&typeSwapped length:sizeof(uint32_t)];
      [tocData appendBytes:&sizeSwapped length:sizeof(uint32_t)];
      [staging setObject:entryData forKey:entry];
    }
    uint32_t tocSize = ((uint32_t)tocData.length + 8);
    tocEntry = [NEIEntry identifier:'TOC ' size:tocSize data:tocData];
  }
  
  // Write 'TOC ' entry
  uint32_t tocTypeSwapped = CFSwapInt32HostToBig(tocEntry.id);
  uint32_t tocSizeSwapped = CFSwapInt32HostToBig((uint32_t)tocEntry.data.length + 8);
  [outputData appendBytes:&tocTypeSwapped length:sizeof(uint32_t)];
  [outputData appendBytes:&tocSizeSwapped length:sizeof(uint32_t)];
  [outputData appendData:tocEntry.data];
  
  // Write other entries
  for (NEIEntry *entry in _formats) {
    if (entry.id != 'TOC ') {
      NSData* entryData = [staging objectForKey:entry];
      if (!entryData)
        entryData = [entry dataAsRecommended];
      
      uint32_t typeSwapped = CFSwapInt32HostToBig(entry.id);
      uint32_t sizeSwapped = CFSwapInt32HostToBig((uint32_t)entryData.length + 8);
      
      [outputData appendBytes:&typeSwapped length:sizeof(uint32_t)];
      [outputData appendBytes:&sizeSwapped length:sizeof(uint32_t)];
      [outputData appendData:entryData];
    }
  }
  
  uint32_t finalSizeSwapped = CFSwapInt32HostToBig((uint32_t)[outputData length] + 8);
  NSRange range = NSMakeRange(4, 4);
  
  [outputData replaceBytesInRange:range withBytes:&finalSizeSwapped];
  
  return [outputData writeToFile:path atomically:YES];
}

- (NEIEntry *)entryForFormat:(NEIFormat*)format
{
  for (NEIEntry *entry in _formats)
  {
    if (entry.id == format.id)
      return entry;
  }
  return nil;
}

- (NEIEntry *)entryForIdentifier:(uint32_t)type
{
  for (NEIEntry *entry in _formats)
  {
    if (entry.id == type)
      return entry;
  }
  return nil;
}
@end
