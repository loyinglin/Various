//
//  TranslateViewController.m
//  Various
//
//  Created by 林伟池 on 15/12/1.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "TranslateViewController.h"
#import "TranslateViewModel.h"
#import <ReactiveCocoa.h>

@interface TranslateViewController ()


@property (nonatomic , strong) IBOutlet UISwitch* mySwitch;
@property (nonatomic , strong) IBOutlet UILabel* myDesc;


@property (nonatomic , strong) IBOutlet UITextView* mySource;
@property (nonatomic , strong) IBOutlet UITextView* myDest;



@property (nonatomic , strong) TranslateViewModel* myViewModel;


@end

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@implementation TranslateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.myViewModel = [TranslateViewModel new];
    
    self.mySource.layer.borderColor = UIColorFromRGB(0xcdcdcd).CGColor;
    self.mySource.layer.borderWidth = 1;
    
    
    self.myDest.layer.borderColor = UIColorFromRGB(0xcdcdcd).CGColor;
    self.myDest.layer.borderWidth = 1;
    
    
    [[[[[self.mySource.rac_textSignal filter:^BOOL(NSString* text) {
        return text.length > 0;
    }]
     throttle:0.5]
     flattenMap:^RACStream *(NSString* text) {
         return [self.myViewModel signalForTranslateWithText:text Type:self.mySwitch.on];
     }]
     deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(NSString* text) {
         self.myDest.text = text;
     }];

    RAC(self.myDesc, text) = [[self.mySwitch rac_signalForControlEvents:UIControlEventValueChanged] map:^id(UISwitch* item) {
        if (item.on) {
            return @"汉译英";
        }
        else{
            return @"英译汉";
        }
    }];
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
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
}

#pragma mark - ibaction

#pragma mark - ui

#pragma mark - delegate

#pragma mark - notify


@end
