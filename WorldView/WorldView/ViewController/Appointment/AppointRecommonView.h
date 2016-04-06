//
//  AppointRecommonView.h
//  WorldView
//
//  Created by WorldView on 15/11/24.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZJ_ApplicationClass.h"
#import "TravelHunterView.h"
#import "ServiceObject.h"

@interface AppointRecommonView : UIView<ServiceObjectDelegate>
{
    XZJ_ApplicationClass *mainApplication;
    ServiceObject *serviceObj;
    NSArray *serviceArray;
    XZJ_CustomLabel *titleLabel;
}
- (id)initWithFrame:(CGRect)frame service:(ServiceClass *) _service;
@end
