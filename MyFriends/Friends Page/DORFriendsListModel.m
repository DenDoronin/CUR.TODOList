//
//  DORFriendsListModel.m
//  MyFriends
//
//  Created by Doronin Denis on 11/13/15.
//  Copyright © 2015 Doronin Denis. All rights reserved.
//

#import "DORFriendsListModel.h"
#import "AppDelegate.h"

@interface DORFriendsListModel()<NSFetchedResultsControllerDelegate>

@property (nonatomic, strong)  AFHTTPRequestOperationManager *manager;
@property (nonatomic, strong) NSManagedObjectContext *childContext;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;


@end

static NSInteger DORDownloadFrinedsLimit = 10;


@implementation DORFriendsListModel


- (NSManagedObjectContext*) managedObjectContext
{
    if (!_managedObjectContext)
    {
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate] ;
        _managedObjectContext = delegate.managedObjectContext;
    }
    return _managedObjectContext;
}

- (void) updateData
{
    if (!_canEdit)
        return;
    
    if (!_manager)
    {
        self.manager = [AFHTTPRequestOperationManager manager];
    }
    
    NSMutableArray *responses = [NSMutableArray new];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
    [self downloadFriends:responses
                  counter:0
                    limit:DORDownloadFrinedsLimit];
    _activityMessage = NSLocalizedString(@"Downloading", nil);
    [self startActivity];
}



- (void) downloadFriends:(NSMutableArray*) responses counter:(NSInteger) counter limit: (NSInteger) limit
{
    [_manager GET:@"https://randomuser.me/api/"
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [responses addObject:responseObject];
              if (counter < limit)
                  [self downloadFriends:responses
                                counter:counter+1
                                  limit:limit];
              else
              {
                  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
                  [self parseResponse:responses];
              }
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              [self finishActivity];
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
              [self.delegate modelDidFailWithError:error];
          }];
}

- (void) parseResponse: (NSArray* )responses
{
    NSLog(@"%@",responses);
    if (!_childContext)
    {
        self.childContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        self.childContext.parentContext = self.managedObjectContext;
    }
    
    NSMutableArray *res = [NSMutableArray new];
    
    for (id friendData in responses)
    {
        
    
        for (id data in friendData[@"results"]) {
            
            id userData = data[@"user"];
            
            DORUser *friend = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([DORUser class]) inManagedObjectContext:self.childContext];
            
            
            friend.email = userData[@"email"];
            friend.phone = userData[@"phone"];
            
            id name = userData[@"name"];
             DORName *nameObj = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([DORName class]) inManagedObjectContext:self.childContext];
            
            nameObj.first = name[@"first"];
            nameObj.last = name[@"last"];
            nameObj.title = name[@"title"];
            
            
            friend.name = nameObj;
            nameObj.user = friend;
            
            
            
            id picture = userData[@"picture"];
            DORPicture *picObj = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([DORPicture class]) inManagedObjectContext:self.childContext];
            
            picObj.mediumURL = picture[@"medium"];
            picObj.largeURL = picture[@"large"];
            picObj.thumbnailURL = picture[@"thumbnail"];
            
            friend.picture = picObj;
            picObj.user = friend;
            
            [res addObject:friend];
        }
    }
    
    self.friends = res;
    [self finishActivity];
    [self.delegate modelDidUpdate:self];
    
}

- (void) saveAsFriend: (DORUser*) friendObject
{
    if (!_canEdit)
        return;
    
    [self.childContext performBlock:^{
        // do something that takes some time asynchronously using the temp context
        friendObject.isFriend = @YES;
        
        for (DORUser *f in self.friends)
        {
            if (f.isFriend.boolValue == NO)
                [self.childContext deleteObject:f];
        }
        // push to parent
        NSError *error;
        if (![self.childContext save:&error])
        {
            [self finishActivity];
            // handle error
            [self.delegate modelDidFailWithError:error];
        }
        
        // save parent to disk asynchronously
        [self.managedObjectContext performBlock:^{
            NSError *error;
            if (![self.managedObjectContext save:&error])
            {
                [self finishActivity];
                [self.delegate modelDidFailWithError:error];
                // handle error
            }
            [self finishActivity];
            self.selectedFriend = friendObject;
        }];
    }];
    _activityMessage = NSLocalizedString(@"Saving", nil);
    [self startActivity];
    
}
@end
