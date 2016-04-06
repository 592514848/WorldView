//
//  AppointEvalutionView.h
//  WorldView
//
//  Created by WorldView on 15/11/24.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZJ_ApplicationClass.h"
#import "EvalutionObject.h"
#import "SendEvalutionViewController.h"

@interface AppointEvalutionView : UIView<EvalutionObjectDelegate>
{
    XZJ_ApplicationClass *mainApplicaiton;
    UIViewController *superViewController;
    EvalutionObject *evalutionObj;
    NSArray *evalutionArray;
    CGFloat frame_origin_y;
    NSString *serviceID;
}
- (id)initWithFrame:(CGRect)frame superViewController:(UIViewController *) sender serviceID:(NSString *) serviceId;
@end
