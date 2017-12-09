//
//  NSImageLoader.h
//  KVBFlikker
//
//  Created by Константин on 09.12.17.
//  Copyright © 2017 Konstantin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KVBImageLoader : NSObject
@property (nonatomic, strong) NSArray *photosByReuest;

- (void)downloadImagesForTags: (NSString*) tags Page: (NSInteger) page andAmount: (NSInteger*) amount;

@end
