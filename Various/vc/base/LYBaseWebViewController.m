//
//  LYBaseWebViewController.m
//  Various
//
//  Created by 林伟池 on 15/12/1.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "LYBaseWebViewController.h"

@interface LYBaseWebViewController ()

@property (nonatomic , strong) IBOutlet UIWebView* myWebView;

@end

@implementation LYBaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.myWebView.delegate = self;
    
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.tabBarController) {
        [self.tabBarController.tabBar setHidden:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
#pragma mark - ibaction

#pragma mark - ui

#pragma mark - delegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"start");
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"end");
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    NSLog(@"error");
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
#pragma mark - notify


@end
