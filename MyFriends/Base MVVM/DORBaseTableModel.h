//
//  DORBaseTableModel.h
//  MyFriends
//
//  Created by Doronin Denis on 11/13/15.
//  Copyright © 2015 Doronin Denis. All rights reserved.
//

#import "DORBaseModel.h"
#import "PendingOperations.h"
#import "DORImageDownloader.h"

@interface DORBaseTableModel : DORBaseModel

@property (nonatomic, weak)             id<DORTableModelActivityDelegate> delegate;

@property (nonatomic, strong) NSArray *friends;

-(void) downloadPreviewForIndexPath:(NSIndexPath *)indexPath ismoving: (BOOL) isNotMoving;

- (void)imageDownloaderDidFinish:(DORImageDownloader *)downloader;
- (void)suspendAllOperations;
- (void)resumeAllOperations;
- (void)cancelAllOperations;
- (void)loadImagesForOnscreenCells: (NSSet*) visibleRows;

@end
