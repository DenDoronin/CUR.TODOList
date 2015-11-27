//
//  CURTextValidatorNumeric.m
//  CURPay
//
//  Created by Doronin Denis on 10/5/15.
//  Copyright © 2015 Doronin Denis. All rights reserved.
//

#import "DORTextValidatorNumeric.h"
@interface DORTextValidatorNumeric()

@property (nonatomic, readwrite)          BOOL       isValid;
@property (nonatomic, readwrite, strong)  NSString*  errorText;

@end

@implementation DORTextValidatorNumeric

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

- (NSString*)   stripInputValue:        (NSString*) inputValue
{
    NSMutableString *strippedString = [NSMutableString
                                       stringWithCapacity:inputValue.length];
    
    NSScanner *scanner = [NSScanner scannerWithString:inputValue];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    [formatter setLocale:[NSLocale currentLocale]];
    NSString *decimalSymbol = [formatter decimalSeparator];
    
    NSCharacterSet *validCharacters = [NSCharacterSet characterSetWithCharactersInString:[@"1234567890 ()-+" stringByAppendingString:decimalSymbol]];
    
    while ([scanner isAtEnd] == NO) {
        NSString *buffer;
        if ([scanner scanCharactersFromSet:validCharacters intoString:&buffer]) {
            [strippedString appendString:buffer];
            
        } else {
            [scanner setScanLocation:([scanner scanLocation] + 1)];
        }
    }
    return strippedString;
}

- (NSString*)   stripAndMaskInputValue: (NSString*) inputValue
{
    NSString *validatedValue  = [self stripInputValue:inputValue];
    return validatedValue;
}

- (BOOL)        isValidInputValue:      (NSString*) inputValue
{
   
    inputValue = [self stripInputValue:inputValue];
    BOOL isValid = inputValue && ![inputValue isEqualToString:@""];
    
    if (isValid)
    {

        isValid = [[self stripInputValue:inputValue] isEqualToString:inputValue];
        if (isValid)
        {
            self.isValid = YES;
        }
        else
        {
            self.isValid = NO;
            self.errorText = _isValid?@"":NSLocalizedString(@"Incorrect numeric value", nil);
        }
    }
    else
    {
        self.isValid = NO;
        self.errorText = self.errorTextEmptyNumericValue?:NSLocalizedString(@"Value shouldn't be empty", nil);
    }
    return self.isValid;
    
}

@end
