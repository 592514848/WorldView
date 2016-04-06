//
//  PJStepThreeViewController.m
//  WorldView
//
//  Created by XZJ on 11/6/15.
//  Copyright © 2015 XZJ. All rights reserved.
//
#define STEP_IMAGEVIEW_HEIGHT 15.0F
#define MARGIN_LEFT 15.0F
#define BUTTON_HEIGHT 35.0F
#define BUTTON_WIDTH 100.0F
#define TITLE_HEIGHT 35.0F
#define TEXTFIELD_HEIGHT 40.0F
#define MAP_VIEW_HEIGHT 200.0F
#define BASE_LOCATION_HEIGHT 30.0F
#define MARGIN_TOP 10.0F
#define TEXTVIEW_HEIGHT 120.0F
#import "PJStepThreeViewController.h"
#import "PJStepFourViewController.h"

@implementation PJStepThreeViewController
@synthesize remarksTextView, travelLocationTextFiledArray,curLocationCoordinate, mainService;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle: @"发布旅程"];
    [self loadMainView];
    ////1.开启定位，获取当前位置
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    [_locService startUserLocationService];
    
    ///2.初始化大头针
    if(!pointAnnotation){
        pointAnnotation = [[BMKPointAnnotation alloc]init];
    }
    
    ///3.地址解析
    bmkSearcher =[[BMKGeoCodeSearch alloc]init];
    bmkSearcher.delegate = self;
}

#pragma mark -
#pragma mark 实现相关delegate 处理位置信息更新
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    NSLog(@"heading is %@",userLocation.heading);
}

#pragma mark -
#pragma mark 实现相关delegate 处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    if(curLocationCoordinate .latitude == 0 || curLocationCoordinate.longitude == 0)
    {
        pointAnnotation.coordinate = userLocation.location.coordinate;
        pointAnnotation.title = userLocation.title;
        [mapView setCenterCoordinate: userLocation.location.coordinate animated: YES];
        [mapView addAnnotation:pointAnnotation];
        curLocationCoordinate = userLocation.location.coordinate;
        NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
        //发起反向地理编码检索
        if(!reverseGeoCodeSearchOption)
        {
            reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
        }
        reverseGeoCodeSearchOption.reverseGeoPoint = curLocationCoordinate;
        BOOL flag = [bmkSearcher reverseGeoCode:reverseGeoCodeSearchOption];
        if(!flag)
        {
            NSLog(@"反geo检索发送失败");
        }
    }
}

- (void)loadMainView
{
    ///2.主滚动视图
    CGFloat origin_y = STEP_IMAGEVIEW_HEIGHT + 20.0f;
    mainScrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0.0f, origin_y, curScreenSize.width, curScreenSize.height - origin_y)];
    [mainScrollView setBackgroundColor: [UIColor clearColor]];
    [mainScrollView setShowsVerticalScrollIndicator: NO];
    [mainScrollView setDelegate: self];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(mainScrollViewClik)];
    [mainScrollView addGestureRecognizer: tap];
    [self.view addSubview: mainScrollView];
    
    ///3.标题
    origin_y = 0.0f;
    XZJ_CustomLabel *titleLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(MARGIN_LEFT, origin_y, mainScrollView.frame.size.width - 2 * MARGIN_LEFT, TITLE_HEIGHT)];
    [titleLabel setFont: [UIFont boldSystemFontOfSize: 15.0f]];
    [titleLabel setText: @"见面地点:"];
    [mainScrollView addSubview: titleLabel];
    
    ///4.输入框背景
    origin_y += TITLE_HEIGHT;
    UIView *inputBGView = [[UIView alloc] initWithFrame: CGRectMake(MARGIN_LEFT, origin_y, titleLabel.frame.size.width, TEXTFIELD_HEIGHT)];
    [inputBGView.layer setBorderWidth: 1.0F];
    [inputBGView.layer setBorderColor: [applicationClass methodOfTurnToUIColor: @"#DBDCDD"].CGColor];
    [inputBGView.layer setCornerRadius: 2.0f];
    [mainScrollView addSubview: inputBGView];
    
    ///5.导航按钮
    UIButton *navigationButton = [[UIButton alloc] initWithFrame: CGRectMake(0.0f, 0.0f, TEXTFIELD_HEIGHT, TEXTFIELD_HEIGHT)];
    [navigationButton setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"icon_navigation" ofType: @"png"]] forState: UIControlStateNormal];
    [navigationButton setImageEdgeInsets: UIEdgeInsetsMake(10.0f, 12.0f, 10.0f, 12.0f)];
    [inputBGView addSubview: navigationButton];
    ///6.竖线
    UIView *lineView = [[UIView alloc] initWithFrame: CGRectMake(TEXTFIELD_HEIGHT, 0.0f, 1.0, TEXTFIELD_HEIGHT)];
    [lineView setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#DBDCDD"]];
    [inputBGView addSubview: lineView];
    ///7.位置输入框
    CGFloat origin_x = navigationButton.frame.size.width + navigationButton.frame.origin.x;
    CGFloat size_w = inputBGView.frame.size.width - 2 * TEXTFIELD_HEIGHT - 2.0f;
    locationTextFiled = [[UITextField alloc] initWithFrame: CGRectMake(origin_x, 0.0f, size_w, TEXTFIELD_HEIGHT)];
    [locationTextFiled setFont: [UIFont systemFontOfSize: 14.0f]];
    UIView *leftView = [[UIView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, 10.0f, TEXTFIELD_HEIGHT)];
    [locationTextFiled setLeftViewMode: UITextFieldViewModeAlways];
    [locationTextFiled setLeftView: leftView];
    [locationTextFiled setDelegate: self];
    [locationTextFiled setReturnKeyType: UIReturnKeyDone];
    [inputBGView addSubview: locationTextFiled];
    ///7.竖线
    origin_x += size_w;
    lineView = [[UIView alloc] initWithFrame: CGRectMake(origin_x, 0.0f, 1.0, TEXTFIELD_HEIGHT)];
    [lineView setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#DBDCDD"]];
    [inputBGView addSubview: lineView];
    ///8.搜索按钮
    origin_x += 1.0f;
    UIButton *searchButton = [[UIButton alloc] initWithFrame: CGRectMake(origin_x, 0.0f, TEXTFIELD_HEIGHT, TEXTFIELD_HEIGHT)];
    [searchButton setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"icon_search" ofType: @"png"]] forState: UIControlStateNormal];
    [searchButton setImageEdgeInsets: UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f)];
    [searchButton addTarget: self action: @selector(searchButtonClick) forControlEvents: UIControlEventTouchUpInside];
    [inputBGView addSubview: searchButton];
    
    ///9.地图
    origin_y = inputBGView.frame.size.height + inputBGView.frame.origin.y+10.0f;
    mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(MARGIN_LEFT, origin_y, curScreenSize.width - 2 * MARGIN_LEFT, MAP_VIEW_HEIGHT)];
    [mapView setZoomEnabled: YES];
    [mainScrollView addSubview:  mapView];
    
    ///10.线路描述
    origin_y += MAP_VIEW_HEIGHT;
    titleLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(MARGIN_LEFT, origin_y, mainScrollView.frame.size.width - 2 * MARGIN_LEFT, TITLE_HEIGHT)];
    [titleLabel setFont: [UIFont boldSystemFontOfSize: 15.0f]];
    [titleLabel setText: @"线路描述:"];
    [mainScrollView addSubview: titleLabel];
    
    ///11.线路操作区域
    origin_y += TITLE_HEIGHT;
    travelLineView = [[UIView alloc] initWithFrame: CGRectMake(MARGIN_LEFT, origin_y, titleLabel.frame.size.width, BASE_LOCATION_HEIGHT)];
    [mainScrollView addSubview: travelLineView];
    
    ///12.第一个线路输入框
    NSArray *lineRoadArray = [[mainService lineRoad] componentsSeparatedByString: @"-"];
    travelLocationTextFiledArray = [[NSMutableArray alloc] init];
    baseLocationWidth = (travelLineView.frame.size.width - 40.0f) / 3.0f;
    UITextField *travelTextFiled = [[UITextField alloc] initWithFrame: CGRectMake(0.0f, 0.0f, baseLocationWidth, BASE_LOCATION_HEIGHT)];
    [travelTextFiled.layer setBorderColor: [applicationClass methodOfTurnToUIColor: @"#DBDCDD"].CGColor];
    [travelTextFiled.layer setBorderWidth: 0.5f];
    [travelTextFiled.layer setCornerRadius: 2.0f];
    [travelTextFiled setTextAlignment: NSTextAlignmentCenter];
    [travelTextFiled setFont: [UIFont systemFontOfSize: 14.0f]];
    [travelTextFiled setTextColor: [applicationClass methodOfTurnToUIColor: @"#848686"]];
    [travelTextFiled setDelegate: self];
    [travelTextFiled setReturnKeyType: UIReturnKeyDone];
    [travelLineView addSubview:travelTextFiled];
    if([lineRoadArray count] > 0){
        [travelTextFiled setText: [lineRoadArray objectAtIndex: 0]];
    }
    [travelLocationTextFiledArray addObject: travelTextFiled];
    ///13.添加按钮
    origin_x = travelTextFiled.frame.size.width + travelTextFiled.frame.origin.x;
    addLocationbutton = [[UIButton alloc] initWithFrame: CGRectMake(origin_x, 0.0f, BASE_LOCATION_HEIGHT, BASE_LOCATION_HEIGHT)];
    [addLocationbutton setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"add_location" ofType: @"png"]] forState: UIControlStateNormal];
    [addLocationbutton addTarget: self action: @selector(addTravelLocationButtonClick) forControlEvents: UIControlEventTouchUpInside];
    [addLocationbutton setImageEdgeInsets: UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f)];
    [travelLineView addSubview: addLocationbutton];
    for(NSInteger i = 1; i < [lineRoadArray count]; i++){
        [self addTravelLocationButtonClick];
    }

    
    ///14.备注视图
    origin_y = travelLineView.frame.size.height + travelLineView.frame.origin.y;
    remarksView = [[UIView alloc] initWithFrame: CGRectMake(MARGIN_LEFT, origin_y, mainScrollView.frame.size.width - 2 * MARGIN_LEFT, TITLE_HEIGHT * 2.0f + TEXTVIEW_HEIGHT + 2.0f * BUTTON_HEIGHT)];
    [mainScrollView addSubview: remarksView];
    //标题
    titleLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(0.0f, 10.0f, remarksView.frame.size.width, TITLE_HEIGHT)];
    [titleLabel setFont: [UIFont boldSystemFontOfSize: 15.0f]];
    [titleLabel setText: @"游客须知:"];
    [remarksView addSubview: titleLabel];
    //提示
    origin_y = TITLE_HEIGHT + titleLabel.frame.origin.y;
    XZJ_CustomLabel *tipLable  =[[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(0.0f, origin_y, remarksView.frame.size.width, TITLE_HEIGHT / 1.5f)];
    [tipLable setFont: [UIFont systemFontOfSize: 13.0f]];
    [tipLable setText: @"*该信息会作为Tips显示在游客端"];
    [tipLable setTextColor: [applicationClass methodOfTurnToUIColor: @"#c4c6c6"]];
    [remarksView addSubview: tipLable];
    //输入框
    origin_y += TITLE_HEIGHT / 1.5f;
    remarksTextView = [[UITextView alloc] initWithFrame: CGRectMake(0.0f, origin_y, remarksView.frame.size.width, TEXTVIEW_HEIGHT)];
    [remarksTextView setFont: [UIFont systemFontOfSize: 13.0F]];
    [remarksTextView setTextColor: [applicationClass methodOfTurnToUIColor: @"#c4c6c6"]];
    if([mainService serviceTips]){
        [mainService setServiceTips: [mainService serviceTips]];
    }
    else
        [remarksTextView setText: @"请输入游客须知..."];
    [remarksTextView.layer setBorderColor: [applicationClass methodOfTurnToUIColor: @"#c4c6c6"].CGColor];
    [remarksTextView.layer setBorderWidth: 0.5f];
    [remarksTextView.layer setCornerRadius: 3.0f];
    [remarksTextView setDelegate: self];
    [remarksView addSubview: remarksTextView];
    
    ///4.上一步按钮
    CGFloat margin = (remarksView.frame.size.width - 2 * BUTTON_WIDTH) / 3.0f;
    origin_y += TEXTVIEW_HEIGHT + BUTTON_HEIGHT / 2.0f;
    UIButton *lastStepButton = [[UIButton alloc] initWithFrame: CGRectMake(margin, origin_y, BUTTON_WIDTH, BUTTON_HEIGHT)];
    [lastStepButton setBackgroundColor: [UIColor whiteColor]];
    [lastStepButton setTitleColor: [applicationClass methodOfTurnToUIColor: @"#ef5052"] forState: UIControlStateNormal];
    [lastStepButton setTitle: @"上一步" forState: UIControlStateNormal];
    [lastStepButton.layer setCornerRadius: 3.0f];
    [lastStepButton.titleLabel setFont: [UIFont systemFontOfSize: 14.0f]];
    [lastStepButton.layer setBorderWidth: 0.5f];
    [lastStepButton setTag: 0];
    [lastStepButton.layer setBorderColor:[applicationClass methodOfTurnToUIColor: @"#ef5052"].CGColor];
    [lastStepButton addTarget:self action: @selector(stepButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [remarksView addSubview: lastStepButton];
    
    ///5.下一步按钮
    origin_x = 2 * margin + BUTTON_WIDTH;
    UIButton *nextStepButton = [[UIButton alloc] initWithFrame: CGRectMake(origin_x, origin_y , BUTTON_WIDTH, BUTTON_HEIGHT)];
    [nextStepButton setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#ef5052"]];
    [nextStepButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    [nextStepButton setTitle: @"下一步" forState: UIControlStateNormal];
    [nextStepButton.layer setCornerRadius: 3.0f];
    [nextStepButton.titleLabel setFont: [UIFont systemFontOfSize: 14.0f]];
    [nextStepButton setTag: 1];
    [nextStepButton addTarget:self action: @selector(stepButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [remarksView addSubview: nextStepButton];
    
    ///18.调整滚动视图的contentSize
    CGFloat size_h = remarksView.frame.size.height + remarksView.frame.origin.y + 20.0f;
    size_h = (size_h > curScreenSize.height ? size_h : curScreenSize.height + 20.0f);
    [mainScrollView setContentSize: CGSizeMake(curScreenSize.width, size_h)];
}

- (void)addTravelLocationButtonClick
{
    CGRect lastFrame = [[travelLocationTextFiledArray lastObject] frame];
    CGFloat origin_x = lastFrame.size.width + lastFrame.origin.x;
    CGRect addLocationFrame = [addLocationbutton frame];
    if([travelLocationTextFiledArray count] % 3 == 0){
        origin_x = 0.0f; ///输入框的位置
        lastFrame.origin.y += MARGIN_TOP + BASE_LOCATION_HEIGHT;
    }
    else{
        ///线条
        UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake(origin_x, lastFrame.origin.y + 10.0f, 20.0f, BASE_LOCATION_HEIGHT - 20.0f)];
        [imageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"travel_line" ofType: @"png"]]];
        [imageView setContentMode: UIViewContentModeScaleAspectFit];
        [travelLineView addSubview: imageView];
        origin_x = imageView.frame.size.width + imageView.frame.origin.x;
    }
    ///调整添加按钮的位置
    if([travelLocationTextFiledArray count] % 3 == 2){
        ///更新整体视图的大小
        CGRect travelineFrame = [travelLineView frame];
        travelineFrame.size.height += BASE_LOCATION_HEIGHT + MARGIN_TOP;
        [travelLineView setFrame: travelineFrame];
        ////调整后续视图的大小
        CGRect remarksFrame = [remarksView frame];
        remarksFrame.origin.y = travelLineView.frame.size.height + travelLineView.frame.origin.y;
        [remarksView setFrame: remarksFrame];
        ///调整滚动视图的contentSize
        CGFloat size_h = remarksView.frame.size.height + remarksView.frame.origin.y + 20.0f;
        size_h = (size_h > curScreenSize.height ? size_h : curScreenSize.height + 20.0f);
        [mainScrollView setContentSize: CGSizeMake(curScreenSize.width, size_h)];
        ////
        addLocationFrame.origin.y += BASE_LOCATION_HEIGHT + MARGIN_TOP;
        addLocationFrame.origin.x = 0.0f;
    }
    else{
        addLocationFrame.origin.x += baseLocationWidth + 20.0f;
    }
    [addLocationbutton setFrame: addLocationFrame];
    ///输入框
    UITextField *travelTextFiled = [[UITextField alloc] initWithFrame: CGRectMake(origin_x, lastFrame.origin.y, baseLocationWidth, BASE_LOCATION_HEIGHT)];
    [travelTextFiled.layer setBorderColor: [applicationClass methodOfTurnToUIColor: @"#DBDCDD"].CGColor];
    [travelTextFiled.layer setBorderWidth: 0.5f];
    [travelTextFiled.layer setCornerRadius: 2.0f];
    [travelTextFiled setTextAlignment: NSTextAlignmentCenter];
    [travelTextFiled setFont: [UIFont systemFontOfSize: 14.0f]];
    [travelTextFiled setTextColor: [applicationClass methodOfTurnToUIColor: @"#848686"]];
    [travelTextFiled setDelegate: self];
    [travelTextFiled setReturnKeyType: UIReturnKeyDone];
    NSArray *lineRoadArray = [[mainService lineRoad] componentsSeparatedByString: @"-"];
    if([lineRoadArray count] > [travelLocationTextFiledArray count]){
        [travelTextFiled setText: [lineRoadArray objectAtIndex: [travelLocationTextFiledArray count]]];
    }
    [travelLineView addSubview:travelTextFiled];
    [travelLocationTextFiledArray addObject: travelTextFiled];
}

#pragma mark -
#pragma mark 步骤按钮点击事件
- (void)stepButtonClick:(UIButton *)sender
{
    switch ([sender tag]) {
        case 0:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName: @"PagerViewControllerGoToLast" object: nil];
            break;
        }
        case 1:{
            [[NSNotificationCenter defaultCenter] postNotificationName: @"PagerViewControllerGoToNext" object: nil];
            break;
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark textView委托事件
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    curFirstResponser = textView;
    if([[textView text] isEqualToString: @"请输入游客须知..."]){
        [textView setText: @""];
        [textView setTextColor: [UIColor grayColor]];
    }
}

#pragma mark -
#pragma mark 搜索按钮
- (void)searchButtonClick
{
    //初始化检索对象
    if(!geoCodeSearchOption){
        geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    }
//    geoCodeSearchOption.city= @"北京市";
    geoCodeSearchOption.address = [locationTextFiled text];
    BOOL flag = [bmkSearcher geoCode:geoCodeSearchOption];
    if(flag)
    {
        NSLog(@"geo检索发送成功");
    }
    else
    {
        NSLog(@"geo检索发送失败");
    }
}

- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        pointAnnotation.coordinate = result.location;
        pointAnnotation.title =[locationTextFiled text];
        [mapView setCenterCoordinate: result.location animated: YES];
        curLocationCoordinate = result.location;
        [mapView addAnnotation:pointAnnotation];
    }
    else {
        [applicationClass methodOfShowAlert: @"抱歉，未找到结果"];
    }
}

////接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:
(BMKReverseGeoCodeResult *)result
errorCode:(BMKSearchErrorCode)error{
  if (error == BMK_SEARCH_NO_ERROR) {
      [locationTextFiled setText: [result address]];
  }
  else {
      NSLog(@"抱歉，未找到结果");
  }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [curFirstResponser resignFirstResponder];
}

- (void)mainScrollViewClik
{
    [curFirstResponser resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    curFirstResponser = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
