//
//  HUNetworking.m
//  networkTest
//
//  Created by mac on 16/8/15.
//  Copyright © 2016年 hujewelz. All rights reserved.
//

#import "HUNetworking.h"
#import "HUAppContext.h"



@implementation HUNetworking

+ (void)GET:(NSString *)apiName
     params:(NSDictionary *)params
    success:(HUCallback)success
    failure:(HUCallback)failure {

    requestID = [[HUApiProxy sharedInstance] callGETWithParams:params
                                           apiName:apiName
                                           success:success
                                           failure:failure];

}

+ (void)POST:(NSString *)apiName
      params:(NSDictionary *)params
     success:(HUCallback)success
     failure:(HUCallback)failure {

    requestID = [[HUApiProxy sharedInstance] callPOSTWithParams:params
                                            apiName:apiName
                                            success:success
                                            failure:failure];
}

+ (void)uploadData:(id)data
        withParams:(NSDictionary *)params
         URLString:(NSString *)URLString
          filePath:(id)filePath
           success:(HUCallback)success
           failure:(HUCallback)failure {
  [[HUApiProxy sharedInstance] uploadData:data withParams:params URLString:URLString filePath:filePath success:success failure:failure];
}


+ (void)cancel {
    [[HUApiProxy sharedInstance] cancelRequestWithRequestID:@(requestID)];
}


@end
