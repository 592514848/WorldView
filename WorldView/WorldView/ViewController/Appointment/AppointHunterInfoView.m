//
//  AppointHunterInfoView.m
//  WorldView
//
//  Created by WorldView on 15/11/24.
//  Copyright © 2015年 XZJ. All rights reserved.
//
#define PHOTO_IMAGE_HEIGHT 70.0f
#define MARGIN_LEFT 15.0F
#define TOP_IMAGE_HEIGHT 200.0f
#define MASK_VIEW_HEIGHT 20.0f
#define HUNTER_INFO_HEIGHT 210.0f
#define TAG_IMAGE_HEIGHT 20.0f
#import "AppointHunterInfoView.h"

@implementation AppointHunterInfoView
@synthesize superViewController;
- (id)initWithFrame:(CGRect)frame service:(ServiceClass *) _service
{
    self = [super initWithFrame: frame];
    if(self){
        mainService = _service;
        mainApplication = [XZJ_ApplicationClass commonApplication];
        ///1.顶部视图
        UIImageView *topImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, frame.size.width, TOP_IMAGE_HEIGHT)];
        [topImageView setImageWithURL: IMAGE_URL([_service mainImageUrl]) placeholderImage: [UIImage imageNamed: @"default.png"]];
        [topImageView setContentMode: UIViewContentModeScaleAspectFill];
        [topImageView.layer setMasksToBounds: YES];
        [self addSubview: topImageView];
        ///3.覆盖视图
        UIView *imageMaskView = [[UIView alloc] initWithFrame: CGRectMake(0.0f, TOP_IMAGE_HEIGHT - MASK_VIEW_HEIGHT, topImageView.frame.size.width, MASK_VIEW_HEIGHT)];
        [imageMaskView setBackgroundColor: [[UIColor alloc] initWithWhite: 0.2f alpha: 0.5f]];
        [topImageView addSubview: imageMaskView];
        ///4.定位图标
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame: CGRectMake(20.0f, 5.0f, MASK_VIEW_HEIGHT, MASK_VIEW_HEIGHT - 10.0f)];
        [iconImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"icon_location" ofType: @"png"]]];
        [iconImageView setContentMode: UIViewContentModeScaleAspectFit];
        [imageMaskView addSubview: iconImageView];
        ///5.地点名称
        CGFloat origin_x = iconImageView.frame.size.width +iconImageView.frame.origin.x;
        XZJ_CustomLabel *locationNameLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x, 0.0f, imageMaskView.frame.size.width / 2.0f - origin_x, MASK_VIEW_HEIGHT)];
        [locationNameLabel setTextColor: [UIColor whiteColor]];
        [locationNameLabel setTextAlignment: NSTextAlignmentLeft];
        [locationNameLabel setFont: [UIFont systemFontOfSize: 10.0f]];
        [locationNameLabel setText: [NSString stringWithFormat: @"%@", [mainService serviceAddress]]];
        [imageMaskView addSubview: locationNameLabel];
        ///6.人数图标
        iconImageView = [[UIImageView alloc] initWithFrame: CGRectMake(imageMaskView.frame.size.width * 2.0f / 3.0f, 5.0f, MASK_VIEW_HEIGHT, MASK_VIEW_HEIGHT - 10.0f)];
        [iconImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"icon_person" ofType: @"png"]]];
        [iconImageView setContentMode: UIViewContentModeScaleAspectFit];
        [imageMaskView addSubview: iconImageView];
        ///7.参加的人数
        origin_x = iconImageView.frame.size.width + iconImageView.frame.origin.x;
        XZJ_CustomLabel *joinNumberLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x, 0.0f, imageMaskView.frame.size.width - origin_x - 10.0f, MASK_VIEW_HEIGHT)];
        [joinNumberLabel setTextColor: [UIColor whiteColor]];
        [joinNumberLabel setFont: [UIFont systemFontOfSize: 10.0f]];
        [joinNumberLabel setText: [NSString stringWithFormat: @"已经有%ld人参与",(long)[mainService joinNum]]];
        [imageMaskView addSubview: joinNumberLabel];
        
        ///////8.猎人信息展示
        CGFloat origin_y = TOP_IMAGE_HEIGHT + topImageView.frame.origin.y;
        UIView *hunterBGView = [[UIView alloc] initWithFrame: CGRectMake(0.0f, origin_y, frame.size.width, HUNTER_INFO_HEIGHT)];
        [hunterBGView setBackgroundColor: [UIColor whiteColor]];
        [hunterBGView.layer setShadowOpacity: 0.2f];
        [hunterBGView.layer setShadowOffset: CGSizeMake(0.0f, 3.0f)];
        [self addSubview: hunterBGView];
        ///9.头像
        UIImageView *photoImageView = [[UIImageView alloc] initWithFrame: CGRectMake(MARGIN_LEFT, 10.0f, PHOTO_IMAGE_HEIGHT, PHOTO_IMAGE_HEIGHT)];
        [photoImageView.layer setCornerRadius: PHOTO_IMAGE_HEIGHT / 2.0f];
        if([[[_service member] memberSex] isEqualToString: @"男"])
            [photoImageView.layer setBorderColor: [mainApplication methodOfTurnToUIColor:@"#6fc9e5"].CGColor];
        else
            [photoImageView.layer setBorderColor: [mainApplication methodOfTurnToUIColor:@"#ffcddb"].CGColor];
        [photoImageView.layer setBorderWidth: 2.0f];
        [photoImageView setContentMode: UIViewContentModeScaleAspectFill];
        [photoImageView.layer setMasksToBounds: YES];
        [photoImageView setImageWithURL: IMAGE_URL([[mainService member] memberPhoto]) placeholderImage: [UIImage imageNamed: @"default.png"]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(hunterInfoClick)];
        [photoImageView setUserInteractionEnabled: YES];
        [photoImageView addGestureRecognizer: tap];
        [hunterBGView addSubview: photoImageView];
        ///10.标题
        origin_x = photoImageView.frame.size.width + photoImageView.frame.origin.x+ 10.0f;
        origin_y = photoImageView.frame.origin.y;
        XZJ_CustomLabel *titleLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x, origin_y, frame.size.width - origin_x - MARGIN_LEFT, photoImageView.frame.size.height / 2.0f)];
        [titleLabel setTextColor: [mainApplication methodOfTurnToUIColor: @"#444444"]];
        //    [titleLabel setText: @"我在小船上等你，与你一起感受浪漫威尼斯"];
        [titleLabel setText: [mainService serviceTitle]];
        [titleLabel setFont: [UIFont systemFontOfSize: 14.0f]];
        [titleLabel setLineBreakMode: NSLineBreakByTruncatingTail];
        [titleLabel setNumberOfLines: 2.0f];
        [hunterBGView addSubview: titleLabel];
        ///11.子标题
        origin_y = titleLabel.frame.size.height + titleLabel.frame.origin.y;
        XZJ_CustomLabel *subTitleLabel  =[[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x, origin_y, frame.size.width - origin_x - MARGIN_LEFT, titleLabel.frame.size.height)];
        [subTitleLabel setText: @"水上之都，世界著名历史名城,水天相接别样的夜晚"];
        [subTitleLabel setText: [mainService serviceDescription]];
        [subTitleLabel setLineBreakMode: NSLineBreakByTruncatingTail];
        [subTitleLabel setNumberOfLines: 2];
        [subTitleLabel setFont: [UIFont systemFontOfSize: 11.0f]];
        [subTitleLabel setTextColor: [mainApplication methodOfTurnToUIColor: @"#797979"]];
        [hunterBGView addSubview: subTitleLabel];
        ///12.姓名
        origin_x = photoImageView.frame.origin.x;
        origin_y = photoImageView.frame.size.height + photoImageView.frame.origin.y;
        XZJ_CustomLabel *memberNameLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x, origin_y, photoImageView.frame.size.width, 20.0f)];
        [memberNameLabel setFont: [UIFont systemFontOfSize: 11.0f]];
        [memberNameLabel setTextColor: [mainApplication methodOfTurnToUIColor: @"#888888"]];
        [memberNameLabel setText: @"by michel 曾玲玲"];
        [memberNameLabel setText: [[mainService member] nickName]];
        [memberNameLabel setTextAlignment: NSTextAlignmentCenter];
        [hunterBGView addSubview: memberNameLabel];
        ///13.个人介绍
        origin_x = memberNameLabel.frame.size.width + memberNameLabel.frame.origin.x + 10.0f;
        origin_y = subTitleLabel.frame.size.height + subTitleLabel.frame.origin.y;
        XZJ_CustomLabel *introduceLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x, origin_y, frame.size.width - origin_x, memberNameLabel.frame.size.height)];
        [introduceLabel setTextColor: [mainApplication methodOfTurnToUIColor: @"#c4c4c4"]];
        [introduceLabel setFont: [UIFont systemFontOfSize: 11.0f]];
        //    [introduceLabel setText: @"文职工作，热爱旅行"];
        [introduceLabel setText: [[mainService member] synopsis]];
        [hunterBGView addSubview: introduceLabel];
        ///14.评星
        origin_x = memberNameLabel.frame.origin.x + 10.0f;
        origin_y = memberNameLabel.frame.size.height + memberNameLabel.frame.origin.y;
        CGFloat size_w = (PHOTO_IMAGE_HEIGHT - 20.0f) / 5.0f;
        NSInteger startLevel = [mainService serivceScore];
        for (NSInteger i = 0; i < 5; i++) {
            NSString *imageName = (i < startLevel ? @"star_fill" :@"star_blank");
            UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake(origin_x + i * size_w, origin_y, size_w, size_w)];
            [imageView setContentMode: UIViewContentModeScaleAspectFit];
            [imageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: imageName ofType: @"png"]]];
            [hunterBGView addSubview: imageView];
        }
        ///15.标签
        origin_x = PHOTO_IMAGE_HEIGHT;
        origin_y += size_w + 30.0f;
        size_w = (frame.size.width - 2 * PHOTO_IMAGE_HEIGHT) / 3.0f;
        for(NSInteger i = 0; i < 3; i++){
            ///标签图标
            UIImageView *tagImageView = [[UIImageView alloc] initWithFrame: CGRectMake(origin_x + i * size_w, origin_y, size_w, TAG_IMAGE_HEIGHT)];
            [tagImageView setContentMode: UIViewContentModeScaleAspectFit];
            [hunterBGView addSubview: tagImageView];
            ///标签说明
            XZJ_CustomLabel *tagLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(tagImageView.frame.origin.x, tagImageView.frame.size.height + tagImageView.frame.origin.y, tagImageView.frame.size.width, 20.0f)];
            [tagLabel setTextAlignment: NSTextAlignmentCenter];
            [tagLabel setTextColor: [mainApplication methodOfTurnToUIColor: @"#929292"]];
            [tagLabel setFont: [UIFont systemFontOfSize: 10.0f]];
            [hunterBGView addSubview: tagLabel];
            switch (i) {
                case 0:
                    [tagImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"icon_time" ofType: @"png"]]];
                    [tagLabel setText: @"2-3小时"];
                    break;
                case 1:
                    [tagImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"icon_persons" ofType: @"png"]]];
                    [tagLabel setText: @"1-6人"];
                    break;
                case 2:
                    [tagImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"icon_language" ofType: @"png"]]];
                    [tagLabel setText: @"中文、英文"];
                    break;
                default:
                    break;
            }
        }
    }
    return self;
}

#pragma mark -
#pragma mark 点击猎人头像
- (void)hunterInfoClick
{
    HunterInfoViewController *infoVC = [[HunterInfoViewController alloc] init];
    [infoVC setHunterId: [[mainService member] memberId]];
    [infoVC setMainService: mainService];
    [superViewController.navigationController pushViewController: infoVC animated: YES];
}
@end
