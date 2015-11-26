//
//  DORMainPageController.h
//  MyFriends
//
//  Created by Doronin Denis on 11/12/15.
//  Copyright © 2015 Doronin Denis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DORMainPageModel.h"
#import "DORBaseTableViewController.h"
@interface DORMainPageController : DORBaseTableViewController

@property (nonatomic, strong) DORMainPageModel *model;
@end
