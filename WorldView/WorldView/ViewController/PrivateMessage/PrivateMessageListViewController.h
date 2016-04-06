//
//  PrivateMessageListViewController.h
//  WorldView
//
//  Created by XZJ on 11/2/15.
//  Copyright © 2015 XZJ. All rights reserved.
//

#import "BaseViewController.h"
#import "MessageObject.h"

@interface PrivateMessageListViewController : BaseViewController<XZJ_EGOTableViewDelegate, MessageObjectDelegate>
{
    NSMutableArray *messageArray;
    XZJ_EGOTableView *mainTableView;
    MessageObject *messageObj;
}
@end
