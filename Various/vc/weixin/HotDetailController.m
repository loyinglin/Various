//
//  HotDetailController.m
//  Various
//
//  Created by 林伟池 on 15/11/29.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "HotDetailController.h"

@interface HotDetailController ()

@property (nonatomic , strong) IBOutlet UIWebView* myWebView;

@end

@implementation HotDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.myWebView loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:self.myWebUrl]]];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController setToolbarHidden:NO animated:YES];
//    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
#pragma mark - ibaction

#pragma mark - ui

#pragma mark - delegate

#pragma mark - notify

@end
