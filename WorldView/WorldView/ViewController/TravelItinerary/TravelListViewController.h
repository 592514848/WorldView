//
//  TravelListViewController.h
//  WorldView
//
//  Created by XZJ on 10/31/15.
//  Copyright © 2015 XZJ. All rights reserved.
//

#import "BaseViewController.h"
#import "TravelListTableViewCell.h"
#import "OrderObject.h"

@interface TravelListViewController : BaseViewController<XZJ_EGOTableViewDelegate, OrderObjectDelegate, TravelListTableViewCell_Delegate>
{
    UIButton *lastSelectedButton;
    OrderObject *orderObj;
    UIView *pickereView;
    NSMutableArray *orderDataArray;
    XZJ_EGOTableView *mainTableView;
}
@end