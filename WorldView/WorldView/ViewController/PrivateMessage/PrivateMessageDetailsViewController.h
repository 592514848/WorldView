//
//  PrivateMessageDetailsViewController.h
//  WorldView
//
//  Created by WorldView on 15/11/14.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import "BaseViewController.h"
#import "MessageObject.h"

@interface PrivateMessageDetailsViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, MessageObjectDelegate>
{
    UITableView *mainTableView;
    UITextField *sendTextFiled;
    MessageObject *messageObj;
    NSMutableArray *messageArray;
}
@property(nonatomic, retain)MessageClass *mainMessage;
@end
