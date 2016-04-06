//
//  MessageObject.m
//  WorldView
//
//  Created by WorldView on 15/11/20.
//  Copyright © 2015年 XZJ. All rights reserved.
//
#import "MessageObject.h"
@implementation MessageObject
@synthesize xDelegate, page;
- (id)init
{
    self = [super init];
    if(self){
        page = [[PageClass alloc] init];
    }
    return self;
}

#pragma mark 获取私信列表
- (void)getMessageList:(NSString *) memberID
{
    interface_type = kMessageList_Request;
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: MESSAGELIST_METHOD_ID, @"methodId", memberID, @"receiveUserId", [[NSNumber numberWithInteger: [page currentPage]] stringValue], @"currentPage", [[NSNumber numberWithInteger: [page pageSize]] stringValue], @"pageSize", nil]] param: nil showIndicator: YES];
}

#pragma mark 发送私信
- (void)sendMessage:(NSString *)content sendMemberId:(NSString *)sendMemberId receiveMemberId:(NSString *)receiveMemberId serviceId:(NSString *) serviceId
{
    interface_type = kSendMessage_Request;
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: SENDMESSAGE_METHOD_ID, @"methodId", sendMemberId, @"createUserId", receiveMemberId, @"receiveUserId", content, @"content", serviceId, @"tripId",  nil]] param: nil showIndicator: YES];
}

#pragma mark 获取私信阅读状态
- (void)UpdateMessageReadStatus:(NSString *) messageId
{
    interface_type = kUpdateReadStatus_Request;
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: UPDATEREADSTATUS_METHOD_ID, @"methodId", messageId, @"id",  nil]] param: nil showIndicator: YES];
}

#pragma mark 获取历史私信列表
- (void)getMessageHistoryList:(NSString *)messageId
{
    interface_type = kMessageHistory_Request;
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: MESSAGEHISTORY_METHOD_ID, @"methodId", messageId, @"msgId",  nil]] param: nil showIndicator: YES];
}

#pragma mark -
#pragma mark XZJ_AsyncRequestData
- (void)XZJ_AsyncRequestDataReceiveData:(NSDictionary *)responseDictionary
{
    NSLog(@"%@", responseDictionary);
    switch (interface_type) {
        case 0: case 3:
        {
            ////1.解析数据
            NSArray *tempArray = [responseDictionary objectForKey: @"data"];
            NSMutableArray *listArray = [NSMutableArray arrayWithCapacity: [tempArray count]];
            for(NSDictionary *dictionary in tempArray){
                MessageClass *message = [[MessageClass alloc] init];
                [message setMessageId: VALIDATE_VALUE_STRING([dictionary objectForKey: @"id"])];
                [message setMessageContent: VALIDATE_VALUE_STRING([dictionary objectForKey: @"content"])];
                [message setMessageTitle: VALIDATE_VALUE_STRING([dictionary objectForKey: @"title"])];
                [message setServiceId: VALIDATE_VALUE_STRING([dictionary objectForKey: @"tripId"])];
                if(!IsNSNULL([dictionary objectForKey: @"addTime"])){
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSDate *date = [dateFormatter dateFromString: [dictionary objectForKey: @"addTime"]];
                    [message setAddTime:date];
                }
                [message setIsRead: (VALIDATE_VALUE_LONG([dictionary objectForKey: @"status"]) == 1 ? YES : NO)];
                ///发送者的信息
                NSDictionary *tempDictioanry = [dictionary objectForKey: @"sendUser"];
                if(!IsNSNULL(tempDictioanry)){
                    MemberObject *member = [[MemberObject alloc] init];
                    [member setMemberId:  VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"id"])];
                    [member setMemberAccount:  VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"account"])];
                    [member setMemberPassword:  VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"password"])];
                    [member setMemberPhoto: VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"imgUrl"])];
                    NSInteger sex = [VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"sex"]) integerValue];
                    [member setMemberSex: (sex == 0 ? @"男" : @"女")];
                    [member setNickName:  VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"nickName"])];
                    [member setNickName_EN:  VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"engNickName"])];
                    [member setMemberMail:  VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"mail"])];
                    [member setMemberPhone:  VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"mobile"])];
                    [member getMemberType: VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"userType"])];
                    [message setSendMember: member];
                }
                /////页码
                NSDictionary *pageDictionary = [responseDictionary objectForKey: @"page"];
                if(!IsNSNULL(pageDictionary)){
                    [page setTotalPage: VALIDATE_VALUE_LONG([pageDictionary objectForKey: @"totalPage"])];
                    [page setCurrentPage: VALIDATE_VALUE_LONG([pageDictionary objectForKey: @"currentPage"])];
                    [page setPrePage: VALIDATE_VALUE_LONG([pageDictionary objectForKey: @"prePage"])];
                    [page setNextPage: VALIDATE_VALUE_LONG([pageDictionary objectForKey: @"nextPage"])];
                    [page setTotalCount: VALIDATE_VALUE_LONG([pageDictionary objectForKey: @"totalCount"])];
                }
                ///接收者的信息
                tempDictioanry = [dictionary objectForKey: @"receiveUser"];
                if(!IsNSNULL(tempDictioanry)){
                    MemberObject *member = [[MemberObject alloc] init];
                    [member setMemberId:  VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"id"])];
                    [member setMemberAccount:  VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"account"])];
                    [member setMemberPassword:  VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"password"])];
                    [member setMemberPhoto: VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"imgUrl"])];
                    NSInteger sex = [VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"sex"]) integerValue];
                    [member setMemberSex: (sex == 0 ? @"男" : @"女")];
                    [member setNickName:  VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"nickName"])];
                    [member setNickName_EN:  VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"engNickName"])];
                    [member setMemberMail:  VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"mail"])];
                    [member setMemberPhone:  VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"mobile"])];
                    [member getMemberType: VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"userType"])];
                    [message setReceiveMember: member];
                }
                [listArray addObject: message];
            }
            if(interface_type == 0){
                if([xDelegate respondsToSelector: @selector(messageObjectDelegate_GetMessageLsit:)]){
                    [xDelegate messageObjectDelegate_GetMessageLsit: listArray];
                }
            }
            if(interface_type == 3)
            {
                if([xDelegate respondsToSelector: @selector(messageObjectDelegate_GetHistoryMessageLsit:)]){
                    [xDelegate messageObjectDelegate_GetHistoryMessageLsit: listArray];
                }
            }
            break;
        }
        case 1:
        {
            ///发送私信
            if([xDelegate respondsToSelector: @selector(messageObjectDelegate_DidSendMessageResult:)]){
                BOOL success = [[responseDictionary objectForKey: @"code"] integerValue] == INTERFACE_SUCEESS_RETURN_CODE ? YES : NO;
                [xDelegate messageObjectDelegate_DidSendMessageResult: success];
            }
            break;
        }
        default:
            break;
    }
}
@end
