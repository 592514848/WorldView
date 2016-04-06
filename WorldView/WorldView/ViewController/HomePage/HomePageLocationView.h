//
//  HomePageLocationView.h
//  WorldView
//
//  Created by XZJ on 10/30/15.
//  Copyright © 2015 XZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountryClass.h"

@protocol HomePageLocationViewDelegate <NSObject>
- (void)homePageLocationView_DidCancelButton;
//- (void)homePageLocationView_DidSelectedTableView:(UITableView *)tableView indexPath:(NSIndexPath *) indexPath;
@end

@interface HomePageLocationView : UIView<UITableViewDataSource, UITableViewDelegate>
{
    UIView *lineView;
    NSTimer *timer;
    UIView *contentView;
    UITableView *mainTableView;
    UIViewController<HomePageLocationViewDelegate> *xDelegate;
    CGFloat selfAlpha;
    NSArray *countryListArray;
}
- (id)initWithFrame:(CGRect)frame buttonRect:(CGRect) buttonFrame delegate:(UIViewController<HomePageLocationViewDelegate> *) _delegate dataArray:(NSArray *)dataArray;
@end
