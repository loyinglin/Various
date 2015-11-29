//
//  NSDictionary+LYDictToObject.m
//  Supermark
//
//  Created by 林伟池 on 15/8/4.
//  Copyright (c) 2015年 林伟池. All rights reserved.
//

#import "NSDictionary+LYDictToObject.h"
#import "LYTypeEncoding.h"
#import "NSObject+LYTypeConversion.h"
#import <objc/runtime.h>

@implementation NSDictionary (LYDictToObject)

- (id)objectForClass:(Class)clazz
{
    if ( [clazz respondsToSelector:@selector(initFromDictionary:)] )
    {
        return [clazz performSelector:@selector(initFromDictionary:) withObject:self];
    }
    
    if ( [clazz respondsToSelector:@selector(fromDictionary:)] )
    {
        return [clazz performSelector:@selector(fromDictionary:) withObject:self];
    }
    
    id object = [[clazz alloc] init];
    if ( nil == object )
        return nil;
    
    for ( Class clazzType = clazz; clazzType != [NSObject class]; )
    {
        unsigned int		propertyCount = 0;
        objc_property_t *	properties = class_copyPropertyList( clazzType, &propertyCount );
        
        for ( NSUInteger i = 0; i < propertyCount; i++ )
        {
            const char *	name = property_getName(properties[i]);
            NSString *		propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
            const char *	attr = property_getAttributes(properties[i]);
            NSUInteger		type = [LYTypeEncoding typeOf:attr];
            
            BOOL readonly = [LYTypeEncoding isReadOnly:attr];
            if ( readonly )
                continue;
            
            NSObject *	tempValue = [self objectForKey:propertyName];
            NSObject *	value = nil;
            
            if ( tempValue )
            {
                if ( NSNUMBER == type )
                {
                    value = [tempValue asNSNumber];
                }
                else if ( NSSTRING == type )
                {
                    value = [tempValue asNSString];
                }
                else if ( NSDATE == type )
                {
                    value = [tempValue asNSDate];
                }
                else if ( NSARRAY == type )
                {
                    if ( [tempValue isKindOfClass:[NSArray class]] )
                    {
                        SEL convertSelector = NSSelectorFromString( [NSString stringWithFormat:@"convertPropertyClassFor_%@", propertyName] );
                        if ( [clazz respondsToSelector:convertSelector] )
                        {
                            Class convertClass = [clazz performSelector:convertSelector];
                            if ( convertClass )
                            {
                                NSMutableArray * arrayTemp = [NSMutableArray array];
                                
                                for ( NSObject * tempObject in (NSArray *)tempValue )
                                {
                                    if ( [tempObject isKindOfClass:[NSDictionary class]] )
                                    {
                                        [arrayTemp addObject:[(NSDictionary *)tempObject objectForClass:convertClass]];
                                    }
                                }
                                
                                value = arrayTemp;
                            }
                            else
                            {
                                value = tempValue;
                            }
                        }
                        else
                        {
                            value = tempValue;
                        }
                    }
                }
                else if ( NSDICTIONARY == type )
                {
                    if ( [tempValue isKindOfClass:[NSDictionary class]] )
                    {
                        SEL convertSelector = NSSelectorFromString( [NSString stringWithFormat:@"convertPropertyClassFor_%@", propertyName] );
                        if ( [clazz respondsToSelector:convertSelector] )
                        {
                            Class convertClass = [clazz performSelector:convertSelector];
                            if ( convertClass )
                            {
                                value = [(NSDictionary *)tempValue objectForClass:convertClass];
                            }
                            else
                            {
                                value = tempValue;
                            }
                        }
                        else
                        {
                            value = tempValue;
                        }
                    }
                }
                else if ( OBJECT == type )
                {
                    NSString * className = [LYTypeEncoding classNameOfAttribute:attr];
                    if ( [tempValue isKindOfClass:NSClassFromString(className)] )
                    {
                        value = tempValue;
                    }
                    else if ( [tempValue isKindOfClass:[NSDictionary class]] )
                    {
                        value = [(NSDictionary *)tempValue objectForClass:NSClassFromString(className)];
                    }
                }
            }
            
            if ( nil != value )
            {
                [object setValue:value forKey:propertyName];
            }
        }
        
        clazzType = class_getSuperclass( clazzType );
        if ( nil == clazzType )
            break;
        
        free(properties);
    }
    
    return object;
}

@end
