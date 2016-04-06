//
//  AdObject.m
//  WorldView
//
//  Created by WorldView on 15/12/5.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import "AdObject.h"

@implementation AdObject
@synthesize xDelegate;

- (id)init
{
    self = [super init];
    if(self){
    }
    return self;
}

#pragma mark 获取广告列表
- (void)getAdList
{
    interface_type = kAdList_Request;
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: ADLIST_METHOD_ID, @"methodId", nil]] param: nil showIndicator: YES];
}

#pragma mark -
#pragma mark XZJ_AsyncRequestData
- (void)XZJ_AsyncRequestDataReceiveData:(NSDictionary *)responseDictionary
{
    NSLog(@"%@", responseDictionary);
    switch (interface_type) {
        case 0:
        {
            ////1.解析数据
            NSArray *tempArray = (IsNSNULL([responseDictionary objectForKey: @"data"]) ? nil : [responseDictionary objectForKey: @"data"]);
            NSMutableArray *listArray = [NSMutableArray arrayWithCapacity: [tempArray count]];
            for(NSDictionary *dictionary in tempArray){
                AdClass *ad = [[AdClass alloc] init];
                [ad setAdId: VALIDATE_VALUE_STRING([dictionary objectForKey: @"id"])];
                [ad setAdTitle: VALIDATE_VALUE_STRING([dictionary objectForKey: @"title"])];
                [ad setAdAddTime: VALIDATE_VALUE_STRING([dictionary objectForKey: @"addTime"])];
                [ad setAdStartTime: VALIDATE_VALUE_STRING([dictionary objectForKey: @"startTime"])];
                [ad setAdEndTime: VALIDATE_VALUE_STRING([dictionary objectForKey: @"endTime"])];
                [ad setAdUrl: VALIDATE_VALUE_STRING([dictionary objectForKey: @"url"])];
                [ad setAdImageUrl: VALIDATE_VALUE_STRING([dictionary objectForKey: @"imgUrl"])];
                [ad setAdStatus: VALIDATE_VALUE_STRING([dictionary objectForKey: @"status"])];
                [listArray addObject: ad];
            }
            ///2.未成行
            if([xDelegate respondsToSelector: @selector(adObjectDelegate_GetAdLsit:)]){
                [xDelegate adObjectDelegate_GetAdLsit: listArray];
            }
            break;
        }
        default:
            break;
    }
}

@end
