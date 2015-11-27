//
//  CURBaseModel.h
//  CURPay
//
//  Created by Doronin Denis on 9/28/15.
//  Copyright © 2015 Doronin Denis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DORModelProtocol.h"
#import "DORBaseValidator.h"
@interface DORBaseModel : NSObject<DORModelProtocol>
{
    @protected
    id _provider;
    NSString *_activityMessage;
    BOOL _canEdit;
}

@property (nonatomic, readonly, strong) NSString*                    activityMessage;
@property (nonatomic, readonly)         BOOL                         canEdit;
@property (nonatomic, readonly)         id                           provider;
@property (nonatomic, weak)             id<DORModelActivityDelegate> delegate;


- (instancetype) initWithManagerProvider:(id)provider;
- (void)         startActivity;
- (void)         finishActivity;
@end
