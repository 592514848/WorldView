//
//  AdObject.h
//  WorldView
//
//  Created by WorldView on 15/12/5.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#define ADLIST_METHOD_ID @"m0033"
#import "ModelObject.h"
#import "AdClass.h"

@protocol AdObjectDelegate <NSObject>
@optional
- (void)adObjectDelegate_GetAdLsit:(NSArray *) dataArray;
@end

typedef enum {
    kAdList_Request = 0
}Ad_Interface_Type;
@interface AdObject : ModelObject
{
    Ad_Interface_Type interface_type;
}
@property(nonatomic, retain) id<AdObjectDelegate> xDelegate;//委托对象
- (void)getAdList;
@end
