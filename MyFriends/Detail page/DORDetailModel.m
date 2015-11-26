//
//  DORDetailModel.m
//  MyFriends
//
//  Created by Doronin Denis on 11/13/15.
//  Copyright © 2015 Doronin Denis. All rights reserved.
//

#import "DORDetailModel.h"
#import "AppDelegate.h"
@interface DORDetailModel()


@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong)  AFHTTPRequestOperationManager *manager;

@end

@implementation DORDetailModel

- (NSManagedObjectContext*) managedObjectContext
{
    if (!_managedObjectContext)
    {
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate] ;
        _managedObjectContext = delegate.managedObjectContext;
    }
    return _managedObjectContext;
}


- (DOREmptyValidator*) validatorFirst
{
    if (!_validatorFirst)
    {
        _validatorFirst = [DOREmptyValidator new];
    }
    return _validatorFirst;
}

- (DOREmptyValidator*) validatorLast
{
    if (!_validatorLast)
    {
        _validatorLast = [DOREmptyValidator new];
    }
    return _validatorLast;
}

- (DORTextValidatorEmail*) validatorEmail
{
    if (!_validatorEmail)
    {
        _validatorEmail = [DORTextValidatorEmail new];
    }
    return _validatorEmail;
}

- (DORTextValidatorNumeric*) validatorPhone
{
    if (!_validatorPhone)
    {
        _validatorPhone = [DORTextValidatorNumeric new];
    }
    return _validatorPhone;
}

- (BOOL) canSave
{
    
    BOOL isEmailValid = [self.validatorEmail isValidInputValue:self.validatorEmail.validatedText];
    BOOL isFirstValid = [self.validatorFirst isValidInputValue:self.validatorFirst.validatedText];
    BOOL isLastValid = [self.validatorLast isValidInputValue:self.validatorLast.validatedText];
    BOOL isPhoneValid = [self.validatorPhone isValidInputValue:self.validatorPhone.validatedText];
    
    return isEmailValid && isFirstValid && isLastValid && isPhoneValid;
}

- (void) save
{
    [self saveWithModelUpdate:YES];
}

- (void) saveWithModelUpdate: (BOOL) shouldUpdateModel
{
    [self.managedObjectContext performBlock:^{
        NSError *error;
        
        if (![self.managedObjectContext save:&error])
        {
            [self.delegate modelDidFailWithError:error];
            // handle error
        }
        [self finishActivity];
        if (shouldUpdateModel)
            [self.delegate modelDidUpdate:self];
    }];
    _activityMessage = NSLocalizedString(@"Saving", nil);
    [self startActivity];
    
}


- (void) updateProfile
{
    if (!_canEdit)
        return;
    
    if (!_manager)
    {
        self.manager = [AFHTTPRequestOperationManager manager];
        self.manager.responseSerializer = [AFImageResponseSerializer serializer];

    }

    if (!self.friendObj.picture.largeURL || self.friendObj.picture.large)
        return;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
    [_manager GET:self.friendObj.picture.largeURL
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, UIImage *responseObject) {
              [self finishActivity];
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
              
              self.friendObj.picture.large = UIImagePNGRepresentation(responseObject) ;
            
              [self saveWithModelUpdate:NO];
              
              
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              [self finishActivity];
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
              [self.delegate modelDidFailWithError:error];
          }];
    _activityMessage = NSLocalizedString(@"Updating profile", nil);
    [self startActivity];
}



@end
