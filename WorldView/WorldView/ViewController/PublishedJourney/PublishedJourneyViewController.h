//
//  PublishedJourneyViewController.h
//  WorldView
//
//  Created by XZJ on 11/3/15.
//  Copyright © 2015 XZJ. All rights reserved.
//

#import "BaseViewController.h"
#import "ServiceObject.h"
#import "PublishedJourneyTableViewCell.h"

@interface PublishedJourneyViewController : BaseViewController<XZJ_EGOTableViewDelegate, ServiceObjectDelegate, PublishedJourneyTableViewCellDelegate, UIAlertViewDelegate>
{
    UIButton *lastSelectedButton;
    UIView *pickereView;
    XZJ_EGOTableView *mainTableView;
    ServiceObject *serviceObj;
    NSArray *serviceArray;
    NSInteger curPickerType; ///0:上架；1:下架
    UITableViewCell *curOperateCell;
}
@end
