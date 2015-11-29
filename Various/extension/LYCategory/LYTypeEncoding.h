//
//  LYTpyeEncoding.h
//  Supermark
//
//  Created by 林伟池 on 15/8/4.
//  Copyright (c) 2015年 林伟池. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYTypeEncoding : NSObject


enum
{
    UNKNOWN,
    OBJECT,
    NSNUMBER,
    NSSTRING,
    NSARRAY,
    NSDICTIONARY,
    NSDATE,
};


+ (BOOL)isReadOnly:(const char *)attr;

+ (NSUInteger)typeOf:(const char *)attr;
+ (NSUInteger)typeOfAttribute:(const char *)attr;
+ (NSUInteger)typeOfObject:(id)obj;

+ (NSString *)classNameOf:(const char *)attr;
+ (NSString *)classNameOfAttribute:(const char *)attr;

+ (Class)classOfAttribute:(const char *)attr;

+ (BOOL)isAtomClass:(Class)clazz;




@end
