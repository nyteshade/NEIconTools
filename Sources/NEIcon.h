//
//  NEIcon.h
//  Icon Stamper
//
//  Created by Brielle Harrison on 3/27/23.
//  Copyright © 2023 Brielle Harrison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import "NEIFormat.h"
#import "NETuple.h"
#import "NEIEntry.h"

NS_ASSUME_NONNULL_BEGIN

@interface NEIcon : NSObject
@property (readonly) NSMutableArray<NEIEntry*>* formats ;

- (instancetype)initWithFormat:(NEIFormat*)format withImage:(NSImage*)image;
- (instancetype)initWithIdentifier:(uint32_t)identifier withImage:(NSImage*)image;
- (instancetype)initWithStandardFormatsFromImage:(NSImage*)image;
- (instancetype)initWithStandardFormatsFromImage:(NSImage*)image keepAspects:(BOOL)keepAspects;

+ (instancetype)format:(NEIFormat*)format withImage:(NSImage*)image;
+ (instancetype)identifier:(uint32_t)identifier withImage:(NSImage*)image;
+ (instancetype)standardFormatsFromImage:(NSImage*)image;

- (void)addFormat:(NEIFormat*)format;
- (void)addFormat:(NEIFormat*)format withImage:(NSImage* _Nullable)image;
- (void)addFormatId:(uint32_t)identifier withImage:(NSImage* _Nullable)image;

- (void)addFormats:(NEIFormat*)formats, ...;
- (void)addFormatIds:(uint32_t)formats, ...;
- (void)addFormatsArray:(NSArray<NEIFormat*>* _Nonnull)formats;

- (void)removeFormat:(NEIFormat*)format;
- (void)removeFormats:(NEIFormat*)formats, ...;
- (void)removeFormatIds:(uint32_t)formats, ...;

- (void)setImage:(NSImage*)image forFormat:(NEIFormat*)format;
- (void)setImage:(NSImage*)image forIdentifier:(uint32_t)identifier;

- (void)setImageForAllFormats:(NSImage*)image keepAspect:(BOOL)keepAspect;

- (NSImage*)imageForFormat:(NEIFormat*)format;
- (NSImage*)imageForIdentifier:(uint32_t)identifier;

- (BOOL)writeToFile:(NSString *)path;
@end

NS_ASSUME_NONNULL_END
