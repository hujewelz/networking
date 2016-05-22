//
//  TestCell.m
//  ProtocolOrientedProgramming
//
//  Created by mac on 16/4/7.
//  Copyright (c) 2016年 hujewelz. All rights reserved.
//

#import "TestCell.h"
#import "HUPropertyListReformerKeys.h"

@interface TestCell () 

@end

@implementation TestCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)configureWithData:(id)data {
    NSDictionary *dict = (NSDictionary *)data;
    self.textLabel.text = dict[kPropertyListReformerKeyImage];
}

@end
