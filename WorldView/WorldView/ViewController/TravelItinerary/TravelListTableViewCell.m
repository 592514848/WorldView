//
//  TravelListTableViewCell.m
//  WorldView
//
//  Created by XZJ on 10/31/15.
//  Copyright © 2015 XZJ. All rights reserved.
//

#import "TravelListTableViewCell.h"

@implementation TravelListTableViewCell
@synthesize nameLabel, titleLabel, subTitleLabel, priceLabel, xDelegate;
- (id)initWithStyle:(UITableViewCellStyle) style reuseIdentifier:(NSString *) reuseIdentifier size:(CGSize) _size
{
    self = [super initWithStyle: style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        applicationClass = [XZJ_ApplicationClass commonApplication];
        [self.layer setBorderWidth: 0.5f];
        [self.layer setBorderColor: [applicationClass methodOfTurnToUIColor: @"#c7c7c8"].CGColor];
        [self.layer setShadowOpacity: 0.1f];
        [self.layer setShadowOffset: CGSizeMake(0.0f, 2.0f)];
        ///1.支付状态
        statusImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, _size.height / 3.0f, _size.height / 3.0f)];
        [statusImageView.layer setMasksToBounds: YES];
        [self addSubview: statusImageView];
        
        ///2.头像
        CGFloat origin_x = statusImageView.frame.size.width / 2.0f;
        photoImageView = [[UIImageView alloc] initWithFrame: CGRectMake(origin_x, origin_x, _size.height / 2.0f, _size.height / 2.0f)];
        [photoImageView setContentMode: UIViewContentModeScaleAspectFill];
        [photoImageView.layer setMasksToBounds: YES];
        [photoImageView.layer setCornerRadius: photoImageView.frame.size.height / 2.0f];
        [photoImageView.layer setBorderWidth: 1.5f];
        [self addSubview: photoImageView];
        
        ///3.姓名
        CGFloat origin_y = photoImageView.frame.size.height + photoImageView.frame.origin.y + 10.0f;
        nameLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x, origin_y, photoImageView.frame.size.width, 25.0f)];
        [nameLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#4b4c4c"]];
        [nameLabel setTextAlignment: NSTextAlignmentCenter];
        [nameLabel setFont: [UIFont systemFontOfSize: 12.0f]];
        [self addSubview: nameLabel];
        
        ///4.标题
        origin_y = origin_x;
        origin_x = photoImageView.frame.size.width + photoImageView.frame.origin.x + 10.0f;
        titleLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x, origin_y, _size.width - origin_x - 10.0f, 20.0f)];
        [titleLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#313232"]];
        [titleLabel setFont: [UIFont systemFontOfSize: 15.0f]];
        [self addSubview: titleLabel];
        
        ///5.子标题
        origin_y += titleLabel.frame.size.height;
        subTitleLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x, origin_y, _size.width - origin_x - 10.0f, 2 * titleLabel.frame.size.height)];
        [subTitleLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#6f7070"]];
        [subTitleLabel setFont: [UIFont systemFontOfSize: 13.0f]];
        [subTitleLabel setNumberOfLines: 2];
        [subTitleLabel setLineBreakMode: NSLineBreakByTruncatingTail];
        [self addSubview: subTitleLabel];
        
        ///6.时间
        origin_y += subTitleLabel.frame.size.height + 10.0f;
        timeLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x, origin_y,(_size.width - origin_x) / 2.0f, 20.0f)];
        [timeLabel setFont: [UIFont systemFontOfSize: 12.0f]];
        [timeLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#ea3940"]];
        [self addSubview: timeLabel];
        
        ///7.价格
        origin_y = subTitleLabel.frame.size.height + subTitleLabel.frame.origin.y;
        origin_x = timeLabel.frame.size.width + timeLabel.frame.origin.x + 5.0f;
        priceLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x, origin_y, _size.width - origin_x - 20.0f, 30.0f)];
        [priceLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#3c3d3e"]];
        [priceLabel setTextAlignment: NSTextAlignmentRight];
        [self addSubview: priceLabel];
        
        ///8.评星
        origin_x = photoImageView.frame.size.width + photoImageView.frame.origin.x + 10.0f;
        origin_y = timeLabel.frame.size.height + timeLabel.frame.origin.y + 10.0f;
        starImageViewArray = [[NSMutableArray alloc] initWithCapacity: 5];
        CGFloat size_w = 15.0f;
        starDisplayView = [[UIView alloc] initWithFrame: CGRectMake(origin_x, origin_y, size_w * 5.0f, size_w)];
        [self addSubview: starDisplayView];
        for(NSInteger i = 0; i < 5; i++){
            UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake(i * size_w, 0.0f, size_w, size_w)];
            [imageView setContentMode: UIViewContentModeScaleAspectFit];
            [starDisplayView addSubview: imageView];
            [starImageViewArray addObject: imageView];
        }
        
        ///9.操作按钮
        origin_y = priceLabel.frame.size.height + priceLabel.frame.origin.y + 5.0f;
        operateButton = [[UIButton alloc] initWithFrame: CGRectMake(_size.width - 90.0f, origin_y, 80.0f, 30.0f)];
        [operateButton.titleLabel setFont: [UIFont systemFontOfSize: 15.0f]];
        [operateButton setTag: -1];
        [operateButton addTarget: self action:@selector(operateButtonClick:) forControlEvents: UIControlEventTouchUpInside];
        [self addSubview: operateButton];
    }
    return self;
}

#pragma mark 根据不同状态显示不同布局
- (void)displayForStatus:(NSInteger) status
{
    [operateButton setTag: status];
    ///订单状态： -1:过期 1:未付款； 2:已付款； 3:同意； 4:不同意 5:完成未评论 6:完成已评
    if(status == 2)
    {
        ///////////已支付
        ///1.操作按钮
        [operateButton setBackgroundColor: [UIColor clearColor]];
        [operateButton setTitleColor: [applicationClass methodOfTurnToUIColor: @"#ea3940"] forState: UIControlStateNormal];
        [operateButton.layer setBorderWidth: 0.5f];
        [operateButton.layer setBorderColor: [applicationClass methodOfTurnToUIColor: @"#ea3940"].CGColor];
        [operateButton.layer setCornerRadius: 3.0f];
        [operateButton setTitle: @"查看详情" forState: UIControlStateNormal];
        ///2.状态条
        [statusImageView setHidden: NO];
        [statusImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"payed" ofType: @"png"]]];
        ///3.时间
        [timeLabel setHidden: NO];
        ///4.评星
        [starDisplayView setHidden: NO];
    }
    else if(status == 1)
    {
        ///////未支付
        ///1.操作按钮
        [operateButton setBackgroundColor: [UIColor clearColor]];
        [operateButton setTitleColor: [applicationClass methodOfTurnToUIColor: @"#ea3940"] forState: UIControlStateNormal];
        [operateButton.layer setBorderWidth: 0.5f];
        [operateButton.layer setBorderColor: [applicationClass methodOfTurnToUIColor: @"#ea3940"].CGColor];
        [operateButton.layer setCornerRadius: 3.0f];
        [operateButton setTitle: @"立即支付" forState: UIControlStateNormal];
        ///2.状态条
        [statusImageView setHidden: NO];
        [statusImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"not_pay" ofType: @"png"]]];
        ///3.时间
        [timeLabel setHidden: NO];
        ///4.评星
        [starDisplayView setHidden: NO];
    }
    else if(status == -1)
    {
        ////////过期
        ///1.操作按钮
        [operateButton setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#7f8081"]];
        [operateButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
        [operateButton.layer setBorderWidth: 0.0f];
        [operateButton.layer setCornerRadius: 3.0f];
        [operateButton setTitle: @"已过期" forState: UIControlStateNormal];
        ///2.状态条
        [statusImageView setHidden: YES];
        ///3.背景色
        [self setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#e4e5e6"]];
        ///4.时间
        [timeLabel setHidden: YES];
        ///5.评星
        [starDisplayView setHidden: NO];
    }
    else if(status == 5)
    {
        /////////已完成，未评价
        ///1.操作按钮
        [operateButton setBackgroundColor: [UIColor clearColor]];
        [operateButton setTitleColor: [applicationClass methodOfTurnToUIColor: @"#ea3940"] forState: UIControlStateNormal];
        [operateButton.layer setBorderWidth: 0.5f];
        [operateButton.layer setBorderColor: [applicationClass methodOfTurnToUIColor: @"#ea3940"].CGColor];
        [operateButton.layer setCornerRadius: 3.0f];
        [operateButton setTitle: @"去评价" forState: UIControlStateNormal];
        ///2.状态条
        [statusImageView setHidden: YES];
        ///3.时间
        [timeLabel setHidden: YES];
        ///4.评星
        [starDisplayView setHidden: YES];
    }
    else if(status == 6)
    {
        /////////已完成，已评价
        ///1.操作按钮
        [operateButton setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#7f8081"]];
        [operateButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
        [operateButton.layer setBorderWidth: 0.0f];
        [operateButton.layer setCornerRadius: 3.0f];
        [operateButton setTitle: @"已评价" forState: UIControlStateNormal];
        ///2.状态条
        [statusImageView setHidden: YES];
        ///3.时间
        [timeLabel setHidden: YES];
        ///4.评星
        [starDisplayView setHidden: NO];
    }
    else if(status == 3){
        ///////猎人同意此次旅程，用户可以进行完成此次旅程
        ///1.操作按钮
        [operateButton setBackgroundColor: [UIColor clearColor]];
        [operateButton setTitleColor: [applicationClass methodOfTurnToUIColor: @"#ea3940"] forState: UIControlStateNormal];
        [operateButton.layer setBorderWidth: 0.5f];
        [operateButton.layer setBorderColor: [applicationClass methodOfTurnToUIColor: @"#ea3940"].CGColor];
        [operateButton.layer setCornerRadius: 3.0f];
        [operateButton setTitle: @"完成旅程" forState: UIControlStateNormal];
        ///2.状态条
        [statusImageView setHidden: NO];
        [statusImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"not_pay" ofType: @"png"]]];
        ///3.时间
        [timeLabel setHidden: NO];
        ///4.评星
        [starDisplayView setHidden: NO];
    }
    else if(status == 4)
    {
        /////////已拒绝
        ///1.操作按钮
        [operateButton setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#7f8081"]];
        [operateButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
        [operateButton.layer setBorderWidth: 0.0f];
        [operateButton.layer setCornerRadius: 3.0f];
        [operateButton setTitle: @"已拒绝" forState: UIControlStateNormal];
        ///2.状态条
        [statusImageView setHidden: YES];
        ///3.时间
        [timeLabel setHidden: YES];
        ///4.评星
        [starDisplayView setHidden: NO];
    }
}

#pragma mark 设置头像
- (void)setPhotoImage:(NSURL *)imageUrl sex:(NSInteger)_sex
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

#pragma mark 设置剩余时间
- (void)setSurplusTime:(NSDate *)time
{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate: time];
    NSInteger day = timeInterval / (60 * 60 * 24);
    NSInteger hour = (timeInterval - day * 60 * 60 * 24) / 3600;
    [timeLabel setText: [NSString stringWithFormat: @"还剩：%ld天%ld小时", (long)day, (long)hour]];
}

#pragma mark 按钮操作时间
- (void)operateButtonClick:(UIButton *) sender
{
    if([xDelegate respondsToSelector: @selector(TravelListTableViewCell_DidOperateButtonClick:buttontag:)]){
        [xDelegate TravelListTableViewCell_DidOperateButtonClick: self buttontag: [sender tag]];
    }
}
@end
