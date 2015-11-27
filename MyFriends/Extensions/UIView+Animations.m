//
//  UIView+Animations.m
//  BTC-exchange
//
//  Created by   Doro on 11/13/14.
//  Copyright (c) 2014 CuriousIT. All rights reserved.
//

#import "UIView+Animations.h"
#import <objc/runtime.h>

@implementation UIView (Animations)
@dynamic currentlyShakingViews;


- (NSMutableArray*) currentlyShakingViews {
    return objc_getAssociatedObject(self, @selector(currentlyShakingViews));
}

- (void)setCurrentlyShakingViews: (NSMutableArray*) currentlyShakingViews {
    objc_setAssociatedObject(self, @selector(currentlyShakingViews), currentlyShakingViews, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// shake animation

-(void)shake:(UIView *)view vibration: (BOOL) on
{
    if (!self.currentlyShakingViews) self.currentlyShakingViews = [NSMutableArray array];
    
    if([self.currentlyShakingViews containsObject:view] ) return;
    
    [self.currentlyShakingViews addObject:view];
//    if (on)
//        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    int shakes = 0;
    int direction = 1;
    [self rec_shake:view shakes:shakes direction:direction];
    
}

- (void) rec_shake: (UIView*) view shakes: (NSInteger) shakes direction: (NSInteger) direction
{
    
    [UIView animateWithDuration:0.08 animations:^
     {
         view.transform = CGAffineTransformMakeTranslation(5*direction, 0);
     }
                     completion:^(BOOL finished)
     {
         if(shakes >= 7)
         {
             view.transform = CGAffineTransformIdentity;
             [self.currentlyShakingViews removeObject:view];
             return;
         }
         [self rec_shake:view shakes:shakes+1 direction:direction * -1];
     }];
}
/////
//
/////
@end
