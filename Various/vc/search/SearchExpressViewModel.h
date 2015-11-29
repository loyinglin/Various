//
//  SearchExpressViewModel.h
//  Various
//
//  Created by 林伟池 on 15/11/27.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>

typedef NS_ENUM(NSInteger, LYSearchExpressError) {
    LYSearchExpressErrorCodeError,
    LYSearchExpressErrorAPIError
};

@interface SearchExpressViewModel : NSObject

@property(nonatomic, strong) NSString* myExpressType;

- (RACSignal*)signalForSearchExpressWithText:(NSString*)text Type:(NSString*)type;

@end
