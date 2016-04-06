//
//  PublishedJourneyViewController.m
//  WorldView
//
//  Created by XZJ on 11/3/15.
//  Copyright © 2015 XZJ. All rights reserved.
//
#define PICKER_HEIGHT 45.0f
#define CELL_HEIGHT 295.0F
#import "PublishedJourneyViewController.h"
#import "PublishJourneyViewController.h"

@implementation PublishedJourneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle: @"我发布的旅程"];
    [self loadPickerView];
    ///获取数据
    if(isLogin){
        serviceObj = [[ServiceObject alloc] init];
        [serviceObj setXDelegate: self];
        ///默认获取猎人上架的旅程
        curPickerType = 0;
        [serviceObj getHunterShelfOnServiceList: LONG_PASER_TOSTRING([memberDictionary objectForKey: @"id"])];
    }
    else{
        [applicationClass methodOfAlterThenDisAppear: @"您还未登录"];
    }
}

#pragma mark -
#pragma mark serviceObject委托
- (void)serviceObject_GetShelfOnServiceList:(NSArray *)dataArray
{
    serviceArray = dataArray;
    [self loadMainTableView];
}

- (void)serviceObject_GetShelfOffServiceList:(NSArray *)dataArray
{
    serviceArray = dataArray;
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
    CGFloat size_w = curScreenSize.width / 2.0f;
    for(NSInteger i = 0; i < 2; i++)
    {
        UIButton *tempButton = [[UIButton alloc] initWithFrame: CGRectMake(i * size_w, 0.0f, size_w, PICKER_HEIGHT)];
        [tempButton setTitleColor: [applicationClass methodOfTurnToUIColor:@"#ea5357"] forState: UIControlStateNormal];
        [tempButton setTitleColor: [UIColor whiteColor] forState: UIControlStateSelected];
        if(i == 0){
            [tempButton setSelected: YES];
            lastSelectedButton = tempButton;
            [tempButton setTitle: @"进行中" forState: UIControlStateNormal];
            [tempButton setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#ea5357"]];
        }
        else{
            [tempButton setTitle: @"已下架" forState: UIControlStateNormal];
        }
        [tempButton setTag: i];
        [tempButton.titleLabel setFont: [UIFont boldSystemFontOfSize: 15.0f]];
        [tempButton addTarget: self action: @selector(pickerButtonClick:) forControlEvents: UIControlEventTouchUpInside];
        [pickereView addSubview: tempButton];
    }
}

#pragma mark -
#pragma mark 筛选按钮的点击事件
- (void)pickerButtonClick:(UIButton *)sender
{
    if(lastSelectedButton != sender){
        [sender setSelected: YES];
        [lastSelectedButton setSelected: NO];
        [lastSelectedButton setBackgroundColor: [UIColor whiteColor]];
        [sender setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#ea5357"]];
        lastSelectedButton = sender;
    }
    curPickerType = [sender tag];
    switch ([sender tag]) {
        case 1:
            [serviceObj getHunterShelfOffServiceList: LONG_PASER_TOSTRING([memberDictionary objectForKey: @"id"])];
            break;
        default:
            [serviceObj getHunterShelfOnServiceList: LONG_PASER_TOSTRING([memberDictionary objectForKey: @"id"])];
            break;
    }
}

#pragma mark -
#pragma mark 加载数据视图
- (void)loadMainTableView
{
    [applicationClass methodOfHideTipInView];
    [self.view setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#f0f0f1"]];
    if(!mainTableView){
        mainTableView = [[XZJ_EGOTableView alloc] initWithFrame: CGRectMake(0.0f, PICKER_HEIGHT, curScreenSize.width, curScreenSize.height - PICKER_HEIGHT)];
        [mainTableView setXDelegate: self];
        [mainTableView setTableViewFooterView];
        [mainTableView setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#f0f0f1"]];
        [mainTableView setSeparatorStyle: UITableViewCellSeparatorStyleNone];
        [self.view addSubview: mainTableView];
    }
    else
        [mainTableView reloadData];
    if([serviceArray count] > 0)
        [mainTableView updateViewSize: CGSizeMake(mainTableView.frame.size.width, [serviceArray count] * CELL_HEIGHT) showFooter: YES];
    else
        [applicationClass methodOfShowTipInView: mainTableView text: @"暂无数据"];
}

#pragma mark XZJ_EGOTableView委托
- (NSInteger)numberOfSectionsIn_XZJ_EGOTableView:(UITableView *)_tableView
{
    return 1;
}

- (NSInteger)XZJ_EGOTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [serviceArray count];
}

- (UITableViewCell *)XZJ_EGOTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PublishedJourneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"ListCell"];
    if(!cell){
        cell = [[PublishedJourneyTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"ListCell" size: CGSizeMake(tableView.frame.size.width, CELL_HEIGHT)];
        [cell setXDelegate: self];
    }
    [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
    ServiceClass *service = [serviceArray objectAtIndex: [indexPath row]];
    NSString *status = (curPickerType == 1 ? @"已下架" : @"未下架");
    [cell displayForStatus: status];
    [cell setPhotoImage: IMAGE_URL([[service member] memberPhoto]) sex: [[service member] memberSex]];
    [cell.localImageView setImageWithURL: IMAGE_URL([service mainImageUrl]) placeholderImage: [UIImage imageNamed: @"default.png"]];
    [cell.nameLabel setText: [NSString stringWithFormat: @"by %@ %@", [[service member] nickName_EN], [[service member] nickName]]];
    [cell.titleLabel setText: [service serviceTitle]];
    [cell.appointNumberLabel setText: [NSString stringWithFormat: @"%ld人参与", (long)[service joinNum]]];
    [cell.localLabel setText: [service serviceAddress]];
    [cell setStarLevel: [service serivceScore]];
    [cell.collectionNumberLabel setText: _LONG_PASER_TOSTRING([service collectionNum])];
    return cell;
}

- (CGFloat)XZJ_EGOTableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
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

#pragma mark PublishedJourneyTableViewCell委托
- (void)PublishedJourneyTableViewCell_DidShelOffbuttonClick:(UITableViewCell *)cell
{
    curOperateCell = cell;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"温馨提示" message: @"下架后，该行程将收入“已下架”列表，且用户无法预约该行程；您可以在“已下架”列表中重新编辑该行程" delegate: self cancelButtonTitle: @"取消" otherButtonTitles: @"确认下架", nil];
    [alert show];
}

- (void)PublishedJourneyTableViewCell_DidEditbuttonClick:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [mainTableView.tableView indexPathForCell: cell];
    ServiceClass *service = [serviceArray objectAtIndex: [indexPath row]];
    [serviceObj getServiceDetails: [service serviceId]];
}

- (void)serviceObject_ServiceDetails:(ServiceClass *)service
{
    PublishJourneyViewController *editVC = [[PublishJourneyViewController alloc] init];
    [editVC setMainService: service];
    [self.navigationController pushViewController: editVC animated: YES];
}

#pragma mark alertView委托
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1){
        NSIndexPath *indexPath = [mainTableView.tableView indexPathForCell: curOperateCell];
        ServiceClass *service = [serviceArray objectAtIndex: [indexPath row]];
        [serviceObj shelfOffService: [service serviceId] memberID: [[service member] memberId]];
    }
    [alertView dismissWithClickedButtonIndex: 0 animated: YES];
}

- (void)serviceObject_DidShelfOffService:(BOOL)success
{
    if(success){
        [applicationClass methodOfAlterThenDisAppear: @"下架成功"];
        [serviceObj getHunterShelfOnServiceList: LONG_PASER_TOSTRING([memberDictionary objectForKey: @"id"])];
    }
    else
        [applicationClass methodOfAlterThenDisAppear: @"下架失败,请稍候再试"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
