//
//  DORMainPageModel.h
//  MyFriends
//
//  Created by Doronin Denis on 11/12/15.
//  Copyright © 2015 Doronin Denis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DORBaseTableModel.h"
@interface DORMainPageModel : DORBaseTableModel


- (void) updateData;
- (void) deleteFriendAtIndexPath: (NSIndexPath*) indexPath;
@end
