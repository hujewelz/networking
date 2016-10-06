//
//  HUServer.m
//  HUNetworking
//
//  Created by mac on 16/5/9.
//  Copyright © 2016年 hujewelz. All rights reserved.
//

#import "HUServerConfig.h"

@interface HUServerConfig ()

@property (nonatomic, weak) id<HUServerProtocol> child;

@end

@implementation HUServerConfig

+ (instancetype)sharedInstance {
    static HUServerConfig *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[HUServerConfig alloc] init];
        
    });
    return config;
}

+ (void)registerServerWithBaseURL:(NSString *)baseUrl apsEnviroment:(EnvironmentType)environmentType {
    [[HUServerConfig sharedInstance] registerServerWithBaseURL:baseUrl apsEnviroment:environmentType];
}


- (void)registerServerWithBaseURL:(NSString *)baseUrl apsEnviroment:(EnvironmentType)environmentType {
    self.environmentType = environmentType;
    _apiBaseUrl = baseUrl;
}

@end
