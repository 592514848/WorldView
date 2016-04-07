//
//  AppointMeetingPlaceView.m
//  WorldView
//
//  Created by WorldView on 15/11/24.
//  Copyright © 2015年 XZJ. All rights reserved.
//
#define MARGIN_LEFT 15.0F
#import "AppointMeetingPlaceView.h"

@implementation AppointMeetingPlaceView
- (id)initWithFrame:(CGRect)frame service: (ServiceClass *)mainService
{
    self = [super initWithFrame: frame];
    if(self){
         CGSize curScreenSize = [[UIScreen mainScreen] bounds].size;
        
        mainApplication = [XZJ_ApplicationClass commonApplication];
        ///1.主视图
        [self setBackgroundColor: [UIColor whiteColor]];
        [self.layer setShadowOpacity: 0.2f];
        [self.layer setShadowOffset: CGSizeMake(0.0f, 2.0f)];
        
        ///2.标题
        XZJ_CustomLabel *titleLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(MARGIN_LEFT, 0.0f, frame.size.width - MARGIN_LEFT, 60.0f)];
        [titleLabel setText: @"见面地点"];
        [titleLabel setTextColor: [mainApplication methodOfTurnToUIColor: @"#0f0f0f"]];
        [titleLabel setFont: [UIFont systemFontOfSize: 16.0f]];
        [self addSubview: titleLabel];
        
        ///3.分割线
        CGFloat origin_y = titleLabel.frame.size.height + titleLabel.frame.origin.y;
        UIView *lineView = [[UIView alloc] initWithFrame: CGRectMake(10.0f, origin_y, frame.size.width - 20.0f, 1.0f)];
        [lineView setBackgroundColor: [mainApplication methodOfTurnToUIColor: @"#dddddd"]];
        [self addSubview: lineView];
        
        ///4.定位图标
        origin_y += lineView.frame.size.height + 10.0f;
        UIImageView *flagImageView = [[UIImageView alloc] initWithFrame: CGRectMake(MARGIN_LEFT, origin_y, 15.0f, 15.0f)];
        [flagImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"icon_flag" ofType: @"png"]]];
        [flagImageView setContentMode: UIViewContentModeScaleAspectFit];
        [self addSubview: flagImageView];
        
        ///5.位置信息
        CGFloat origin_x = flagImageView.frame.size.width + flagImageView.frame.origin.x + 5.0f;
        XZJ_CustomLabel *placeLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x, origin_y, frame.size.width - origin_x, flagImageView.frame.size.height)];
//        [placeLabel setText: @"Ca'Rezzonico 雷佐尼科宫"];
        [placeLabel setText: [NSString stringWithFormat: @"%@", mainService.serviceAddress]];
        [placeLabel setTextColor: [mainApplication methodOfTurnToUIColor: @"#606060"]];
        [placeLabel setFont: [UIFont systemFontOfSize: 14.0f]];
        [self addSubview: placeLabel];
        
        ///6.地图
        origin_y = placeLabel.frame.size.height + placeLabel.frame.origin.y+10.0f;
        mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(MARGIN_LEFT, origin_y, curScreenSize.width - 2 * MARGIN_LEFT, self.frame.size.height - origin_y - 10.0f)];
        [mapView setZoomEnabled: YES];
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake([mainService.latitude doubleValue], [mainService.longitude doubleValue]);
        [mapView setCenterCoordinate: location animated: YES];
//        [mapView setCenterCoordinate: result.location animated: YES];
        BMKPointAnnotation *pointAnnotation = [[BMKPointAnnotation alloc]init];
        pointAnnotation.coordinate = location;
        pointAnnotation.title = mainService.serviceAddress;
        [mapView addAnnotation:pointAnnotation];
        [self addSubview:  mapView];
        ///
    }
    return self;
}

@end
