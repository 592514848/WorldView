//
//  CountryObject.m
//  WorldView
//
//  Created by WorldView on 15/11/18.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import "CountryObject.h"
@implementation CountryObject

@synthesize xDelegate;
- (id)init
{
    self = [super init];
    if(self){
        
    }
    return self;
}

#pragma mark 获取国家列表
- (void)countryList
{
    interface_type = kCountryList_Request;
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: COUNTRYLIST_METHOD_ID, @"methodId", nil]] param: nil showIndicator: YES];
}

#pragma mark 获取城市列表
- (void)cityList:(NSString *) contryId
{
    interface_type = kCityList_Request;
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: CityLIST_METHOD_ID, @"methodId", [[NSNumber numberWithLong: (long)contryId] stringValue], @"countryId", nil]] param: nil showIndicator: YES];
}

#pragma mark -
#pragma mark XZJ_AsyncRequestData
- (void)XZJ_AsyncRequestDataReceiveData:(NSDictionary *)responseDictionary
{
    NSLog(@"%@", responseDictionary);
    switch (interface_type) {
        case 0:
        {
            ///城市列表
            if([xDelegate respondsToSelector: @selector(countryObject_GetCountryList:)]){
                NSArray *tempArray = [responseDictionary objectForKey: @"data"];
                if(!IsNSNULL(tempArray)){
                    NSMutableArray *cuntryListArray = [NSMutableArray arrayWithCapacity: [tempArray count]];
                    for(NSDictionary *dictionary in tempArray){
                        CountryClass *country = [[CountryClass alloc] init];
                        [country setCountryId: VALIDATE_VALUE_STRING([dictionary objectForKey: @"id"])];
                        [country setCountryName_CH: VALIDATE_VALUE_STRING([dictionary objectForKey: @"countryName"])];
                        [country setCountryName_EN: VALIDATE_VALUE_STRING([dictionary objectForKey: @"engName"])];
                        [country setHunterNum: VALIDATE_VALUE_STRING([dictionary objectForKey: @"hunterNum"])];
                        [country setImageUrl: VALIDATE_VALUE_STRING([dictionary objectForKey: @"imgUrl"])];
                        [cuntryListArray addObject: country];
                    }
                    [xDelegate countryObject_GetCountryList: cuntryListArray];
                }
            }
            break;
        }
        case 1:
        {
            if([xDelegate respondsToSelector: @selector(countryObject_GetCityList:)]){
                NSArray *tempArray = [responseDictionary objectForKey: @"data"];
                if(!IsNSNULL(tempArray)){
                    NSMutableArray *cityListArray = [NSMutableArray arrayWithCapacity: [tempArray count]];
                    for(NSDictionary *dictionary in tempArray){
                        CityClass *city = [[CityClass alloc] init];
                        [city setCityId: VALIDATE_VALUE_STRING([dictionary objectForKey: @"id"])];
                        [city setCityName: VALIDATE_VALUE_STRING([dictionary objectForKey: @"cityName"])];
                        [city setCityCode: VALIDATE_VALUE_STRING([dictionary objectForKey: @"code"])];
                        [cityListArray addObject: city];
                    }
                    [xDelegate countryObject_GetCityList: cityListArray];
                }
            }
            break;
        }
        default:
            break;
    }
}
@end
