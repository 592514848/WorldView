//
//  WishListTableViewCell.m
//  WorldView
//
//  Created by XZJ on 11/2/15.
//  Copyright © 2015 XZJ. All rights reserved.
//
#define DISPLAY_VIEW_HEIGHT 80.0F
#define PHOTO_VIEW_HEIGHT 60.0F
#define PRICE_LABEL_WIDTH 80.0F
#define BUTTON_WIDTH 80.0F
#define TITLE_VIEW_HEIGHT 40.0F
#define TIP_VIEW_WIDTH 40.0F
#import "WishListTableViewCell.h"

@implementation WishListTableViewCell
@synthesize localImageView, nameLabel, titleLabel, subTitleLabel, appointNumberLabel, priceLabel, localLabel,collectionNumberLabel,xDelegate;
- (id)initWithStyle:(UITableViewCellStyle) style reuseIdentifier:(NSString *) reuseIdentifier size:(CGSize) _size
{
    self = [super initWithStyle: style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        applicationClass = [XZJ_ApplicationClass commonApplication];
        [self setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#f0f0f1"]];
        ///1.主视图
        CGFloat origin_x = 10.0f, origin_y = 10.0f;
        UIView *mainView = [[UIView alloc] initWithFrame: CGRectMake(origin_x, origin_y, _size.width - 2.0f * origin_x, _size.height - 2.0f * origin_y)];
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
        
        ///8.价格
        origin_x = localImageView.frame.size.width - PRICE_LABEL_WIDTH;
        origin_y = localImageView.frame.size.height - alphaView.frame.size.height - 50.0F;
        priceLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x, origin_y, PRICE_LABEL_WIDTH, 40.0f)];
        [priceLabel setBackgroundColor: [[UIColor alloc] initWithWhite: 0.3f alpha: 0.3f]];
        [priceLabel setTextColor: [UIColor whiteColor]];
        [priceLabel setTextAlignment: NSTextAlignmentCenter];
        [localImageView addSubview: priceLabel];
        
        ///9.标题
        origin_y = localImageView.frame.size.height + localImageView.frame.origin.y;
        origin_x = photoImageView.frame.size.width + photoImageView.frame.origin.x + 5.0f;
        titleLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x, origin_y, mainView.frame.size.width - origin_x - BUTTON_WIDTH, TITLE_VIEW_HEIGHT)];
        [titleLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#3a3c3c"]];
        [titleLabel setFont: [UIFont systemFontOfSize: 14.0f]];
        [titleLabel setNumberOfLines: 2];
        [titleLabel setLineBreakMode: NSLineBreakByCharWrapping];
        [mainView addSubview: titleLabel];
        
        ///10.预约按钮
        origin_x = titleLabel.frame.size.width + titleLabel.frame.origin.x + 15.0f;
        appointButton = [[UIButton alloc] initWithFrame: CGRectMake(origin_x, origin_y + 5.0f, BUTTON_WIDTH - 20.0f, TITLE_VIEW_HEIGHT - 10.0f)];
        [appointButton.layer setBorderWidth: 1.5f];
        [appointButton setTitle: @"约TA" forState:UIControlStateNormal];
        [appointButton.titleLabel setFont: [UIFont systemFontOfSize: 16.0f]];
        [appointButton addTarget: self action: @selector(appointButtonClick:) forControlEvents: UIControlEventTouchUpInside];
        [mainView addSubview: appointButton];
        
        origin_y = titleLabel.frame.size.height + titleLabel.frame.origin.y;
        CGFloat size_h = DISPLAY_VIEW_HEIGHT - titleLabel.frame.size.height - 10.0f;
        ///11.评星
        origin_x = photoImageView.frame.origin.x;
        size_w = photoImageView.frame.size.width / 5.0f;
        starImageViewArray = [[NSMutableArray alloc] initWithCapacity: 5];
        starDisplayView = [[UIView alloc] initWithFrame: CGRectMake(origin_x, origin_y, photoImageView.frame.size.width, size_h)];
        [mainView addSubview: starDisplayView];
        for(NSInteger i = 0; i < 5; i++){
            UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake(i * size_w, 0.0f, size_w, size_h)];
            [imageView setContentMode: UIViewContentModeScaleAspectFit];
            [starDisplayView addSubview: imageView];
            [starImageViewArray addObject: imageView];
        }
        
        ///12.子标题
        origin_x = starDisplayView.frame.size.width + starDisplayView.frame.origin.x + 5.0f;
        subTitleLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x, origin_y, titleLabel.frame.size.width, size_h)];
        [subTitleLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#bcbebe"]];
        [subTitleLabel setFont: [UIFont systemFontOfSize: 10.0f]];
        [mainView addSubview: subTitleLabel];
        
        ///13.预约人数图标
        origin_x = appointButton.frame.origin.x;
        UIImageView *appointIconImageView = [[UIImageView alloc] initWithFrame: CGRectMake(origin_x, origin_y, size_w, size_h)];
        [appointIconImageView setContentMode: UIViewContentModeScaleAspectFit];
        [appointIconImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"numbers" ofType: @"png"]]];
        [appointIconImageView.layer setMasksToBounds: YES];
        [mainView addSubview: appointIconImageView];
        
        ///14.预约的人数
        origin_x = appointIconImageView.frame.size.width + appointIconImageView.frame.origin.x;
        appointNumberLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x, origin_y, mainView.frame.size.width - origin_x - 10.0f, size_h)];
        [appointNumberLabel setFont: [UIFont systemFontOfSize: 10.0f]];
//        [appointNumberLabel setAdjustsFontSizeToFitWidth: YES];
        [appointNumberLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#bcbebe"]];
        [mainView addSubview: appointNumberLabel];
        
        ///标签
        UIImageView *tipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_size.width - 70.0f, 5.0f, TIP_VIEW_WIDTH, TIP_VIEW_WIDTH * 1.5f)];
        [tipImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"tip_bg" ofType: @"png"]]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(collectionButtonClick)];
        [tap setCancelsTouchesInView: NO];
        [tipImageView setUserInteractionEnabled: YES];
        [tipImageView addGestureRecognizer: tap];
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
        collectionImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0.0f, origin_y, TIP_VIEW_WIDTH, tipImageView.frame.size.height - origin_y - 5.0f)];
        [collectionImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"collection_no" ofType: @"png"]]];
        [collectionImageView setContentMode: UIViewContentModeScaleAspectFit];
        [tipImageView addSubview: collectionImageView];
    }
    return self;
}

#pragma mark 设置头像
- (void)setPhotoImage:(NSURL *)imageUrl sex:(NSInteger) _sex
{
    [photoImageView setImageWithURL: imageUrl placeholderImage: [UIImage imageNamed: @"default.png"]];
    if(_sex == 0){
        ///男生
        [photoImageView.layer setBorderColor: [applicationClass methodOfTurnToUIColor: @"#94e5f8"].CGColor];
    }
    else{
        ///女生
        [photoImageView.layer setBorderColor: [applicationClass methodOfTurnToUIColor: @"#fbd0db"].CGColor];
    }
}

#pragma mark 设置预约按钮
- (void)setAppointButtonThemeColorBySex: (NSInteger) _sex
{
    if(_sex == 0){
        ///男生
        [appointButton.layer setBorderColor: [applicationClass methodOfTurnToUIColor: @"#94e5f8"].CGColor];
        [appointButton setTitleColor: [applicationClass methodOfTurnToUIColor: @"#94e5f8"] forState: UIControlStateNormal];
    }
    else{
        ///女生
        [appointButton.layer setBorderColor: [applicationClass methodOfTurnToUIColor: @"#fbd0db"].CGColor];
        [appointButton setTitleColor: [applicationClass methodOfTurnToUIColor: @"#fbd0db"] forState: UIControlStateNormal];
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

#pragma mark 设置价格
- (void)setPricelText:(NSString *)price
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString: price];
    [attributeString addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize: 13.0f] range: NSMakeRange(0, 1)];
    [attributeString addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize: 20.0f] range: NSMakeRange(1, [price length] - 1)];
    [priceLabel setAttributedText: attributeString];
}

#pragma mark 按钮点击事件
- (void)appointButtonClick:(UIButton *)button
{
    if([xDelegate respondsToSelector: @selector(wishListTableViewCell_DidButtonClick: tableViewCell:)]){
        [xDelegate wishListTableViewCell_DidButtonClick: button tableViewCell: self];
    }
}

- (void)collectionButtonClick
{
    if([xDelegate respondsToSelector: @selector(wishListTableViewCell_DidCollectionClick:)]){
        [xDelegate wishListTableViewCell_DidCollectionClick: self];
    }
}

#pragma mark 是否收藏
- (void)setIsCollection:(BOOL) isCollection
{
    NSString *imagePath = (isCollection ? @"collection_yes" : @"collection_no");
    [collectionImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: imagePath ofType: @"png"]]];
}
@end
