//
//  HUAPIProxy.m
//  HUNetworking
//
//  Created by mac on 16/5/9.
//  Copyright © 2016年 hujewelz. All rights reserved.
//

#import "HUApiProxy.h"
#import "AFURLSessionManager.h"
#import "HUApiURLRequestGenerator.h"
#import "HULogger.h"

@interface HUApiProxy ()

//AFNetworking stuff
@property (nonatomic, strong) AFURLSessionManager *sessionManager;
// 根据 requestid，存放 task
@property (nonatomic, strong) NSMutableDictionary *dispatchTable;
@property (nonatomic, strong) NSNumber *recordedRequestId;


@end

@implementation HUApiProxy

+ (instancetype)sharedInstance {
    static HUApiProxy *api = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        api = [[HUApiProxy alloc] init];
    });
    return api;
}

- (NSUInteger)callGETWithParams:(NSDictionary *)params apiName:(NSString *)apiName success:(HUCallback)success failure:(HUCallback)failure {
    NSURLRequest *request = [[HUApiURLRequestGenerator sharedInstance] generateGETRequestWithParamas:params apiMethodName:apiName];
    NSNumber *requestID = [self callRequestWithRequest:request success:success failure:failure];
    return requestID.unsignedIntegerValue;
}

- (NSUInteger)callPOSTWithParams:(NSDictionary *)params apiName:(NSString *)apiName success:(HUCallback)success failure:(HUCallback)failure {
    NSURLRequest *request = [[HUApiURLRequestGenerator sharedInstance] generatePOSTRequestWithParamas:params apiMethodName:apiName];
    NSNumber *requestID = [self callRequestWithRequest:request success:success failure:failure];
    return requestID.unsignedIntegerValue;
}

/**
 *  取消网络请求
 */
- (void)cancelRequestWithRequestID:(NSNumber *)requestID{
    NSURLSessionDataTask *task = [self.dispatchTable objectForKey:requestID];
    [task cancel];
    [self.dispatchTable removeObjectForKey:requestID];
}
- (void)cancelRequestWithRequestIDList:(NSArray<NSNumber *> *)requestIDList{
    typeof(self) __weak weakSelf = self;
    [requestIDList enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSURLSessionDataTask *task = [weakSelf.dispatchTable objectForKey:obj];
        [task cancel];
    }];
    [self.dispatchTable removeObjectsForKeys:requestIDList];
}

#pragma mark - private

- (NSNumber *)callRequestWithRequest:(NSURLRequest *)request success:(HUCallback)success failure:(HUCallback)failure {

    NSURLSessionDataTask *task = [self.sessionManager dataTaskWithRequest:request
                                                        completionHandler:^(NSURLResponse * _Nonnull response,
                                                                            id  _Nullable responseObject,
                                                                            NSError * _Nullable error)
    {
        
        if (task.state == NSURLSessionTaskStateCanceling) {
            return ;
        }
        else {
            NSNumber *requestID = [NSNumber numberWithUnsignedInteger:task.hash];
            [self.dispatchTable removeObjectForKey:requestID];
        }
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if (!error) {
            [HULogger logDebugInfoWithResponse:(NSHTTPURLResponse*)response resposeString:responseString error:nil];
            success?success(responseObject, nil):nil;
        }
        else {
            [HULogger logDebugInfoWithResponse:(NSHTTPURLResponse*)response resposeString:responseString error:error];
            failure?failure(nil, error):nil;
        }
        
    }];
    NSNumber *requestID = [NSNumber numberWithUnsignedInteger:task.hash];
    self.dispatchTable[requestID] = task;
    [task resume];
    return requestID;
}


#pragma mark - getters and setters

- (NSMutableDictionary *)dispatchTable {
    if (_dispatchTable == nil) {
        _dispatchTable = [[NSMutableDictionary alloc] init];
    }
    return _dispatchTable;
}

- (AFURLSessionManager *)sessionManager {
    if (_sessionManager == nil) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForResource = 20;
        
        _sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return _sessionManager;
}


@end
