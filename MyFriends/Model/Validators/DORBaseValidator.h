//
//  CURBaseValidator.h
//  CURPay
//
//  Created by Doronin Denis on 10/5/15.
//  Copyright © 2015 Doronin Denis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DORTextFieldValidatorProtocol.h"
@interface DORBaseValidator : NSObject<DORTextFieldValidatorProtocol>{
    @protected
    BOOL _isValid;
    NSString*  _errorText;
}
@property (nonatomic, readonly)          BOOL       isValid;
@property (nonatomic, strong)            NSString*  validatedText;
@property (nonatomic, readonly, strong)  NSString*  errorText;

- (NSString*)   stripInputValue:        (NSString*) inputValue;
- (NSString*)   stripAndMaskInputValue: (NSString*) inputValue;
- (BOOL)        isValidInputValue:      (NSString*) inputValue;



@end
