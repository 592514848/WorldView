//
//  HomePageNewsView.m
//  WorldView
//
//  Created by XZJ on 10/30/15.
//  Copyright © 2015 XZJ. All rights reserved.
//
#define SELF_ALPHA 0.6f
#define LINE_HEIGHT 60.0f
#import "HomePageNewsView.h"

@implementation HomePageNewsView
@synthesize dataArray;
- (id)initWithFrame:(CGRect)frame buttonRect:(CGRect) buttonFrame delegate:(UIViewController<HomePageNewsViewDelegate> *) _delegate dataArray:(NSArray *) _dataArray
{
    if(self = [super initWithFrame: frame])
    {
        xDelegate = _delegate;
        dataArray = _dataArray;
        [self setBackgroundColor: [[UIColor alloc] initWithWhite: 0.3f alpha: 0.6f]];
        ///1.取消按钮
        CGFloat flow = ([UIScreen mainScreen].bounds.size.width > 375.0f ? 20.0f : 16.0f);
        UIButton *cancelButton = [[UIButton alloc] initWithFrame: CGRectMake(buttonFrame.origin.x + flow, 20.0f + buttonFrame.origin.y, buttonFrame.size.width, buttonFrame.size.height)];
        [cancelButton setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"cancel_btn" ofType: @"png"]] forState: UIControlStateNormal];
        [cancelButton setContentMode: UIViewContentModeScaleAspectFit];
        [cancelButton setImageEdgeInsets: UIEdgeInsetsMake(12.0f, 12.0f, 12.0f, 12.0f)];
        [cancelButton addTarget: self action: @selector(dismiss) forControlEvents: UIControlEventTouchUpInside];
        [self addSubview: cancelButton];
        ///2.线条
        CGFloat origin_X = buttonFrame.size.width / 2.0f + buttonFrame.origin.x + flow - 1.0f;
        CGFloat origin_y = buttonFrame.size.height + cancelButton.frame.origin.y - 12.0f;
        lineView = [[UIView alloc] initWithFrame: CGRectMake(origin_X, origin_y, 1.0f, 1.0f)];
        [lineView setBackgroundColor: [UIColor whiteColor]];
        [self addSubview: lineView];

        ///3.内容展示框
        origin_y += LINE_HEIGHT + 2.0f;
        origin_X = flow + 15.0f;
        contentView = [[UIView alloc] initWithFrame: CGRectMake(origin_X, origin_y, frame.size.width - 2 * origin_X, frame.size.height * 2.0f / 3.0f)];
        [contentView setBackgroundColor: [UIColor whiteColor]];
        [contentView.layer setCornerRadius: 3.0f];
        [contentView.layer setMasksToBounds: YES];
        [contentView setHidden: YES];
        [contentView.layer setMasksToBounds: YES];
        [self addSubview: contentView];
        ///4.内容的主题图片
        NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity: [dataArray count]];
        for(NSInteger i = 0; i < [dataArray count]; i++){
            AdClass *ad = [dataArray objectAtIndex: i];
            [imageArray addObject: IMAGE_URL([ad adImageUrl])];
        }
        contentImageScrollView = [[XZJ_ImagesScrollView alloc] initWith:CGRectMake(0.0f, 0.0f, contentView.frame.size.width, contentView.frame.size.height) ImagesArray: imageArray TitleArray: nil isURL: YES];
        [contentImageScrollView setDelegate: self];
        [contentImageScrollView.noteView setHidden: YES];
        [contentView addSubview: contentImageScrollView];
        ///显示
        [self show];
    }
    return self;
}

#pragma mark -
#pragma mark 显示主视图
- (void)show
{
    [self setHidden: NO];
    timer = [NSTimer scheduledTimerWithTimeInterval: 0.01f target: self selector: @selector(autoUpBackgroundAlpha) userInfo: nil repeats: YES];
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront: self];
    CGRect contentViewFrame = [contentView frame];
    [contentView setFrame: CGRectMake(contentViewFrame.origin.x, contentViewFrame.origin.y, contentViewFrame.size.width, 0.0f)];
    [UIView animateWithDuration: 0.2f animations:^{
        CGRect lineFrame = [lineView frame];
        lineFrame.size.height = LINE_HEIGHT;
        [lineView setFrame: lineFrame];
    } completion: ^(BOOL finished){
        [contentView setHidden: NO];
        [UIView animateWithDuration: 0.2f animations: ^{
            [contentView setFrame: CGRectMake(contentViewFrame.origin.x, contentViewFrame.origin.y, contentViewFrame.size.width, self.frame.size.height * 2.0f / 3.0f)];
        }];
    }];
}

#pragma mark -
#pragma mark 隐藏主视图
- (void)dismiss
{
    ///1.隐藏背景透明度
    timer = [NSTimer scheduledTimerWithTimeInterval: 0.01f target: self selector: @selector(autoDownBackgroundAlpha) userInfo: nil repeats: YES];
    ///2.隐藏内容视图等
    [UIView animateWithDuration: 0.2f animations:^{
        CGRect contentViewFrame = [contentView frame];
        [contentView setFrame: CGRectMake(contentViewFrame.origin.x, contentViewFrame.origin.y, contentViewFrame.size.width, 0.0f)];
    } completion: ^(BOOL finished){
        [UIView animateWithDuration: 0.2f animations: ^{
            CGRect lineFrame = [lineView frame];
            lineFrame.size.height = 0.0f;
            [lineView setFrame: lineFrame];
        } completion:^(BOOL finished){
            [self setHidden: YES];
            if([xDelegate respondsToSelector: @selector(homePageNewsView_DidCancelButton)]){
                [xDelegate homePageNewsView_DidCancelButton];
            }
        }];
    }];
}

#pragma mark 自动加深主视图的背景透明度
- (void)autoUpBackgroundAlpha
{
    if(selfAlpha < SELF_ALPHA){
        selfAlpha += 0.1f;
        [self setBackgroundColor: [[UIColor alloc] initWithWhite: 0.3f alpha: selfAlpha]];
    }
    else
    {
        [timer setFireDate: [NSDate distantFuture]];
    }
}

#pragma mark 自动减少主视图的背景透明度
- (void)autoDownBackgroundAlpha
{
    if(selfAlpha > 0.0f){
        selfAlpha -= 0.08f;
        [self setBackgroundColor: [[UIColor alloc] initWithWhite: 0.3f alpha: selfAlpha]];
    }
    else
    {
        selfAlpha = 0.0f;
        [timer setFireDate: [NSDate distantFuture]];
    }
}

#pragma mark -
#pragma mark 页面空白处点击事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}

- (void)XZJ_ImagesScrollViewDidClicked:(NSUInteger)index
{
    if([dataArray count] > index){
        [self dismiss];
        AdClass *ad = [dataArray objectAtIndex: index];
        WebViewViewController *webView = [[WebViewViewController alloc] init];
        [webView setWebUrl: [ad adUrl]];
        [webView setTopBarTitle: [ad adTitle]];
        [xDelegate.navigationController pushViewController: webView animated: YES];
    }
}
@end
