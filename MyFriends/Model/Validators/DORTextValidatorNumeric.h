//
//  CURTextValidatorNumeric.h
//  CURPay
//
//  Created by Doronin Denis on 10/5/15.
//  Copyright © 2015 Doronin Denis. All rights reserved.
//

#import "DORBaseValidator.h"

@interface DORTextValidatorNumeric : DORBaseValidator

@property (nonatomic, strong) NSNumber *minValue;
@property (nonatomic, strong) NSNumber *maxValue;

@property (nonatomic, strong) NSString* errorTextEmptyNumericValue;
@end
