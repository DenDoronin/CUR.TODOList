//
//  DORDetailModel.h
//  MyFriends
//
//  Created by Doronin Denis on 11/13/15.
//  Copyright © 2015 Doronin Denis. All rights reserved.
//

#import "DORBaseModel.h"
#import "DORTextValidatorEmail.h"
#import "DORTextValidatorNumeric.h"
#import "DOREmptyValidator.h"

@interface DORDetailModel : DORBaseModel

@property (nonatomic,strong) DOREmptyValidator *validatorFirst;
@property (nonatomic,strong) DOREmptyValidator *validatorLast;
@property (nonatomic,strong) DORTextValidatorEmail *validatorEmail;
@property (nonatomic,strong) DORTextValidatorNumeric *validatorPhone;


@property (nonatomic,strong) DORUser *friendObj;

- (void) updateProfile;
- (BOOL) canSave;
- (void) save;
@end
