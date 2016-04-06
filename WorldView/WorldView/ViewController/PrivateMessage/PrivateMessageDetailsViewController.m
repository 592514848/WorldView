//
//  PrivateMessageDetailsViewController.m
//  WorldView
//
//  Created by WorldView on 15/11/14.
//  Copyright © 2015年 XZJ. All rights reserved.
//
#define SEND_VIEW_HEIGHT 60.0F
#define BASE_CELL_HEIGHT 100.0F
#define MESSAGE_MAX_WIDTH 200.0F
#import "PrivateMessageDetailsViewController.h"
#import "MessageDetailsTableViewCell.h"

@implementation PrivateMessageDetailsViewController
@synthesize mainMessage;
- (void)viewDidLoad {
    [super viewDidLoad];
    ///
    messageObj = [[MessageObject alloc] init];
    [messageObj setXDelegate: self];
    [messageObj getMessageHistoryList: [mainMessage messageId]];
    ///
    [self loadMainVeiw];
}

- (void)messageObjectDelegate_GetHistoryMessageLsit:(NSArray *)dataArray
{
    messageArray = [NSMutableArray arrayWithArray: [[dataArray reverseObjectEnumerator] allObjects]];
    [mainTableView reloadData];
    [mainTableView scrollToRowAtIndexPath: [NSIndexPath indexPathForRow: [messageArray count] - 1 inSection: 0] atScrollPosition:UITableViewScrollPositionBottom animated: YES];
}

- (void)loadMainVeiw
{
    ///1.留言主视图
    mainTableView = [[UITableView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, curScreenSize.width, curScreenSize.height - SEND_VIEW_HEIGHT)];
    [mainTableView setDelegate: self];
    [mainTableView setDataSource: self];
    [mainTableView setShowsVerticalScrollIndicator: NO];
    [mainTableView setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#eff0f1"]];
    [mainTableView setSeparatorStyle: UITableViewCellSeparatorStyleNone];
    UIView *footerView = [[UIView alloc] init];
    [footerView setBackgroundColor: [UIColor clearColor]];
    [mainTableView setTableFooterView: footerView];
    [self.view addSubview: mainTableView];
    ///
    UIView *bottomView = [[UIView alloc] initWithFrame: CGRectMake(0.0f, curScreenSize.height - SEND_VIEW_HEIGHT, curScreenSize.width, SEND_VIEW_HEIGHT)];
    [bottomView setBackgroundColor: [UIColor whiteColor]];
    [self.view addSubview: bottomView];
    
    ///2.logo图标
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame: CGRectMake(10.0f, 10.0f, bottomView.frame.size.height - 15.0f, bottomView.frame.size.height - 15.0f)];
    [logoImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"icon_send_logo" ofType: @"png"]]];
    [bottomView addSubview: logoImageView];
    
    ///3.输入框
    CGFloat origin_x = logoImageView.frame.size.width + logoImageView.frame.origin.x;
    sendTextFiled = [[UITextField alloc] initWithFrame: CGRectMake(origin_x, logoImageView.frame.origin.y + 10.0f, curScreenSize.width - 2 * origin_x, logoImageView.frame.size.height - 11.0f)];
    UIView *leftView = [[UIView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, 10.0f, sendTextFiled.frame.size.height)];
    [leftView setBackgroundColor: [UIColor clearColor]];
    [sendTextFiled setLeftViewMode: UITextFieldViewModeAlways];
    [sendTextFiled setLeftView: leftView];
    [sendTextFiled setFont: [UIFont systemFontOfSize: 14.0f]];
    [sendTextFiled setPlaceholder: @"点击回复"];
    [bottomView addSubview: sendTextFiled];
    
    ///5.下划线
    CGFloat origin_y = sendTextFiled.frame.size.height + sendTextFiled.frame.origin.y;
    UIView *lineView = [[UIView alloc] initWithFrame: CGRectMake(origin_x, origin_y, sendTextFiled.frame.size.width, 1.0f)];
    [lineView setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#ff6165"]];
    [bottomView addSubview: lineView];
    
    ///4.发送图标
    origin_x = sendTextFiled.frame.size.width + sendTextFiled.frame.origin.x;
    UIImageView *sendImageView= [[UIImageView alloc] initWithFrame: CGRectMake(origin_x, logoImageView.frame.origin.y, logoImageView.frame.size.width, logoImageView.frame.size.height)];
    [sendImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"icon_send" ofType: @"png"]]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(sendImageViewClick)];
    [sendImageView setUserInteractionEnabled: YES];
    [sendImageView addGestureRecognizer: tap];
    [bottomView addSubview: sendImageView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [messageArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"cell"];
    if(!cell){
        cell = [[MessageDetailsTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"Cell" size: CGSizeMake(tableView.frame.size.width, BASE_CELL_HEIGHT)];
    }
    MessageClass *message = [messageArray objectAtIndex: [indexPath row]];
    if([[[message sendMember] memberId] integerValue] == [ [memberDictionary objectForKey: @"id"] integerValue]){
        ///说明是回复内容
        [cell setReplyMessageContent: [message messageContent]];
    }
    else{
        [cell setLeaveMessageContent: [message messageContent]];
    }
    [cell setPhotoImage: IMAGE_URL([[message sendMember] memberPhoto]) sex: [[message sendMember] memberSex]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    XZJ_CustomLabel *contentLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(0.0f, 0.0f, MESSAGE_MAX_WIDTH, 60.0f)];
    MessageClass *message = [messageArray objectAtIndex: [indexPath row]];
    [contentLabel setText: [message messageContent]];
    CGSize size = [applicationClass methodOfGetLabelSize: contentLabel];
    return (size.height / 1.8f > BASE_CELL_HEIGHT ? size.height / 1.8f: BASE_CELL_HEIGHT);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *mainView = [[UIView alloc] init];
    [mainView setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#eff0f1"]];
    ///1.图标
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame: CGRectMake(80.0f, 5.0f, 20.0f, 20.0f)];
    [iconImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"icon_link" ofType: @"png"]]];
    [iconImageView setContentMode: UIViewContentModeScaleAspectFit];
    [mainView addSubview: iconImageView];
    ///2.标题
    CGFloat origin_x = iconImageView.frame.size.width + iconImageView.frame.origin.x + 5.0f;
    XZJ_CustomLabel *titleLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x, 0.0f, tableView.frame.size.width - origin_x - 40.0f, 30.0f)];
    [titleLabel setFont: [UIFont systemFontOfSize: 12.0f]];
    [titleLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#b3b4b5"]];
    [titleLabel setText: [mainMessage messageTitle]];
    [mainView addSubview: titleLabel];
    return mainView;
}

#pragma mark -
#pragma mark 发送按钮
- (void)sendImageViewClick
{
    [messageObj sendMessage: [sendTextFiled text] sendMemberId: [memberDictionary objectForKey: @"id"] receiveMemberId: [[mainMessage sendMember] memberId] serviceId: [mainMessage serviceId]];
    ///添加回复
    [mainTableView beginUpdates];
    NSArray *insertArray = [NSArray arrayWithObject: [NSIndexPath indexPathForRow: [messageArray count] inSection:0]];
    ///message
    MessageClass *message = [[MessageClass alloc] init];
    [message setMessageId: @""];
    [message setMessageContent: [sendTextFiled text]];
    [message setMessageTitle: [mainMessage messageTitle]];
    [message setServiceId: [mainMessage serviceId]];
    [message setAddTime: [NSDate date]];
    [message setIsRead: NO];
    [message setSendMember: [mainMessage receiveMember]];
    [message setReceiveMember: [mainMessage sendMember]];
    [messageArray addObject: message];
    ////
    [mainTableView insertRowsAtIndexPaths: insertArray withRowAnimation:UITableViewRowAnimationAutomatic];
    [mainTableView endUpdates];
    [mainTableView scrollToRowAtIndexPath: [NSIndexPath indexPathForRow: [messageArray count] - 1 inSection: 0] atScrollPosition:UITableViewScrollPositionBottom animated: YES];
}

#pragma mark -
#pragma mark messageObject委托
- (void)messageObjectDelegate_DidSendMessageResult:(BOOL)success
{
    if(success){
        [applicationClass methodOfAlterThenDisAppear: @"发送成功"];
        [sendTextFiled setText: @""];
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
