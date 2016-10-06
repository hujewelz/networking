//
//  NSString+networking.m
//  HUNetworking
//
//  Created by mac on 16/5/9.
//  Copyright © 2016年 hujewelz. All rights reserved.
//

#import "NSString+networking.h"

@implementation NSString (networking)

- (BOOL)isEmptyString {
    if (self == nil) {
        return YES;
    }
    if (![self isKindOfClass:[NSString class]]) {
        return YES;
    }
    return self.length == 0;
}

@end
