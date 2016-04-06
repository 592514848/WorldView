//
//  BaseViewController.h
//  WorldView
//
//  Created by XZJ on 10/28/15.
//  Copyright © 2015 XZJ. All rights reserved.
//
#define NAVIGATIONBAR_HEIGHT 44.0f
#define STATUSBAR_HEIGHT 20.0f
#define DOUBLE_PASER_TOSTRING(VALUE) [NSString stringWithFormat: @"%.2f", [VALUE doubleValue]]
#define LONG_PASER_TOSTRING(VALUE) [NSString stringWithFormat: @"%lld", [VALUE longLongValue]]
#define _LONG_PASER_TOSTRING(VALUE) [NSString stringWithFormat: @"%ld", VALUE]
typedef enum {
    kDEFAULTControlMask = 0,
    kMODALControlMask = 1,
    kMODALPushControlMask = 2
}ControlMask;

#import <UIKit/UIKit.h>
#import "XZJ_ApplicationClass.h"

@interface BaseViewController : UIViewController
{
    XZJ_ApplicationClass *applicationClass; //App基本配置信息
    CGSize curScreenSize; //当前设备尺寸
    BOOL isLogin; //是否登录
    NSDictionary *memberDictionary;//会员信息字典
}
@property(nonatomic)ControlMask XZJ_ControlMask;
@property(nonatomic) BOOL isRoot;
@property(nonatomic, retain)NSString *topBarTitle;
@property(nonatomic) CGFloat point_y;
- (void)updateViewController;
@end
