//
//  CookSearchDetailController.m
//  Various
//
//  Created by 林伟池 on 15/12/3.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "CookSearchDetailController.h"

@interface CookSearchDetailController ()

@property (nonatomic , strong) IBOutlet UIWebView* myWebView;

@end

@implementation CookSearchDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.myWebView loadHTMLString:self.myMessage baseURL:nil];
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

@end
