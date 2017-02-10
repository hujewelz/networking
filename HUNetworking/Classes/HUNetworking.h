//
//  HUNetworking.h
//  networkTest
//
//  Created by mac on 16/8/15.
//  Copyright © 2016年 hujewelz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HUApiProxy.h"
#import "HUBaseAPIManager.h"

static NSInteger requestID = 0;

@interface HUNetworking : NSObject

/**
 GET请求
 @param apiName 请求名
 @param params  请求参数， get请求可不传
 @param success 请求成功回调
 @param failure 请求失败回调
*/
+ (void)GET:(NSString *)apiName
     params:(NSDictionary *)params
    success:(HUCallback)success
    failure:(HUCallback)failure;


/*!
 POST请求
 @param apiName 请求名
 @param params  请求参数
 @param success 请求成功回调
 @param failure 请求失败回调
*/
+ (void)POST:(NSString *)apiName
     params:(NSDictionary *)params
    success:(HUCallback)success
    failure:(HUCallback)failure;

/**
 媒体上传
 @param data 媒体数据，单个文件必须为NSData类型，多个文件为NSData数组类型
 @param params 参数
 @param URLString 上传地址
 @param filePath 文件路径，单个文件为NSString类型
 */
+ (void)uploadData:(id)data
        withParams:(NSDictionary *)params
         URLString:(NSString *)URLString
          filePath:(id)filePath
           success:(HUCallback)success
           failure:(HUCallback)failure;

/*! 取消网络请求 */
+ (void)cancel;

@end
