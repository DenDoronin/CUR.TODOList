//
//  CURBaseView.m
//  CURPay
//
//  Created by Doronin Denis on 9/28/15.
//  Copyright © 2015 Doronin Denis. All rights reserved.
//

#import "DORBaseView.h"

@implementation DORBaseView

- (void) decorate
{
    UIImage *backgroundImage = nil;
    self.background = [[UIImageView alloc] initWithImage:backgroundImage];
    
    
    
    self.background.contentMode = UIViewContentModeScaleAspectFill;
    self.background.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.background];
    
    NSDictionary *views = @{@"background":self.background};
    
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|[background]|"
                          options:0
                          metrics:nil
                          views:views]];
    
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|-49-[background]"
                          options:0
                          metrics:nil
                          views:views]];
    
    [self sendSubviewToBack:self.background];

}

@end
