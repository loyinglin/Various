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
#import "WeinDetailController.h"

#import <MBProgressHUD.h>
#import <ReactiveCocoa.h>


@interface WeixinHotController () <PullTableViewDelegate>

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
    
    @weakify(self)
    [RACObserve(self.myViewModel, myDataArr) subscribeNext:^(id x) {
        @strongify(self)
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self refreshTable];
    }];
    
    
    RAC(self.myViewModel, myRand) = [[self.myRandSwitch rac_signalForControlEvents:UIControlEventValueChanged]
     map:^id(UISwitch* value) {
         return @(value.on);
     }];
    
    [self.myViewModel.myCommand execute:@(command_type_refresh)];
    

    //MARK: PullTableViewDelegate
    [[self rac_signalForSelector:@selector(pullTableViewDidTriggerLoadMore:) fromProtocol:@protocol(PullTableViewDelegate)] subscribeNext:^(id x) {
        @strongify(self)
        [MBProgressHUD showHUDAddedTo:self.view animated:YES].labelText = @"加载中..";
        [self.myViewModel.myCommand execute:@(command_type_load_more)];
        
//        WeinDetailController* controller = [[WeinDetailController alloc] init];
//        [self presentViewController:controller animated:YES completion:nil];
    }];
    
    [[self rac_signalForSelector:@selector(pullTableViewDidTriggerRefresh:) fromProtocol:@protocol(PullTableViewDelegate)] subscribeNext:^(id x) {
        @strongify(self)
//        [self.myViewModel updateHotData];
        [self.myViewModel.myCommand execute:@(command_type_refresh)];
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - view init

- (void)dealloc{
    NSLog(@"%@ dealloc", self);
}

#pragma mark - 

- (void)refreshTable {
    [self.myTableView reloadData]; //应该紧接着 否则在下面的状态改变会有bug
    self.myTableView.pullLastRefreshDate = [NSDate date];
    self.myTableView.pullTableIsRefreshing = NO;
    self.myTableView.pullTableIsLoadingMore = NO;

}

#pragma mark - ui

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"hot_detail_board"]) {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
        LYBaseWebViewController* controller = segue.destinationViewController;
        controller.myWebUrl = self.myDetailUrl;
    }
}


#pragma mark - delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.myViewModel getDataCount];
}

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


#pragma mark - notify


@end
