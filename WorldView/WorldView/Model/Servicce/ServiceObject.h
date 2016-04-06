//
//  ServiceObject.h
//  WorldView
//
//  Created by WorldView on 15/11/20.
//  Copyright © 2015年 XZJ. All rights reserved.
//
#define SERVICE_METHOD_ID @"m0052" ///旅程列表
#define COLLECTIONLIST_METHOD_ID @"m0016" ///收藏列表
#define COLLECTIONSERVICE_METHOD_ID @"m0006" ///加入收藏
#define CANCELCOLLECTION_METHOD_ID @"m0007" ///取消收藏
#define GETPBLISHSERVICE_METHOD_ID @"m0053" ///猎人发布的旅程
#define GETSHELFONSERVICE_METHOD_ID @"m0054" ///猎人上架旅程
#define GETSHELFOFFSERVICE_METHOD_ID @"m0055" ///猎人未上架旅程
#define SERVICEDETILS_METHOD_ID @"m0025"  ///旅程详情
#define ORDERSERVICE_METHOD_ID @"m0040" ///预定旅程
#define TRAVELTIME_METHOD_ID @"m0023" ///旅行时间列表
#define GETSERVICETYPE_METHOD_ID @"m0020" ///获取服务类型列表
#define GETADDTIONALSERVICE_METHOD_ID @"m0021" ///获取附加服务列表
#define GETPOLICYLIST_METHOD_ID @"m0022" ///获取政策列表
#define UPLOADFILE_METHOD_ID @"m0001" ///上传文件
#define PUBLISHSEVICE_METHOD_ID @"m0024"  ///发布旅程
#define HUNTEROTHERSERVICE_METHOD_ID @"m0056"  ///该猎人除了当前旅程还提供其它的旅程
#define RECOMMONSERVICE_METHOD_ID @"m0057"  ///为你推荐的其它旅程
#define DIDSHELFOFFSERVICE_METHOD_ID @"m0027"  ///下架旅程

#import "ModelObject.h"
#import "ServiceClass.h"
#import "AppointClass.h"
#import "TravelTime.h"
#import "ServiceTypeClass.h"
#import "AdditionalServiceClass.h"
#import "PolicyClass.h"
#import "PageClass.h"

@protocol ServiceObjectDelegate <NSObject>
@optional
- (void)serviceObject_GetServiceList:(NSArray *) dataArray;
- (void)serviceObject_GetCollectionList:(NSArray *) dataArray;
- (void)serviceObject_DidCollection:(BOOL) success;
- (void)serviceObject_DidCancelCollection:(BOOL) success;
- (void)serviceObject_GetPublishServiceList:(NSArray *) dataArray;
- (void)serviceObject_ServiceDetails:(ServiceClass *) service;
- (void)serviceObject_OrderServiceResult:(BOOL) success;
- (void)serviceObject_GetTravelTimeList:(NSArray *) dataArray;
- (void)serviceObject_GetServiceTypeList:(NSArray *) dataArray;
- (void)serviceObject_GetAddtionalServiceList:(NSArray *) dataArray;
- (void)serviceObject_GetPolicyList:(NSArray *) dataArray;
- (void)serviceObject_UploadFileSuccess:(BOOL) success imagePath:(NSString *) imagePath;
- (void)serviceObject_PublishService:(BOOL) success;
- (void)serviceObject_GetHunterOtherServiceList:(NSArray *) dataArray;
- (void)serviceObject_GetRecommonServiceList:(NSArray *) dataArray;
- (void)serviceObject_GetShelfOnServiceList:(NSArray *) dataArray;
- (void)serviceObject_GetShelfOffServiceList:(NSArray *) dataArray;
- (void)serviceObject_DidShelfOffService:(BOOL) success;
@end
typedef enum {
    kServiceList_Request = 0,
    kCollectionList_Request = 1,
    kCollectionService_Request = 2,
    kCancelCollection_Request = 3,
    kGetPublishService_Request = 4,
    kServiceDetails_Request = 5,
    kOrderService_Request = 6,
    kTravelTime_Request = 7,
    kGetServiceType_Request = 8,
    kAddtionalServiceList_Request = 9,
    kPolicyList_Request = 10,
    kUploadFile_Request = 11,
    kPublishService_Request = 12,
    kHunterOtherervice_Request = 13,
    kRECOMMONService_Request = 14,
    kShelfOnService_Request = 15,
    kShelfOffService_Request = 16,
    kDidShelfOffService_Request = 17
}Service_Interface_Type;

typedef enum {
    kComprehensive_Sort = 1, ///综合排序
    kNew_Sort = 2, ///最新
    kPopularity_Type = 3, ///人气最高
    kAverageScore_Type = 4 ///平均分最高
}Service_Sort_Type;

@interface ServiceObject : ModelObject
{
    Service_Interface_Type interface_type;
}
@property(nonatomic, retain) PageClass *page;
@property(nonatomic, retain)id<ServiceObjectDelegate> xDelegate;//委托对象
- (void)serviceList:(NSString *) cityOrCountryId isCountry:(BOOL) isCountry sortType:(Service_Sort_Type) sort memberId:(NSString *) memberId;
- (void)getCollectionList:(NSString *) memberID;
- (void)collectionService: (ServiceClass *)service memerID:(NSString *) memberID;
- (void)cancelCollectionService: (ServiceClass *)service memerID:(NSString *) memberID;
- (void)getPublishServiceList:(NSString *) memberID;
- (void)getServiceDetails:(NSString *) serviceId;
- (void)orderService:(AppointClass *) appointClass;
- (void)getTravelTimeList:(NSString *) serviceId;
- (void)getServiceTypeList;
- (void)getAddtionalServiceList;
- (void)getPolicyList;
- (void)uploadFile:(NSData *) imageData fileName:(NSString *) fileName;
- (void)publishService:(ServiceClass *) _service;
- (void)getHunterOtherServiceList:(NSString *) _serviceId memberId:(NSString *) _memberId;
- (void)getRecommonServiceList:(NSString *) _serviceId;
- (void)getHunterShelfOnServiceList:(NSString *) memberID;
- (void)getHunterShelfOffServiceList:(NSString *) memberID;
- (void)shelfOffService:(NSString *) serviceId memberID:(NSString *)memberID;
@end
