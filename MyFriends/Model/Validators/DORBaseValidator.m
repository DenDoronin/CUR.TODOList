//
//  CURBaseValidator.m
//  CURPay
//
//  Created by Doronin Denis on 10/5/15.
//  Copyright © 2015 Doronin Denis. All rights reserved.
//

#import "DORBaseValidator.h"

@implementation DORBaseValidator

- (NSString*)   stripInputValue:        (NSString*) inputValue
{
    return inputValue;
}
- (NSString*)   stripAndMaskInputValue: (NSString*) inputValue
{
    return inputValue;
}
- (BOOL)        isValidInputValue:      (NSString*) inputValue
{
    return YES;
}


@end
