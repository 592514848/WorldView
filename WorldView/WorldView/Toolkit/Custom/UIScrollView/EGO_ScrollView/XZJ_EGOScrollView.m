//
//  XZJ_EGOScrollView.m
//  GRDApplication
//
//  Created by 6602 on 14-1-9.
//  Copyright (c) 2014年 Xiong. All rights reserved.
//

#import "XZJ_EGOScrollView.h"

@implementation XZJ_EGOScrollView
@synthesize xDelegate;
@synthesize ScrollView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        curScreenSize = [[UIScreen mainScreen] bounds].size;
        ScrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, frame.size.width,frame.size.height)];
        [ScrollView setDelegate: self];
        [ScrollView setShowsVerticalScrollIndicator: NO];
        [self addSubview:ScrollView];
        dataFrame = ScrollView.frame;
        
        /*----------初始化下拉刷新-----------*/
        if(_refreshHeaderView == nil)
        {
            _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f-ScrollView.bounds.size.height, ScrollView.bounds.size.width, ScrollView.bounds.size.height)];
            [_refreshHeaderView setDelegate: self];
            [ScrollView addSubview: _refreshHeaderView];
        }
    }
    return self;
}

#pragma mark -
#pragma mark EGO中scrollview的委托方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	if (_refreshHeaderView)
	{
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
	
	if (_refreshFooterView)
	{
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
    if([xDelegate respondsToSelector: @selector(XZJ_EGOScrollViewDidScroll:)]){
        [xDelegate XZJ_EGOScrollViewDidScroll: ScrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if (_refreshHeaderView)
	{
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
	if (_refreshFooterView)
	{
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}


#pragma mark -
#pragma mark EGO的委托方法
- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
    if (aRefreshPos == EGORefreshHeader)
	{
        if([xDelegate respondsToSelector: @selector(XZJ_EGOScrollViewDidRefreshData)])
        {
            [xDelegate XZJ_EGOScrollViewDidRefreshData];
        }
    }
    else if(aRefreshPos == EGORefreshFooter)
    {
        if([xDelegate respondsToSelector: @selector(XZJ_EGOScrollViewDidLoadMoreData)])
        {
            [xDelegate XZJ_EGOScrollViewDidLoadMoreData];
        }
    }
    [self performSelector:@selector(finishReloadingData) withObject:nil afterDelay:1.0];
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view{
	return reloading;
}

- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view
{
	return [NSDate date];
}

#pragma mark -
#pragma mark 设置上拉控件的位置
-(void)setFooterView
{
    if (!_refreshFooterView || ![_refreshFooterView superview])
	{
        _refreshFooterView = [[EGORefreshTableFooterView alloc] init];
        [_refreshFooterView setDelegate: self];
        [ScrollView addSubview:_refreshFooterView];
    }
    CGRect footerFrame = CGRectMake(0.0f,dataFrame.size.height, dataFrame.size.width, dataFrame.size.height);
    if(dataFrame.size.height < curScreenSize.height - dataFrame.origin.y)
        footerFrame = CGRectMake(0.0f,curScreenSize.height - dataFrame.origin.y, dataFrame.size.width, dataFrame.size.height);
    [_refreshFooterView setFrame:footerFrame];
    if (_refreshFooterView)
	{
        [_refreshFooterView refreshLastUpdatedDate];
    }
}

#pragma mark -
#pragma mark 数据加载完毕的方法
- (void)finishReloadingData{
	reloading = NO;
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:ScrollView];
    }
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:ScrollView];
        [self setFooterView];
        if(dataFrame.size.height < self.frame.size.height)
            [ScrollView setContentOffset: CGPointMake(ScrollView.contentOffset.x, 0.0f) animated: YES];
    }
}

#pragma mark -
#pragma mark 第二种设置方法
- (void)updateViewFrame:(CGSize) contentSize showFooter:(BOOL)isShow
{
    if (_refreshFooterView == nil && isShow) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading: ScrollView];
    }
    dataFrame.size = contentSize;
    if(ScrollView.frame.size.height >= contentSize.height)
    {
        [ScrollView setContentSize: CGSizeMake( dataFrame.size.width, ScrollView.frame.size.height + 80.0f)];
    }
    else
    {
        [ScrollView setContentSize:contentSize];
    }
    if(isShow)
    {
        [_refreshFooterView setHidden: NO];
        [self setFooterView];
    }
    else
        [_refreshFooterView setHidden: YES];
}

- (void)addSubviewToScrollView:(UIView *) view
{
    [ScrollView addSubview: view];
}
@end
