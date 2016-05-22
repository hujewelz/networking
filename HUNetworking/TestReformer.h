//
//  TestReformer.h
//  ProtocolOrientedProgramming
//
//  Created by mac on 16/4/8.
//  Copyright (c) 2016年 hujewelz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HUProtocol.h"
#import "HUPropertyListReformerKeys.h"

typedef void (^ConfigureCell)(id cell, id dataItem);

@interface TestReformer : NSObject<HUDataReformer, UITableViewDataSource>

- (instancetype)initWithCellIdentifier:(NSString *)identifier configureCellBlock:(ConfigureCell)configurecell;

@end
