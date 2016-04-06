//
//  OrderClass.h
//  WorldView
//
//  Created by WorldView on 15/11/20.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MemberObject.h"
#import "ServiceClass.h"

@interface OrderClass : NSObject
@property(nonatomic,retain) NSString *orderId;///订单编号
@property(nonatomic,retain) NSString *orderNo; ///订单序列号
@property(nonatomic) NSInteger orderStatus; ///订单状态
@property(nonatomic,retain) NSString *serviceId; ///旅程编号（服务编号）
@property(nonatomic,retain) NSString *travelPurpose; //出行目的
@property(nonatomic,retain) NSString *oneselfIntroduce; //自我介绍
@property(nonatomic) NSInteger *travelUserNum; ///旅程人数
@property(nonatomic) double orderPrice; ///订单价格
@property(nonatomic,retain) NSString *addTime; //下单时间
@property(nonatomic,retain) NSString *refuseReason; ///拒绝原因
@property(nonatomic) NSInteger startLevel; ///评星数量
@property(nonatomic,retain) MemberObject *orderMember; ///预订者会员信息
@property(nonatomic, retain) ServiceClass *service; ///服务（旅程）
@property(nonatomic, retain) NSDate *serviceStartTime; ///服务开始时间
@end
