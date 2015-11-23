//
//  CURModelProtocol.h
//  BTC-exchange
//
//  Created by   Doro on 10/29/14.
//  Copyright (c) 2014 CuriousIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DORModelProtocol <NSObject>

- (instancetype)initWithManagerProvider:(id)provider;
- (void) updateData;
@optional

- (void) startActivity;
- (void) finishActivity;
- (void) cancelOperation;

@end

@protocol DORModelActivityDelegate <NSObject>
@required

- (void) modelDidUpdate:(id)model;
- (void) modelDidFailWithError: (NSError*) error;

@optional

- (void) modelDidFetchData;

- (void) modelDidStartActivity:(id)model;
- (void) modelDidFinishActivity:(id)model;



@end


@protocol DORTableModelActivityDelegate <CURModelActivityDelegate>

@required

- (void) shouldUpdateCellAtIndexPath:(NSIndexPath*)indexPath;

@optional

- (void) shouldUpdateCellsAtIndexPathes:(NSArray*)indexPathes;
- (void) shouldUpdateSections:(NSIndexSet *)sections;
- (void) shouldInsertCellsAtIndexPaths: (NSArray*) indexPaths;
- (void) shouldShowContext: (id) context;

@end
