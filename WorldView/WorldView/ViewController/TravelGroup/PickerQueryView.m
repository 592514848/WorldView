//
//  PickerQueryView.m
//  WorldView
//
//  Created by XZJ on 11/9/15.
//  Copyright © 2015 XZJ. All rights reserved.
//
#define LINE_HEIGHT 60.0f
#define CITY_HEIGHT 35.0f
#define TITLE_HEIGHT 50.0F
#define BUTTON_HEIGHT 40.0F
#define SELF_ALPHA 0.6f
#define CELL_HEIGHT 105.0F
#import "PickerQueryView.h"

@implementation PickerQueryView
- (id)initWithFrame:(CGRect)frame buttonRect:(CGRect) buttonFrame delegate:(id<PickerQueryViewDelegate>) _delegate country:(CountryClass *) _country
{
    self = [super initWithFrame: frame];
    if(self){
        isCountry = YES;
        sortType = kComprehensive_Sort;
        countryOrCityId = [_country countryId];
        xDelegate = _delegate;
        ///2.取消按钮
        CGSize curScreenSize = [UIScreen mainScreen].bounds.size;
        CGFloat flow = (curScreenSize.width > 375.0f ? 20.0f : 16.0f);
        UIButton *cancelButton = [[UIButton alloc] initWithFrame: CGRectMake(curScreenSize.width - buttonFrame.size.width - flow, 20.0f + buttonFrame.origin.y, buttonFrame.size.width, buttonFrame.size.height)];
        [cancelButton setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"icon_ball_white" ofType: @"png"]] forState: UIControlStateNormal];
        [cancelButton setContentMode: UIViewContentModeScaleAspectFit];
        [cancelButton setImageEdgeInsets: UIEdgeInsetsMake(12.0f, 12.0f, 12.0f, 12.0f)];
        [cancelButton addTarget: self action: @selector(dismiss) forControlEvents: UIControlEventTouchUpInside];
        [self addSubview: cancelButton];
        
        ///3.线条
        CGFloat origin_X = buttonFrame.size.width / 2.0f + cancelButton.frame.origin.x;
        CGFloat origin_y = buttonFrame.size.height + cancelButton.frame.origin.y - 12.0f;
        lineView = [[UIView alloc] initWithFrame: CGRectMake(origin_X, origin_y, 1.0f, 1.0f)];
        [lineView setBackgroundColor: [UIColor whiteColor]];
        [self addSubview: lineView];

        
        ///4.内容展示框
        origin_y += LINE_HEIGHT + 2.0f;
        origin_X = flow + 15.0f;
        contentView = [[UIView alloc] initWithFrame: CGRectMake(origin_X, origin_y, frame.size.width - 2 * origin_X, frame.size.height * 2.0f / 3.0f)];
        [contentView setBackgroundColor: [UIColor whiteColor]];
        [contentView.layer setCornerRadius: 3.0f];
        [contentView.layer setMasksToBounds: YES];
        [contentView.layer setMasksToBounds: YES];
        [self addSubview: contentView];
        
        ///5.切换国家按钮
        UIButton *changeCityImageView = [[UIButton alloc] initWithFrame: CGRectMake(10.0f, 10.0f, 2 * CITY_HEIGHT, CITY_HEIGHT)];
        [changeCityImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"change_country" ofType: @"png"]] forState: UIControlStateNormal];
        [changeCityImageView setContentMode: UIViewContentModeScaleAspectFit];
        [changeCityImageView addTarget: self action: @selector(changeCityButtonClick) forControlEvents: UIControlEventTouchUpInside];
        [changeCityImageView setImageEdgeInsets: UIEdgeInsetsMake(5.0f, 0.0f, 5.0f, 0.0f)];
        [contentView addSubview: changeCityImageView];
        
        ///6.标题
        applicationClass = [XZJ_ApplicationClass commonApplication];
        origin_y = changeCityImageView.frame.size.height + changeCityImageView.frame.origin.y;
        titleLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(10.0f, origin_y, contentView.frame.size.width - 20.0f, 30.0f)];
        [titleLabel setTextAlignment: NSTextAlignmentCenter];
        [titleLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#f05654"]];
        [titleLabel setFont: [UIFont systemFontOfSize: 16.0f]];
        [titleLabel setText: [_country countryName_CH]];
        [contentView addSubview: titleLabel];
        
        ///7.横线
        origin_y += titleLabel.frame.size.height + 10.0f;
        UIView *horienLineView = [[UIView alloc] initWithFrame: CGRectMake(10.0f, origin_y, contentView.frame.size.width - 20.0f, 1.0f)];
        [horienLineView setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#f05654"]];
        [contentView addSubview: horienLineView];
        
        ///8.列名
        origin_y += lineView.frame.size.height;
        CGFloat size_w = (contentView.frame.size.width - 20.0f) / 2.0f;
        for(NSInteger i = 0; i < 2; i++){
            XZJ_CustomLabel *tempLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(10.0f + i * size_w, origin_y, size_w, TITLE_HEIGHT)];
            [tempLabel setTextAlignment: NSTextAlignmentCenter];
            [tempLabel setFont: [UIFont systemFontOfSize: 16.0f]];
            [contentView addSubview: tempLabel];
            if(i == 0){
                [tempLabel setText: @"地点"];
            }
            else{
                [tempLabel setText: @"排序"];
            }
        }
        
        ///9.横线
        origin_y += TITLE_HEIGHT;
        horienLineView = [[UIView alloc] initWithFrame: CGRectMake(10.0f, origin_y, contentView.frame.size.width - 20.0f, 1.0f)];
        [horienLineView setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#f05654"]];
        [contentView addSubview: horienLineView];
        
        ///10.城市列表
        countryObj = [[CountryObject alloc] init];
        [countryObj setXDelegate: self];
        [countryObj cityList: [_country countryId]];
        origin_y += horienLineView.frame.size.height;
        cityTableView = [[UITableView alloc] initWithFrame: CGRectMake(10.0f, origin_y, size_w, contentView.frame.size.height - 2 * TITLE_HEIGHT - origin_y)];
        [cityTableView setDelegate: self];
        [cityTableView setDataSource: self];
        [cityTableView setTag: 0];
        [cityTableView setSeparatorStyle: UITableViewCellSeparatorStyleNone];
        [contentView addSubview: cityTableView];
        
        ///11.排序
        origin_X = cityTableView.frame.size.width + cityTableView.frame.origin.x;
        cellHeight = (cityTableView.frame.size.height - 3.0f) / 4.0f;
        UIView *sequeensView = [[UIView alloc] initWithFrame: CGRectMake(origin_X, origin_y, size_w, cityTableView.frame.size.height)];
        [contentView addSubview: sequeensView];
        for(NSInteger i = 0; i < 4; i++){
            UIButton *sequensButton = [[UIButton alloc] initWithFrame: CGRectMake(0.0f, i * (cellHeight + 1.0f), size_w, cellHeight)];
            [sequensButton setTitleColor: [applicationClass methodOfTurnToUIColor: @"#656667"] forState: UIControlStateNormal];
            [sequensButton setTitleColor: [applicationClass methodOfTurnToUIColor: @"#f05654"] forState: UIControlStateSelected];
            [sequensButton.titleLabel setFont: [UIFont systemFontOfSize: 13.0f]];
            [sequensButton setTag: i];
            [sequensButton addTarget: self action: @selector(sequeensButtonClick:) forControlEvents: UIControlEventTouchUpInside];
            [sequeensView addSubview: sequensButton];
            ///横线
            if(i < 3){
                horienLineView = [[UIView alloc] initWithFrame: CGRectMake(10.0f, sequensButton.frame.size.height + sequensButton.frame.origin.y, sequeensView.frame.size.width - 20.0f, 1.0f)];
                [horienLineView setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#f05654"]];
                [sequeensView addSubview: horienLineView];
            }
            switch (i) {
                case 0:
                    [sequensButton setTitle: @"智能排序" forState: UIControlStateNormal];
                    [sequensButton setSelected: YES];
                    lastSequeensButton = sequensButton;
                    break;
                case 1:
                    [sequensButton setTitle: @"最新上线" forState: UIControlStateNormal];
                    break;
                case 2:
                    [sequensButton setTitle: @"人气最高" forState: UIControlStateNormal];
                    break;
                case 3:
                    [sequensButton setTitle: @"评价最高" forState: UIControlStateNormal];
                    break;
                default:
                    break;
            }
        }
        
        ///12.横线
        origin_y += cityTableView.frame.size.height;
        horienLineView = [[UIView alloc] initWithFrame: CGRectMake(10.0f, origin_y, contentView.frame.size.width - 20.0f, 1.0f)];
        [horienLineView setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#f05654"]];
        [contentView addSubview: horienLineView];
        
        ///13.确定按钮
        origin_y += (contentView.frame.size.height - origin_y - 1.0f) / 4.0f;
        UIButton *ensureButton = [[UIButton alloc] initWithFrame: CGRectMake((contentView.frame.size.width - 120.0f) / 2.0f, origin_y, 120.0f, BUTTON_HEIGHT)];
        [ensureButton.layer setCornerRadius: BUTTON_HEIGHT / 2.0f];
        [ensureButton.layer setBorderColor: [applicationClass methodOfTurnToUIColor: @"#f05654"].CGColor];
        [ensureButton.layer setBorderWidth: 1.0f];
        [ensureButton setTitle: @"确定" forState: UIControlStateNormal];
        [ensureButton.titleLabel setFont: [UIFont systemFontOfSize: 15.0f]];
        [ensureButton setTitleColor: [applicationClass methodOfTurnToUIColor: @"#f05654"] forState: UIControlStateNormal];
        [ensureButton addTarget: self action: @selector(ensureButtonClick) forControlEvents: UIControlEventTouchUpInside];
        [contentView addSubview: ensureButton];
        cellHeight = (cityTableView.frame.size.height) / 4.0f;
        
        ///14.选择国家的视图
        cityContentVeiw = [[UIView alloc] initWithFrame: contentView.frame];
        [cityContentVeiw setBackgroundColor: [UIColor whiteColor]];
        [cityContentVeiw.layer setCornerRadius: 3.0f];
        [cityContentVeiw.layer setMasksToBounds: YES];
        [cityContentVeiw setHidden: YES];
        [cityContentVeiw.layer setMasksToBounds: YES];
        [self addSubview: cityContentVeiw];
        ///15.国家列表
        countryObj = [[CountryObject alloc] init];
        [countryObj setXDelegate: self];
        [countryObj countryList];
        countryTableView = [[UITableView alloc] initWithFrame: CGRectMake(5.0f, 5.0f, contentView.frame.size.width - 10.0f, contentView.frame.size.height - 10.0f)];
        [countryTableView setDelegate: self];
        [countryTableView setDataSource: self];
        [countryTableView setTag: 1];
        UIView *footerView = [[UIView alloc] init];
        [footerView setBackgroundColor: [UIColor clearColor]];
        [countryTableView setShowsVerticalScrollIndicator: NO];
        [countryTableView setTableFooterView: footerView];
        [countryTableView setSeparatorStyle: UITableViewCellSeparatorStyleNone];
        [cityContentVeiw addSubview: countryTableView];
        
        ///16.显示主视图
        [self show];
    }
    return self;
}

#pragma mark -
#pragma mark countryObject委托
- (void)countryObject_GetCountryList:(NSArray *)dataArray
{
    countryArray = dataArray;
    [countryTableView reloadData];
}

- (void)countryObject_GetCityList:(NSArray *)dataArray
{
    cityArray = dataArray;
    [cityTableView reloadData];
}

#pragma mark -
#pragma mark 显示主视图
- (void)show
{
    [self setHidden: NO];
    timer = [NSTimer scheduledTimerWithTimeInterval: 0.01f target: self selector: @selector(autoUpBackgroundAlpha) userInfo: nil repeats: YES];
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront: self];
    CGRect contentViewFrame = [contentView frame];
    [contentView setFrame: CGRectMake(contentViewFrame.origin.x, contentViewFrame.origin.y, contentViewFrame.size.width, 0.0f)];
    CGRect cityContentViewFrame = [contentView frame];
    [cityContentVeiw setFrame: CGRectMake(cityContentViewFrame.origin.x, cityContentViewFrame.origin.y, cityContentViewFrame.size.width, 0.0f)];
    [UIView animateWithDuration: 0.2f animations:^{
        CGRect lineFrame = [lineView frame];
        lineFrame.size.height = LINE_HEIGHT;
        [lineView setFrame: lineFrame];
    } completion: ^(BOOL finished){
        [UIView animateWithDuration: 0.2f animations: ^{
            ///1
            [contentView setFrame: CGRectMake(contentViewFrame.origin.x, contentViewFrame.origin.y, contentViewFrame.size.width, self.frame.size.height * 2.0f / 3.0f)];
            ///2
            [cityContentVeiw setFrame: CGRectMake(cityContentViewFrame.origin.x, cityContentViewFrame.origin.y, cityContentViewFrame.size.width, self.frame.size.height * 2.0f / 3.0f)];
        }];
    }];
}

#pragma mark -
#pragma mark 隐藏主视图
- (void)dismiss
{
    ///1.隐藏背景透明度
    timer = [NSTimer scheduledTimerWithTimeInterval: 0.01f target: self selector: @selector(autoDownBackgroundAlpha) userInfo: nil repeats: YES];
    ///2.隐藏内容视图等
    [UIView animateWithDuration: 0.2f animations:^{
        ////1
        CGRect contentViewFrame = [contentView frame];
        [contentView setFrame: CGRectMake(contentViewFrame.origin.x, contentViewFrame.origin.y, contentViewFrame.size.width, 0.0f)];
        ////2
        contentViewFrame = [cityContentVeiw frame];
        [cityContentVeiw setFrame: CGRectMake(contentViewFrame.origin.x, contentViewFrame.origin.y, contentViewFrame.size.width, 0.0f)];
    } completion: ^(BOOL finished){
        [UIView animateWithDuration: 0.2f animations: ^{
            CGRect lineFrame = [lineView frame];
            lineFrame.size.height = 0.0f;
            [lineView setFrame: lineFrame];
        } completion:^(BOOL finished){
            [self setHidden: YES];
            if([xDelegate respondsToSelector: @selector(pickerQueryViewDelegate_DidCancelButton)]){
                [xDelegate pickerQueryViewDelegate_DidCancelButton];
            }
        }];
    }];
}

#pragma mark 自动加深主视图的背景透明度
- (void)autoUpBackgroundAlpha
{
    if(selfAlpha < SELF_ALPHA){
        selfAlpha += 0.1f;
        [self setBackgroundColor: [[UIColor alloc] initWithWhite: 0.3f alpha: selfAlpha]];
    }
    else
    {
        [timer setFireDate: [NSDate distantFuture]];
    }
}

#pragma mark 自动减少主视图的背景透明度
- (void)autoDownBackgroundAlpha
{
    if(selfAlpha > 0.0f){
        selfAlpha -= 0.1f;
        [self setBackgroundColor: [[UIColor alloc] initWithWhite: 0.3f alpha: selfAlpha]];
    }
    else
    {
        selfAlpha = 0.0f;
        [timer setFireDate: [NSDate distantFuture]];
    }
}

#pragma mark -
#pragma mark tableView委托
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([tableView tag] == 0)
        return 1;
    else
        return [countryArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([tableView tag] == 0)
        return [cityArray count] + 1;
    else
        return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView tag] == 0){
        PickerQueryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"ListCell"];
        if(!cell){
            cell = [[PickerQueryTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"ListCell" size: CGSizeMake(tableView.frame.size.width, cellHeight)];
        }
        switch ([indexPath row]) {
            case 0:
            {
                [cell.defaultLabel setText: @"全部"];
                [cell setSelected: YES];
                lastSelectedCell = cell;
                break;
            }
            default:
            {
                CityClass *city = [cityArray objectAtIndex: [indexPath row]];
                [cell.defaultLabel setText: [city cityName]];
                break;
            }
        }
        return cell;
    }
    else{
        HP_Locaction_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"ListCell"];
        if(!cell){
            cell = [[HP_Locaction_TableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"ListCell" size: CGSizeMake(tableView.frame.size.width, CELL_HEIGHT)];
        }
        CountryClass *country = [countryArray objectAtIndex: [indexPath section]];
        [cell.defaultImageView setImageWithURL: IMAGE_URL([country imageUrl]) placeholderImage: [UIImage imageNamed: @"default.png"]];
        [cell.defaultLabel setText: [NSString stringWithFormat: @"共有%@位猎人", [country hunterNum]]];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView tag] == 0){
        switch ([indexPath row]) {
            case 0:
                [cell setSelected: YES];
                lastSelectedCell = (PickerQueryTableViewCell *)cell;
                break;
            default:
                break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView tag] == 0){
        return cellHeight;
    }
    else{
        return CELL_HEIGHT;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView tag] == 0){
        ///1.调整选中样式
        if(lastSelectedCell){
            [lastSelectedCell setSelected: NO];
        }
        PickerQueryTableViewCell *cell = [tableView cellForRowAtIndexPath: indexPath];
        [cell setSelected: YES];
        lastSelectedCell = cell;
        ///2.设置选中的值
        switch ([indexPath row]) {
            case 0:
            {
                isCountry = YES;
                break;
            }
            default:
            {
                isCountry = NO;
                CityClass *city = [cityArray objectAtIndex: [indexPath row]];
                countryOrCityId = [city cityId];
                break;
            }
        }
    }
    else{
        ///获取城市数据
        CountryClass *country = [countryArray objectAtIndex: [indexPath section]];
        if([countryOrCityId longLongValue] != [[country countryId] longLongValue]){
            [countryObj cityList: [country countryId]];
            [titleLabel setText: [country countryName_CH]];
        }
        ///调整视图
        [cityContentVeiw setHidden: YES];
        [contentView setHidden: NO];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if([tableView tag] == 1){
        if(section != 0)
            return 5.0f;
        else
            return 0.0f;
    }
    else{
        return 0.0f;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor: [UIColor clearColor]];
    return view;
}

#pragma mark -
#pragma mark tableView委托
- (void)sequeensButtonClick:(UIButton *)sender
{
    [lastSequeensButton setSelected: NO];
    [sender setSelected: YES];
    lastSequeensButton = sender;
    switch ([sender tag]) {
        case 1:
            sortType = kNew_Sort;
            break;
        case 2:
            sortType = kPopularity_Type;
            break;
        case 3:
            sortType = kAverageScore_Type;
            break;
        default:
            sortType = kComprehensive_Sort;
            break;
    }
}

#pragma mark -
#pragma mark 切换国家
- (void)changeCityButtonClick
{
    [contentView setHidden: YES];
    [cityContentVeiw setHidden: NO];
}

#pragma mark -
#pragma mark 确定按钮
- (void)ensureButtonClick
{
    [self dismiss];
    if([xDelegate respondsToSelector: @selector(pickerQueryViewDelegate_DidEnsureButton:isCountry:sortType:)]){
        [xDelegate pickerQueryViewDelegate_DidEnsureButton: countryOrCityId isCountry: isCountry sortType: sortType];
    }
}

#pragma mark -
#pragma mark 页面空白处点击事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}
@end
