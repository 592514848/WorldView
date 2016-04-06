//
//  ThemeTravelObject.h
//  WorldView
//
//  Created by WorldView on 15/11/19.
//  Copyright © 2015年 XZJ. All rights reserved.
//
#define GETTHEMELIST_METHOD_ID @"m0061"
#import <Foundation/Foundation.h>
#import "MemberObject.h"
#import "ThemeTravelClass.h"

@protocol ThemeTravelObjectDelegate <NSObject>
@optional
- (void)themeTravelObject_GetThemeTravelList:(NSArray *) dataArray;
@end

typedef enum {
    kThemeList_Request = 0
    
}Theme_Interface_Type;

@interface ThemeTravelObject : ModelObject
{
    Theme_Interface_Type interface_type;
}
@property(nonatomic, retain)id<ThemeTravelObjectDelegate> xDelegate;//委托对象
- (void)getThemetavelList:(NSString *) cityOrCountryId isCountry:(BOOL) isCountry;
@end
