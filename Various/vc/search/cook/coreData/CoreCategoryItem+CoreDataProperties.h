//
//  CoreCategoryItem+CoreDataProperties.h
//  Various
//
//  Created by 林伟池 on 15/12/29.
//  Copyright © 2015年 林伟池. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CoreCategoryItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoreCategoryItem (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *id;
@property (nullable, nonatomic, retain) NSString *title;

@end

NS_ASSUME_NONNULL_END
