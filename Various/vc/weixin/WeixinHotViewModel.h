//
//  WeixinHotViewModel.h
//  Various
//
//  Created by 林伟池 on 15/11/29.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>

@interface WeixinHotData : NSObject

@property (nonatomic , strong) NSString* title;
@property (nonatomic , strong) NSString* auther;
@property (nonatomic , strong) NSString* picUrl;
@property (nonatomic , strong) NSString* url;
@property (nonatomic , strong) NSString* hottime;

@end

typedef NS_ENUM(int, TYPE_COMMAND){
    command_type_load_more = 0,
    command_type_refresh = 1
};


@interface WeixinHotViewModel : NSObject

@property (nonatomic , strong) NSArray* myDataArr;

@property (nonatomic) NSNumber* myRand;

@property (nonatomic , strong) RACCommand* myCommand;

@property (nonatomic , strong) RACSignal* myRefreshSignal;

#pragma mark - init

+ (instancetype)instance;

#pragma mark - set


#pragma mark - get

- (long)getDataCount;

- (WeixinHotData*)getDataByIndex:(long)index;


#pragma mark - update



#pragma mark - message


@end
