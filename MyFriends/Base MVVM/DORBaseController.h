//
//  CURBaseController.h
//  CURPay
//
//  Created by Doronin Denis on 9/28/15.
//  Copyright © 2015 Doronin Denis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DORBaseModel.h"
#import "DORBaseView.h"
@interface DORBaseController : UIViewController<DORModelActivityDelegate>

@property (nonatomic, strong) DORBaseView *view;
@property (nonatomic, strong) DORBaseModel *model;

- (void) bindViewModel;

// override this method and bind model values with validatedText property of textfield
//vs
// errorText from validator to target label object
// also, setup here concrete validator for textfield
- (void) bindTextfieldTextAndError;
@end
