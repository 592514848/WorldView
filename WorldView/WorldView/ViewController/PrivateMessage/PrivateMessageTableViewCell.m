//
//  PrivateMessageTableViewCell.m
//  WorldView
//
//  Created by XZJ on 11/2/15.
//  Copyright © 2015 XZJ. All rights reserved.
//

#import "PrivateMessageTableViewCell.h"

@implementation PrivateMessageTableViewCell
@synthesize nameLabel, contentLabel, titleLabel, timeLabel;
- (id)initWithStyle:(UITableViewCellStyle) style reuseIdentifier:(NSString *) reuseIdentifier size:(CGSize) _size
{
    self = [super initWithStyle: style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        applicationClass = [XZJ_ApplicationClass commonApplication];
        [self.layer setShadowOpacity: 0.1f];
        [self.layer setShadowOffset: CGSizeMake(0.0f, 2.0f)];
        
        readView = [[UIView alloc] initWithFrame: CGRectMake(5.0f, (_size.height - 5.0f) / 2.0f, 5.0f, 5.0f)];
        [readView setBackgroundColor: [UIColor redColor]];
        [readView.layer setCornerRadius: readView.frame.size.height / 2.0f];
        [readView setHidden: YES];
        [self addSubview: readView];
        
        ///1.头像
        CGFloat origin_x = 20.0f;
        photoImageView = [[UIImageView alloc] initWithFrame: CGRectMake(15.0f, origin_x, _size.height - 40.0f, _size.height - 40.0f)];
        [photoImageView setContentMode: UIViewContentModeScaleAspectFill];
        [photoImageView.layer setMasksToBounds: YES];
        [photoImageView.layer setCornerRadius: photoImageView.frame.size.height / 2.0f];
        [photoImageView.layer setBorderWidth: 1.5f];
        [self addSubview: photoImageView];
        
        ///2.姓名
        CGFloat origin_y = 20.0f;
        origin_x = photoImageView.frame.size.width + photoImageView.frame.origin.x + 10.0f;
        nameLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x, 10.0f, (_size.width - origin_x) * 2.0f / 3.0f, 20.0f)];
        [nameLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#3a3b3c"]];
        [nameLabel setFont: [UIFont systemFontOfSize: 13.0f]];
        [self addSubview: nameLabel];
        
        ///3.时间
        origin_x += nameLabel.frame.size.width + 5.0f;
        timeLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x, nameLabel.frame.origin.y, _size.width - origin_x - 15.0f, 20.0f)];
        [timeLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#c6c7c7"]];
        [timeLabel setTextAlignment: NSTextAlignmentRight];
        [timeLabel setFont: [UIFont systemFontOfSize: 12.0f]];
        [self addSubview: timeLabel];
        
        ///4.内容
        origin_y = nameLabel.frame.size.height + nameLabel.frame.origin.y;
        origin_x = photoImageView.frame.size.width + photoImageView.frame.origin.x + 10.0f;
        contentLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x, origin_y, _size.width - origin_x - 10.0f, _size.height - 50.0f)];
        [contentLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#3a3b3c"]];
        [contentLabel setFont: [UIFont systemFontOfSize: 13.0f]];
        [contentLabel setNumberOfLines: 0];
        [contentLabel setLineBreakMode: NSLineBreakByCharWrapping];
        [self addSubview: contentLabel];
        
        ///5.图标
        origin_y += contentLabel.frame.size.height;
        CGFloat size_h = _size.height - origin_y - 10.0f;
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame: CGRectMake(origin_x, origin_y, size_h, size_h)];
        [iconImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"icon_link" ofType: @"png"]]];
        [iconImageView setContentMode: UIViewContentModeScaleAspectFit];
        [self addSubview: iconImageView];
        
        ///标题
        origin_x = iconImageView.frame.size.width + iconImageView.frame.origin.x + 5.0f;
        titleLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x, origin_y, _size.width - origin_x - 10.0f, size_h)];
        [titleLabel setFont: [UIFont systemFontOfSize: 12.0f]];
        [titleLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#b3b4b5"]];
        [self addSubview: titleLabel];
    }
    return self;
}

#pragma mark 设置头像
- (void)setPhotoImage:(NSURL *)imageUrl sex:(NSString *)_sex
{
    [photoImageView setImageWithURL: imageUrl placeholderImage: [UIImage imageNamed: @"default.png"]];
    if([_sex isEqualToString: @"男"]){
        ///男生
        [photoImageView.layer setBorderColor: [applicationClass methodOfTurnToUIColor: @"#94e5f8"].CGColor];
    }
    else{
        ///女生
        [photoImageView.layer setBorderColor: [applicationClass methodOfTurnToUIColor: @"#fbd0db"].CGColor];
    }
}

#pragma mark 设置时间间隔
- (void)setTimeSpan:(NSDate *) time
{
    if(time){
        NSTimeInterval timeSpan = [[NSDate date] timeIntervalSinceDate: time];
        if(timeSpan < 60){
            [timeLabel setText: @"刚刚"];
        }
        else if(timeSpan / 60 < 60){
            [timeLabel setText: [NSString stringWithFormat: @"%ld分钟前", (long)timeSpan / 60]];
        }
        else if(timeSpan / 3600 < 24){
            [timeLabel setText: [NSString stringWithFormat: @"%ld小时前", (long)timeSpan / 3600]];
        }
        else if(timeSpan / 3600 / 24 < 365){
            [timeLabel setText: [NSString stringWithFormat: @"%ld天前", (long)timeSpan / 3600 / 24]];
        }
        else{
            [timeLabel setText: [NSString stringWithFormat: @"%ld天前", (long)timeSpan / 3600 / 24 / 365]];
        }
    }
}

- (void)setReadStatus:(BOOL) isRead
{
    [readView setHidden: isRead];
}
@end
