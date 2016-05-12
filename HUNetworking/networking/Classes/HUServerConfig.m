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

+ (void)configreServerWithPlist:(NSString *)plist apsEnviroment:(EnvironmentType)environmentType {
    [[HUServerConfig sharedInstance] configreServerWithPlist:plist apsEnviroment:environmentType];
}

- (void)configreServerWithPlist:(NSString *)plist apsEnviroment:(EnvironmentType)environmentType {
//    if (plist == nil) {
//        NSAssert(NO, @"");
//    }
    self.environmentType = environmentType;
   // NSDictionary *configDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:plist ofType:@"plist"]];
    _apiBaseUrl = @"http://mysql.memeta.cc:8009/";
 
}

@end
