//
//  CookSearchController.m
//  Various
//
//  Created by 林伟池 on 15/12/3.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "CookSearchController.h"
#import "CookSearchViewModel.h"
#import "CookSearchDetailController.h"

#import "UIImageView+AFNetworking.h"
#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa.h>

@interface CookSearchController ()

@property (nonatomic , strong) UISearchController* mySearchController;

@property (nonatomic , strong) CookSearchViewModel* myViewModel;

@property (nonatomic , strong) NSString* myMessage;

@property (nonatomic , strong) NSString* mySearchStr;
@end

@implementation CookSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.myViewModel = [CookSearchViewModel new];
    
    self.mySearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.mySearchController.searchResultsUpdater = self;
    self.mySearchController.dimsBackgroundDuringPresentation = NO;
//    self.mySearchController.hidesNavigationBarDuringPresentation = NO;
    
    self.tableView.tableHeaderView = self.mySearchController.searchBar;    

    [[[RACObserve(self, mySearchStr) filter:^BOOL(NSString* text) {
        return text && text.length > 0;
    }]
     throttle:1.0]
     subscribeNext:^(NSString* text) {
         NSLog(@"search %@", self.mySearchStr);
         if (self.mySearchStr) {
             [self.myViewModel requestSearchWithName:self.mySearchStr];
         }
     }];
    
    [RACObserve(self.myViewModel, myDataArr) subscribeNext:^(id x) {
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"search dealloc");
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"search_detail_board"]) {
        CookSearchDetailController* controller = segue.destinationViewController;
        controller.myMessage = self.myMessage;
    }
}

#pragma mark - delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.myViewModel getDataCount];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    
    UILabel* name = (UILabel*)[cell viewWithTag:10];
    UILabel* food = (UILabel*)[cell viewWithTag:20];
    UILabel* keyword = (UILabel*)[cell viewWithTag:30];
    UILabel* count = (UILabel*)[cell viewWithTag:40];
    UIImageView* img = (UIImageView*)[cell viewWithTag:50];
    
    CookSearchData* data = [self.myViewModel getDataByIndex:indexPath.row];
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

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CookSearchData* data = [self.myViewModel getDataByIndex:indexPath.row];
    self.myMessage = data.message;
    [self.mySearchController setActive:NO];
    
    [self performSegueWithIdentifier:@"search_detail_board" sender:self];
    
    return nil;
}

#pragma mark - notify
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    self.mySearchStr = searchController.searchBar.text;
    NSLog(@"update %@", self.mySearchStr);
}

@end
