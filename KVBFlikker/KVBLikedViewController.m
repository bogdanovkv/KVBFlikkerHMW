//
//  KVBLikedViewController.m
//  KVBFlikker
//
//  Created by Константин Богданов on 10.12.17.
//  Copyright © 2017 Konstantin. All rights reserved.
//

#import "KVBLikedViewController.h"
static NSString *const KVBPhotoIdentifier = @"PhototCell";

@interface KVBLikedViewController () <NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *photoTable;
@property(nonatomic, strong) NSFetchedResultsController *fetchResultsController;
@property(nonatomic, strong) NSCache *cache;

@end

@implementation KVBLikedViewController
- (instancetype)initWithContext: (NSManagedObjectContext *) context
{
    self = [super init];
    if (self) {
        _photoTable = [[UITableView alloc] initWithFrame:CGRectMake(0 ,0 ,self.view.bounds.size.width, self.view.bounds.size.height - 44) style:UITableViewStyleGrouped];
        _photoTable.delegate = self;
        _photoTable.dataSource = self;
        [_photoTable registerClass:[UITableViewCell class] forCellReuseIdentifier:KVBPhotoIdentifier];
        
        _fetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[SavedPhotos fetchRequest] managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
        _cache =[[NSCache alloc] init];
        
        _contex = context;
        
        [self.view addSubview:_photoTable];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.photos = [self.contex executeFetchRequest: self.fetchResultsController.fetchRequest error:nil];
    

    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KVBPhotoIdentifier forIndexPath:indexPath];
    
    SavedPhotos *image = self.photos[indexPath.row];
    
    if ([self.cache objectForKey:@(indexPath.row)] != nil)
    {
        
        UIImage *photo = [self.cache objectForKey:@(indexPath.row)];
        
        cell.imageView.image = photo;
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"defimg.png"];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        NSURLSessionDownloadTask *download = [session downloadTaskWithURL:[NSURL URLWithString:image.url_sq] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            NSData *data = [NSData dataWithContentsOfURL:location];
            UIImage *photo = [UIImage imageWithData:data];
            [self.cache setObject:photo forKey:@(indexPath.row)];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                cell.imageView.image = photo;
            });
        }];
        
        [download resume];
    }
    
    cell.textLabel.text = image.photoDescription;
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.photos.count;
}




@end
