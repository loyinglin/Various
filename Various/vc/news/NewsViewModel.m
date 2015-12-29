//
//  NewsViewModel.m
//  Various
//
//  Created by 林伟池 on 15/11/29.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "NewsViewModel.h"
#import "NSDictionary+LYDictToObject.h"

#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa.h>

@implementation NewsData


@end


@implementation NewsViewModel
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
        
        NSString *httpUrl = @"http://api.huceo.com/social/other";
        NSString *httpArg;
        
        if (self.myRand.integerValue) {
            httpArg = [NSString stringWithFormat:@"num=10&rand=%ld", self.myRand.integerValue];
        }
        else{
            httpArg = [NSString stringWithFormat:@"num=10&page=%ld", myPage];
        }
        httpArg = [NSString stringWithFormat:@"%@&key=%@", httpArg, @"f4e2a3fc734cd04539610ddff313925f"];
        
        
        NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, httpArg];
        NSURL *url = [NSURL URLWithString: urlStr];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
        [request setHTTPMethod: @"GET"];
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
         NSArray* arr = [dict objectForKey:@"newslist"];
         NSMutableArray* newData = [NSMutableArray array];
         
         for (NSDictionary* data in arr) {
             if (data) {
                 NewsData* item = [data objectForClass:[NewsData class]];
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


- (NewsData*)getDataByIndex:(long)index{
    NewsData* ret;
    
    if (index >= 0 && index < self.myDataArr.count) {
        ret = [self.myDataArr objectAtIndex:index];
    }
    
    return ret;
}


#pragma mark - update



#pragma mark - message

@end
