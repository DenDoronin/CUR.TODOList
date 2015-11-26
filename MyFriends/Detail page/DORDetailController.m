//
//  DORDetailController.m
//  MyFriends
//
//  Created by Doronin Denis on 11/13/15.
//  Copyright © 2015 Doronin Denis. All rights reserved.
//

#import "DORDetailController.h"
#import "DORDetailView.h"
@interface DORDetailController ()

@property (nonatomic, strong) DORDetailView *view;

@end

@implementation DORDetailController

@dynamic model;
@dynamic view;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationItem setTitle:NSLocalizedString(@"My friend detail", nil)];
    
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveFriend:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    [self.navigationItem setHidesBackButton:YES];
    
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
}

- (void) bindTextfieldTextAndError
{
    self.view.tfFirst.validator = self.model.validatorFirst;
    self.view.tfLast.validator = self.model.validatorLast;
    
    self.view.tfEmail.validator = self.model.validatorEmail;
    self.view.tfPhone.validator = self.model.validatorPhone;
    
    self.view.tfFirst.text = [self.view.tfFirst.validator stripAndMaskInputValue:self.model.friendObj.name.first];
    self.view.tfLast .text = [self.view.tfLast.validator stripAndMaskInputValue:self.model.friendObj.name.last];
    self.view.tfEmail.text = [self.view.tfEmail.validator stripAndMaskInputValue:self.model.friendObj.email];
    self.view.tfPhone.text = [self.view.tfPhone.validator stripAndMaskInputValue:self.model.friendObj.phone];
    
    self.view.ivPhoto.image = [UIImage imageWithData: self.model.friendObj.picture.medium];
    
    [self.model updateProfile];
    
    [RACObserve(self.model.friendObj.picture, large) subscribeNext:^(id x) {
        if (x)
            self.view.ivPhoto.image = [UIImage imageWithData: x];
    }];
    
}

- (void) saveFriend: (id) sender
{
    if (![self.model canSave])
        return;
    self.model.friendObj.name.first =self.view.tfFirst.text;
    self.model.friendObj.name.last = self.view.tfLast.text;
    self.model.friendObj.email = self.view.tfEmail.text;
    self.model.friendObj.phone = self.view.tfPhone.text;
    [self.model save];
    NSLog(@"save");
}

- (void) cancelAction: (id) sender
{
    NSLog(@"cancel");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) modelDidUpdate:(id)model
{
     [self.navigationController popViewControllerAnimated:YES];
}


@end
