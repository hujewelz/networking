//
//  HUAPIURLRequestGenerator.m
//  HUNetworking
//
//  Created by mac on 16/5/9.
//  Copyright © 2016年 hujewelz. All rights reserved.
//

#import "HUApiURLRequestGenerator.h"
#import "AFURLRequestSerialization.h"
#import "NSString+networking.h"
#import "HUServerConfig.h"
#import "HULogger.h"

static NSTimeInterval kHUNetworkingTimeoutSeconds = 15.0f;

@interface HUApiURLRequestGenerator ()
@property (nonatomic, strong) AFHTTPRequestSerializer *httpRequestSerializer;
@end

@implementation HUApiURLRequestGenerator

+ (instancetype)sharedInstance {
    static HUApiURLRequestGenerator *generator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        generator = [[HUApiURLRequestGenerator alloc] init];
    });
    return generator;
}

#pragma mark - public

- (NSURLRequest *)generateGETRequestWithParamas:(NSDictionary *)params apiMethodName:(NSString *)methodName {
    return [self generateWithRequestMethod:@"GET" paramas:params apiMethodName:methodName];;
}

- (NSURLRequest *)generatePOSTRequestWithParamas:(NSDictionary *)params apiMethodName:(NSString *)methodName {
    return [self generateWithRequestMethod:@"POST" paramas:params apiMethodName:methodName];
}

#pragma mark - private methods

- (NSURLRequest *)generateWithRequestMethod:(NSString *)method paramas:(NSDictionary *)params apiMethodName:(NSString *)methodName {
    NSString *urlString = [self URLStringWithServiceUrl:[HUServerConfig sharedInstance].apiBaseUrl path:methodName];
    
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:method URLString:urlString parameters:params error:nil];
    [HULogger logDebugInfoWithRequest:request apiName:urlString requestParams:params httpMethod:method];
    return request;
}

/*!
    @brief 请求URL拼接
    @param serviceUrl 请求Basic URL
    @parma path 请求路径
    @return NSString 完整请求URL字符串
 */
- (NSString *)URLStringWithServiceUrl:(NSString *)serviceUrl path:(NSString *)path{
  

    NSURL *fullURL = [NSURL URLWithString:serviceUrl];
    if (path != nil && [path isKindOfClass:[NSString class]]) {
        fullURL = [NSURL URLWithString:path relativeToURL:fullURL];
    }
    if (fullURL == nil) {
        NSLog(@"URL拼接错误:\n---------------------------\n\
              apiBaseUrl:%@\n\
              urlPath:%@\n\
              \n---------------------------\n",serviceUrl,path);
        return nil;
    }
    
    return [fullURL absoluteString];
}

#pragma mark - getters and setters

- (AFHTTPRequestSerializer *)httpRequestSerializer {
    if (_httpRequestSerializer == nil) {
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
        _httpRequestSerializer.timeoutInterval = kHUNetworkingTimeoutSeconds;
        _httpRequestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    return _httpRequestSerializer;
}



@end
