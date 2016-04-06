//
//  HunterMainInfoView.m
//  WorldView
//
//  Created by WorldView on 15/12/3.
//  Copyright © 2015年 XZJ. All rights reserved.
//
#define PHOTO_IMAGE_HEIGHT 70.0f
#define MARGIN_LEFT 15.0F
#define TOP_IMAGE_HEIGHT 150.0f
#define MASK_VIEW_HEIGHT 20.0f
#define TAG_IMAGE_HEIGHT 20.0f
#define IMAGE_SCROLLVIEW_HEIGHT 150.0f
#import "HunterMainInfoView.h"

@implementation HunterMainInfoView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: frame];
    if(self){
        mainApplication = [XZJ_ApplicationClass commonApplication];
        [self setBackgroundColor: [UIColor whiteColor]];
        [self.layer setShadowOffset: CGSizeMake(0.0f, 3.0f)];
        [self.layer setShadowOpacity: 0.3f];
        ///1.顶部背景视图
        topImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, frame.size.width, TOP_IMAGE_HEIGHT)];
        [topImageView setContentMode: UIViewContentModeScaleAspectFill];
        [topImageView.layer setMasksToBounds: YES];
        [topImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"hunter_default_bg" ofType: @"png"]]];
        [self addSubview: topImageView];
        ///2.头像
        photoImageView = [[UIImageView alloc] initWithFrame: CGRectMake((frame.size.width - PHOTO_IMAGE_HEIGHT) / 2.0f, TOP_IMAGE_HEIGHT - (PHOTO_IMAGE_HEIGHT / 2.0f), PHOTO_IMAGE_HEIGHT, PHOTO_IMAGE_HEIGHT)];
        [photoImageView.layer setCornerRadius: PHOTO_IMAGE_HEIGHT / 2.0f];
        [photoImageView setContentMode: UIViewContentModeScaleAspectFill];
        [self addSubview: photoImageView];
        ///3.姓名
        CGFloat origin_y = photoImageView.frame.size.height + photoImageView.frame.origin.y + 5.0f;
        memberNameLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(0.0f, origin_y, frame.size.width, 20.0f)];
        [memberNameLabel setFont: [UIFont systemFontOfSize: 15.0f]];
        [memberNameLabel setTextAlignment: NSTextAlignmentCenter];
        [self addSubview: memberNameLabel];
        ///4.个人签名
        origin_y = memberNameLabel.frame.size.height + memberNameLabel.frame.origin.y;
        introduceLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(0.0f, origin_y, frame.size.width, memberNameLabel.frame.size.height)];
        [introduceLabel setTextColor: [mainApplication methodOfTurnToUIColor: @"#c4c4c4"]];
        [introduceLabel setFont: [UIFont systemFontOfSize: 13.0f]];
        [introduceLabel setTextAlignment: NSTextAlignmentCenter];
        [self addSubview: introduceLabel];
        ///5.分割线
        origin_y = introduceLabel.frame.size.height + introduceLabel.frame.origin.y + 10.0f;
        UIView *lineView = [[UIView alloc] initWithFrame: CGRectMake(40.0f, origin_y, frame.size.width - 80.0f, 1.0f)];
        [lineView setBackgroundColor: [mainApplication methodOfTurnToUIColor: @"#c5c6c6"]];
        [self addSubview: lineView];
        ///6.标签
        CGFloat origin_x = 50.0f;
        origin_y += lineView.frame.size.height + 15.0f;
        CGFloat size_w = (frame.size.width - 2 * origin_x - 40.0f) / 3.0f;
        for(NSInteger i = 0; i < 3; i++){
            ///标签图标
            UIImageView *tagImageView = [[UIImageView alloc] initWithFrame: CGRectMake(origin_x + i * (size_w + 20.0f), origin_y, size_w, TAG_IMAGE_HEIGHT)];
            [tagImageView setContentMode: UIViewContentModeScaleAspectFit];
            [self addSubview: tagImageView];
            ///标签说明
            XZJ_CustomLabel *tagLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(tagImageView.frame.origin.x, tagImageView.frame.size.height + tagImageView.frame.origin.y, tagImageView.frame.size.width, 20.0f)];
            [tagLabel setTextAlignment: NSTextAlignmentCenter];
            [tagLabel setTextColor: [mainApplication methodOfTurnToUIColor: @"#929292"]];
            [tagLabel setFont: [UIFont systemFontOfSize: 10.0f]];
            [self addSubview: tagLabel];
            switch (i) {
                case 0:
                    [tagImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"icon_navigation" ofType: @"png"]]];
                    [tagLabel setText: @"2-3小时"];
                    break;
                case 1:
                    [tagImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"icon_profession" ofType: @"png"]]];
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
        ///关于我
        origin_y += TAG_IMAGE_HEIGHT * 2.0f + 25.0f;
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame: CGRectMake(lineView.frame.origin.x, origin_y, lineView.frame.size.width, 15.0f)];
        [lineImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"about_me" ofType: @"png"]]];
        [lineImageView setContentMode: UIViewContentModeScaleAspectFit];
        [self addSubview: lineImageView];
        ///猎人图片
        origin_y += lineImageView.frame.size.height + 15.0f;
        intriduceImageScrollView = [[XZJ_ImagesScrollView alloc] initWith: CGRectMake(0.0f, origin_y, frame.size.width, IMAGE_SCROLLVIEW_HEIGHT) ImagesArray: nil TitleArray: nil isURL: YES];
        [intriduceImageScrollView.noteView setHidden: YES];
        [self addSubview: intriduceImageScrollView];
        ///猎人介绍
        origin_y += IMAGE_SCROLLVIEW_HEIGHT;
        contentLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(10.0f, origin_y, frame.size.width - 20.0f, frame.size.height - origin_y)];
        [contentLabel setNumberOfLines: 0];
        [contentLabel setLineBreakMode: NSLineBreakByTruncatingTail];
        [contentLabel setFont: [UIFont systemFontOfSize: 14.0f]];
        [contentLabel setTextColor: [mainApplication methodOfTurnToUIColor: @"#7c7d7e"]];
        [self addSubview: contentLabel];
    }
    return self;
}

#pragma mark -
#pragma mark 更新数据
- (void)updateMainView:(MemberObject *) memberObj
{
    ///头像
    [photoImageView.layer setBorderWidth: 2.0f];
    [photoImageView.layer setMasksToBounds: YES];
    if([[memberObj memberSex] longLongValue] == 0){
        [photoImageView.layer setBorderColor: [mainApplication methodOfTurnToUIColor:@"#6fc9e5"].CGColor];
    }
    else{
        [photoImageView.layer setBorderColor: [mainApplication methodOfTurnToUIColor:@"#ffcddb"].CGColor];
    }
    [photoImageView setImageWithURL: IMAGE_URL([memberObj memberPhoto]) placeholderImage: [UIImage imageNamed: @"default.png"]];
    ///会员姓名
    [memberNameLabel setText: [NSString stringWithFormat: @"%@ %@",[memberObj nickName_EN], [memberObj nickName]]];
    ///个人签名
    [introduceLabel setText: [memberObj memberSign]];
    ///关于我
    NSArray *aboutImageUrl = [[memberObj aboutMeImgUrl] componentsSeparatedByString: @","];
    NSMutableArray *imagesArray = [NSMutableArray array];
    for(NSInteger i = 0; i < 3; i++){
        if([[aboutImageUrl objectAtIndex: i] length] > 0){
            [imagesArray addObject: IMAGE_URL([aboutImageUrl objectAtIndex: i])];
        }
    }
    [intriduceImageScrollView setImageWithURLArray: imagesArray];
    ///猎人介绍
    [contentLabel setText: [memberObj  aboutMeImgDesc]];
    
}
@end
