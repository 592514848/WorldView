//
//  TravelGroupViewController.m
//  WorldView
//
//  Created by XZJ on 11/3/15.
//  Copyright © 2015 XZJ. All rights reserved.
//
#define NAVIGATIONBAR_HEIGHT 44.0f
#define THEME_VIEW_HEIGHT 240.0f
#define PICKER_HEIGHT 45.0f
#define CELL_HEIGHT 300.0F
#import "TravelGroupViewController.h"
#import "ThemeTravelTableViewCell.h"
#import "AppointmentViewController.h"

@implementation TravelGroupViewController
@synthesize country;
- (void)viewDidLoad {
    [super viewDidLoad];
    ///1.加载服务列表
    serviceObj = [[ServiceObject alloc] init];
    [serviceObj setXDelegate: self];
    sortType = kComprehensive_Sort;
    [serviceObj serviceList: [country countryId] isCountry: YES sortType: sortType memberId: (memberDictionary ? [memberDictionary objectForKey: @"id" ] : @"")];
    listType = kService_List;
    ////2.初始化主题旅程对象
    if(!themeTravelObj){
        themeTravelObj = [[ThemeTravelObject alloc] init];
        [themeTravelObj setXDelegate: self];
    }
    ////2.加载视图
    [self loadNavigationBar];
    [self loadPickerView];
}

#pragma mark -
#pragma mark 获取服务列表
- (void)serviceObject_GetServiceList:(NSArray *)dataArray
{
    if([[serviceObj page] currentOperate] == kOperate_LoadMore){
        NSMutableArray *insertArray = [NSMutableArray array];
        for(NSInteger i = 0; i < [dataArray count]; i++){
            [insertArray addObject: [NSIndexPath indexPathForRow: [serviceArray count] + i inSection: 0]];
        }
        [serviceArray addObjectsFromArray: dataArray];
        CGFloat tableViewHeight = [serviceArray count] * CELL_HEIGHT;
        [mainTableView setFrame: CGRectMake(0.0f, THEME_VIEW_HEIGHT, curScreenSize.width, tableViewHeight)];
        [mainTableView insertRowsAtIndexPaths: insertArray withRowAnimation: UITableViewRowAnimationAutomatic];
        ///跟新数据视图
        [mainScrollView updateViewFrame: CGSizeMake(curScreenSize.width, tableViewHeight + mainTableView.frame.origin.y) showFooter: YES];
    }
    else{
        serviceArray = [NSMutableArray arrayWithArray: dataArray];
        [self loadMainView];
    }
}

- (void)serviceObject_DidCollection:(BOOL)success
{
    if(success){
        [applicationClass methodOfAlterThenDisAppear: @"收藏成功"];
        [curOperateCell setIsCollection: YES];
        NSIndexPath *indexPath = [mainTableView indexPathForCell: curOperateCell];
        ServiceClass *service = [serviceArray objectAtIndex: [indexPath row]];
        [service setIsCollection: YES];
        [serviceArray setObject: service atIndexedSubscript: [indexPath row]];
    }
}

- (void)serviceObject_DidCancelCollection:(BOOL)success
{
    if(success){
        [curOperateCell setIsCollection: NO];
        NSIndexPath *indexPath = [mainTableView indexPathForCell: curOperateCell];
        ServiceClass *service = [serviceArray objectAtIndex: [indexPath row]];
        [service setIsCollection: NO];
        [serviceArray setObject: service atIndexedSubscript: [indexPath row]];
    }
}

#pragma mark -
#pragma mark 加载导航栏
- (void)loadNavigationBar
{
    ////
    navigationRightButton = [[UIButton alloc] initWithFrame: CGRectMake(0.0f, 0.0f, NAVIGATIONBAR_HEIGHT, NAVIGATIONBAR_HEIGHT)];
    [navigationRightButton setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"hp_ball" ofType: @"png"]] forState: UIControlStateNormal];
    [navigationRightButton setContentMode: UIViewContentModeScaleAspectFit];
    [navigationRightButton setImageEdgeInsets: UIEdgeInsetsMake(12.0f, 12.0f, 12.0f, 12.0f)];
    [navigationRightButton addTarget: self action: @selector(BarButtonItemClick) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *barBurronItem = [[UIBarButtonItem alloc] initWithCustomView: navigationRightButton];
    [self.navigationItem setRightBarButtonItem: barBurronItem];
    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0.0f, 12.0f, curScreenSize.width - NAVIGATIONBAR_HEIGHT, NAVIGATIONBAR_HEIGHT - 24.0f)];
    [titleImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"hp_logo" ofType: @"png"]]];
    [titleImageView setContentMode: UIViewContentModeScaleAspectFit];
    [self.navigationItem setTitleView: titleImageView];
}

#pragma mark -
#pragma mark 加载筛选视图
- (void)loadPickerView
{
    ////1.滚动视图
    mainScrollView = [[XZJ_EGOScrollView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, curScreenSize.width, curScreenSize.height)];
    [mainScrollView setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#f1f1f1"]];
    [mainScrollView setXDelegate: self];
    [self.view addSubview: mainScrollView];
    
    ////2.筛选视图的背景
    bgImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, curScreenSize.width,THEME_VIEW_HEIGHT)];
    [bgImageView setContentMode: UIViewContentModeScaleAspectFill];
    [bgImageView.layer setMasksToBounds: YES];
    [bgImageView setImageWithURL: IMAGE_URL([country imageUrl]) placeholderImage: [UIImage imageNamed: @"default.png"]];
    [bgImageView setUserInteractionEnabled: YES];
    [mainScrollView addSubviewToScrollView: bgImageView];
    
    ////3.筛选视图的主视图
    pickereView = [[UIView alloc] initWithFrame: CGRectMake(0.0f, THEME_VIEW_HEIGHT - PICKER_HEIGHT, curScreenSize.width, PICKER_HEIGHT)];
    [pickereView setBackgroundColor: [[UIColor alloc] initWithWhite: 0.6f alpha: 0.6f]];
    [pickereView.layer setBorderColor: [UIColor whiteColor].CGColor];
    [pickereView.layer setBorderWidth: 0.5f];
    [pickereView.layer setShadowOpacity: 0.2f];
    [pickereView.layer setShadowOffset: CGSizeMake(3.0f, 0.0f)];
    [bgImageView addSubview: pickereView];
    
    ////2.筛选按钮
    CGFloat size_w = (pickereView.frame.size.width - 1.0f) / 2.0f;
    for(NSInteger i = 0; i < 2; i++)
    {
        UIButton *tempButton = [[UIButton alloc] initWithFrame: CGRectMake(i * (size_w + 1.0f), 0.0f, size_w, PICKER_HEIGHT)];
        [tempButton setTitleColor: [applicationClass methodOfTurnToUIColor:@"#ea5357"] forState: UIControlStateSelected];
        [tempButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
        [tempButton.titleLabel setFont: [UIFont systemFontOfSize: 14.0f]];
        if(i == 0){
            [tempButton setTitle: @"城市猎人" forState: UIControlStateNormal];
            ////分割线
            UIView *lineView = [[UIView alloc] initWithFrame: CGRectMake(tempButton.frame.size.width, 5.0f, 1.0f, PICKER_HEIGHT - 10.0f)];
            [lineView setBackgroundColor: [UIColor whiteColor]];
            [pickereView addSubview: lineView];
        }
        else{
            [tempButton setTitle: @"主题旅程" forState: UIControlStateNormal];
        }
        [tempButton setTag: i];
        [tempButton addTarget: self action: @selector(pickerButtonClick:) forControlEvents: UIControlEventTouchUpInside];
        [pickereView addSubview: tempButton];
    }
}

#pragma mark -
#pragma mark 筛选按钮的点击事件
- (void)pickerButtonClick:(UIButton *)sender
{
    [applicationClass methodOfHideTipInView];
    if(lastSelectedButton != sender){
        [sender setSelected: YES];
        [lastSelectedButton setSelected: NO];
        lastSelectedButton = sender;
    }
    switch ([sender tag]) {
        case 0:
        {
            ///城市猎人（服务）
            listType = kService_List;
            [serviceObj serviceList: [country countryId] isCountry: YES sortType: sortType memberId: (memberDictionary ? [memberDictionary objectForKey: @"id" ] : @"")];
            break;
        }
        case 1:
        {
            //主题旅程
            listType = kThemeList;
            [themeTravelObj getThemetavelList: [country countryId] isCountry: YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark themeTravel 委托
- (void)themeTravelObject_GetThemeTravelList:(NSArray *)dataArray
{
    serviceArray = [NSMutableArray arrayWithArray: dataArray];
    [self loadMainView];
}

#pragma mark -
#pragma mark 加载主视图
- (void)loadMainView
{
    ////1.TableView的高度
    CGFloat tableViewHeight = [serviceArray count] * CELL_HEIGHT;
    if(!mainTableView)
    {
        [self.view setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#eff0f1"]];
        ////2.TableView初始化
        mainTableView = [[UITableView alloc] initWithFrame: CGRectMake(0.0f, THEME_VIEW_HEIGHT, curScreenSize.width, tableViewHeight)];
        [mainTableView setDelegate: self];
        [mainTableView setDataSource: self];
        [mainTableView setSeparatorStyle: UITableViewCellSeparatorStyleNone];
        [mainTableView setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#eff0f1"]];
        [mainTableView setScrollEnabled: NO];
        [mainScrollView addSubviewToScrollView: mainTableView];
    }
    else{
        [mainTableView setFrame: CGRectMake(0.0f, THEME_VIEW_HEIGHT, curScreenSize.width, tableViewHeight)];
        [mainTableView reloadData];
    }
    ////3.调整scrollview
    [mainScrollView.ScrollView setScrollEnabled: YES];
    [mainScrollView updateViewFrame: CGSizeMake(curScreenSize.width, tableViewHeight + mainTableView.frame.origin.y) showFooter: YES];
    if([serviceArray count] == 0){
        [applicationClass methodOfShowTipInView: mainScrollView text: @"暂无数据"];
        [mainScrollView.ScrollView setScrollEnabled: NO];
    }
}

#pragma mark -
#pragma mark UIScrollview委托
- (void)XZJ_EGOScrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y >= pickereView.frame.origin.y && !isAdjustView){
        isAdjustView = YES;
        ///1.设置背景图片的位置
        [bgImageView setFrame: CGRectMake(0.0f, -(bgImageView.frame.size.height - pickereView.frame.size.height), curScreenSize.width, bgImageView.frame.size.height)];
        [self.view addSubview: bgImageView];
        ///2.设置主滚动视图的位置
        [UIView animateWithDuration: 0.3f animations: ^{
            CGRect frame = [scrollView frame];
            [scrollView setFrame: CGRectMake(0.0F, -(bgImageView.frame.size.height - pickereView.frame.size.height), curScreenSize.width, frame.size.height + (bgImageView.frame.size.height - pickereView.frame.size.height))];
            //            [mainScrollView updateViewFrame: CGSizeMake(curScreenSize.width, scrollView.contentSize.height) showFooter: YES];
        }];
    }
    if(scrollView.contentOffset.y < -PICKER_HEIGHT && isAdjustView){
        isAdjustView = NO;
        ///1.设置背景图片的位置
        [bgImageView setFrame: CGRectMake(0.0f, 0.0f, curScreenSize.width, bgImageView.frame.size.height)];
        [mainScrollView addSubviewToScrollView: bgImageView];
        ///2.设置主滚动视图的位置
        [UIView animateWithDuration: 0.3f animations: ^{
            CGRect frame = [scrollView frame];
            [scrollView setFrame: CGRectMake(0.0F, 0.0f, curScreenSize.width, frame.size.height - (bgImageView.frame.size.height - pickereView.frame.size.height))];
            //            [mainScrollView updateViewFrame: CGSizeMake(curScreenSize.width, scrollView.contentSize.height) showFooter: YES];
        }];
    }
}

#pragma mark -
#pragma mark XZJ_EGOTableView委托
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [serviceArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (listType) {
        case 1:
        {
            WishListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"WishListCell"];
            if(!cell){
                cell = [[WishListTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"WishListCell" size: CGSizeMake(tableView.frame.size.width, CELL_HEIGHT)];
                [cell setXDelegate: self];
            }
            [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
            
            ServiceClass *service = [serviceArray objectAtIndex: [indexPath row]];
            [cell setPhotoImage: IMAGE_URL([[service member] memberPhoto]) sex: [[[service member]  memberSex] integerValue]];
            [cell setAppointButtonThemeColorBySex: [[[service member]  memberSex] integerValue]];
            [cell.localImageView setImageWithURL: IMAGE_URL([service mainImageUrl]) placeholderImage: [UIImage imageNamed: @"default.png"]];
            [cell.nameLabel setText: [NSString stringWithFormat: @"by %@ %@",[[service member] nickName_EN],[[service member] nickName]]];
            [cell.titleLabel setText: [service serviceTitle]];
            [cell.priceLabel setText: [NSString stringWithFormat: @"¥ %@", DOUBLE_PASER_TOSTRING([service unitPrice])]];
            [cell.appointNumberLabel setText: [NSString stringWithFormat: @"%ld人参与", [service joinNum]]];
            [cell.localLabel setText: [service serviceAddress]];
            [cell setStarLevel: [service serivceScore]];
            [cell.collectionNumberLabel setText: _LONG_PASER_TOSTRING([service collectionNum])];
            [cell setIsCollection: [service isCollection]];
            return cell;
        }
        case 2:{
            ThemeTravelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"ThemeListCell"];
            if(!cell){
                cell = [[ThemeTravelTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"ThemeListCell" size: CGSizeMake(tableView.frame.size.width, CELL_HEIGHT)];
            }
            [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
            ThemeTravelClass *theme = [serviceArray objectAtIndex: [indexPath row]];
            [cell updateDisplayView: [theme hunters]];
            [cell updateMainScrollView: [theme services]];
            [cell.mainImageView setImageWithURL: IMAGE_URL([theme themeImageUrl]) placeholderImage: [UIImage imageNamed: @"default.png"]];
            return cell;
        }
        default:
        {
            WishListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"WishListCell"];
            if(!cell){
                cell = [[WishListTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"WishListCell" size: CGSizeMake(tableView.frame.size.width, CELL_HEIGHT)];
                [cell setXDelegate: self];
            }
            [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
            
            ServiceClass *service = [serviceArray objectAtIndex: [indexPath row]];
            [cell setPhotoImage: IMAGE_URL([[service member] memberPhoto]) sex: [[[service member]  memberSex] integerValue]];
            [cell setAppointButtonThemeColorBySex: [[[service member]  memberSex] integerValue]];
            [cell.localImageView setImageWithURL: IMAGE_URL([service mainImageUrl]) placeholderImage: [UIImage imageNamed: @"default.png"]];
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
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor: [UIColor clearColor]];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    AppointmentViewController *appointVC = [[AppointmentViewController alloc] init];
    //    [self.navigationController pushViewController: appointVC animated: YES];
}

#pragma mark 导航栏按钮点击事件
-(void)BarButtonItemClick
{
    [navigationRightButton setHidden: YES];
    if(!pickerQueryView){
        pickerQueryView = [[PickerQueryView alloc] initWithFrame: [[UIScreen mainScreen] bounds] buttonRect: CGRectMake(0.0f, 0.0f, NAVIGATIONBAR_HEIGHT, NAVIGATIONBAR_HEIGHT) delegate: self country: country];
        [[[UIApplication sharedApplication] keyWindow] addSubview: pickerQueryView];
    }
    else{
        [pickerQueryView show];
    }
}

#pragma mark -
#pragma mark PickerQueryView
- (void)pickerQueryViewDelegate_DidCancelButton
{
    [navigationRightButton setHidden: NO];
}

- (void)pickerQueryViewDelegate_DidEnsureButton:(NSString *)countryOrCityId isCountry:(BOOL)isCountry sortType:(Service_Sort_Type)sort
{
    ///城市猎人（服务）
    listType = kService_List;
    [serviceObj serviceList: countryOrCityId isCountry: isCountry sortType: sort memberId: (memberDictionary ? [memberDictionary objectForKey: @"id" ] : @"")];
}

#pragma mark -
#pragma mark wishListTableViewCell
- (void)wishListTableViewCell_DidButtonClick:(UIButton *)button tableViewCell:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [mainTableView indexPathForCell: cell];
    AppointmentViewController *appointVC = [[AppointmentViewController alloc] init];
    ServiceClass *service = [serviceArray objectAtIndex: [indexPath row]];
    [appointVC setServiceID: [service serviceId]];
    [appointVC setTopBarTitle: [country countryName_CH]];
    [self.navigationController pushViewController: appointVC animated: YES];
}

- (void)wishListTableViewCell_DidCollectionClick:(UITableViewCell *)cell
{
    curOperateCell = (WishListTableViewCell *)cell;
    NSIndexPath *indexPath = [mainTableView indexPathForCell: cell];
    ServiceClass *servicClass = [serviceArray objectAtIndex: [indexPath row]];
    if(isLogin){
        if([servicClass isCollection]){
            ///取消收藏
            [serviceObj cancelCollectionService: servicClass memerID: [memberDictionary objectForKey: @"id"]];
        }
        else{
            ///收藏
            [serviceObj collectionService: servicClass memerID: [memberDictionary objectForKey: @"id"]];
        }
    }
    else{
        [applicationClass methodOfAlterThenDisAppear: @"您还未登录哦～"];
    }
}

#pragma mark -
#pragma mark XZJ_EGOScrollView委托
- (void)XZJ_EGOScrollViewDidRefreshData
{
    switch (listType) {
        case 1:
        {
            ///城市猎人（服务
            [[serviceObj page] refresh];
            [serviceObj serviceList: [country countryId] isCountry: YES sortType: sortType memberId: (memberDictionary ? [memberDictionary objectForKey: @"id" ] : @"")];
            break;
        }
        case 2:
        {
            //主题旅程
            [themeTravelObj getThemetavelList: [country countryId] isCountry: YES];
            break;
        }
        default:
            break;
    }
}

- (void)XZJ_EGOScrollViewDidLoadMoreData
{
    switch (listType) {
        case 1:
        {
            if(![[serviceObj page] loadMore]){
                [applicationClass methodOfAlterThenDisAppear: @"没有更多了噢～"];
                return;
            }
            else{
                ///城市猎人（服务
                [serviceObj serviceList: [country countryId] isCountry: YES sortType: sortType memberId: (memberDictionary ? [memberDictionary objectForKey: @"id" ] : @"")];
            }
            break;
        }
        case 2:
        {
            //主题旅程
            [themeTravelObj getThemetavelList: [country countryId] isCountry: YES];
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
