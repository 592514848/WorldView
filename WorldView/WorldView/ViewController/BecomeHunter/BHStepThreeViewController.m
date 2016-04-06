//
//  BHStepThreeViewController.m
//  WorldView
//
//  Created by WorldView on 15/11/30.
//  Copyright © 2015年 XZJ. All rights reserved.
//
#define ICON_IMAGEVIEW_HEIGHT 120.0f
#import "BHStepThreeViewController.h"
#import "BHStepFourViewController.h"

@implementation BHStepThreeViewController
@synthesize memberObj;
- (void)viewWillAppear:(BOOL)animated
{
    ///获取用户个人资料
    memberObj = [[MemberObject alloc] init];
    [memberObj setMemberId: [memberDictionary objectForKey: @"id"]];
    [memberObj setXDelegate: self];
    [memberObj getMemberDetails];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadMainView];
}

- (void)MemberObject_GetMemberDetails:(BOOL)success infoDictionarys:(NSDictionary *)infoDictionary
{
    BOOL isUpload = NO;
    for(NSInteger i = 0; i < [certificateArray  count]; i++){
        isUpload = NO;
        for(CertificateClass *certificate in [memberObj certificates]){
            if([[certificate certificateType] integerValue] - 1 == i)
                isUpload = YES;
        }
        NSString *path = (isUpload ? [NSString stringWithFormat: @"bh_item%ld_done",(long)i]: [NSString stringWithFormat: @"bh_item%ld_not",(long)i]);
        [[certificateArray objectAtIndex: i] setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: path ofType: @"png"]]];
    }
}

- (void)loadMainView
{
    [self setTitle:@"成为猎人"];
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, curScreenSize.width, curScreenSize.height)];
    [mainScrollView setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#f1f1f2"]];
    [self.view addSubview: mainScrollView];
    ///1.证件
    CGFloat origin_y = 25.0f;
    CGFloat size_w = ([[UIScreen mainScreen] bounds].size.width  - 100.0f) / 3.0f;
    certificateArray = [NSMutableArray arrayWithCapacity: 6];
    for(NSInteger i = 0; i < 6; i++){
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame: CGRectMake(25.0f + (i % 3) * (size_w + 25.0f), (i / 3) * (30.0f + ICON_IMAGEVIEW_HEIGHT) + origin_y, size_w, ICON_IMAGEVIEW_HEIGHT)];
        [iconImageView setContentMode: UIViewContentModeScaleAspectFit];
        [mainScrollView addSubview: iconImageView];
        if(i % 3 == 2){
            UIView *lineView = [[UIView alloc] initWithFrame: CGRectMake(15.0f, iconImageView.frame.size.height + iconImageView.frame.origin.y + 15.0f, curScreenSize.width - 30.0f, 1.0f)];
            [lineView setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#e7a6ac"]];
            [mainScrollView addSubview: lineView];
        }
        ///
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(nextStepClick:)];
        [iconImageView setTag: i];
        [iconImageView setUserInteractionEnabled: YES];
        [iconImageView addGestureRecognizer: tap];
        [certificateArray addObject: iconImageView];
    }
    ///2.提示
    XZJ_CustomLabel *titleLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(10.0f, curScreenSize.height - 120.0f, curScreenSize.width - 20.0f, 20.0f)];
    [titleLabel setFont: [UIFont systemFontOfSize: 15.0f]];
    [titleLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#484749"]];
    [titleLabel setText: @"*温馨提示："];
    [mainScrollView addSubview: titleLabel];
    origin_y = titleLabel.frame.size.height + titleLabel.frame.origin.y + 5.0f;
    XZJ_CustomLabel *contentLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(10.0f, origin_y, curScreenSize.width - 20.0f, curScreenSize.height - origin_y - 20.0f)];
    [contentLabel setFont: [UIFont systemFontOfSize: 14.0f]];
    [contentLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#5c5c5d"]];
    [contentLabel setText: @"    请上传以上任意一项证件已证明您的身份，我们在收到申请后会及时与您联系；审核通过后，您就可以成为猎人带领世界各地的朋友玩耍。"];
    [contentLabel setNumberOfLines: 0];
    [contentLabel setLineBreakMode: NSLineBreakByCharWrapping];
    [mainScrollView addSubview: contentLabel];
}

- (void)nextStepClick:(UITapGestureRecognizer *)sender
{
    BHStepFourViewController *stepVC = [[BHStepFourViewController alloc] init];
    switch ([sender.view tag]) {
        case 0:
            [stepVC setUploadType: kPassport_Type];
            break;
        case 1:
            [stepVC setUploadType: kIdCard_type];
            break;
        case 2:
            [stepVC setUploadType: kDrivingLicense_Type];
            break;
        case 3:
            [stepVC setUploadType: kTourGuide_Type];
            break;
        case 4:
            [stepVC setUploadType: kStuCard_Type];
            break;
        case 5:
            [stepVC setUploadType: kWorkCertificate_Type];
            break;
        default:
            break;
    }
    if([[memberObj certificates] count] > [sender.view tag]){
        [stepVC setCertificate: [[memberObj certificates] objectAtIndex: [sender.view tag]]];
    }
    [self.navigationController pushViewController: stepVC animated: YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
