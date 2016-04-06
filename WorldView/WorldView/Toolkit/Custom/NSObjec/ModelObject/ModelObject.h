//
//  ModelObject.h
//  WorldView
//
//  Created by WorldView on 15/11/16.
//  Copyright © 2015年 XZJ. All rights reserved.
//
#define INTERFACE_SUCEESS_RETURN_CODE 10000
#define IsNSNULL(obj) [obj isEqual: [NSNull null]]
#define VALIDATE_VALUE_STRING(obj) ([obj isEqual: [NSNull null]] ? @"" : obj)
#define VALIDATE_VALUE_DOUBLE(obj) ([obj isEqual: [NSNull null]] ? 0 : [obj doubleValue])
#define VALIDATE_VALUE_LONG(obj) ([obj isEqual: [NSNull null]] ? 0 : [obj longValue])

#import <Foundation/Foundation.h>
#import "XZJ_CommonClass.h"

@interface ModelObject : NSObject<XZJ_AsyncRequestDataDelegate>
{
    XZJ_ApplicationClass *applicationClass;
    XZJ_AsyncRequestData *asyncRequestData;
}
@end
