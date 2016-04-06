//
//  EvalutionObject.m
//  WorldView
//
//  Created by WorldView on 15/11/24.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import "EvalutionObject.h"

@implementation EvalutionObject
@synthesize xDelegate;

- (id)init
{
    self = [super init];
    if(self){
    }
    return self;
}

#pragma mark 获取评论列表
- (void)getEvalutionList:(NSString *) serviceId
{
    interface_type = kEvalutionList_Request;
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: EVALUTIONLIST_METHOD_ID, @"methodId", serviceId, @"tripId", nil]] param: nil showIndicator: YES];
}

#pragma mark 评论
- (void)sendEvalution:(NSString *)content serviceId:(NSString *) serviceId memberId:(NSString *) memberId score:(NSString *) score
{
    interface_type = kSendEvalution_Request;
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: SENDEVALUTION_METHOD_ID, @"methodId", serviceId, @"tripId", memberId, @"commentUserId", score, @"score", nil]] param: nil showIndicator: YES];
}

#pragma mark -
#pragma mark XZJ_AsyncRequestData
- (void)XZJ_AsyncRequestDataReceiveData:(NSDictionary *)responseDictionary
{
    NSLog(@"%@", responseDictionary);
    switch (interface_type) {
        case 0:
        {
            NSArray *tempArray = [responseDictionary objectForKey: @"data"];
            if(!IsNSNULL(tempArray))
            {
                NSMutableArray *listArray = [NSMutableArray arrayWithCapacity: [tempArray count]];
                for(NSDictionary *dictionary in tempArray){
                    EvaluationClass *evalution = [[EvaluationClass alloc] init];
                    [evalution setEvalutionId: VALIDATE_VALUE_STRING([dictionary objectForKey: @"id"])];
                    [evalution setServiceId: VALIDATE_VALUE_STRING([dictionary objectForKey: @"tripId"])];
                    [evalution setEvalutionContent: VALIDATE_VALUE_STRING([dictionary objectForKey: @"content"])];
                    [evalution setAddTime: VALIDATE_VALUE_STRING([dictionary objectForKey: @"addTime"])];
                    [evalution setEvalutionScore: [VALIDATE_VALUE_STRING([dictionary objectForKey: @"score"]) integerValue]];
                    ///评论人信息
                    NSDictionary *tempDictioanry = [dictionary objectForKey: @"userInfo"];
                    MemberObject *member = [[MemberObject alloc] init];
                    [member setMemberId:  VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"id"])];
                    [member setMemberAccount:  VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"account"])];
                    [member setMemberPassword:  VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"password"])];
                    [member setMemberPhoto: VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"imgUrl"])];
                    NSInteger sex = [VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"sex"]) integerValue];
                    [member setMemberSex: (sex == 0 ? @"男" : @"女")];
                    [member setNickName:  VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"nickName"])];
                    [member setMemberMail:  VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"mail"])];
                    [member setMemberPhone:  VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"mobile"])];
                    [member getMemberType: VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"userType"])];
                    [evalution setMember: member];
                    [listArray addObject: evalution];
                }
                if([xDelegate respondsToSelector: @selector(evalutionObjectDelegate_GetEvalutionLsit:)]){
                    [xDelegate evalutionObjectDelegate_GetEvalutionLsit: listArray];
                }
            }
            break;
        }
        case 1:
        {
            ///评论结果
            if([xDelegate respondsToSelector: @selector(evalutionObjectDelegate_DidSendEvalutionResults:)]){
                BOOL success = [[responseDictionary objectForKey: @"code"] integerValue] == INTERFACE_SUCEESS_RETURN_CODE ? YES : NO;
                [xDelegate evalutionObjectDelegate_DidSendEvalutionResults: success];
            }
            break;
        }
        default:
            break;
    }
}
@end
