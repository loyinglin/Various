//
//  GirlViewModel.m
//  Various
//
//  Created by 林伟池 on 15/11/30.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "CookViewModel.h"
#import "NSDictionary+LYDictToObject.h"

#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa.h>

@implementation CookCategoryData


@end


@implementation CookViewModel
{
    long myPage;
    NSMutableDictionary* myDict;
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
    myPage = 1;
    myDict = [[NSMutableDictionary alloc] init];
    self.myDataArr = [NSArray array];
    return self;
}

#pragma mark - set

- (void)requestCategoryWithId:(long)categoryId{
    
    @weakify(self);
    [[[RACSignal startLazilyWithScheduler:[RACScheduler currentScheduler] block:^(id<RACSubscriber> subscriber) {
        
        NSString *httpUrl = @"http://apis.baidu.com/tngou/cook/classify";
        NSString *httpArg = [NSString stringWithFormat:@"id=%ld", categoryId]; //api bug
        
        
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
                                           NSArray* arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                           if (arr.count) {
                                               [subscriber sendNext:arr];
                                           }

                                           
                                       }
                                       else{
                                           
                                       }
                                   }
                               }];
    }]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(NSArray* arr) {
         @strongify(self);
         
         NSMutableArray* newArr = [NSMutableArray array];
         for (NSDictionary* dict in arr) {
             CookCategoryData* item = [dict objectForClass:[CookCategoryData class]];
             [newArr addObject:item];
         }
         
         self.myDataArr = newArr;
     }];
}

- (void)requestUpdateCategoryByIndex:(long)index {
    NSString* key = [NSString stringWithFormat:@"%ld", [self getHeadByIndex:index].id.integerValue];
    if (!myDict[key]) {
        @weakify(self);
        [[[RACSignal startLazilyWithScheduler:[RACScheduler currentScheduler] block:^(id<RACSubscriber> subscriber) {
            
            NSString *httpUrl = @"http://apis.baidu.com/tngou/cook/classify";
            NSString *httpArg = [NSString stringWithFormat:@"id=%ld", [self getHeadByIndex:index].id.integerValue]; //api bug
            
            
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
                                               NSArray* arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                               if (arr.count) {
                                                   [subscriber sendNext:arr];
                                               }
                                               
                                               
                                           }
                                           else{
                                               
                                           }
                                       }
                                   }];
        }]
          deliverOn:[RACScheduler mainThreadScheduler]]
         subscribeNext:^(NSArray* arr) {
             @strongify(self);
             
             NSMutableArray* newArr = [NSMutableArray array];
             for (NSDictionary* dict in arr) {
                 CookCategoryData* item = [dict objectForClass:[CookCategoryData class]];
                 [newArr addObject:item];
             }
             
             myDict[key] = newArr;
             self.myUpdate = @(!self.myUpdate.boolValue);
         }];
    }
    else {
        self.myUpdate = @(!self.myUpdate.boolValue);
    }
}
#pragma mark - get

- (long)getHeadCount {
    return self.myDataArr.count;
}


- (CookCategoryData*)getHeadByIndex:(long)index {
    CookCategoryData* ret;
    
    if (index >= 0 && index < self.myDataArr.count) {
        ret = [self.myDataArr objectAtIndex:index];
    }
    
    return ret;
}

- (long)getDetailCountByIndex:(long)index {
    
    NSString* key = [NSString stringWithFormat:@"%ld", [self getHeadByIndex:index].id.integerValue];
    NSArray* arr = myDict[key];
    return arr.count;
}

- (NSArray *)getDetailByIndex:(long)index {
    NSString* key = [NSString stringWithFormat:@"%ld", [self getHeadByIndex:index].id.integerValue];
    return myDict[key];
}
#pragma mark - update



@end
