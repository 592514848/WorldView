//
//  XZJ_EGOTableView.m
//  GDY
//
//  Created by 6602 on 14-8-7.
//  Copyright (c) 2014年 XZJ. All rights reserved.
//
#define DFAULTCELLHEIGHT 44.0f
#define DFAULT_NAVIGATIONBAR_HEIGHT 64.0f
#import "XZJ_EGOTableView.h"

@implementation XZJ_EGOTableView
@synthesize xDelegate, tableView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        curScreenSize = [[UIScreen mainScreen] bounds].size;
        tableView = [[UITableView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
        if(CGRectIsEmpty(frame))
            [tableView setFrame: CGRectMake(0.0f, 0.0f, curScreenSize.width, curScreenSize.height)];
        [tableView setDelegate: self];
        [tableView setDataSource: self];
        [tableView setShowsVerticalScrollIndicator: NO];
        [self addSubview:tableView];
        /*----------初始化下拉刷新-----------*/
        if(!_refreshHeaderView)
        {
            _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f-tableView.bounds.size.height, tableView.bounds.size.width, tableView.bounds.size.height)];
            [_refreshHeaderView setDelegate: self];
            [tableView addSubview: _refreshHeaderView];
        }
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if(tableView)
        [tableView setFrame: CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
}
#pragma mark -
#pragma mark 是否显示下拉刷新控件
- (void)setShowRefreshHeaderView:(BOOL) isShow
{
    if(!isShow)
    {
        [_refreshHeaderView removeFromSuperview];
        _refreshHeaderView = nil;
    }
}

#pragma mark -
#pragma mark tableView的委托方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)_tableView
{
    if([xDelegate respondsToSelector: @selector(numberOfSectionsIn_XZJ_EGOTableView:)])
        return [xDelegate numberOfSectionsIn_XZJ_EGOTableView: _tableView];
    else
        return 0;
}

- (NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section
{
    if([xDelegate respondsToSelector: @selector(XZJ_EGOTableView:numberOfRowsInSection:)])
        return [xDelegate XZJ_EGOTableView: _tableView numberOfRowsInSection: section];
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([xDelegate respondsToSelector: @selector(XZJ_EGOTableView:cellForRowAtIndexPath:)])
        return [xDelegate XZJ_EGOTableView: _tableView cellForRowAtIndexPath: indexPath];
    else
        return nil;
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([xDelegate respondsToSelector: @selector(XZJ_EGOTableView:didSelectRowAtIndexPath:)])
        return [xDelegate XZJ_EGOTableView: _tableView didSelectRowAtIndexPath: indexPath];
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([xDelegate respondsToSelector: @selector(XZJ_EGOTableView:heightForRowAtIndexPath:)])
        return [xDelegate XZJ_EGOTableView: _tableView heightForRowAtIndexPath: indexPath];
    else
        return DFAULTCELLHEIGHT;
}

- (CGFloat)tableView:(UITableView *)_tableView heightForHeaderInSection:(NSInteger)section
{
    if([xDelegate respondsToSelector: @selector(XZJ_EGOTableView:heightForHeaderInSection:)])
        return [xDelegate XZJ_EGOTableView: _tableView heightForHeaderInSection: section];
    else
        return 0.0f;
}

- (UIView *)tableView:(UITableView *)_tableView viewForHeaderInSection:(NSInteger)section
{
    if([xDelegate respondsToSelector: @selector(XZJ_EGOTableView:viewForHeaderInSection:)])
        return [xDelegate XZJ_EGOTableView: _tableView viewForHeaderInSection: section];
    else
        return nil;
}

- (CGFloat)tableView:(UITableView *)_tableView heightForFooterInSection:(NSInteger)section
{
    if([xDelegate respondsToSelector: @selector(XZJ_EGOTableView:heightForFooterInSection:)])
        return [xDelegate XZJ_EGOTableView: _tableView heightForFooterInSection: section];
    else
        return 0.0f;
}

- (UIView *)tableView:(UITableView *)_tableView viewForFooterInSection:(NSInteger)section
{
    if([xDelegate respondsToSelector: @selector(XZJ_EGOTableView:viewForFooterInSection:)])
        return [xDelegate XZJ_EGOTableView: _tableView viewForFooterInSection: section];
    else
        return nil;
}

- (void)tableView:(UITableView *)_tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([xDelegate respondsToSelector: @selector(XZJ_EGOTableView:willDisplayCell:forRowAtIndexPath:)])
        return [xDelegate XZJ_EGOTableView: _tableView willDisplayCell: cell forRowAtIndexPath: indexPath];
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
    if([xDelegate respondsToSelector: @selector(XZJ_EGOTableViewDidEndScrollDragging:)]){
        [xDelegate XZJ_EGOTableViewDidEndScrollDragging: scrollView];
    }
}

#pragma mark -
#pragma mark EGO的委托方法
- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
    if (aRefreshPos == EGORefreshHeader)
	{
        if([xDelegate respondsToSelector: @selector(XZJ_EGOTableViewDidRefreshData)])
        {
            [xDelegate XZJ_EGOTableViewDidRefreshData];
        }
    }
    else if(aRefreshPos == EGORefreshFooter)
    {
        if([xDelegate respondsToSelector: @selector(XZJ_EGOTableViewDidLoadMoreData)])
        {
            [xDelegate XZJ_EGOTableViewDidLoadMoreData];
        }
    }
    [self performSelector:@selector(finishReloadingData) withObject:nil afterDelay:1.5];
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
-(void)setFooterView:(CGSize) _contentSize
{
    if (!_refreshFooterView || ![_refreshFooterView superview])
	{
        _refreshFooterView = [[EGORefreshTableFooterView alloc] init];
        [_refreshFooterView setDelegate: self];
        [tableView addSubview:_refreshFooterView];
    }
    
    CGFloat height = _contentSize.height < curScreenSize.height - DFAULT_NAVIGATIONBAR_HEIGHT - self.frame.origin.y ? curScreenSize.height - DFAULT_NAVIGATIONBAR_HEIGHT - self.frame.origin.y : _contentSize.height;
    CGRect footerFrame = CGRectMake(0.0f,height, _contentSize.width, _contentSize.height);
   
    [_refreshFooterView setFrame:footerFrame];
    if (_refreshFooterView)
	{
        [_refreshFooterView refreshLastUpdatedDate];
    }
    [self bringSubviewToFront: _refreshFooterView];
}

#pragma mark -
#pragma mark 数据加载完毕的方法
- (void)finishReloadingData{
	reloading = NO;
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:tableView];
    }
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:tableView];
        [self setFooterView:contentSize];
        if(contentSize.height < curScreenSize.height - DFAULT_NAVIGATIONBAR_HEIGHT)
        {
            if([tableView numberOfSections] > 0)
                [tableView scrollToRowAtIndexPath: [NSIndexPath indexPathForRow: 0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated: YES];
        }
    }
}

#pragma mark -
#pragma mark 调整视图的大小
- (void)updateViewSize:(CGSize) _contentSize showFooter:(BOOL)isShow
{
//    [tableView setScrollEnabled: NO];
    if (_refreshFooterView == nil && isShow) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading: tableView];
    }
    contentSize = _contentSize;
    if(isShow)
    {
        [_refreshFooterView setHidden: NO];
        [self setFooterView:_contentSize];
    }
    else
        [_refreshFooterView setHidden: YES];
}

#pragma mark -
#pragma mark 设置视图背景
- (void)setBackgroundColor:(UIColor *) color
{
    [super setBackgroundColor: color];
    [tableView setBackgroundColor: color];
}

#pragma mark -
#pragma mark 重新绑定数据
- (void)reloadData
{
    [tableView reloadData];
}

#pragma mark -
#pragma mark 设置tableView的分割线样式
- (void)setSeparatorStyle:(UITableViewCellSeparatorStyle) style
{
    [tableView setSeparatorStyle: style];
}

#pragma mark -
#pragma mark 插入section
- (void)insertSections:(NSIndexSet *) set
{
    [tableView beginUpdates];
    [tableView insertSections: set withRowAnimation: UITableViewRowAnimationAutomatic];
    [tableView endUpdates];
}

#pragma mark -
#pragma mark 插入rows
- (void)insertRows:(NSArray *) indexPaths
{
    [tableView beginUpdates];
    [tableView insertRowsAtIndexPaths: indexPaths withRowAnimation: UITableViewRowAnimationAutomatic];
    [tableView endUpdates];
}

#pragma mark -
#pragma mark 设置tableVive的footer视图
- (void)setTableViewFooterView
{
    UIView *tempView = [[UIView alloc] init];
    [tableView setTableFooterView: tempView];
}

- (void)deleteSections:(NSIndexSet *) indexSet withRowAnimation:(UITableViewRowAnimation) animation
{
    [tableView deleteSections:indexSet withRowAnimation:animation];
}
@end
