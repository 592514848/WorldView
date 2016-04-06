//
//  HomePageMainListView.h
//  WorldView
//
//  Created by XZJ on 11/3/15.
//  Copyright © 2015 XZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZJ_ApplicationClass.h"
#import "CountryClass.h"
@protocol HomePageMainListViewDelegate <NSObject>
- (void)HomePageMainListView_DidRefeshData;
- (void)HomePageMainListView_DidLoadMoreData;
@end

@interface HomePageMainListView : UIView<XZJ_EGOTableViewDelegate>
{
    XZJ_EGOTableView *mainTableView;
    NSArray *countryListArray;
}
@property(nonatomic, retain) UIViewController *viewControllerSender;
@property(nonatomic, retain) id<HomePageMainListViewDelegate> xDelegate;
- (id)initWithFrame:(CGRect)frame dataArray:(NSArray *) dataArray;
- (void)updateFrame:(CGRect) frame;
- (void)updateView:(NSArray *) dataArray;
@end
