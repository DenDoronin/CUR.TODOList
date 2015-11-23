//
//  CURBaseModel.m
//  CURPay
//
//  Created by Doronin Denis on 9/28/15.
//  Copyright © 2015 Doronin Denis. All rights reserved.
//

#import "DORBaseModel.h"

@implementation DORBaseModel


- (instancetype)initWithManagerProvider:(id)provider
{
    if (self = [super init])
    {
        NSParameterAssert(provider);
        _provider = provider;
        _canEdit = YES;
        _activityMessage = @"";
    }
    return self;
}
- (void) updateData
{
    
}

- (void)startActivity
{
    _canEdit = NO;
    //NSParameterAssert(self.delegate);
    if ([self.delegate respondsToSelector:@selector(modelDidStartActivity:)])
    {
        @weakify(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self)
            [self.delegate modelDidStartActivity:self];
        });
    }
}

- (void)finishActivity
{
    _canEdit = YES;
    _activityMessage = @"";
    //NSParameterAssert(self.delegate);
    if ([self.delegate respondsToSelector:@selector(modelDidFinishActivity:)])
    {
        @weakify(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self)
            [self.delegate modelDidFinishActivity:self];
        });
        
    }
}

@end
