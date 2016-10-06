//
//  HUAPIProxy.h
//  HUNetworking
//
//  Created by mac on 16/5/9.
//  Copyright © 2016年 hujewelz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^HUCallback)(id responseObj, NSError *error);

@interface HUApiProxy : NSObject

/**
 GET请求
 @param params  请求参数， get请求可不传
 @param apiName 请求名
 @param success 请求成功回调
 @param failure 请求失败回调
 @return NSUInteger 请求ID
*/
- (NSUInteger)callGETWithParams:(NSDictionary *)params
                        apiName:(NSString *)apiName
                        success:(HUCallback)success
                        failure:(HUCallback)failure ;

/*!
 POST请求
 @param params  请求参数
 @param apiName 请求名
 @param success 请求成功回调
 @param failure 请求失败回调
 @return NSUInteger 请求ID
*/
- (NSUInteger)callPOSTWithParams:(NSDictionary *)params
                         apiName:(NSString *)apiName
                         success:(HUCallback)success
                         failure:(HUCallback)failure;

/**
 上传单张图片
 @param data 图片数据
 @param params 参数
 @param URLString 图片上传地址
 @param fileName 文件名
*/
- (void)uploadData:(NSData *)data
        withParams:(NSDictionary *)params
         URLString:(NSString *)URLString
          fileName:(NSString *)fileName
           success:(HUCallback)success
           failure:(HUCallback)failure;

/*!
 @brief 请据请求ID取消请求
 @param requestID 请求ID
*/
- (void)cancelRequestWithRequestID:(NSNumber *)requestID;

/*!
 @brief 请据请求ID列表取消请求
 @param requestIDList 请求ID列表
*/
- (void)cancelRequestWithRequestIDList:(NSArray<NSNumber *> *)requestIDList;

+ (instancetype)sharedInstance;

@end
