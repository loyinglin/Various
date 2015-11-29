//
//  NSDictionary+LYDictToObject.h
//  Supermark
//
//  Created by 林伟池 on 15/8/4.
//  Copyright (c) 2015年 林伟池. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (LYDictToObject)


#pragma mark -

#undef	CONVERT_PROPERTY_CLASS
#define	CONVERT_PROPERTY_CLASS( __name, __class ) \
+ (Class)convertPropertyClassFor_##__name \
{ \
return NSClassFromString( [NSString stringWithUTF8String:#__class] ); \
}

#pragma mark -


- (id)objectForClass:(Class)clazz;

@end
