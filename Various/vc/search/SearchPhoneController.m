//
//  SearchPhoneController.m
//  Various
//
//  Created by 林伟池 on 15/11/26.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "SearchPhoneController.h"
#import <ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

typedef NS_ENUM(NSInteger, LYSearchPhoneError) {
    LYSearchPhoneErrorPhoneError,
    LYSearchPhoneErrorAPIError
};

@interface SearchPhoneController ()

@property (weak, nonatomic) IBOutlet UITextField *searchText;

@property (nonatomic , strong) IBOutlet UILabel*    myStatus;

@property (nonatomic , strong) IBOutlet UILabel*    myPhoneNum;
@property (nonatomic , strong) IBOutlet UILabel*    mySupllier;
@property (nonatomic , strong) IBOutlet UILabel*    myProvince;
@property (nonatomic , strong) IBOutlet UILabel*    myCity;

@end

@implementation SearchPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self textRac];
    
}

- (void)dealloc{
    NSLog(@"desc %@", self);
}

- (void)textRac{
    @weakify(self);
    
    [[[[[self.searchText.rac_textSignal
         filter:^BOOL(NSString* text) {
             return text.length == 11;
         }]
        throttle:0.5]
       flattenMap:^RACStream *(NSString* text) {
           @strongify(self);
           self.myStatus.text = @"查询中...";
           self.myStatus.hidden = NO;
           return [self signalForSearchPhoneWithText:text];
       }]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(NSDictionary* dict) {
         @strongify(self);
         if ([dict objectForKey:@"error"]) {
             NSLog(@"error %@", [dict objectForKey:@"error"]);
             self.myStatus.text = @"手机号码有误";
             self.myStatus.hidden = NO;
             return ;
         }
         [self viewInitWithDict:dict];
         self.myStatus.hidden = YES;
     }
     error:^(NSError *error) {
         NSLog(@"error");
     }];

}


- (RACSignal*)signalForSearchPhoneWithText:(NSString*)text {
    NSError* phoneError = [NSError errorWithDomain:@"LYERROR" code:LYSearchPhoneErrorPhoneError userInfo:nil];
    NSError* apiError = [NSError errorWithDomain:@"LYERROR" code:LYSearchPhoneErrorAPIError userInfo:nil];
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        if (text.length != 11) {
            [subscriber sendError:phoneError];
        }
        
        NSString *httpUrl = @"http://apis.baidu.com/apistore/mobilenumber/mobilenumber";
        NSString *httpArg = [NSString stringWithFormat:@"phone=%@", text];
        
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
                                           NSNumber* errNum = [dict objectForKey:@"errNum"];
                                           if ([errNum integerValue] == 0) {
                                               
                                               [subscriber sendNext:[dict objectForKey:@"retData"]];
                                               [subscriber sendCompleted];
                                               
                                           }
                                           
                                           else {
                                               [subscriber sendNext:[[NSDictionary alloc] initWithObjectsAndKeys:@"手机error", @"error", nil]];
//                                               [subscriber sendError:apiError];
                                           }
                                           
                                       }
                                       else{
//                                           [subscriber sendError:apiError];
                                       }
                                   }
                               }];
        
        return nil;
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - view init


- (void)viewInitWithDict:(NSDictionary *)detail{
    self.myPhoneNum.text = [NSString stringWithFormat:@"手机号码：%@", detail[@"phone"]];
    self.mySupllier.text = [NSString stringWithFormat:@"服务商：%@", detail[@"supplier"]];
    self.myProvince.text = [NSString stringWithFormat:@"省份：%@", detail[@"province"]];
    self.myCity.text = [NSString stringWithFormat:@"城市：%@", detail[@"city"]];
}
#pragma mark - ibaction

#pragma mark - ui

#pragma mark - delegate

#pragma mark - notify



@end
