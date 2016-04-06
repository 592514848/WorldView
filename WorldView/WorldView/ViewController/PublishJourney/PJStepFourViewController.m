//
//  PJStepFourViewController.m
//  WorldView
//
//  Created by XZJ on 11/6/15.
//  Copyright © 2015 XZJ. All rights reserved.
//
#define STEP_IMAGEVIEW_HEIGHT 15.0F
#define TITLE_LABEL_HEIGHT 40.0F
#define MARGIN_LEFT 15.0F
#define SERVICE_HEIGHT 30.0F
#define BUTTON_HEIGHT 35.0F
#define BUTTON_WIDTH 100.0F
#import "PJStepFourViewController.h"
#import "PJStepFiveViewController.h"

@implementation PJStepFourViewController
@synthesize selectedAddtionalServiceArray, selectedPolicyArray, mainService;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle: @"发布旅程"];
    ///1.获取服务列表
    serviceObj = [[ServiceObject alloc] init];
    [serviceObj setXDelegate: self];
    [serviceObj getAddtionalServiceList];
}

- (void)serviceObject_GetAddtionalServiceList:(NSArray *)dataArray
{
    addtionalServiceArray = dataArray;
    selectedAddtionalServiceArray = [NSMutableArray arrayWithCapacity: [addtionalServiceArray count]];
    ///获取政策列表
    [serviceObj getPolicyList];
}

- (void)serviceObject_GetPolicyList:(NSArray *)dataArray
{
    selectedPolicyArray = [NSMutableArray arrayWithCapacity: [dataArray count]];
    policyArray = dataArray;
    [self loadMainView];
}

- (void)loadMainView
{
    ///2.主滚动视图
    CGFloat origin_y = STEP_IMAGEVIEW_HEIGHT + 20.0f;
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0.0f, origin_y, curScreenSize.width, curScreenSize.height - origin_y)];
    [mainScrollView setBackgroundColor: [UIColor clearColor]];
    [mainScrollView setShowsVerticalScrollIndicator: NO];
    [self.view addSubview: mainScrollView];
    
    ///3.类型的选项
    NSArray *dataArray = [NSArray arrayWithObjects: addtionalServiceArray, policyArray, nil];
    origin_y = 0.0f;
    CGFloat origin_x = 0.0f;
    serviceImageViewArray = [[NSMutableArray alloc] init];
    NSInteger flag = 0;
    NSArray *addtionArray = [NSArray array];
    NSArray *tmpPolicyArray = [NSArray array];
    if(mainService){
        addtionArray = [[mainService addtionalServicesIds] componentsSeparatedByString: @","];
        tmpPolicyArray = [[mainService policyIds] componentsSeparatedByString: @","];
    }
    for(NSInteger i = 0 ;i < [dataArray count]; i++){
        ///4.服务名称
        XZJ_CustomLabel *titleLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(MARGIN_LEFT, origin_y, mainScrollView.frame.size.width - 20.0f, TITLE_LABEL_HEIGHT)];
        if(i == 0)
            [titleLabel setText: @"附加服务："];
        else
            [titleLabel setText: @"附加政策："];
        [titleLabel setFont: [UIFont boldSystemFontOfSize: 15.0f]];
        [mainScrollView addSubview: titleLabel];
        ////5.选项内容
        origin_y = titleLabel.frame.size.height + titleLabel.frame.origin.y;
        NSArray *subArray = [dataArray objectAtIndex: i];
        for (NSInteger j = 0; j < [subArray count]; j++) {
            UIView *tempView = [[UIView alloc] initWithFrame: CGRectMake(MARGIN_LEFT, origin_y, titleLabel.frame.size.width, SERVICE_HEIGHT)];
            [tempView setUserInteractionEnabled:YES];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(onCheckedType:)];
            [tempView addGestureRecognizer: tap];
            [tempView setTag: flag++];
            [mainScrollView addSubview: tempView];
            origin_y += SERVICE_HEIGHT;
            ///复选框
            UIImageView *tempImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0.0f, 8.0f, SERVICE_HEIGHT - 16.0f, SERVICE_HEIGHT - 16.0f)];
            [tempImageView setContentMode: UIViewContentModeScaleAspectFit];
            [tempImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"selection_none" ofType:@"png"]]];
            [tempImageView setTag: 0];//默认都是0，表示没有被选中
            [tempView addSubview: tempImageView];
            [serviceImageViewArray addObject: tempImageView];
            ///名称
            origin_x = tempImageView.frame.size.width + tempImageView.frame.origin.x + 5.0f;
            XZJ_CustomLabel *nameLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x, 0.0f, titleLabel.frame.size.width - origin_x, SERVICE_HEIGHT)];
            if(i == 0){
                AdditionalServiceClass *addtional = [subArray objectAtIndex: j];
                [nameLabel setText: [addtional name]];
                if([addtionArray containsObject: LONG_PASER_TOSTRING([addtional addtionalServiceId])]){
                    [tempImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"selection_checked" ofType:@"png"]]];
                    [tempImageView setTag: 1];
                    [selectedAddtionalServiceArray addObject: addtional];
                }
            }
            else{
                PolicyClass *policy = [subArray objectAtIndex: j];
                [nameLabel setText: [policy name]];
                if([tmpPolicyArray containsObject: LONG_PASER_TOSTRING([policy policyId])]){
                    [tempImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"selection_checked" ofType:@"png"]]];
                    [tempImageView setTag: 1];
                    [selectedPolicyArray addObject: policy];
                }
            }
            [nameLabel setAdjustsFontSizeToFitWidth: YES];
            [nameLabel setFont: [UIFont systemFontOfSize: 12.0f]];
            [nameLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#5e5f60"]];
            [tempView addSubview: nameLabel];
        }
        ///6.虚线
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame: CGRectMake(titleLabel.frame.origin.x, origin_y, mainScrollView.frame.size.width - 2 * titleLabel.frame.origin.x, 1.0f)];
        [lineImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"pot_line" ofType: @"png"]]];
        [mainScrollView addSubview: lineImageView];
        origin_y += lineImageView.frame.size.height;
    }
    
    ///4.上一步按钮
    origin_y += 15.0f;
    CGFloat margin = (curScreenSize.width - 2 * BUTTON_WIDTH) / 3.0f;
    UIButton *lastStepButton = [[UIButton alloc] initWithFrame: CGRectMake(margin, origin_y, BUTTON_WIDTH, BUTTON_HEIGHT)];
    [lastStepButton setBackgroundColor: [UIColor whiteColor]];
    [lastStepButton setTitleColor: [applicationClass methodOfTurnToUIColor: @"#ef5052"] forState: UIControlStateNormal];
    [lastStepButton setTitle: @"上一步" forState: UIControlStateNormal];
    [lastStepButton.layer setCornerRadius: 3.0f];
    [lastStepButton.titleLabel setFont: [UIFont systemFontOfSize: 14.0f]];
    [lastStepButton.layer setBorderWidth: 0.5f];
    [lastStepButton setTag: 0];
    [lastStepButton.layer setBorderColor:[applicationClass methodOfTurnToUIColor: @"#ef5052"].CGColor];
    [lastStepButton addTarget:self action: @selector(stepButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview: lastStepButton];
    
    ///5.下一步按钮
    origin_x = 2 * margin + BUTTON_WIDTH;
    UIButton *nextStepButton = [[UIButton alloc] initWithFrame: CGRectMake(origin_x, origin_y , BUTTON_WIDTH, BUTTON_HEIGHT)];
    [nextStepButton setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#ef5052"]];
    [nextStepButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    [nextStepButton setTitle: @"下一步" forState: UIControlStateNormal];
    [nextStepButton.layer setCornerRadius: 3.0f];
    [nextStepButton.titleLabel setFont: [UIFont systemFontOfSize: 14.0f]];
    [nextStepButton setTag: 1];
    [nextStepButton addTarget:self action: @selector(stepButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview: nextStepButton];
    
    ///18.调整滚动视图的contentSize
    CGFloat size_h = nextStepButton.frame.size.height + nextStepButton.frame.origin.y + 20.0f;
    size_h = (size_h > curScreenSize.height ? size_h : curScreenSize.height + 20.0f);
    [mainScrollView setContentSize: CGSizeMake(curScreenSize.width, size_h)];
}

#pragma mark -
#pragma mark 复选框事件
- (void)onCheckedType:(UITapGestureRecognizer *)sender
{
    ///1.选中的值
    if([sender.view tag] < [addtionalServiceArray count]){
        ///选中的是附加服务
        AdditionalServiceClass *addtionalService = [addtionalServiceArray objectAtIndex: [sender.view tag]];
        if([selectedAddtionalServiceArray containsObject: addtionalService]){
            [selectedAddtionalServiceArray removeObject: addtionalService];
        }
        else{
            [selectedAddtionalServiceArray addObject: addtionalService];
        }
    }
    else{
        NSInteger index = [sender.view tag] - [addtionalServiceArray count];
        PolicyClass *addtionalService = [policyArray objectAtIndex: index];
        if([selectedPolicyArray containsObject: addtionalService]){
            [selectedPolicyArray removeObject: addtionalService];
        }
        else{
            [selectedPolicyArray addObject: addtionalService];
        }
    }
    ///2.更新选中样式
    UIImageView *tempImageView = [serviceImageViewArray objectAtIndex: [sender.view tag]];
    if([tempImageView tag] == 0){
        [tempImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"selection_checked" ofType: @"png"]]];
        [tempImageView setTag: 1];
    }
    else{
        [tempImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"selection_none" ofType: @"png"]]];
        [tempImageView setTag: 0];
    }
    [serviceImageViewArray setObject: tempImageView atIndexedSubscript: [sender.view tag]];
}

#pragma mark -
#pragma mark 步骤按钮点击事件
- (void)stepButtonClick:(UIButton *)sender
{
    switch ([sender tag]) {
        case 0:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName: @"PagerViewControllerGoToLast" object: nil];
            break;
        }
        case 1:{
            [[NSNotificationCenter defaultCenter] postNotificationName: @"PagerViewControllerGoToNext" object: nil];
            break;
        }
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
