//
//  DORFriendsListModel.h
//  MyFriends
//
//  Created by Doronin Denis on 11/13/15.
//  Copyright © 2015 Doronin Denis. All rights reserved.
//

#import "DORBaseTableModel.h"
@interface DORFriendsListModel : DORBaseTableModel

@property (nonatomic, strong) id selectedFriend;


- (void) saveAsFriend: (DORUser*) friendObjec;
@end
