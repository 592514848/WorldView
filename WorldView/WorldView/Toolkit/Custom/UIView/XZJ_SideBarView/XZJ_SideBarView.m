//
//  XZJSideBarView.m
//  WorldView
//
//  Created by XZJ on 11/4/15.
//  Copyright © 2015 XZJ. All rights reserved.
//
#define WINDOW [[UIApplication sharedApplication] keyWindow]
#import "XZJ_SideBarView.h"

@implementation XZJ_SideBarView
@synthesize contentView, sideBarWidth, xDelegate;
- (id)initWithFrame:(CGRect)frame sideBarWidth:(CGFloat) _sidth
{
    self = [super initWithFrame:frame];
    sideBarWidth = _sidth;
    if(self){
        ///1.主视图属性
        [self setBackgroundColor: [UIColor clearColor]];
        [self setHidden: YES]; //默认是隐藏的
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(tapGestureRecongnizer:)];
        [self setUserInteractionEnabled: YES];
        [tap setCancelsTouchesInView: NO];
        [self addGestureRecognizer: tap];
        
        ///2.内容视图
        contentView = [[UIView alloc] initWithFrame: CGRectMake(-sideBarWidth, 0.0f, sideBarWidth, frame.size.height)];
        [contentView setBackgroundColor: [UIColor whiteColor]]; //默认白色背景;
        [contentView.layer setShadowOpacity: 0.2f];
        [contentView.layer setShadowOffset: CGSizeMake(0.0f, 1.0f)];
        [contentView setUserInteractionEnabled: YES];
        [self addSubview: contentView];
        
        ///3.添加右滑取消手势
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureToLeft:)];
        [self addGestureRecognizer:panGestureRecognizer];
    }
    return self;
}

#pragma mark -
#pragma mark 处理向左侧滑手势
- (void)handlePanGestureToLeft:(UIPanGestureRecognizer *)recognizer
{
    ///1.获取滑动的起始坐标
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        panStartPoint = [recognizer locationInView: self];
    }
    ///2.获取滑动的当前坐标
    CGPoint currentPoint = [recognizer locationInView:self];
    if(currentPoint.x < panStartPoint.x){
        if (recognizer.state == UIGestureRecognizerStateChanged) {
            [self moveViewFromRightTox: panStartPoint.x - currentPoint.x];
        }
        if (recognizer.state == UIGestureRecognizerStateEnded) {
            if (sideBarWidth + contentView.frame.origin.x < sideBarWidth * 2.0f / 3.0f) {
                [self dismiss];
            } else {
                [self show];
            }
        }
    }
}

#pragma mark -
#pragma mark 处理向右侧滑手势
- (void)handlePanGestureToShow:(UIPanGestureRecognizer *)recognizer inView:(UIView *)parentView
{
    ///1.获取滑动的起始坐标
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        panStartPoint = [recognizer locationInView:parentView];
        if([recognizer translationInView: parentView].x > 0){
            [self setHidden: NO];
        }
    }
    ///2.获取滑动的当前坐标
    CGPoint currentPoint = [recognizer locationInView:parentView];
    if(currentPoint.x >= panStartPoint.x){
        
        if (recognizer.state == UIGestureRecognizerStateChanged) {
            [self moveViewTox: currentPoint.x - panStartPoint.x];
        }
        if (recognizer.state == UIGestureRecognizerStateEnded) {
            if (sideBarWidth + contentView.frame.origin.x < sideBarWidth / 3.0f) {
                [self dismiss];
            } else {
                [self show];
            }
        }
    }
}

#pragma mark -
#pragma mark 显示侧边栏
- (void)show
{
    [UIView animateWithDuration:0.45f animations:^{
        ///1.执行委托
        if([xDelegate respondsToSelector: @selector(sideBar:willAppear:)])
            [xDelegate sideBar: self willAppear: YES];
        ///2.显示侧滑栏的背景
        [self setHidden: NO];
        ///3.调整内容视图的frame
        CGRect frame = contentView.frame;
        frame.origin.x = 0.0f;
        contentView.frame = frame;
        ///4.主视图的背景颜色透明值
        CGFloat alpha = 0.5f;
        [self setBackgroundColor: [[UIColor alloc] initWithWhite: 0.3f alpha: alpha]];
    } completion:^(BOOL finished) {
        ///5.执行委托
        if([xDelegate respondsToSelector: @selector(sideBar:didAppear:)])
            [xDelegate sideBar: self didAppear: YES];
    }];
}

#pragma mark -
#pragma mark 隐藏侧边栏
-(void)dismiss
{
    [UIView animateWithDuration:0.45f animations:^{
        ///1.执行委托
        if([xDelegate respondsToSelector: @selector(sideBar:willDisappear:)])
            [xDelegate sideBar: self willDisappear: YES];
        ///2.调整内容视图的frame
        CGRect frame = contentView.frame;
        frame.origin.x = -sideBarWidth;
        contentView.frame = frame;
        ///3.主视图的背景颜色透明值
        [self setBackgroundColor: [[UIColor alloc] initWithWhite: 0.3f alpha: 0.0f]];
    } completion:^(BOOL finished) {
        ///4.隐藏侧滑栏的背景
        [self setHidden: YES];
        ///5.执行委托
        if([xDelegate respondsToSelector: @selector(sideBar:didDisappear:)])
            [xDelegate sideBar: self didDisappear: YES];
    }];
}

#pragma mark -
#pragma mark 移动到指定的x轴
- (void)moveViewTox:(CGFloat) origin_x
{
    origin_x = origin_x > self.frame.size.width ? self.frame.size.width : origin_x;
    origin_x = origin_x < 0.0f ? 0.0f : origin_x;
    CGRect frame = contentView.frame;
    if(origin_x - sideBarWidth <= 0.0f){
        frame.origin.x = origin_x - sideBarWidth;
        contentView.frame = frame;
        float alpha = origin_x / self.frame.size.width / 2.0f;//透明值
        //背景颜色透明值
        [self setBackgroundColor: [[UIColor alloc] initWithWhite: 0.3f alpha: alpha]];
    }
}

#pragma mark -
#pragma mark 移动到指定的x轴
- (void)moveViewFromRightTox:(CGFloat) origin_x
{
    origin_x = origin_x > self.frame.size.width ? self.frame.size.width : origin_x;
    origin_x = origin_x < 0.0f ? 0.0f : origin_x;
    CGRect frame = contentView.frame;
    if(origin_x > 0.0f){
        frame.origin.x =  - origin_x;
        contentView.frame = frame;
        float alpha = origin_x / self.frame.size.width / 2.0f;//透明值
        //背景颜色透明值
        [self setBackgroundColor: [[UIColor alloc] initWithWhite: 0.3f alpha: alpha]];
    }
}

#pragma mark -
#pragma mark 设置内容视图
- (void)setContentViewInSideBar:(UIView *) view
{
    [contentView addSubview: view];
}

#pragma mark -
#pragma mark 屏幕点击事件
- (void)tapGestureRecongnizer:(UIGestureRecognizer *) recognizer
{
    CGPoint curTapPoint = [recognizer locationInView: self];
    if(curTapPoint.x > sideBarWidth){
        [self dismiss];
    }
}
@end
