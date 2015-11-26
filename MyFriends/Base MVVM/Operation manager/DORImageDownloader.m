//
//  CURImageDownloader.m
//  DocumentInteraction
//
//  Created by Doronin Denis on 11/27/14.
//  Copyright (c) 2014 Doronin Denis. All rights reserved.
//

#import "DORImageDownloader.h"

@interface DORImageDownloader ()
@property (nonatomic, readwrite, strong) NSIndexPath *indexPathInTableView;
@property (nonatomic, readwrite, strong) DORUser *fileRecord;
@end

@implementation DORImageDownloader

@synthesize delegate = _delegate;
@synthesize indexPathInTableView = _indexPathInTableView;
@synthesize fileRecord = _fileRecord;

#pragma mark -
#pragma mark - Life Cycle

- (id)initWithPhotoRecord:(DORUser *)record atIndexPath:(NSIndexPath *)indexPath delegate:(id<ImageDownloaderDelegate>)theDelegate {
    
    if (self = [super init]) {
        // 2
        self.delegate = theDelegate;
        self.indexPathInTableView = indexPath;
        self.fileRecord = record;
    }
    return self;
}

#pragma mark -
#pragma mark - Downloading image



// 3
- (void)main {
    
    // 4
    @autoreleasepool {
        
        if (self.isCancelled)
            return;

        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString: self.fileRecord.picture.mediumURL]];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
        
        if (self.isCancelled) {
            imageData = nil;
            return;
        }
        
        if (imageData) {
            self.fileRecord.picture.medium = imageData;
        }
        else {
            self.fileRecord.picture.mediumFailed = @YES;
        }
        
        imageData = nil;
        
        if (self.isCancelled)
            return;
        
        // 5
        if (self.delegate)
            [(NSObject *)self.delegate performSelectorOnMainThread:@selector(imageDownloaderDidFinish:) withObject:self waitUntilDone:NO];
        
    }
}




@end
