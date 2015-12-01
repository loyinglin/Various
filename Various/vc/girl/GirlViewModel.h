//
//  GirlViewModel.h
//  Various
//
//  Created by 林伟池 on 15/11/30.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GirlData : NSObject

@property (nonatomic , strong) NSString* title;
@property (nonatomic , strong) NSString* picUrl;
@property (nonatomic , strong) NSString* url;

@end


@interface GirlViewModel : NSObject

@property (nonatomic , strong) NSArray* myDataArr;


#pragma mark - init

+ (instancetype)instance;

#pragma mark - set

/**
 *  重新获取最新的
 */
- (void)updateHotData;


/**
 *  加载下一页
 */
- (void)loadMoreData;
#pragma mark - get

- (long)getDataCount;

- (GirlData*)getDataByIndex:(long)index;


#pragma mark - update



#pragma mark - message


@end
