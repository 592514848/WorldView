//
//  BecomeHunterViewController.m
//  WorldView
//
//  Created by WorldView on 15/11/30.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import "BHStepOneViewController.h"
#import "BHStepTwoViewController.h"

@implementation BHStepOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle: @"成为猎人"];
    [self loadMainView];
}

- (void)loadMainView
{
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, curScreenSize.width, curScreenSize.height)];
    [self.view addSubview: mainScrollView];
    
    ///1.地球
    UIImageView *ballImageView = [[UIImageView alloc] initWithFrame: CGRectMake(30.0f, 20.0f, curScreenSize.width - 60.0f, curScreenSize.height * 2.0f / 3.0f - 40.0f)];
    [ballImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"bh_icon_ball" ofType: @"png"]]];
    [ballImageView setContentMode: UIViewContentModeScaleAspectFill];
    [mainScrollView addSubview:ballImageView];
    
    ///2.左边的图片
    CGFloat origin_y = ballImageView.frame.size.height + ballImageView.frame.origin.y;
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0.0f, origin_y, 80.0f, 120.0f)];
    [leftImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"bh_left_icon" ofType: @"png"]]];
    [leftImageView setContentMode: UIViewContentModeScaleAspectFill];
    [mainScrollView addSubview: leftImageView];
    
    ///3.右边的图片
    origin_y = curScreenSize.height - 120.0f;
    UIImageView *rightImageView = [[UIImageView alloc] initWithFrame: CGRectMake(curScreenSize.width - 80.0f, origin_y, 80.0f, 120.0f)];
    [rightImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"bh_right_icon" ofType: @"png"]]];
    [rightImageView setContentMode: UIViewContentModeScaleAspectFill];
    [mainScrollView addSubview: rightImageView];
    
    ///4.成为猎人
    UIImageView *becomeHunterImageView = [[UIImageView alloc] initWithFrame: CGRectMake((curScreenSize.width - 180.0f) / 2.0f, curScreenSize.height - 160.0f, 180.0f, 80.0f)];
    [becomeHunterImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"bh_btn_hunter" ofType: @"png"]]];
    [becomeHunterImageView setContentMode: UIViewContentModeScaleAspectFit];
    [mainScrollView addSubview: becomeHunterImageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(becomeHunterImgaeViewClick)];
    [becomeHunterImageView setUserInteractionEnabled: YES];
    [becomeHunterImageView addGestureRecognizer: tap];
}

#pragma mark -
#pragma mark 成为猎人点击事件
- (void)becomeHunterImgaeViewClick
{
    BHStepTwoViewController *nextVC = [[BHStepTwoViewController alloc] init];
    [self.navigationController pushViewController: nextVC animated: YES];
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
