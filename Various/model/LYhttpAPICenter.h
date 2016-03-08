//
//  LYhttpAPICenter.h
//  Various
//
//  Created by 林伟池 on 16/3/8.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^LYhttpAPISuccessBlock)(id responseObject);

typedef BOOL(^LYhttpAPIStatusOKBlock)(id responseObject); //业务逻辑判断回调
typedef void(^LYhttpAPINotNetworkBlock)(void); //无网络回调
typedef void(^LYhttpAPIFailBlock)(NSError* error);

@protocol LYhttpAPIDelegate


@optional
- (LYhttpAPIFailBlock)getAPIFailBlock;

- (LYhttpAPINotNetworkBlock)getAPINotNetworkBlock;

- (LYhttpAPIStatusOKBlock)getAPIStatusOKBlock;

@end


@interface LYhttpAPICenter : NSObject

+ (instancetype)instance;

@property (nonatomic , weak) id<LYhttpAPIDelegate> delegate;

#pragma init
- (void)setAPINotNetworkBlock:(LYhttpAPINotNetworkBlock)block;

- (void)setAPIFailBlock:(LYhttpAPIFailBlock)block;

- (void)setAPIStatusOKBlock:(LYhttpAPIStatusOKBlock)block;

- (void)setRequestHeadWithDict:(NSDictionary *)dict;

- (void)setAcceptableContentTypes:(NSSet *)set;


#pragma mark - http
- (void)lySendRequestWithPost:(NSString *)URLString Param:(NSDictionary *)param Sucess:(LYhttpAPISuccessBlock)successBlock;

- (void)lySendRequestWithGET:(NSString *)URLString  Param:(NSDictionary *)param Sucess:(LYhttpAPISuccessBlock)successBlock;

@end
