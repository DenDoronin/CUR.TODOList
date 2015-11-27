//
//  DORBaseTableViewController.m
//  MyFriends
//
//  Created by Doronin Denis on 11/13/15.
//  Copyright © 2015 Doronin Denis. All rights reserved.
//

#import "DORBaseTableViewController.h"

@interface DORBaseTableViewController ()

@end

@implementation DORBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    // A little trick for removing the cell separators
    self.tableView.tableFooterView = [UIView new];
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)modelDidUpdate:(id)model
{
    [self.tableView reloadData];
}

- (void)modelDidStartActivity:(id)model
{
    [SVProgressHUD showWithStatus:self.model.activityMessage];
}

- (void)modelDidFinishActivity:(id)model
{
    [SVProgressHUD popActivity];
}

- (void) modelDidFailWithError:(NSError*) error
{
    NSString *message = [error.userInfo objectForKey:NSLocalizedDescriptionKey];
    
    if (!message)
        message =NSLocalizedString(@"Internal error", nil);
    
    [TSMessage showNotificationInViewController:self.navigationController?:self
                                          title:NSLocalizedString(@"Error", nil)
                                       subtitle:message
                                          image:nil
                                           type:TSMessageNotificationTypeError
                                       duration:TSMessageNotificationDurationAutomatic
                                       callback:nil
                                    buttonTitle:nil
                                 buttonCallback:nil
                                     atPosition:TSMessageNotificationPositionNavBarOverlay
                           canBeDismissedByUser:YES];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"DORIconFriendsEmpty"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text =self.emptyTableviewText;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}


#pragma mark - Table view data source

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 87;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell<DORReactiveView> *cell = [tableView dequeueReusableCellWithIdentifier:@"DORFriendCell" forIndexPath:indexPath];
    
    [cell bindViewModel:self.model.friends[indexPath.row]];
    // Configure the cell...
    [self.model downloadPreviewForIndexPath:indexPath
                                   ismoving:(!tableView.dragging && !tableView.decelerating)];
    return cell;
}


- (void) shouldUpdateCellAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath)
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark -
#pragma mark - UIScrollView delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // 1
    [self.model suspendAllOperations];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    // 2
    
    if (!decelerate) {
        NSSet *visibleRows = [NSSet setWithArray:[self.tableView indexPathsForVisibleRows]];
        [self.model loadImagesForOnscreenCells:visibleRows ];
        [self.model resumeAllOperations];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 3
    NSSet *visibleRows = [NSSet setWithArray:[self.tableView indexPathsForVisibleRows]];
    [self.model loadImagesForOnscreenCells:visibleRows ];
    [self.model resumeAllOperations];
}


@end
