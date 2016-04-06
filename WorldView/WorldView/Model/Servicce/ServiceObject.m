//
//  ServiceObject.m
//  WorldView
//
//  Created by WorldView on 15/11/20.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import "ServiceObject.h"

@implementation ServiceObject
@synthesize xDelegate, page;
- (id)init
{
    self = [super init];
    if(self){
        page = [[PageClass alloc] init];
    }
    return self;
}

#pragma mark 获取服务列表
- (void)serviceList:(NSString *) cityOrCountryId isCountry:(BOOL) isCountry sortType:(Service_Sort_Type) sort memberId:(NSString *) memberId
{
    interface_type = kServiceList_Request;
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: SERVICE_METHOD_ID, @"methodId", cityOrCountryId, (isCountry ? @"countryId" : @"cityId"), [[NSNumber numberWithInt: sort] stringValue], @"sortType", (memberId ? memberId : @""), @"userId", [[NSNumber numberWithInteger: [page currentPage]] stringValue], @"currentPage", [[NSNumber numberWithInteger: [page pageSize]] stringValue], @"pageSize",  nil]] param: nil showIndicator: YES];
}

#pragma mark 获取收藏列表
- (void)getCollectionList:(NSString *) memberID
{
    interface_type = kCollectionList_Request;
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: COLLECTIONLIST_METHOD_ID, @"methodId",memberID, @"userId", [[NSNumber numberWithInteger: [page currentPage]] stringValue], @"currentPage", [[NSNumber numberWithInteger: [page pageSize]] stringValue], @"pageSize", nil]] param: nil showIndicator: YES];
}

#pragma mark 收藏服务（旅程）
- (void)collectionService: (ServiceClass *)service memerID:(NSString *) memberID
{
    interface_type = kCollectionService_Request;
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: COLLECTIONSERVICE_METHOD_ID, @"methodId", [service serviceId], @"tripId", memberID, @"userId", nil]] param: nil showIndicator: YES];
}

#pragma mark 取消收藏的服务（旅程）
- (void)cancelCollectionService: (ServiceClass *)service memerID:(NSString *) memberID
{
    interface_type = kCancelCollection_Request;
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: CANCELCOLLECTION_METHOD_ID, @"methodId", [service serviceId], @"tripId", memberID, @"userId", nil]] param: nil showIndicator: YES];
}

#pragma mark 获取发布的旅程
- (void)getPublishServiceList:(NSString *) memberID
{
    interface_type = kGetPublishService_Request;
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: GETPBLISHSERVICE_METHOD_ID, @"methodId", memberID, @"hunterId", nil]] param: nil showIndicator: YES];
}

#pragma mark 获取猎人上架的旅程
- (void)getHunterShelfOnServiceList:(NSString *) memberID
{
    interface_type = kShelfOnService_Request;
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: GETSHELFONSERVICE_METHOD_ID, @"methodId", memberID, @"hunterId", nil]] param: nil showIndicator: YES];
}

#pragma mark 获取猎人未上架的旅程
- (void)getHunterShelfOffServiceList:(NSString *) memberID
{
    interface_type = kShelfOffService_Request;
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: GETSHELFOFFSERVICE_METHOD_ID, @"methodId", memberID, @"hunterId", nil]] param: nil showIndicator: YES];
}

#pragma mark 下架旅程
- (void)shelfOffService:(NSString *) serviceId memberID:(NSString *)memberID
{
    interface_type = kDidShelfOffService_Request;
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: DIDSHELFOFFSERVICE_METHOD_ID, @"methodId", memberID, @"hunterId", serviceId, @"tripId", nil]] param: nil showIndicator: YES];
}

#pragma mark 获取服务详情
- (void)getServiceDetails:(NSString *) serviceId
{
    interface_type = kServiceDetails_Request;
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: SERVICEDETILS_METHOD_ID, @"methodId", serviceId, @"tripId", nil]] param: nil showIndicator: YES];
}

#pragma mark 预订服务（旅程）
- (void)orderService:(AppointClass *) appointClass
{
    interface_type = kOrderService_Request;
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: ORDERSERVICE_METHOD_ID, @"methodId", [appointClass serviceId], @"tripId", [appointClass memberId], @"userId", [appointClass travelProsonNum], @"userNum", [appointClass travelTimeId], @"tripOrderDateId", [appointClass travelPurpose], @"tripPurpose", [appointClass oneselfIntroduce], @"oneselfIntroduce", nil]] param: nil showIndicator: YES];
}

#pragma mark 获取旅程时间列表
- (void)getTravelTimeList:(NSString *) serviceId
{
    interface_type = kTravelTime_Request;
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: TRAVELTIME_METHOD_ID, @"methodId", serviceId, @"tripId", nil]] param: nil showIndicator: YES];
}

#pragma mark 获取服务类型
- (void)getServiceTypeList
{
    interface_type = kGetServiceType_Request;
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: GETSERVICETYPE_METHOD_ID, @"methodId", nil]] param: nil showIndicator: YES];
}

#pragma mark 获取附加服务列表
- (void)getAddtionalServiceList
{
    interface_type = kAddtionalServiceList_Request;
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: GETADDTIONALSERVICE_METHOD_ID, @"methodId", nil]] param: nil showIndicator: YES];
}

#pragma mark 获取政策列表
- (void)getPolicyList
{
    interface_type = kPolicyList_Request;
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: GETPOLICYLIST_METHOD_ID, @"methodId", nil]] param: nil showIndicator: YES];
}

#pragma mark 上传文件
- (void)uploadFile:(NSData *) imageData fileName:(NSString *) fileName
{
    interface_type = kUploadFile_Request;
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: UPLOADFILE_METHOD_ID, @"methodId", nil]]  fileData: imageData fileName: fileName showIndicator: YES];
}

#pragma mark 发布旅程
- (void)publishService:(ServiceClass *) _service
{
    interface_type = kPublishService_Request;
    NSMutableString *json = [NSMutableString stringWithFormat: @"{\"title\":\"%@\",\"subhead\":\"%@\",\"description\":\"%@\",\"receptionAddr\":\"%@\",\"lineRoad\":\"%@\",\"touristNotice\":\"%@\",\"priceDesc\":\"%@\",\"imgUrl\":\"%@\",\"detailImgDesc\":\"%@\",\"serviceIds\":\"%@\",\"policyIds\":\"%@\",\"tripOrderDates\":\"%@\"", ([_service serviceTitle] == nil ? @"" : [_service serviceTitle]),([_service serviceSubTitle] == nil ? @"" : [_service serviceSubTitle]),([_service serviceDescription] == nil ? @"" : [_service serviceDescription]),([_service serviceAddress] == nil ? @"" : [_service serviceAddress]),([_service lineRoad] == nil ? @"" : [_service lineRoad]),([_service serviceTips] == nil ? @"" : [_service serviceTips]),([_service priceDesc] == nil ? @"" : [_service priceDesc]),([_service mainImageUrl] == nil ? @"" : [_service mainImageUrl]),([_service detailImgDesc] == nil ? @"" : [_service detailImgDesc]),([_service addtionalServicesIds] == nil ? @"" : [_service addtionalServicesIds]),([_service policyIds] == nil ? @"" : [_service policyIds]),([_service tripOrderDates] == nil ? @"" : [_service tripOrderDates])];
    if([_service member]){
        [json appendFormat: @",\"userId\":\"%@\"", [[_service member] memberId]];
    }
    if([_service serviceTimeSize]){
        [json appendFormat: @",\"serviceTimeSize\":\"%@\"", [_service serviceTimeSize]];
    }
    if([_service latitude]){
        [json appendFormat: @",\"receptionLat\":\"%@\"", [_service latitude]];
    }
    if([_service longitude]){
        [json appendFormat: @",\"receptionLon\":\"%@\"", [_service longitude]];
    }
    if([_service unitPrice]){
        [json appendFormat: @",\"oneUserPrice\":\"%@\"", [_service unitPrice]];
    }
    if([_service addOnePrice]){
        [json appendFormat: @",\"addUserPrice\":\"%@\"", [_service addOnePrice]];
    }
    if([_service serivceTypeId]){
         [json appendFormat: @",\"tripTypeId\":\"%@\"", [_service serivceTypeId]];
    }
    if([_service cityId]){
        [json appendFormat: @",\"cityId\":\"%@\"", [_service cityId]];
    }
    if([_service countryId]){
        [json appendFormat: @",\"countryId\":\"%@\"", [_service countryId]];
    }
    if([_service maxJoinNum]){
        [json appendFormat: @",\"receptionNum\":\"%@\"", [_service maxJoinNum]];
    }
    [json appendFormat: @",\"serviceTimeSize\":\"0\""];
    [json appendString: @"}"];
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: PUBLISHSEVICE_METHOD_ID, @"methodId", json, @"jsonStr", nil]] param: nil showIndicator: YES];
}


#pragma mark 该猎人除了当前旅程还提供其它的旅程
- (void)getHunterOtherServiceList:(NSString *) _serviceId memberId:(NSString *) _memberId
{
    interface_type = kHunterOtherervice_Request;
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: HUNTEROTHERSERVICE_METHOD_ID, @"methodId", _serviceId, @"tripId", _memberId, @"hunterId", nil]] param: nil showIndicator: YES];
}

#pragma mark 为你推荐的其它旅程
- (void)getRecommonServiceList:(NSString *) _serviceId
{
    interface_type = kRECOMMONService_Request;
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: RECOMMONSERVICE_METHOD_ID, @"methodId", _serviceId, @"tripId",nil]] param: nil showIndicator: YES];
}

#pragma mark -
#pragma mark XZJ_AsyncRequestData
- (void)XZJ_AsyncRequestDataReceiveData:(NSDictionary *)responseDictionary
{
    NSLog(@"%@", responseDictionary);
    NSLog(@"%@", [responseDictionary objectForKey: @"msg"]);
    switch (interface_type) {
        case 0: case 1: case 4: case 13: case 14: case 15: case 16:
        {
            NSArray *tempArray = [responseDictionary objectForKey: @"data"];
            if(!IsNSNULL(tempArray)){
                NSMutableArray *serviceListArray = [NSMutableArray arrayWithCapacity: [tempArray count]];
                for(NSDictionary *dictionary in tempArray){
                    ServiceClass *service = [[ServiceClass alloc] init];
                    [service setServiceId: VALIDATE_VALUE_STRING([dictionary objectForKey: @"id"])];
                    [service setServiceTitle: VALIDATE_VALUE_STRING([dictionary objectForKey: @"title"])];
                    [service setServiceDescription: VALIDATE_VALUE_STRING([dictionary objectForKey: @"description"])];
                    [service setCityId: VALIDATE_VALUE_STRING([dictionary objectForKey: @"cityId"])];
                    [service setDetailImgDesc: VALIDATE_VALUE_STRING([dictionary objectForKey: @"detailImgDesc"])];
                    [service setCountryId: VALIDATE_VALUE_STRING([dictionary objectForKey: @"countryId"])];
                    [service setCollectionNum: VALIDATE_VALUE_LONG([dictionary objectForKey: @"collectNum"])];
                    [service setSerivceScore: VALIDATE_VALUE_LONG([dictionary objectForKey: @"score"])];
                    [service setUnitPrice: VALIDATE_VALUE_STRING([dictionary objectForKey: @"oneUserPrice"])];
                    [service setAddOnePrice: VALIDATE_VALUE_STRING([dictionary objectForKey: @"addUserPrice"])];
                    [service setAddTime: VALIDATE_VALUE_STRING([dictionary objectForKey: @"addTime"])];
                    [service setLineRoad: VALIDATE_VALUE_STRING([dictionary objectForKey: @"lineRoad"])];
                    [service setMainImageUrl: VALIDATE_VALUE_STRING([dictionary objectForKey: @"imgUrl"])];
                    [service setJoinNum: VALIDATE_VALUE_LONG([dictionary objectForKey: @"joinNum"])];
                    [service setServiceAddress: VALIDATE_VALUE_STRING([dictionary objectForKey: @"receptionAddr"])];
                    [service setLatitude: VALIDATE_VALUE_STRING([dictionary objectForKey: @"receptionLat"])];
                    [service setLongitude: VALIDATE_VALUE_STRING([dictionary objectForKey: @"receptionLon"])];
                    [service setSerivceTypeId: VALIDATE_VALUE_STRING([dictionary objectForKey: @"tripTypeId"])];
                    BOOL isColletion = VALIDATE_VALUE_LONG([dictionary objectForKey: @"isCollected"]) == 1 ? YES : NO;
                    [service setIsCollection: isColletion];
                    ///猎人信息
                    NSDictionary *tempDictioanry = [dictionary objectForKey: @"userInfo"];
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
                    [serviceListArray addObject: service];
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
                ////调用委托方法
                switch (interface_type) {
                    case 0:
                        ///服务列表
                        if([xDelegate respondsToSelector: @selector(serviceObject_GetServiceList:)]){
                            [xDelegate serviceObject_GetServiceList: serviceListArray];
                        }
                        break;
                    case 1:
                        ///收藏列表
                        if([xDelegate respondsToSelector: @selector(serviceObject_GetCollectionList:)]){
                            [xDelegate serviceObject_GetCollectionList: serviceListArray];
                        }
                        break;
                    case 4:
                        ///猎人发布的旅程
                        if([xDelegate respondsToSelector: @selector(serviceObject_GetPublishServiceList:)]){
                            [xDelegate serviceObject_GetPublishServiceList: serviceListArray];
                        }
                        break;
                    case 13:
                        ///该猎人除了当前旅程还提供其它的旅程
                        if([xDelegate respondsToSelector: @selector(serviceObject_GetHunterOtherServiceList:)]){
                            [xDelegate serviceObject_GetHunterOtherServiceList: serviceListArray];
                        }
                        break;
                    case 14:
                        ///为你推荐的其它旅程
                        if([xDelegate respondsToSelector: @selector(serviceObject_GetRecommonServiceList:)]){
                            [xDelegate serviceObject_GetRecommonServiceList: serviceListArray];
                        }
                        break;
                    case 15:
                        ///获取猎人上架的旅程
                        if([xDelegate respondsToSelector: @selector(serviceObject_GetShelfOnServiceList:)]){
                            [xDelegate serviceObject_GetShelfOnServiceList: serviceListArray];
                        }
                        break;
                    case 16:
                        ///获取猎人未上架的旅程
                        if([xDelegate respondsToSelector: @selector(serviceObject_GetShelfOffServiceList:)]){
                            [xDelegate serviceObject_GetShelfOffServiceList: serviceListArray];
                        }
                        break;
                    default:
                        break;
                }
            }
            break;
        }
        case 2:{
            //收藏功能
            if([xDelegate respondsToSelector: @selector(serviceObject_DidCollection:)]){
                 BOOL success = [[responseDictionary objectForKey: @"code"] integerValue] == INTERFACE_SUCEESS_RETURN_CODE ? YES : NO;
                [xDelegate serviceObject_DidCollection: success];
            }
            break;
        }
        case 3:{
            ///取消收藏
            if([xDelegate respondsToSelector: @selector(serviceObject_DidCancelCollection:)]){
                BOOL success = [[responseDictionary objectForKey: @"code"] integerValue] == INTERFACE_SUCEESS_RETURN_CODE ? YES : NO;
                [xDelegate serviceObject_DidCancelCollection: success];
            }
            break;
        }
        case 5:
        {
            ///服务详情
            NSDictionary *dictionary = [responseDictionary objectForKey: @"data"];
            if(!IsNSNULL(dictionary)){
                ServiceClass *service = [[ServiceClass alloc] init];
                [service setServiceId: VALIDATE_VALUE_STRING([dictionary objectForKey: @"id"])];
                [service setDetailImgDesc: VALIDATE_VALUE_STRING([dictionary objectForKey: @"detailImgDesc"])];
                [service setServiceTitle: VALIDATE_VALUE_STRING([dictionary objectForKey: @"title"])];
                [service setServiceDescription: VALIDATE_VALUE_STRING([dictionary objectForKey: @"description"])];
                [service setCityId: VALIDATE_VALUE_STRING([dictionary objectForKey: @"cityId"])];
                [service setCountryId: VALIDATE_VALUE_STRING([dictionary objectForKey: @"countryId"])];
                [service setCollectionNum: VALIDATE_VALUE_LONG([dictionary objectForKey: @"collectNum"])];
                [service setUnitPrice: VALIDATE_VALUE_STRING([dictionary objectForKey: @"oneUserPrice"])];
                [service setAddOnePrice: VALIDATE_VALUE_STRING([dictionary objectForKey: @"addUserPrice"])];
                [service setAddTime: VALIDATE_VALUE_STRING([dictionary objectForKey: @"addTime"])];
                [service setLineRoad: VALIDATE_VALUE_STRING([dictionary objectForKey: @"lineRoad"])];
                [service setMainImageUrl: VALIDATE_VALUE_STRING([dictionary objectForKey: @"imgUrl"])];
                [service setJoinNum: VALIDATE_VALUE_LONG([dictionary objectForKey: @"joinNum"])];
                [service setServiceAddress: VALIDATE_VALUE_STRING([dictionary objectForKey: @"receptionAddr"])];
                [service setLatitude: VALIDATE_VALUE_STRING([dictionary objectForKey: @"receptionLat"])];
                [service setLongitude: VALIDATE_VALUE_STRING([dictionary objectForKey: @"receptionLon"])];
                [service setSerivceTypeId: VALIDATE_VALUE_STRING([dictionary objectForKey: @"tripTypeId"])];
                [service setPolicyIds: VALIDATE_VALUE_STRING([dictionary objectForKey: @"policyIds"])];
                [service setAddtionalServicesIds: VALIDATE_VALUE_STRING([dictionary objectForKey: @"serviceIds"])];
                [service setServiceTimeSize: VALIDATE_VALUE_STRING([dictionary objectForKey: @"serviceTimeSize"])];
                ///猎人信息
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
                [service setMember: member];
                if([xDelegate respondsToSelector: @selector(serviceObject_ServiceDetails:)]){
                    [xDelegate serviceObject_ServiceDetails: service];
                }
            }
            break;
        }
        case 6:
        {
            ///预订服务（旅程）
            if([xDelegate respondsToSelector: @selector(serviceObject_OrderServiceResult:)]){
                BOOL success = [[responseDictionary objectForKey: @"code"] integerValue] == INTERFACE_SUCEESS_RETURN_CODE ? YES : NO;
                [xDelegate serviceObject_OrderServiceResult: success];
            }
            break;
        }
        case 7:
        {
            ///旅程时间列表
            NSArray *tempArray = [responseDictionary objectForKey: @"data"];
            if(!IsNSNULL(tempArray)){
                NSMutableArray *listArray = [NSMutableArray arrayWithCapacity: [tempArray count]];
                for(NSDictionary *dictionary in tempArray){
                    TravelTime *travelTime = [[TravelTime alloc] init];
                    [travelTime setTravelTimeId: VALIDATE_VALUE_STRING([dictionary objectForKey: @"id"])];
                    [travelTime setServiceId: VALIDATE_VALUE_STRING([dictionary objectForKey: @"tripId"])];
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    if(!IsNSNULL([dictionary objectForKey: @"startTime"])){
                        NSDate *date = [dateFormatter dateFromString: [dictionary objectForKey: @"startTime"]];
                        [travelTime setStartTime: date];
                    }
                    if(!IsNSNULL([dictionary objectForKey: @"addTime"])){
                        NSDate *date = [dateFormatter dateFromString: [dictionary objectForKey: @"addTime"]];
                        [travelTime setAddTime: date];
                    }
                    if(!IsNSNULL([dictionary objectForKey: @"orderTime"])){
                        NSDate *date = [dateFormatter dateFromString: [dictionary objectForKey: @"orderTime"]];
                        [travelTime setOrderTime: date];
                    }
                    [travelTime setStatus: VALIDATE_VALUE_STRING([dictionary objectForKey: @"status"])];
                    [listArray addObject: travelTime];
                }
                if([xDelegate respondsToSelector: @selector(serviceObject_GetTravelTimeList:)]){
                    [xDelegate serviceObject_GetTravelTimeList: listArray];
                }
            }
            break;
        }
        case 8:
        {
            ///获取服务类型
            NSArray *tempArray = [responseDictionary objectForKey: @"data"];
            if(!IsNSNULL(tempArray)){
                NSMutableArray *listArray = [NSMutableArray arrayWithCapacity: [tempArray count]];
                for(NSDictionary *dictionary in tempArray){
                    ServiceTypeClass *serviceType = [[ServiceTypeClass alloc] init];
                    [serviceType setServiceTypeId: VALIDATE_VALUE_STRING([dictionary objectForKey: @"id"])];
                    [serviceType setServiceTypeName: VALIDATE_VALUE_STRING([dictionary objectForKey: @"name"])];
                    [listArray addObject: serviceType];
                }
                if([xDelegate respondsToSelector: @selector(serviceObject_GetServiceTypeList:)]){
                    [xDelegate serviceObject_GetServiceTypeList: listArray];
                }
            }
            break;
        }
        case 9:
        {
            ///获取附加服务
            NSArray *tempArray = [responseDictionary objectForKey: @"data"];
            if(!IsNSNULL(tempArray)){
                NSMutableArray *listArray = [NSMutableArray arrayWithCapacity: [tempArray count]];
                for(NSDictionary *dictionary in tempArray){
                    AdditionalServiceClass *addtionalService = [[AdditionalServiceClass alloc] init];
                    [addtionalService setAddtionalServiceId: VALIDATE_VALUE_STRING([dictionary objectForKey: @"id"])];
                    [addtionalService setName: VALIDATE_VALUE_STRING([dictionary objectForKey: @"name"])];
                    [addtionalService setType: VALIDATE_VALUE_STRING([dictionary objectForKey: @"type"])];
                    [addtionalService setType: VALIDATE_VALUE_STRING([dictionary objectForKey: @"ptype"])];
                    [listArray addObject: addtionalService];
                }
                if([xDelegate respondsToSelector: @selector(serviceObject_GetAddtionalServiceList:)]){
                    [xDelegate serviceObject_GetAddtionalServiceList: listArray];
                }
            }
            break;
        }
        case 10:
        {
            ///获取政策
            NSArray *tempArray = [responseDictionary objectForKey: @"data"];
            if(!IsNSNULL(tempArray)){
                NSMutableArray *listArray = [NSMutableArray arrayWithCapacity: [tempArray count]];
                for(NSDictionary *dictionary in tempArray){
                    PolicyClass *policy = [[PolicyClass alloc] init];
                    [policy setPolicyId: VALIDATE_VALUE_STRING([dictionary objectForKey: @"id"])];
                    [policy setName: VALIDATE_VALUE_STRING([dictionary objectForKey: @"name"])];
                    [policy setType: VALIDATE_VALUE_STRING([dictionary objectForKey: @"type"])];
                    [policy setType: VALIDATE_VALUE_STRING([dictionary objectForKey: @"ptype"])];
                    [listArray addObject: policy];
                }
                if([xDelegate respondsToSelector: @selector(serviceObject_GetPolicyList:)]){
                    [xDelegate serviceObject_GetPolicyList: listArray];
                }
            }
            break;
        }
        case 11:{
            ///上传图片
            if([xDelegate respondsToSelector: @selector(serviceObject_UploadFileSuccess:imagePath:)]){
                BOOL success = [[responseDictionary objectForKey: @"code"] integerValue] == INTERFACE_SUCEESS_RETURN_CODE ? YES : NO;
                NSArray *tempArray = [responseDictionary objectForKey: @"data"];
                NSString *imagePath = @"";
                if (!IsNSNULL(tempArray)) {
                    imagePath = [[tempArray objectAtIndex: 0] objectForKey: @"url"];
                }
                [xDelegate serviceObject_UploadFileSuccess: success imagePath:  imagePath];
            }
            break;
        }
        case 12:
        {
            ///发布旅程
            if([xDelegate respondsToSelector: @selector(serviceObject_PublishService:)]){
                BOOL success = [[responseDictionary objectForKey: @"code"] integerValue] == INTERFACE_SUCEESS_RETURN_CODE ? YES : NO;
                [xDelegate serviceObject_PublishService: success];
            }
            break;
        }
        case 17:
        {
            ///下架
            if([xDelegate respondsToSelector: @selector(serviceObject_DidShelfOffService:)]){
                BOOL success = [[responseDictionary objectForKey: @"code"] integerValue] == INTERFACE_SUCEESS_RETURN_CODE ? YES : NO;
                [xDelegate serviceObject_DidShelfOffService: success];
            }
            break;
        }
        default:
            break;
    }
}
@end
