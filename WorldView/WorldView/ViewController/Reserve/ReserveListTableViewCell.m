//
//  ReserveListTableViewCell.m
//  WorldView
//
//  Created by XZJ on 11/2/15.
//  Copyright © 2015 XZJ. All rights reserved.
//
#define PHOTO_VIEW_HEIGHT 100.0F
#define DETAILS_VIEW_HEIGHT 60.0F
#define BUTTON_HEIGHT 28.0F
#import "ReserveListTableViewCell.h"

@implementation ReserveListTableViewCell
@synthesize nameLabel, titleLabel, timeLabel, placeLabel, numberLabel, contentLabel,descriptLabel, xDelegate;
- (id)initWithStyle:(UITableViewCellStyle) style reuseIdentifier:(NSString *) reuseIdentifier size:(CGSize) _size
{
    self = [super initWithStyle: style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        applicationClass = [XZJ_ApplicationClass commonApplication];
        [self.layer setBorderWidth: 0.5f];
        [self.layer setBorderColor: [applicationClass methodOfTurnToUIColor: @"#f7f8f8"].CGColor];
        [self.layer setShadowOpacity: 0.1f];
        [self.layer setShadowOffset: CGSizeMake(0.0f, 2.0f)];

        ///1.头像
        CGFloat origin_x = 10.0f, origin_y = 15.0f;
        photoImageView = [[UIImageView alloc] initWithFrame: CGRectMake(origin_x, origin_y, PHOTO_VIEW_HEIGHT, PHOTO_VIEW_HEIGHT)];
        [photoImageView setContentMode: UIViewContentModeScaleAspectFill];
        [photoImageView.layer setMasksToBounds: YES];
        [photoImageView.layer setCornerRadius: photoImageView.frame.size.height / 2.0f];
        [photoImageView.layer setBorderWidth: 1.5f];
        [self addSubview: photoImageView];
        
        ///2.姓名
        origin_y = photoImageView.frame.origin.y + PHOTO_VIEW_HEIGHT;
        nameLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x, origin_y, photoImageView.frame.size.width, 20.0f)];
        [nameLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#545656"]];
        [nameLabel setTextAlignment: NSTextAlignmentCenter];
        [nameLabel setFont: [UIFont systemFontOfSize: 13.0f]];
        [self addSubview: nameLabel];
        
        ///3.标题
        origin_y = 10.0f;
        origin_x = photoImageView.frame.size.width + photoImageView.frame.origin.x + 15.0f;
        titleLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x, origin_y, _size.width - origin_x - 10.0f, 20.0f)];
        [titleLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#6d6f6f"]];
        [titleLabel setFont: [UIFont systemFontOfSize: 15.0f]];
        [self addSubview: titleLabel];
        
        ///4.表格
        origin_y = titleLabel.frame.size.height + titleLabel.frame.origin.y + 5.0f;
        CGFloat size_h = nameLabel.frame.size.height + nameLabel.frame.origin.y - origin_y;
        UIView *tableView = [[UIView alloc] initWithFrame: CGRectMake(origin_x, origin_y, _size.width - origin_x - 15.0f, size_h)];
        [tableView.layer setBorderColor: [applicationClass methodOfTurnToUIColor: @"#dcdede"].CGColor];;
        [tableView.layer setBorderWidth: 1.0f];
        [self addSubview: tableView];
        
        ///5.时间、地点、人数
        CGFloat item_h = (size_h - 2.0f) / 3.0f;
        CGFloat size_w = tableView.frame.size.width / 2.0f;
        for (NSInteger i = 0; i < 3; i++) {
            XZJ_CustomLabel *tempTitleLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(5.0f, i * (item_h + 1.0f), size_w - 5.0f, item_h)];
            [tempTitleLabel setFont: [UIFont systemFontOfSize: 12.0f]];
            [tempTitleLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#8b8d8e"]];
            [tableView addSubview: tempTitleLabel];
            XZJ_CustomLabel *tempValueLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(size_w, tempTitleLabel.frame.origin.y, size_w - 5.0f, item_h)];
            [tempValueLabel setFont: [UIFont systemFontOfSize: 12.0f]];
            [tempValueLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#8b8d8e"]];
            [tempValueLabel setTextAlignment: NSTextAlignmentRight];
            [tableView addSubview: tempValueLabel];
            switch (i) {
                case 0:
                    [tempTitleLabel setText: @"时间:"];
                    timeLabel = tempValueLabel;
                    break;
                case 1:
                    [tempTitleLabel setText: @"地点:"];
                    placeLabel = tempValueLabel;
                    break;
                case 2:
                    [tempTitleLabel setText: @"人数:"];
                    numberLabel = tempValueLabel;
                    break;
                default:
                    break;
            }
            if(i != 2){
                UIView *lineView = [[UIView alloc] initWithFrame: CGRectMake(0.0f, tempTitleLabel.frame.size.height + tempTitleLabel.frame.origin.y, tableView.frame.size.width, 1.0f)];
                [lineView setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#dcdede"]];
                [tableView addSubview: lineView];
            }
        }
        ///6.虚线
        origin_y = tableView.frame.size.height + tableView.frame.origin.y;
        XZJ_CustomLabel *potLineView = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(photoImageView.frame.origin.x, origin_y, _size.width - 2 * photoImageView.frame.origin.x, 10.0f)];
//        [potLineView setAdjustsFontSizeToFitWidth: YES];
        [potLineView setText:@"..................................................................................................................................."];
        [potLineView setFont: [UIFont systemFontOfSize: 10.0f]];
        [potLineView setTextColor: [applicationClass methodOfTurnToUIColor: @"#a9aaab"]];
        [self addSubview: potLineView];
        
        origin_y = potLineView.frame.size.height + potLineView.frame.origin.y;
        for(NSInteger i = 0; i < 2; i++)
        {
            origin_x = photoImageView.frame.origin.x;
            ///7.详情主视图
            UIView *detailsView = [[UIView alloc] initWithFrame: CGRectMake(origin_x, origin_y + i * (DETAILS_VIEW_HEIGHT + potLineView.frame.size.height), _size.width - 2 * origin_x, DETAILS_VIEW_HEIGHT)];
            [self addSubview: detailsView];
            ///8.小圆点
            UIView *cicleView = [[UIView alloc] initWithFrame: CGRectMake(5.0f, (DETAILS_VIEW_HEIGHT - 8.0f)/ 2.0f, 8.0f, 8.0f)];
            [cicleView.layer setCornerRadius: cicleView.frame.size.height / 2.0f];
            [cicleView setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#e4464a"]];
            [detailsView addSubview: cicleView];
            
            ///9.详细信息标题
            origin_x = cicleView.frame.size.width + cicleView.frame.size.width;
            XZJ_CustomLabel *detailsTitleLable = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x, 0.0f, photoImageView.frame.size.width, detailsView.frame.size.height)];
            [detailsTitleLable setFont: [UIFont boldSystemFontOfSize: 15.0f]];
            [detailsTitleLable setTextColor: [applicationClass methodOfTurnToUIColor: @"#303232"]];
            [detailsView addSubview: detailsTitleLable];
            
            ///10.详细内容
            origin_x = detailsTitleLable.frame.size.width + detailsTitleLable.frame.origin.x;
            XZJ_CustomLabel *tempLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x, 0.0f, detailsView.frame.size.width - origin_x, DETAILS_VIEW_HEIGHT)];
            [tempLabel setFont: [UIFont systemFontOfSize: 12.0f]];
            [tempLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#6b6c6d"]];
            [tempLabel setNumberOfLines: 0];
            [tempLabel setLineBreakMode: NSLineBreakByTruncatingTail];
            [detailsView addSubview: tempLabel];
            if(i == 0){
                contentLabel = tempLabel;
                [detailsTitleLable setText: @"出行目的:"];
                CGFloat tempOrigin_y = tempLabel.frame.size.height + detailsView.frame.origin.y;
                potLineView = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(photoImageView.frame.origin.x, tempOrigin_y, _size.width - 2 * photoImageView.frame.origin.x, 10.0f)];
                [potLineView setText:@"..................................................................................................................................."];
                [potLineView setFont: [UIFont systemFontOfSize: 10.0f]];
                [potLineView setTextColor: [applicationClass methodOfTurnToUIColor: @"#a9aaab"]];
                [self addSubview: potLineView];
            }
            else{
                descriptLabel = tempLabel;
                [detailsTitleLable setText: @"介绍自己:"];
            }
        }
    
        ///11.虚线
        origin_y += 2 * DETAILS_VIEW_HEIGHT + potLineView.frame.size.height;
        potLineView = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(photoImageView.frame.origin.x, origin_y, _size.width - 2 * photoImageView.frame.origin.x, 10.0f)];
        [potLineView setText:@"..................................................................................................................................."];
        [potLineView setFont: [UIFont systemFontOfSize: 10.0f]];
        [potLineView setTextColor: [applicationClass methodOfTurnToUIColor: @"#a9aaab"]];
        [self addSubview: potLineView];
        
        ///12.拒绝按钮
        origin_x = _size.width / 2.5f;
        origin_y = potLineView.frame.origin.y + potLineView.frame.size.height + 15.0f;
        size_w = _size.width / 5.0f;
        rejectButton = [[UIButton alloc] initWithFrame: CGRectMake(origin_x, origin_y, size_w, BUTTON_HEIGHT)];
        [rejectButton setTitle: @"拒绝" forState: UIControlStateNormal];
        [rejectButton.layer setBorderWidth: 0.5f];
        [rejectButton.layer setBorderColor: [applicationClass methodOfTurnToUIColor: @"#e55155"].CGColor];
        [rejectButton.layer setCornerRadius: 3.0f];
        [rejectButton setTitleColor: [applicationClass methodOfTurnToUIColor: @"#e55155"] forState: UIControlStateNormal];
        [rejectButton addTarget: self action: @selector(rejectButtonClick) forControlEvents: UIControlEventTouchUpInside];
        [rejectButton.titleLabel setFont: [UIFont systemFontOfSize: 13.0f]];
        [self addSubview: rejectButton];
        
        ///13.操作按钮
        origin_x = _size.width - size_w - 15.0f;
        operateButton = [[UIButton alloc] initWithFrame: CGRectMake(origin_x, origin_y, size_w, BUTTON_HEIGHT)];
        [operateButton.layer setBorderWidth: 0.5f];
        [operateButton.layer setBorderColor: [applicationClass methodOfTurnToUIColor: @"#e77275"].CGColor];
        [operateButton setTitleColor: [applicationClass methodOfTurnToUIColor: @"#e55155"] forState: UIControlStateNormal];
        [operateButton.titleLabel setFont: [UIFont systemFontOfSize: 13.0f]];
        [operateButton.layer setCornerRadius: 3.0f];
        [operateButton addTarget: self action: @selector(operateButton) forControlEvents: UIControlEventTouchUpInside];
        [self addSubview: operateButton];
        
        ///14.时间间隔
        origin_x = photoImageView.frame.origin.x;
        origin_y = _size.height - 30.0f;
        timeSpanLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x, origin_y, _size.width / 2.0f, 20.0f)];
        [timeSpanLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#e45054"]];
        [timeSpanLabel setFont: [UIFont systemFontOfSize: 12.0f]];
        [timeSpanLabel setHidden: YES];
        [self addSubview: timeSpanLabel];
    }
    return self;
}

#pragma mark 根据不同状态显示不同布局
- (void)displayForStatus:(NSInteger) status
{
    ///订单状态： -1:过期 1:未付款； 2:已付款； 3:同意； 4:不同意 5:完成未评论 6:完成已评
    [operateButton setTag: status];
    if(status == 4)
    {
        ///////////已拒绝
        ///1.操作按钮
        [operateButton setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#88898a"] ];
        [operateButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
        [operateButton.layer setBorderWidth: 0.0f];
        [operateButton setTitle: @"已拒绝" forState: UIControlStateNormal];
        ///2.拒绝按钮
        [rejectButton setHidden: YES];
        ///3.背景
        [self setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#e4e5e6"]];
        ///4.时间间隔
        [timeSpanLabel setHidden: YES];
    }
    else if(status == 3){
        ///////////已接受
        ///1.操作按钮
        [operateButton setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#ea5357"] ];
        [operateButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
        [operateButton.layer setBorderWidth: 0.0f];
        [operateButton setTitle: @"联系TA" forState: UIControlStateNormal];
        ///2.拒绝按钮
        [rejectButton setHidden: YES];
        ///3.背景
        [self setBackgroundColor: [UIColor whiteColor]];
        ///4.时间间隔
        [timeSpanLabel setHidden: NO];
    }
    else if(status == -1){
        ///////////过期
        ///1.操作按钮
        [operateButton setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#88898a"] ];
        [operateButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
        [operateButton.layer setBorderWidth: 0.0f];
        [operateButton setTitle: @"已结束" forState: UIControlStateNormal];
        ///2.拒绝按钮
        [rejectButton setHidden: YES];
        ///3.背景
        [self setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#e4e5e6"]];
        ///4.时间间隔
        [timeSpanLabel setHidden: YES];
    }
    else if(status == 5 || status == 6){
        ///1.操作按钮
        [operateButton setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#88898a"] ];
        [operateButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
        [operateButton.layer setBorderWidth: 0.0f];
        [operateButton setTitle: @"已完成" forState: UIControlStateNormal];
        ///2.拒绝按钮
        [rejectButton setHidden: YES];
        ///3.背景
        [self setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#e4e5e6"]];
        ///4.时间间隔
        [timeSpanLabel setHidden: YES];
    }
    else
    {
        ///1.操作按钮
        [operateButton setBackgroundColor: [UIColor clearColor] ];
        [operateButton setTitleColor: [applicationClass methodOfTurnToUIColor: @"#e55155"] forState: UIControlStateNormal];
        [operateButton.layer setBorderWidth: 0.5f];
        [operateButton.layer setBorderColor: [applicationClass methodOfTurnToUIColor: @"#e77275"].CGColor];
        [operateButton setTitle: @"接受预约" forState: UIControlStateNormal];
        ///2.拒绝按钮
        [rejectButton setHidden: NO];
        ///3.背景
        [self setBackgroundColor: [UIColor whiteColor]];
        ///4.时间间隔
        [timeSpanLabel setHidden: YES];
    }
}

#pragma mark 设置头像
- (void)setPhotoImage:(NSURL *) imageUrl sex:(NSString *) _sex
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
#pragma mark 设置剩余时间
- (void)setSurplusTime:(NSDate *)time
{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate: time];
    NSInteger day = timeInterval / (60 * 60 * 24);
    NSInteger hour = (timeInterval - day * 60 * 60 * 24) / 3600;
    [timeSpanLabel setText: [NSString stringWithFormat: @"距离开始时间：%ld天%ld小时", (long)day, (long)hour]];
    
}

#pragma mark 拒绝按钮点击事件
- (void)rejectButtonClick
{
    if([xDelegate respondsToSelector: @selector(ReserveListTableViewCell_DidRejectButtonClick:)]){
        [xDelegate ReserveListTableViewCell_DidRejectButtonClick: self];
    }
}

- (void)operateButton
{
    if([xDelegate respondsToSelector: @selector(ReserveListTableViewCell_DidOperateButtonClick: index:)]){
        [xDelegate ReserveListTableViewCell_DidOperateButtonClick: self index: [operateButton tag]];
    }
}
@end
