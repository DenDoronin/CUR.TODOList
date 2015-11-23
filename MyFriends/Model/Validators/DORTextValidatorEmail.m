//
//  CURTextValidatorEmail.m
//  CURPay
//
//  Created by Doronin Denis on 10/5/15.
//  Copyright © 2015 Doronin Denis. All rights reserved.
//

#import "DORTextValidatorEmail.h"

@interface DORTextValidatorEmail()

@property (nonatomic, readwrite)          BOOL       isValid;
@property (nonatomic, readwrite, strong)  NSString*  errorText;

@end

static NSString *   const kTextValidatorEmailRegularExpression =
                            @"^([a-zA-Z0-9_-]+\\.)*[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)*\\.[a-zA-Z]{2,6}$";
static NSString *   const kTextValidatorEmailLatinLettersRegularExpression =
                            @"^[\\p{L}&&[^a-zA-Z]]$";

@implementation DORTextValidatorEmail

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
    NSCharacterSet *validCharacters = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_-@."];
    
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
    NSRegularExpression *regex =
    [NSRegularExpression
     regularExpressionWithPattern:kTextValidatorEmailRegularExpression
     options:NSRegularExpressionCaseInsensitive
     error:nil];
    
    BOOL isValid = inputValue && ![inputValue isEqualToString:@""];
    
    if (isValid)
    {
        self.isValid = [[regex matchesInString:inputValue
                                  options:0
                                    range:NSMakeRange(0, [inputValue length])] count];
        self.errorText = _isValid?@"":NSLocalizedString(@"Incorrect email", nil);
    }
    else
    {
        self.isValid = NO;
        self.errorText = NSLocalizedString(@"Email shouldn't be empty", nil);
    }
    return self.isValid;

}


@end
