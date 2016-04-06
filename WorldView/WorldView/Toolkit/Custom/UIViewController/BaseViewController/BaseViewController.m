//
//  BaseViewController.m
//  WorldView
//
//  Created by XZJ on 10/28/15.
//  Copyright © 2015 XZJ. All rights reserved.
//

#import "BaseViewController.h"
#import <objc/message.h>

@implementation BaseViewController
@synthesize topBarTitle, XZJ_ControlMask, isRoot, point_y;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self updateViewController];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    if(XZJ_ControlMask == kMODALControlMask)
//        [self.view bringSubviewToFront: navigationBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ////1.初始化基本数据
    if(!applicationClass)
        applicationClass = [XZJ_ApplicationClass commonApplication];
    curScreenSize = [[UIScreen mainScreen] bounds].size;
    [self.view setBackgroundColor: [UIColor whiteColor]];
    [self updateViewController];
    
    ////2.调整视图内容为不扩充
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
        [self setEdgesForExtendedLayout:  UIRectEdgeNone];
    
    ////3.设置导航栏参数
    [self.navigationController.navigationBar setBarStyle: UIBarStyleDefault];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
        [self.navigationController.navigationBar setBarTintColor: [UIColor whiteColor]];
    else
        [self.navigationController.navigationBar setTintColor: [UIColor whiteColor]];
    [self.navigationItem setTitle: topBarTitle];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObject: [applicationClass methodOfTurnToUIColor: @"#ee5c5e"] forKey:NSForegroundColorAttributeName]];
    
    ////4.设置导航栏的返回按钮
    UIButton *leftCustomButton = [[UIButton alloc] initWithFrame: CGRectMake(0.0f, 0.0f, NAVIGATIONBAR_HEIGHT, NAVIGATIONBAR_HEIGHT)];
    [leftCustomButton setImage: [UIImage imageNamed: @"navigation_back.png"] forState: UIControlStateNormal];
    [leftCustomButton addTarget: self action: @selector(backButtonClick) forControlEvents: UIControlEventTouchUpInside];
    [leftCustomButton setImageEdgeInsets: UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f)];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView: leftCustomButton];
    
    ////5.根据不同的跳转模式，设置相关属性
    switch (XZJ_ControlMask) {
        case 1:
        {
            //Modal(模态) 方式跳转
            UINavigationItem *navigationItem = [[UINavigationItem alloc] init];
            [navigationItem setTitle: topBarTitle];
            UINavigationBar *navigationBar = [[UINavigationBar alloc] init];
            [navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObject: [applicationClass methodOfTurnToUIColor: @"#ee5c5e"] forKey:NSForegroundColorAttributeName]];
            [navigationBar pushNavigationItem: navigationItem animated:NO];
            [navigationBar setFrame: CGRectMake(0.0f, 0.0f, curScreenSize.width, NAVIGATIONBAR_HEIGHT + 20.0f)];
            if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
                [navigationBar setBarTintColor: [UIColor whiteColor]];
            else
                [navigationBar setTintColor: [UIColor whiteColor]];
            if(!isRoot)
                [navigationItem setLeftBarButtonItem: leftButton];
            [navigationBar setBarStyle: UIBarStyleDefault];
            [self.view addSubview: navigationBar];
            point_y = NAVIGATIONBAR_HEIGHT + STATUSBAR_HEIGHT;
            break;
        }
        default:
        {
            curScreenSize.height = curScreenSize.height -NAVIGATIONBAR_HEIGHT - STATUSBAR_HEIGHT;
            //当不是导航栏的根视图时需要显示返回按钮
            if(!isRoot)
                [self.navigationItem setLeftBarButtonItem: leftButton];
            break;
        }
    }
}

- (void)backButtonClick
{
    //由子类响应返回按钮点击事件
    SEL selector = NSSelectorFromString(@"viewControllerDidClickBackButton");
    if([self respondsToSelector: selector])
    {
        void (*action)(id, SEL) = (void (*)(id, SEL))objc_msgSend;
        action(self, selector);
    }
    else
    {
        switch (XZJ_ControlMask) {
            case 0:
                [self.navigationController popViewControllerAnimated: YES];
                break;
            case 1:
                [self dismissViewControllerAnimated: YES completion:nil];
                break;
            case 2:
                [self dismissViewControllerAnimated: YES completion: nil];
            default:
                break;
        }
    }
}

#pragma mark -
#pragma mark 更新会员登录数据
- (void)updateViewController
{
    if(!applicationClass){
        applicationClass = [XZJ_ApplicationClass commonApplication];
    }
    if([applicationClass methodOfExistLocal: @"LOCALUSER"])
    {
        isLogin = YES;
        memberDictionary = (NSDictionary *)[applicationClass methodOfReadLocal: @"LOCALUSER"];
    }
    else
        isLogin = NO;
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
