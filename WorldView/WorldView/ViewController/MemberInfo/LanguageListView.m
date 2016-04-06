//
//  LanguageListView.m
//  WorldView
//
//  Created by WorldView on 15/11/21.
//  Copyright © 2015年 XZJ. All rights reserved.
//
#define CELL_HEIGHT 45.0f
#import "LanguageListView.h"
#import "LanguageTableViewCell.h"

@implementation LanguageListView
@synthesize xDelegate;
- (id)initWithFrame:(CGRect)frame dataArray:(NSArray *) _dataArray
{
    self = [super initWithFrame:frame];
    if (self) {
        dataArray = _dataArray;
        selectedArray = [NSMutableArray arrayWithCapacity: [dataArray count]];
        ///1.主视图属性设置
        [self setBackgroundColor: [UIColor whiteColor]];
        [self.layer setShadowOpacity: 0.2f];
        [self.layer setShadowOffset: CGSizeMake(0.0f, -3.0f)];
        applicationClass = [XZJ_ApplicationClass commonApplication];
        ///2.分割线
        UIView *lineView = [[UIView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, frame.size.width, 1.0f)];
        [lineView setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#efefef"]];
        [self addSubview: lineView];
        ///3.关闭按钮
        UIButton *cancelButton = [[UIButton alloc] initWithFrame: CGRectMake(10.0f, 10.0f, 60.0f, 30.0f)];
        [cancelButton setTag: 0];
        [cancelButton setTitle: @"关闭" forState: UIControlStateNormal];
        [cancelButton setBackgroundColor: [UIColor clearColor]];
        [cancelButton.titleLabel setFont: [UIFont systemFontOfSize: 15.0f]];
        [cancelButton addTarget: self action:@selector(buttonClick:) forControlEvents: UIControlEventTouchUpInside];
        [cancelButton setTitleColor: [applicationClass methodOfTurnToUIColor: @"#d52c3d"] forState: UIControlStateNormal];
        [self addSubview: cancelButton];
        ///4.确定按钮
        UIButton *ensureButton = [[UIButton alloc] initWithFrame: CGRectMake(frame.size.width-70.0f, 10.0f, 60.0f, 30.0f)];
        [ensureButton setTag: 1];
        [ensureButton setTitle: @"确定" forState: UIControlStateNormal];
        [ensureButton setBackgroundColor: [UIColor clearColor]];
        [ensureButton.titleLabel setFont: [UIFont systemFontOfSize: 15.0f]];
        [ensureButton addTarget: self action:@selector(buttonClick:) forControlEvents: UIControlEventTouchUpInside];
        [self addSubview: ensureButton];
        [ensureButton setTitleColor: [applicationClass methodOfTurnToUIColor: @"#1da4e8"] forState: UIControlStateNormal];
        ///5.添加横线
        lineView = [[UIView alloc] initWithFrame: CGRectMake(0.0f, 50.0f, frame.size.width, 1.0f)];
        [lineView setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#efefef"]];
        [self addSubview: lineView];
        ///6加载tableView
        CGFloat origin_y = lineView.frame.size.height + lineView.frame.origin.y;
        UIScrollView *mainScrolleView = [[UIScrollView alloc] initWithFrame: CGRectMake(0.0f, origin_y, frame.size.width, frame.size.height - origin_y)];
        [mainScrolleView setShowsVerticalScrollIndicator: NO];
        [self addSubview: mainScrolleView];
        //
        CGFloat size_h = CELL_HEIGHT * [dataArray count];
        UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, size_h)];
        [mainTableView setDelegate: self];
        [mainTableView setDataSource: self];
        [mainTableView setScrollEnabled: NO];
        [mainTableView setSeparatorStyle: UITableViewCellSeparatorStyleNone];
        [mainScrolleView addSubview: mainTableView];
        ///
        [mainScrolleView setContentSize: CGSizeMake(frame.size.width, size_h)];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LanguageTableViewCell *cell = nil;
    if(!cell){
        cell = [[LanguageTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"Cell" size: CGSizeMake(tableView.frame.size.width, CELL_HEIGHT)];
    }
    LanguageClass *language = [dataArray objectAtIndex: [indexPath row]];
    [cell.languageLabel setText: [language languageName]];
    [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LanguageTableViewCell *cell = [tableView cellForRowAtIndexPath: indexPath];
    LanguageClass *language = [dataArray objectAtIndex: [indexPath row]];
    if([selectedArray containsObject: language]){
        [cell setNotSelectStatus];
        [selectedArray removeObject: language];
    }
    else
    {
        [cell setSelectStatus];
        [selectedArray addObject: language];
    }
}

#pragma mark -
- (void)animateDisappear
{
    [UIView animateWithDuration: 0.3f animations: ^{
        [self setFrame: CGRectMake(0.0f, [[UIScreen mainScreen] bounds].size.height, self.frame.size.width, self.frame.size.height)];
    }];
}

#pragma mark -
- (void)animateShow
{
    [UIView animateWithDuration: 0.3f animations: ^{
        [self setFrame: CGRectMake(0.0f, [[UIScreen mainScreen] bounds].size.height / 2.0f, self.frame.size.width, [[UIScreen mainScreen] bounds].size.height / 2.0f)];
    }];
}

#pragma mark -
#pragma mark 按钮点击事件
- (void)buttonClick:(UIButton *) sender
{
    switch ([sender tag]) {
        case 1:
            if([xDelegate respondsToSelector: @selector(languageListView_EnsureClick:)]){
                [xDelegate languageListView_EnsureClick: selectedArray];
            }
            break;
        default:
            break;
    }
    [self animateDisappear];
}
@end
