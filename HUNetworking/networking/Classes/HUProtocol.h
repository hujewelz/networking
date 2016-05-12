//
//  HUProtocol.h
//  ProtocolOrientedProgramming
//
//  Created by mac on 16/4/7.
//  Copyright (c) 2016年 hujewelz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HUConfigureable <NSObject>

@required
- (void)configureWithData:(id)data;

@end


@class HUBaseAPIManager;
/**
 * 用于对服务器返回的原始数据进行结构化
 */
@protocol HUDataReformer <NSObject>

- (id)reformData:(NSDictionary *)data forManager:(HUBaseAPIManager *)manager ;

@end
