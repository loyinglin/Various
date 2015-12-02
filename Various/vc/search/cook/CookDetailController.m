//
//  CookDetailController.m
//  Various
//
//  Created by 林伟池 on 15/12/2.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "CookDetailController.h"

#import "UIImageView+AFNetworking.h"
#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa.h>

@interface CookDetailController ()
@property (nonatomic , strong) IBOutlet UILabel* myFoodLabel;
@property (nonatomic , strong) IBOutlet UILabel* myKeywordsLabel;
@property (nonatomic , strong) IBOutlet UILabel* myCountLabel;
@property (nonatomic , strong) IBOutlet UIWebView* myMessageWebView;

@property (nonatomic , strong) IBOutlet UIImageView* myImageView;

@end

@implementation CookDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self requestUpdate];
    [self setTitle:self.myDetailName];
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

- (void)requestUpdate {
    
    @weakify(self);
    [[[RACSignal startLazilyWithScheduler:[RACScheduler currentScheduler] block:^(id<RACSubscriber> subscriber) {
        
        NSString *httpUrl = @"http://apis.baidu.com/tngou/cook/show";
        NSString *httpArg = [NSString stringWithFormat:@"id=%ld", self.myDetailId.integerValue]; //api bug
        
        
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
                                           if ([dict objectForKey:@"count"]) {
                                               [subscriber sendNext:dict];
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
         
         self.myCountLabel.text = [NSString stringWithFormat:@"评论数：%@", [dict objectForKey:@"count"]];
         self.myFoodLabel.text = [NSString stringWithFormat:@"食材：%@", [dict objectForKey:@"food"]];
         self.myKeywordsLabel.text = [NSString stringWithFormat:@"关键：%@", [dict objectForKey:@"keywords"]];
         NSString* message = [NSString stringWithFormat:@"<html><body> %@ </body></html>", [dict objectForKey:@"message"]];
//         message = @"<html><body> Some html string </body></html>";
         [self.myMessageWebView loadHTMLString:message baseURL:nil];
         
         
         [self.myImageView setImageWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://tnfs.tngou.net/image%@_100x100", [dict objectForKey:@"img"]]]];
     }];
}
@end
