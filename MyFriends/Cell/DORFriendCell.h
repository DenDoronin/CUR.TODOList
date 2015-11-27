//
//  DORFriendCell.h
//  MyFriends
//
//  Created by Doronin Denis on 11/12/15.
//  Copyright © 2015 Doronin Denis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DORFriendCell : UITableViewCell<DORReactiveView>
@property (weak, nonatomic) IBOutlet UIImageView *ivPhoto;
@property (weak, nonatomic) IBOutlet UILabel *lblNameFirst;
@property (weak, nonatomic) IBOutlet UILabel *lblNameLast;

@end
