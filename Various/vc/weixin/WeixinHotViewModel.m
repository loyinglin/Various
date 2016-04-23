//
//  WeixinHotViewModel.m
//  Various
//
//  Created by 林伟池 on 15/11/29.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "WeixinHotViewModel.h"
#import "NSDictionary+LYDictToObject.h"
#import "LYhttpAPICenter.h"
#import <ReactiveCocoa.h>

@implementation WeixinHotData


@end


@implementation WeixinHotViewModel
{
    long myPage;
}

#pragma mark - init

+(instancetype) instance
{
    static id test;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        test = [[[self class] alloc] init];
    });
    return test;
}

- (instancetype)init{
    self = [super init];
    self.myDataArr = [NSArray array];
    myPage = 1;
    @weakify(self)
    self.myCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber* update) {
        if (update.intValue == command_type_refresh) {
            myPage = 1;
        }
        else {
            myPage++;
        }
        RACSignal* ret = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self)
            NSString *httpUrl = @"http://api.huceo.com/wxnew/other";
            NSString *httpArg;
            
            if (self.myRand.integerValue) {
                httpArg = [NSString stringWithFormat:@"num=10&rand=%ld", self.myRand.integerValue];
            }
            else{
                httpArg = [NSString stringWithFormat:@"num=10&page=%ld", myPage];
            }
            httpArg = [NSString stringWithFormat:@"%@&key=%@", httpArg, @"f4e2a3fc734cd04539610ddff313925f"];
            
            NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, httpArg];
            
            [[LYhttpAPICenter instance] lySendRequestWithGET:urlStr Param:nil Sucess:^(NSDictionary* dict) {
                NSNumber* result = [dict objectForKey:@"code"];
                if ([result integerValue] == 200) {
                    [subscriber sendNext:dict];
                    [subscriber sendCompleted];
                }
                else {
                    [subscriber sendError:nil];
                }
                
            } Fail:^(NSError *error) {
                [subscriber sendError:nil];
            }];
            return nil;
        }];
        
        [[ret deliverOn:[RACScheduler mainThreadScheduler]]
         subscribeNext:^(NSDictionary* dict) {
             @strongify(self);
             NSArray* arr = [dict objectForKey:@"newslist"];
             NSMutableArray* newData = [NSMutableArray array];
             
             for (NSDictionary* data in arr) {
                 if (data) {
                     WeixinHotData* item = [data objectForClass:[WeixinHotData class]];
                     item.auther = [data objectForKey:@"description"];
                     if (item) {
                         [newData addObject:item];
                     }
                 }
             }
             if (myPage == 1) {
                 self.myDataArr = newData;
             }
             else{
                 self.myDataArr = [self.myDataArr arrayByAddingObjectsFromArray:newData];
             }
         }];
        
        return ret;
    }];
    
    return self;
}

#pragma mark - set

#pragma mark - get

- (long)getDataCount{
    return self.myDataArr.count;
}


- (WeixinHotData*)getDataByIndex:(long)index{
    WeixinHotData* ret;
    
    if (index >= 0 && index < self.myDataArr.count) {
        ret = [self.myDataArr objectAtIndex:index];
    }
    
    return ret;
}


#pragma mark - update



#pragma mark - message

@end
