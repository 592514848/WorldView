//
//  HomePageLocationView.m
//  WorldView
//
//  Created by XZJ on 10/30/15.
//  Copyright © 2015 XZJ. All rights reserved.
//
#define LINE_HEIGHT 60.0f
#define CELL_HEIGHT 105.0F
#define NAVIGATIONBAR_HEIGHT 44.0f
#define SELF_ALPHA 0.6f
#import "HomePageLocationView.h"
#import "HP_Locaction_TableViewCell.h"
#import "TravelGroupViewController.h"
@implementation HomePageLocationView

- (id)initWithFrame:(CGRect)frame buttonRect:(CGRect) buttonFrame delegate:(UIViewController<HomePageLocationViewDelegate> *) _delegate dataArray:(NSArray *)dataArray
{
    if(self = [super initWithFrame: frame])
    {
        countryListArray = dataArray;
        xDelegate = _delegate;
        
        ///1.取消按钮
        CGSize curScreenSize = [UIScreen mainScreen].bounds.size;
        CGFloat flow = (curScreenSize.width > 375.0f ? 20.0f : 16.0f);
        UIButton *cancelButton = [[UIButton alloc] initWithFrame: CGRectMake(curScreenSize.width - buttonFrame.size.width - flow, 20.0f + buttonFrame.origin.y, buttonFrame.size.width, buttonFrame.size.height)];
        [cancelButton setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"icon_ball_white" ofType: @"png"]] forState: UIControlStateNormal];
        [cancelButton setContentMode: UIViewContentModeScaleAspectFit];
        [cancelButton setImageEdgeInsets: UIEdgeInsetsMake(12.0f, 12.0f, 12.0f, 12.0f)];
        [cancelButton addTarget: self action: @selector(dismiss) forControlEvents: UIControlEventTouchUpInside];
        [self addSubview: cancelButton];
        ///2.线条
        CGFloat origin_X = buttonFrame.size.width / 2.0f + cancelButton.frame.origin.x;
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
        ///4.内容列表
        mainTableView = [[UITableView alloc] initWithFrame: CGRectMake(5.0f, 5.0f, contentView.frame.size.width - 10.0f, contentView.frame.size.height - 10.0f)];
        [mainTableView setDelegate: self];
        [mainTableView setDataSource: self];
        UIView *footerView = [[UIView alloc] init];
        [footerView setBackgroundColor: [UIColor clearColor]];
        [mainTableView setShowsVerticalScrollIndicator: NO];
        [mainTableView setTableFooterView: footerView];
        [mainTableView setSeparatorStyle: UITableViewCellSeparatorStyleNone];
        [contentView addSubview: mainTableView];
        
        ///5.显示主视图
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
            if([xDelegate respondsToSelector: @selector(homePageLocationView_DidCancelButton)]){
                [xDelegate homePageLocationView_DidCancelButton];
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
        selfAlpha -= 0.1f;
        [self setBackgroundColor: [[UIColor alloc] initWithWhite: 0.3f alpha: selfAlpha]];
    }
    else
    {
        selfAlpha = 0.0f;
        [timer setFireDate: [NSDate distantFuture]];
    }
}

#pragma mark -
#pragma mark tableView委托
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [countryListArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HP_Locaction_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"ListCell"];
    if(!cell){
        cell = [[HP_Locaction_TableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"ListCell" size: CGSizeMake(tableView.frame.size.width, CELL_HEIGHT)];
    }
    CountryClass *country = [countryListArray objectAtIndex: [indexPath section]];
    [cell.defaultImageView setImageWithURL: IMAGE_URL([country imageUrl]) placeholderImage: [UIImage imageNamed: @"default.png"]];
    [cell.defaultLabel setText: [NSString stringWithFormat: @"共有%@位猎人", [country hunterNum]]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section != 0)
        return 5.0f;
    else
        return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor: [UIColor clearColor]];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismiss];
    CountryClass *country = [countryListArray objectAtIndex: [indexPath section]];
    TravelGroupViewController *nextVC = [[TravelGroupViewController alloc] init];
    [nextVC setCountry: country];
    [xDelegate.navigationController pushViewController: nextVC animated: YES];
}

#pragma mark -
#pragma mark 页面空白处点击事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}
@end
