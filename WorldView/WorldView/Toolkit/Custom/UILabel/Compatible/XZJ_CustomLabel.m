//
//  XZJ_CustomLabel.m
//  GRDApplication
//
//  Created by 6602 on 14-4-13.
//  Copyright (c) 2014年 Xiong. All rights reserved.
//

#import "XZJ_CustomLabel.h"

@implementation XZJ_CustomLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
        if(systemVersion < 7.0f)
        {
            [self setBackgroundColor: [UIColor clearColor]];
        }
    }
    return self;
}

#pragma mark -
#pragma mark 识别HTML的文本
- (void)setHTMLText:(NSString *) text
{
    if(systemVersion >= 7.0f)
    {
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[text dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        [self setAttributedText: attributedString];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
