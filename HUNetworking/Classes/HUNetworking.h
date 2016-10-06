//
//  HUNetworking.h
//  networkTest
//
//  Created by mac on 16/8/15.
//  Copyright © 2016年 hujewelz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HUApiProxy.h"

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
 上传单张图片
 @param data 图片数据
 @param params 参数
 @param URLString 图片上传地址
 @param fileName 文件名
*/

+ (void)uploadData:(NSData *)data
        withParams:(NSDictionary *)params
         URLString:(NSString *)URLString
          fileName:(NSString *)fileName
           success:(HUCallback)success
           failure:(HUCallback)failure;

/*! 取消网络请求 */
+ (void)cancel;

@end
