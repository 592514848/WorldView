//
//  AppointRecommonView.m
//  WorldView
//
//  Created by WorldView on 15/11/24.
//  Copyright © 2015年 XZJ. All rights reserved.
//
#define MARGIN_LEFT 15.0F
#import "AppointRecommonView.h"

@implementation AppointRecommonView
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
        titleLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(MARGIN_LEFT, 0.0f, frame.size.width - MARGIN_LEFT, 60.0f)];
        [titleLabel setText: @"推荐其他好玩的"];
        [titleLabel setTextColor: [mainApplication methodOfTurnToUIColor: @"#0f0f0f"]];
        [titleLabel setTextAlignment: NSTextAlignmentCenter];
        [titleLabel setFont: [UIFont systemFontOfSize: 16.0f]];
        [self addSubview: titleLabel];
        
        //获取推荐数据
        serviceObj = [[ServiceObject alloc] init];
        [serviceObj setXDelegate: self];
        [serviceObj getRecommonServiceList: [_service serviceId]];
    }
    return self;
}

#pragma mark -
#pragma mark serviceObject委托
- (void)serviceObject_GetRecommonServiceList:(NSArray *)dataArray
{
    serviceArray = dataArray;
    CGFloat origin_y = titleLabel.frame.size.height + titleLabel.frame.origin.y;
    CGFloat size_h = (self.frame.size.height - origin_y) / 2.0f;
    NSInteger flag = [serviceArray count] > 2 ? 2 : [serviceArray count];
    for(NSInteger i = 0; i < flag; i++){
        TravelHunterView *hunterView = [[TravelHunterView alloc] initWithFrame: CGRectMake(0.0f, origin_y + i * size_h, self.frame.size.width, size_h)];
        [hunterView setBackgroundColor: [UIColor clearColor]];
        ServiceClass *service = [serviceArray objectAtIndex: i];
        [hunterView setPhotoImage: IMAGE_URL([[service member] memberPhoto]) sex: [[service member] memberSex]];
        [hunterView setAppointButtonThemeColorBySex: [[service member] memberSex]];
        [hunterView.localImageView setImageWithURL: IMAGE_URL([service mainImageUrl]) placeholderImage: [UIImage imageNamed: @"default.png"]];
        [hunterView.nameLabel setText: [NSString stringWithFormat: @"by %@ %@", [[service member] nickName_EN], [[service member] nickName]]];
        [hunterView.titleLabel setText: [service serviceTitle]];
        [hunterView.subTitleLabel setText: [[service member] memberSign]];
        [hunterView setPricelText: [NSString stringWithFormat: @"¥ %.2f", [[service unitPrice] doubleValue]]];
        [hunterView.appointNumberLabel setText: [NSString stringWithFormat: @"%ld人参与", (long)[service joinNum]]];
        [hunterView.localLabel setText: [service serviceAddress]];
        [hunterView setStarLevel: [service serivceScore]];
        [hunterView.collectionNumberLabel setText: [[NSNumber numberWithLong: [service collectionNum]] stringValue]];
        [hunterView setIsCollection: [service isCollection]];
        [self addSubview: hunterView];
    }
    if([serviceArray count] == 0){
        [mainApplication methodOfShowTipInView: self text: @"暂无推荐"];
    }
}
@end
