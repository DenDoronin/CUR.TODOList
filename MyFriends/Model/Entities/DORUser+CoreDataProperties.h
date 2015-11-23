//
//  DORUser+CoreDataProperties.h
//  MyFriends
//
//  Created by Doronin Denis on 11/13/15.
//  Copyright © 2015 Doronin Denis. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DORUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface DORUser (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *gender;
@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSString *username;
@property (nullable, nonatomic, retain) NSString *password;
@property (nullable, nonatomic, retain) NSString *salt;
@property (nullable, nonatomic, retain) NSString *md5;
@property (nullable, nonatomic, retain) NSString *sha1;
@property (nullable, nonatomic, retain) NSString *sha256;
@property (nullable, nonatomic, retain) NSNumber *registered;
@property (nullable, nonatomic, retain) NSNumber *dob;
@property (nullable, nonatomic, retain) NSString *phone;
@property (nullable, nonatomic, retain) NSString *cell;
@property (nullable, nonatomic, retain) NSString *bsn;
@property (nullable, nonatomic, retain) NSNumber *isFriend;
@property (nullable, nonatomic, retain) DORLocation *location;
@property (nullable, nonatomic, retain) DORName *name;
@property (nullable, nonatomic, retain) DORPicture *picture;

@end

NS_ASSUME_NONNULL_END
