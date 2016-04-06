//
//  FindPasswordNavaigationController.m
//  WorldView
//
//  Created by WorldView on 15/11/18.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import "FindPasswordNavaigationController.h"
#import "FindPassword_StepOne_VC.h"

@implementation FindPasswordNavaigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    ///1.设置根视图
    FindPassword_StepOne_VC *rootVC = [[FindPassword_StepOne_VC alloc] init];
    [rootVC setTopBarTitle: @"找回密码"];
    [rootVC setXZJ_ControlMask: kMODALPushControlMask];
    [self pushViewController: rootVC animated: NO];
}

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
