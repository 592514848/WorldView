//
//  HomePageViewController.m
//  WorldView
//
//  Created by XZJ on 10/28/15.
//  Copyright © 2015 XZJ. All rights reserved.
//
#define NAVIGATIONBAR_HEIGHT 44.0f
#import "HomePageViewController.h"
#import "TravelListViewController.h"
#import "PrivateMessageListViewController.h"
#import "WishListViewController.h"
#import "ReserveListViewController.h"
#import "PublishedJourneyViewController.h"
#import "PublishJourneyViewController.h"
#import "MemberInfoViewController.h"
#import "LoginViewController.h"
#import "EmailRegisterNavigationController.h"
#import "PhoneRegisternavigationController.h"
#import "SettingViewController.h"
#import "BHStepOneViewController.h"

@implementation HomePageViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadSideslipBar];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(weChatLoginresult) name: @"WXApiManager_weChatLogin" object: nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ////1.加载欢迎页
    [self loadWelcomePage];
    ////2.获取城市列表数据
    countryObj = [[CountryObject alloc] init];
    [countryObj setXDelegate: self];
    [countryObj countryList];
}

#pragma mark -
#pragma mark 加载欢迎页
- (void)loadWelcomePage
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    mainWelcomeScrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, screenSize.width, screenSize.height)];
    [mainWelcomeScrollView setShowsVerticalScrollIndicator: NO];
    [mainWelcomeScrollView setShowsHorizontalScrollIndicator: NO];
    [mainWelcomeScrollView setBounces: NO];
    [mainWelcomeScrollView setDelegate: self];
    [mainWelcomeScrollView setBackgroundColor: [UIColor whiteColor]];
    [mainWelcomeScrollView setPagingEnabled: YES];
    [[[UIApplication sharedApplication] keyWindow] addSubview: mainWelcomeScrollView];
    //////
    for(NSInteger i = 0; i < 3; i++){
        UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame: CGRectMake(i * (curScreenSize.width), 0.0f, screenSize.width, screenSize.height)];
        [tmpImageView setContentMode: UIViewContentModeScaleAspectFill];
        [tmpImageView.layer setMasksToBounds: YES];
        [tmpImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: [NSString stringWithFormat: @"wp%ld", (long)i] ofType: @"jpg"]]];
        [mainWelcomeScrollView addSubview: tmpImageView];
    }
    [mainWelcomeScrollView setContentSize: CGSizeMake(3 * screenSize.width, screenSize.height)];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.x >= 2 * curScreenSize.width){
        CATransition *transition = [CATransition animation];
        [transition setDuration: 3.5f];
        [transition setTimingFunction: [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [transition setType: kCATransitionFade];
        [transition setSubtype: kCATransitionFromLeft];
        [scrollView.layer.superlayer addAnimation:transition forKey:nil];
        [scrollView.layer addAnimation:transition forKey:nil];
        [scrollView removeFromSuperview];
        ////加载广告数据
        AdObject *adObjc = [[AdObject alloc] init];
        [adObjc setXDelegate: self];
        [adObjc getAdList];
    }
}

#pragma mark -
#pragma mark 广告对象的委托
- (void)adObjectDelegate_GetAdLsit:(NSArray *)dataArray
{
    if([dataArray count] > 0){
        [navigationLeftButton setHidden: YES];
        HomePageNewsView *newsView = [[HomePageNewsView alloc] initWithFrame: [[UIScreen mainScreen] bounds] buttonRect: CGRectMake(0.0f, 0.0f, NAVIGATIONBAR_HEIGHT, NAVIGATIONBAR_HEIGHT) delegate: self dataArray: dataArray];
        [[[UIApplication sharedApplication] keyWindow] insertSubview: newsView belowSubview: mainWelcomeScrollView];
    }
}

#pragma mark -
#pragma mark 获取到城市列表
- (void)countryObject_GetCountryList:(NSArray *)dataArray
{
    countryListArray = dataArray;
    if(!homePageMainView){
        homePageMainView = [[HomePageMainListView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, curScreenSize.width, curScreenSize.height) dataArray: dataArray];
        [homePageMainView setViewControllerSender: self];
        [homePageMainView setXDelegate: self];
        [self.view addSubview: homePageMainView];
        ///
        [self loadNavigationBar];
    }
    else
    {
        [homePageMainView updateView: countryListArray];
    }
}

#pragma mark -
#pragma mark 加载导航栏
- (void)loadNavigationBar
{
    ////初始化导航栏
    navigationLeftButton = [[UIButton alloc] initWithFrame: CGRectMake(0.0f, 0.0f, NAVIGATIONBAR_HEIGHT, NAVIGATIONBAR_HEIGHT)];
    [navigationLeftButton setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"hp_member" ofType: @"png"]] forState: UIControlStateNormal];
    [navigationLeftButton setContentMode: UIViewContentModeScaleAspectFit];
    [navigationLeftButton setImageEdgeInsets: UIEdgeInsetsMake(12.0f, 12.0f, 12.0f, 12.0f)];
    [navigationLeftButton setTag: 0];
    [navigationLeftButton addTarget: self action: @selector(BarButtonItemClick:) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *barBurronItem = [[UIBarButtonItem alloc] initWithCustomView: navigationLeftButton];
    [self.navigationItem setLeftBarButtonItem: barBurronItem];
    ////
    navigationRightButton = [[UIButton alloc] initWithFrame: CGRectMake(0.0f, 0.0f, NAVIGATIONBAR_HEIGHT, NAVIGATIONBAR_HEIGHT)];
    [navigationRightButton setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"hp_ball" ofType: @"png"]] forState: UIControlStateNormal];
    [navigationRightButton setContentMode: UIViewContentModeScaleAspectFit];
    [navigationRightButton setImageEdgeInsets: UIEdgeInsetsMake(12.0f, 12.0f, 12.0f, 12.0f)];
    [navigationRightButton setTag: 1];
    [navigationRightButton addTarget: self action: @selector(BarButtonItemClick:) forControlEvents: UIControlEventTouchUpInside];
    barBurronItem = [[UIBarButtonItem alloc] initWithCustomView: navigationRightButton];
    [self.navigationItem setRightBarButtonItem: barBurronItem];
    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0.0f, 12.0f, curScreenSize.width - NAVIGATIONBAR_HEIGHT, NAVIGATIONBAR_HEIGHT - 24.0f)];
    [titleImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"hp_logo" ofType: @"png"]]];
    [titleImageView setContentMode: UIViewContentModeScaleAspectFit];
    [self.navigationItem setTitleView: titleImageView];
}

#pragma mark 导航栏按钮点击事件
-(void)BarButtonItemClick:(UIButton *) sender
{
    switch ([sender tag]) {
        case 0:
            [sideBarMainView show];
            break;
        case 1:
        {
            [navigationRightButton setHidden: YES];
            HomePageLocationView *locationView = [[HomePageLocationView alloc] initWithFrame: [[UIScreen mainScreen] bounds] buttonRect: CGRectMake(0.0f, 0.0f, NAVIGATIONBAR_HEIGHT, NAVIGATIONBAR_HEIGHT) delegate: self dataArray: countryListArray];
            [[[UIApplication sharedApplication] keyWindow] addSubview: locationView];
            break;
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark 加载侧边栏
- (void)loadSideslipBar
{
    ////1.初始化侧边栏
    CGFloat sideBarWidth = curScreenSize.width - 75.0f;
    if(!sideBarMainView){
        sideBarMainView = [[XZJ_SideBarView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, curScreenSize.width, [[UIScreen mainScreen] bounds].size.height) sideBarWidth: sideBarWidth];
        [sideBarMainView setXDelegate: self];
        [[[UIApplication sharedApplication] keyWindow] addSubview: sideBarMainView];
        [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront: sideBarMainView];
        ////2.侧滑手势
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [self.view addGestureRecognizer:panGestureRecognizer];
    }
    ////初始化内容试图
    if(isLogin){
        if(!mainMemberView)
        {
            mainMemberView = [[HomePageMemberView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, sideBarMainView.sideBarWidth, sideBarMainView.frame.size.height) delegate: self];
            [sideBarMainView setContentViewInSideBar: mainMemberView];
        }
        else{
            [mainLoginView setHidden: YES];
            [mainMemberView setHidden: NO];
            [mainMemberView updateMemberInfo];
        }
    }
    else{
        if(!mainLoginView)
        {
            ///未登录状态
            mainLoginView = [[HomePageLoginView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, sideBarMainView.sideBarWidth, sideBarMainView.frame.size.height) sender: self];
//            __weak typeof(self) weakSelf = self;
            mainLoginView.weChatLogin = ^{
                [[WXApiManager shareManager] sendLoginReq];
            };
            [sideBarMainView setContentViewInSideBar: mainLoginView];
        }
        else{
            [mainLoginView setHidden: NO];
            [mainMemberView setHidden: YES];
        }
    }
}

#pragma mark 处理侧滑手势
- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer
{
//    ////当手势在屏幕的1/2处时，才启动侧边栏
//    if (recognizer.state == UIGestureRecognizerStateBegan) {
//        CGPoint startPoint = [recognizer locationInView:self.view];
//        if (startPoint.x < self.view.bounds.size.width / 2.0) {
//            [sideBarMainView handlePanGestureToShow:recognizer inView: self.view];
//        }
//    }
    [sideBarMainView handlePanGestureToShow:recognizer inView: self.view];
}

#pragma mark 侧滑委托
- (void)sideBar:(XZJ_SideBarView *)sideBar willAppear:(BOOL)animated
{
//    ///调整主视图大小
//    [self.view setFrame: CGRectMake(0.0f, 0.0f, curScreenSize.height, curScreenSize.height+ 100.0f)];
//    [homePageMainView updateFrame: CGRectMake(0.0f, 0.0f, curScreenSize.width, self.view.frame.size.height)];
//    ///隐藏导航栏
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}

- (void)sideBar:(XZJ_SideBarView *)sideBar didAppear:(BOOL)animated
{
//    ///调整主视图大小
//    [self.view setFrame: CGRectMake(0.0f, 0.0f, curScreenSize.height, curScreenSize.height)];
//    [homePageMainView updateFrame: CGRectMake(0.0f, 0.0f, curScreenSize.width, self.view.frame.size.height)];
}

- (void)sideBar:(XZJ_SideBarView *)sideBar willDisappear:(BOOL)animated
{
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

- (void)sideBar:(XZJ_SideBarView *)sideBar didDisappear:(BOOL)animated
{
    if(isPushNextVC){
        isPushNextVC = NO;
        switch ([curOperateIndexPath section]) {
            case 0:
            {
                switch ([curOperateIndexPath row]) {
                    case 0:
                    {
                        MemberInfoViewController *nextVC = [[MemberInfoViewController alloc] init];
                        [self.navigationController pushViewController: nextVC animated: YES];
                        break;
                    }
                    case 1:
                    {
                        PublishJourneyViewController *nextVC = [[PublishJourneyViewController alloc] init];
                        [self.navigationController pushViewController: nextVC animated: YES];
                        break;
                    }
                    default:
                        break;
                }
                break;
            }
            case 1:
            {
                switch ([curOperateIndexPath row]) {
                    case 0:
                    {
                        ////我的行程单
                        TravelListViewController *traveListVC = [[TravelListViewController alloc] init];
                        [self.navigationController pushViewController: traveListVC animated: YES];
                        break;
                    }
                    case 1:
                    {
                        ////我的心愿单
                        WishListViewController *wishListVC = [[WishListViewController alloc] init];
                        [self.navigationController pushViewController: wishListVC animated: YES];
                        break;
                    }
                    case 2:
                    {
                        ////私信
                        PrivateMessageListViewController *pmListVC = [[PrivateMessageListViewController alloc] init];
                        [self.navigationController pushViewController: pmListVC animated: YES];
                    }
                    default:
                        break;
                }
                break;
            }
            case 2:
            {
                if([[memberDictionary objectForKey: @"userType"]  isEqualToString: @"HUNTER_USER"]){
                    switch ([curOperateIndexPath row]) {
                        case 0:
                        {
                            ///我收到的预定
                            ReserveListViewController *reserveListVC = [[ReserveListViewController alloc] init];
                            [self.navigationController pushViewController: reserveListVC animated: YES];
                            break;
                        }
                        case 1:
                        {
                            ///我发布的旅程
                            PublishedJourneyViewController *publishedListVC = [[PublishedJourneyViewController alloc] init];
                            [self.navigationController pushViewController: publishedListVC animated: YES];
                            break;
                        }
                        default:
                            break;
                    }
                    
                }
                else{
                    ///成为猎人
                    BHStepOneViewController *publishedListVC = [[BHStepOneViewController alloc] init];
                    [self.navigationController pushViewController: publishedListVC animated: YES];
                }
            }
            case 3:
            {
                switch ([curOperateIndexPath row]) {
                    case 2:
                    {
                        SettingViewController *settingVC = [[SettingViewController alloc] init];
                        [self.navigationController pushViewController: settingVC animated: YES];
                        break;
                    }
                    default:
                        break;
                }
                break;
            }
            default:
                break;
        }
    }

}

#pragma mark -
#pragma mark HomePageLocationViewDelegate
- (void)homePageLocationView_DidCancelButton
{
    [navigationRightButton setHidden: NO];
}

#pragma mark -
#pragma mark HomePageNewsViewDelegate
- (void)homePageNewsView_DidCancelButton
{
    [navigationLeftButton setHidden: NO];
}

#pragma mark -
#pragma mark HomePageMemberViewDelegate
- (void)homePageMemberView_WillDisplay:indexPath
{
    curOperateIndexPath = indexPath;
    isPushNextVC = YES;
    [sideBarMainView dismiss];
}

- (void)homePageLoginView_DidClick:(NSInteger)index
{
    [sideBarMainView dismiss];
    switch(index){
        case 0:
        {
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            [loginVC setXZJ_ControlMask: kMODALControlMask];
            [loginVC setTopBarTitle: @"用户登录"];
            [self presentViewController: loginVC animated: YES completion: nil];
            break;
        }
        case 1:
        {
            PhoneRegisternavigationController *registerVC = [[PhoneRegisternavigationController alloc] init];
            [self presentViewController: registerVC animated: YES completion: nil];
            break;
        }
        case 2:
        {
            EmailRegisterNavigationController *registerVC = [[EmailRegisterNavigationController alloc] init];
            [self presentViewController: registerVC animated: YES completion: nil];
            break;
        }
    }
}

#pragma mark -
#pragma mark HomePageMainListView委托
- (void)HomePageMainListView_DidRefeshData
{
    [countryObj countryList];
}

- (void)HomePageMainListView_DidLoadMoreData
{
    
}

#pragma mark - 微信登录结果
- (void)weChatLoginresult{
    [super viewWillAppear: YES];
    [self loadSideslipBar];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver: self name: @"WXApiManager_weChatLogin" object: nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
