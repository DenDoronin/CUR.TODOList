//
//  DORFriendCell.m
//  MyFriends
//
//  Created by Doronin Denis on 11/12/15.
//  Copyright © 2015 Doronin Denis. All rights reserved.
//

#import "DORFriendCell.h"

@implementation DORFriendCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)bindViewModel:(id)viewModel
{
    DORUser *friend = viewModel;
    self.lblNameFirst.text = friend.name.first;
    self.lblNameLast.text = friend.name.last;
    if (friend.picture.medium)
        self.ivPhoto.image =[UIImage imageWithData: friend.picture.medium];
    else
        if (friend.picture.mediumFailed.boolValue == NO)
            self.ivPhoto.image = [UIImage imageNamed:@"DORIconFriendsEmpty"];
    else
        self.ivPhoto.image = [UIImage imageNamed:@"DORFriendFailed"];
    
}
@end
