//
//  XZJSideBarView.h
//  WorldView
//
//  Created by XZJ on 11/4/15.
//  Copyright © 2015 XZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XZJ_SideBarView;
@protocol XZJ_SideBarViewDelegate <NSObject>
@optional
- (void)sideBar:(XZJ_SideBarView *)sideBar didAppear:(BOOL)animated;
- (void)sideBar:(XZJ_SideBarView *)sideBar willAppear:(BOOL)animated;
- (void)sideBar:(XZJ_SideBarView *)sideBar didDisappear:(BOOL)animated;
- (void)sideBar:(XZJ_SideBarView *)sideBar willDisappear:(BOOL)animated;
@end

@interface XZJ_SideBarView : UIView
{
    CGPoint panStartPoint;
}
@property(nonatomic) CGFloat sideBarWidth;
@property(nonatomic, retain)UIView *contentView;
@property(nonatomic, retain) id<XZJ_SideBarViewDelegate> xDelegate;
- (id)initWithFrame:(CGRect)frame sideBarWidth:(CGFloat) _sidth;
- (void)show;
-(void)dismiss;
- (void)handlePanGestureToShow:(UIPanGestureRecognizer *)recognizer inView:(UIView *)parentView;
- (void)setContentViewInSideBar:(UIView *) view;
@end
