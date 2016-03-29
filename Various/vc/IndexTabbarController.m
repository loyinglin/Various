//
//  IndexTabbarController.m
//  Various
//
//  Created by 林伟池 on 15/11/29.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "IndexTabbarController.h"
#import "LYhttpAPICenter.h"

@interface IndexTabbarController ()

@end

@implementation IndexTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationController.navigationBar.hidden = YES;
    [self.tabBar setTintColor:[UIColor blackColor]];
    
    [self customAPI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)customAPI {
    [[LYhttpAPICenter instance] setAPINotNetworkBlock:^{
        NSLog(@"ABC");
    }];
    [[LYhttpAPICenter instance] setRequestHeadWithDict:@{@"apikey":@"d233f5dfd98c24f5d9e595af6e5c9fac"}];
    
    [[LYhttpAPICenter instance] setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil]];
}

@end
