//
//  AppointClass.h
//  WorldView
//
//  Created by WorldView on 15/11/24.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppointClass : NSObject
@property(nonatomic,retain) NSString *serviceId;
@property(nonatomic,retain) NSString *memberId;
@property(nonatomic,retain) NSString *travelProsonNum;///旅行人数
@property(nonatomic,retain) NSString *travelTimeId; //出行时间编号
@property(nonatomic,retain) NSString *travelPurpose; ///出行目的
@property(nonatomic,retain) NSString *oneselfIntroduce; ///自我介绍
@end
