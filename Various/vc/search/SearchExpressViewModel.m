//
//  SearchExpressViewModel.m
//  Various
//
//  Created by 林伟池 on 15/11/27.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "SearchExpressViewModel.h"

@implementation SearchExpressViewModel


- (RACSignal*)signalForSearchExpressWithText:(NSString*)text Type:(NSString*)type{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSError* codeError = [NSError errorWithDomain:@"LYERROR" code:LYSearchExpressErrorCodeError userInfo:nil];
        NSError* apiError = [NSError errorWithDomain:@"LYERROR" code:LYSearchExpressErrorAPIError userInfo:nil];
        
        NSString *httpUrl = @"http://apis.baidu.com/ppsuda/waybillnoquery/waybillnotrace";
        NSString *httpArg = [NSString stringWithFormat:@"expresscode=%@&billno=%@", type, text];
        
        NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, httpArg];
        NSURL *url = [NSURL URLWithString: urlStr];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
        [request setHTTPMethod: @"GET"];
        [request addValue: @"d233f5dfd98c24f5d9e595af6e5c9fac" forHTTPHeaderField: @"apikey"];
        [NSURLConnection sendAsynchronousRequest: request
                                           queue: [NSOperationQueue mainQueue]
                               completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                                   if (error) {
                                       [subscriber sendError:apiError];
                                   } else {
                                       NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                       if (responseCode == 200) {
                                           NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                           NSNumber* result = [dict objectForKey:@"result"];
                                           if ([result integerValue] == 1) {
                                               NSArray* arr = [dict objectForKey:@"data"];
                                               id responseData = arr[0];
                                               if ([responseData isKindOfClass:[NSDictionary class]]) {
                                                   [subscriber sendNext:responseData];
                                                   [subscriber sendCompleted];
                                               }
                                               else {
                                                   [subscriber sendError:codeError];
                                               }
                                               
                                           }
                                           else {
                                               [subscriber sendError:codeError];
                                           }
                                           
                                       }
                                       else{
                                           [subscriber sendError:apiError];
                                       }
                                   }
                               }];
        
        return nil;
    }];
}

@end
