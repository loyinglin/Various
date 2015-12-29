//
//  CookViewModel.h
//  Various
//
//  Created by 林伟池 on 15/11/30.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CookCategoryData : NSObject

@property (nonatomic , strong) NSString* title;
@property (nonatomic , strong) NSNumber* id;
@property (nonatomic , strong) NSString* cookclass;
@end


@interface CookViewModel : NSObject

@property (nonatomic , strong) NSArray* myDataArr;

@property (nonatomic , strong) NSNumber* myUpdate;

#pragma mark - init

+ (instancetype)instance;

#pragma mark - set

- (void)requestCategoryRoot;

- (void)requestUpdateCategoryByIndex:(long)index;

#pragma mark - get

- (long)getHeadCount;

- (CookCategoryData*)getHeadByIndex:(long)index;

- (long)getDetailCountByIndex:(long)index;

- (NSArray *)getDetailByIndex:(long)index;
#pragma mark - update



#pragma mark - message

#pragma mark - core data




@end
