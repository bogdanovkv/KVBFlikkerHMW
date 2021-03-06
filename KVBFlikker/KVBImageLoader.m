//
//  NSImageLoader.m
//  KVBFlikker
//
//  Created by Константин on 09.12.17.
//  Copyright © 2017 Konstantin. All rights reserved.
//

#import "KVBImageLoader.h"
#import "KVBImageModel.h"
@implementation KVBImageLoader

- (instancetype)init
{
    self = [super init];
    if (self) {
        _photosByReuest = [NSArray array];
    }
    return self;
}

- (void)downloadImagesForTags: (NSString*) tags Page: (NSInteger) page andAmount: (NSInteger) amount
{
   
    NSString *string = [tags stringByReplacingOccurrencesOfString:@" " withString:@"," ];
    
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:@"https://api.flickr.com/services/rest/"];
    NSURLQueryItem *method = [NSURLQueryItem queryItemWithName:@"method" value:@"flickr.photos.search"];
    NSURLQueryItem *apiKey = [NSURLQueryItem queryItemWithName:@"api_key" value:@"dab4052df3cc23ed39745a8cca163e0a"];
    NSURLQueryItem *allTags = [NSURLQueryItem queryItemWithName:@"tags" value:string];
    NSURLQueryItem *tagMode = [NSURLQueryItem queryItemWithName:@"tag_mode" value:@"all"];
    NSURLQueryItem *perpage = [NSURLQueryItem queryItemWithName:@"per_page" value:[NSString stringWithFormat:@"%li",(long)amount]];
    NSURLQueryItem *pageNum = [NSURLQueryItem queryItemWithName:@"page" value:[NSString stringWithFormat:@"%li",(long)page]];
    NSURLQueryItem *format = [NSURLQueryItem queryItemWithName:@"format" value:@"json"];
    NSURLQueryItem *imgFormat = [NSURLQueryItem queryItemWithName:@"extras" value:@"url_sq,url_m"];
    NSURLQueryItem *noCallBack = [NSURLQueryItem queryItemWithName:@"nojsoncallback" value:@"1"];
    NSURLQueryItem *safeMode = [NSURLQueryItem queryItemWithName:@"safe_search" value:@"1"];


    
    urlComponents.queryItems = @[method, apiKey, allTags, tagMode, format, pageNum, perpage, noCallBack, imgFormat, safeMode];


    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:nil delegateQueue:nil];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:urlComponents.URL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSError *JSONError = nil;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&JSONError];
        NSDictionary *photoDictionary = result[@"photos"];
        NSDictionary *photos = photoDictionary[@"photo"];
        self.pageCount = [photoDictionary[@"pages"] integerValue];
        NSMutableArray *array = [NSMutableArray array];
        
        for (NSDictionary *imageJSON in photos)
        {
            KVBImageModel *model = [KVBImageModel new];
            
            model.personDescription = imageJSON[@"title"];
            model.urlHQ = imageJSON[@"url_m"];
            model.urlSQ = imageJSON[@"url_sq"];
            [array addObject:model];
        }
        self.photosByReuest = array;
        dispatch_sync(dispatch_get_main_queue(), ^{

            [self.delegate loadingComplete];

        });

        
    }];

    [dataTask resume];
    
}



@end
