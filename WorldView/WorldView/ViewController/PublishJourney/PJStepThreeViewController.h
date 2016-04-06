//
//  PJStepThreeViewController.h
//  WorldView
//
//  Created by XZJ on 11/6/15.
//  Copyright © 2015 XZJ. All rights reserved.
//

#import "BaseViewController.h"
#import "ServiceClass.h"

@interface PJStepThreeViewController : BaseViewController<UITextViewDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate, UIScrollViewDelegate, UITextFieldDelegate>
{
    UIScrollView *mainScrollView;
    UIView *travelLineView;
    UIButton *addLocationbutton;
    CGFloat baseLocationWidth;
    UIView *remarksView;
    UITextField *locationTextFiled;
    BMKLocationService *_locService;
    BMKMapView *mapView;
    BMKGeoCodeSearch *bmkSearcher;
    BMKPointAnnotation* pointAnnotation;
    BMKGeoCodeSearchOption *geoCodeSearchOption;
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption;
    id curFirstResponser;
}
@property(nonatomic) ServiceClass *mainService;
@property(nonatomic) CLLocationCoordinate2D curLocationCoordinate;
@property(nonatomic,retain) UITextView *remarksTextView;
@property(nonatomic, retain) NSMutableArray *travelLocationTextFiledArray;
@end
