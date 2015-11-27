//
//  UITextField+Validation.h
//  CURPay
//
//  Created by Doronin Denis on 10/1/15.
//  Copyright © 2015 Doronin Denis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DORBaseValidator.h"
#import "DORBubbleView.h"

@interface UITextField (Validation)<UIGestureRecognizerDelegate>

@property (nonatomic, strong) DORBaseValidator *validator;
@property (nonatomic, retain) DORBubbleView *tipView;

@end
