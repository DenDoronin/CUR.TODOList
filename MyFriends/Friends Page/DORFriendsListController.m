//
//  DORFriendsListController.m
//  MyFriends
//
//  Created by Doronin Denis on 11/13/15.
//  Copyright © 2015 Doronin Denis. All rights reserved.
//

#import "DORFriendsListController.h"


@interface DORFriendsListController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end

@implementation DORFriendsListController

@dynamic model;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSParameterAssert(self.model);
    
    [self.navigationItem setTitle:NSLocalizedString(@"Choose friend", nil)];
    [self setEmptyTableviewText:NSLocalizedString(@"Possible friends", nil)];

    NSParameterAssert(self.model);
  
    self.model.delegate = self;
    [self.model updateData];
    [self setupRefresh];
    
}

- (void) setupRefresh
{
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor blackColor];
    [self.refreshControl addTarget:self
                            action:@selector(update)
                  forControlEvents:UIControlEventValueChanged];

}

- (void) update {
    [self.model cancelAllOperations];
    [self.model updateData];
}

- (void) modelDidFinishActivity:(id)model
{
    [super modelDidFinishActivity:model];
    [self.refreshControl endRefreshing];
}

- (void) dealloc
{
    [self modelDidFinishActivity:self.model];
    [self.model cancelAllOperations];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.model saveAsFriend:self.model.friends[indexPath.row]];
}


@end
