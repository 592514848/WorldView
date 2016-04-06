//
//  MessageDetailsTableViewCell.m
//  WorldView
//
//  Created by WorldView on 15/11/14.
//  Copyright © 2015年 XZJ. All rights reserved.
//
#define PHOTO_HEIGHT 60.0F
#define MESSAGE_MAX_WIDTH 200.0F
#import "MessageDetailsTableViewCell.h"

@implementation MessageDetailsTableViewCell
- (id)initWithStyle:(UITableViewCellStyle) style reuseIdentifier:(NSString *) reuseIdentifier size:(CGSize) _size
{
    self = [super initWithStyle: style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setSelectionStyle: UITableViewCellSelectionStyleNone];
        [self setBackgroundColor: [UIColor clearColor]];
        applicationClass = [XZJ_ApplicationClass commonApplication];
        [self.layer setShadowOpacity: 0.1f];
        [self.layer setShadowOffset: CGSizeMake(0.0f, 2.0f)];
        
        ///1.头像
        photoImageView = [[UIImageView alloc] initWithFrame: CGRectMake(10.0f, 10.0f, PHOTO_HEIGHT, PHOTO_HEIGHT)];
        [photoImageView setContentMode: UIViewContentModeScaleAspectFill];
        [photoImageView.layer setMasksToBounds: YES];
        [photoImageView.layer setCornerRadius: photoImageView.frame.size.height / 2.0f];
        [photoImageView.layer setBorderWidth: 1.5f];
        [self addSubview: photoImageView];
        
        ///2.消息框
        messageImageView = [[UIImageView alloc] init];
//        [messageImageView.layer setMasksToBounds: YES];
        [self addSubview: messageImageView];
        
        ///3.内容
        contentLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(0.0f, 0.0f, MESSAGE_MAX_WIDTH, PHOTO_HEIGHT)];
        [contentLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#363738"]];
        [contentLabel setFont: [UIFont systemFontOfSize: 12.0f]];
        [contentLabel setBackgroundColor: [UIColor clearColor]];
        [contentLabel setNumberOfLines: 0];
        [contentLabel setLineBreakMode: NSLineBreakByCharWrapping];
        [contentLabel setTextAlignment: NSTextAlignmentCenter];
        [messageImageView addSubview: contentLabel];
    }
    return self;
}

#pragma mark 设置头像
- (void)setPhotoImage:(NSURL *)imageUrl sex:(NSString *)_sex;
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

#pragma mark 设置用户的留言内容
- (void)setLeaveMessageContent:(NSString *) message
{
    ///1.根据文字字数得到高宽
    [contentLabel setText: message];
    CGSize size = [applicationClass methodOfGetLabelSize: contentLabel];
    
    ///2.调整对话框的大小
    CGFloat origin_x = photoImageView.frame.size.width + photoImageView.frame.origin.x;
    CGFloat imageHight = size.height + 20.0f;
    if(imageHight < PHOTO_HEIGHT)
    {
        ///调整对话框的背景图片的大小
        UIImage *image = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"left_dailog_stort" ofType: @"png"]];
        image = [image resizableImageWithCapInsets: UIEdgeInsetsMake(30.0f, 80.0f, 30.0f, 20.0f) resizingMode: UIImageResizingModeStretch];
        [messageImageView setFrame: CGRectMake(origin_x, (self.frame.size.height - imageHight) / 2.0f + photoImageView.frame.origin.y, size.width + 30.0f, imageHight)];
        [messageImageView setImage: image];
    }
    else{
        ///调整对话框的背景图片的大小
        UIImage *image = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"left_dailog_long" ofType: @"png"]];
        image = [image resizableImageWithCapInsets: UIEdgeInsetsMake(100.0f, 400.0f, 10.0f, 80.0f) resizingMode: UIImageResizingModeStretch];
        [messageImageView setFrame: CGRectMake(origin_x, 0.0f, size.width + 30.0f, imageHight)];
        [messageImageView setImage: image];
    }
    ///3.调整对话内容
    [contentLabel setFrame: CGRectMake(25.0f, 10.0f, size.width, size.height)];
}

#pragma mark 设置回复内容
- (void)setReplyMessageContent:(NSString *) message
{
    ///1.调整头像的位置
    [photoImageView setFrame: CGRectMake(self.frame.size.width - 10.0f, 10.0f, PHOTO_HEIGHT, PHOTO_HEIGHT)];
    
    ///2.根据文本字数得到内容的大小
    [contentLabel setText: message];
    CGSize size = [applicationClass methodOfGetLabelSize: contentLabel];
    
    ///3.调整对话框背景的大小
    CGFloat origin_x = self.frame.size.width - size.width - 50.0f;
    CGFloat imageHeight = size.height + 20.0f;
    if(imageHeight < PHOTO_HEIGHT){
        ///调整背景图片
        UIImage *image = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"right_dailog_stort" ofType: @"png"]];
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(30.0f, 10.0f, 30.0f, 60.0f);
        image = [image resizableImageWithCapInsets: edgeInsets resizingMode: UIImageResizingModeStretch];
        ///设置背景对话框
        [messageImageView setImage: image];
        [messageImageView setFrame: CGRectMake(origin_x, (self.frame.size.height - imageHeight) / 2.0f + photoImageView.frame.origin.y, size.width + 40.0f, imageHeight)];
        [messageImageView setImage: image];
    }
    else{
        ///调整背景图片
        UIImage *image = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"right_dailog_long" ofType: @"png"]];
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(100.0f, 80.0f, 10.0f, 400.0f);
        image = [image resizableImageWithCapInsets: edgeInsets resizingMode: UIImageResizingModeStretch];
        ///设置背景对话框
        [messageImageView setFrame: CGRectMake(origin_x, 0.0f, size.width + 40.0f, imageHeight)];
        [messageImageView setImage: image];
    }
    
    ///4.调整文本内容
    [contentLabel setFrame: CGRectMake(10.0f, 10.0f, size.width, size.height)];
}
@end
