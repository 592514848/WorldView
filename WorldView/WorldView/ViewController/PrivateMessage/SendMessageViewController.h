//
//  SendMessageViewController.h
//  WorldView
//
//  Created by WorldView on 15/12/5.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import "BaseViewController.h"
#import "MessageObject.h"
#import "ServiceClass.h"

@interface SendMessageViewController : BaseViewController<MessageObjectDelegate, UITextViewDelegate>
{
    MessageObject *messageObj;
    UITextView *contentTextView;
    XZJ_CustomLabel *fontNumberLabel;
    NSString *textViewText;
}
@property(nonatomic, retain) ServiceClass *serviceClass;
@end
