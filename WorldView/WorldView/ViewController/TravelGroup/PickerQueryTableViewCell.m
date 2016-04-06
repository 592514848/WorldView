//
//  PickerQueryTableViewCell.m
//  WorldView
//
//  Created by XZJ on 11/9/15.
//  Copyright © 2015 XZJ. All rights reserved.
//

#import "PickerQueryTableViewCell.h"

@implementation PickerQueryTableViewCell
@synthesize defaultLabel;
- (id)initWithStyle:(UITableViewCellStyle) style reuseIdentifier:(NSString *) reuseIdentifier size:(CGSize) _size
{
    self = [super initWithStyle: style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        applicationClass = [XZJ_ApplicationClass commonApplication];
        [self setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#edeeef"]];
        [self setSelectionStyle: UITableViewCellSelectionStyleNone];
        ///1.标题
        defaultLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(0.0f, 0.0f, _size.width, _size.height)];
        [defaultLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#6e6f70"]];
        [defaultLabel setTextAlignment: NSTextAlignmentCenter];
        [defaultLabel setFont: [UIFont boldSystemFontOfSize: 14.0f]];
        [self addSubview: defaultLabel];
        
        ///2.小圆点
        selectView = [[UIView alloc] initWithFrame: CGRectMake(0.0f, (_size.height - 8.0f) / 2.0f, 8.0f, 8.0f)];
        [selectView setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#f05654"]];
        [selectView.layer setCornerRadius: 4.0f];
        [selectView setHidden: YES];
        [self addSubview: selectView];
    }
    return self;
}

- (void)setSelected:(BOOL) isSelected
{
    if(isSelected){
        [defaultLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#f05654"]];
        [self setBackgroundColor: [UIColor whiteColor]];
        ///
        CGRect frame = [selectView frame];
        frame.origin.x = self.frame.size.width / 2.0f + [[defaultLabel text] length] * 8.0f;
        [selectView setFrame: frame];
        [selectView setHidden: NO];
    }
    else{
        [defaultLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#6e6f70"]];
        [self setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#edeeef"]];
        [selectView setHidden: YES];
    }
}
@end
