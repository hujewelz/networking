//
//  HUUser.m
//  HUNetworking
//
//  Created by mac on 2017/2/10.
//  Copyright © 2017年 Jewelz Hu. All rights reserved.
//

#import "HUUser.h"

@implementation HUUser

+ (instancetype)userWithDict:(NSDictionary *)dict {
  return  [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict {
  if (self = [super init]) {
    _name = dict[@"name"];
    _headImgURL = dict[@"head"];
  }
  return self;
}

@end
