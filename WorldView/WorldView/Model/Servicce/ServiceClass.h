//
//  ServiceObject.h
//  WorldView
//
//  Created by WorldView on 15/11/19.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MemberObject.h"

@interface ServiceClass : NSObject
@property(nonatomic, retain) NSString *serviceId;
@property(nonatomic, retain) NSString *serviceTitle;
@property(nonatomic, retain) NSString *serviceSubTitle;
@property(nonatomic, retain) NSString *serviceDescription;
@property(nonatomic, retain) NSString *serviceAddress;  ///服务（旅程）的地点
@property(nonatomic, retain) NSString *serviceTimeSize; ///服务（旅程）时长
@property(nonatomic, retain) NSString *mainImageUrl;
@property(nonatomic, retain) NSString *cityId;
@property(nonatomic, retain) NSString *countryId;
@property(nonatomic, retain) NSString *unitPrice;
@property(nonatomic, retain) NSString *addOnePrice;
@property(nonatomic, retain) NSString *lineRoad;
@property(nonatomic, retain) NSString *addTime;
@property(nonatomic) long collectionNum;
@property(nonatomic) long joinNum;  ///目前参加的人数
@property(nonatomic, retain) NSString *maxJoinNum;  ///最大接受的人数
@property(nonatomic, retain) NSString *longitude;
@property(nonatomic, retain) NSString *latitude;
@property(nonatomic, retain) MemberObject *member;
@property(nonatomic) NSInteger serivceScore;
@property(nonatomic, retain) NSString *serivceTypeId;
@property(nonatomic, retain) NSString *serviceTips;
@property(nonatomic, retain) NSString *addtionalServicesIds; ///附加服务
@property(nonatomic, retain) NSString *policyIds; ///附加政策
@property(nonatomic, retain) NSString *priceDesc; ///费用说明
@property(nonatomic, retain) NSString *detailImgDesc; ///服务详情图文描述（使用json）
@property(nonatomic, retain) NSString *tripOrderDates; ////可以预定的时间
@property(nonatomic) BOOL isCollection; ////是否收藏
@end
