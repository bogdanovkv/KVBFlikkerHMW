//
//  KVBLikedViewController.h
//  KVBFlikker
//
//  Created by Константин Богданов on 10.12.17.
//  Copyright © 2017 Konstantin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SavedPhotos+CoreDataClass.h"
@interface KVBLikedViewController : UIViewController

@property(nonatomic, strong) NSArray<SavedPhotos*> *photos;

@end
