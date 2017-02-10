//
//  HUAPIManager.m
//  ProtocolOrientedProgramming
//
//  Created by mac on 16/4/7.
//  Copyright (c) 2016年 hujewelz. All rights reserved.
//

#import "HUBaseAPIManager.h"
#import "HUProtocol.h"
#import "HUApiProxy.h"
#import "HUAppContext.h"

#define CallAPI(REQUEST_METHOD, REQUEST_ID) \
{ \
    REQUEST_ID = [[HUApiProxy sharedInstance] call##REQUEST_METHOD##WithParams:apiparam apiName:self.child.apiName success:^(id responseObj, NSError *error) { \
        [self succeedOnCallAPIWithData:responseObj]; \
    } failure:^(id responseObj, NSError *error) { \
        [self failedOnCallAPIWithError: error];\
    }]; \
    [self.requestIdList addObject:@(REQUEST_ID)]; \
\
} \

static NSString * const kAPIManagerErrorDomain = @"APIManagerErrorDomain";

@interface HUBaseAPIManager () {
    HUAPIManagerErrorType _errorType;
}

@property (nonatomic, strong) NSMutableArray *requestIdList;

@end

@implementation HUBaseAPIManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _delegate = nil;
        if ([self conformsToProtocol:@protocol(HUAPIManager)]) {
            self.child = (NSObject<HUAPIManager> *)self;
        }
    }
    return self;
}

#pragma mark - API

- (NSInteger)fetchData {
    
    NSDictionary *data = [self.dataSource paramForApi:self];
    NSInteger requestId = [self fetchDataWithParam:data];
    return requestId;
}

/*!
 发起请求
 @param param 请求参数
 @return NSInteger 请求ID
 */
- (NSInteger)fetchDataWithParam:(NSDictionary *)param {
    NSInteger requestId = 0;
    NSDictionary *apiparam = [self reformParams:param];

    if ([self shouldCallAPIWithParams:apiparam]) {
        switch (self.child.requestType) {
            case APIManagerRequestTypeGET:
                CallAPI(GET, requestId);
                break;
            case APIManagerRequestTypePOST:
                CallAPI(POST, requestId);
            default:
                break;
        }
    }
    
    return requestId;
}


- (NSDictionary *)reformParams:(NSDictionary *)params {
    IMP childIMP = [self.child methodForSelector:@selector(reformParams:)];
    IMP selfIMP = [self methodForSelector:@selector(reformParams:)];
    
    if (childIMP == selfIMP) {
        return params;
    } else {
        // 如果child是继承得来的，那么这里就不会跑到，会直接跑子类中的IMP。
        // 如果child是另一个对象，就会跑到这里
        NSDictionary *result = nil;
        result = [self.child reformParams:params];
        if (result) {
            return result;
        } else {
            return params;
        }
    }
}

#pragma mark - public methods
- (void)cancelAllRequests
{
    [[HUApiProxy sharedInstance] cancelRequestWithRequestIDList:self.requestIdList];

    [self.requestIdList removeAllObjects];
}

- (void)cancelRequestWithRequestId:(NSInteger)requestID
{
    [self removeRequestIdWithRequestID:requestID];
    [[HUApiProxy sharedInstance] cancelRequestWithRequestID:@(requestID)];
}

#pragma mark - method for interceptor

/*
 拦截器的功能可以由子类通过继承实现，也可以由其它对象实现,两种做法可以共存
 当两种情况共存的时候，子类重载的方法一定要调用一下super
 然后它们的调用顺序是BaseManager会先调用子类重载的实现，再调用外部interceptor的实现
 
 notes:
 正常情况下，拦截器是通过代理的方式实现的，因此可以不需要以下这些代码
 但是为了将来拓展方便，如果在调用拦截器之前manager又希望自己能够先做一些事情，所以这些方法还是需要能够被继承重载的
 所有重载的方法，都要调用一下super,这样才能保证外部interceptor能够被调到
 这就是decorate pattern
 */
- (void)beforePerformSuccessWithResponseObject:(id)responseObject {
    //self.errorType = RTAPIManagerErrorTypeSuccess;
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(apiManager:beforePerformSuccessWithResponseObject:)]) {
        [self.interceptor apiManager:self beforePerformSuccessWithResponseObject:responseObject];
    }
}

- (void)afterPerformSuccessWithResponseObject:(id)responseObject{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(apiManager:afterPerformSuccessWithResponseObject:)]) {
        [self.interceptor apiManager:self afterPerformSuccessWithResponseObject:responseObject];
    }
}

- (void)beforePerformFailWithError:(NSError *)error {
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(apiManager:beforePerformFailWithError:)]) {
        [self.interceptor apiManager:self beforePerformFailWithError:error];
    }
}

- (void)afterPerformFailWithError:(NSError *)error {
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(apiManager:afterPerformFailWithError:)]) {
        [self.interceptor apiManager:self afterPerformFailWithError:error];
    }
}

//只有返回YES才会继续调用API
- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params {
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(apiManager:shouldCallAPIWithParams:)]) {
        return [self.interceptor apiManager:self shouldCallAPIWithParams:params];
    } else {
        return self.isRechable;
    }
}



- (id)reformerDataWithRefomer:(id<HUDataReformer>)reformer {
    
    if ([reformer respondsToSelector:@selector(reformData:forManager:)]) {
        return [reformer reformData:_origionData forManager:self];
    }
    return _origionData;
}

#pragma mark - private

- (void)succeedOnCallAPIWithData:(NSDictionary *)data {
    _origionData = data;
    [self beforePerformSuccessWithResponseObject:data];
    if ([self.delegate respondsToSelector:@selector(apiManagerDidFetchDataSucceed:)]) {
        [self.delegate apiManagerDidFetchDataSucceed:self];
    }
    [self afterPerformSuccessWithResponseObject:data];
}

- (void)failedOnCallAPIWithError:(NSError *)error {
    
    [self beforePerformFailWithError:error];
    if ([self.delegate respondsToSelector:@selector(apiManager:didFetchDataFailed:)]) {
        NSError *e = [NSError errorWithDomain:kAPIManagerErrorDomain code:_errorType userInfo:[self errorUserInfo]];
        [self.delegate apiManager:self didFetchDataFailed:e];
    }
    [self afterPerformFailWithError:error];
}

- (BOOL)isRechable {
    BOOL isNetWorkReachable = [HUAppContext sharedInstance].isReachable;
    if (!isNetWorkReachable) {
        _errorType = HUAPIManagerErrorTypeNoNetWork;
        NSError *error = [NSError errorWithDomain:kAPIManagerErrorDomain code:_errorType userInfo:[self errorUserInfo]];
        if ([self.delegate respondsToSelector:@selector(apiManager:didFetchDataFailed:)]) {
            [self.delegate apiManager:self didFetchDataFailed:error];
        }
    }
    return isNetWorkReachable;
}

- (void)removeRequestIdWithRequestID:(NSInteger)requestId {
    NSNumber *requestIDToRemove = nil;
    for (NSNumber *storedRequestId in self.requestIdList) {
        if ([storedRequestId integerValue] == requestId) {
            requestIDToRemove = storedRequestId;
        }
    }
    if (requestIDToRemove) {
        [self.requestIdList removeObject:requestIDToRemove];
    }
}

- (NSDictionary *)errorUserInfo {
    NSMutableDictionary *userinfo = [NSMutableDictionary dictionary];
    userinfo[@"error_code"] = @(_errorType);
    NSString *errorMsg = @"";
    switch (_errorType) {
        case HUAPIManagerErrorTypeNoNetWork:
            errorMsg = @"无网络连接";
            break;
        case HUAPIManagerErrorTypeParamsError:
            errorMsg = @"参数错误";
            break;
        case HUAPIManagerErrorTypeTimeOut:
            errorMsg = @"连接超时";
            break;
        default:
            break;
    }
    userinfo[@"msg"] = errorMsg;
    return userinfo;
}


@end
