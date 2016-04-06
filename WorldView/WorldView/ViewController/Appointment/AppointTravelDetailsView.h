//
//  AppointTravelDetailsView.h
//  WorldView
//
//  Created by WorldView on 15/11/24.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZJ_ApplicationClass.h"
#import "ServiceClass.h"

@interface AppointTravelDetailsView : UIView
{
    XZJ_ApplicationClass *mainApplication;
    ServiceClass *mainService;
}
@property(nonatomic, retain) UIViewController *viewController;
- (id)initWithFrame:(CGRect)frame service:(ServiceClass *) _service;
@end
