//
//  DORMainPageController.m
//  MyFriends
//
//  Created by Doronin Denis on 11/12/15.
//  Copyright © 2015 Doronin Denis. All rights reserved.
//

#import "DORMainPageController.h"
#import "DORFriendsListController.h"
#import "DORDetailController.h"

#import "UIScrollView+EmptyDataSet.h"

@interface DORMainPageController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) NSIndexPath *selectedIndex;

@end

@implementation DORMainPageController
@dynamic model;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:NSLocalizedString(@"My friends", nil)];
    [self setEmptyTableviewText:NSLocalizedString(@"Press add button to find friends", nil)];
    
    self.model = [[DORMainPageModel alloc] init];
    self.model.delegate = self;
    [self.model updateData];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.model deleteFriendAtIndexPath:indexPath];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndex = indexPath;
    [self performSegueWithIdentifier:@"DORDetailSegue" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"DORFriendsSegue"])
    {
        DORFriendsListController *vc = segue.destinationViewController;
        DORFriendsListModel *model = [DORFriendsListModel new];
        vc.model = model;
        [RACObserve(model, selectedFriend) subscribeNext:^(id x) {
            [self.navigationController popToViewController:self animated:YES];
            [self.model updateData];
        }];
    }
    
    if ([segue.identifier isEqualToString:@"DORDetailSegue"])
    {
        DORUser *selected = self.model.friends[self.selectedIndex.row];
        DORDetailController *vc = segue.destinationViewController;
        DORDetailModel *model = [DORDetailModel new];
        model.friendObj = selected;
        vc.model = model;
        
        [[vc rac_signalForSelector:@selector(modelDidUpdate:)] subscribeNext:^(id x) {
            [self.tableView reloadRowsAtIndexPaths:@[self.selectedIndex]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            self.selectedIndex = nil;
        }];
        
    }
}


@end
