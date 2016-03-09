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

/**
  http请求中心
  1、统一的http错误处理，在 setAPIFailBlock:(LYhttpAPIFailBlock)block
 
  2、统一的业务逻辑错误处理，在 setAPIStatusOKBlock:(LYhttpAPIStatusOKBlock)block
 
  3、请求发起先会进行统一网络判断，无网络处理在 setAPINotNetworkBlock:(LYhttpAPINotNetworkBlock)block
 
  4、统一的http请求头，在 setRequestHeadWithDict:(NSDictionary *)dict
 
  5、统一的http响应接受类型，在 setAcceptableContentTypes:(NSSet *)set
 
##待扩展
 
 对于每一条请求，都用一个类进行封装。
 类定义了，请求类型（get、post、upload），请求头的获取；响应头的获取；url地址获取；参数获取；成功、失败回调；进度条；
 */
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

- (void)lySendRequestWithPost:(NSString *)URLString Param:(NSDictionary *)param Sucess:(LYhttpAPISuccessBlock)successBlock Fail:(LYhttpAPIFailBlock)failBlock;

- (void)lySendRequestWithGET:(NSString *)URLString  Param:(NSDictionary *)param Sucess:(LYhttpAPISuccessBlock)successBlock;

- (void)lySendRequestWithGET:(NSString *)URLString  Param:(NSDictionary *)param Sucess:(LYhttpAPISuccessBlock)successBlock Fail:(LYhttpAPIFailBlock)failBlock;

@end
