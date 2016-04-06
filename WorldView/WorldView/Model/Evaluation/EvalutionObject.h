//
//  EvalutionObject.h
//  WorldView
//
//  Created by WorldView on 15/11/24.
//  Copyright © 2015年 XZJ. All rights reserved.
//
#define EVALUTIONLIST_METHOD_ID @"m0063"
#define SENDEVALUTION_METHOD_ID @"m0013"
#import "ModelObject.h"
#import "EvaluationClass.h"

@protocol EvalutionObjectDelegate <NSObject>
@optional
- (void)evalutionObjectDelegate_GetEvalutionLsit:(NSArray *) dataArray;
- (void)evalutionObjectDelegate_DidSendEvalutionResults:(BOOL) success;
@end

typedef enum {
    kEvalutionList_Request = 0,
    kSendEvalution_Request = 1
}Evalution_Interface_Type;
@interface EvalutionObject : ModelObject
{
    Evalution_Interface_Type interface_type;
}
@property(nonatomic, retain) id<EvalutionObjectDelegate> xDelegate;//委托对象
- (void)getEvalutionList:(NSString *) serviceId;
- (void)sendEvalution:(NSString *)content serviceId:(NSString *) serviceId memberId:(NSString *) memberId score:(NSString *) score;
@end
