//
//  TravelTime.h
//  WorldView
//
//  Created by WorldView on 15/11/24.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TravelTime : NSObject
@property(nonatomic, retain) NSString *travelTimeId;
@property(nonatomic, retain) NSString *serviceId;
@property(nonatomic, retain) NSDate *startTime; ///可以预订的开始时间
@property(nonatomic, retain) NSDate *orderTime; ///预订时间
@property(nonatomic, retain) NSDate *addTime; ///数据添加时间
@property(nonatomic, retain) NSString *status; ///状态
@end
