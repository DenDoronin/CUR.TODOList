//
//  DORLocation+CoreDataProperties.h
//  MyFriends
//
//  Created by Doronin Denis on 11/13/15.
//  Copyright © 2015 Doronin Denis. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DORLocation.h"

NS_ASSUME_NONNULL_BEGIN

@interface DORLocation (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *street;
@property (nullable, nonatomic, retain) NSString *city;
@property (nullable, nonatomic, retain) NSNumber *zip;
@property (nullable, nonatomic, retain) NSString *state;
@property (nullable, nonatomic, retain) DORUser *user;

@end

NS_ASSUME_NONNULL_END
