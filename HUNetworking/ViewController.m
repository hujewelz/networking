//
//  ViewController.m
//  ProtocolOrientedProgramming
//
//  Created by mac on 16/4/7.
//  Copyright (c) 2016年 hujewelz. All rights reserved.
//

#import "ViewController.h"
#import "TestCell.h"
#import "TestAPIManager.h"
#import "TestReformer.h"

@interface ViewController () <UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataLists;
@property (nonatomic, strong) TestAPIManager *testManager;
@property (nonatomic, strong) TestReformer *reformer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _reformer = [[TestReformer alloc] initWithCellIdentifier:@"Cell" configureCellBlock:^(TestCell *cell, NSDictionary *dataItem) {
        [cell configureWithData:dataItem];
    }];
    
    self.tableView.dataSource = self.reformer;
    
    __weak __typeof(self) wself = self;
    [self.testManager loadDataSucceed:^(HUBaseAPIManager *manager) {
        [manager reformerDataWithRefomer:self.reformer];
        [wself.tableView reloadData];
    } failed:^(NSError *error) {
        NSLog(@"-----error: %@", error);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.testManager loadNextPage];
}

- (TestAPIManager *)testManager {
    if (!_testManager) {
        _testManager = [[TestAPIManager alloc] init];
        //_testManager.delegate = self;
    }
    return _testManager;
}


@end
