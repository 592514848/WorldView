//
//  AppointEvalutionView.m
//  WorldView
//
//  Created by WorldView on 15/11/24.
//  Copyright © 2015年 XZJ. All rights reserved.
//
#define MARGIN_LEFT 15.0F
#import "EvaluationListViewController.h"
#import "AppointEvalutionView.h"

@implementation AppointEvalutionView
- (id)initWithFrame:(CGRect)frame superViewController:(UIViewController *) sender serviceID:(NSString *) serviceId
{
    self = [super initWithFrame: frame];
    if(self){
        serviceID = serviceId;
        superViewController = sender;
        mainApplicaiton = [XZJ_ApplicationClass commonApplication];
        ///1.主视图
        [self setBackgroundColor: [UIColor whiteColor]];
        [self.layer setShadowOpacity: 0.2f];
        [self.layer setShadowOffset: CGSizeMake(0.0f, 2.0f)];
        
        ///2.标题
        XZJ_CustomLabel *titleLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(MARGIN_LEFT, 0.0f, frame.size.width - MARGIN_LEFT - 60.0f, 60.0f)];
        [titleLabel setText: @"用户评论"];
        [titleLabel setTextColor: [mainApplicaiton methodOfTurnToUIColor: @"#0f0f0f"]];
        [titleLabel setFont: [UIFont systemFontOfSize: 16.0f]];
        [self addSubview: titleLabel];
        
        //评论按钮
        CGFloat origin_x = titleLabel.frame.origin.x + titleLabel.frame.size.width;
        UIImageView *evalutionButton = [[UIImageView alloc] initWithFrame: CGRectMake(origin_x, 20.0f, titleLabel.frame.size.height - 40.0f, titleLabel.frame.size.height - 40.0f)];
        [evalutionButton setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"icon_pop" ofType: @"png"]]];
        [evalutionButton setContentMode: UIViewContentModeScaleAspectFit];
        [evalutionButton setUserInteractionEnabled: YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(evalutionButtonClick)];
        [evalutionButton addGestureRecognizer: tap];
        [self addSubview: evalutionButton];
        
        
        ///3.分割线
        CGFloat origin_y = titleLabel.frame.size.height + titleLabel.frame.origin.y;
        UIView *lineView = [[UIView alloc] initWithFrame: CGRectMake(10.0f, origin_y, frame.size.width - 20.0f, 1.0f)];
        [lineView setBackgroundColor: [mainApplicaiton methodOfTurnToUIColor: @"#dddddd"]];
        [self addSubview: lineView];
        
        ///4.评论信息
        frame_origin_y = origin_y + lineView.frame.size.height;
        evalutionObj = [[EvalutionObject alloc] init];
        [evalutionObj setXDelegate: self];
        [evalutionObj getEvalutionList: serviceId];
        
        ///5.查看更多按钮
        origin_y = self.frame.size.height - 50.0f;
        UIImageView *moreImageView = [[UIImageView alloc] initWithFrame: CGRectMake((self.frame.size.width - 60.0f) / 2.0f, origin_y, 60.0f, 30.0f)];
        [moreImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"btn_more" ofType: @"png"]]];
        [moreImageView setContentMode: UIViewContentModeScaleAspectFit];
        tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(moreEvalutionButtonClick)];
        [moreImageView setUserInteractionEnabled: YES];
        [moreImageView addGestureRecognizer: tap];
        [self addSubview: moreImageView];
    }
    return self;
}

#pragma mark -
#pragma mark Evalution委托
- (void)evalutionObjectDelegate_GetEvalutionLsit:(NSArray *)dataArray
{
    evalutionArray = dataArray;
    CGFloat tmp_origin_y = 0.0f;
    CGFloat size_h = (self.frame.size.height - frame_origin_y - 60.0f) / 2.0f;
    CGFloat origin_x = 0.0f;
    CGFloat flag = ([evalutionArray count] > 2 ? 2 : [evalutionArray count]);
    for(NSInteger i = 0; i < flag; i++){
        EvaluationClass *evalution = [evalutionArray objectAtIndex: i];
        //背景
        UIView *tempView = [[UIView alloc] initWithFrame: CGRectMake(0.0f, frame_origin_y+ i * (size_h + 1.0f), self.frame.size.width, size_h)];
        [tempView setBackgroundColor: [UIColor whiteColor]];
        [self addSubview : tempView];
        //头像
        UIImageView *photoImageView = [[UIImageView alloc] initWithFrame: CGRectMake(10.0f, 10.0f, tempView.frame.size.height - 40.0f,tempView.frame.size.height - 40.0f)];
        [photoImageView.layer setCornerRadius: photoImageView.frame.size.height / 2.0f];
        if([[[evalution member] memberSex] isEqualToString: @"女"]){
            [photoImageView.layer setBorderColor: [mainApplicaiton methodOfTurnToUIColor:@"#ffbdcf"].CGColor];
        }
        else{
            [photoImageView.layer setBorderColor: [mainApplicaiton methodOfTurnToUIColor:@"#8cecfc"].CGColor];
        }
        [photoImageView.layer setBorderWidth: 2.0f];
        [photoImageView.layer setMasksToBounds: YES];
        [photoImageView setImageWithURL: [NSURL URLWithString: [[evalution member] memberPhoto]] placeholderImage: [UIImage imageNamed: @"default.png"]];
        [photoImageView setContentMode: UIViewContentModeScaleAspectFill];
        [tempView addSubview: photoImageView];
        //名称
        tmp_origin_y = photoImageView.frame.size.height + photoImageView.frame.origin.y;
        XZJ_CustomLabel *nameLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(photoImageView.frame.origin.x, tmp_origin_y, photoImageView.frame.size.width, 20.0f)];
        [nameLabel setTextAlignment: NSTextAlignmentCenter];
        [nameLabel setText: [[evalution member] nickName]];
        [nameLabel setFont: [UIFont systemFontOfSize: 10.0f]];
        [tempView addSubview: nameLabel];
        ///评分
        origin_x = photoImageView.frame.size.width + photoImageView.frame.origin.x + 10.0f;
        for(NSInteger j = 0; j < 5; j++){
            UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame: CGRectMake(origin_x + 10.0f * j, photoImageView.frame.origin.y, 10.0f, 10.0f)];
            NSString *imageName = (i < [evalution evalutionScore] ? @"star_fill" :@"star_blank");
            [tmpImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: imageName ofType: @"png"]]];
            [tmpImageView setContentMode: UIViewContentModeScaleAspectFit];
            [tempView addSubview: tmpImageView];
        }
        ///评论内容
        tmp_origin_y = photoImageView.frame.origin.y + 10.0f;
        XZJ_CustomLabel *contentLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x, tmp_origin_y, tempView.frame.size.width - origin_x - 10.0f, photoImageView.frame.size.height - tmp_origin_y)];
        [contentLabel setLineBreakMode: NSLineBreakByTruncatingTail];
        [contentLabel setNumberOfLines: 3];
        [contentLabel setFont: [UIFont systemFontOfSize: 13.0f]];
        [contentLabel setText: [evalution evalutionContent]];
        [contentLabel setTextColor: [mainApplicaiton methodOfTurnToUIColor: @"#7d7c7d"]];
        [tempView addSubview: contentLabel];
        ///时间
        tmp_origin_y = photoImageView.frame.size.height + photoImageView.frame.origin.y;
        XZJ_CustomLabel *timeLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(tempView.frame.size.width - 180.0f, tmp_origin_y, 150.0f, 25.0f)];
        [timeLabel setTextColor: [mainApplicaiton methodOfTurnToUIColor: @"#c3c3c3"]];
        [timeLabel setTextAlignment: NSTextAlignmentRight];
        [timeLabel setFont: [UIFont systemFontOfSize: 10.0f]];
        [timeLabel setText: [evalution addTime]];
        [tempView addSubview: timeLabel];
        ///下划线
        if(i == 0){
            UIView *lineView = [[UIView alloc] initWithFrame: CGRectMake(10.0f, tempView.frame.size.height + tempView.frame.origin.y, tempView.frame.size.width - 20.0f, 1.0f)];
            [lineView setBackgroundColor: [mainApplicaiton methodOfTurnToUIColor: @"#dddddd"]];
            [self addSubview: lineView];
        }
    }
    if([evalutionArray count] == 0){
        [mainApplicaiton methodOfShowTipInView: self text: @"暂无评论"];
    }
}

#pragma mark -
#pragma mark 评论的更多按钮
- (void)moreEvalutionButtonClick
{
    EvaluationListViewController *evalutionVC = [[EvaluationListViewController alloc] init];
    [evalutionVC setServiceId: serviceID];
    [superViewController.navigationController pushViewController: evalutionVC animated: YES];
}

#pragma mark -
#pragma mark 评论按钮
- (void)evalutionButtonClick
{
    SendEvalutionViewController *sendVC = [[SendEvalutionViewController alloc] init];
    [sendVC setServiceId: serviceID];
    [superViewController.navigationController pushViewController: sendVC animated: YES];
}
@end
