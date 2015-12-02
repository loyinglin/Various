//
//  NewsViewModel.m
//  Various
//
//  Created by 林伟池 on 15/11/29.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "CookSubCategoryViewModel.h"
#import "NSDictionary+LYDictToObject.h"

#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa.h>

@implementation CookSubCategoryData


@end


@implementation CookSubCategoryViewModel
{
    long myPage;
    long myCategoryId;
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


- (void)requestUpdateDataWithId:(long)categoryId {
    myPage = 1;
    myCategoryId = categoryId;
    [self requestData];
}

- (void)loadMoreData {
    ++myPage;
    [self requestData];
}

- (void)requestData{
    
    @weakify(self);
    [[[RACSignal startLazilyWithScheduler:[RACScheduler currentScheduler] block:^(id<RACSubscriber> subscriber) {
        
        NSString *httpUrl = @"http://apis.baidu.com/tngou/cook/list";
        NSString *httpArg = [NSString stringWithFormat:@"id=%ld&page=%ld&rows=20", myCategoryId, myPage];
        
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
                                           NSArray* result = [dict objectForKey:@"tngou"];
                                           NSLog(@"total %@", [dict objectForKey:@"total"]);
                                           [subscriber sendNext:result];
                                       }
                                   }
                               }];
    }]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(NSArray* arr) {
         @strongify(self);
         NSMutableArray* newData = [NSMutableArray array];
         
         for (NSDictionary* dict in arr) {
             CookSubCategoryData* item = [dict objectForClass:[CookSubCategoryData class]];
             [newData addObject:item];
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


- (CookSubCategoryData*)getDataByIndex:(long)index{
    CookSubCategoryData* ret;
    
    if (index >= 0 && index < self.myDataArr.count) {
        ret = [self.myDataArr objectAtIndex:index];
    }
    
    return ret;
}


#pragma mark - update



#pragma mark - message

@end
