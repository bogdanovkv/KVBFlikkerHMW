//
//  SavedPhotos+CoreDataProperties.m
//  KVBFlikker
//
//  Created by Константин Богданов on 10.12.17.
//  Copyright © 2017 Konstantin. All rights reserved.
//
//

#import "SavedPhotos+CoreDataProperties.h"

@implementation SavedPhotos (CoreDataProperties)

+ (NSFetchRequest<SavedPhotos *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"SavedPhotos"];
}

@dynamic url_sq;
@dynamic url_m;
@dynamic photoDescription;

@end
