//
//  SavedPhotos+CoreDataProperties.m
//  KVBFlikker
//
//  Created by Константин Богданов on 11.12.17.
//  Copyright © 2017 Konstantin. All rights reserved.
//
//

#import "SavedPhotos+CoreDataProperties.h"

@implementation SavedPhotos (CoreDataProperties)

+ (NSFetchRequest<SavedPhotos *> *)fetchRequest {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"SavedPhotos" ];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"url_m!=nil"];
    fetchRequest.predicate = predicate;
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"photoDescription" ascending:YES]];
    
    return fetchRequest;}

@dynamic photoDescription;
@dynamic url_m;
@dynamic url_sq;

@end
