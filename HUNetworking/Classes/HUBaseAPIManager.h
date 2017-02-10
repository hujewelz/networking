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

/*!
 @protocol HUAPIManagerInterceptor 拦截器
 */
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

/*!
 @protocol HUAPIDataSource 请求参数数据源
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

/*!
  @class HUBaseAPIManager 其子类必须实现HUAPIManager协议
 */
@interface HUBaseAPIManager : NSObject

@property (nonatomic, weak) id<HUAPIManagerDelegate> delegate;
@property (nonatomic, weak) id<HUAPIDataSource> dataSource;
@property (nonatomic, weak) NSObject<HUAPIManager> *child;
@property (nonatomic, weak) id<HUAPIManagerInterceptor> interceptor;
@property (nonatomic, weak) id<HUPageEnable> pageAble;

@property (nonatomic,readonly, strong) NSDictionary *origionData;

@property (nonatomic,readonly, assign) BOOL isRechable;

/*! 发起请求 */
- (NSInteger)fetchData;

/*!
 使用改方法格式化成你想要的任何数据
 @param reformer 遵守 HUDataReformer协议的任何对象
 @return id 格式化后的数据
 */
- (id)reformerDataWithRefomer:(id<HUDataReformer>)reformer;

/*! 
 如果需要在调用API之前额外添加一些参数，比如pageNumber和pageSize之类的就在这里添加
 @remark 子类中覆盖这个函数的时候就不需要调用 [super reformParams:params]
 */
- (NSDictionary *)reformParams:(NSDictionary *)params;


/*! 拦截器方法，继承之后需要调用一下super */
- (void)beforePerformSuccessWithResponseObject:(id)responseObject;
- (void)afterPerformSuccessWithResponseObject:(id)responseObject;

- (void)beforePerformFailWithError:(NSError *)error;
- (void)afterPerformFailWithError:(NSError *)error;

- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params;

/*! 取消所有请求 */
- (void)cancelAllRequests;

/*! 根据requestID取消请求 */
- (void)cancelRequestWithRequestId:(NSInteger)requestID;

@end
