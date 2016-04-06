//
//  PagerViewController.m
//  WorldView
//
//  Created by WorldView on 15/11/25.
//  Copyright © 2015年 XZJ. All rights reserved.
//
#define NAVIGATIONBAR_HEIGHT 44.0f
#define CONTENTVIEW_TAG 24
#define TABVIEW_ORIGIN_Y 64.0F
#import "PagerViewController.h"
#import "PJStepSevenViewController.h"
@implementation PagerViewController
@synthesize dataSource, delegate, activeContentIndex,contents;
- (id)init
{
    self = [super init];
    if (self) {
        [self defaultSettings];
    }
    return self;
}

#pragma mark -
#pragma mark 默认设置
- (void)defaultSettings
{
    pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    [self addChildViewController: pageViewController];
    pageViewController.dataSource = self;
    pageViewController.delegate = self;
    heightOfTabView = 44.0;
}

- (void)defaultSetUp
{
    ///设置所有的选项卡
    for (UIView *tabView in self.tabs) {
        [tabView removeFromSuperview];
    }
    tabsView.contentSize = CGSizeZero;
    [self.tabs removeAllObjects];
    [contents removeAllObjects];
    //设置选项卡的属性
    tabCount = [dataSource numberOfTabView];
    self.tabs = [NSMutableArray array];
    contents = [NSMutableArray array];
    //加载选项卡主视图
    if (!tabsView) {
        tabsView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, TABVIEW_ORIGIN_Y, CGRectGetWidth(self.view.frame), heightOfTabView)];
        [tabsView setAutoresizingMask: UIViewAutoresizingFlexibleWidth];
        [tabsView setBackgroundColor: [UIColor clearColor]];
        [tabsView setScrollsToTop: NO];
        [tabsView setShowsHorizontalScrollIndicator: NO];
        [tabsView setShowsVerticalScrollIndicator: NO];
        [tabsView setBounces: NO];
        [tabsView setScrollEnabled: NO];
        [self.view insertSubview: tabsView atIndex:0];
    }
    
    //加载选项卡中的选项视图
    NSInteger contentSizeWidth = 0;
    for (NSUInteger i = 0; i < tabCount; i++) {
        if (self.tabs.count >= tabCount) {
            continue;
        }
        UIView *tabView = [dataSource viewPager:self viewForTabAtIndex:i];
        tabView.tag = i;
        CGRect frame = tabView.frame;
        frame.origin.x = contentSizeWidth;
        frame.size.width = [dataSource widthOfTabView];
        tabView.frame = frame;
        tabView.userInteractionEnabled = YES;
        [tabsView addSubview:tabView];
        [self.tabs addObject:tabView];
        contentSizeWidth += CGRectGetWidth(tabView.frame);
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [tabView addGestureRecognizer:tapGestureRecognizer];
        [contents addObject:[dataSource viewPager:self contentViewControllerForTabAtIndex:i]];
    }
    [tabsView setContentSize: CGSizeMake(contentSizeWidth, heightOfTabView)];
    
    //加载内容主视图
    contentView = [self.view viewWithTag: CONTENTVIEW_TAG];
    if (!contentView) {
        contentView = pageViewController.view;
        [contentView setAutoresizingMask: UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        [contentView setBounds: self.view.bounds];
        [contentView setTag: CONTENTVIEW_TAG];
        [self.view insertSubview: contentView atIndex:0];
        // constraints
        if ([delegate respondsToSelector:@selector(viewPagerDidAddContentView)]) {
            [delegate viewPagerDidAddContentView];
        } else {
            [contentView setTranslatesAutoresizingMaskIntoConstraints: NO];
            NSDictionary *views = @{ @"contentView" : contentView };
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[contentView]-0-|" options:0 metrics:nil views:views]];
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[contentView]-0-|" options:0 metrics:nil views:views]];
        }
    }
    ///选择第一个视图
    [self selectTabAtIndex: 0];
    ///委托方法
    if ([delegate respondsToSelector:@selector(viewPager:didSwitchAtIndex:withTabs:)]) {
        [delegate viewPager:self didSwitchAtIndex: activeContentIndex withTabs:self.tabs];
    }
}

#pragma mark -
#pragma mark viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [self defaultSetUp];
    ///1.设置视图基本属性
    XZJ_ApplicationClass *applicationClass = [XZJ_ApplicationClass commonApplication];
    [self.view setBackgroundColor: [UIColor whiteColor]];
    ////2.调整视图内容为不扩充
//    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
//        [self setEdgesForExtendedLayout:  UIRectEdgeNone];
    ////3.设置导航栏参数
    [self.navigationController.navigationBar setBarStyle: UIBarStyleDefault];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
        [self.navigationController.navigationBar setBarTintColor: [UIColor whiteColor]];
    else
        [self.navigationController.navigationBar setTintColor: [UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObject: [applicationClass methodOfTurnToUIColor: @"#ee5c5e"] forKey:NSForegroundColorAttributeName]];
    ////4.设置导航栏的返回按钮
    UIButton *leftCustomButton = [[UIButton alloc] initWithFrame: CGRectMake(0.0f, 0.0f, NAVIGATIONBAR_HEIGHT, NAVIGATIONBAR_HEIGHT)];
    [leftCustomButton setImage: [UIImage imageNamed: @"navigation_back.png"] forState: UIControlStateNormal];
    [leftCustomButton addTarget: self action: @selector(backButtonClick) forControlEvents: UIControlEventTouchUpInside];
    [leftCustomButton setImageEdgeInsets: UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f)];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView: leftCustomButton];
    [self.navigationItem setLeftBarButtonItem: leftButton];
}

#pragma mark - 返回按钮
- (void)backButtonClick
{
    [self.navigationController popViewControllerAnimated: YES];
}


#pragma mark - 选项卡的点击事件
- (void)handleTapGesture:(UITapGestureRecognizer *)sender
{
    UIViewController *viewController = [contents objectAtIndex: activeContentIndex];
    if([delegate respondsToSelector: @selector(viewPager:previousViewController:)]){
        [delegate viewPager:activeContentIndex previousViewController: viewController ];
    }
    [self selectTabAtIndex:sender.view.tag];
    [self trasitionTabViewWithView:sender.view];
}

#pragma mark -
#pragma mark 调整选项卡视图
- (void)trasitionTabViewWithView:(UIView *)view
{
    if ([delegate respondsToSelector:@selector(viewPager:didSwitchAtIndex:withTabs:)]) {
        [delegate viewPager:self didSwitchAtIndex: [view tag] withTabs:self.tabs];
    }
}

#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexForViewController:viewController];
    index++;
    if (index == [contents count]) {
        return nil;
    }
    else
        return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexForViewController:viewController];
    if (index == 0) {
        return nil;
    } else {
        index--;
        return [self viewControllerAtIndex:index];
    }
}

#pragma mark - UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)_pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed
{
    UIViewController *viewController = [pageViewController.viewControllers objectAtIndex: 0];
    NSUInteger index = [self indexForViewController:viewController];
    for (UIView *view in [tabsView subviews]) {
        if (view.tag == index) {
            [self trasitionTabViewWithView:view];
        }
    }
    if([delegate respondsToSelector: @selector(viewPager:previousViewController:)]){
        [delegate viewPager:activeContentIndex previousViewController: [previousViewControllers objectAtIndex: 0]];
    }
    activeContentIndex = index;
}

#pragma mark - 私有方法
- (void)setActiveContentIndex:(NSInteger)_activeContentIndex
{
    UIViewController *viewController = [self viewControllerAtIndex:_activeContentIndex];
    if (!viewController) {
        viewController = [[UIViewController alloc] init];
        viewController.view = [[UIView alloc] init];
        viewController.view.backgroundColor = [UIColor redColor];
    }
    if (_activeContentIndex == activeContentIndex) {
        [pageViewController setViewControllers:@[ viewController ]
                                     direction:UIPageViewControllerNavigationDirectionForward
                                      animated:NO
                                    completion:^(BOOL completed){
                                    }];
        
    }
    else {
        NSInteger direction = 0;
        if (_activeContentIndex == contents.count - 1 && activeContentIndex == 0) {
            direction = UIPageViewControllerNavigationDirectionReverse;
        }
        else if (_activeContentIndex == 0 && activeContentIndex == contents.count - 1) {
            direction = UIPageViewControllerNavigationDirectionForward;
        }
        else if (_activeContentIndex < activeContentIndex) {
            direction = UIPageViewControllerNavigationDirectionReverse;
        }
        else {
            direction = UIPageViewControllerNavigationDirectionForward;
        }
        [pageViewController setViewControllers:@[ viewController ]
                                     direction:direction
                                      animated:YES
                                    completion:^(BOOL completed){// none
                                    }];
    }
    activeContentIndex = _activeContentIndex;
}

- (void)selectTabAtIndex:(NSUInteger)index
{
    if (index >= tabCount) {
        return;
    }
    [self setActiveContentIndex:index];
}

- (UIView *)tabViewAtIndex:(NSUInteger)index
{
    return [self.tabs objectAtIndex:index];
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (index >= tabCount) {
        return nil;
    }
    
    return [contents objectAtIndex:index];
}

- (NSUInteger)indexForViewController:(UIViewController *)viewController
{
    return [contents indexOfObject:viewController];
}

#pragma mark -
#pragma mark 选择指定页面
- (void)selectPageWithIndex:(NSInteger) index
{
    if (index >= tabCount || index < 0) {
        return;
    }
    UIViewController *viewController = [contents objectAtIndex: activeContentIndex];
    if([delegate respondsToSelector: @selector(viewPager:previousViewController:)]){
        [delegate viewPager:activeContentIndex previousViewController: viewController ];
    }
    ///设置视图
    [self setActiveContentIndex:index];
    if ([delegate respondsToSelector:@selector(viewPager:didSwitchAtIndex:withTabs:)]) {
        [delegate viewPager:self didSwitchAtIndex: activeContentIndex withTabs:self.tabs];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
