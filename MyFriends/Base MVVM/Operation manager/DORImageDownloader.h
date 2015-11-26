//
//  DORImageDownloader.h
//  DocumentInteraction
//
//  Created by Doronin Denis on 11/13/15.
//  Copyright (c) 2014 Doronin Denis. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImageDownloaderDelegate;

@interface DORImageDownloader : NSOperation

@property (nonatomic, assign) id <ImageDownloaderDelegate> delegate;


@property (nonatomic, readonly, strong) NSIndexPath *indexPathInTableView;
@property (nonatomic, readonly, strong) DORUser *fileRecord;

- (id)initWithPhotoRecord:(DORUser *)record atIndexPath:(NSIndexPath *)indexPath delegate:(id<ImageDownloaderDelegate>) theDelegate;

@end

@protocol ImageDownloaderDelegate <NSObject>

- (void)imageDownloaderDidFinish:(DORImageDownloader *)downloader;

@end

