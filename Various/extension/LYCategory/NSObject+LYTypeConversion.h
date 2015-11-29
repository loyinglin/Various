//
//  LYTpyeEncoding.h
//  Supermark
//
//  Created by 林伟池 on 15/8/4.
//  Copyright (c) 2015年 林伟池. All rights reserved.
//

#import <Foundation/Foundation.h>



#pragma mark -

@interface NSObject(LYTypeConversion)

- (NSInteger)asInteger;
- (float)asFloat;
- (BOOL)asBool;

- (NSNumber *)asNSNumber;
- (NSString *)asNSString;
- (NSDate *)asNSDate;
- (NSData *)asNSData;	// TODO
- (NSArray *)asNSArray;

- (NSMutableArray *)asNSMutableArray;

- (NSDictionary *)asNSDictionary;
- (NSMutableDictionary *)asNSMutableDictionary;

@end
