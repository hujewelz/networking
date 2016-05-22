//
//  TestAPIManager.h
//  ProtocolOrientedProgramming
//
//  Created by mac on 16/4/7.
//  Copyright (c) 2016年 hujewelz. All rights reserved.
//

#import "HUBaseAPIManager.h"

@interface TestAPIManager : HUBaseAPIManager <HUAPIManager, HUPageEnable>

- (void)loadDataSucceed:(void (^)(HUBaseAPIManager *manager))succeed
                 failed:(void (^)(NSError *error))failed;

@end
