//
//  DORName+CoreDataProperties.h
//  MyFriends
//
//  Created by Doronin Denis on 11/13/15.
//  Copyright © 2015 Doronin Denis. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DORName.h"

NS_ASSUME_NONNULL_BEGIN

@interface DORName (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *first;
@property (nullable, nonatomic, retain) NSString *last;
@property (nullable, nonatomic, retain) DORUser *user;

@end

NS_ASSUME_NONNULL_END
