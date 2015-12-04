//
//  WeixinHotViewModel.h
//  Various
//
//  Created by 林伟池 on 15/11/29.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CookSearchData : NSObject

@property (nonatomic , strong) NSString* count;
@property (nonatomic , strong) NSString* food;
@property (nonatomic , strong) NSNumber* id;
@property (nonatomic , strong) NSString* img;
@property (nonatomic , strong) NSString* keywords;
@property (nonatomic , strong) NSString* name;
@property (nonatomic , strong) NSString* message;

@end


@interface CookSearchViewModel : NSObject

@property (nonatomic , strong) NSArray* myDataArr;

#pragma mark - init

#pragma mark - set

- (void)requestSearchWithName:(NSString *)name;

#pragma mark - get

- (long)getDataCount;

- (CookSearchData *)getDataByIndex:(long)index;


#pragma mark - update



#pragma mark - message


@end
