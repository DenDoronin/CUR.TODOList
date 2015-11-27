//
//  CURTextFieldValidatorProtocol.h
//  CURPay
//
//  Created by Doronin Denis on 10/1/15.
//  Copyright © 2015 Doronin Denis. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DORTextFieldValidatorProtocol <NSObject>


@property (nonatomic, readonly)          BOOL       isValid;
@property (nonatomic, strong)            NSString*  validatedText;
@property (nonatomic, readonly, strong)  NSString*  errorText;

- (NSString*)   stripInputValue:        (NSString*) inputValue;
- (NSString*)   stripAndMaskInputValue: (NSString*) inputValue;
- (BOOL)        isValidInputValue:      (NSString*) inputValue;

@end
