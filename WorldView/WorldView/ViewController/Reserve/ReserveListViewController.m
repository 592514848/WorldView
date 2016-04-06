//
//  ReserveListViewController.m
//  WorldView
//
//  Created by XZJ on 11/2/15.
//  Copyright © 2015 XZJ. All rights reserved.
//
#define PICKER_HEIGHT 45.0f
#define HEADER_HEIGHT 10.0F
#define CELL_HEIGHT 335.0F
#import "ReserveListViewController.h"

@implementation ReserveListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle: @"我收到的预定"];
    ///获取收到的预订列表
    orderObj = [[OrderObject alloc] init];
    [orderObj setXDelegate: self];
    //默认获取未处理的订单
    [orderObj getReceivedAllOrderList: LONG_PASER_TOSTRING([memberDictionary objectForKey: @"id"])];
    ///加载筛选栏
    [self loadPickerView];
}

#pragma mark -
#pragma mark 获取收到的预订列表
- (void)orderObject_GetReceivedAllOrderList:(NSArray *)dataArray
{
    orderArray = dataArray;
    [self loadMainTableView];
}

- (void)orderObject_GetRefuseOrderList:(NSArray *)dataArray
{
    orderArray = dataArray;
    [self loadMainTableView];
}

- (void)orderObject_GetAcceptOrderList:(NSArray *)dataArray
{
    orderArray = dataArray;
    [self loadMainTableView];
}

- (void)orderObject_GetCompeleteOrderList:(NSArray *)dataArray
{
    orderArray = dataArray;
    [self loadMainTableView];
}

#pragma mark -
#pragma mark 加载筛选视图
- (void)loadPickerView
{
    ////1.筛选视图的主视图
    pickereView = [[UIView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, curScreenSize.width, PICKER_HEIGHT)];
    [pickereView setBackgroundColor: [UIColor whiteColor]];
    [pickereView.layer setBorderColor: [applicationClass methodOfTurnToUIColor: @"#ea5357"].CGColor];
    [pickereView.layer setBorderWidth: 0.5f];
    [pickereView.layer setShadowOpacity: 0.2f];
    [pickereView.layer setShadowOffset: CGSizeMake(0.0f, 3.0f)];
    [self.view addSubview: pickereView];
    ////2.筛选按钮
    CGFloat size_w = (curScreenSize.width - 3.0f) / 4.0f;
    for(NSInteger i = 0; i < 4; i++)
    {
        UIButton *tempButton = [[UIButton alloc] initWithFrame: CGRectMake(i * (size_w + 1.0f), 0.0f, size_w, PICKER_HEIGHT)];
        [tempButton setTitleColor: [applicationClass methodOfTurnToUIColor:@"#ea5357"] forState: UIControlStateNormal];
        [tempButton setTitleColor: [UIColor whiteColor] forState: UIControlStateSelected];
        switch (i) {
            case 0:
            {
                [tempButton setSelected: YES];
                lastSelectedButton = tempButton;
                [tempButton setTitle: @"未处理" forState: UIControlStateNormal];
                [tempButton setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#ea5357"]];
                break;
            }
            case 1:
            {
                [tempButton setTitle: @"已拒绝" forState: UIControlStateNormal];
                break;
            }
            case 2:
            {
                [tempButton setTitle: @"已接受" forState: UIControlStateNormal];
                break;
            }
            case 3:
            {
                [tempButton setTitle: @"已完成" forState: UIControlStateNormal];
                break;
            }
            default:
                break;
        }
        [tempButton setTag: i];
        [tempButton.titleLabel setFont: [UIFont boldSystemFontOfSize: 15.0f]];
        [tempButton addTarget: self action: @selector(pickerButtonClick:) forControlEvents: UIControlEventTouchUpInside];
        [pickereView addSubview: tempButton];
        if(i != 3)
        {
            UIView *lineView = [[UIView alloc] initWithFrame: CGRectMake(tempButton.frame.origin.x + size_w, 0.0f, 1.0f, PICKER_HEIGHT)];
            [lineView setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#ea5357"]];
            [pickereView addSubview: lineView];
        }
    }
}

#pragma mark -
#pragma mark 筛选按钮的点击事件
- (void)pickerButtonClick:(UIButton *)sender
{
    if(lastSelectedButton != sender){
        [applicationClass methodOfHideTipInView];
        [sender setSelected: YES];
        [lastSelectedButton setSelected: NO];
        [lastSelectedButton setBackgroundColor: [UIColor whiteColor]];
        [sender setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#ea5357"]];
        lastSelectedButton = sender;
        switch ([sender tag]) {
            case 0:
                [orderObj getReceivedAllOrderList: [memberDictionary objectForKey:@"id"]];
                break;
            case 1:
                [orderObj getRefuseOrderList: [memberDictionary objectForKey:@"id"]];
                break;
            case 2:
                [orderObj getAcceptOrderList: [memberDictionary objectForKey:@"id"]];
                break;
            case 3:
                [orderObj getCompeleteOrderList: [memberDictionary objectForKey:@"id"]];
                break;
            default:
                break;
        }
    }
}

#pragma mark -
#pragma mark 加载数据视图
- (void)loadMainTableView
{
    if(!mainTableView){
        [self.view setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#f0f0f1"]];
        mainTableView = [[XZJ_EGOTableView alloc] initWithFrame: CGRectMake(0.0f, PICKER_HEIGHT, curScreenSize.width, curScreenSize.height - PICKER_HEIGHT)];
        [mainTableView setXDelegate: self];
        [mainTableView setTableViewFooterView];
        [mainTableView setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#f0f0f1"]];
        [self.view addSubview: mainTableView];
    }
    else{
        [mainTableView reloadData];
    }
    if([orderArray count] > 0)
        [mainTableView updateViewSize: CGSizeMake(mainTableView.frame.size.width, 5 * (HEADER_HEIGHT + CELL_HEIGHT)) showFooter: YES];
    else
        [applicationClass methodOfShowTipInView: mainTableView text: @"暂无数据"];
}

#pragma mark XZJ_EGOTableView委托
- (NSInteger)numberOfSectionsIn_XZJ_EGOTableView:(UITableView *)_tableView
{
    return [orderArray count];
}

- (NSInteger)XZJ_EGOTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)XZJ_EGOTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReserveListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"ListCell"];
    if(!cell){
        cell = [[ReserveListTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"ListCell" size: CGSizeMake(tableView.frame.size.width, CELL_HEIGHT)];
        [cell setXDelegate: self];
    }
    [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
    OrderClass *order = [orderArray objectAtIndex: [indexPath section]];
    [cell displayForStatus: [order orderStatus]];
    [cell setPhotoImage: IMAGE_URL([[order orderMember] memberPhoto]) sex: [[order orderMember] memberSex]];
    [cell.nameLabel setText: [[order orderMember] nickName]];
    [cell.titleLabel setText: [[order service] serviceTitle]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    [cell.timeLabel setText: [formatter stringFromDate: [order serviceStartTime]]];
    [cell.contentLabel setText: [order travelPurpose]];
    [cell.descriptLabel setText: [order oneselfIntroduce]];
    [cell.numberLabel setText: _LONG_PASER_TOSTRING((long)[order travelUserNum])];
    [cell.placeLabel setText: [[order service] serviceAddress]];
    [cell setSurplusTime: [order serviceStartTime]];
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

#pragma mak -
#pragma mark ReserveListTableViewCell
- (void)ReserveListTableViewCell_DidOperateButtonClick:(UITableViewCell *)cell index:(NSInteger)index
{
    NSIndexPath *indexPath = [mainTableView.tableView indexPathForCell: cell];
    OrderClass *order = [orderArray objectAtIndex: [indexPath section]];
    switch (index) {
        case -1: case 4: case 5: case 6:
            break;
        case 3:
        {
            ///联系预订者
            [applicationClass methodOfCall: [[order orderMember] memberPhone] superView: self.view];
            break;
        }
        default:
        {
            ///接受预约
            [orderObj acceptOrder: [order orderId] memberId: [[[order service] member] memberId]];
            break;
        }
    }
}

- (void)ReserveListTableViewCell_DidRejectButtonClick:(UITableViewCell *)cell
{
    if(!mainRefuseOrderView){
        mainRefuseOrderView = [[RefuseOrderView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, curScreenSize.width, curScreenSize.height)];
        [mainRefuseOrderView setXDelegate: self];
        [self.view addSubview: mainRefuseOrderView];
    }
    [mainRefuseOrderView setOperateCell: cell];
    [mainRefuseOrderView.refusetextView setText: @"对方将会看到您的拒绝理由..."];
    [mainRefuseOrderView show];
}

#pragma mak -
#pragma mark RefuseOrderView委托
- (void)RefuseOrderView_DidOperateButtonClick:(UIButton *)sender cell:(UITableViewCell *)cell
{
    if([sender tag] == 0){
        [mainRefuseOrderView dismiss];
    }
    else{
        if(cell){
            if([[[mainRefuseOrderView refusetextView] text] isEqualToString: @"对方将会看到您的拒绝理由..."] || [[[mainRefuseOrderView refusetextView] text] length] == 0){
                [applicationClass methodOfShowAlert: @"请填写拒绝理由"];
                return;
            }
            ///拒绝预约
            NSIndexPath *indexPath = [mainTableView.tableView indexPathForCell: cell];
            OrderClass *order = [orderArray objectAtIndex: [indexPath section]];
            [orderObj refuseOrder: [order orderId] memberId: [[[order service] member]  memberId] refuseReason: [[mainRefuseOrderView refusetextView] text]];
        }
    }
}

#pragma mak -
#pragma mark orderObject委托
- (void)orderObject_DidAcceptOrderResult:(BOOL)success
{
    if(success){
        [applicationClass methodOfAlterThenDisAppear: @"您已正式接受此次预约"];
    }
    else
        [applicationClass methodOfAlterThenDisAppear: @"操作失败,请稍候重试"];
}

- (void)orderObject_DidRefuseOrderResult:(BOOL)success
{
    if(success){
        [applicationClass methodOfAlterThenDisAppear: @"您已正式拒绝此次预约"];
    }
    else
        [applicationClass methodOfAlterThenDisAppear: @"操作失败,请稍候重试"];
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
