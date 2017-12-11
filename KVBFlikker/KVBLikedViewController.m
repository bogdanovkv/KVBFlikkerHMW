//
//  KVBLikedViewController.m
//  KVBFlikker
//
//  Created by Константин Богданов on 10.12.17.
//  Copyright © 2017 Konstantin. All rights reserved.
//

#import "KVBLikedViewController.h"
static NSString *const KVBPhotoIdentifier = @"PhototCell";

@interface KVBLikedViewController () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) NSArray<SavedPhotos*> *photos;

@property(nonatomic, strong) UITableView *photoTable;
@property(nonatomic, strong) NSCache *cache;

@end

@implementation KVBLikedViewController
- (instancetype)initWithContext: (NSManagedObjectContext *) context
{
    self = [super init];
    if (self) {
        _photoTable = [[UITableView alloc] initWithFrame:CGRectMake(0 ,self.navigationController.navigationBar.frame.size.height ,self.view.bounds.size.width, self.view.bounds.size.height - self.navigationController.navigationBar.frame.size.height) style:UITableViewStylePlain];
        _photoTable.delegate = self;
        _photoTable.dataSource = self;
        [_photoTable registerClass:[UITableViewCell class] forCellReuseIdentifier:KVBPhotoIdentifier];
        

        _cache =[[NSCache alloc] init];
        
        _contex = context;
        
        [self.view addSubview:_photoTable];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.photoTable reloadData];

    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    
    self.photos = [self.contex executeFetchRequest:[SavedPhotos fetchRequest] error:nil];
    
    [self.photoTable reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITableViewDataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KVBPhotoIdentifier forIndexPath:indexPath];
    
    SavedPhotos *image = self.photos[indexPath.row];
    
    if ([self.cache objectForKey:image.url_sq] != nil)
    {
        
        UIImage *photo = [self.cache objectForKey:image.url_sq];
        
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
            [self.cache setObject:photo forKey:image.url_sq];
            
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

#pragma mark -UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.photos];
        
        [self.contex deleteObject:self.photos[indexPath.row]];
        [self.contex  save:nil];
        [self.photoTable beginUpdates];
        
        
        [self.photoTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [array removeObjectAtIndex:indexPath.row];
        self.photos = array;
        
        [self.photoTable endUpdates];
    }
}


#pragma mark Editing Table

- (void)editTable
{
    if (self.photoTable.editing == NO)
    {
        [self.photoTable setEditing: YES animated:YES];
    }
    else
    {
        [self.photoTable setEditing: NO animated:YES];
    }
}


@end
