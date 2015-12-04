//
//  NewsViewModel.m
//  Various
//
//  Created by 林伟池 on 15/11/29.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "CookSearchViewModel.h"
#import "NSDictionary+LYDictToObject.h"

#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa.h>

@implementation CookSearchData


@end


@implementation CookSearchViewModel
{
}

#pragma mark - init

- (instancetype)init{
    self = [super init];
    self.myDataArr = [NSArray array];
    return self;
}

#pragma mark - set

- (void)requestSearchWithName:(NSString *)name {
    
    @weakify(self);
    [[[RACSignal startLazilyWithScheduler:[RACScheduler currentScheduler] block:^(id<RACSubscriber> subscriber) {
        
        NSString *httpUrl = @"http://apis.baidu.com/tngou/cook/name";
        NSString *httpArg = [NSString stringWithFormat:@"name=%@", name];
        
        NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, httpArg];
        urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
                                          
                                           NSLog(@"total %ld", arr.count);
                                           [subscriber sendNext:arr];
                                       }
                                   }
                               }];
    }]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(NSArray* arr) {
         @strongify(self);
         NSMutableArray* newData = [NSMutableArray array];
         
         for (NSDictionary* dict in arr) {
             CookSearchData* item = [dict objectForClass:[CookSearchData class]];
             [newData addObject:item];
         }
         self.myDataArr = newData;
     }];

}


#pragma mark - get

- (long)getDataCount{
    return self.myDataArr.count;
}


- (CookSearchData *)getDataByIndex:(long)index{
    CookSearchData* ret;
    
    if (index >= 0 && index < self.myDataArr.count) {
        ret = [self.myDataArr objectAtIndex:index];
    }
    
    return ret;
}


#pragma mark - update



#pragma mark - message

@end
