//
//  NSImageLoader.h
//  KVBFlikker
//
//  Created by Константин on 09.12.17.
//  Copyright © 2017 Konstantin. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol KVBImageLoaderDelegate;
@class KVBImageModel;

@interface KVBImageLoader : NSObject

@property (nonatomic, strong) NSArray<KVBImageModel*> *photosByReuest;
@property (nonatomic, weak) id <KVBImageLoaderDelegate> delegate;

- (void)downloadImagesForTags: (NSString*) tags Page: (NSInteger) page andAmount: (NSInteger) amount;

@end


@protocol KVBImageLoaderDelegate <NSObject>

- (void) loadingComplete;

@end
