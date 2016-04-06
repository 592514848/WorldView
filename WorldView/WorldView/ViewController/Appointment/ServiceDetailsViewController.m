//
//  ServiceDetailsViewController.m
//  WorldView
//
//  Created by WorldView on 15/12/8.
//  Copyright © 2015年 XZJ. All rights reserved.
//
#define CONTENT_IMAGE_HEIGHT 150.0f
#import "ServiceDetailsViewController.h"
@implementation ServiceDetailsViewController
@synthesize mainService;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadMainView];
}

- (void)loadMainView
{
    ///1.滚动视图
    UIScrollView *mainScrollView =[[UIScrollView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, curScreenSize.width, curScreenSize.height)];
    [mainScrollView setBackgroundColor: [UIColor whiteColor]];
    [mainScrollView setShowsVerticalScrollIndicator: NO];
    [self.view addSubview: mainScrollView];
    ///2.旅程详情
    CGFloat origin_y = 15.0f;
    if([mainService detailImgDesc]){
        NSString *responsedString = [[mainService detailImgDesc] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSArray *imageTextArray = [responsedString objectFromJSONStringWithParseOptions: JKParseOptionLooseUnicode];
        for(NSInteger i = 0; i < [imageTextArray count]; i++)
        {
            NSDictionary *tempDictionary = [imageTextArray objectAtIndex: i];
            ////文字
            CGRect labelFrame = CGRectMake(10.0f, origin_y, curScreenSize.width - 20.0f, 20.0f);
            UILabel *tmpLabel = [[UILabel alloc] initWithFrame: labelFrame];
            [tmpLabel setText: [tempDictionary objectForKey: @"desc"]];
            [tmpLabel setNumberOfLines: 0];
            [tmpLabel setLineBreakMode: NSLineBreakByTruncatingTail];
            [tmpLabel setFont: [UIFont systemFontOfSize: 12.0f]];
            [tmpLabel setTextColor: [applicationClass methodOfTurnToUIColor:@"#7a7a7a"]];
            [mainScrollView addSubview: tmpLabel];
            labelFrame.size.height = [applicationClass methodOfGetLabelSize: tmpLabel].height;
            [tmpLabel setFrame:labelFrame];
            ////图片
            origin_y = tmpLabel.frame.size.height + tmpLabel.frame.origin.y + 10.0f;
            UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame: CGRectMake(10.0f, origin_y, curScreenSize.width - 20.0f, CONTENT_IMAGE_HEIGHT)];
            [tmpImageView setImageWithURL: IMAGE_URL([tempDictionary objectForKey: @"url"]) placeholderImage: [UIImage imageNamed: @"default.png"]];
            [tmpImageView setContentMode: UIViewContentModeScaleAspectFill];
            [tmpImageView.layer setMasksToBounds: YES];
            [mainScrollView addSubview: tmpImageView];
            origin_y += CONTENT_IMAGE_HEIGHT + 10.0f;
        }
        [mainScrollView setContentSize: CGSizeMake(curScreenSize.width, origin_y)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
