//
//  HUServer.h
//  HUNetworking
//
//  Created by mac on 16/5/9.
//  Copyright © 2016年 hujewelz. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kAPPServerEnviroment;

/**
 *  开发、测试、预发、正式、HotFix和自定义环境,环境的切换是给开发人员和测试人员用的，对于外部正式打包不应该有环境切换的存在
 */
typedef NS_ENUM(NSUInteger,EnvironmentType) {
    EnvironmentTypeDevelop,
    EnvironmentTypeTest,
    EnvironmentTypePreRelease,
    EnvironmentTypeHotFix,
    EnvironmentTypeRelease,
    EnvironmentTypeCustom,
};

@protocol HUServerProtocol <NSObject>

@property (nonatomic, strong, readonly) NSString *developApiBaseUrl;
@property (nonatomic, strong, readonly) NSString *testApiBaseUrl;
@property (nonatomic, strong, readonly) NSString *prereleaseApiBaseUrl;
@property (nonatomic, strong, readonly) NSString *hotfixApiBaseUrl;
@property (nonatomic, strong, readonly) NSString *releaseApiBaseUrl;

@end

@interface HUServerConfig : NSObject

@property (nonatomic, assign) EnvironmentType environmentType;

@property (nonatomic, strong, readonly) NSString *publicKey;
@property (nonatomic, strong, readonly) NSString *privateKey;
@property (nonatomic, strong, readonly) NSString *apiBaseUrl;

+ (instancetype)sharedInstance;

/*!
  @brief 注册请求baseUrl 静态方法
  @param baseUrl 请求根路径
  @param environmentType 应用环境
 */
+ (void)registerServerWithBaseURL:(NSString *)baseUrl apsEnviroment:(EnvironmentType)environmentType;

/*!
 @brief 注册请求baseUrl
 @param baseUrl 请求根路径
 @param environmentType 应用环境
 */
- (void)registerServerWithBaseURL:(NSString *)baseUrl apsEnviroment:(EnvironmentType)environmentType;

//+ (void)configreServerWithPlist:(NSString *)plist apsEnviroment:(EnvironmentType)environmentType;
//- (void)configreServerWithPlist:(NSString *)plist apsEnviroment:(EnvironmentType)environmentType;

@end
