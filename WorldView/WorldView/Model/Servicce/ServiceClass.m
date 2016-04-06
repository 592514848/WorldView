//
//  ServiceObject.m
//  WorldView
//
//  Created by WorldView on 15/11/19.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import "ServiceClass.h"

@implementation ServiceClass
@synthesize serviceId,serviceDescription,serviceTitle,cityId,collectionNum,unitPrice,addOnePrice,lineRoad,addTime,latitude,longitude, member, mainImageUrl, joinNum, serviceAddress,serivceScore, serivceTypeId,serviceSubTitle,serviceTips, addtionalServicesIds, policyIds, priceDesc,detailImgDesc,maxJoinNum,serviceTimeSize,tripOrderDates;
- (id)init
{
    self = [super init];
    if(self){
    }
    return self;
}
@end
