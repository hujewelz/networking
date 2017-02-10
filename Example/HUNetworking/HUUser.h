//
//  HUUser.h
//  HUNetworking
//
//  Created by mac on 2017/2/10.
//  Copyright © 2017年 Jewelz Hu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUUser : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *headImgURL;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)userWithDict:(NSDictionary *)dict;

@end
