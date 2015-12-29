//
//  CoreCategoryList+CoreDataProperties.h
//  Various
//
//  Created by 林伟池 on 15/12/29.
//  Copyright © 2015年 林伟池. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CoreCategoryList.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoreCategoryList (CoreDataProperties)

@property (nullable, nonatomic, retain) CoreCategoryItem *titleItem;
@property (nullable, nonatomic, retain) NSSet<CoreCategoryItem *> *titleList;

@end

@interface CoreCategoryList (CoreDataGeneratedAccessors)

- (void)addTitleListObject:(CoreCategoryItem *)value;
- (void)removeTitleListObject:(CoreCategoryItem *)value;
- (void)addTitleList:(NSSet<CoreCategoryItem *> *)values;
- (void)removeTitleList:(NSSet<CoreCategoryItem *> *)values;

@end

NS_ASSUME_NONNULL_END
