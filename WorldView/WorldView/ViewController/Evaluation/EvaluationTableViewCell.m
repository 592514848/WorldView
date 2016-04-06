//
//  EvaluationTableViewCell.m
//  WorldView
//
//  Created by WorldView on 15/11/16.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import "EvaluationTableViewCell.h"

@implementation EvaluationTableViewCell
@synthesize nameLabel, contentLabel, timeLabel;
- (id)initWithStyle:(UITableViewCellStyle) style reuseIdentifier:(NSString *) reuseIdentifier size:(CGSize) _size
{
    self = [super initWithStyle: style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        applicationClass = [XZJ_ApplicationClass commonApplication];
        ///1.头像
       photoImageView = [[UIImageView alloc] initWithFrame: CGRectMake(10.0f, 10.0f, _size.height - 40.0f,_size.height - 40.0f)];
        [photoImageView.layer setCornerRadius: photoImageView.frame.size.height / 2.0f];
        [photoImageView.layer setBorderColor: [applicationClass methodOfTurnToUIColor:@"#ffbdcf"].CGColor];
        [photoImageView.layer setBorderWidth: 2.0f];
        [photoImageView.layer setMasksToBounds: YES];
        [photoImageView setContentMode: UIViewContentModeScaleAspectFill];
        [self addSubview: photoImageView];
        
        ///2.名称
        CGFloat origin_y = photoImageView.frame.size.height + photoImageView.frame.origin.y;
        nameLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(photoImageView.frame.origin.x, origin_y, photoImageView.frame.size.width, 20.0f)];
        [nameLabel setTextAlignment: NSTextAlignmentCenter];
        [nameLabel setFont: [UIFont systemFontOfSize: 10.0f]];
        [self addSubview: nameLabel];
        
        ///3.评分
        starImageViewArray = [[NSMutableArray alloc] initWithCapacity: 5];
        CGFloat origin_x = photoImageView.frame.size.width + photoImageView.frame.origin.x + 10.0f;
        for(NSInteger j = 0; j < 5; j++){
            UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame: CGRectMake(origin_x + 10.0f * j, photoImageView.frame.origin.y, 10.0f, 10.0f)];
            [tmpImageView setContentMode: UIViewContentModeScaleAspectFit];
            [self addSubview: tmpImageView];
            [starImageViewArray addObject: tmpImageView];
        }
        
        ///4.评论内容
        origin_y = photoImageView.frame.origin.y + 10.0f;
        contentLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x, origin_y, _size.width - origin_x - 10.0f, photoImageView.frame.size.height - origin_y)];
        [contentLabel setLineBreakMode: NSLineBreakByTruncatingTail];
        [contentLabel setNumberOfLines: 3];
        [contentLabel setFont: [UIFont systemFontOfSize: 13.0f]];
        [contentLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#7d7c7d"]];
        [self addSubview: contentLabel];
        
        ///5.时间
        origin_y = photoImageView.frame.size.height + photoImageView.frame.origin.y;
        timeLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(_size.width - 100.0f, origin_y, 90.0f, 25.0f)];
        [timeLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#c3c3c3"]];
        [timeLabel setTextAlignment: NSTextAlignmentRight];
        [timeLabel setFont: [UIFont systemFontOfSize: 10.0f]];
        [self addSubview: timeLabel];
    }
    return self;
}

#pragma mark 设置评星等级
- (void)setStarLevel:(NSInteger)level
{
    for(NSInteger i = 0; i < [starImageViewArray count]; i++){
        NSString *imageName = (i < level ? @"star_fill" :@"star_blank");
        UIImageView *tempImageView = (UIImageView *)[starImageViewArray objectAtIndex: i];
        [tempImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: imageName ofType: @"png"]]];
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
@end
