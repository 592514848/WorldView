//
//  CountryObject.h
//  WorldView
//
//  Created by WorldView on 15/11/18.
//  Copyright © 2015年 XZJ. All rights reserved.
//
#define COUNTRYLIST_METHOD_ID @"m0008"
#define CityLIST_METHOD_ID @"m0009"
#import "ModelObject.h"
#import "CountryClass.h"
#import "CityClass.h"

@protocol CountryObjectDelegate <NSObject>
@optional
- (void)countryObject_GetCountryList:(NSArray *) dataArray;
- (void)countryObject_GetCityList:(NSArray *) dataArray;
@end

typedef enum {
    kCountryList_Request = 0,
    kCityList_Request = 1
}Interface_Type;

@interface CountryObject : ModelObject
{
    Interface_Type interface_type;
}
@property(nonatomic, retain)id<CountryObjectDelegate> xDelegate;//委托对象
- (void)countryList;
- (void)cityList:(NSString *) contryId;
@end
