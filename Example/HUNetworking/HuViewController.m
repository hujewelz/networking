//
//  HuViewController.m
//  HUNetworking
//
//  Created by Jewelz Hu on 10/06/2016.
//  Copyright (c) 2016 Jewelz Hu. All rights reserved.
//

#import "HuViewController.h"
#import "HUNetworking.h"
#import "HUUserAPI.h"
#import "HUUser.h"

@interface HuViewController () <HUAPIManagerDelegate>

@property (nonatomic, strong) HUUserAPI *userAPI;
@property (nonatomic, strong) UserDataReformer *dataReformer;

@end

@implementation HuViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
	// 发起请求
  [self.userAPI fetchData];
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - HUAPIManagerDelegate

- (void)apiManagerDidFetchDataSucceed:(HUBaseAPIManager *)manager {
  // 格式化数据
  HUUser *user =  [manager reformerDataWithRefomer:self.dataReformer];
  
  NSLog(@"name: %@", user.name);
}

- (void)apiManager:(HUBaseAPIManager *)manager didFetchDataFailed:(NSError *)error {
  NSLog(@"error: %@", error);
}

#pragma mark - getter

- (HUUserAPI *)userAPI {
  if (_userAPI == nil) {
    _userAPI = [[HUUserAPI alloc] init];
    _userAPI.delegate = self;
  }
  return _userAPI;
}

- (UserDataReformer *)dataReformer {
  if (_dataReformer == nil) {
    _dataReformer = [[UserDataReformer alloc] init];
  }
  return _dataReformer;
}

@end


@implementation UserDataReformer

- (HUUser *)reformData:(NSDictionary *)data forManager:(HUBaseAPIManager *)manager {
  return [HUUser userWithDict:data];
}

@end