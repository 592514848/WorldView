//
//  XZJ_CompatibleSearchBar.m
//  GRDApplication
//
//  Created by XZJ on 15/1/10.
//  Copyright (c) 2015年 Xiong. All rights reserved.
//

#import "XZJ_CompatibleSearchBar.h"

@implementation XZJ_CompatibleSearchBar

- (id)init
{
    if(self = [super init])
    {
        [self abjustCompatible: self color: [UIColor clearColor]];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withBackGroundColor:(UIColor *) _color
{
    if(self = [super initWithFrame: frame])
    {
        [self abjustCompatible: self color: _color];
    }
    return self;
}

#pragma mark -
#pragma mark 兼容性调整
- (void)abjustCompatible:(UISearchBar *) searchBar color:(UIColor *)_color
{
    float version = [[[ UIDevice currentDevice ] systemVersion ] floatValue ];
    if ([ searchBar respondsToSelector : @selector (barTintColor)]) {
        float  iosversion7_1 = 7.1 ;
        if (version >= iosversion7_1)
        {
            //iOS7.1
            [[[[ searchBar . subviews objectAtIndex : 0 ] subviews ] objectAtIndex : 0 ] removeFromSuperview ];
            [ searchBar setBackgroundColor: _color];
        }
        else
        {
            //iOS7.0
            [ searchBar setBarTintColor :_color];
            [ searchBar setBackgroundColor :_color];
        }
    }
    else
    {
        //iOS7.0 以下
        [[ searchBar . subviews objectAtIndex : 0 ] removeFromSuperview ];
        [ searchBar setBackgroundColor :_color];
    }
}
@end
