//
//  TestReformer.m
//  ProtocolOrientedProgramming
//
//  Created by mac on 16/4/8.
//  Copyright (c) 2016年 hujewelz. All rights reserved.
//

#import "TestReformer.h"


NSString * const kPropertyListReformerKeyImage = @"headImg";
NSString * const kPropertyListReformerKeyID = @"userId";

@interface TestReformer ()

@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) ConfigureCell configereCellBlock;

@end

@implementation TestReformer

- (instancetype)initWithCellIdentifier:(NSString *)identifier configureCellBlock:(ConfigureCell)configurecell {
    self = [super init];
    if (self) {
        _identifier = identifier;
        _configereCellBlock = configurecell;
    }
    return self;
}

- (id)reformData:(NSDictionary *)data forManager:(HUBaseAPIManager *)manager {
    NSArray *users = data[@"result"][@"userList"];
    self.dataList = [NSMutableArray arrayWithArray:users];
    return users;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cell = [tableView dequeueReusableCellWithIdentifier:self.identifier forIndexPath:indexPath];
    self.configereCellBlock(cell, self.dataList[indexPath.row]);
    return cell;
}

@end
