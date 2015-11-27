//
//  UIView+Animations.h
//  BTC-exchange
//
//  Created by   Doro on 11/13/14.
//  Copyright (c) 2014 CuriousIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Animations)

-(void)shake:(UIView *)view vibration: (BOOL) on;

@property (nonatomic, retain) NSMutableArray *currentlyShakingViews;


@end
