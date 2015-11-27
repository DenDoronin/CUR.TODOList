//
//  UIView+ViewHierarchy.h
//  CURPay
//
//  Created by Doronin Denis on 9/29/15.
//  Copyright © 2015 Doronin Denis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ViewHierarchy)

- (NSArray*) itemsOfClass:      (Class) itemClass;
- (NSArray*) orderedTextfieldForReturnAction;

- (void) setSubviewsEnabled:    (BOOL)  enabled;
- (void) setTextfieldsEnabled:  (BOOL)  enabled;
- (void) setButtonsEnabled:     (BOOL)  enabled;

@end
