//
//  GirlViewModel.m
//  Various
//
//  Created by 林伟池 on 15/11/30.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "CookViewModel.h"
#import "NSDictionary+LYDictToObject.h"
#import "CoreCategoryList.h"
#import "CoreCategoryItem.h"

#import <CoreData/CoreData.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa.h>

@implementation CookCategoryData


@end

@interface CookViewModel()

@property (strong, nonatomic) NSManagedObjectContext *myManagedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *myManagedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *myPersistentStoreCoordinator;


@end

@implementation CookViewModel
{
    long myPage;
    NSMutableDictionary* myDict;
}


#pragma mark - init

+(instancetype) instance
{
    static id test;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        test = [[[self class] alloc] init];
    });
    return test;
}

- (instancetype)init{
    self = [super init];
    myPage = 1;
    myDict = [[NSMutableDictionary alloc] init];
    self.myDataArr = [NSArray array];
    [self customCoreData];
    return self;
}

#pragma mark - set

- (void)requestCategoryRoot{
    
    @weakify(self);
    
    
    NSFetchRequest* request = [NSFetchRequest new];
    [request setEntity:[NSEntityDescription entityForName:[[CoreCategoryList class] description] inManagedObjectContext:self.myManagedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"titleItem.id = 0"]];
    NSError* error;
    NSArray* fetchs = [self.myManagedObjectContext executeFetchRequest:request error:&error];
    if (fetchs && fetchs.count > 0) {
        CoreCategoryList* root = fetchs[0];
        NSMutableArray* newArr = [NSMutableArray array];
        for (CoreCategoryItem* listItem in root.titleList) {
            CookCategoryData* data = [CookCategoryData new];
            data.id = listItem.id;
            data.title = listItem.title;
            [newArr addObject:data];
        }
        self.myDataArr = newArr;
    }
    else {
        [[[RACSignal startLazilyWithScheduler:[RACScheduler currentScheduler] block:^(id<RACSubscriber> subscriber) {
            
            NSString *httpUrl = @"http://apis.baidu.com/tngou/cook/classify";
            NSString *httpArg = [NSString stringWithFormat:@"id=%d", 0]; //api bug
            
            
            NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, httpArg];
            NSURL *url = [NSURL URLWithString: urlStr];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
            [request setHTTPMethod: @"GET"];
            [request addValue: @"d233f5dfd98c24f5d9e595af6e5c9fac" forHTTPHeaderField: @"apikey"];
            [NSURLConnection sendAsynchronousRequest: request
                                               queue: [NSOperationQueue mainQueue]
                                   completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                                       if (error) {
                                           
                                       } else {
                                           NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                           if (responseCode == 200) {
                                               NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                               if ([dict objectForKey:@"tngou"]) {
                                                   [subscriber sendNext:[dict objectForKey:@"tngou"]];
                                               }
                                               
                                               
                                           }
                                           else{
                                               
                                           }
                                       }
                                   }];
        }]
          deliverOn:[RACScheduler mainThreadScheduler]]
         subscribeNext:^(NSArray* arr) {
             @strongify(self);
             
             NSMutableArray* newArr = [NSMutableArray array];
             for (NSDictionary* dict in arr) {
                 CookCategoryData* item = [dict objectForClass:[CookCategoryData class]];
                 [newArr addObject:item];
             }
             
             
             {
                 CoreCategoryList* listItem = [NSEntityDescription insertNewObjectForEntityForName:[[CoreCategoryList class] description] inManagedObjectContext:self.myManagedObjectContext];
                 CoreCategoryItem* titleItem = [NSEntityDescription insertNewObjectForEntityForName:[[CoreCategoryItem class] description] inManagedObjectContext:self.myManagedObjectContext];
                 titleItem.id = @(0);
                 titleItem.title = @"root";
                 [listItem setTitleItem:titleItem];
                 NSMutableArray* inserts = [NSMutableArray array];
                 for (CookCategoryData* dataItem in newArr) {
                     CoreCategoryItem* item = [NSEntityDescription insertNewObjectForEntityForName:[[CoreCategoryItem class] description] inManagedObjectContext:self.myManagedObjectContext];
                     item.id = dataItem.id;
                     item.title = dataItem.title;
                     [inserts addObject:item];
                 }
                 [listItem setTitleList:[NSSet setWithArray:inserts]];
                 
                 [self saveContext];
             }
             
             
             self.myDataArr = newArr;
         }];
    }
}

- (void)requestUpdateCategoryByIndex:(long)index {
    NSString* key = [NSString stringWithFormat:@"%ld", [self getHeadByIndex:index].id.integerValue];
    if (!myDict[key]) {
        @weakify(self);
        [[[RACSignal startLazilyWithScheduler:[RACScheduler currentScheduler] block:^(id<RACSubscriber> subscriber) {
            
            NSString *httpUrl = @"http://apis.baidu.com/tngou/cook/classify";
            NSString *httpArg = [NSString stringWithFormat:@"id=%ld", [self getHeadByIndex:index].id.integerValue]; //api bug
            
            
            NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, httpArg];
            NSURL *url = [NSURL URLWithString: urlStr];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
            [request setHTTPMethod: @"GET"];
            [request addValue: @"d233f5dfd98c24f5d9e595af6e5c9fac" forHTTPHeaderField: @"apikey"];
            [NSURLConnection sendAsynchronousRequest: request
                                               queue: [NSOperationQueue mainQueue]
                                   completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                                       if (error) {
                                           
                                       } else {
                                           NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                           if (responseCode == 200) {
                                               NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                               NSNumber* status = [dict objectForKey:@"status"];
                                               if (status && status.boolValue) {
                                                   [subscriber sendNext:[dict objectForKey:@"tngou"]];
                                               }
                                               
                                               
                                           }
                                           else{
                                               
                                           }
                                       }
                                   }];
        }]
          deliverOn:[RACScheduler mainThreadScheduler]]
         subscribeNext:^(NSArray* arr) {
             @strongify(self);
             
             NSMutableArray* newArr = [NSMutableArray array];
             for (NSDictionary* dict in arr) {
                 CookCategoryData* item = [dict objectForClass:[CookCategoryData class]];
                 [newArr addObject:item];
             }
             
             myDict[key] = newArr;
             self.myUpdate = @(!self.myUpdate.boolValue);
         }];
    }
    else {
        self.myUpdate = @(!self.myUpdate.boolValue);
    }
}
#pragma mark - get

- (long)getHeadCount {
    return self.myDataArr.count;
}


- (CookCategoryData*)getHeadByIndex:(long)index {
    CookCategoryData* ret;
    
    if (index >= 0 && index < self.myDataArr.count) {
        ret = [self.myDataArr objectAtIndex:index];
    }
    
    return ret;
}

- (long)getDetailCountByIndex:(long)index {
    
    NSString* key = [NSString stringWithFormat:@"%ld", [self getHeadByIndex:index].id.integerValue];
    NSArray* arr = myDict[key];
    return arr.count;
}

- (NSArray *)getDetailByIndex:(long)index {
    NSString* key = [NSString stringWithFormat:@"%ld", [self getHeadByIndex:index].id.integerValue];
    return myDict[key];
}
#pragma mark - update

#pragma mark - core data

- (void)customCoreData {
    [self customManagedObjectModel];
    [self customPersistentStoreCoordinator];
    [self customManagedObjectContext]; //先后顺序
    
}

- (void)customManagedObjectModel {
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CookModel" withExtension:@"momd"];
    self.myManagedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
}

- (void)customPersistentStoreCoordinator {
    self.myPersistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.myManagedObjectModel];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"LearnCoreData.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption:@YES,NSInferMappingModelAutomaticallyOption:@YES};
    if (![self.myPersistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}


- (void)customManagedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    self.myManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [self.myManagedObjectContext setPersistentStoreCoordinator:self.myPersistentStoreCoordinator];
}


- (void)saveContext {
    
    NSManagedObjectContext *managedObjectContext = self.myManagedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "loying.lin.LearnCoreData" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}





@end
