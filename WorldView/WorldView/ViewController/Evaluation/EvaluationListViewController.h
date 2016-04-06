//
//  EvaluationListViewController.h
//  WorldView
//
//  Created by WorldView on 15/11/16.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import "BaseViewController.h"
#import "EvalutionObject.h"

@interface EvaluationListViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, EvalutionObjectDelegate>
{
    EvalutionObject *evalutionObj;
    NSArray *evalutionArray;
    UITableView *mainTableView;
}
@property(nonatomic, retain) NSString *serviceId;
@end
