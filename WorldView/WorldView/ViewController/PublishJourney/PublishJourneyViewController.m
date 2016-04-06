//
//  PublishJourneyViewController.m
//  WorldView
//
//  Created by WorldView on 15/11/25.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import "PublishJourneyViewController.h"
#import "PJStepOneViewController.h"
#import "PJStepTwoViewController.h"
#import "PJStepThreeViewController.h"
#import "PJStepFourViewController.h"
#import "PJStepFiveViewController.h"
#import "PJStepSixViewController.h"
#import "PJStepSevenViewController.h"

@implementation PublishJourneyViewController
@synthesize mainService;
- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(gotoNextPage) name: @"PagerViewControllerGoToNext" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(gotoLastPage) name: @"PagerViewControllerGoToLast" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(publishSevice:) name: @"PublishService" object: nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name: @"PagerViewControllerGoToNext" object: nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name: @"PagerViewControllerGoToLast" object: nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name: @"PublishService" object: nil];
}

- (void)gotoNextPage
{
    [super selectPageWithIndex: [super activeContentIndex] + 1];
}

- (void)gotoLastPage
{
    [super selectPageWithIndex: [super activeContentIndex] - 1];
}

- (void)viewDidLoad {
    self.dataSource = self;
    self.delegate = self;
    [super viewDidLoad];
    [self setTitle:@"发布旅程"];
    if(!mainService)
        mainService = [[ServiceClass alloc] init];
    for(NSInteger i = 2; i < [[self contents] count]; i++){
        [[[self contents] objectAtIndex: i] setMainService: mainService];
    }
}

#pragma mark - PagerViewDataSource
- (NSUInteger)numberOfTabView
{
    return 7;
}

- (UIView *)viewPager:(PagerViewController *)viewPager viewForTabAtIndex:(NSUInteger)index
{
    UIView *view = [[UIView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, [[UIScreen mainScreen] bounds].size.width / 7.0f, 44.0f)];
    switch (index) {
        case 0:
        {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(view.frame.size.width / 2.0f - 10.0f, (view.frame.size.height - 10.0f) / 2.0f, 10.0f, 10.0f)];
            [imageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"blank_circle" ofType: @"png"]]];
            [imageView setTag: 1];
            [view addSubview: imageView];
            ///
            CGFloat origin_x = imageView.frame.size.width + imageView.frame.origin.x;
            UIView *lineView = [[UIView alloc] initWithFrame: CGRectMake(origin_x, (view.frame.size.height - 1.0f) / 2.0f, view.frame.size.width, 1.0f)];
            [lineView setBackgroundColor: [UIColor redColor]];
            [view addSubview: lineView];
            break;
        }
        case 6:
        {
            UIView *lineView = [[UIView alloc] initWithFrame: CGRectMake(0.0f, (view.frame.size.height - 1.0f) / 2.0f, view.frame.size.width / 2.0f + 10.0f, 1.0f)];
            [lineView setBackgroundColor: [UIColor redColor]];
            [view addSubview: lineView];
            //
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((view.frame.size.width - 10.0f) / 2.0f + 10.0f, (view.frame.size.height - 10.0f) / 2.0f, 10.0f, 10.0f)];
            [imageView setBackgroundColor: [UIColor whiteColor]];
            [imageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"blank_circle" ofType: @"png"]]];
            [imageView setTag: 1];
            [view addSubview: imageView];
            break;
        }
        default:
        {
            UIView *lineView = [[UIView alloc] initWithFrame: CGRectMake(0.0f, (view.frame.size.height - 1.0f) / 2.0f, view.frame.size.width, 1.0f)];
            [lineView setBackgroundColor: [UIColor redColor]];
            [view addSubview: lineView];
            ///
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((view.frame.size.width - 10.0f) / 2.0f, (view.frame.size.height - 10.0f) / 2.0f, 10.0f, 10.0f)];
            [imageView setBackgroundColor: [UIColor whiteColor]];
            [imageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"blank_circle" ofType: @"png"]]];
            [imageView setTag: 1];
            [view addSubview: imageView];
            break;
        }
    }
    return view;
}

- (UIViewController *)viewPager:(PagerViewController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index
{
    switch (index) {
        case 0:
        {
            PJStepOneViewController *contentVC = [[PJStepOneViewController alloc] init];
            return contentVC;
        }
        case 1:
        {
            PJStepTwoViewController *contentVC = [[PJStepTwoViewController alloc] init];
            return contentVC;
        }
        case 2:
        {
            PJStepThreeViewController *contentVC = [[PJStepThreeViewController alloc] init];
            return contentVC;
        }
        case 3:
        {
            PJStepFourViewController *contentVC = [[PJStepFourViewController alloc] init];
            return contentVC;
        }
        case 4:
        {
            PJStepFiveViewController *contentVC = [[PJStepFiveViewController alloc] init];
            return contentVC;
        }
        case 5:
        {
            PJStepSixViewController *contentVC = [[PJStepSixViewController alloc] init];
            return contentVC;
        }
        case 6:
        {
            PJStepSevenViewController *contentVC = [[PJStepSevenViewController alloc] init];
            return contentVC;
        }
        default:
            return nil;
    }
}

- (NSInteger)widthOfTabView
{
    return [[UIScreen mainScreen] bounds].size.width / 7.0f;
}

#pragma mark - PagerViewDelegate
- (void)viewPager:(PagerViewController *)viewPager didSwitchAtIndex:(NSInteger)index withTabs:(NSArray *)tabs
{
    NSLog(@"%ld", (long)index);
    [UIView animateWithDuration:0.1
                     animations:^{
                         for (UIView *view in self.tabs) {
                             for(UIView *subView in [view subviews]){
                                 if([subView isKindOfClass: [UIImageView class]]){
                                     if (index == view.tag) {
                                         [(UIImageView *)subView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"full_circle" ofType: @"png"]]];
                                     } else {
                                         [(UIImageView *)subView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"blank_circle" ofType: @"png"]]];
                                     }
                                 }
                             }
                         }
                     }
                     completion:^(BOOL finished){}];
    
    switch (index) {
        case 0:
        {
            PJStepOneViewController *vc = [[self contents] objectAtIndex: index];
            if([mainService joinNum] == 0)
                [[vc numberTextfiled] setText: @"1"];
            else
                [[vc numberTextfiled] setText: _LONG_PASER_TOSTRING([mainService joinNum])];
            [vc setSelectedServiceTypeId: [mainService serivceTypeId]];
            [vc setSelectedCountryId: [mainService countryId]];
            [[vc timeSizeTextfiled] setText: [mainService serviceTimeSize]];
            break;
        }
        case 1:
        {
            PJStepTwoViewController *vc = [[self contents] objectAtIndex: index];
            [[vc titleTextField] setText: [mainService serviceTitle]];
            [[vc subTitleTextField] setText: [mainService serviceSubTitle]];
            [[vc descriptionTextView] setText: [mainService serviceDescription]];
            break;
        }
        default:
            break;
    }
}

- (void)viewPager:(NSInteger)index previousViewController:(UIViewController *)previousViewController
{
    switch (index) {
        case 0:
        {
            PJStepOneViewController *viewController = (PJStepOneViewController *)previousViewController;
            MemberObject *memberObj = [[MemberObject alloc] init];
            NSDictionary *memberDictionary = [[XZJ_ApplicationClass commonApplication] methodOfReadLocal: @"LOCALUSER"];
            [memberObj setMemberId: [memberDictionary objectForKey:@"id"]];
            [mainService setMember: memberObj];
            [mainService setMaxJoinNum: [[viewController numberTextfiled] text]];
            [mainService setSerivceTypeId: [viewController selectedServiceTypeId]];
            [mainService setCountryId: [viewController selectedCountryId]];
            [mainService setServiceTimeSize: [[viewController timeSizeTextfiled] text]];
            break;
        }
        case 1:
        {
            PJStepTwoViewController *viewController = (PJStepTwoViewController *)previousViewController;
            [mainService setServiceTitle: [[viewController titleTextField] text]];
            [mainService setServiceSubTitle: [[viewController subTitleTextField] text]];
            [mainService setServiceDescription: [[viewController descriptionTextView] text]];
            break;
        }
        case 2:
        {
            PJStepThreeViewController *viewController = (PJStepThreeViewController *)previousViewController;
            [mainService setServiceTips: [[viewController remarksTextView] text]];
            NSMutableArray *travelLineArray = [NSMutableArray arrayWithCapacity: [[viewController travelLocationTextFiledArray] count]];
            for(UITextField *textFile in [viewController travelLocationTextFiledArray]){
                if(![[textFile text] isEqualToString: @""]){
                    [travelLineArray addObject: [textFile text]];
                }
            }
            [mainService setLineRoad: [travelLineArray componentsJoinedByString: @"-"]];
            [mainService setLongitude: [[NSNumber numberWithDouble: [viewController curLocationCoordinate].longitude] stringValue]];
            [mainService setLatitude: [[NSNumber numberWithDouble: [viewController curLocationCoordinate].latitude] stringValue]];
            break;
        }
        case 3:
        {
            PJStepFourViewController *viewController = (PJStepFourViewController *)previousViewController;
            NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity: [[viewController selectedAddtionalServiceArray] count]];
            for(AdditionalServiceClass *addtional in [viewController selectedAddtionalServiceArray]){
                [tmpArray addObject: [addtional addtionalServiceId]];
            }
            [mainService setAddtionalServicesIds: [tmpArray componentsJoinedByString: @","]];
            tmpArray = [NSMutableArray arrayWithCapacity: [[viewController selectedPolicyArray] count]];
            for(PolicyClass *policy in [viewController selectedPolicyArray]){
                [tmpArray addObject: [policy policyId]];
            }
            [mainService setPolicyIds: [tmpArray componentsJoinedByString: @","]];
            break;
        }
        case 4:
        {
            PJStepFiveViewController *viewController = (PJStepFiveViewController *)previousViewController;
            [mainService setUnitPrice: [[viewController unitPriceTextFiled] text]];
            [mainService setAddOnePrice: [[viewController addOnePriceTextFiled] text]];
            [mainService setPriceDesc: [[viewController pricedescTextView] text]];
            break;
        }
        case 5:
        {
            PJStepSixViewController *viewController = (PJStepSixViewController *)previousViewController;
            [mainService setMainImageUrl: [viewController serviceMainImagePath]];
            NSMutableString *json = [NSMutableString stringWithString: @"["];
            for(ImageTextView *view in [viewController imageTextViewArray]){
                if([[view mainImagePath] length] > 0)
                    [json appendFormat: @"{\\\"url\\\":\\\"%@\\\",\\\"desc\\\":\\\"%@\\\"},", [view mainImagePath], [[view contentTextView] text]];
            }
            json = [NSMutableString stringWithFormat: @"%@]",[json substringToIndex: [json length] - 1]];
            [mainService setDetailImgDesc: json];
            break;
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark 发布旅程
- (void)publishSevice:(NSNotification *) notification
{
    NSDictionary *timeDictionary = [notification userInfo];
    [mainService setTripOrderDates: [timeDictionary objectForKey: @"TripOrderDates"]];
    XZJ_ApplicationClass *applictionClass = [XZJ_ApplicationClass commonApplication];
    if(![mainService member]){
        [applictionClass methodOfShowAlert: @"当前账号信息错误，请重试"];
        return;
    }
    if(![mainService serivceTypeId]){
        [applictionClass methodOfShowAlert: @"请在第一步选择所属的旅程类型"];
        return;
    }
    if(![mainService countryId]){
        [applictionClass methodOfShowAlert: @"请在第一步选择您提供旅程的所在城市"];
        return;
    }
    if(![mainService serviceTitle]){
        [applictionClass methodOfShowAlert: @"请在第二步输入您此次旅程的标题"];
        return;
    }
    if(![mainService latitude] || ![mainService longitude]){
        [applictionClass methodOfShowAlert: @"请在第三步设置见面的地点"];
        return;
    }
    if(![mainService lineRoad]){
        [applictionClass methodOfShowAlert: @"请在第三步输入您此次旅程的线路"];
        return;
    }
    if(![mainService serviceTips]){
        [applictionClass methodOfShowAlert: @"请在第三步输入您此次旅程的tips"];
        return;
    }
    if(![mainService unitPrice]){
        [applictionClass methodOfShowAlert: @"请在第五步输入您此次旅程的费用"];
        return;
    }
    if(![mainService addOnePrice]){
        [applictionClass methodOfShowAlert: @"请在第五步输入您此次旅程增加一人的费用"];
        return;
    }
    if(![mainService mainImageUrl]){
        [applictionClass methodOfShowAlert: @"请在第六步选择您此次旅程的封面图片"];
        return;
    }
    if(![mainService detailImgDesc]){
        [applictionClass methodOfShowAlert: @"请在第六步编辑您此次旅程的详细介绍"];
        return;
    }
    if(![mainService tripOrderDates]){
        [applictionClass methodOfShowAlert: @"请在第七步添加您此次旅程可以预约的时间"];
        return;
    }
    ServiceObject *serviceObj = [[ServiceObject alloc] init];
    [serviceObj setXDelegate: self];
    [serviceObj publishService: mainService];
}

- (void)serviceObject_PublishService:(BOOL)success
{
    if(success){
        [[XZJ_ApplicationClass commonApplication] methodOfAlterThenDisAppear: @"发布成功"];
        [self.navigationController popToRootViewControllerAnimated: YES];
    }
    else{
        [[XZJ_ApplicationClass commonApplication] methodOfShowAlert: @"十分抱歉，发布失败，请稍候重试"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
