//
//  HULogger.h
//  HUNetworking
//
//  Created by mac on 16/5/9.
//  Copyright © 2016年 hujewelz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HUServerConfig.h"

@interface HULogger : NSObject

/*!
  @brief 打印request日志
  @param request URL请求
  @param apiName URL名
  @param params URL参数
  @param method 请求类型 POST GET
 */

+ (void)logDebugInfoWithRequest:(NSURLRequest *)request
                        apiName:(NSString *)apiName
                  requestParams:(id)params
                     httpMethod:(NSString *)method;

/*!
 @brief 打印response日志
 @param response 请求响应
 @param responseString 请求响应信息
 @param error 错误信息
 */
+ (void)logDebugInfoWithResponse:(NSHTTPURLResponse *)response
                   resposeString:(NSString *)responseString
                           error:(NSError *)error;


@end
