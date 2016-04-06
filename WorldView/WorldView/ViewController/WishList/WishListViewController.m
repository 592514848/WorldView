//
//  WishListViewController.m
//  WorldView
//
//  Created by XZJ on 11/2/15.
//  Copyright © 2015 XZJ. All rights reserved.
//
#define CELL_HEIGHT 300.0F
#import "WishListViewController.h"
#import "AppointmentViewController.h"

@implementation WishListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle: @"我的心愿单"];
    if(isLogin){
        ///.获取收藏列表
        serviceObj = [[ServiceObject alloc] init];
        [serviceObj setXDelegate: self];
        [serviceObj getCollectionList: LONG_PASER_TOSTRING([memberDictionary objectForKey: @"id"])];
    }
    else{
        [applicationClass methodOfAlterThenDisAppear: @"您还未登录"];
    }
}

#pragma mark -
#pragma mark 获取收藏列表
- (void)serviceObject_GetCollectionList:(NSArray *)dataArray
{
    if([[serviceObj page] currentOperate] == kOperate_LoadMore){
        NSMutableArray *insertArray = [NSMutableArray array];
        for(NSInteger i = 0; i < [dataArray count]; i++){
            [insertArray addObject: [NSIndexPath indexPathForRow: [collectionArray count] + i inSection: 0]];
        }
        [collectionArray addObjectsFromArray: dataArray];
        [mainTableView insertRows: insertArray];
        [mainTableView updateViewSize: CGSizeMake(curScreenSize.width, [collectionArray count] * CELL_HEIGHT) showFooter: YES];
    }
    else{
        collectionArray = [NSMutableArray arrayWithArray: dataArray];
        [self loadMainTableView];
    }
}

- (void)serviceObject_DidCancelCollection:(BOOL)success
{
    if(success){
        [applicationClass methodOfAlterThenDisAppear: @"取消成功"];
        [collectionArray removeObjectAtIndex: [curIndexPath row]];
        [self loadMainTableView];
    }
    else{
        [applicationClass methodOfAlterThenDisAppear: @"取消失败，请稍候再试"];
    }
}

#pragma mark 加载收藏列表
- (void)loadMainTableView
{
    if(!mainTableView){
        [self.view setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#eff0f1"]];
        mainTableView = [[XZJ_EGOTableView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, curScreenSize.width, curScreenSize.height)];
        [mainTableView setXDelegate: self];
        [mainTableView setTableViewFooterView];
        [mainTableView setSeparatorStyle: UITableViewCellSeparatorStyleNone];
        [mainTableView setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#eff0f1"]];
        [self.view addSubview: mainTableView];
    }
    else{
        [mainTableView reloadData];
    }
    if([collectionArray count] > 0)
        [mainTableView updateViewSize: CGSizeMake(mainTableView.frame.size.width, [collectionArray count] * CELL_HEIGHT) showFooter: YES];
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
    return [collectionArray count];
}

- (UITableViewCell *)XZJ_EGOTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WishListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"ListCell"];
    if(!cell){
        cell = [[WishListTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"ListCell" size: CGSizeMake(tableView.frame.size.width, CELL_HEIGHT)];
        [cell setXDelegate: self];
    }
    [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
    ServiceClass *service = [collectionArray objectAtIndex: [indexPath row]];
    [cell setPhotoImage: [NSURL URLWithString: [[service member] memberPhoto]] sex: [[[service member]  memberSex] integerValue]];
    [cell setAppointButtonThemeColorBySex: [[[service member]  memberSex] integerValue]];
    [cell.localImageView setImageWithURL: [NSURL URLWithString: [service mainImageUrl]] placeholderImage: [UIImage imageNamed: @"default.png"]];
    [cell.nameLabel setText: [[service member] nickName]];
    [cell.titleLabel setText: [service serviceTitle]];
    [cell.priceLabel setText: [NSString stringWithFormat: @"¥ %@", DOUBLE_PASER_TOSTRING([service unitPrice])]];
    [cell.appointNumberLabel setText: [NSString stringWithFormat: @"%ld人参与", [service joinNum]]];
    [cell.localLabel setText: [service serviceAddress]];
    [cell setStarLevel: [service serivceScore]];
    [cell.collectionNumberLabel setText: _LONG_PASER_TOSTRING([service collectionNum])];
    [cell setIsCollection: [service isCollection]];
    return cell;
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
    if(isLogin){
        [[serviceObj page] refresh];
        [serviceObj getCollectionList: LONG_PASER_TOSTRING([memberDictionary objectForKey: @"id"])];
    }
}

- (void)XZJ_EGOTableViewDidLoadMoreData
{
    if(![[serviceObj page] loadMore]){
        [applicationClass methodOfAlterThenDisAppear: @"没有更多了噢~"];
        return;
    }
    else{
        [serviceObj getCollectionList: LONG_PASER_TOSTRING([memberDictionary objectForKey: @"id"])];
    }
}

#pragma mark -
#pragma mark wishListTableViewCell
- (void)wishListTableViewCell_DidButtonClick:(UIButton *)button tableViewCell:(UITableViewCell *)cell
{
    AppointmentViewController *appointVC = [[AppointmentViewController alloc] init];
    [self.navigationController pushViewController: appointVC animated: YES];
}

- (void)wishListTableViewCell_DidCollectionClick:(UITableViewCell *)cell
{
    ///取消收藏按钮
    curIndexPath = [mainTableView.tableView indexPathForCell: cell];
    ServiceClass *service = [collectionArray objectAtIndex: [curIndexPath row]];
    [serviceObj cancelCollectionService: service memerID: [memberDictionary objectForKey: @"id"]];
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
