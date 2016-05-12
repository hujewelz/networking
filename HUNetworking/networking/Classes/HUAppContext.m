//
//  HUAppContent.m
//  HUNetworking
//
//  Created by mac on 16/5/9.
//  Copyright © 2016年 hujewelz. All rights reserved.
//

#import "HUAppContext.h"
#import "AFNetworkReachabilityManager.h"
#import "UIDevice+UtilNetworking.h"
#import <ifaddrs.h>
#import <arpa/inet.h>

@interface HUAppContext ()

@property (nonatomic, copy, readwrite) NSString *ip;

@end

@implementation HUAppContext

- (NSString *)qtime {
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    dateFormater.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    return [dateFormater stringFromDate:[NSDate date]];
}

- (BOOL)isReachable {
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusUnknown) {
        return YES;
    } else {
        return [[AFNetworkReachabilityManager sharedManager] isReachable];
    }
}

- (NSString *)ip {
    if (_ip == nil) {
        _ip = @"Error";
        struct ifaddrs *interfaces = NULL;
        struct ifaddrs *temp_addr = NULL;
        int success = 0;
        // retrieve the current interfaces - returns 0 on success
        success = getifaddrs(&interfaces);
        if (success == 0) {
            // Loop through linked list of interfaces
            temp_addr = interfaces;
            while(temp_addr != NULL) {
                if(temp_addr->ifa_addr->sa_family == AF_INET) {
                    // Check if interface is en0 which is the wifi connection on the iPhone
                    if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                        // Get NSString from C String
                        _ip = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    }
                }
                temp_addr = temp_addr->ifa_next;
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return _ip;
}

#pragma mark - public

+ (instancetype)sharedInstance {
    static HUAppContext *contex = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        contex = [[HUAppContext alloc] init];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    });
    return contex;
}

#pragma mark - overrided methods

- (instancetype)init {
    self = [super init];
    if (self) {
        self.appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleNameKey];
        self.channelID = @"App Store";
        _device_id = @"[OpenUDID value]";
        _os_name = [[UIDevice currentDevice] systemName];
        _os_version = [[UIDevice currentDevice] systemVersion];
        _bundle_version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        _app_client_id = @"1";
        _device_model = [[UIDevice currentDevice] platform];
        _device_name = [[UIDevice currentDevice] name];
        
    }
    return self;
}

@end
