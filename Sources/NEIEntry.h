//
//  NEIEntry.h
//  Icon Stamper
//
//  Created by Brielle Harrison on 3/28/23.
//  Copyright © 2023 Brielle Harrison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NEIFormat.h"

NS_ASSUME_NONNULL_BEGIN

@interface NEIEntry : NSObject<NSCopying>
@property (readwrite, retain) NEIFormat* format;
@property (readwrite, retain) NSData* data;
@property (readonly) uint32_t id;
@property (readwrite) uint32_t size;

- (instancetype)init;

- (instancetype)initWithFormat:(NEIFormat*)format;
- (instancetype)initWithFormat:(NEIFormat*)format andData:(NSData*)data;
- (instancetype)initWithFormat:(NEIFormat*)format
                       andSize:(uint32_t)size
                       andData:(NSData*)data;

- (instancetype)initWithIdentifier:(uint32_t)identifier;
- (instancetype)initWithIdentifier:(uint32_t)identifier andData:(NSData*)data;
- (instancetype)initWithIdentifier:(uint32_t)identifier
                           andSize:(uint32_t)size
                           andData:(NSData*)data;

+ (instancetype)format:(NEIFormat*)format;
+ (instancetype)format:(NEIFormat*)format data:(NSData*)data;
+ (instancetype)format:(NEIFormat*)format
                  size:(uint32_t)size
                  data:(NSData*)data;

+ (instancetype)identifier:(uint32_t)identifier;
+ (instancetype)identifier:(uint32_t)identifier data:(NSData*)data;
+ (instancetype)identifier:(uint32_t)identifier
                      size:(uint32_t)size
                       data:(NSData*)data;

- (NSData *)dataAsRecommended;
- (NSData *)dataAsPNG;
- (NSData *)dataAsJPEG2000;
- (NSData *)dataAsARGB;
- (NSData *)dataAs24BitRGB;
- (NSData *)dataAs8Bit;
- (NSData *)dataAs8BitMask;
- (NSData *)dataAs4Bit;
- (NSData *)dataAs1BitMonoIcon;
- (NSData *)dataAs1BitMonoIconWithMask;
@end

NS_ASSUME_NONNULL_END
