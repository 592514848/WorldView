//
//  HomePageLoginView.m
//  WorldView
//
//  Created by XZJ on 10/30/15.
//  Copyright © 2015 XZJ. All rights reserved.
//
#define NAVIGATIONBAR_HEIGHT 44.0f
#import "HomePageLoginView.h"

@implementation HomePageLoginView

- (id)initWithFrame:(CGRect)frame sender:(UIViewController<HomePageLoginViewDelegate> *)_sender
{
    self = [super initWithFrame: frame];
    if(self)
    {
        viewControllerSender = _sender;
        applicationClass = [XZJ_ApplicationClass commonApplication];
        [self setBackgroundColor: [UIColor whiteColor]];
        [self.layer setBorderColor: [applicationClass methodOfTurnToUIColor: @"#d6d6d6"].CGColor];
        [self.layer setMasksToBounds: YES];
        [self.layer setBorderWidth: 0.5f];
        
        /////加载侧滑栏内容
        //1.顶部图片
        UIImageView *topImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0.0f, 2 * NAVIGATIONBAR_HEIGHT, frame.size.width, frame.size.height / 3.0f  - 2 * NAVIGATIONBAR_HEIGHT)];
        [topImageView setContentMode: UIViewContentModeScaleAspectFit];
        [topImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"side_top" ofType: @"png"]]];
        [topImageView.layer setMasksToBounds: YES];
        [self addSubview: topImageView];
        CGFloat origin_y = frame.size.height / 3.0f + NAVIGATIONBAR_HEIGHT;
        UIView *lineView = [[UIView alloc] initWithFrame: CGRectMake(20.0f, origin_y, frame.size.width - 40.0f, 1.0f)];
        [lineView setBackgroundColor: [applicationClass methodOfTurnToUIColor:@"#bababa"]];
        [self addSubview: lineView];
        //2.登录注册
        origin_y += 20.0f;
        CGFloat size_h = (frame.size.height / 3.0f - 80.0f) / 3.0f;
        for(NSInteger i = 0 ; i < 3; i++){
            UIButton *tempbutton = [[UIButton alloc] initWithFrame: CGRectMake(frame.size.width / 4.0f, origin_y, frame.size.width / 2.0f, size_h)];
            origin_y += (size_h + 20.0f);
            [tempbutton setBackgroundColor: [UIColor clearColor]];
            [tempbutton.layer setCornerRadius: 3.0f];
            [tempbutton.layer setBorderColor: [applicationClass methodOfTurnToUIColor: @"#ea515a"].CGColor];
            [tempbutton.layer setBorderWidth: 0.5f];
            [tempbutton setTag: i];
            [self addSubview:tempbutton];
            switch (i) {
                case 0:
                    [tempbutton setTitle: @"登录" forState: UIControlStateNormal];
                    break;
                case 1:
                    [tempbutton setTitle: @"手机注册" forState: UIControlStateNormal];
                    break;
                case 2:
                    [tempbutton setTitle: @"邮箱注册" forState: UIControlStateNormal];
                    break;
                default:
                    break;
            }
            [tempbutton addTarget: self action: @selector(viewButtonClick:) forControlEvents: UIControlEventTouchUpInside];
            [tempbutton setTitleColor: [applicationClass methodOfTurnToUIColor: @"#ea515a"] forState: UIControlStateNormal];
        }
        lineView = [[UIView alloc] initWithFrame: CGRectMake(20.0f, origin_y, frame.size.width - 40.0f, 1.0f)];
        [lineView setBackgroundColor: [applicationClass methodOfTurnToUIColor:@"#bababa"]];
        [self addSubview: lineView];
        ///3.底部区域
        origin_y += 1.0f;
        XZJ_CustomLabel *tipLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(20.0f, origin_y, frame.size.width - 40.0f, 30.0f)];
        [tipLabel setText: @"使用第三方账号登录"];
        [tipLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#929292"]];
        [tipLabel setFont: [UIFont systemFontOfSize: 13.0f]];
        [self addSubview: tipLabel];
        origin_y += tipLabel.frame.size.height + 30.0f;
        ///4.微信登录
        UIImageView *weixinImageView = [[UIImageView alloc] initWithFrame: CGRectMake(frame.size.width / 4.0f, origin_y, frame.size.width / 2.0f, 40.0f)];
        [weixinImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"weixin_login" ofType: @"png"]]];
        [weixinImageView setContentMode: UIViewContentModeScaleAspectFit];
        [weixinImageView setUserInteractionEnabled: YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(weiXinLogin)];
        [weixinImageView addGestureRecognizer: tap];
        [self addSubview: weixinImageView];
        ///5.底部icon
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame: CGRectMake(frame.size.width * 3.0f / 8.0f, frame.size.height - 30.0f, frame.size.width / 4.0f, 20.0f)];
        [iconImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"gray_logo" ofType: @"png"]]];
        [iconImageView setContentMode: UIViewContentModeScaleAspectFit];
        [self addSubview: iconImageView];
    }
    return self;
}

#pragma mark -
#pragma mark 按钮的点击事件
- (void)viewButtonClick: (UIButton *)sender
{
    if([viewControllerSender respondsToSelector: @selector(homePageLoginView_DidClick:)])
    {
        [viewControllerSender homePageLoginView_DidClick: [sender tag]];
    }
    
}

#pragma mark - 微信登录
- (void)weiXinLogin{
    self.weChatLogin();
}
@end
