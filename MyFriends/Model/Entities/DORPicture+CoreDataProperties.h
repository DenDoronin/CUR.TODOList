//
//  DORPicture+CoreDataProperties.h
//  MyFriends
//
//  Created by Doronin Denis on 11/13/15.
//  Copyright © 2015 Doronin Denis. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DORPicture.h"

NS_ASSUME_NONNULL_BEGIN

@interface DORPicture (CoreDataProperties)

@property (nullable, nonatomic, retain) NSData *large;
@property (nullable, nonatomic, retain) NSData *medium;
@property (nullable, nonatomic, retain) NSData *thumbnail;
@property (nullable, nonatomic, retain) NSString *largeURL;
@property (nullable, nonatomic, retain) NSString *mediumURL;
@property (nullable, nonatomic, retain) NSString *thumbnailURL;
@property (nullable, nonatomic, retain) NSNumber *largeFailed;
@property (nullable, nonatomic, retain) NSNumber *mediumFailed;
@property (nullable, nonatomic, retain) NSNumber *thumbnailFailed;
@property (nullable, nonatomic, retain) DORUser *user;

@end

NS_ASSUME_NONNULL_END
