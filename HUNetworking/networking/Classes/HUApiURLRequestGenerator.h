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

- (NSURLRequest *)generateGETRequestWithParamas:(NSDictionary *)params apiMethodName:(NSString *)methodName;
- (NSURLRequest *)generatePOSTRequestWithParamas:(NSDictionary *)params apiMethodName:(NSString *)methodName;

@end
