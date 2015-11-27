//
//  DORBaseTableViewController.h
//  MyFriends
//
//  Created by Doronin Denis on 11/13/15.
//  Copyright © 2015 Doronin Denis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+EmptyDataSet.h"
#import "DORBaseTableModel.h"

@interface DORBaseTableViewController : UITableViewController<DORTableModelActivityDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) DORBaseTableModel *model;
@property (nonatomic, strong) NSString *emptyTableviewText;
- (void) modelDidUpdate:(id)model;

- (void) modelDidStartActivity:(id)model;
- (void) modelDidFinishActivity:(id)model;
- (void) modelDidFailWithError:(NSError*) error;

@end
