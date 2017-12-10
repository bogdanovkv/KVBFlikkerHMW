//
//  KVBLikedViewController.m
//  KVBFlikker
//
//  Created by Константин Богданов on 10.12.17.
//  Copyright © 2017 Konstantin. All rights reserved.
//

#import "KVBLikedViewController.h"

@interface KVBLikedViewController ()
@property(nonatomic, strong) UITableView *photoTable;

@end

@implementation KVBLikedViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        _photoTable = [[UITableView alloc] initWithFrame:CGRectMake(0 ,0 ,self.view.bounds.size.width, self.view.bounds.size.height - 44) style:UITableViewStyleGrouped];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
