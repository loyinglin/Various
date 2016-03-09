//
//  TranslateViewModel.m
//  Various
//
//  Created by 林伟池 on 15/12/1.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "TranslateViewModel.h"
#import "LYhttpAPICenter.h"

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

        [[LYhttpAPICenter instance] lySendRequestWithGET:httpUrl Param:@{@"query":text, @"from":from, @"to":to} Sucess:^(NSDictionary* dict) {
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
            }

        } Fail:^(NSError *error) {
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

@end
