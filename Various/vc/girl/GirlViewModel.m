//
//  GirlViewModel.m
//  Various
//
//  Created by 林伟池 on 15/11/30.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "GirlViewModel.h"
#import "NSDictionary+LYDictToObject.h"

#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa.h>

@implementation GirlData



@end


@implementation GirlViewModel
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
    myPage = 1;
    self.myDataArr = [NSArray array];
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
        
        NSString *httpUrl = @"http://apis.baidu.com/txapi/mvtp/meinv";
        NSString *httpArg = [NSString stringWithFormat:@"num=%d", 15 + 1]; //api bug
        
        
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
         for (int i = 0; i < 15; ++i) {
             NSString* key = [NSString stringWithFormat:@"%d", i];
             NSDictionary*  data = [dict objectForKey:key];
             if (data) {
                 GirlData* item = [data objectForClass:[GirlData class]];
                 if (item) {
                     [newData addObject:item];
                 }
                 else{
                     NSLog(@"%d emtpy", i);
                 }
             }
             else{
                 NSLog(@"%d emtpy", i);
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


- (GirlData*)getDataByIndex:(long)index{
    GirlData* ret;
    
    if (index >= 0 && index < self.myDataArr.count) {
        ret = [self.myDataArr objectAtIndex:index];
    }
    
    return ret;
}


#pragma mark - update



@end
