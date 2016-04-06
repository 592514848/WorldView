//
//  LanguageTableViewCell.m
//  WorldView
//
//  Created by WorldView on 15/11/21.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import "LanguageTableViewCell.h"

@implementation LanguageTableViewCell
@synthesize languageLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier size:(CGSize ) _size
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        languageLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(40.0f, 0.0f, _size.width / 2.0f - 40.0f, _size.height)];
        [languageLabel setTextColor: [UIColor grayColor]];
        [languageLabel setFont: [UIFont systemFontOfSize: 13.0f]];
        [self addSubview: languageLabel];
        
        selectImageView = [[UIImageView alloc] initWithFrame: CGRectMake(_size.width - _size.height, _size.height / 4.0f, _size.height / 2.0f, _size.height / 2.0f)];
        [selectImageView setContentMode: UIViewContentModeScaleAspectFit];
        [self addSubview: selectImageView];
    }
    return self;
}

- (void)setSelectStatus
{
    [selectImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"icon_selected" ofType: @"png"]]];
}

- (void)setNotSelectStatus
{
    [selectImageView setImage: nil];
}
@end
