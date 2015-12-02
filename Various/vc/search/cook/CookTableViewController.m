//
//  CookTableViewController.m
//  Various
//
//  Created by 林伟池 on 15/12/1.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "CookTableViewController.h"
#import "CookViewModel.h"
#import "CookSubCategoryController.h"

#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa.h>

@interface CookTableViewController ()
@property (nonatomic , strong) CookViewModel* myViewModel;


@property (nonatomic , strong) NSNumber* mySubcategoryId;

@property (nonatomic , strong) NSMutableDictionary* myOpenstatus;

@end

@implementation CookTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myViewModel = [CookViewModel new];
    self.myOpenstatus = [NSMutableDictionary dictionary];
    
    [self.myViewModel requestCategoryWithId:0];
    [RACObserve(self.myViewModel, myDataArr) subscribeNext:^(id x) {
        [self.tableView reloadData];
    }];
    
    [RACObserve(self.myViewModel, myUpdate) subscribeNext:^(id x) {
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.myViewModel getHeadCount];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    long ret = 0;
    NSNumber* status = [self.myOpenstatus objectForKey:@(section)];
    if (status && status.integerValue == 1) {
        ret = [self.myViewModel getDetailCountByIndex:section];
    }
    return ret;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* head = [tableView dequeueReusableCellWithIdentifier:@"head"];
    UILabel* title = (UILabel*)[head viewWithTag:10];
    title.text = [self.myViewModel getHeadByIndex:section].title;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onOpen:)];
    [head addGestureRecognizer:tap];
    head.tag = section;
    return head;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSArray* arr = [self.myViewModel getDetailByIndex:indexPath.section];
    CookCategoryData* data = arr[indexPath.row];
    UILabel* title = (UILabel*)[cell viewWithTag:10];
    title.text = data.title;
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray* arr = [self.myViewModel getDetailByIndex:indexPath.section];
    CookCategoryData* data = arr[indexPath.row];
    self.mySubcategoryId = data.id;
    
    [self performSegueWithIdentifier:@"cook_category_board" sender:self];
    return nil;
}

#pragma mark - view init

#pragma mark - ibaction

#pragma mark - ui

- (void)onOpen:(UITapGestureRecognizer *)sender {
    UIView* head = sender.view;
    
    NSNumber* open = [self.myOpenstatus objectForKey:@(head.tag)];
    if (open && open.integerValue == 1) {
        [self.myOpenstatus setObject:@(0) forKey:@(head.tag)];
    }
    else {
        [self.myOpenstatus setObject:@(1) forKey:@(head.tag)];
    }
    

    
    [self.myViewModel requestUpdateCategoryByIndex:head.tag];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"cook_category_board"]) {
        CookSubCategoryController* controller = segue.destinationViewController;
        controller.myCategoryId = self.mySubcategoryId;
    }
}

#pragma mark - delegate

#pragma mark - notify


@end
