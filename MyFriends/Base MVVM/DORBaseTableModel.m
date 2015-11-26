//
//  DORBaseTableModel.m
//  MyFriends
//
//  Created by Doronin Denis on 11/13/15.
//  Copyright © 2015 Doronin Denis. All rights reserved.
//

#import "DORBaseTableModel.h"

@interface DORBaseTableModel()<ImageDownloaderDelegate>

@property (nonatomic,strong) NSMutableArray *loadedPreviews;
@property (nonatomic, assign) BOOL shouldExit;
@property (nonatomic, strong) PendingOperations *pendingOperations;

@end

@implementation DORBaseTableModel
@synthesize pendingOperations = _pendingOperations;
@dynamic delegate;

-(void) downloadPreviewForIndexPath:(NSIndexPath *)indexPath ismoving: (BOOL) isNotMoving
{
    DORUser *rec =[_friends  objectAtIndex:indexPath.row];
    if (!rec.picture.medium && !rec.picture.mediumFailed.boolValue) {
        
        if (isNotMoving)
            [self startOperationsForPhotoRecord:rec atIndexPath:indexPath];
    }
}

- (void)startOperationsForPhotoRecord:(DORUser *)record atIndexPath:(NSIndexPath *)indexPath {
    
    // 2
    if (!record.picture.medium && record.picture.mediumURL) {
        [self startImageDownloadingForRecord:record atIndexPath:indexPath];
        
    }
    
}

- (void)startImageDownloadingForRecord:(DORUser *)record atIndexPath:(NSIndexPath *)indexPath {
    // 1
    if (![self.pendingOperations.downloadsInProgress.allKeys containsObject:indexPath]) {
        
        // 2
        // Start downloading
        DORImageDownloader *imageDownloader = [[DORImageDownloader alloc] initWithPhotoRecord:record atIndexPath:indexPath delegate:self];
        [self.pendingOperations.downloadsInProgress setObject:imageDownloader forKey:indexPath];
        [self.pendingOperations.downloadQueue addOperation:imageDownloader];
    }
}

- (void)imageDownloaderDidFinish:(DORImageDownloader *)downloader {
    
    // 1
    NSIndexPath *indexPath = downloader.indexPathInTableView;
    // 2
    // [self.delegate shouldUpdateCellAtIndexPath:indexPath];
    // 3
    [self.pendingOperations.downloadsInProgress removeObjectForKey:indexPath];
    
    if ([[self.pendingOperations.downloadsInProgress allKeys] count] == 0)
        [self.delegate modelDidUpdate:self];
}



- (PendingOperations *)pendingOperations {
    if (!_pendingOperations) {
        _pendingOperations = [[PendingOperations alloc] init];
    }
    return _pendingOperations;
}

- (void)suspendAllOperations {
    [self.pendingOperations.downloadQueue setSuspended:YES];
}

- (void)resumeAllOperations {
    [self.pendingOperations.downloadQueue setSuspended:NO];
}

- (void)cancelAllOperations {
    [self.pendingOperations.downloadQueue cancelAllOperations];
}

- (void)loadImagesForOnscreenCells: (NSSet*) visibleRows{
    
    // 1
    // 2
    NSMutableSet *pendingOperations = [NSMutableSet setWithArray:[self.pendingOperations.downloadsInProgress allKeys]];
    
    NSMutableSet *toBeCancelled = [pendingOperations mutableCopy];
    NSMutableSet *toBeStarted = [visibleRows mutableCopy];
    
    // 3
    [toBeStarted minusSet:pendingOperations];
    // 4
    [toBeCancelled minusSet:visibleRows];
    
    // 5
    for (NSIndexPath *anIndexPath in toBeCancelled) {
        
        DORImageDownloader *pendingDownload = [self.pendingOperations.downloadsInProgress objectForKey:anIndexPath];
        [pendingDownload cancel];
        [self.pendingOperations.downloadsInProgress removeObjectForKey:anIndexPath];
        
    }
    toBeCancelled = nil;
    
    // 6
    for (NSIndexPath *anIndexPath in toBeStarted) {
        
        DORUser *recordToProcess = [_friends objectAtIndex:anIndexPath.row];
        [self startOperationsForPhotoRecord:recordToProcess atIndexPath:anIndexPath];
    }
    toBeStarted = nil;
    
}


@end
