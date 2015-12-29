//
//  WeixinHotController.m
//  Various
//
//  Created by 林伟池 on 15/11/28.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "WeixinHotController.h"
#import "UIImageView+AFNetworking.h"
#import "LYBaseWebViewController.h"
#import "WeixinHotViewModel.h"
#import <ReactiveCocoa.h>

@interface WeixinHotController ()

@property (nonatomic , strong) IBOutlet PullTableView*  myTableView;

@property (nonatomic , strong) NSString* myDetailUrl;

@property (nonatomic , strong) WeixinHotViewModel* myViewModel;

@property (nonatomic , strong) IBOutlet UISwitch* myRandSwitch;
@end

@implementation WeixinHotController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myTableView.estimatedRowHeight = 200;
    self.myTableView.rowHeight = UITableViewAutomaticDimension;
    
    self.myViewModel = [WeixinHotViewModel new];
    // Do any additional setup after loading the view.
    [self refreshTable];
    
    
    [RACObserve(self.myViewModel, myDataArr) subscribeNext:^(id x) {
        NSLog(@"update");
        [self refreshTable];
    }];
    
    
    RAC(self.myViewModel, myRand) = [[self.myRandSwitch rac_signalForControlEvents:UIControlEventValueChanged]
     map:^id(UISwitch* value) {
         return @(value.on);
     }];
    
//    [[self rac_signalForSelector:@selector(tableView:willSelectRowAtIndexPath:) fromProtocol:@protocol(UITableViewDelegate)] subscribeNext:^(id x) {
//        NSLog(@"test%@", x);
//    }];

    
    [self.myViewModel updateHotData];
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

- (void)dealloc{
    NSLog(@"%@ dealloc", self);
}

#pragma mark - ibaction

#pragma mark - ui

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"hot_detail_board"]) {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
        LYBaseWebViewController* controller = segue.destinationViewController;
        controller.myWebUrl = self.myDetailUrl;
        //        controller.hidesBottomBarWhenPushed = YES;
    }
}


#pragma mark - delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.myViewModel getDataCount];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    UILabel* title = (UILabel*)[cell viewWithTag:10];
    UILabel* desc = (UILabel*)[cell viewWithTag:20];
    UIImageView* img = (UIImageView*)[cell viewWithTag:30];
    UILabel* hottime = (UILabel*)[cell viewWithTag:40];
    WeixinHotData* data = [self.myViewModel getDataByIndex:indexPath.row];
    if (data) {
        title.text = data.title;
        desc.text = data.auther;
        hottime.text = data.hottime;
        [img setImageWithURL:[[NSURL alloc] initWithString:data.picUrl]];
//        
//        [cell setNeedsLayout];
//        [cell layoutIfNeeded];
    }
    else {
        NSLog(@"error");
    }
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.myDetailUrl = nil;
    
    WeixinHotData* data = [self.myViewModel getDataByIndex:indexPath.row];
    if (data) {
        
        self.myDetailUrl = data.url;
        if ([self.myDetailUrl isKindOfClass:[NSString class]]) {
            [self performSegueWithIdentifier:@"hot_detail_board" sender:self];
        }
    }
    
    
    return nil;
}



#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self.myViewModel updateHotData];
    
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self.myViewModel loadMoreData];
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
