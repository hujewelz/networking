//
//  HUAPIURLRequestGenerator.h
//  HUNetworking
//
//  Created by mac on 16/5/9.
//  Copyright © 2016年 hujewelz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUApiURLRequestGenerator : NSObject

+ (instancetype)sharedInstance;

/**
 生成 GET 请求
 @param params  请求参数， get请求可不传
 @param methodName 请求名
 @return NSURLRequest GET请求
 */
- (NSURLRequest *)generateGETRequestWithParamas:(NSDictionary *)params apiMethodName:(NSString *)methodName;

/**
 生成 POST 请求
 @param params  请求参数
 @param methodName 请求名
 @return NSURLRequest POST请求
 */
- (NSURLRequest *)generatePOSTRequestWithParamas:(NSDictionary *)params apiMethodName:(NSString *)methodName;

@end
