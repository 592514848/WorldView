//
//  HomaPageMainTableViewCell.m
//  WorldView
//
//  Created by XZJ on 11/3/15.
//  Copyright © 2015 XZJ. All rights reserved.
//
#define CH_NAME_HEIGHT 20.0F
#define EN_NAME_HEIGHT 40.0F
#import "HomePageMainTableViewCell.h"

@implementation HomePageMainTableViewCell
@synthesize mainImageView, ch_localNameLabel, en_localNameLabel;
- (id)initWithStyle:(UITableViewCellStyle) style reuseIdentifier:(NSString *) reuseIdentifier size:(CGSize) _size
{
    self = [super initWithStyle: style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        ///1.主图片
        mainImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, _size.width, _size.height)];
        [mainImageView setContentMode: UIViewContentModeScaleAspectFill];
        [mainImageView.layer setMasksToBounds: YES];
        [self addSubview: mainImageView];
        
        ///2.中文地名
        CGFloat origin_y = (_size.height - EN_NAME_HEIGHT - CH_NAME_HEIGHT) / 2.0f;
        ch_localNameLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(0.0f, origin_y, _size.width, CH_NAME_HEIGHT)];
        [ch_localNameLabel setTextColor: [UIColor whiteColor]];
        [ch_localNameLabel setFont: [UIFont boldSystemFontOfSize: 25.0f]];
        [ch_localNameLabel setTextAlignment: NSTextAlignmentCenter];
        [self addSubview: ch_localNameLabel];
        
        ///3.英文地名
        origin_y += CH_NAME_HEIGHT;
        en_localNameLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(0.0f, origin_y, _size.width, EN_NAME_HEIGHT)];
        [en_localNameLabel setTextColor: [UIColor whiteColor]];
        [en_localNameLabel setFont: [UIFont systemFontOfSize: 20.0f]];
        [en_localNameLabel setTextAlignment: NSTextAlignmentCenter];
        [self addSubview: en_localNameLabel];
    }
    return self;
}
@end
