//
//  PagerViewController.h
//  WorldView
//
//  Created by WorldView on 15/11/25.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZJ_ApplicationClass.h"
@class PagerViewController;

#pragma mark PagerViewDataSource
@protocol PagerViewDataSource <NSObject>
- (NSUInteger)numberOfTabView;
- (NSInteger)widthOfTabView;
- (UIView *)viewPager:(PagerViewController *)viewPager viewForTabAtIndex:(NSUInteger)index;
- (UIViewController *)viewPager:(PagerViewController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index;
@end

#pragma mark PagerViewDelegate
@protocol PagerViewDelegate <NSObject>
@optional
- (void)viewPager:(PagerViewController *)viewPager didSwitchAtIndex:(NSInteger)index withTabs:(NSArray *)tabs;
- (void)viewPagerDidAddContentView;
- (void)viewPager:(NSInteger)index previousViewController:(UIViewController *)previousViewController;
@end

@interface PagerViewController : UIViewController<UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate>
{
    UIScrollView *tabsView;
    UIView *contentView;
    CGFloat heightOfTabView;
    NSInteger tabCount;
    UIPageViewController *pageViewController;
}
@property(nonatomic, retain) NSMutableArray *tabs;//选项卡
@property(nonatomic, retain) NSMutableArray *contents; //ViewControllers
@property(nonatomic, retain) id<PagerViewDataSource> dataSource;
@property(nonatomic, retain) id<PagerViewDelegate> delegate;
@property(nonatomic) NSInteger activeContentIndex;

- (void)setActiveContentIndex:(NSInteger)index;
- (void)selectPageWithIndex:(NSInteger) index;
@end
