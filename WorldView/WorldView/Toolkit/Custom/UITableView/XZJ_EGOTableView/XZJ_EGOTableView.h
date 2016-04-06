//
//  XZJ_EGOTableView.h
//  GDY
//
//  Created by 6602 on 14-8-7.
//  Copyright (c) 2014年 XZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

@protocol XZJ_EGOTableViewDelegate;
@interface XZJ_EGOTableView : UIView<UITableViewDelegate, UITableViewDataSource,EGORefreshTableDelegate>
{
    BOOL reloading;
    CGSize curScreenSize;
    EGORefreshTableHeaderView *_refreshHeaderView;//下拉刷新
    EGORefreshTableFooterView *_refreshFooterView;//上拉加载更多
    CGSize contentSize;
}
@property(retain,nonatomic) id<XZJ_EGOTableViewDelegate> xDelegate;
@property(retain,nonatomic) UITableView *tableView;

- (void)updateViewSize:(CGSize) _contentSize showFooter:(BOOL)isShow;
- (void)reloadData;
- (void)setBackgroundColor:(UIColor *) color;
- (void)insertSections:(NSIndexSet *) set;
- (void)setSeparatorStyle:(UITableViewCellSeparatorStyle) style;
- (void)insertRows:(NSArray *) indexPaths;
- (void)setShowRefreshHeaderView:(BOOL) isShow;
- (void)setTableViewFooterView;
- (void)deleteSections:(NSIndexSet *) indexSet withRowAnimation:(UITableViewRowAnimation) animation;
@end

@protocol XZJ_EGOTableViewDelegate <NSObject>
@optional
- (void)XZJ_EGOTableViewDidLoadMoreData;
- (void)XZJ_EGOTableViewDidRefreshData;
- (NSInteger)numberOfSectionsIn_XZJ_EGOTableView:(UITableView *)_tableView;
- (NSInteger)XZJ_EGOTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)XZJ_EGOTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)XZJ_EGOTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)XZJ_EGOTableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (CGFloat)XZJ_EGOTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)XZJ_EGOTableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
- (UIView *)XZJ_EGOTableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
- (UIView *)XZJ_EGOTableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;
- (void)XZJ_EGOTableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)XZJ_EGOTableViewDidEndScrollDragging:(UIScrollView *) scrollView;
@end

