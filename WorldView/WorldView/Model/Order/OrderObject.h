//
//  OrderObject.h
//  WorldView
//
//  Created by WorldView on 15/11/20.
//  Copyright © 2015年 XZJ. All rights reserved.
//
#define NOTTRSVELORDER_METHOD_ID @"m0044"
#define TRSVELEDORDER_METHOD_ID @"m0045"
#define RECEIVEDORDER_METHOD_ID @"m0046"
#define REFUSEORDER_METHOD_ID @"m0047"
#define ACCEPTORDER_METHOD_ID @"m0048"
#define DIDACCEPTORDER_METHOD_ID @"m0042"
#define DIDREFUSEORDER_METHOD_ID @"m0043"
#define COMPELETEORDERLIST_METHOD_ID @"m0049"
#define DIDCOMPELETEORDER_METHOD_ID @"m0039"

#import "ModelObject.h"
#import "OrderClass.h"
#import "PageClass.h"
@protocol OrderObjectDelegate <NSObject>
@optional
- (void)orderObject_GetNotTravelOrderList:(NSArray *)dataArray;
- (void)orderObject_GetTraveledOrderList:(NSArray *)dataArray;
- (void)orderObject_GetReceivedAllOrderList:(NSArray *)dataArray;
- (void)orderObject_GetRefuseOrderList:(NSArray *)dataArray;
- (void)orderObject_GetAcceptOrderList:(NSArray *)dataArray;
- (void)orderObject_DidAcceptOrderResult:(BOOL) success;
- (void)orderObject_DidRefuseOrderResult:(BOOL) success;
- (void)orderObject_GetCompeleteOrderList:(NSArray *)dataArray;
- (void)orderObject_DidCompeleteOrderResult:(BOOL) success;
@end

typedef enum {
    kNotTrvale_Request = 0,
    kTraveled_Request = 1,
    kReceivedAllOrder_Request = 2,
    kRefuseOrder_Request = 3,
    kAcceptOrder_Request = 4,
    kDidAcceptOrder_Request = 5,
    kDidRefuseOrder_Request = 6,
    kCompeleteOrderList = 7,
    kDidCompeleteOrder = 8
}Order_Interface_Type;
@interface OrderObject : ModelObject
{
    Order_Interface_Type interface_type;
}
@property(nonatomic, retain) PageClass *page;
@property(nonatomic, retain)id<OrderObjectDelegate> xDelegate;//委托对象
- (void)getNotTravelOrderList:(NSString *) memberID;
- (void)getTraveledOrderList:(NSString *) memberID;
- (void)getReceivedAllOrderList:(NSString *) memberID;
- (void)getRefuseOrderList:(NSString *) memberID;
- (void)getAcceptOrderList:(NSString *) memberID;
- (void)acceptOrder:(NSString *) orderId memberId:(NSString *) memberId;
- (void)refuseOrder:(NSString *) orderId memberId:(NSString *) memberId refuseReason:(NSString *) refuseReason;
- (void)getCompeleteOrderList:(NSString *) memberID;
- (void)compeleteOrder:(NSString *) orderId memberId:(NSString *) memberId;
@end
