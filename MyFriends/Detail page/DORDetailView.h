//
//  DORDetailView.h
//  MyFriends
//
//  Created by Doronin Denis on 11/13/15.
//  Copyright © 2015 Doronin Denis. All rights reserved.
//

#import "DORBaseView.h"

@interface DORDetailView : DORBaseView

@property (weak, nonatomic) IBOutlet UIImageView *ivPhoto;
@property (weak, nonatomic) IBOutlet UITextField *tfFirst;
@property (weak, nonatomic) IBOutlet UITextField *tfLast;
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
@property (weak, nonatomic) IBOutlet UITextField *tfPhone;

@end
