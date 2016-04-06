//
//  EmailRegisterNavigationController.m
//  WorldView
//
//  Created by WorldView on 15/11/18.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import "EmailRegisterNavigationController.h"
#import "EmailRegisterViewController.h"

@implementation EmailRegisterNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    ///1.设置根视图
    EmailRegisterViewController *rootVC = [[EmailRegisterViewController alloc] init];
    [rootVC setTopBarTitle: @"邮箱注册"];
    [rootVC setXZJ_ControlMask: kMODALPushControlMask];
    [self pushViewController: rootVC animated: NO];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
