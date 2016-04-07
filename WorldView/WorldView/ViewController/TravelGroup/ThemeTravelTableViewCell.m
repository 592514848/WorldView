//
//  ThemeTravelTableViewCell.m
//  WorldView
//
//  Created by XZJ on 11/3/15.
//  Copyright © 2015 XZJ. All rights reserved.
//
#define DOUBLE_PASER_TOSTRING(VALUE) [NSString stringWithFormat: @"%.2f", [VALUE doubleValue]]
#define LONG_PASER_TOSTRING(VALUE) [NSString stringWithFormat: @"%lld", [VALUE longLongValue]]
#define DISPLAY_VIEW_HEIGHT 40.0F
#define CH_NAME_HEIGHT 20.0F
#define EN_NAME_HEIGHT 40.0F
#import "ThemeTravelTableViewCell.h"
#import "TravelHunterView.h"

@implementation ThemeTravelTableViewCell
@synthesize mainImageView, ch_localNameLabel, en_localNameLabel;
- (id)initWithStyle:(UITableViewCellStyle) style reuseIdentifier:(NSString *) reuseIdentifier size:(CGSize) _size
{
    self = [super initWithStyle: style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        applicationClass = [XZJ_ApplicationClass commonApplication];
        ////1.主滚动视图
        mainScrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, _size.width, _size.height)];
        [mainScrollView setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#f0f0f1"]];
        [mainScrollView setPagingEnabled: YES];
        [mainScrollView setShowsHorizontalScrollIndicator: NO];
        [self addSubview: mainScrollView];
        
        ////2.主图片
        mainImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, _size.width, _size.height)];
        [mainImageView setContentMode: UIViewContentModeScaleAspectFill];
        [mainImageView.layer setMasksToBounds: YES];
        [mainScrollView addSubview: mainImageView];
        
        ////3.人头像主展示视图
        displayView = [[UIView alloc] initWithFrame: CGRectMake(20.0f, mainImageView.frame.size.height - DISPLAY_VIEW_HEIGHT - 10.0f, mainImageView.frame.size.width, DISPLAY_VIEW_HEIGHT)];
        [displayView setBackgroundColor: [UIColor clearColor]];
        [mainImageView addSubview: displayView];
//        ///2.中文地名
//        CGFloat origin_y = (_size.height - EN_NAME_HEIGHT - CH_NAME_HEIGHT) / 2.0f;
//        ch_localNameLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(0.0f, origin_y, _size.width, CH_NAME_HEIGHT)];
//        [ch_localNameLabel setTextColor: [UIColor whiteColor]];
//        [ch_localNameLabel setFont: [UIFont boldSystemFontOfSize: 25.0f]];
//        [ch_localNameLabel setTextAlignment: NSTextAlignmentCenter];
//        [self addSubview: ch_localNameLabel];
//        
//        ///3.英文地名
//        origin_y += CH_NAME_HEIGHT;
//        en_localNameLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(0.0f, origin_y, _size.width, EN_NAME_HEIGHT)];
//        [en_localNameLabel setTextColor: [UIColor whiteColor]];
//        [en_localNameLabel setFont: [UIFont systemFontOfSize: 20.0f]];
//        [en_localNameLabel setTextAlignment: NSTextAlignmentCenter];
//        [self addSubview: en_localNameLabel];
    }
    return self;
}

- (void)updateDisplayView:(NSArray *) _array
{
    ///1.移除原视图中的所有子视图
    for(UIView *view in [displayView subviews]){
        [view removeFromSuperview];
    }
    
    ///2.添加新视图
    UIImageView *lastImageView;
    for(NSInteger i = 0; i < [_array count]; i++){
        UIImageView *tempImageView = [[UIImageView alloc] initWithFrame: CGRectMake(i * (DISPLAY_VIEW_HEIGHT - 10.0f), 0.0f, DISPLAY_VIEW_HEIGHT, DISPLAY_VIEW_HEIGHT)];
        [tempImageView.layer setCornerRadius: DISPLAY_VIEW_HEIGHT / 2.0f];
        [tempImageView.layer setMasksToBounds: YES];
        [tempImageView.layer setShadowOpacity: 0.2f];
        [tempImageView.layer setShadowOffset: CGSizeMake(0.0f, 1.0f)];
        MemberObject *member = [_array objectAtIndex: i];
        [tempImageView setImageWithURL: IMAGE_URL([member memberPhoto]) placeholderImage: [UIImage imageNamed: @"default.png"]];
        if(lastImageView){
            [displayView insertSubview: tempImageView belowSubview: lastImageView];
        }
        else{
            [displayView addSubview: tempImageView];
        }
        lastImageView = tempImageView;
    }
}

- (void)updateMainScrollView:(NSArray *) _array
{
    for(NSInteger i = 0; i < [_array count]; i++){
        TravelHunterView *hunterView = [[TravelHunterView alloc] initWithFrame: CGRectMake((i + 1) * mainScrollView.frame.size.width, 0.0f, mainScrollView.frame.size.width, mainScrollView.frame.size.height)];
        [hunterView setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#f0f0f1"]];
        
        ServiceClass *service = [_array objectAtIndex: i];
        NSString *sex = ([[[service member] memberSex] integerValue] == 1 ? @"男" : @"女");
        [hunterView setPhotoImage: [NSURL URLWithString: [[service member] memberPhoto]] sex: sex];
        [hunterView setAppointButtonThemeColorBySex: sex];
        [hunterView.localImageView setImageWithURL: [NSURL URLWithString: [service mainImageUrl]] placeholderImage: [UIImage imageNamed: @"default.png"]];
        [hunterView.nameLabel setText: [[service member] nickName]];
        [hunterView.titleLabel setText: [service serviceTitle]];
        [hunterView.subTitleLabel setText: @"自由职业，摄影爱好者"];
        [hunterView setPricelText: [NSString stringWithFormat: @"¥ %@", DOUBLE_PASER_TOSTRING([service unitPrice])]];
        [hunterView.appointNumberLabel setText: [NSString stringWithFormat: @"%ld人参与", [service joinNum]]];
        [hunterView.localLabel setText:[service serviceAddress]];
        [hunterView setStarLevel: [service serivceScore]];
        [hunterView.collectionNumberLabel setText: [[NSNumber numberWithLong: [service collectionNum]] stringValue]];
        [hunterView setIsCollection: [service isCollection]];
        [mainScrollView addSubview: hunterView];
    }
    [mainScrollView setContentSize: CGSizeMake(mainScrollView.frame.size.width * ([_array  count]+ 1), self.frame.size.height)];
}
@end
