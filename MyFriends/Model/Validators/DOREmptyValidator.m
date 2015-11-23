//
//  CURLoginValidator.m
//  Canopus
//
//  Created by Doronin Denis on 11/3/15.
//  Copyright © 2015 Doronin Denis. All rights reserved.
//

#import "DOREmptyValidator.h"
@interface DOREmptyValidator()

@property (nonatomic, readwrite)          BOOL       isValid;
@property (nonatomic, readwrite, strong)  NSString*  errorText;

@end

@implementation DOREmptyValidator


@dynamic isValid;
@dynamic errorText;

- (void) setIsValid:(BOOL)isValid
{
    _isValid = isValid;
}

- (void) setErrorText:(NSString *)errorText
{
    _errorText = errorText;
}

- (BOOL)        isValidInputValue:      (NSString*) inputValue
{
    
    BOOL isValid = inputValue && ![inputValue isEqualToString:@""];
    
    if (isValid)
    {
        self.errorText = @"";
        
    }
    else
    {
        isValid = NO;
        self.errorText = NSLocalizedString(@"Login shouldn't be empty", nil);
    }
    
    self.isValid = isValid;
    
    return self.isValid;
    
}

@end
