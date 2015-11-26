//
//  DORFriendsListController.h
//  MyFriends
//
//  Created by Doronin Denis on 11/13/15.
//  Copyright © 2015 Doronin Denis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DORBaseTableViewController.h"
#import "DORFriendsListModel.h"

@interface DORFriendsListController : DORBaseTableViewController

@property (nonatomic, strong) DORFriendsListModel *model;

@end
