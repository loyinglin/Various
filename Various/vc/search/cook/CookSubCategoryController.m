//
//  NewsTableViewController.m
//  Various
//
//  Created by 林伟池 on 15/12/1.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "CookSubCategoryController.h"
#import "MJRefresh.h"
#import "CookSubCategoryViewModel.h"
#import "CookDetailController.h"
#import "UIImageView+AFNetworking.h"
#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa.h>

@interface CookSubCategoryController ()


@property (nonatomic , strong) NSString* myDetailName;
@property (nonatomic , strong) NSNumber* myDetailId;


@property (nonatomic , strong) CookSubCategoryViewModel* myViewModel;



@end

@implementation CookSubCategoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    self.myViewModel = [CookSubCategoryViewModel new];
    
    
    [RACObserve(self.myViewModel, myDataArr) subscribeNext:^(id x) {
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        [self.tableView reloadData];
    }];
    
    
    
    @weakify(self);
    
    [self.tableView addHeaderWithCallback:^{
        NSLog(@"back");
        @strongify(self);
        
        [self.myViewModel requestUpdateDataWithId:self.myCategoryId.integerValue];
//        [self.tableView headerEndRefreshing];
    }];
    
    
    [self.tableView addFooterWithCallback:^{
        @strongify(self);
        
        [self.myViewModel loadMoreData];
    }];
    
    [self.myViewModel requestUpdateDataWithId:self.myCategoryId.integerValue];
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
    
    UILabel* name = (UILabel*)[cell viewWithTag:10];
    UILabel* food = (UILabel*)[cell viewWithTag:20];
    UILabel* keyword = (UILabel*)[cell viewWithTag:30];
    UILabel* count = (UILabel*)[cell viewWithTag:40];
    UIImageView* img = (UIImageView*)[cell viewWithTag:50];

    CookSubCategoryData* data = [self.myViewModel getDataByIndex:indexPath.row];
    if (data) {
        name.text = [NSString stringWithFormat:@"名字：%@", data.name];
        food.text = [NSString stringWithFormat:@"食材：%@", data.food];
        keyword.text = [NSString stringWithFormat:@"关键：%@", data.keywords];
        count.text = [NSString stringWithFormat:@"评论数：%@", data.count];

        [img setImageWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://tnfs.tngou.net/image%@_100x100", data.img]]];
//
    }

    
    
    return cell;
}


#pragma mark - view init

#pragma mark - ibaction

#pragma mark - ui

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"cook_detail_board"]) {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
        CookDetailController* controller = segue.destinationViewController;
        controller.myDetailName = self.myDetailName;
        controller.myDetailId = self.myDetailId;
        //        controller.hidesBottomBarWhenPushed = YES;
    }
}


#pragma mark - delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CookSubCategoryData* data = [self.myViewModel getDataByIndex:indexPath.row];
    if (data) {
        
        self.myDetailName = data.name;
        self.myDetailId = data.id;
        
        if (self.myDetailId && self.myDetailName) {
            [self performSegueWithIdentifier:@"cook_detail_board" sender:self];
        }
        
    }
    
    
    return nil;
}

#pragma mark - notify


@end
