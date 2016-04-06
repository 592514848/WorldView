//
//  AppointHunterServiceView.m
//  WorldView
//
//  Created by WorldView on 15/11/24.
//  Copyright © 2015年 XZJ. All rights reserved.
//
#define MARGIN_LEFT 15.0F
#import "AppointHunterServiceView.h"

@implementation AppointHunterServiceView
- (id)initWithFrame:(CGRect)frame service:(ServiceClass *) _service
{
    self = [super initWithFrame: frame];
    if(self){
        mainApplication = [XZJ_ApplicationClass commonApplication];
        ///1.主视图
        [self setBackgroundColor: [UIColor whiteColor]];
        [self.layer setShadowOpacity: 0.2f];
        [self.layer setShadowOffset: CGSizeMake(0.0f, 2.0f)];
        
        ///2.标题
        XZJ_CustomLabel *titleLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(MARGIN_LEFT, 0.0f, frame.size.width - MARGIN_LEFT, 60.0f)];
        [titleLabel setText: @"TA还可以带你玩"];
        [titleLabel setTextColor: [mainApplication methodOfTurnToUIColor: @"#0f0f0f"]];
        [titleLabel setTextAlignment: NSTextAlignmentCenter];
        [titleLabel setFont: [UIFont systemFontOfSize: 16.0f]];
        [self addSubview: titleLabel];
        
        ///4.猎人的其它旅游景点
        CGFloat origin_y = titleLabel.frame.size.height + titleLabel.frame.origin.y;
        hunterScrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(30.0f, origin_y, frame.size.width - 60.0f, frame.size.height - origin_y)];
        [hunterScrollView setBackgroundColor: [UIColor clearColor]];
        [hunterScrollView setShowsHorizontalScrollIndicator: NO];
        [hunterScrollView setPagingEnabled: YES];
        [hunterScrollView.layer setMasksToBounds: NO];
        [self addSubview: hunterScrollView];
        //获取数据
        serviceObj = [[ServiceObject alloc] init];
        [serviceObj setXDelegate: self];
        [serviceObj getHunterOtherServiceList: [_service serviceId] memberId: [[_service member] memberId]];
    }
    return self;
}

#pragma mark -
#pragma mark serviceObject的委托
- (void)serviceObject_GetHunterOtherServiceList:(NSArray *)dataArray
{
    serviceArray = dataArray;
    CGFloat size_w = hunterScrollView.frame.size.width;
    for(NSInteger i = 0; i < [serviceArray count]; i++){
        TravelHunterView *hunterView = [[TravelHunterView alloc] initWithFrame: CGRectMake(i * size_w, 0.0f, size_w, hunterScrollView.frame.size.height - 20.0f)];
        [hunterView setBackgroundColor: [UIColor clearColor]];
        ServiceClass *service = [serviceArray objectAtIndex: i];
        [hunterView setPhotoImage: IMAGE_URL([[service member] memberPhoto]) sex: [[service member] memberSex]];
        [hunterView setAppointButtonThemeColorBySex: [[service member] memberSex]];
        [hunterView.localImageView setImageWithURL: IMAGE_URL([service mainImageUrl]) placeholderImage: [UIImage imageNamed: @"default.png"]];
        [hunterView.nameLabel setText: [NSString stringWithFormat: @"by %@ %@", [[service member] nickName_EN], [[service member] nickName]]];
        [hunterView.titleLabel setText: [service serviceTitle]];
        [hunterView.subTitleLabel setText: [[service member] memberSign]];
        [hunterView setPricelText: [NSString stringWithFormat: @"¥ %.2f", [[service unitPrice] doubleValue]]];
        [hunterView.appointNumberLabel setText: [NSString stringWithFormat: @"%ld人参与", [service joinNum]]];
        [hunterView.localLabel setText: [service serviceAddress]];
        [hunterView setStarLevel: [service serivceScore]];
        [hunterView.collectionNumberLabel setText: [[NSNumber numberWithLong: [service collectionNum]] stringValue]];
        [hunterView setIsCollection: [service isCollection]];
        [hunterScrollView addSubview: hunterView];
    }
    [hunterScrollView setContentSize: CGSizeMake(hunterScrollView.frame.size.width * 4.0f, hunterScrollView.frame.size.height)];
    [hunterScrollView setContentOffset: CGPointMake(hunterScrollView.frame.size.width, 0.0f)];
}
@end
