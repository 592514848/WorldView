//
//  TravelTimeTableViewCell.m
//  WorldView
//
//  Created by WorldView on 15/11/28.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import "TravelTimeTableViewCell.h"

@implementation TravelTimeTableViewCell
@synthesize dateLabel, timeLabel, xDelegate;
- (id)initWithStyle:(UITableViewCellStyle) style reuseIdentifier:(NSString *) reuseIdentifier size:(CGSize) _size
{
    self = [super initWithStyle: style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        XZJ_ApplicationClass *applicationClass = [XZJ_ApplicationClass commonApplication];
        [self setSelectionStyle: UITableViewCellSelectionStyleNone];
        CGFloat size_w = _size.width / 3.0f;
        ///1.日期
        dateLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(0.0f, 0.0f, size_w, _size.height)];
        [dateLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#9a9b9c"]];
        [dateLabel setTextAlignment: NSTextAlignmentCenter];
        [dateLabel setFont: [UIFont boldSystemFontOfSize: 13.0f]];
        [self addSubview: dateLabel];
        ///2.时间
        timeLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(size_w, 0.0f, size_w, _size.height)];
        [timeLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#9a9b9c"]];
        [timeLabel setTextAlignment: NSTextAlignmentCenter];
        [timeLabel setFont: [UIFont boldSystemFontOfSize: 13.0f]];
        [self addSubview: timeLabel];
        ///3.删除按钮
        UIButton *deletebutton = [[UIButton alloc] initWithFrame: CGRectMake(2 * size_w + (size_w - _size.height) / 2.0f, 0.0f, _size.height, _size.height)];
        [deletebutton setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"icon_delete" ofType: @"png"]] forState: UIControlStateNormal];
        [deletebutton addTarget: self action: @selector(deleteButtonClick) forControlEvents: UIControlEventTouchUpInside];
        [deletebutton setImageEdgeInsets: UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f)];
        [self addSubview: deletebutton];
    }
    return self;
}

#pragma mark -
#pragma mark 删除按钮点击事件
- (void)deleteButtonClick
{
    if([xDelegate respondsToSelector: @selector(travelTimeTableViewCell_DidDeleteButton:)]){
        [xDelegate travelTimeTableViewCell_DidDeleteButton: self];
    }
}
@end
