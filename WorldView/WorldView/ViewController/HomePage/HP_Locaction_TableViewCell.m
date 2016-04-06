//
//  HP_Locaction_TableViewCell.m
//  WorldView
//
//  Created by XZJ on 10/30/15.
//  Copyright © 2015 XZJ. All rights reserved.
//
#define BASE_HEIGHT 15.0F
#import "HP_Locaction_TableViewCell.h"

@implementation HP_Locaction_TableViewCell
@synthesize defaultImageView, defaultLabel;
- (id)initWithStyle:(UITableViewCellStyle) style reuseIdentifier:(NSString *) reuseIdentifier size:(CGSize) _size
{
    self = [super initWithStyle: style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        ///1.图片
        defaultImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, _size.width, _size.height)];
        [defaultImageView setContentMode: UIViewContentModeScaleAspectFill];
        [defaultImageView.layer setMasksToBounds: YES];
        [self addSubview: defaultImageView];
        ///2.图标
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame: CGRectMake(10.0f, _size.height - BASE_HEIGHT - 5.0f, BASE_HEIGHT, BASE_HEIGHT)];
        [iconImageView setContentMode: UIViewContentModeScaleAspectFit];
        [iconImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"icon_person" ofType: @"png"]]];
        [self addSubview: iconImageView];
        ///3.人数
        CGFloat origin_x = iconImageView.frame.size.width + iconImageView.frame.origin.x + 5.0f;
        defaultLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x, iconImageView.frame.origin.y, _size.width - 2 * origin_x, BASE_HEIGHT)];
        [defaultLabel setTextColor: [UIColor whiteColor]];
        [defaultLabel setTextAlignment: NSTextAlignmentLeft];
        [defaultLabel setFont: [UIFont boldSystemFontOfSize: 11.0f]];
        [self addSubview: defaultLabel];
    }
    return self;
}
@end
