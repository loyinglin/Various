//
//  LYTpyeEncoding.m
//  Supermark
//
//  Created by 林伟池 on 15/8/4.
//  Copyright (c) 2015年 林伟池. All rights reserved.
//

#import "LYTypeEncoding.h"

@implementation LYTypeEncoding


+ (BOOL)isReadOnly:(const char *)attr
{
    if ( strstr(attr, "_ro") || strstr(attr, ",R") )
    {
        return YES;
    }
    
    return NO;
}

+ (NSUInteger)typeOf:(const char *)attr
{
    if ( attr[0] != 'T' )
        return UNKNOWN;
    
    const char * type = &attr[1];
    if ( type[0] == '@' )
    {
        if ( type[1] != '"' )
            return UNKNOWN;
        
        char typeClazz[128] = { 0 };
        
        const char * clazz = &type[2];
        const char * clazzEnd = strchr( clazz, '"' );
        
        if ( clazzEnd && clazz != clazzEnd )
        {
            unsigned int size = (unsigned int)(clazzEnd - clazz);
            strncpy( &typeClazz[0], clazz, size );
        }
        
        if ( 0 == strcmp((const char *)typeClazz, "NSNumber") )
        {
            return NSNUMBER;
        }
        else if ( 0 == strcmp((const char *)typeClazz, "NSString") )
        {
            return NSSTRING;
        }
        else if ( 0 == strcmp((const char *)typeClazz, "NSDate") )
        {
            return NSDATE;
        }
        else if ( 0 == strcmp((const char *)typeClazz, "NSArray") )
        {
            return NSARRAY;
        }
        else if ( 0 == strcmp((const char *)typeClazz, "NSDictionary") )
        {
            return NSDICTIONARY;
        }
        else
        {
            return OBJECT;
        }
    }
    else if ( type[0] == '[' )
    {
        return UNKNOWN;
    }
    else if ( type[0] == '{' )
    {
        return UNKNOWN;
    }
    else
    {
        if ( type[0] == 'c' || type[0] == 'C' )
        {
            return UNKNOWN;
        }
        else if ( type[0] == 'i' || type[0] == 's' || type[0] == 'l' || type[0] == 'q' )
        {
            return UNKNOWN;
        }
        else if ( type[0] == 'I' || type[0] == 'S' || type[0] == 'L' || type[0] == 'Q' )
        {
            return UNKNOWN;
        }
        else if ( type[0] == 'f' )
        {
            return UNKNOWN;
        }
        else if ( type[0] == 'd' )
        {
            return UNKNOWN;
        }
        else if ( type[0] == 'B' )
        {
            return UNKNOWN;
        }
        else if ( type[0] == 'v' )
        {
            return UNKNOWN;
        }
        else if ( type[0] == '*' )
        {
            return UNKNOWN;
        }
        else if ( type[0] == ':' )
        {
            return UNKNOWN;
        }
        else if ( 0 == strcmp(type, "bnum") )
        {
            return UNKNOWN;
        }
        else if ( type[0] == '^' )
        {
            return UNKNOWN;
        }
        else if ( type[0] == '?' )
        {
            return UNKNOWN;
        }
        else
        {
            return UNKNOWN;
        }
    }
    
    return UNKNOWN;
}

+ (NSUInteger)typeOfAttribute:(const char *)attr
{
    return [self typeOf:attr];
}

+ (NSUInteger)typeOfObject:(id)obj
{
    if ( nil == obj )
        return UNKNOWN;
    
    if ( [obj isKindOfClass:[NSNumber class]] )
    {
        return NSNUMBER;
    }
    else if ( [obj isKindOfClass:[NSString class]] )
    {
        return NSSTRING;
    }
    else if ( [obj isKindOfClass:[NSArray class]] )
    {
        return NSARRAY;
    }
    else if ( [obj isKindOfClass:[NSDictionary class]] )
    {
        return NSDICTIONARY;
    }
    else if ( [obj isKindOfClass:[NSDate class]] )
    {
        return NSDATE;
    }
    else if ( [obj isKindOfClass:[NSObject class]] )
    {
        return OBJECT;
    }
    
    return UNKNOWN;
}

+ (NSString *)classNameOf:(const char *)attr
{
    if ( attr[0] != 'T' )
        return nil;
    
    const char * type = &attr[1];
    if ( type[0] == '@' )
    {
        if ( type[1] != '"' )
            return nil;
        
        char typeClazz[128] = { 0 };
        
        const char * clazz = &type[2];
        const char * clazzEnd = strchr( clazz, '"' );
        
        if ( clazzEnd && clazz != clazzEnd )
        {
            unsigned int size = (unsigned int)(clazzEnd - clazz);
            strncpy( &typeClazz[0], clazz, size );
        }
        
        return [NSString stringWithUTF8String:typeClazz];
    }
    
    return nil;
}

+ (NSString *)classNameOfAttribute:(const char *)attr
{
    return [self classNameOf:attr];
}

+ (Class)classOfAttribute:(const char *)attr
{
    NSString * className = [self classNameOf:attr];
    if ( nil == className )
        return nil;
    
    return NSClassFromString( className );
}

+ (BOOL)isAtomClass:(Class)clazz
{
    if ( clazz == [NSArray class] || [[clazz description] isEqualToString:@"__NSCFArray"] )
        return YES;
    if ( clazz == [NSData class] )
        return YES;
    if ( clazz == [NSDate class] )
        return YES;
    if ( clazz == [NSDictionary class] )
        return YES;
    if ( clazz == [NSNull class] )
        return YES;
    if ( clazz == [NSNumber class] || [[clazz description] isEqualToString:@"__NSCFNumber"] )
        return YES;
    if ( clazz == [NSObject class] )
        return YES;
    if ( clazz == [NSString class] )
        return YES;
    if ( clazz == [NSURL class] )
        return YES;
    if ( clazz == [NSValue class] )
        return YES;
    
    return NO;
}


@end
