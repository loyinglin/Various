//
//  LYhttpAPICenter.m
//  Various
//
//  Created by 林伟池 on 16/3/8.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "LYhttpAPICenter.h"
#import <AFNetworking.h>

@interface LYhttpAPICenter()
@property (nonatomic , strong) LYhttpAPIStatusOKBlock   myStatusBlock;
@property (nonatomic , strong) LYhttpAPINotNetworkBlock myNotNetworkBlock;
@property (nonatomic , strong) LYhttpAPIFailBlock       myFailBlock;

@property (nonatomic , strong) AFHTTPSessionManager*    myManager;

@end


@implementation LYhttpAPICenter


+ (instancetype)instance {
    static id test;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        test = [[[self class] alloc] init];
    });
    return test;
}

#pragma init

- (instancetype)init {
    self = [super init];
    self.myManager = [AFHTTPSessionManager manager];
    
    return self;
}

- (void)setAPINotNetworkBlock:(LYhttpAPINotNetworkBlock)block {
    self.myNotNetworkBlock = block;
}

- (void)setAPIFailBlock:(LYhttpAPIFailBlock)block {
    self.myFailBlock = block;
}

- (void)setAPIStatusOKBlock:(LYhttpAPIStatusOKBlock)block {
    self.myStatusBlock = block;
}

- (void)setRequestHeadWithDict:(NSDictionary *)dict {
    if (dict) {
        NSArray* allKeys = [dict allKeys];
        for (NSString* key in allKeys) {
            if ([key isKindOfClass:[NSString class]]) {
                [self.myManager.requestSerializer setValue:dict[key] forHTTPHeaderField:key
                 ];
            }
        }
    }
}

- (void)setAcceptableContentTypes:(NSSet *)set {
    self.myManager.responseSerializer.acceptableContentTypes = set;
}

#pragma http

- (void)lySendRequestWithGET:(NSString *)URLString  Param:(NSDictionary *)param Sucess:(LYhttpAPISuccessBlock)successBlock {
    [self requestWithMethod:@"GET" URL:URLString parameters:param progress:nil success:successBlock];
}



- (void)lySendRequestWithPost:(NSString *)URLString Param:(NSDictionary *)param Sucess:(LYhttpAPISuccessBlock)successBlock{
    [self requestWithMethod:@"POST" URL:URLString parameters:param progress:nil success:successBlock];
}

- (void)requestWithMethod:(NSString *)method URL:(NSString *)URLString
  parameters:(id)parameters
    progress:(void (^)(NSProgress * _Nonnull))uploadProgress
     success:(void (^)(id _Nullable))success {
    if (![self lyNetworkReachable]) {
        if (self.myNotNetworkBlock) { //没有网络
            self.myNotNetworkBlock();
        }
        return ;
    }
    
    void (^innerSuccessBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.myStatusBlock) {
            if (!self.myStatusBlock(responseObject)) { //业务逻辑判断是否成功
                return ;
            }
        }
        success(responseObject);
    };

    void (^innerFailBlock)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.myFailBlock) {
            self.myFailBlock(error);
        }
    };

    if ([method isEqualToString:@"POST"]) {
        [self.myManager POST:URLString parameters:parameters progress:uploadProgress success:innerSuccessBlock failure:innerFailBlock];
    }
    else if ([method isEqualToString:@"GET"]) {
        [self.myManager GET:URLString parameters:parameters progress:uploadProgress success:innerSuccessBlock failure:innerSuccessBlock];
    }
}


- (BOOL)lyNetworkReachable {
    AFNetworkReachabilityManager* manager = [AFNetworkReachabilityManager manager];

//    BOOL ret = NO;
//    switch ([manager networkReachabilityStatus]) {
//        case AFNetworkReachabilityStatusReachableViaWiFi:
//            ret = YES;
//            break;
//        case AFNetworkReachabilityStatusReachableViaWWAN:
//            ret = YES;
//            break;
//            
//        default:
//            break;
//    }
    
    return manager.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable;
}



@end
