//
//  SearchExpressController.m
//  Various
//
//  Created by 林伟池 on 15/11/26.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "SearchExpressController.h"
#import "SearchExpressViewModel.h"
#import <ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

typedef NS_ENUM(NSInteger, LYSearchExpressError) {
    LYSearchExpressErrorCodeError,
    LYSearchExpressErrorAPIError
};

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

@property (nonatomic , strong) SearchExpressViewModel* myViewModel;
@end

@implementation SearchExpressController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.myButtons = [NSArray arrayWithObjects:self.button0, self.button1, self.button2,
                 self.button3, self.button4, self.button5,
                 self.button6, self.button7, self.button8,
                 nil];
    self.myExpressDesc = [NSArray arrayWithObjects:@"YT", @"ZY", @"ZT",
                          @"YZEMS", @"TT", @"YS",
                          @"KJ", @"QF",
                          nil];
    
    @weakify(self);

    NSMutableArray<RACSignal*>* signalArr = [NSMutableArray array];
    for (UIButton* item in self.myButtons) {

        item.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton* button) {
            RACSignal* ret = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

                @strongify(self);
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

    self.myViewModel = [[SearchExpressViewModel alloc] init];
    

    RAC(self.myViewModel, myExpressType) = [currentStatus map:^id(id value) {
        @strongify(self);
        return [self.myExpressDesc objectAtIndex:[self.myButtons indexOfObject:value]];
    }];
    
    [RACObserve(self.myViewModel, myExpressType) subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    [self.button0.rac_command execute:self.button0];
    
    self.mySearchButton.rac_command = [[RACCommand alloc] initWithEnabled:[self isExpressCodeValid] signalBlock:^RACSignal *(id input) {
        @strongify(self);
        RACSignal* signal = [self signalForSearchExpressWithText:self.mySearchText.text Type:self.myViewModel.myExpressType];
        return signal;
    }];
    
    [RACObserve(self, myExpressDict) subscribeNext:^(NSDictionary* dict) {
        NSLog(@"dict change");
        @strongify(self);
        [self.myTableView reloadData];
    }];
    
    [self.mySearchButton.rac_command.executionSignals subscribeNext:^(RACSignal* signal) {
        [signal subscribeNext:^(id x) {
            @strongify(self);
            NSArray* arr = [x objectForKey:@"wayBills"];
            NSDictionary* detail = arr[0];
            NSLog(@"%@", [detail objectForKey:@"processInfo"]);
            self.myExpressDict = x;
        }];
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

- (void)dealloc{
    NSLog(@"desac %@", self);
}

- (RACSignal*)isExpressCodeValid{
    return [self.mySearchText.rac_textSignal map:^id(NSString* text) {
        return @(text.length != 0);
    }];
}


- (RACSignal*)signalForSearchExpressWithText:(NSString*)text Type:(NSString*)type{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

        
        NSError* codeError = [NSError errorWithDomain:@"LYERROR" code:LYSearchExpressErrorCodeError userInfo:nil];
        NSError* apiError = [NSError errorWithDomain:@"LYERROR" code:LYSearchExpressErrorAPIError userInfo:nil];
        
        NSString *httpUrl = @"http://apis.baidu.com/ppsuda/waybillnoquery/waybillnotrace";
        NSString *httpArg = [NSString stringWithFormat:@"expresscode=%@&billno=%@", type, text];
        
        NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, httpArg];
        NSURL *url = [NSURL URLWithString: urlStr];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
        [request setHTTPMethod: @"GET"];
        [request addValue: @"d233f5dfd98c24f5d9e595af6e5c9fac" forHTTPHeaderField: @"apikey"];
        [NSURLConnection sendAsynchronousRequest: request
                                           queue: [NSOperationQueue mainQueue]
                               completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                                   if (error) {
                                       [subscriber sendError:apiError];
                                   } else {
                                       NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                       if (responseCode == 200) {
                                           NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                           NSNumber* result = [dict objectForKey:@"result"];
                                           if ([result integerValue] == 1) {
                                               NSArray* arr = [dict objectForKey:@"data"];
                                               id responseData = arr[0];
                                               if ([responseData isKindOfClass:[NSDictionary class]]) {
                                                   [subscriber sendNext:responseData];
                                                   [subscriber sendCompleted];
                                               }
                                               else {
                                                   [subscriber sendError:codeError];
                                               }
                                               
                                           }
                                           else {
                                               [subscriber sendError:codeError];
                                           }
                                           
                                       }
                                       else{
                                           [subscriber sendError:apiError];
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
    
    UILabel* timeLabel = (UILabel*)[cell viewWithTag:10];
    UILabel* descLabel = (UILabel*)[cell viewWithTag:20];
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
