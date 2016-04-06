//
//  SendMessageViewController.m
//  WorldView
//
//  Created by WorldView on 15/12/5.
//  Copyright © 2015年 XZJ. All rights reserved.
//
#define TEXTVIEW_HEIGHT 200.0f
#import "SendMessageViewController.h"
@implementation SendMessageViewController
@synthesize serviceClass;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle: @"留言"];
    messageObj = [[MessageObject alloc] init];
    [messageObj setXDelegate: self];
    [self loadNaviagationRight];
    [self loadMainView];
}

#pragma mark -
#pragma mark 加载确定按钮
- (void)loadNaviagationRight
{
    UIButton *button = [[UIButton alloc] initWithFrame: CGRectMake(0.0f, 0.0f, NAVIGATIONBAR_HEIGHT, NAVIGATIONBAR_HEIGHT)];
    [button setTitle: @"发送" forState: UIControlStateNormal];
    [button setTitleColor: [applicationClass methodOfTurnToUIColor: @"#5495fc"]forState: UIControlStateNormal];
    [button.titleLabel setFont: [UIFont systemFontOfSize: 13.0f]];
    [button addTarget: self action: @selector(confirmButtonClick) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView: button];
    [self.navigationItem setRightBarButtonItem: rightBarButton];
}

#pragma mark -
#pragma mark 主视图
- (void)loadMainView
{
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, curScreenSize.width, curScreenSize.height)];
    [mainScrollView setBackgroundColor: [UIColor whiteColor]];
    [mainScrollView setShowsVerticalScrollIndicator: NO];
    [self.view addSubview: mainScrollView];

    ///4.输入框
    contentTextView = [[UITextView alloc] initWithFrame: CGRectMake(10.0f,20.0f, curScreenSize.width - 20.0f, TEXTVIEW_HEIGHT)];
    [contentTextView setDelegate: self];
    [contentTextView setFont: [UIFont systemFontOfSize: 14.0F]];
    [contentTextView setTextColor: [[XZJ_ApplicationClass commonApplication] methodOfTurnToUIColor: @"#b2b3b4"]];
    [contentTextView setText: @"请留言..."];
    [contentTextView.layer setBorderColor: [[XZJ_ApplicationClass commonApplication] methodOfTurnToUIColor: @"#b2b3b4"].CGColor];
    [contentTextView.layer setBorderWidth: 0.5f];
    [contentTextView.layer setCornerRadius: 3.0f];
    [mainScrollView addSubview: contentTextView];
    
    ///4.字数
    CGFloat origin_y = TEXTVIEW_HEIGHT + contentTextView.frame.origin.y;
    fontNumberLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(10.0f, origin_y,curScreenSize.width - 20.0f, 20.0f)];
    [fontNumberLabel setFont: [UIFont systemFontOfSize: 12.0f]];
    [fontNumberLabel setTextAlignment: NSTextAlignmentRight];
    [fontNumberLabel setText: @"您还可以输入300个字"];
    [fontNumberLabel setTextColor: [[XZJ_ApplicationClass commonApplication] methodOfTurnToUIColor: @"#b5b6b7"]];
    [mainScrollView addSubview: fontNumberLabel];
    
    ///调整滚动视图
    [mainScrollView setContentSize: CGSizeMake(curScreenSize.width, origin_y + fontNumberLabel.frame.size.height + 20.0f)];
}

#pragma mark -
#pragma mark textView委托事件
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([[textView text] isEqualToString: @"请留言..."]){
        [textView setText: @""];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger fontNumber = [[textView text] length];
    if(fontNumber <= 300){
        [fontNumberLabel setText: [NSString stringWithFormat: @"您还可以输入%ld个字", (long)(300 - fontNumber)]];
        textViewText = [textView text];
    }
    else{
        [textView setText: textViewText];
    }
}

#pragma mark -
#pragma mark 完成按钮的点击
- (void)confirmButtonClick
{
    [messageObj sendMessage: [contentTextView text] sendMemberId: [memberDictionary objectForKey: @"id"] receiveMemberId: [[serviceClass member] memberId] serviceId: [serviceClass serviceId]];
}

- (void)messageObjectDelegate_DidSendMessageResult:(BOOL)success
{
    if(success){
        [applicationClass methodOfAlterThenDisAppear: @"留言成功"];
        [self.navigationController popViewControllerAnimated: YES];
    }
    else
        [applicationClass methodOfAlterThenDisAppear: @"留言失败"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
