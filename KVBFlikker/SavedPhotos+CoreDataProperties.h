//
//  SavedPhotos+CoreDataProperties.h
//  KVBFlikker
//
//  Created by Константин Богданов on 11.12.17.
//  Copyright © 2017 Konstantin. All rights reserved.
//
//

#import "SavedPhotos+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface SavedPhotos (CoreDataProperties)

+ (NSFetchRequest<SavedPhotos *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *photoDescription;
@property (nullable, nonatomic, copy) NSString *url_m;
@property (nullable, nonatomic, copy) NSString *url_sq;

@end

NS_ASSUME_NONNULL_END
