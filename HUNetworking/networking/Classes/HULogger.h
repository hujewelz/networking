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

+ (void)logDebugInfoWithRequest:(NSURLRequest *)request
                        apiName:(NSString *)apiName
                  requestParams:(id)params
                     httpMethod:(NSString *)method;

+ (void)logDebugInfoWithResponse:(NSHTTPURLResponse *)response
                   resposeString:(NSString *)responseString
                           error:(NSError *)error;


@end
