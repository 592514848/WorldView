//
//  OrderObject.m
//  WorldView
//
//  Created by WorldView on 15/11/20.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import "OrderObject.h"

@implementation OrderObject
@synthesize xDelegate, page;
- (id)init
{
    self = [super init];
    if(self){
        page = [[PageClass alloc] init];
    }
    return self;
}

#pragma mark 获取未成行订单
- (void)getNotTravelOrderList:(NSString *) memberID
{
    interface_type = kNotTrvale_Request;
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: NOTTRSVELORDER_METHOD_ID, @"methodId",memberID, @"userId", [[NSNumber numberWithInteger: [page currentPage]] stringValue], @"currentPage", [[NSNumber numberWithInteger: [page pageSize]] stringValue], @"pageSize",  nil]] param: nil showIndicator: YES];
}

#pragma mark 获取已成行订单
- (void)getTraveledOrderList:(NSString *) memberID
{
    interface_type = kTraveled_Request;
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: TRSVELEDORDER_METHOD_ID, @"methodId",memberID, @"userId",  nil]] param: nil showIndicator: YES];
}

#pragma mark 获取猎人收到的所有订单(未处理的订单)
- (void)getReceivedAllOrderList:(NSString *) memberID
{
    interface_type = kReceivedAllOrder_Request;
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: RECEIVEDORDER_METHOD_ID, @"methodId",memberID, @"hunterId",  nil]] param: nil showIndicator: YES];
}

#pragma mark 获取猎人拒绝的订单
- (void)getRefuseOrderList:(NSString *) memberID
{
    interface_type = kRefuseOrder_Request;
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: REFUSEORDER_METHOD_ID, @"methodId",memberID, @"hunterId",  nil]] param: nil showIndicator: YES];
}

#pragma mark 获取猎人接受的订单
- (void)getAcceptOrderList:(NSString *) memberID
{
    interface_type = kAcceptOrder_Request;
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: ACCEPTORDER_METHOD_ID, @"methodId",memberID, @"hunterId",  nil]] param: nil showIndicator: YES];
}

#pragma mark 接受预约
- (void)acceptOrder:(NSString *) orderId memberId:(NSString *) memberId
{
    interface_type = kDidAcceptOrder_Request;
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: DIDACCEPTORDER_METHOD_ID, @"methodId",memberId, @"hunterId", orderId, @"orderId", nil]] param: nil showIndicator: YES];
}

#pragma mark 拒绝预约
- (void)refuseOrder:(NSString *) orderId memberId:(NSString *) memberId refuseReason:(NSString *) refuseReason
{
    interface_type = kRefuseOrder_Request;
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: DIDREFUSEORDER_METHOD_ID, @"methodId",memberId, @"hunterId", orderId, @"orderId", refuseReason, @"refuseReason", nil]] param: nil showIndicator: YES];
}

#pragma mark 获取猎人完成的订单
- (void)getCompeleteOrderList:(NSString *) memberID
{
    interface_type = kCompeleteOrderList;
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: COMPELETEORDERLIST_METHOD_ID, @"methodId",memberID, @"hunterId",  nil]] param: nil showIndicator: YES];
}

#pragma mark 完成旅程
- (void)compeleteOrder:(NSString *) orderId memberId:(NSString *) memberId
{
    interface_type = kDidCompeleteOrder;
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: DIDCOMPELETEORDER_METHOD_ID, @"methodId",memberId, @"userId", orderId, @"orderId", nil]] param: nil showIndicator: YES];
}

#pragma mark -
#pragma mark XZJ_AsyncRequestData
- (void)XZJ_AsyncRequestDataReceiveData:(NSDictionary *)responseDictionary
{
    NSLog(@"%@", responseDictionary);
    NSLog(@"%@", [responseDictionary objectForKey: @"msg"]);
    switch (interface_type) {
        case 5:{
            ///接受预约
            if([xDelegate respondsToSelector: @selector(orderObject_DidAcceptOrderResult:)]){
                BOOL success = [[responseDictionary objectForKey: @"code"] integerValue] == INTERFACE_SUCEESS_RETURN_CODE ? YES : NO;
                [xDelegate orderObject_DidAcceptOrderResult: success];
            }
            break;
        }
        case 6:{
            ///拒绝预约
            if([xDelegate respondsToSelector: @selector(orderObject_DidRefuseOrderResult:)]){
                BOOL success = [[responseDictionary objectForKey: @"code"] integerValue] == INTERFACE_SUCEESS_RETURN_CODE ? YES : NO;
                [xDelegate orderObject_DidRefuseOrderResult: success];
            }
            break;
        }
        case 8:{
            ///完成旅程
            if([xDelegate respondsToSelector: @selector(orderObject_DidCompeleteOrderResult:)]){
                BOOL success = [[responseDictionary objectForKey: @"code"] integerValue] == INTERFACE_SUCEESS_RETURN_CODE ? YES : NO;
                [xDelegate orderObject_DidCompeleteOrderResult: success];
            }
            break;
        }
        default:{
            ////1.解析数据
            NSArray *tempArray = (IsNSNULL([responseDictionary objectForKey: @"data"]) ? nil : [responseDictionary objectForKey: @"data"]);
            NSMutableArray *listArray = [NSMutableArray arrayWithCapacity: [tempArray count]];
            for(NSDictionary *dictionary in tempArray){
                OrderClass *order = [[OrderClass alloc] init];
                [order setOrderId: VALIDATE_VALUE_STRING([dictionary objectForKey: @"id"])];
                [order setOrderNo: VALIDATE_VALUE_STRING([dictionary objectForKey: @"orderNo"])];
                [order setServiceId: VALIDATE_VALUE_STRING([dictionary objectForKey: @"tripId"])];
                [order setOrderPrice: VALIDATE_VALUE_DOUBLE([dictionary objectForKey: @"totalPrice"])];
                [order setOrderStatus: VALIDATE_VALUE_LONG([dictionary objectForKey: @"status"])];
                [order setAddTime: VALIDATE_VALUE_STRING([dictionary objectForKey: @"addTime"])];
                [order setRefuseReason: VALIDATE_VALUE_STRING([dictionary objectForKey: @"refuseReason"])];
                [order setStartLevel: VALIDATE_VALUE_LONG([dictionary objectForKey: @"score"])];
                ////服务开始时间
                if(!IsNSNULL([dictionary objectForKey: @"startTime"])){
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
                    [order setServiceStartTime: [formatter dateFromString: [dictionary objectForKey: @"startTime"]]];
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
                ///服务信息（旅程信息）
                NSDictionary *serviceDictionary = [dictionary objectForKey: @"tripInfo"];
                if(!IsNSNULL(serviceDictionary)){
                    ////服务内容
                    ServiceClass *service = [[ServiceClass alloc] init];
                    [service setServiceId: VALIDATE_VALUE_STRING([serviceDictionary objectForKey: @"id"])];
                    [service setServiceTitle: VALIDATE_VALUE_STRING([serviceDictionary objectForKey: @"title"])];
                    [service setServiceDescription: VALIDATE_VALUE_STRING([serviceDictionary objectForKey: @"description"])];
                    [service setCityId: VALIDATE_VALUE_STRING([serviceDictionary objectForKey: @"cityId"])];
                    [service setCountryId: VALIDATE_VALUE_STRING([serviceDictionary objectForKey: @"countryId"])];
                    [service setCollectionNum: VALIDATE_VALUE_LONG([serviceDictionary objectForKey: @"collectNum"])];
                    [service setSerivceScore: VALIDATE_VALUE_LONG([serviceDictionary objectForKey: @"score"])];
                    [service setUnitPrice: VALIDATE_VALUE_STRING([serviceDictionary objectForKey: @"oneUserPrice"])];
                    [service setAddOnePrice: VALIDATE_VALUE_STRING([serviceDictionary objectForKey: @"addUserPrice"])];
                    [service setAddTime: VALIDATE_VALUE_STRING([serviceDictionary objectForKey: @"addTime"])];
                    [service setLineRoad: VALIDATE_VALUE_STRING([serviceDictionary objectForKey: @"lineRoad"])];
                    [service setMainImageUrl: VALIDATE_VALUE_STRING([serviceDictionary objectForKey: @"imgUrl"])];
                    [service setJoinNum: VALIDATE_VALUE_LONG([serviceDictionary objectForKey: @"joinNum"])];
                    [service setServiceAddress: VALIDATE_VALUE_STRING([serviceDictionary objectForKey: @"receptionAddr"])];
                    [service setLatitude: VALIDATE_VALUE_STRING([serviceDictionary objectForKey: @"receptionLat"])];
                    [service setLongitude: VALIDATE_VALUE_STRING([serviceDictionary objectForKey: @"receptionLon"])];
                    ///猎人信息
                    NSDictionary *tempDictioanry = [serviceDictionary objectForKey: @"userInfo"];
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
                    [service setMember: member];
                    [order setService: service];
                }
                ///订单预订者的信息
                NSDictionary *tempMemberDictioanry = [dictionary objectForKey: @"userInfo"];
                MemberObject *member = [[MemberObject alloc] init];
                [member setMemberId:  VALIDATE_VALUE_STRING([tempMemberDictioanry objectForKey: @"id"])];
                [member setMemberAccount:  VALIDATE_VALUE_STRING([tempMemberDictioanry objectForKey: @"account"])];
                [member setMemberPassword:  VALIDATE_VALUE_STRING([tempMemberDictioanry objectForKey: @"password"])];
                [member setMemberPhoto: VALIDATE_VALUE_STRING([tempMemberDictioanry objectForKey: @"imgUrl"])];
                NSInteger sex = [VALIDATE_VALUE_STRING([tempMemberDictioanry objectForKey: @"sex"]) integerValue];
                [member setMemberSex: (sex == 0 ? @"男" : @"女")];
                [member setNickName:  VALIDATE_VALUE_STRING([tempMemberDictioanry objectForKey: @"nickName"])];
                [member setNickName_EN:  VALIDATE_VALUE_STRING([tempMemberDictioanry objectForKey: @"engNickName"])];
                [member setMemberMail:  VALIDATE_VALUE_STRING([tempMemberDictioanry objectForKey: @"mail"])];
                [member setMemberPhone:  VALIDATE_VALUE_STRING([tempMemberDictioanry objectForKey: @"mobile"])];
                [member getMemberType: VALIDATE_VALUE_STRING([tempMemberDictioanry objectForKey: @"userType"])];
                [order setOrderMember: member];
                [listArray addObject: order];
            }
            ///2.执行委托
            switch (interface_type) {
                case 0:
                {
                    ///未成行
                    if([xDelegate respondsToSelector: @selector(orderObject_GetNotTravelOrderList:)]){
                        [xDelegate orderObject_GetNotTravelOrderList: listArray];
                    }
                    break;
                }
                case 1:
                {
                    ///已成行
                    if([xDelegate respondsToSelector: @selector(orderObject_GetTraveledOrderList:)]){
                        [xDelegate orderObject_GetTraveledOrderList: listArray];
                    }
                    break;
                }
                case 2:
                {
                    ///猎人收到的所有订单
                    if([xDelegate respondsToSelector: @selector(orderObject_GetReceivedAllOrderList:)]){
                        [xDelegate orderObject_GetReceivedAllOrderList: listArray];
                    }
                    break;
                }
                case 3:
                {
                    ////猎人拒绝的订单
                    if([xDelegate respondsToSelector: @selector(orderObject_GetRefuseOrderList:)]){
                        [xDelegate orderObject_GetRefuseOrderList: listArray];
                    }
                    break;
                }
                case 4:{
                    ///猎人接受的订单
                    if([xDelegate respondsToSelector: @selector(orderObject_GetAcceptOrderList:)]){
                        [xDelegate orderObject_GetAcceptOrderList: listArray];
                    }
                    break;
                }
                case 7:{
                    ///猎人完成的订单
                    if([xDelegate respondsToSelector: @selector(orderObject_GetCompeleteOrderList:)]){
                        [xDelegate orderObject_GetCompeleteOrderList: listArray];
                    }
                    break;
                }
                default:
                    break;
            }
            break;
        }
    }
}
@end
