//
//  HUAPIManager.h
//  ProtocolOrientedProgramming
//
//  Created by mac on 16/4/7.
//  Copyright (c) 2016年 hujewelz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HUProtocol.h"

typedef NS_ENUM(NSInteger, APIManagerRequestType) {
    APIManagerRequestTypeGET,
    APIManagerRequestTypePOST
};

typedef NS_ENUM(NSInteger, HUAPIManagerErrorType) {
    HUAPIManagerErrorTypeParamsError,
    HUAPIManagerErrorTypeTimeOut,
    HUAPIManagerErrorTypeNoNetWork
};

@class HUBaseAPIManager;
@protocol HUAPIManagerDelegate <NSObject>

@optional
- (void)apiManagerDidFetchDataSucceed:(HUBaseAPIManager *)manager;
- (void)apiManager:(HUBaseAPIManager *)manager didFetchDataFailed:(NSError *)error;

@end

@protocol HUAPIManagerInterceptor <NSObject>

@optional
- (BOOL)apiManager:(HUBaseAPIManager *)manager shouldCallAPIWithParams:(NSDictionary *)params;

- (void)apiManager:(HUBaseAPIManager *)manager beforePerformSuccessWithResponseObject:(id)responseObject;
- (void)apiManager:(HUBaseAPIManager *)manager afterPerformSuccessWithResponseObject:(id)responseObject;

- (void)apiManager:(HUBaseAPIManager *)manager beforePerformFailWithError:(NSError *)error;
- (void)apiManager:(HUBaseAPIManager *)manager afterPerformFailWithError:(NSError *)error;

@end

@protocol HUAPIManager <NSObject>

@required
- (NSString *)apiName;
- (APIManagerRequestType)requestType;

@optional
- (NSDictionary *)reformParams:(NSDictionary *)params;

@end

/**
 *  请求参数协议
 */
@protocol HUAPIDataSource <NSObject>
@required
- (NSDictionary *)paramForApi:(HUBaseAPIManager *)manager;

@end

/**
 * 有分页的需求，实现该协议
 */
@protocol HUPageEnable <NSObject>

@required
- (void)loadNextPage;

@end

/**
 *  其子类必须实现HUAPIManager协议
 */
@interface HUBaseAPIManager : NSObject

@property (nonatomic, weak) id<HUAPIManagerDelegate> delegate;
@property (nonatomic, weak) id<HUAPIDataSource> dataSource;
@property (nonatomic, weak) NSObject<HUAPIManager> *child;
@property (nonatomic, weak) id<HUAPIManagerInterceptor> interceptor;
@property (nonatomic, weak) id<HUPageEnable> pageAble;

@property (nonatomic,readonly, strong) NSDictionary *origionData;

@property (nonatomic,readonly, assign) BOOL isRechable;

- (void)fetchData;
- (void)fetchDataWithParam:(NSDictionary *)param;
- (id)reformerDataWithRefomer:(id<HUDataReformer>)reformer;
- (void)cancelRequest;
- (NSDictionary *)reformParams:(NSDictionary *)params;


// 拦截器方法，继承之后需要调用一下super
- (void)beforePerformSuccessWithResponseObject:(id)responseObject;
- (void)afterPerformSuccessWithResponseObject:(id)responseObject;

- (void)beforePerformFailWithError:(NSError *)error;
- (void)afterPerformFailWithError:(NSError *)error;

- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params;

@end
