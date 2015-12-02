//
//  WeixinHotViewModel.h
//  Various
//
//  Created by 林伟池 on 15/11/29.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CookSubCategoryData : NSObject

@property (nonatomic , strong) NSString* count;
@property (nonatomic , strong) NSString* food;
@property (nonatomic , strong) NSNumber* id;
@property (nonatomic , strong) NSString* img;
@property (nonatomic , strong) NSString* keywords;
@property (nonatomic , strong) NSString* name;

@end


@interface CookSubCategoryViewModel : NSObject

@property (nonatomic , strong) NSArray* myDataArr;

@property (nonatomic) NSNumber* myRand;


#pragma mark - init

+ (instancetype)instance;

#pragma mark - set

- (void)requestUpdateDataWithId:(long)categoryId;


/**
 *  加载下一页
 */
- (void)loadMoreData;
#pragma mark - get

- (long)getDataCount;

- (CookSubCategoryData *)getDataByIndex:(long)index;


#pragma mark - update



#pragma mark - message


@end
