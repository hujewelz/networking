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

- (NSUInteger)callGETWithParams:(NSDictionary *)params
                        apiName:(NSString *)apiName
                        success:(HUCallback)success
                        failure:(HUCallback)failure ;

- (NSUInteger)callPOSTWithParams:(NSDictionary *)params
                         apiName:(NSString *)apiName
                         success:(HUCallback)success
                         failure:(HUCallback)failure;

- (void)cancelRequestWithRequestID:(NSNumber *)requestID;
- (void)cancelRequestWithRequestIDList:(NSArray<NSNumber *> *)requestIDList;

+ (instancetype)sharedInstance;

@end
