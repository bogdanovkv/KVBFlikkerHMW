//
//  SavedPhotos+CoreDataProperties.h
//  KVBFlikker
//
//  Created by Константин Богданов on 10.12.17.
//  Copyright © 2017 Konstantin. All rights reserved.
//
//

#import "SavedPhotos+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface SavedPhotos (CoreDataProperties)

+ (NSFetchRequest<SavedPhotos *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *url_sq;
@property (nullable, nonatomic, copy) NSString *url_m;
@property (nullable, nonatomic, copy) NSString *photoDescription;

@end

NS_ASSUME_NONNULL_END
