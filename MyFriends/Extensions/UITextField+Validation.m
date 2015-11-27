//
//  UITextField+Validation.m
//  CURPay
//
//  Created by Doronin Denis on 10/1/15.
//  Copyright © 2015 Doronin Denis. All rights reserved.
//

#import "UITextField+Validation.h"
#import <objc/runtime.h>
#import "UIView+Components.h"

#define textFieldBackgroundColor RGBA(50, 53, 60, 0.0*255)
#define textFieldActiveColor RGB(75, 183, 73)
#define textFieldErrorColor RGB(226, 82, 88)
#define textFieldPassiveColor RGBA(50,53,60,255)
#define textFieldTextColorActive RGBA(50,53,60,255)
#define textFieldTextColor RGBA(50,53,60,255)
#define textFieldTintColor RGBA(50,53,60,255)

@implementation UITextField (Validation)


@dynamic validator;


- (DORBubbleView*) tipView {
    return objc_getAssociatedObject(self, @selector(tipView));
}

- (void)setTipView: (DORBubbleView*) tipView {
    objc_setAssociatedObject(self, @selector(tipView), tipView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void) showTipWithText:(NSString*) text
                tipPoint: (CGPoint) tipPoint
            tipDirection: (DORBubbleTipDirection) direction
               presenter: (UIView*) presenter
{
    
   // tipPoint = [self convertPoint:tipPoint toView:[UIApplication sharedApplication].keyWindow];
    
    self.tipView = [DORBubbleView viewWithText:text
                                     tipPoint:tipPoint
                                 tipDirection:direction];
    self.tipView.backgroundColor = [UIColor redColor];
    self.tipView.font = [UIFont systemFontOfSize: 17.0];
    [presenter addSubview:[self.tipView popIn]];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];

    tap.numberOfTouchesRequired = 1;
    tap.cancelsTouchesInView = NO;
    [[UIApplication sharedApplication].keyWindow addGestureRecognizer:tap];
    tap.delegate  = self;
    [[self rac_signalForSelector:@selector(dismissTip)] subscribeNext:^(id x) {
        [self removeTapGestureRecognizer:tap];
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void) removeTapGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    [gestureRecognizer removeTarget:self action:@selector(tapAction:)];
    [[UIApplication sharedApplication].keyWindow removeGestureRecognizer:gestureRecognizer];
}

- (void) tapAction: (UITapGestureRecognizer*) sender
{
    [self dismissTip];
}

- (void) dismissTip
{
    [self.tipView popOut];
    self.tipView = nil;
}


- (id) validator {
    return objc_getAssociatedObject(self, @selector(validator));
}

- (void)setValidator: (id) validator {
    
    objc_setAssociatedObject(self, @selector(validator), validator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    RAC(self, text) = [self.rac_textSignal map:^id(NSString *value) {
        return [self.validator stripAndMaskInputValue:value];
    }];
    RAC(self.validator,validatedText) = [RACObserve(self, text) map:^id(NSString *value) {
        return [self.validator stripInputValue:value];
    }];
    
    [self bindAndDecorate];
    
}

- (void) drawBottomLineWithColor: (UIColor*) color
{
    UIView *bottomBorder = [self viewWithTag:100500];
    if (!bottomBorder)
    {
        bottomBorder = [[UIView alloc]
                        initWithFrame:CGRectMake(0,
                                                 self.bounds.size.height - 1.0f,
                                                 self.bounds.size.width,
                                                 1.0f)];
        
        bottomBorder.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:bottomBorder];
        
        NSDictionary *views = @{@"bottomBorder":bottomBorder};
        
        [self addConstraints:[NSLayoutConstraint
                                   constraintsWithVisualFormat:@"H:|-(-1)-[bottomBorder]-(-1)-|"
                                   options:0
                                   metrics:nil
                                   views:views]];
        
        [bottomBorder addConstraint:[NSLayoutConstraint constraintWithItem:bottomBorder attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:1]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:bottomBorder attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self  attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
        
        bottomBorder.tag = 100500;
        
        
        
    }
    bottomBorder.backgroundColor = color;
}


- (UIView*) paddingView
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
}

- (UIButton*) rightPadingButton
{
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearButton setFrame:CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.height)];
    [clearButton setImage:[UIImage imageNamed:@"dor_attention"] forState:UIControlStateNormal];
    
    @weakify(self)
    [[clearButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        if (self.validator.errorText && !self.tipView)
        {
            CGPoint center= [self convertPoint:clearButton.center toView:[self superview]] ;
            [self showTipWithText:self.validator.errorText tipPoint:center tipDirection:DORBubbleTipDirectionUp presenter:[self superview]];
        }
        else
        {
            if (self.tipView)
                [self dismissTip];
        }
    }];
    
    [clearButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:clearButton];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:clearButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:clearButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:clearButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:10]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:clearButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    return clearButton;

}

-(void) bindAndDecorate
{
    self.clipsToBounds = NO;
    self.leftViewMode = UITextFieldViewModeAlways;
    self.borderStyle = UITextBorderStyleNone;
    self.tintColor = textFieldTintColor;
    self.backgroundColor = textFieldBackgroundColor;
    [self setNeedsDisplay];
    self.textColor = textFieldTextColor;
    self.leftView = [self paddingView];
    //
    UIButton *rightPaddingButton = [self rightPadingButton];
    
    @weakify(self)
    
    [RACObserve(rightPaddingButton, hidden) subscribeNext:^(NSNumber *hidden) {
        @strongify(self)
        if (hidden.boolValue)
            self.rightView = nil;
        else
            self.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rightPaddingButton.bounds.size.width, rightPaddingButton.bounds.size.height)];
    }];
    
    
    [RACObserve(self, enabled)  subscribeNext:^(NSNumber *enabled) {
        @strongify(self)
        [self drawBottomLineWithColor:enabled.boolValue?textFieldPassiveColor:[UIColor clearColor]];
        [self setNeedsDisplay];
        
    }];
    //
    
    [[self rac_signalForControlEvents:UIControlEventEditingDidEnd]
    subscribeNext:^(id x) {
        self.textColor = textFieldTextColor;
        [self drawBottomLineWithColor:textFieldPassiveColor ];
    }];
    
    [[self rac_signalForControlEvents:UIControlEventEditingDidBegin]
     subscribeNext:^(UITextField *t) {
         @strongify(self)
         
         if (self.tipView)
             [self dismissTip];
         [rightPaddingButton setHidden:YES];
         self.textColor = textFieldTextColorActive;
         [self drawBottomLineWithColor:textFieldActiveColor ];
     }];
    if (self.validator)
        [[RACObserve(self.validator, errorText)
          map:^id(NSString *text) {
              return @(![text isEqualToString:@""] && text);
          }]
         subscribeNext:^(NSNumber *isValid) {
             BOOL isNotEmpty = [isValid boolValue];
             if (isNotEmpty)
             {
                 [rightPaddingButton setHidden:NO];
                 self.textColor = textFieldErrorColor;
                 [self shake:rightPaddingButton vibration:NO];
                 [self drawBottomLineWithColor:textFieldErrorColor];
                 
             }
             else
             {
                 [rightPaddingButton setHidden:YES];
                 self.textColor = textFieldTextColor;
                 [self drawBottomLineWithColor:self.enabled?textFieldPassiveColor:[UIColor clearColor]];
             }
         }];
    
}



@end
