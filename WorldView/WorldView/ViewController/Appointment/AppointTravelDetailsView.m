//
//  AppointTravelDetailsView.m
//  WorldView
//
//  Created by WorldView on 15/11/24.
//  Copyright © 2015年 XZJ. All rights reserved.
//
#define MARGIN_LEFT 15.0F
#define LINE_LABEL_WIDTH 70.0f
#define LINE_LABEL_HEIGHT 30.0f
#define CONTENT_IMAGE_HEIGHT 150.0f
#import "AppointTravelDetailsView.h"
#import "ServiceDetailsViewController.h"

@implementation AppointTravelDetailsView
@synthesize viewController;
- (id)initWithFrame:(CGRect)frame service:(ServiceClass *) _service
{
    self = [super initWithFrame: frame];
    if(self){
        mainService = _service;
        mainApplication = [XZJ_ApplicationClass commonApplication];
        ///1.旅游详情主视图
        [self setBackgroundColor: [UIColor whiteColor]];
        [self.layer setShadowOpacity: 0.2f];
        [self.layer setShadowOffset: CGSizeMake(0.0f, 2.0f)];
        
        ///2.标题
        XZJ_CustomLabel *titleLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(0.0f, 0.0f, frame.size.width, 60.0f)];
        [titleLabel setText: @"旅程详情"];
        [titleLabel setTextColor: [mainApplication methodOfTurnToUIColor: @"#0f0f0f"]];
        [titleLabel setTextAlignment: NSTextAlignmentCenter];
        [titleLabel setFont: [UIFont systemFontOfSize: 16.0f]];
        [self addSubview: titleLabel];
        
        ///3.分割线
        CGFloat origin_y = titleLabel.frame.size.height + titleLabel.frame.origin.y;
        UIView *lineView = [[UIView alloc] initWithFrame: CGRectMake(10.0f, origin_y, frame.size.width - 20.0f, 1.0f)];
        [lineView setBackgroundColor: [mainApplication methodOfTurnToUIColor: @"#dddddd"]];
        [self addSubview: lineView];
        
        ///4.路线
        origin_y += lineView.frame.size.height + 5.0f;
        CGFloat origin_x = 10.0f;
        NSArray *lineRoadArray =  [[_service lineRoad] componentsSeparatedByString: @"-"];
        for(NSInteger i = 0; i < [lineRoadArray count]; i++){
            ///地点名称
            XZJ_CustomLabel *tmpLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x, origin_y + (i > 2 ? 1 : 0) * 30.0f, LINE_LABEL_WIDTH, LINE_LABEL_HEIGHT)];
            [tmpLabel setFont: [UIFont systemFontOfSize: 13.0f]];
            [tmpLabel setText: [lineRoadArray objectAtIndex: i]];
            [tmpLabel setTextColor: [mainApplication methodOfTurnToUIColor: @"#4c4c4c"]];
            [tmpLabel setTextAlignment: NSTextAlignmentCenter];
            [self addSubview: tmpLabel];
            if(i < 2){
                origin_x = tmpLabel.frame.size.width + tmpLabel.frame.origin.x;
                ///线路
                UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame: CGRectMake(origin_x, tmpLabel.frame.origin.y, LINE_LABEL_WIDTH / 2.0f, tmpLabel.frame.size.height)];
                [tmpImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"travel_line" ofType: @"png"]]];
                [tmpImageView setContentMode: UIViewContentModeScaleAspectFit];
                [self addSubview: tmpImageView];
                origin_x += LINE_LABEL_WIDTH / 2.0f;
            }
            else if(i == 2 && [lineRoadArray count] > 3){
                origin_x = tmpLabel.frame.size.width + tmpLabel.frame.origin.x;
                ///线路
                UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame: CGRectMake(origin_x, tmpLabel.frame.origin.y + tmpLabel.frame.size.height / 2.0f, LINE_LABEL_WIDTH / 2.0f, tmpLabel.frame.size.height)];
                [tmpImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"line_circle" ofType: @"png"]]];
                [self addSubview: tmpImageView];
                origin_x -= tmpLabel.frame.size.width;
            }
            else if(i > 2 && i < 5){
                origin_x -= LINE_LABEL_WIDTH / 2.0f;
                ///线路
                UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame: CGRectMake(origin_x, tmpLabel.frame.origin.y, LINE_LABEL_WIDTH / 2.0f, tmpLabel.frame.size.height)];
                [tmpImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"line_left" ofType: @"png"]]];
                [tmpImageView setContentMode: UIViewContentModeScaleAspectFit];
                [self addSubview: tmpImageView];
                origin_x -= LINE_LABEL_WIDTH;
            }
        }
        
        ///5.分割线
        origin_y += 2 * LINE_LABEL_HEIGHT;
        lineView = [[UIView alloc] initWithFrame: CGRectMake(10.0f, origin_y, frame.size.width - 20.0f, 0.5f)];
        [lineView setBackgroundColor: [mainApplication methodOfTurnToUIColor: @"#dddddd"]];
        [self addSubview: lineView];
        
        ///6.旅行时长
        origin_y = lineView.frame.size.height + lineView.frame.origin.y;
        XZJ_CustomLabel *timeLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(MARGIN_LEFT, origin_y, frame.size.width - 2 * MARGIN_LEFT, LINE_LABEL_HEIGHT * 1.5f)];
        [timeLabel setText: [NSString stringWithFormat: @"旅程时长：%@天", [_service serviceTimeSize]]];
        [timeLabel setFont: [UIFont systemFontOfSize: 12.0f]];
        [timeLabel setTextColor: [mainApplication methodOfTurnToUIColor: @"#717171"]];
        [self addSubview: timeLabel];
        
        ///7.分割线
        origin_y = timeLabel.frame.size.height + timeLabel.frame.origin.y;
        lineView = [[UIView alloc] initWithFrame: CGRectMake(10.0f, origin_y, frame.size.width - 20.0f, 0.5f)];
        [lineView setBackgroundColor: [mainApplication methodOfTurnToUIColor: @"#dddddd"]];
        [self addSubview: lineView];
        
        ///8.旅程内容
        origin_y += lineView.frame.size.height + 10.0f;
        UIView *contentView = [[UIView alloc] initWithFrame: CGRectMake(MARGIN_LEFT, origin_y, frame.size.width - 2 * MARGIN_LEFT, frame.size.height - origin_y - 40.0f)];
        [self addSubview: contentView];
        origin_y = 0.0f;
        if([_service detailImgDesc]){
            NSString *responsedString = [[_service detailImgDesc] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSArray *imageTextArray = [responsedString objectFromJSONStringWithParseOptions: JKParseOptionLooseUnicode];
            NSInteger flag = [imageTextArray count] > 2 ? 2 : [imageTextArray count];
            for(NSInteger i = 0; i < flag; i++)
            {
                NSDictionary *tempDictionary = [imageTextArray objectAtIndex: i];
                ////文字
                CGRect labelFrame = CGRectMake(0.0f, origin_y, contentView.frame.size.width, 20.0f);
                UILabel *tmpLabel = [[UILabel alloc] initWithFrame: labelFrame];
                [tmpLabel setText: [tempDictionary objectForKey: @"desc"]];
                [tmpLabel setNumberOfLines: 0];
                [tmpLabel setLineBreakMode: NSLineBreakByTruncatingTail];
                [tmpLabel setFont: [UIFont systemFontOfSize: 12.0f]];
                [tmpLabel setTextColor: [mainApplication methodOfTurnToUIColor:@"#7a7a7a"]];
                [contentView addSubview: tmpLabel];
                labelFrame.size.height = [mainApplication methodOfGetLabelSize: tmpLabel].height;
                [tmpLabel setFrame:labelFrame];
                ////图片
                origin_y = tmpLabel.frame.size.height + tmpLabel.frame.origin.y + 10.0f;
                UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0.0f, origin_y, contentView.frame.size.width, CONTENT_IMAGE_HEIGHT)];
                [tmpImageView setImageWithURL: IMAGE_URL([tempDictionary objectForKey: @"url"]) placeholderImage: [UIImage imageNamed: @"default.png"]];
                [tmpImageView setContentMode: UIViewContentModeScaleAspectFill];
                [tmpImageView.layer setMasksToBounds: YES];
                [contentView addSubview: tmpImageView];
                origin_y += CONTENT_IMAGE_HEIGHT + 10.0f;
            }
        }
        
        ////9.调整滚动视图的大小
        frame.size.height = origin_y + contentView.frame.origin.y + 60.0f;
        [self setFrame: frame];
        
        ///10.查看更多按钮
        origin_y = frame.size.height - 50.0f;
        UIImageView *moreImageView = [[UIImageView alloc] initWithFrame: CGRectMake((frame.size.width - 60.0f) / 2.0f, origin_y, 60.0f, 30.0f)];
        [moreImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"btn_more" ofType: @"png"]]];
        [moreImageView setContentMode: UIViewContentModeScaleAspectFit];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(moreImageVIewClick)];
        [moreImageView addGestureRecognizer: tap];
        [moreImageView setUserInteractionEnabled: YES];
        [self addSubview: moreImageView];
    }
    return self;
}

- (void)moreImageVIewClick
{
    ServiceDetailsViewController *serviceDetailsVC = [[ServiceDetailsViewController alloc] init];
    [serviceDetailsVC setMainService: mainService];
    [viewController.navigationController pushViewController: serviceDetailsVC animated: YES];
}
@end
