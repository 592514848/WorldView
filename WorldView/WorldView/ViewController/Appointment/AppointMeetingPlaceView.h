//
//  AppointMeetingPlaceView.h
//  WorldView
//
//  Created by WorldView on 15/11/24.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZJ_ApplicationClass.h"
#import "ServiceClass.h"

@interface AppointMeetingPlaceView : UIView
{
    XZJ_ApplicationClass *mainApplication;
    BMKMapView *mapView;
}

- (id)initWithFrame:(CGRect)frame service: (ServiceClass *)mainService;
@end
