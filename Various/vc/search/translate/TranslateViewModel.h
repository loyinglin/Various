//
//  TranslateViewModel.h
//  Various
//
//  Created by 林伟池 on 15/12/1.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>

@interface TranslateViewModel : NSObject

@property (nonatomic , strong) NSString* myDest;

- (RACSignal*)signalForTranslateWithText:(NSString*)text Type:(BOOL)zh2en;

@end
