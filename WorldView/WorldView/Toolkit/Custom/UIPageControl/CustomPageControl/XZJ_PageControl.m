//
//  XZJ_PageControl_One.m
//  GRDApplication
//
//  Created by 6602 on 14-3-31.
//  Copyright (c) 2014年 Xiong. All rights reserved.
//

#import "XZJ_PageControl.h"

@implementation XZJ_PageControl
@synthesize activeColor;
@synthesize inactiveColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    [super setCurrentPage: currentPage];
    //设置自定义颜色
    for(NSInteger i = 0; i < [self.subviews count]; i++)
    {
        UIImageView *dotImageView = [self.subviews objectAtIndex: i];
        if(activeColor != nil && i == currentPage)
        {
            
            [dotImageView setBackgroundColor: activeColor];
        }
        else if(inactiveColor != nil)
        {
            [dotImageView setBackgroundColor: inactiveColor];
        }
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
