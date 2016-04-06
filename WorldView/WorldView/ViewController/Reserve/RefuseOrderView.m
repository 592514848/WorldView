//
//  RefuseOrderView.m
//  WorldView
//
//  Created by WorldView on 15/12/8.
//  Copyright © 2015年 XZJ. All rights reserved.
//
#define BUTTON_HEIGHT 30.0f
#define BUTTON_WIDTH 60.0F
#import "RefuseOrderView.h"

@implementation RefuseOrderView
@synthesize xDelegate, operateCell, refusetextView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: frame];
    if(self){
        XZJ_ApplicationClass *applicationClass = [XZJ_ApplicationClass commonApplication];
        ///操作框
        operateFrame = CGRectMake(20.0f, frame.size.height / 3.5f, frame.size.width - 40.0f, frame.size.height / 2.0f);
        operateView = [[UIView alloc] initWithFrame: operateFrame];
        [operateView setBackgroundColor: [UIColor whiteColor]];
        [operateView.layer setCornerRadius: 5.0f];
        [operateView.layer setMasksToBounds: YES];
        [self addSubview: operateView];
        ///拒绝理由标题
        XZJ_CustomLabel *titleLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(20.0f, 10.0f, operateView.frame.size.width - 40.0f, 20.0f)];
        [titleLabel setText: @"拒绝理由:"];
        [titleLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#292b2d"]];
        [titleLabel setFont: [UIFont systemFontOfSize: 15.0f]];
        [operateView addSubview: titleLabel];
        ///输入框
        CGFloat origin_y = titleLabel.frame.size.height + titleLabel.frame.origin.y + 10.0f;
        UITextView *textView = [[UITextView alloc] initWithFrame: CGRectMake(20.0f, origin_y, operateView.frame.size.width - 40.0f, operateView.frame.size.height / 2.0f)];
        [textView setText: @"对方将会看到您的拒绝理由..."];
        [textView setTextColor: [applicationClass methodOfTurnToUIColor: @"#aaabac"]];
        [textView setFont: [UIFont systemFontOfSize:14.0f]];
        [textView setDelegate: self];
        [textView.layer setBorderColor: [applicationClass methodOfTurnToUIColor: @"#dcddde"].CGColor];
        [textView.layer setBorderWidth: 0.5f];
        [textView.layer setCornerRadius: 3.0f];
        refusetextView = textView;
        [operateView addSubview: textView];
        ///按钮
        CGFloat margin = (operateView.frame.size.width - 2 * BUTTON_WIDTH) / 3.0;
        for(NSInteger i = 0; i < 2; i++)
        {
            UIButton *tmpButton = [[UIButton alloc] initWithFrame: CGRectMake(margin + i * (BUTTON_WIDTH + margin), operateView.frame.size.height - BUTTON_HEIGHT - 15.0f, BUTTON_WIDTH, BUTTON_HEIGHT)];
            [tmpButton.layer setBorderWidth: 0.5f];
            [tmpButton.layer setBorderColor: [applicationClass methodOfTurnToUIColor: @"#e20013"].CGColor];
            [tmpButton setBackgroundColor: [UIColor whiteColor]];
            [tmpButton.titleLabel setFont: [UIFont systemFontOfSize: 13.0f]];
            [tmpButton.layer setCornerRadius: 3.0f];
            [tmpButton setTitleColor: [applicationClass methodOfTurnToUIColor: @"#e20013"] forState: UIControlStateNormal];
            NSString *title = (i == 0 ? @"取消" : @"拒绝预约");
            [tmpButton setTag: i];
            [tmpButton setTitle: title forState: UIControlStateNormal];
            [tmpButton addTarget: self action: @selector(operateButtconClick:) forControlEvents: UIControlEventTouchUpInside];
            [operateView addSubview: tmpButton];
        }
        ////
        operateFrame.size.height = 0.0f;
        [operateView setFrame: operateFrame];
    }
    return self;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([[textView text] isEqualToString: @"对方将会看到您的拒绝理由..."]){
        [textView setText: @""];
    }
}

#pragma mark -
#pragma mark 展示
- (void)show
{
    [self setHidden: NO];
    alpha = 0.0f;
    timer = [NSTimer scheduledTimerWithTimeInterval: 0.1f target: self selector: @selector(upBackgroundAlpha) userInfo: nil repeats: YES];
    [UIView animateWithDuration: 0.5f animations: ^{
        operateFrame.size.height = self.frame.size.height / 2.0f;
        [operateView setFrame: operateFrame];
    } completion: ^(BOOL finish){
    }];
}

- (void)upBackgroundAlpha
{
    if(alpha >= 0.5f){
        [timer setFireDate: [NSDate distantFuture]];
    }
    else{
        alpha += 0.1;
        [self setBackgroundColor: [[UIColor alloc] initWithWhite: 0.1f alpha: alpha]];
    }
}

#pragma mark 隐藏
- (void)dismiss
{
    [refusetextView resignFirstResponder];
    timer = [NSTimer scheduledTimerWithTimeInterval: 0.1f target: self selector: @selector(downBackgroundAlpha) userInfo: nil repeats: YES];
    [UIView animateWithDuration: 0.3f animations: ^{
        operateFrame.size.height = 0.0f;
        [operateView setFrame: operateFrame];
    } completion: ^(BOOL finish){
        if(finish){
            [self setHidden: YES];
        }
    }];
}

- (void)downBackgroundAlpha
{
    if(alpha <= 0.0f){
        [timer setFireDate: [NSDate distantFuture]];
    }
    else{
        alpha -= 0.1;
        [self setBackgroundColor: [[UIColor alloc] initWithWhite: 0.1f alpha: alpha]];
    }
}

- (void)operateButtconClick:(UIButton *)sender
{
    [refusetextView resignFirstResponder];
    if([xDelegate respondsToSelector: @selector(RefuseOrderView_DidOperateButtonClick:cell:)]){
        [xDelegate RefuseOrderView_DidOperateButtonClick: sender cell: operateCell];
    }
    [self dismiss];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}
@end
