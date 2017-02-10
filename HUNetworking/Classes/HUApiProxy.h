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
 媒体上传
 @param data 媒体数据，单个文件必须为NSData类型，多个文件为NSData数组类型
 @param params 参数
 @param URLString 上传地址
 @param filePath 文件路径，单个文件为NSString类型
 */
- (void)uploadData:(id)data
        withParams:(NSDictionary *)params
         URLString:(NSString *)URLString
          filePath:(id)filePath
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
