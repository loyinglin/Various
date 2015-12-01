//
//  NewsTableViewController.m
//  Various
//
//  Created by 林伟池 on 15/12/1.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "NewsTableViewController.h"
#import "MJRefresh.h"
#import "NewsViewModel.h"
#import "LYBaseWebViewController.h"
#import "UIImageView+AFNetworking.h"
#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa.h>

@interface NewsTableViewController ()


@property (nonatomic , strong) NSString* myWebUrl;


@property (nonatomic , strong) NewsViewModel* myViewModel;



@end

@implementation NewsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    self.myViewModel = [NewsViewModel new];
    
    
    [RACObserve(self.myViewModel, myDataArr) subscribeNext:^(id x) {
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        [self.tableView reloadData];
    }];
    
    
    
    @weakify(self);
    
    [self.tableView addHeaderWithCallback:^{
        NSLog(@"back");
        @strongify(self);
        
        [self.myViewModel updateHotData];
//        [self.tableView headerEndRefreshing];
    }];
    
    
    [self.tableView addFooterWithCallback:^{
        @strongify(self);
        
        [self.myViewModel loadMoreData];
    }];
    
    [self.myViewModel updateHotData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.myViewModel getDataCount];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    UILabel* title = (UILabel*)[cell viewWithTag:10];
    UILabel* desc = (UILabel*)[cell viewWithTag:20];
    UIImageView* img = (UIImageView*)[cell viewWithTag:30];
    UILabel* hottime = (UILabel*)[cell viewWithTag:40];
    NewsData* data = [self.myViewModel getDataByIndex:indexPath.row];
    if (data) {
        title.text = data.title;
        desc.text = data.auther;
        hottime.text = data.time;
        [img setImageWithURL:[[NSURL alloc] initWithString:data.picUrl]];
        
    }

    
    
    return cell;
}


#pragma mark - view init

#pragma mark - ibaction

#pragma mark - ui

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"news_detail_board"]) {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
        LYBaseWebViewController* controller = segue.destinationViewController;
        controller.myWebUrl = self.myWebUrl;
        //        controller.hidesBottomBarWhenPushed = YES;
    }
}


#pragma mark - delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.myWebUrl = nil;
    
    NewsData* data = [self.myViewModel getDataByIndex:indexPath.row];
    if (data) {
        
        self.myWebUrl = data.url;
        if ([self.myWebUrl isKindOfClass:[NSString class]]) {
            [self performSegueWithIdentifier:@"news_detail_board" sender:self];
        }
    }
    
    
    return nil;
}

#pragma mark - notify


@end
