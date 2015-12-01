//
//  TranslateViewModel.m
//  Various
//
//  Created by 林伟池 on 15/12/1.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "TranslateViewModel.h"

@implementation TranslateViewModel

- (RACSignal*)signalForTranslateWithText:(NSString*)text Type:(BOOL)zh2en{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSString* from;
        NSString* to;
        if (zh2en) {
            from = @"zh";
            to = @"en";
        }
        else{
            from = @"en";
            to = @"zh";
        }
        
        NSString *httpUrl = @"http://apis.baidu.com/apistore/tranlateservice/translate";
        NSString *httpArg = [NSString stringWithFormat:@"query=%@&from=%@&to=%@", text, from, to];
        
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
                                       NSLog(@"error");
                                       [subscriber sendCompleted];
                                   } else {
                                       NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                       if (responseCode == 200) {
                                           NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                           NSNumber* result = [dict objectForKey:@"errNum"];
                                           if ([result integerValue] == 0) {
                                               NSDictionary* retData = [dict objectForKey:@"retData"];
                                               NSArray* arr = [retData objectForKey:@"trans_result"];
                                               NSString* dst = [(NSDictionary*)arr[0] objectForKey:@"dst"];
                                               if (dst && [dst isKindOfClass:[NSString class]]) {
                                                   [subscriber sendNext:dst];
                                               }
                                               [subscriber sendCompleted];
                                           }
                                           else {
                                               NSLog(@"error");
                                               [subscriber sendCompleted];
//                                               [subscriber sendError:codeError];
                                           }
                                           
                                       }
                                       else{
                                           NSLog(@"error");
                                           [subscriber sendCompleted];
//                                           [subscriber sendError:apiError];
                                       }
                                   }
                               }];
        
        return nil;
    }];
}

@end
