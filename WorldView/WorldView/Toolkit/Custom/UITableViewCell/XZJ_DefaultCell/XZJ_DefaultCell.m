//
//  XZJ_DefaultCell.m
//  GRDApplication
//
//  Created by 6602 on 14-8-16.
//  Copyright (c) 2014年 Xiong. All rights reserved.
//

#import "XZJ_DefaultCell.h"

@implementation XZJ_DefaultCell
@synthesize defaultDetailLabel, defaultImageView, defaultTitleLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame: (CGRect)frame style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        defaultImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, frame.size.width / 3.0f, frame.size.height)];
        [self addSubview: defaultImageView];
        
        CGFloat label_X = defaultImageView.frame.size.width + defaultImageView.frame.origin.x + 10.0f;
        defaultTitleLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(label_X, 0.0f, frame.size.width - label_X, frame.size.height / 2.0f)];
        [self addSubview: defaultTitleLabel];
        
        defaultDetailLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(label_X, frame.size.height / 2.0f, frame.size.width - label_X, frame.size.height / 2.0f)];
        [defaultDetailLabel setTextColor: [UIColor lightGrayColor]];
        [self addSubview: defaultDetailLabel];
        
        [self setSelectionStyle: UITableViewCellSelectionStyleNone];
    }
    return self;
}


- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
