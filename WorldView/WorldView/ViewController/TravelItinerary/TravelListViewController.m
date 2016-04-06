//
//  TravelListViewController.m
//  WorldView
//
//  Created by XZJ on 10/31/15.
//  Copyright © 2015 XZJ. All rights reserved.
//

#define PICKER_HEIGHT 45.0f
#define HEADER_HEIGHT 10.0F
#define CELL_HEIGHT 160.0F
#import "TravelListViewController.h"

@implementation TravelListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle: @"我的行程单"];
    if(isLogin){
        ///1.获取未成行的行程单
        orderObj = [[OrderObject alloc] init];
        [orderObj setXDelegate: self];
        [orderObj getNotTravelOrderList: LONG_PASER_TOSTRING([memberDictionary objectForKey: @"id"])];
    }
    else{
        [applicationClass methodOfAlterThenDisAppear: @"未登录"];
    }
    ///2.加载筛选栏
    [self loadPickerView];
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
    CGFloat size_w = curScreenSize.width / 2.0f;
    for(NSInteger i = 0; i < 2; i++)
    {
        UIButton *tempButton = [[UIButton alloc] initWithFrame: CGRectMake(i * size_w, 0.0f, size_w, PICKER_HEIGHT)];
        [tempButton setTitleColor: [applicationClass methodOfTurnToUIColor:@"#ea5357"] forState: UIControlStateNormal];
        [tempButton setTitleColor: [UIColor whiteColor] forState: UIControlStateSelected];
        if(i == 0){
            [tempButton setSelected: YES];
            lastSelectedButton = tempButton;
            [tempButton setTitle: @"未成行" forState: UIControlStateNormal];
            [tempButton setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#ea5357"]];
        }
        else{
            [tempButton setTitle: @"已成行" forState: UIControlStateNormal];
        }
        [tempButton setTag: i];
        [tempButton.titleLabel setFont: [UIFont boldSystemFontOfSize: 15.0f]];
        [tempButton addTarget: self action: @selector(pickerButtonClick:) forControlEvents: UIControlEventTouchUpInside];
        [pickereView addSubview: tempButton];
    }
}

#pragma mark -
#pragma mark
- (void)orderObject_GetNotTravelOrderList:(NSArray *)dataArray
{
    if([[orderObj page] currentOperate] == kOperate_LoadMore){
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange: NSMakeRange([orderDataArray count], ([dataArray count]))];
        [orderDataArray addObjectsFromArray: dataArray];
        [mainTableView insertSections: set];
        [mainTableView updateViewSize: CGSizeMake(curScreenSize.width, PICKER_HEIGHT + [orderDataArray count] * (HEADER_HEIGHT + CELL_HEIGHT)) showFooter: YES];
    }
    else{
        orderDataArray = [NSMutableArray arrayWithArray: dataArray];
        [self loadMainTableView];
    }
}

- (void)orderObject_GetTraveledOrderList:(NSArray *)dataArray
{
    orderDataArray = [NSMutableArray arrayWithArray: dataArray];
    [self loadMainTableView];
}

- (void)orderObject_DidCompeleteOrderResult:(BOOL)success
{
    if(success){
        [applicationClass methodOfAlterThenDisAppear: @"完成此次旅程"];
        [orderObj getNotTravelOrderList: LONG_PASER_TOSTRING([memberDictionary objectForKey: @"id"])];
    }
    else{
        [applicationClass methodOfAlterThenDisAppear: @"操作失败,请稍候再试"];
    }
}

#pragma mark -
#pragma mark 筛选按钮的点击事件
- (void)pickerButtonClick:(UIButton *)sender
{
    if(lastSelectedButton != sender){
        [applicationClass methodOfHideTipInView];
        ///1.改变选中状态
        [sender setSelected: YES];
        [lastSelectedButton setSelected: NO];
        [lastSelectedButton setBackgroundColor: [UIColor whiteColor]];
        [sender setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#ea5357"]];
        lastSelectedButton = sender;
        ///2.请求数据
        [self XZJ_EGOTableViewDidRefreshData];
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
        [self.view insertSubview: mainTableView belowSubview: pickereView];
    }
    else{
        [mainTableView reloadData];
    }
    if([orderDataArray count] > 0)
        [mainTableView updateViewSize: CGSizeMake(mainTableView.frame.size.width,PICKER_HEIGHT + [orderDataArray count] * (HEADER_HEIGHT + CELL_HEIGHT)) showFooter: YES];
    else
        [applicationClass methodOfShowTipInView: mainTableView text: @"暂无数据"];
}

#pragma mark XZJ_EGOTableView委托
- (NSInteger)numberOfSectionsIn_XZJ_EGOTableView:(UITableView *)_tableView
{
    return [orderDataArray count];
}

- (NSInteger)XZJ_EGOTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)XZJ_EGOTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TravelListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"ListCell"];
    if(!cell){
        cell = [[TravelListTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"ListCell" size: CGSizeMake(tableView.frame.size.width, CELL_HEIGHT)];
        [cell  setXDelegate: self];
    }
    [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
    OrderClass *order = [orderDataArray objectAtIndex: [indexPath section]];
    [cell displayForStatus: [order orderStatus]];
    [cell setPhotoImage: IMAGE_URL([[order orderMember] memberPhoto]) sex: [[[order orderMember] memberSex] integerValue]];
    [cell.nameLabel setText: [[order orderMember] nickName]];
    [cell.titleLabel setText: [[order service] serviceTitle]];
    [cell.subTitleLabel setText: [[order service] serviceDescription]];
    [cell setSurplusTime: [order serviceStartTime]];
    [cell setPricelText: [NSString stringWithFormat: @"¥%.2f", [order orderPrice]]];
    [cell setStarLevel: [order startLevel]];
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

- (void)XZJ_EGOTableViewDidRefreshData
{
    [[orderObj page] refresh];
    switch ([lastSelectedButton tag]) {
        case 0:
        {
            [orderObj getNotTravelOrderList: [memberDictionary objectForKey: @"id"]];
            break;
        }
        case 1:
        {
            [orderObj getTraveledOrderList: [memberDictionary objectForKey: @"id"]];
            break;
        }
        default:
            break;
    }
}

- (void)XZJ_EGOTableViewDidLoadMoreData
{
    if(![[orderObj page] loadMore]){
        [applicationClass methodOfAlterThenDisAppear: @"没有更多了噢～"];
        return;
    }
    else{
        switch ([lastSelectedButton tag]) {
            case 0:
            {
                [orderObj getNotTravelOrderList: [memberDictionary objectForKey: @"id"]];
                break;
            }
            case 1:
            {
                [orderObj getTraveledOrderList: [memberDictionary objectForKey: @"id"]];
                break;
            }
            default:
                break;
        }
    }
}

- (void)TravelListTableViewCell_DidOperateButtonClick:(UITableViewCell *)cell buttontag:(NSInteger)buttonTag
{
    switch (buttonTag) {
        case 3:
        {
            NSIndexPath *indexPath = [mainTableView.tableView indexPathForCell: cell];
            OrderClass *order = [orderDataArray objectAtIndex: [indexPath section]];
            [orderObj compeleteOrder: [order orderId] memberId: [memberDictionary objectForKey: @"id"]];
            break;
        }
        default:
            break;
    }
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
