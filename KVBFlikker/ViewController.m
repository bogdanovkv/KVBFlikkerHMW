//
//  ViewController.m
//  KVBFlikker
//
//  Created by Константин on 09.12.17.
//  Copyright © 2017 Konstantin. All rights reserved.
//

#import "ViewController.h"
#import "KVBImageLoader.h"
#import "KVBImageModel.h"
#import "SavedPhotos+CoreDataClass.h"
static NSString *const KVBCellIdentifier = @"DefaultCell";
static const NSInteger KVBPhotoPerLoading = 15;

@interface ViewController ()<UITextFieldDelegate,UITableViewDelegate, UITableViewDataSource, KVBImageLoaderDelegate>

@property(nonatomic, strong) KVBImageLoader *loader;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray<KVBImageModel*> *photosArray;
@property(nonatomic, strong) NSCache *cache;
@property(nonatomic, assign) NSInteger pageOfLoading;
@property(nonatomic, weak) UITextField *searchField;


@end

@implementation ViewController

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                   self.navigationController.navigationBar.frame.size.height,
                                                                   self.view.frame.size.width,
                                                                   self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height)
                                                  style:UITableViewStylePlain];
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:KVBCellIdentifier];
        _tableView.dataSource = self;
        _tableView.delegate = self;

        _loader = [[KVBImageLoader alloc] init];
        _loader.delegate = self;
        
        _pageOfLoading = 1;
        
        _cache = [[NSCache alloc] init];
        [self.view addSubview:_tableView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITextField *searchField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
    searchField.backgroundColor = [UIColor whiteColor];
    searchField.borderStyle = UITextBorderStyleRoundedRect;
    searchField.delegate = self;
    self.searchField = searchField;
    
    
    
    self.navigationItem.titleView = searchField;
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if(self.photosArray.count != 0)
    {
        [self.cache removeAllObjects];
        self.pageOfLoading = 1;
        self.photosArray = [NSArray array];
        [self.tableView reloadData];
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [self.loader downloadImagesForTags: self.searchField.text Page:self.pageOfLoading andAmount:KVBPhotoPerLoading];
    
    [self.navigationItem.titleView resignFirstResponder];
    
    return YES;
    
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.photosArray.count - 1)
    {
        if(self.pageOfLoading != self.loader.pageCount)
        {
            self.pageOfLoading++;
        }
        [self.loader downloadImagesForTags: self.searchField.text Page:self.pageOfLoading andAmount:KVBPhotoPerLoading];

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    KVBImageModel *img = self.photosArray[indexPath.row];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"SavedPhotos"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"url_m==%@",img.urlHQ];
    fetchRequest.predicate = predicate;
    
    NSArray *photo = [self.contex executeFetchRequest:fetchRequest error:nil];
    
    if(photo.count == 0)
    {
        SavedPhotos *photo = [NSEntityDescription insertNewObjectForEntityForName:@"SavedPhotos" inManagedObjectContext:self.contex];
        photo.url_m = img.urlHQ;
        photo.url_sq = img.urlSQ;
        photo.photoDescription = img.personDescription;
    
        NSError *error = nil;
    
        [self.contex save:&error];
        
        if(error)
        {
            NSLog(@"Error %@", [error description]);
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.photosArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:KVBCellIdentifier forIndexPath:indexPath];
    
    KVBImageModel *image = self.photosArray[indexPath.row];
    
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
        NSURLSessionDownloadTask *download = [session downloadTaskWithURL:[NSURL URLWithString:image.urlSQ] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            NSData *data = [NSData dataWithContentsOfURL:location];
            UIImage *photo = [UIImage imageWithData:data];
            [self.cache setObject:photo forKey:@(indexPath.row)];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                cell.imageView.image = photo;
            });
        }];
        
        [download resume];
    }

    cell.textLabel.text = image.personDescription;
    
    return cell;
}

#pragma mark KVBImageLoaderDelegate

- (void)loadingComplete
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.photosArray];
    
    
    [self.tableView beginUpdates];
    


    NSMutableArray *indexPathArray = [NSMutableArray array];

    
    for(NSInteger i = 0; i< self.loader.photosByReuest.count;i++)
    {
    
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.photosArray.count + i inSection:0];
        [indexPathArray addObject:indexPath];
    }
    
    [self.tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationLeft];
    
    [array addObjectsFromArray:self.loader.photosByReuest];
    self.photosArray = array;

    [self.tableView endUpdates];
//    [self.tableView reloadData];
}


@end
