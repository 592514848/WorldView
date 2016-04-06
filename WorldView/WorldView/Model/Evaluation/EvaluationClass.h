//
//  EvaluationClass.h
//  WorldView
//
//  Created by WorldView on 15/11/24.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MemberObject.h"

@interface EvaluationClass : NSObject
@property(nonatomic, retain) NSString *evalutionId;
@property(nonatomic, retain) NSString *serviceId;
@property(nonatomic, retain) MemberObject *member;
@property(nonatomic, retain) NSString *evalutionContent;
@property(nonatomic) NSInteger evalutionScore;
@property(nonatomic, retain) NSString *addTime;
@end
