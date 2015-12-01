//
//  GirlCollectionViewController.m
//  Various
//
//  Created by 林伟池 on 15/11/30.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "GirlCollectionViewController.h"
#import "GirlViewModel.h"
#import "UIImageView+AFNetworking.h"
#import "LYBaseWebViewController.h"
#import "MJRefresh.h"
#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa.h>

@interface GirlCollectionViewController ()


@property (nonatomic , strong)  GirlViewModel* myViewModel;



@property (nonatomic , strong) NSString* myUrl;


@end

@implementation GirlCollectionViewController

static NSString * const reuseIdentifier = @"cell";
static NSString * const openIdentifier = @"girl_detail_board";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myViewModel = [GirlViewModel new];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;    
    
    
    //RAC
    [RACObserve(self.myViewModel, myDataArr) subscribeNext:^(id x) {
        NSLog(@"update");
        [self.collectionView reloadData];
        [self.collectionView headerEndRefreshing];
        [self.collectionView footerEndRefreshing];
    }];
    
    
    [self addHeader];
    [self addFooter];
    
    
    
    // Do any additional setup after loading the view.
    [self.myViewModel updateHotData];
}

- (void)addHeader
{
    @weakify(self);
    // 添加下拉刷新头部控件
    [self.collectionView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        @strongify(self);
        
        [self.myViewModel updateHotData];
    }];
    
}


- (void)addFooter
{
    @weakify(self);
    // 添加上拉刷新尾部控件
    [self.collectionView addFooterWithCallback:^{
        @strongify(self);
        
        [self.myViewModel loadMoreData];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:openIdentifier]) {
        LYBaseWebViewController* controller = segue.destinationViewController;
        controller.myWebUrl = self.myUrl;
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    NSLog(@"count %ld", [self.myViewModel getDataCount]);
    return [self.myViewModel getDataCount];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    UIImageView* img = (UIImageView*)[cell viewWithTag:10];
    UILabel* title = (UILabel*)[cell viewWithTag:20];
    GirlData* item = [self.myViewModel getDataByIndex:indexPath.row];
    if (item) {
        [img setImageWithURL:[[NSURL alloc] initWithString:item.picUrl]];
        title.text = item.title;
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeZero;
    
    size.width = [[UIScreen mainScreen] bounds].size.width / 3 - 1;
    
    size.height = 200;
    
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GirlData* item = [self.myViewModel getDataByIndex:indexPath.row];
    self.myUrl = item.url;
    
    [self performSegueWithIdentifier:openIdentifier sender:self];
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
