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

@protocol HUDataReformer <NSObject>

/*!
  @brief 对服务器返回的原始数据进行结构化
  @param data 要格式化的原始数据
  @param manager APIManager
  @return id 格式后的数据
 
 */
- (id)reformData:(NSDictionary *)data forManager:(HUBaseAPIManager *)manager ;

@end
