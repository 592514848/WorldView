//
//  ModelObject.m
//  WorldView
//
//  Created by WorldView on 15/11/16.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import "ModelObject.h"

@implementation ModelObject
- (id)init
{
    self = [super init];
    if(self){
        applicationClass = [XZJ_ApplicationClass commonApplication];
        asyncRequestData = [[XZJ_AsyncRequestData alloc] initWithDelegate: self];
    }
    return self;
}
@end
