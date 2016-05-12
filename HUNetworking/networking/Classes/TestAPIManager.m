//
//  TestAPIManager.m
//  ProtocolOrientedProgramming
//
//  Created by mac on 16/4/7.
//  Copyright (c) 2016年 hujewelz. All rights reserved.
//

#import "TestAPIManager.h"

@interface TestAPIManager () <HUAPIManagerDelegate, HUAPIDataSource>{
    
}

@property (nonatomic) NSInteger nextPage;
@property (nonatomic, copy) void (^succeedBlock)(HUBaseAPIManager *manager);
@property (nonatomic, copy) void (^failedBlock)(NSError *error);
@end

@implementation TestAPIManager

- (instancetype)init {
    if (self = [super init]) {
        self.dataSource = self;
        self.delegate = self;
        _nextPage = 1;
    }
    return self;
}

- (NSString *)apiName {
    return @"main/index";
}

- (APIManagerRequestType)requestType {
    return APIManagerRequestTypeGET;
}

- (NSDictionary *)paramForApi:(HUBaseAPIManager *)manager {
    return @{@"pageSize": @10};
}

- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params {
    return YES;
}

- (void)beforePerformSuccessWithResponseObject:(id)responseObject {
    NSLog(@"responseobjecy: %@", responseObject);
    self.nextPage ++ ;
}

- (void)apiManagerDidFetchDataSucceed:(HUBaseAPIManager *)manager {
     NSLog(@"data: %@", manager.origionData);
    if (self.succeedBlock) {
        self.succeedBlock(self);
    }
    
}

- (void)apiManager:(HUBaseAPIManager *)manager didFetchDataFailed:(NSError *)error {
    
    if (self.failedBlock) {
        self.failedBlock(error);
    }
}

- (void)loadNextPage {
    [self fetchData];
}

- (void)loadDataSucceed:(void (^)(HUBaseAPIManager *))succeed failed:(void (^)(NSError *))failed {
    self.succeedBlock = succeed;
    self.failedBlock = failed;
    [self fetchData];
}


@end
