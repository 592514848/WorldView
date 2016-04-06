//
//  HomePageViewController.h
//  WorldView
//
//  Created by XZJ on 10/28/15.
//  Copyright © 2015 XZJ. All rights reserved.
//

#import "BaseViewController.h"
#import "HomePageLoginView.h"
#import "HomePageNewsView.h"
#import "HomePageLocationView.h"
#import "HomePageMemberView.h"
#import "HomePageMainListView.h"
#import "XZJ_SideBarView.h"
#import "CountryObject.h"
#import "AdObject.h"
#import "WXApiManager.h"

@interface HomePageViewController : BaseViewController<UIScrollViewDelegate, HomePageLocationViewDelegate, HomePageNewsViewDelegate, HomePageMemberViewDelegate, XZJ_SideBarViewDelegate, HomePageLoginViewDelegate, CountryObjectDelegate, AdObjectDelegate, HomePageMainListViewDelegate>
{
    UIScrollView *mainWelcomeScrollView;
    CountryObject *countryObj;
    //////////////////////////////////////////
    XZJ_SideBarView *sideBarMainView; //侧边栏
    CGFloat siderBarBackroundAplha;
    NSTimer *timer;
    UIButton *navigationRightButton;
    UIButton *navigationLeftButton;
    BOOL isPushNextVC;
    NSIndexPath *curOperateIndexPath;
    HomePageMainListView *homePageMainView;
    HomePageMemberView *mainMemberView;
    HomePageLoginView *mainLoginView;
    //////////////////////////////////////////
    NSArray *countryListArray;
}
@end
