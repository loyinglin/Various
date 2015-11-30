//
//  WeixinHotViewModel.m
//  Various
//
//  Created by 林伟池 on 15/11/29.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "WeixinHotViewModel.h"
#import "NSDictionary+LYDictToObject.h"

#import <ReactiveCocoa/RACEXTScope.h>
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
    return self;
}

#pragma mark - set

- (void)updateHotData{
    myPage = 1;
    [self requestData];
}

- (void)loadMoreData{
    ++myPage;
    [self requestData];
}

- (void)requestData{
    
    @weakify(self);
    [[[RACSignal startLazilyWithScheduler:[RACScheduler currentScheduler] block:^(id<RACSubscriber> subscriber) {
        
        NSString *httpUrl = @"http://apis.baidu.com/txapi/weixin/wxhot";
        NSString *httpArg;
        
        if (self.myRand.integerValue) {
            httpArg = [NSString stringWithFormat:@"num=10&rand=%ld", self.myRand.integerValue];
        }
        else{
            httpArg = [NSString stringWithFormat:@"num=10&page=%ld", myPage];
        }
        
        NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, httpArg];
        NSURL *url = [NSURL URLWithString: urlStr];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
        [request setHTTPMethod: @"GET"];
        [request addValue: @"d233f5dfd98c24f5d9e595af6e5c9fac" forHTTPHeaderField: @"apikey"];
        [NSURLConnection sendAsynchronousRequest: request
                                           queue: [NSOperationQueue mainQueue]
                               completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                                   if (error) {
                                       
                                   } else {
                                       NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                       if (responseCode == 200) {
                                           NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                           NSNumber* result = [dict objectForKey:@"code"];
                                           if ([result integerValue] == 200) {
                                               [subscriber sendNext:dict];
                                           }
                                           else {
                                               
                                           }
                                           
                                       }
                                       else{
                                           
                                       }
                                   }
                               }];
    }]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(NSDictionary* dict) {
         @strongify(self);
         NSMutableArray* newData = [NSMutableArray array];
         for (int i = 0; i < 10; ++i) {
             NSString* key = [NSString stringWithFormat:@"%d", i];
             NSDictionary*  data = [dict objectForKey:key];
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
}
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
