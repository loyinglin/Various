//
//  SearchExpressController.m
//  Various
//
//  Created by 林伟池 on 15/11/26.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "SearchExpressController.h"
#import <ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

@interface SearchExpressController ()

@property (weak, nonatomic) IBOutlet UITextField *mySearchText;

@property (nonatomic , strong) IBOutlet UIButton* button0;
@property (nonatomic , strong) IBOutlet UIButton* button1;
@property (nonatomic , strong) IBOutlet UIButton* button2;
@property (nonatomic , strong) IBOutlet UIButton* button3;
@property (nonatomic , strong) IBOutlet UIButton* button4;
@property (nonatomic , strong) IBOutlet UIButton* button5;
@property (nonatomic , strong) IBOutlet UIButton* button6;
@property (nonatomic , strong) IBOutlet UIButton* button7;
@property (nonatomic , strong) IBOutlet UIButton* button8;

@property (nonatomic , strong) IBOutlet UITableView* myTableView;
@property (nonatomic , strong) IBOutlet UIButton* mySearchButton;
@property (nonatomic , strong) IBOutlet UILabel* mySearchStatus;
@property (nonatomic) long mySelectId;

@property (nonatomic , strong) NSArray* myButtons;

@property (nonatomic , strong) NSDictionary* myExpressDict;
@property (nonatomic , strong) NSArray<NSString*>* myExpressDesc;


@end

@implementation SearchExpressController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.myButtons = [NSArray arrayWithObjects:self.button0, self.button1, self.button2,
                 self.button3, self.button4, self.button5,
                 self.button6, self.button7, self.button8,
                 nil];
    self.myExpressDesc = [NSArray arrayWithObjects:@"YT", @"ST", @"ZT",
                          @"YZEMS", @"TT", @"YS",
                          @"KJ", @"QF", @"ZY",
                          nil];
    
    [self selectButton:self.button0];
    
    NSMutableArray<RACSignal*>* signalArr = [NSMutableArray array];
    for (UIButton* item in self.myButtons) {
        item.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton* button) {
            RACSignal* ret = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [self selectButton:button];
                [subscriber sendCompleted];
                return nil;
            }];
            
            
            
            return ret;
        }];
        RACSignal* selected = [item.rac_command.executionSignals map:^id(id value) {
            return item;
        }];
        [signalArr addObject:selected];
    }
    
    RACSignal* currentStatus = [RACSignal merge:signalArr];
    [currentStatus subscribeNext:^(UIButton* button) {
        NSLog(@"current %@", button);
    }];
    
    [self.button0.rac_command execute:self.button0];
    
    
    @weakify(self);
    self.mySearchButton.rac_command = [[RACCommand alloc] initWithEnabled:[self isExpressCodeValid] signalBlock:^RACSignal *(id input) {
        @strongify(self);
        RACSignal* signal = [self signalForSearchExpressWithText:self.mySearchText.text];
        [signal subscribeNext:^(NSDictionary* x) {
            self.myExpressDict = x;
        }];
        return signal;
    }];
    
    [RACObserve(self, myExpressDict) subscribeNext:^(NSDictionary* dict) {
        NSLog(@"dict change");
        [self.myTableView reloadData];
    }];
    
    RACSignal* started = [self.mySearchButton.rac_command.executionSignals map:^id(id value) {
        return @"search ing";
    }];
    RACSignal* completed = [self.mySearchButton.rac_command.executionSignals flattenMap:^RACStream *(RACSignal* sub) {
        return [[[sub materialize] filter:^BOOL(RACEvent* event) {
            return event.eventType == RACEventTypeCompleted;
        }]
                map:^id(id value) {
                    return @"search end";
                }];
    }];
    RACSignal* failed = [[self.mySearchButton.rac_command.errors subscribeOn:[RACScheduler mainThreadScheduler]]
                         map:^id(NSError* error) {
                             return @"error";
                         }];
    RAC(self, mySearchStatus.text) = [RACSignal merge:@[started, completed, failed]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (RACSignal*)isExpressCodeValid{
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        return nil;
    }]
            map:^id(id value) {
                return @(YES);
            }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)textRac{
    @weakify(self);
    
    [[[[[self.mySearchText.rac_textSignal
         filter:^BOOL(NSString* text) {
             return text.length == 11;
         }]
        throttle:0.5]
       flattenMap:^RACStream *(NSString* text) {
           @strongify(self);
           return [self signalForSearchExpressWithText:text];
       }]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(NSArray* arr) {
         @strongify(self);
        
         NSLog(@"%@", [arr description]);

     }
     error:^(NSError *error) {
         NSLog(@"error");
     }];
    
}


- (RACSignal*)signalForSearchExpressWithText:(NSString*)text {
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        
        NSString *httpUrl = @"http://apis.baidu.com/ppsuda/waybillnoquery/waybillnotrace";
        NSString *httpArg = [NSString stringWithFormat:@"expresscode=YT&billno=%@", @"200093247451"];
        
        NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, httpArg];
        NSURL *url = [NSURL URLWithString: urlStr];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
        [request setHTTPMethod: @"GET"];
        [request addValue: @"d233f5dfd98c24f5d9e595af6e5c9fac" forHTTPHeaderField: @"apikey"];
        [NSURLConnection sendAsynchronousRequest: request
                                           queue: [NSOperationQueue mainQueue]
                               completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                                   if (error) {
//                                       [subscriber sendError:apiError];
                                   } else {
                                       NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                       if (responseCode == 200) {
                                           NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                           NSNumber* result = [dict objectForKey:@"result"];
                                           if ([result integerValue] == 1) {
                                               NSArray* arr = [dict objectForKey:@"data"];
                                               [subscriber sendNext:arr[0]];
                                               [subscriber sendCompleted];
                                               
                                           }
                                           
                                           else {
                                               [subscriber sendNext:[[NSDictionary alloc] initWithObjectsAndKeys:@"手机error", @"error", nil]];
                                               //                                               [subscriber sendError:apiError];
                                           }
                                           
                                       }
                                       else{
                                           NSLog(@"aerror");
                                           //                                           [subscriber sendError:apiError];
                                       }
                                   }
                               }];
        
        return nil;
    }];
}


#pragma mark - view init

#pragma mark - ibaction

#pragma mark - ui

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

-(void)selectButton:(UIButton*)button
{
    self.mySelectId = -1;
    for (int i = 0; i < self.myButtons.count; ++i) {
        UIButton* item = (UIButton*)self.myButtons[i];
        if (item) {
            item.layer.borderColor = UIColorFromRGB(0xcdcdcd).CGColor;
            item.layer.borderWidth = 1;
            item.layer.cornerRadius = 3;
            item.backgroundColor = [UIColor whiteColor];
            [item setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
            
            if (item == button) {
                self.mySelectId = i;
                item.backgroundColor = [UIColor darkGrayColor];
                [item setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
    }
    
}


#pragma mark - delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    long ret = 0;
    if (self.myExpressDict && [self.myExpressDict objectForKey:@"wayBills"]) {
        NSArray* arr = [self.myExpressDict objectForKey:@"wayBills"];
        ret = arr.count;
    }
    return ret;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.layer.borderWidth = 0.5;
    cell.layer.borderColor = [UIColor blackColor].CGColor;
    
    UILabel* timeLabel = [cell viewWithTag:10];
    UILabel* descLabel = [cell viewWithTag:20];
    NSArray* arr = [self.myExpressDict objectForKey:@"wayBills"];
    NSDictionary* dict = arr[indexPath.row];
    
    timeLabel.text = [dict objectForKey:@"time"];
    descLabel.text = [dict objectForKey:@"processInfo"];
    
    return cell;
}



- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* cell = [tableView dequeueReusableCellWithIdentifier:@"head"];
    cell.layer.borderWidth = 0.5;
    cell.layer.borderColor = [UIColor blackColor].CGColor;
    return cell;
}
#pragma mark - notify


@end
