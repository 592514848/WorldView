//
//  PJStepSevenViewController.h
//  WorldView
//
//  Created by XZJ on 11/6/15.
//  Copyright © 2015 XZJ. All rights reserved.
//

#import "BaseViewController.h"
#import "TravelTimeTableViewCell.h"
#import "ServiceClass.h"

@interface PJStepSevenViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate,XZJ_CustomPicker_Delegate, TravelTimeTableViewCellDelegate>
{
    NSMutableArray *timeArray;
    XZJ_CustomPicker *mainDatePicker;//时间选择器
    UITableView *mainTableView;
}
@property(nonatomic) ServiceClass *mainService;
@end
