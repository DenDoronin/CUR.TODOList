//
//  DORMainPageModel.m
//  MyFriends
//
//  Created by Doronin Denis on 11/12/15.
//  Copyright © 2015 Doronin Denis. All rights reserved.
//

#import "DORMainPageModel.h"
#import "AppDelegate.h"
@interface DORMainPageModel()<NSFetchedResultsControllerDelegate>

@property (nonatomic, strong)  AFHTTPRequestOperationManager *manager;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;


@end

@implementation DORMainPageModel

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
 
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([DORUser class])];
    
    // Add Sort Descriptors
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(username)) ascending:YES]]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"%K == %@",NSStringFromSelector(@selector(isFriend)),@YES]];
    @weakify(self)
    // Initialize Asynchronous Fetch Request
    NSAsynchronousFetchRequest *asynchronousFetchRequest = [[NSAsynchronousFetchRequest alloc] initWithFetchRequest:fetchRequest completionBlock:^(NSAsynchronousFetchResult *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // Process Asynchronous Fetch Result
            @strongify(self)
            [self processAsynchronousFetchResult:result];
        });
    }];
    
    // Execute Asynchronous Fetch Request
    [self.managedObjectContext performBlock:^{
        // Execute Asynchronous Fetch Request
        @strongify(self)
        NSError *asynchronousFetchRequestError = nil;
        [self.managedObjectContext executeRequest:asynchronousFetchRequest
                                            error:&asynchronousFetchRequestError];
        
        if (asynchronousFetchRequestError) {
            
            [self finishActivity];
            [self.delegate modelDidFailWithError:asynchronousFetchRequestError];
            
        }
    }];
    
    _activityMessage = NSLocalizedString(@"Fetching", nil);
    [self startActivity];
}


- (void)processAsynchronousFetchResult:(NSAsynchronousFetchResult *)asynchronousFetchResult {
    if (asynchronousFetchResult.finalResult) {
        // Update Items
        [self finishActivity];
        NSArray *fetchedFriends = asynchronousFetchResult.finalResult;
        [self setFriends:fetchedFriends];
        
        // Reload Table View
        [self.delegate modelDidUpdate:self];
    }
}

- (void)imageDownloaderDidFinish:(DORImageDownloader *)downloader {
    
    [super imageDownloaderDidFinish:downloader];
    
    
    [self.managedObjectContext performBlock:^{
        NSError *error;
        if (![self.managedObjectContext save:&error])
        {
            [self.delegate modelDidFailWithError:error];
            // handle error
        }
        [self finishActivity];
    }];
    
}

- (void) deleteFriendAtIndexPath: (NSIndexPath*) indexPath
{
    DORUser *friend = self.friends[indexPath.row];
    NSMutableArray *updated = [self.friends mutableCopy];
    [updated removeObjectAtIndex:indexPath.row];
    self.friends = updated;
    
    [self.managedObjectContext performBlock:^{
        NSError *error;
        
        friend.isFriend =@NO;
        if (![self.managedObjectContext save:&error])
        {
            [self.delegate modelDidFailWithError:error];
            // handle error
        }
        [self finishActivity];
    }];

}

@end
