//
//  ViewController.m
//  HUNetworking
//
//  Created by mac on 16/5/9.
//  Copyright © 2016年 hujewelz. All rights reserved.
//

#import "ViewController.h"
#import "HUApiProxy.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[HUApiProxy sharedInstance] callPOSTWithParams:@{@"type":@0} apiName:@"main/isVersion" success:^(id responseObj, NSError *error) {
        NSLog(@"responseObj: %@", responseObj);
    } failure:^(id responseObj, NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
