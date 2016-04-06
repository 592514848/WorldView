//
//  BHStepThreeViewController.h
//  WorldView
//
//  Created by WorldView on 15/11/30.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import "BaseViewController.h"
#import "MemberObject.h"

@interface BHStepThreeViewController : BaseViewController<MemberObjectDelegate>
{
    NSMutableArray *certificateArray;
}
@property(nonatomic, retain) MemberObject *memberObj;
@end
