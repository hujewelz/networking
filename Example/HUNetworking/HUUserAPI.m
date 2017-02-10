//
//  HuUserAPI.m
//  HUNetworking
//
//  Created by mac on 2017/2/10.
//  Copyright © 2017年 Jewelz Hu. All rights reserved.
//

#import "HUUserAPI.h"

@implementation HUUserAPI

- (instancetype)init {
  if (self = [super init]) {
    self.dataSource = self;
  }
  return self;
}

#pragma mark - HUAPIManager
- (NSString *)apiName {
  return @"api/getuserinfo";
}

- (APIManagerRequestType)requestType {
  return APIManagerRequestTypeGET;
}

#pragma mark - HUAPIDataSource

- (NSDictionary *)paramForApi:(HUBaseAPIManager *)manager {
  return @{
   @"id": @"343423"
  };
}

@end
