//
//  AppointmentViewController.m
//  WorldView
//
//  Created by XZJ on 11/10/15.
//  Copyright © 2015 XZJ. All rights reserved.
//
#define BOTTOM_VIEW_HEIGHT 50.0f
#define MARGIN_LEFT 15.0F
#define HUNTER_INFO_HEIGHT 410.0f
#define TRAVEL_VIEW_HEIGHT 400.0f
#define MEETPLACE_VIEW_HEIGHT 240.0f
#define EVALUTION_VIEW_HEIGHT 380.0f
#define OTHER_VIEW_HEIGHT 320.0f
#define RECOMMON_VIEW_HEIGHT 620.0f
#define LEAVEIMAGE_VIEW_HEIGHT 40.0F

#import "AppointmentViewController.h"
@implementation AppointmentViewController
@synthesize serviceID;
- (void)viewDidLoad {
    [super viewDidLoad];
    ////请求服务详情
    serviceObj = [[ServiceObject alloc] init];
    [serviceObj setXDelegate: self];
    [serviceObj getServiceDetails: serviceID];
}

#pragma mark -
#pragma mark serviceObject委托
- (void)serviceObject_ServiceDetails:(ServiceClass *)service
{
    mainService = service;
    [self loadMainView];
    [self loadBottomView];
}

#pragma mark -
#pragma mark 加载底部视图
- (void)loadBottomView
{
    ///1.底部住视图
    UIView *bottomView = [[UIView alloc] initWithFrame: CGRectMake(0.0f, curScreenSize.height - BOTTOM_VIEW_HEIGHT, curScreenSize.width, BOTTOM_VIEW_HEIGHT)];
    [bottomView setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#ff3546"]];
    [self.view addSubview: bottomView];
    
    ///2.价格
    XZJ_CustomLabel *priceLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(40.0f, 0.0f, bottomView.frame.size.width / 2.0f - 40.0f, BOTTOM_VIEW_HEIGHT)];
    [priceLabel setTextColor: [UIColor whiteColor]];
    NSMutableAttributedString *attributteString = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat: @"$%@/人", [mainService unitPrice]]];
    [attributteString addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize: 10.0f] range: NSMakeRange(0, 1)];
    [attributteString addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize: 15.0f] range: NSMakeRange(1, [LONG_PASER_TOSTRING([mainService unitPrice]) length])];
    [attributteString addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize: 10.0f] range: NSMakeRange([LONG_PASER_TOSTRING([mainService unitPrice]) length] + 1, 2)];
    [priceLabel setAttributedText: attributteString];
    [bottomView addSubview: priceLabel];
    
    ///3.预约按钮
    UIButton *appointButton = [[UIButton alloc] initWithFrame: CGRectMake(bottomView.frame.size.width - 120.0f, 10.0f, 80.0f, BOTTOM_VIEW_HEIGHT - 20.0f)];
    [appointButton setTitle: @"立即预约" forState: UIControlStateNormal];
    [appointButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    [appointButton.titleLabel setFont: [UIFont systemFontOfSize: 13.0f]];
    [appointButton addTarget: self action: @selector(appointButtonClick) forControlEvents: UIControlEventTouchUpInside];
    [appointButton.layer setCornerRadius: 3.0f];
    [appointButton.layer setBorderWidth: 0.5f];
    [appointButton.layer setBorderColor: [UIColor whiteColor].CGColor];
    [bottomView addSubview: appointButton];
}

#pragma mark -
#pragma mark 加载主视图
- (void)loadMainView
{
    ///1.主视图
    mainScrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, curScreenSize.width, curScreenSize.height - BOTTOM_VIEW_HEIGHT)];
    [mainScrollView setShowsVerticalScrollIndicator: NO];
    [mainScrollView setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#f0f0f0"]];
    [self.view addSubview: mainScrollView];
    ///加载猎人详情的视图
    if(!mainHunterInfoView){
        mainHunterInfoView = [[AppointHunterInfoView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, curScreenSize.width, HUNTER_INFO_HEIGHT) service: mainService];
        [mainHunterInfoView setSuperViewController: self];
        [mainScrollView addSubview: mainHunterInfoView];
    }
    CGFloat origin_y = mainHunterInfoView.frame.size.height + mainHunterInfoView.frame.origin.y + 10.0f;
    ///加载旅程详情的视图
    if(!mainTravelDetailsView){
        mainTravelDetailsView = [[AppointTravelDetailsView alloc] initWithFrame: CGRectMake(0.0f, origin_y, curScreenSize.width, TRAVEL_VIEW_HEIGHT) service: mainService];
        [mainTravelDetailsView setViewController: self];
        [mainScrollView addSubview: mainTravelDetailsView];
    }
    ///加载见面地点的视图
    origin_y = mainTravelDetailsView.frame.size.height + mainTravelDetailsView.frame.origin.y + 10.0f;
    if(!mainMeetingPlaceView){
        mainMeetingPlaceView = [[AppointMeetingPlaceView alloc] initWithFrame: CGRectMake(0.0f, origin_y, curScreenSize.width, MEETPLACE_VIEW_HEIGHT) service: mainService];
        [mainScrollView addSubview: mainMeetingPlaceView];
    }
    ///用户评论视图
    origin_y = mainMeetingPlaceView.frame.origin.y + MEETPLACE_VIEW_HEIGHT + 10.0f;
    if(!mainEvalutionView){
        mainEvalutionView = [[AppointEvalutionView alloc] initWithFrame: CGRectMake(0.0f, origin_y, curScreenSize.width, EVALUTION_VIEW_HEIGHT) superViewController: self serviceID: [mainService serviceId]];
        [mainScrollView addSubview: mainEvalutionView];
    }
    ///加载猎人的其他旅游地点
    origin_y = mainEvalutionView.frame.size.height + mainEvalutionView.frame.origin.y + 10.0f;
    if(!mainHunterServiceView){
        mainHunterServiceView= [[AppointHunterServiceView alloc] initWithFrame: CGRectMake(0.0f, origin_y, curScreenSize.width, OTHER_VIEW_HEIGHT) service: mainService];
        [mainScrollView addSubview: mainHunterServiceView];
    }
    ///加载推荐视图
    origin_y = mainHunterServiceView.frame.size.height + mainHunterServiceView.frame.origin.y + 10.0f;
    if(!mainRecommonView){
        mainRecommonView = [[AppointRecommonView alloc] initWithFrame: CGRectMake(0.0f, origin_y, curScreenSize.width, RECOMMON_VIEW_HEIGHT ) service: mainService];
        [mainScrollView addSubview: mainRecommonView];
    }
    [mainScrollView setContentSize: CGSizeMake(curScreenSize.width, mainRecommonView.frame.size.height + mainRecommonView.frame.origin.y)];
    
    ///留言按钮
    UIImageView *levaeMessageImageView = [[UIImageView alloc] initWithFrame: CGRectMake(curScreenSize.width - LEAVEIMAGE_VIEW_HEIGHT, HUNTER_INFO_HEIGHT - 2 * LEAVEIMAGE_VIEW_HEIGHT, LEAVEIMAGE_VIEW_HEIGHT, LEAVEIMAGE_VIEW_HEIGHT)];
    [levaeMessageImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"leaving_message" ofType: @"png"]]];
    [levaeMessageImageView setContentMode: UIViewContentModeScaleAspectFit];
    [self.view addSubview: levaeMessageImageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(leaveMessageButtonClick)];
    [levaeMessageImageView setUserInteractionEnabled: YES];
    [levaeMessageImageView addGestureRecognizer: tap];
}

#pragma mark -
#pragma mark 预约按钮
- (void)appointButtonClick
{
    if(!mainAppointView)
    {
         mainAppointView = [[AppointMainView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, curScreenSize.width, curScreenSize.height + 64.0f) service: mainService];
        [[[UIApplication sharedApplication] keyWindow] addSubview: mainAppointView];
    }
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront: mainAppointView];
    [mainAppointView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark 留言
- (void)leaveMessageButtonClick
{
    SendMessageViewController *messageVC = [[SendMessageViewController alloc] init];
    [messageVC setServiceClass: mainService];
    [self.navigationController pushViewController: messageVC animated: YES];
}
@end
