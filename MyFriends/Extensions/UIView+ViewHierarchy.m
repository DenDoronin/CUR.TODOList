//
//  UIView+ViewHierarchy.m
//  CURPay
//
//  Created by Doronin Denis on 9/29/15.
//  Copyright © 2015 Doronin Denis. All rights reserved.
//

#import "UIView+ViewHierarchy.h"

@implementation UIView (ViewHierarchy)



- (NSArray*) itemsOfClass: (Class) itemClass
{
    NSMutableArray *filteredObjects = [NSMutableArray new];
    
    for ( UIView *v in self.subviews)
    {
        if ( [v isKindOfClass:itemClass])
        {
            [filteredObjects addObject:v];
        }
        [filteredObjects addObjectsFromArray:[v itemsOfClass:itemClass]];
    }
    return filteredObjects;
}

- (void) setTextfieldsEnabled: (BOOL) enabled
{
    for (UITextField *t in [self itemsOfClass:[UITextField class]])
    {
        [t setEnabled:enabled];
    }
}

- (void) setButtonsEnabled: (BOOL) enabled
{
    for (UIButton *b in [self itemsOfClass:[UIButton class]])
    {
        [b setEnabled:enabled];
    }
}

- (void) setSubviewsEnabled: (BOOL) enabled
{
    
    for ( UIView *v in self.subviews)
    {
        if ( [v respondsToSelector:@selector(setEnabled:)])
        {
            [v performSelector:@selector(setEnabled:) withObject:@(enabled)];
        }
        [v setSubviewsEnabled:enabled];
    }
}

- (NSArray*) orderedTextfieldForReturnAction
{
    NSArray * orederdTextfields = [self itemsOfClass:[UITextField class]];
    
    NSArray *sorted  = [orederdTextfields sortedArrayUsingComparator:^NSComparisonResult(UITextField *obj1, UITextField *obj2) {
            if (obj1.frame.origin.y < obj2.frame.origin.y)
                return  NSOrderedAscending;
            else
                if (obj1.frame.origin.y > obj2.frame.origin.y)
                    return NSOrderedDescending;
            else
                if (obj1.frame.origin.x < obj2.frame.origin.x)
                    return  NSOrderedAscending;
            else
                if (obj1.frame.origin.x > obj2.frame.origin.x)
                    return  NSOrderedDescending;
                else
                    return NSOrderedSame;
            
    }];
    return sorted;
}


@end
