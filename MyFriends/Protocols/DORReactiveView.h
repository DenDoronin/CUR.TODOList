//
//  CURReactiveView.h
//  BTC-exchange
//
//  Created by Doronin Denis on 4/9/15.
//  Copyright (c) 2015 CuriousIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DORReactiveView <NSObject>


@required
/// Binds the given view model to the view
- (void)bindViewModel:(id)viewModel;

@optional
- (void)validateViewModel:(id)viewModel;


@end
