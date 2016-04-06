//
//  ThemeTravelClass.h
//  WorldView
//
//  Created by WorldView on 15/11/23.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MemberObject.h"
#import "ServiceClass.h"

@interface ThemeTravelClass : NSObject
@property(nonatomic, retain) NSString *themeId;
@property(nonatomic, retain) NSString *themeTitle;
@property(nonatomic, retain) NSString *cityId;
@property(nonatomic, retain) NSString *countryId;
@property(nonatomic, retain) NSString *addTime;
@property(nonatomic, retain) NSString *themeImageUrl;
@property(nonatomic, retain) NSArray *hunters;
@property(nonatomic, retain) NSArray *services;
@end
