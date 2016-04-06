//
//  PrivateMessageListViewController.m
//  WorldView
//
//  Created by XZJ on 11/2/15.
//  Copyright © 2015 XZJ. All rights reserved.
//

#define HEADER_HEIGHT 10.0F
#define CELL_HEIGHT 120.0F
#import "PrivateMessageListViewController.h"
#import "PrivateMessageTableViewCell.h"
#import "PrivateMessageDetailsViewController.h"

@implementation PrivateMessageListViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    ///获取私信列表
    if(isLogin){
        if(!messageObj){
            messageObj = [[MessageObject alloc] init];
            [messageObj setXDelegate: self];
        }
        [messageObj getMessageList: LONG_PASER_TOSTRING([memberDictionary objectForKey: @"id"])];
    }
    else{
        [applicationClass methodOfAlterThenDisAppear: @"您还未登录"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle: @"私信"];
}
#pragma mark -
#pragma mark 
- (void)messageObjectDelegate_GetMessageLsit:(NSArray *)dataArray
{
    if([[messageObj page] currentOperate] == kOperate_LoadMore){
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange: NSMakeRange([messageArray count], ([dataArray count]))];
        [messageArray addObjectsFromArray: dataArray];
        [mainTableView insertSections: set];
        [mainTableView updateViewSize: CGSizeMake(curScreenSize.width, [messageArray count] * (HEADER_HEIGHT + CELL_HEIGHT)) showFooter: YES];
    }
    else{
        messageArray = [NSMutableArray arrayWithArray: dataArray];
        [self loadMainTableView];
    }
}

#pragma mark -
#pragma mark 加载私信列表
- (void)loadMainTableView
{
    if(!mainTableView){
        [self.view setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#eff0f1"]];
        mainTableView = [[XZJ_EGOTableView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, curScreenSize.width, curScreenSize.height)];
        [mainTableView setXDelegate: self];
        [mainTableView setTableViewFooterView];
        [mainTableView setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#eff0f1"]];
        //    [mainTableView.tableView setScrollEnabled: NO];
        [self.view addSubview: mainTableView];
    }
    else
        [mainTableView reloadData];
    if([messageArray count] > 0)
        [mainTableView updateViewSize: CGSizeMake(mainTableView.frame.size.width, [messageArray count] * (HEADER_HEIGHT + CELL_HEIGHT)) showFooter: YES];
    else
        [applicationClass methodOfShowTipInView: mainTableView text: @"暂无数据"];
}

#pragma mark XZJ_EGOTableView委托
- (NSInteger)numberOfSectionsIn_XZJ_EGOTableView:(UITableView *)_tableView
{
    return [messageArray count];
}

- (NSInteger)XZJ_EGOTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)XZJ_EGOTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PrivateMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"ListCell"];
    if(!cell){
        cell = [[PrivateMessageTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"ListCell" size: CGSizeMake(tableView.frame.size.width, CELL_HEIGHT)];
    }
    MessageClass *message = [messageArray objectAtIndex: [indexPath section]];
    [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
    [cell setPhotoImage: IMAGE_URL([[message sendMember] memberPhoto]) sex: [[message sendMember] memberSex]];
    [cell setTimeSpan: [message addTime]];
    if([message sendMember])
        [cell.nameLabel setText: [NSString stringWithFormat: @"%@ %@", [[message sendMember] nickName_EN], [[message sendMember] nickName]]];
    [cell.titleLabel setText: [message messageTitle]];
    [cell.contentLabel setText: [message messageContent]];
    [cell setReadStatus: [message isRead]];
    return cell;
}

- (CGFloat)XZJ_EGOTableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADER_HEIGHT;
}

- (CGFloat)XZJ_EGOTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (UIView *)XZJ_EGOTableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor: [UIColor clearColor]];
    return view;
}

- (void)XZJ_EGOTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageClass *message = [messageArray objectAtIndex: [indexPath section]];
    ////1.跟新私信阅读状态
    if(![message isRead]){
        [messageObj UpdateMessageReadStatus: [message messageId]];
    }
    ////
    PrivateMessageDetailsViewController *detailsVC = [[PrivateMessageDetailsViewController alloc] init];
    
    [detailsVC setMainMessage: message];
    [self.navigationController pushViewController: detailsVC animated: YES];
}

- (void)XZJ_EGOTableViewDidRefreshData
{
    [[messageObj page] refresh];
    [messageObj getMessageList: LONG_PASER_TOSTRING([memberDictionary objectForKey: @"id"])];
    
}

- (void)XZJ_EGOTableViewDidLoadMoreData
{
    if(![[messageObj page] loadMore]){
        [applicationClass methodOfAlterThenDisAppear: @"没有更多了噢～"];
        return;
    }
    else
        [messageObj getMessageList: LONG_PASER_TOSTRING([memberDictionary objectForKey: @"id"])];
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
