//
//  ViewController.m
//  KVBFlikker
//
//  Created by Константин on 09.12.17.
//  Copyright © 2017 Konstantin. All rights reserved.
//

#import "ViewController.h"
#import "KVBImageLoader.h"
static const NSString *KVBCellIdentifier = @"DefaultCell";

@interface ViewController ()<UITextFieldDelegate, UITableViewDataSource>
@property(nonatomic, strong) KVBImageLoader *loader;
@property(nonatomic, strong) UITableView *tableView;
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
        
        _loader = [[KVBImageLoader alloc] init];
        
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [self.loader downloadImagesForTags: self.searchField.text Page:1 andAmount:8];
    
    [self.navigationItem.titleView resignFirstResponder];
    return YES;
    
}


#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:KVBCellIdentifier forIndexPath:indexPath];
    
    return cell;
}

@end
