//
//  WeixinHotController.m
//  Various
//
//  Created by 林伟池 on 15/11/28.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "WeixinHotController.h"
#import "UIImageView+AFNetworking.h"
#import "HotDetailController.h"
#import <ReactiveCocoa.h>

@interface WeixinHotController ()

@property (nonatomic , strong) IBOutlet PullTableView*  myTableView;


@property (nonatomic , strong) NSDictionary* myData;


@property (nonatomic , strong) NSString* myDetailUrl;

@end

@implementation WeixinHotController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self refreshTable];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:[[NSDictionary alloc] initWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
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

#pragma mark - ibaction

#pragma mark - ui

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"hot_detail_board"]) {
        HotDetailController* controller = segue.destinationViewController;
        controller.myWebUrl = self.myDetailUrl;
//        controller.hidesBottomBarWhenPushed = YES;
    }
}

#pragma mark - delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    long ret = 0;
    if (self.myData) {
        ret = 10;
    }
    return ret;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    UILabel* title = (UILabel*)[cell viewWithTag:10];
    UILabel* desc = (UILabel*)[cell viewWithTag:20];
    UIImageView* img = (UIImageView*)[cell viewWithTag:30];
    if (self.myData) {
        NSDictionary* dict = [self.myData objectForKey:[NSString stringWithFormat:@"%ld", indexPath.row]];
        if (dict) {
            title.text = [dict objectForKey:@"title"];
            desc.text = [dict objectForKey:@"description"];
            [img setImageWithURL:[[NSURL alloc] initWithString:[dict objectForKey:@"picUrl"]]];
        }
    }
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.myDetailUrl = nil;
    if (self.myData) {
        NSDictionary* dict = [self.myData objectForKey:[NSString stringWithFormat:@"%ld", indexPath.row]];
        if (dict) {
            self.myDetailUrl = [dict objectForKey:@"url"];
            if ([self.myDetailUrl isKindOfClass:[NSString class]]) {
                [self performSegueWithIdentifier:@"hot_detail_board" sender:self];
            }
        }
    }
    
    
    return nil;
}



#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [[[RACSignal startLazilyWithScheduler:[RACScheduler currentScheduler] block:^(id<RACSubscriber> subscriber) {
        
        NSString *httpUrl = @"http://apis.baidu.com/txapi/weixin/wxhot";
        NSString *httpArg = [NSString stringWithFormat:@"num=10&rand=1"];
        
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
         self.myData = dict;
         [self refreshTable];
     }];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:1.0f];
    
}

- (void) refreshTable
{
    /*
     
     Code to actually refresh goes here.
     
     */
    
    [self.myTableView reloadData]; //应该紧接着 否则在下面的状态改变会有bug
    self.myTableView.pullLastRefreshDate = [NSDate date];
    self.myTableView.pullTableIsRefreshing = NO;
    self.myTableView.pullTableIsLoadingMore = NO;
}

#pragma mark - notify


@end
