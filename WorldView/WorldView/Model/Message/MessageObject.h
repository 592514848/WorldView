//
//  MessageObject.h
//  WorldView
//
//  Created by WorldView on 15/11/20.
//  Copyright © 2015年 XZJ. All rights reserved.
//
#define MESSAGELIST_METHOD_ID @"m0012"
#define SENDMESSAGE_METHOD_ID @"m0010"
#define UPDATEREADSTATUS_METHOD_ID @"m0011"
#define MESSAGEHISTORY_METHOD_ID @"m0019"
#import "ModelObject.h"
#import "MessageClass.h"
#import "PageClass.h"
@protocol MessageObjectDelegate <NSObject>
@optional
- (void)messageObjectDelegate_GetMessageLsit:(NSArray *) dataArray;
- (void)messageObjectDelegate_DidSendMessageResult:(BOOL) success;
- (void)messageObjectDelegate_GetHistoryMessageLsit:(NSArray *) dataArray;
@end

typedef enum {
    kMessageList_Request = 0,
    kSendMessage_Request = 1,
    kUpdateReadStatus_Request = 2,
    kMessageHistory_Request = 3
}Message_Interface_Type;
@interface MessageObject : ModelObject
{
    Message_Interface_Type interface_type;
}
@property(nonatomic, retain) PageClass *page;
@property(nonatomic, retain) id<MessageObjectDelegate> xDelegate;//委托对象
- (void)getMessageList:(NSString *) memberID;
- (void)sendMessage:(NSString *)content sendMemberId:(NSString *)sendMemberId receiveMemberId:(NSString *)receiveMemberId serviceId:(NSString *) serviceId;
- (void)UpdateMessageReadStatus:(NSString *) messageId;
- (void)getMessageHistoryList:(NSString *)messageId;
@end
