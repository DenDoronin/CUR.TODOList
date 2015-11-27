//
//  PendingOperations.h
//  DocumentInteraction
//
//  Created by Doronin Denis on 11/27/14.
//  Copyright (c) 2014 Doronin Denis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PendingOperations : NSObject

@property (nonatomic, strong) NSMutableDictionary *downloadsInProgress;
@property (nonatomic, strong) NSOperationQueue *downloadQueue;

@end
