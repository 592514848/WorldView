//
//  PJStepFourViewController.h
//  WorldView
//
//  Created by XZJ on 11/6/15.
//  Copyright © 2015 XZJ. All rights reserved.
//

#import "BaseViewController.h"
#import "ServiceObject.h"

@interface PJStepFourViewController : BaseViewController<ServiceObjectDelegate>
{
    ServiceObject *serviceObj;
    NSMutableArray *serviceImageViewArray;
    NSArray *addtionalServiceArray;
    NSArray *policyArray;
}
@property(nonatomic) ServiceClass *mainService;
@property(nonatomic, retain) NSMutableArray *selectedAddtionalServiceArray;
@property(nonatomic, retain) NSMutableArray *selectedPolicyArray;
@end
