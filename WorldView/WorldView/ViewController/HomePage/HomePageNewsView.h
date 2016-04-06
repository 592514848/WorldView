//
//  HomePageNewsView.h
//  WorldView
//
//  Created by XZJ on 10/30/15.
//  Copyright © 2015 XZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZJ_ApplicationClass.h"
#import "AdClass.h"
#import "WebViewViewController.h"

@protocol HomePageNewsViewDelegate <NSObject>
- (void)homePageNewsView_DidCancelButton;
@end

@interface HomePageNewsView : UIView<XZJ_ImagesScrollViewDelegate>
{
    UIView *lineView;
    NSTimer *timer;
    UIView *contentView;
    XZJ_ImagesScrollView *contentImageScrollView;
    UIViewController<HomePageNewsViewDelegate> *xDelegate;
    CGFloat selfAlpha;
}
@property(nonatomic, retain) NSArray *dataArray;
- (id)initWithFrame:(CGRect)frame buttonRect:(CGRect) buttonFrame delegate:(UIViewController<HomePageNewsViewDelegate> *) _delegate dataArray:(NSArray *) _dataArray;
- (void)show;
- (void)dismiss;
@end
