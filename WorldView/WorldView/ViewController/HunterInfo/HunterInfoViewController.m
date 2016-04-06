//
//  HunterInfoViewController.m
//  WorldView
//
//  Created by WorldView on 15/12/3.
//  Copyright © 2015年 XZJ. All rights reserved.
//
#define BASE_HEIGHT 50.0F
#define OTHER_VIEW_HEIGHT 320.0f

#import "HunterInfoViewController.h"

@implementation HunterInfoViewController
@synthesize hunterId, mainService;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadMainView];
    [self setTitle: @"猎人详情"];
    if(isLogin){
        memberObj = [[MemberObject alloc] init];
        [memberObj setXDelegate: self];
        [memberObj setMemberId: hunterId];
        [memberObj getMemberDetails];
    }
}

- (void)loadMainView
{
    mainScrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, curScreenSize.width, curScreenSize.height)];
    [mainScrollView setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#eff0f1"]];
    [mainScrollView setShowsVerticalScrollIndicator: NO];
    [self.view addSubview: mainScrollView];
    ////加载猎人主要信息
    if(!mainHunterInfoView){
        mainHunterInfoView = [[HunterMainInfoView alloc] initWithFrame: CGRectMake(0.0f, 0.0, curScreenSize.width, curScreenSize.height)];
        [mainScrollView addSubview: mainHunterInfoView];
    }
}

#pragma mark -
#pragma mark MemberObject委托
- (void)MemberObject_GetMemberDetails:(BOOL)success infoDictionarys:(NSDictionary *)infoDictionary
{
    if(success){
        [mainHunterInfoView updateMainView: memberObj];
        ///加载猎人的认证信息
        [self loadHunterCertifyInfo];
    }
}

#pragma mark -
#pragma mark 加载猎人的认证信息
- (void)loadHunterCertifyInfo
{
    CGFloat origin_y = mainHunterInfoView.frame.size.height + mainHunterInfoView.frame.origin.y + 10.0f;
    ///1.主视图
    CGRect frame = CGRectMake(0.0f, origin_y, curScreenSize.width, 0.0f);
    UIView *mainView = [[UIView alloc] initWithFrame: frame];
    [mainView setBackgroundColor: [UIColor whiteColor]];
    [mainView.layer setShadowOpacity: 0.3f];
    [mainView.layer setShadowOffset: CGSizeMake(0.0f, 3.0f)];
    [mainScrollView addSubview: mainView];
    ///2.标题
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame: CGRectMake(40.0f, 20.0f, mainView.frame.size.width - 80.0f, 15.0f)];
    [lineImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"worldview_identy" ofType: @"png"]]];
    [lineImageView setContentMode: UIViewContentModeScaleAspectFit];
    [mainView addSubview: lineImageView];
    ////3.证书视图
    origin_y = lineImageView.frame.size.height +lineImageView.frame.origin.y + 10.0f;
    NSInteger flag = 0;
    NSMutableArray *certifyNameArray = [NSMutableArray array];
    if([[memberObj nickName] length] > 0){
        flag++;
        [certifyNameArray addObject: @"真实姓名"];
    }
    if([[memberObj memberPhone] length] > 0){
        flag++;
        [certifyNameArray addObject: @"电话号码"];
    }
    if([[memberObj memberMail] length] > 0){
        flag++;
        [certifyNameArray addObject: @"电子邮箱"];
    }
    if([memberObj profession]){
        flag++;
        [certifyNameArray addObject: @"职业认证"];
    }
    flag += [[memberObj certificates] count];
    for(CertificateClass *certify in [memberObj certificates]){
        [certifyNameArray addObject: [certify certificateType]];
    }
    for(NSInteger i = 0; i < flag; i++){
        UIView *tmpView = [[UIView alloc] initWithFrame: CGRectMake(0.0f, i * (BASE_HEIGHT + 1.0f) + origin_y, mainView.frame.size.width, BASE_HEIGHT)];
        [tmpView setBackgroundColor: [UIColor whiteColor]];
        [mainView addSubview: tmpView];
        //文字
        XZJ_CustomLabel *tmpLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(10.0f, 0.0f, tmpView.frame.size.width - BASE_HEIGHT * 2, BASE_HEIGHT)];
        [tmpLabel setFont: [UIFont systemFontOfSize: 15.0f]];
        [tmpLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#4d4e4f"]];
        [tmpLabel setText: [certifyNameArray objectAtIndex: i]];
        [tmpView addSubview: tmpLabel];
        //图标
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame: CGRectMake(tmpView.frame.size.width - BASE_HEIGHT, BASE_HEIGHT / 4.0f, BASE_HEIGHT / 2.0f, BASE_HEIGHT / 3.0f)];
        [iconImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"icon_certify" ofType: @"png"]]];
        [iconImageView setContentMode: UIViewContentModeScaleAspectFit];
        [tmpView addSubview: iconImageView];
        ///分割线
        UIView *lineVIew = [[UIView alloc] initWithFrame: CGRectMake(10.0f, tmpView.frame.size.height + tmpView.frame.origin.y, mainView.frame.size.width - 20.0f, 1.0f)];
        [lineVIew setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#f4f5f6"]];
        [mainView addSubview: lineVIew];
    }
    origin_y += flag * (BASE_HEIGHT + 1.0f) + 10.0f;
    ///
    frame.size.height = origin_y;
    [mainView setFrame: frame];
    
    ///加载猎人的其他旅游地点
    origin_y = mainView.frame.origin.y + origin_y + 10.0f;
    if(!mainHunterOtherServiceView){
        mainHunterOtherServiceView= [[AppointHunterServiceView alloc] initWithFrame: CGRectMake(0.0f, origin_y, curScreenSize.width, OTHER_VIEW_HEIGHT) service: mainService];
        [mainScrollView addSubview: mainHunterOtherServiceView];
    }
    [mainScrollView setContentSize: CGSizeMake(curScreenSize.width, mainHunterOtherServiceView.frame.origin.y + OTHER_VIEW_HEIGHT)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
