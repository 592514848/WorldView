//
//  HomePageMainListView.m
//  WorldView
//
//  Created by XZJ on 11/3/15.
//  Copyright © 2015 XZJ. All rights reserved.
//
#define CELL_HEIGHT 240.0f
#import "HomePageMainListView.h"
#import "HomePageMainTableViewCell.h"
#import "TravelGroupViewController.h"

@implementation HomePageMainListView
@synthesize viewControllerSender, xDelegate;
- (id)initWithFrame:(CGRect)frame dataArray:(NSArray *) dataArray
{
    if(self = [super initWithFrame: frame])
    {
        countryListArray = dataArray;
        [self setBackgroundColor: [UIColor clearColor]];
        ///tableVeiw
        mainTableView = [[XZJ_EGOTableView alloc] initWithFrame: frame];
        [mainTableView setXDelegate: self];
        [mainTableView setTableViewFooterView];
        [mainTableView setSeparatorStyle: UITableViewCellSeparatorStyleNone];
        [self addSubview: mainTableView];
        [mainTableView updateViewSize: CGSizeMake(mainTableView.frame.size.width, [dataArray count] * CELL_HEIGHT) showFooter: NO];
    }
    return self;
}

- (void)updateFrame:(CGRect)frame
{
    [self setFrame: frame];
    [mainTableView setFrame: frame];
}

#pragma mark XZJ_EGOTableView委托
- (NSInteger)numberOfSectionsIn_XZJ_EGOTableView:(UITableView *)_tableView
{
    return 1;
}

- (NSInteger)XZJ_EGOTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [countryListArray count];
}

- (UITableViewCell *)XZJ_EGOTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomePageMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"ListCell"];
    if(!cell){
        cell = [[HomePageMainTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"ListCell" size: CGSizeMake(tableView.frame.size.width, CELL_HEIGHT)];
    }
    CountryClass *countryClass = [countryListArray objectAtIndex: [indexPath row]];
    [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
    [cell.mainImageView setImageWithURL: IMAGE_URL([countryClass imageUrl]) placeholderImage: [UIImage imageNamed: @"default.png"]];
    [cell.ch_localNameLabel setText: [countryClass countryName_CH]];
    [cell.en_localNameLabel setText: [countryClass countryName_EN]];
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

- (void)XZJ_EGOTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CountryClass *contryClass = [countryListArray objectAtIndex: [indexPath row]];
    TravelGroupViewController *nextVC = [[TravelGroupViewController alloc] init];
    [nextVC setTopBarTitle: [contryClass countryName_CH]];
    [nextVC setCountry: contryClass];
    [viewControllerSender.navigationController pushViewController: nextVC animated: YES];
}

- (void)XZJ_EGOTableViewDidRefreshData
{
    if([xDelegate respondsToSelector: @selector(HomePageMainListView_DidRefeshData)]){
        [xDelegate HomePageMainListView_DidRefeshData];
    }
}

- (void)XZJ_EGOTableViewDidLoadMoreData
{
    if([xDelegate respondsToSelector: @selector(HomePageMainListView_DidLoadMoreData)]){
        [xDelegate HomePageMainListView_DidLoadMoreData];
    }
}

- (void)updateView:(NSArray *) dataArray
{
    countryListArray = dataArray;
    [mainTableView reloadData];
}
@end
