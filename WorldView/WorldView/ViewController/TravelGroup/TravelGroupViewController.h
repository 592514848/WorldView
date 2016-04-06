//
//  TravelGroupViewController.h
//  WorldView
//
//  Created by XZJ on 11/3/15.
//  Copyright © 2015 XZJ. All rights reserved.
//

#import "BaseViewController.h"
#import "PickerQueryView.h"
#import "WishListTableViewCell.h"
#import "ServiceObject.h"
#import "ThemeTravelObject.h"
#import "CountryObject.h"

typedef enum {
    kServiceAndTheme_List = 0,
    kService_List = 1,
    kThemeList = 2
}List_Type;
@interface TravelGroupViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, PickerQueryViewDelegate, WishListTableViewCellDelegate, ServiceObjectDelegate, ThemeTravelObjectDelegate,XZJ_EGOScrollViewDelegate>
{
    XZJ_EGOScrollView *mainScrollView;
    UITableView *mainTableView;
    UIButton *lastSelectedButton;
    UIView *pickereView;
    BOOL isAdjustView; //是否调整视图
    NSTimer *mainTimer;
    CGPoint mainScrollVeiwPoint;
    UIButton *navigationRightButton;
    PickerQueryView *pickerQueryView;
    UIImageView *bgImageView;
    ////////////////////////////
    ServiceObject *serviceObj;
    NSMutableArray *serviceArray;
    ThemeTravelObject *themeTravelObj;
    List_Type listType;
    Service_Sort_Type sortType;
    WishListTableViewCell *curOperateCell;
}
@property(nonatomic, retain) CountryClass *country;
@end
