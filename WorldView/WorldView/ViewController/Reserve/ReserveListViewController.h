//
//  ReserveListViewController.h
//  WorldView
//
//  Created by XZJ on 11/2/15.
//  Copyright © 2015 XZJ. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderObject.h"
#import "ReserveListTableViewCell.h"
#import "RefuseOrderView.h"

@interface ReserveListViewController : BaseViewController<XZJ_EGOTableViewDelegate, OrderObjectDelegate, ReserveListTableViewCellDelegate, RefuseOrderViewDelegate>
{
    UIButton *lastSelectedButton;
    UIView *pickereView;
    OrderObject *orderObj;
    NSArray *orderArray;
    XZJ_EGOTableView *mainTableView;
    RefuseOrderView *mainRefuseOrderView;
}
@end
