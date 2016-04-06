//
//  XZJ_EGOScrollView.h
//  GRDApplication
//
//  Created by 6602 on 14-1-9.
//  Copyright (c) 2014年 Xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZJ_CommonClass.h"

@protocol XZJ_EGOScrollViewDelegate;
@interface XZJ_EGOScrollView : UIView <UIScrollViewDelegate,EGORefreshTableDelegate>
{
    BOOL reloading;
    CGSize curScreenSize;
    EGORefreshTableHeaderView *_refreshHeaderView;//下拉刷新
    EGORefreshTableFooterView *_refreshFooterView;//上拉加载更多
    CGRect dataFrame;
}

@property(retain,nonatomic) id<XZJ_EGOScrollViewDelegate> xDelegate;
@property(retain,nonatomic) UIScrollView *ScrollView;
- (void)addSubviewToScrollView:(UIView *) view;
- (void)updateViewFrame:(CGSize) contentSize showFooter:(BOOL)isShow;
@end

@protocol XZJ_EGOScrollViewDelegate <NSObject>
@optional
- (void)XZJ_EGOScrollViewDidLoadMoreData;
- (void)XZJ_EGOScrollViewDidRefreshData;
- (void)XZJ_EGOScrollViewDidScroll:(UIScrollView *)scrollView;
@end
