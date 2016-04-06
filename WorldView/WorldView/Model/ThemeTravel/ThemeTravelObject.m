//
//  ThemeTravelObject.m
//  WorldView
//
//  Created by WorldView on 15/11/19.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import "ThemeTravelObject.h"

@implementation ThemeTravelObject
@synthesize xDelegate;
- (id)init
{
    self = [super init];
    if(self){
        
    }
    return self;
}

#pragma mark 获取主题旅程
- (void)getThemetavelList:(NSString *) cityOrCountryId isCountry:(BOOL) isCountry
{
    interface_type = kThemeList_Request;
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: GETTHEMELIST_METHOD_ID, @"methodId", cityOrCountryId, (isCountry ? @"countryId" : @"cityId"), nil]] param: nil showIndicator: YES];
}

- (void)XZJ_AsyncRequestDataReceiveData:(NSDictionary *)responseDictionary
{
    switch (interface_type) {
        case 0:
        {
            if([xDelegate respondsToSelector: @selector(themeTravelObject_GetThemeTravelList:)]){
                NSArray *tempArray = [responseDictionary objectForKey: @"data"];
                NSMutableArray *listArray = [NSMutableArray arrayWithCapacity: [tempArray count]];
                for(NSDictionary *dictionary in tempArray){
                    ThemeTravelClass *theme = [[ThemeTravelClass alloc] init];
                    [theme setThemeId: VALIDATE_VALUE_STRING([dictionary objectForKey: @"id"])];
                    [theme setThemeTitle: VALIDATE_VALUE_STRING([dictionary objectForKey: @"title"])];
                    [theme setCityId: VALIDATE_VALUE_STRING([dictionary objectForKey: @"cityId"])];
                    [theme setCountryId: VALIDATE_VALUE_STRING([dictionary objectForKey: @"countryId"])];
                    [theme setAddTime: VALIDATE_VALUE_STRING([dictionary objectForKey: @"addTime"])];
                    [theme setThemeImageUrl: VALIDATE_VALUE_STRING([dictionary objectForKey: @"imgUrl"])];
                    ///猎人信息
                    NSArray *huntersTempArray = [dictionary objectForKey: @"userList"];
                    NSMutableArray *huntersArray = [NSMutableArray arrayWithCapacity: [huntersTempArray count]];
                    for(NSDictionary *hunterDictionary in huntersTempArray){
                        MemberObject *member = [[MemberObject alloc] init];
                        [member setMemberId:  VALIDATE_VALUE_STRING([hunterDictionary objectForKey: @"id"])];
                        [member setMemberAccount:  VALIDATE_VALUE_STRING([hunterDictionary objectForKey: @"account"])];
                        [member setMemberPassword:  VALIDATE_VALUE_STRING([hunterDictionary objectForKey: @"password"])];
                        [member setMemberPhoto: VALIDATE_VALUE_STRING([hunterDictionary objectForKey: @"imgUrl"])];
                        NSInteger sex = [VALIDATE_VALUE_STRING([hunterDictionary objectForKey: @"sex"]) integerValue];
                        [member setMemberSex: (sex == 0 ? @"男" : @"女")];
                        [member setNickName:  VALIDATE_VALUE_STRING([hunterDictionary objectForKey: @"nickName"])];
                        [member setMemberMail:  VALIDATE_VALUE_STRING([hunterDictionary objectForKey: @"mail"])];
                        [member setMemberPhone:  VALIDATE_VALUE_STRING([hunterDictionary objectForKey: @"mobile"])];
                        [member getMemberType: VALIDATE_VALUE_STRING([hunterDictionary objectForKey: @"userType"])];
                        [huntersArray addObject: member];
                    }
                    [theme setHunters: huntersArray];
                    ///服务信息
                    NSArray *serviceTempArray = [dictionary objectForKey: @"tripList"];
                    if(!IsNSNULL(serviceTempArray))
                    {
                        NSMutableArray *servicesArray = [NSMutableArray arrayWithCapacity: [serviceTempArray count]];
                        for(NSDictionary *serviceDictionary in serviceTempArray){
                            ServiceClass *service = [[ServiceClass alloc] init];
                            [service setServiceId: VALIDATE_VALUE_STRING([serviceDictionary objectForKey: @"id"])];
                            [service setServiceTitle: VALIDATE_VALUE_STRING([serviceDictionary objectForKey: @"title"])];
                            [service setServiceDescription: VALIDATE_VALUE_STRING([serviceDictionary objectForKey: @"description"])];
                            [service setCityId: VALIDATE_VALUE_STRING([serviceDictionary objectForKey: @"cityId"])];
                            [service setCountryId: VALIDATE_VALUE_STRING([serviceDictionary objectForKey: @"countryId"])];
                            [service setCollectionNum: VALIDATE_VALUE_LONG([serviceDictionary objectForKey: @"collectNum"])];
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
                            NSDictionary *tempHunterDictioanry = [serviceDictionary objectForKey: @"userInfo"];
                            MemberObject *member = [[MemberObject alloc] init];
                            [member setMemberId:  VALIDATE_VALUE_STRING([tempHunterDictioanry objectForKey: @"id"])];
                            [member setMemberAccount:  VALIDATE_VALUE_STRING([tempHunterDictioanry objectForKey: @"account"])];
                            [member setMemberPassword:  VALIDATE_VALUE_STRING([tempHunterDictioanry objectForKey: @"password"])];
                            [member setMemberPhoto: VALIDATE_VALUE_STRING([tempHunterDictioanry objectForKey: @"imgUrl"])];
                            NSInteger sex = [VALIDATE_VALUE_STRING([tempHunterDictioanry objectForKey: @"sex"]) integerValue];
                            [member setMemberSex: (sex == 0 ? @"男" : @"女")];
                            [member setNickName:  VALIDATE_VALUE_STRING([tempHunterDictioanry objectForKey: @"nickName"])];
                            [member setMemberMail:  VALIDATE_VALUE_STRING([tempHunterDictioanry objectForKey: @"mail"])];
                            [member setMemberPhone:  VALIDATE_VALUE_STRING([tempHunterDictioanry objectForKey: @"mobile"])];
                            [service setMember: member];
                            [member getMemberType: VALIDATE_VALUE_STRING([tempHunterDictioanry objectForKey: @"userType"])];
                            [servicesArray addObject: service];
                        }
                        [theme setServices: servicesArray];
                    }
                    [listArray addObject: theme];
                }
                [xDelegate themeTravelObject_GetThemeTravelList: listArray];
            }
            break;
        }
        default:
            break;
    }
}
@end
