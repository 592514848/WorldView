//
//  PublishedJourneyTableViewCell.m
//  WorldView
//
//  Created by XZJ on 11/3/15.
//  Copyright © 2015 XZJ. All rights reserved.
//
#define DISPLAY_VIEW_HEIGHT 100.0F
#define PHOTO_VIEW_HEIGHT 60.0F
#define PRICE_LABEL_WIDTH 80.0F
#define BUTTON_WIDTH 80.0F
#define TITLE_VIEW_HEIGHT 40.0F
#define TIP_VIEW_WIDTH 40.0F
#import "PublishedJourneyTableViewCell.h"

@implementation PublishedJourneyTableViewCell
@synthesize localImageView, nameLabel, titleLabel, appointNumberLabel, localLabel,collectionNumberLabel,xDelegate;
- (id)initWithStyle:(UITableViewCellStyle) style reuseIdentifier:(NSString *) reuseIdentifier size:(CGSize) _size
{
    self = [super initWithStyle: style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        applicationClass = [XZJ_ApplicationClass commonApplication];
        [self setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#f0f0f1"]];
        ///1.主视图
        CGFloat origin_x = 10.0f, origin_y = 10.0f;
        mainView = [[UIView alloc] initWithFrame: CGRectMake(origin_x, origin_y, _size.width - 2.0f * origin_x, _size.height - 2.0f * origin_y)];
        [mainView setBackgroundColor: [UIColor whiteColor]];
        [mainView.layer setShadowOpacity: 0.2f];
        [mainView.layer setShadowOffset: CGSizeMake(0.0f, 3.0f)];
        [self addSubview: mainView];
        
        ///2.地区背景图片
        origin_x = origin_y = 5.0f;
        localImageView = [[UIImageView alloc] initWithFrame: CGRectMake(origin_x, origin_y, mainView.frame.size.width - 2 * origin_x, mainView.frame.size.height - DISPLAY_VIEW_HEIGHT)];
        [localImageView.layer setMasksToBounds: YES];
        [localImageView setContentMode: UIViewContentModeScaleAspectFill];
        [mainView addSubview: localImageView];
        
        ///3.透明图层
        UIView *alphaView = [[UIView alloc] initWithFrame: CGRectMake(0.0f, localImageView.frame.size.height - 15.0f, localImageView.frame.size.width, 15.0f)];
        [alphaView setBackgroundColor: [[UIColor alloc] initWithWhite: 0.2f alpha: 0.5f]];
        [localImageView addSubview: alphaView];
        
        ///4.头像
        origin_x = 10.0f;
        origin_y = localImageView.frame.size.height + localImageView.frame.origin.y - PHOTO_VIEW_HEIGHT / 2.0f;
        photoImageView = [[UIImageView alloc] initWithFrame: CGRectMake(origin_x, origin_y, PHOTO_VIEW_HEIGHT, PHOTO_VIEW_HEIGHT)];
        [photoImageView setContentMode: UIViewContentModeScaleAspectFill];
        [photoImageView.layer setMasksToBounds: YES];
        [photoImageView.layer setCornerRadius: photoImageView.frame.size.height / 2.0f];
        [photoImageView.layer setBorderWidth: 1.5f];
        [mainView addSubview: photoImageView];
        
        ///5.姓名
        origin_x = photoImageView.frame.size.width + photoImageView.frame.origin.x + 5.0f;
        CGFloat size_w = (alphaView.frame.size.width - origin_x) / 2.0f - 20.0f;
        nameLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x, 0.0f, size_w, alphaView.frame.size.height)];
        [nameLabel setTextColor: [UIColor whiteColor]];
        [nameLabel setFont: [UIFont fontWithName: @"courier" size: 10.0f]];
        [alphaView addSubview: nameLabel];
        
        ///6.地点图标
        origin_x = nameLabel.frame.size.width + nameLabel.frame.origin.x + 5.0f;
        UIImageView *localIconImageView = [[UIImageView alloc] initWithFrame: CGRectMake(origin_x, 2.0f, alphaView.frame.size.height, alphaView.frame.size.height - 6.0f)];
        [localIconImageView setContentMode: UIViewContentModeScaleAspectFit];
        [localIconImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"icon_location" ofType: @"png"]]];
        [alphaView addSubview: localIconImageView];
        
        ///7.地点名称
        origin_x = localIconImageView.frame.size.width + localIconImageView.frame.origin.x;
        localLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x, 0.0f, alphaView.frame.size.width - origin_x, alphaView.frame.size.height)];
        [localLabel setTextColor: [UIColor whiteColor]];
        [localLabel setFont: [UIFont fontWithName: @"courier" size: 10.0f]];
        [alphaView addSubview: localLabel];
        
        ///9.标题
        origin_y = localImageView.frame.size.height + localImageView.frame.origin.y;
        origin_x = photoImageView.frame.size.width + photoImageView.frame.origin.x + 5.0f;
        titleLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x, origin_y, mainView.frame.size.width - origin_x - BUTTON_WIDTH, TITLE_VIEW_HEIGHT)];
        [titleLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#3a3c3c"]];
        [titleLabel setFont: [UIFont boldSystemFontOfSize: 14.0f]];
        [titleLabel setNumberOfLines: 2];
        [titleLabel setLineBreakMode: NSLineBreakByTruncatingTail];
        [mainView addSubview: titleLabel];
        
        ///11.评星
        origin_y = titleLabel.frame.size.height + titleLabel.frame.origin.y + 10.0f;
        origin_x = photoImageView.frame.origin.x;
         CGFloat size_h = size_w = photoImageView.frame.size.width / 5.0f;
        starImageViewArray = [[NSMutableArray alloc] initWithCapacity: 5];
        starDisplayView = [[UIView alloc] initWithFrame: CGRectMake(origin_x, origin_y, photoImageView.frame.size.width, size_h)];
        [mainView addSubview: starDisplayView];
        for(NSInteger i = 0; i < 5; i++){
            UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake(i * size_w, 0.0f, size_w, size_h)];
            [imageView setContentMode: UIViewContentModeScaleAspectFit];
            [starDisplayView addSubview: imageView];
            [starImageViewArray addObject: imageView];
        }
        
        ///13.预约人数图标
        origin_y = starDisplayView.frame.origin.y + starDisplayView.frame.size.height + 5.0f;
        UIImageView *appointIconImageView = [[UIImageView alloc] initWithFrame: CGRectMake(origin_x, origin_y, size_w, size_h)];
        [appointIconImageView setContentMode: UIViewContentModeScaleAspectFit];
        [appointIconImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"numbers" ofType: @"png"]]];
        [appointIconImageView.layer setMasksToBounds: YES];
        [mainView addSubview: appointIconImageView];
        
        ///14.预约的人数
        origin_x = appointIconImageView.frame.size.width + appointIconImageView.frame.origin.x + 5.0f;
        appointNumberLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x, origin_y,mainView.frame.size.width / 3.0f, size_h)];
        [appointNumberLabel setFont: [UIFont systemFontOfSize: 10.0f]];
        //        [appointNumberLabel setAdjustsFontSizeToFitWidth: YES];
        [appointNumberLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#bcbebe"]];
        [mainView addSubview: appointNumberLabel];
        
        ///标签
        UIImageView *tipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_size.width - 70.0f, 5.0f, TIP_VIEW_WIDTH, TIP_VIEW_WIDTH * 1.5f)];
        [tipImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"tip_bg" ofType: @"png"]]];
        [self addSubview: tipImageView];
        
        ///收藏人数
        collectionNumberLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(0.0f, 10.0f, TIP_VIEW_WIDTH, 25.0f)];
        [collectionNumberLabel setTextColor: [UIColor whiteColor]];
        [collectionNumberLabel setAdjustsFontSizeToFitWidth: YES];
        [collectionNumberLabel setTextAlignment: NSTextAlignmentCenter];
        [collectionNumberLabel setFont: [UIFont systemFontOfSize: 13.0f]];
        [tipImageView addSubview: collectionNumberLabel];
        
        ///收藏图标
        origin_y = collectionNumberLabel.frame.size.height + collectionNumberLabel.frame.origin.y;
        UIImageView *collectionImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0.0f, origin_y, TIP_VIEW_WIDTH, tipImageView.frame.size.height - origin_y - 5.0f)];
        [collectionImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"collection_yes" ofType: @"png"]]];
        [collectionImageView setContentMode: UIViewContentModeScaleAspectFit];
        [tipImageView addSubview: collectionImageView];
        
        ///下架按钮
        origin_x = mainView.frame.size.width / 2.6f;
        origin_y = titleLabel.frame.size.height + titleLabel.frame.origin.y + 10.0f;
        size_h = starDisplayView.frame.size.height + appointNumberLabel.frame.size.height + 5.0f;
        offShelfButton = [[UIButton alloc] initWithFrame: CGRectMake(origin_x, origin_y, BUTTON_WIDTH, size_h)];
        [offShelfButton setTitle: @"下架" forState: UIControlStateNormal];
        [offShelfButton.layer setBorderWidth: 0.5f];
        [offShelfButton.layer setBorderColor: [applicationClass methodOfTurnToUIColor: @"#e55155"].CGColor];
        [offShelfButton.layer setCornerRadius: 3.0f];
        [offShelfButton setTitleColor: [applicationClass methodOfTurnToUIColor: @"#e55155"] forState: UIControlStateNormal];
        [offShelfButton.titleLabel setFont: [UIFont systemFontOfSize: 13.0f]];
        [offShelfButton addTarget: self action: @selector(offShelfButtonClick:) forControlEvents: UIControlEventTouchUpInside];
        [mainView addSubview: offShelfButton];
        
        ///编辑按钮
        origin_x = mainView.frame.size.width - BUTTON_WIDTH - 10.0f;
        editButton = [[UIButton alloc] initWithFrame: CGRectMake(origin_x, origin_y, BUTTON_WIDTH, size_h)];
        [editButton setTitle: @"编辑" forState: UIControlStateNormal];
        [editButton.layer setBorderWidth: 0.5f];
        [editButton.layer setBorderColor: [applicationClass methodOfTurnToUIColor: @"#e55155"].CGColor];
        [editButton.layer setCornerRadius: 3.0f];
        [editButton setTitleColor: [applicationClass methodOfTurnToUIColor: @"#e55155"] forState: UIControlStateNormal];
        [editButton.titleLabel setFont: [UIFont systemFontOfSize: 13.0f]];
        [editButton addTarget: self action: @selector(editButtonClick) forControlEvents: UIControlEventTouchUpInside];
        [mainView addSubview: editButton];

    }
    return self;
}

#pragma mark 根据不同状态显示不同布局
- (void)displayForStatus:(NSString *)status
{
    if([status isEqualToString: @"已下架"])
    {
        ///////////已下架
        ///1.操作按钮
        [offShelfButton setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#88898a"] ];
        [offShelfButton setTag: 1];
        [offShelfButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
        [offShelfButton setTitle: @"已下架" forState: UIControlStateNormal];
        [offShelfButton.layer setBorderWidth: 0.0f];
        ///2.背景
        [mainView setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#e4e5e6"]];
    }
    else
    {
        ///1.操作按钮
        [offShelfButton setBackgroundColor: [UIColor clearColor] ];
        [offShelfButton setTitleColor: [applicationClass methodOfTurnToUIColor: @"#e55155"] forState: UIControlStateNormal];
        [offShelfButton.layer setBorderWidth: 0.5f];
        [offShelfButton.layer setBorderColor: [applicationClass methodOfTurnToUIColor: @"#e77275"].CGColor];
        [offShelfButton setTag: 0];
        [offShelfButton setTitle: @"下架" forState: UIControlStateNormal];
        ///2.背景
        [mainView setBackgroundColor: [UIColor whiteColor]];
    }
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

#pragma mark 设置评星等级
- (void)setStarLevel:(NSInteger)level
{
    for(NSInteger i = 0; i < 5; i++){
        NSString *imageName = (i < level ? @"star_fill" :@"star_blank");
        UIImageView *tempImageView = (UIImageView *)[starImageViewArray objectAtIndex: i];
        [tempImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: imageName ofType: @"png"]]];
    }
}

#pragma mark 下架按钮
- (void)offShelfButtonClick:(UIButton *)sender
{
    if([sender tag] == 0){
        if([xDelegate respondsToSelector: @selector(PublishedJourneyTableViewCell_DidShelOffbuttonClick:)]){
            [xDelegate PublishedJourneyTableViewCell_DidShelOffbuttonClick: self];
        }
    }
}

#pragma mark 编辑按钮
- (void)editButtonClick
{
    if([xDelegate respondsToSelector: @selector(PublishedJourneyTableViewCell_DidEditbuttonClick:)]){
        [xDelegate PublishedJourneyTableViewCell_DidEditbuttonClick: self];
    }
}
@end
