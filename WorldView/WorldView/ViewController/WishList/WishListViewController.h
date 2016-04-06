//
//  WishListViewController.h
//  WorldView
//
//  Created by XZJ on 11/2/15.
//  Copyright © 2015 XZJ. All rights reserved.
//

#import "BaseViewController.h"
#import "ServiceObject.h"
#import "WishListTableViewCell.h"

@interface WishListViewController : BaseViewController<XZJ_EGOTableViewDelegate, ServiceObjectDelegate, WishListTableViewCellDelegate>
{
    ServiceObject *serviceObj;
    NSMutableArray *collectionArray;
    XZJ_EGOTableView *mainTableView;
    NSIndexPath *curIndexPath;
}
@end
