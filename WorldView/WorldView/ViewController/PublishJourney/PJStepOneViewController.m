//
//  PJStepOneViewController.m
//  WorldView
//
//  Created by XZJ on 11/4/15.
//  Copyright © 2015 XZJ. All rights reserved.
//
#define STEP_IMAGEVIEW_HEIGHT 15.0F
#define TITLE_LABEL_HEIGHT 30.0F
#define TITLE_VALUE_HEIGHT 30.0F
#define TYPE_MARGIN_LEFT 15.0F
#define BUTTON_HEIGHT 35.0F
#define BUTTON_WIDTH 100.0F
#import "PJStepOneViewController.h"
#import "PJStepTwoViewController.h"

@implementation PJStepOneViewController
@synthesize numberTextfiled, selectedServiceTypeId,selectedCountryId, timeSizeTextfiled;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle: @"发布旅程"];
    ///1.获取国家列表
    countryObj = [[CountryObject alloc] init];
    [countryObj setXDelegate: self];
    [countryObj countryList];
    ///2.获取服务类型列表
    serviceObj = [[ServiceObject alloc] init];
    [serviceObj setXDelegate: self];
    [serviceObj getServiceTypeList];
    ///3.初始化控件
    numberTextfiled = [[UITextField alloc] init];
    timeSizeTextfiled = [[UITextField alloc] init];
}

#pragma mark -
#pragma mark countryObject委托
- (void)countryObject_GetCountryList:(NSArray *)dataArray
{
    countryDataArray = dataArray;
}

#pragma mark -
#pragma mark serviceObject委托
- (void)serviceObject_GetServiceTypeList:(NSArray *)dataArray
{
    serviceTypeDataArray = dataArray;
    [self loadMainView];
}

- (void)loadMainView
{
//    ///1.设置进度条
//    UIImageView *stepImageView = [[UIImageView alloc] initWithFrame: CGRectMake(10.0f, 10.0f, curScreenSize.width - 20.0f, STEP_IMAGEVIEW_HEIGHT)];
//    [stepImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"step_one" ofType: @"png"]]];
//    [stepImageView setContentMode: UIViewContentModeScaleAspectFit];
//    [self.view addSubview: stepImageView];
    
    ///2.主滚动视图
    CGFloat origin_y = STEP_IMAGEVIEW_HEIGHT + 20.0f;
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0.0f, origin_y, curScreenSize.width, curScreenSize.height - origin_y)];
    [mainScrollView setBackgroundColor: [UIColor clearColor]];
    [mainScrollView setShowsVerticalScrollIndicator: NO];
    [self.view addSubview: mainScrollView];
    
    ///3.选择类型
    XZJ_CustomLabel *titleLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(10.0f, 10.0f, mainScrollView.frame.size.width - 20.0f, TITLE_LABEL_HEIGHT)];
    [titleLabel setText: @"选择类型："];
    [titleLabel setFont: [UIFont boldSystemFontOfSize: 15.0f]];
    [mainScrollView addSubview: titleLabel];
    
    ///4.类型的选项
    origin_y = titleLabel.frame.origin.y + TITLE_LABEL_HEIGHT;
    CGFloat size_w = (curScreenSize.width - 4 * TYPE_MARGIN_LEFT) / 3.0f;
    CGFloat origin_x = 0.0f;
    typeImageViewArray = [NSMutableArray arrayWithCapacity: [serviceTypeDataArray count]];
    for(NSInteger i = 0 ;i < [serviceTypeDataArray count]; i++){
        NSInteger row = i / 3;
        ServiceTypeClass *serviceType = [serviceTypeDataArray objectAtIndex: i];
        UIView *tempView = [[UIView alloc] initWithFrame: CGRectMake((i % 3) * (size_w + TYPE_MARGIN_LEFT) + TYPE_MARGIN_LEFT, origin_y + row * TITLE_VALUE_HEIGHT, size_w, TITLE_VALUE_HEIGHT)];
        [tempView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(onCheckedType:)];
        [tempView addGestureRecognizer: tap];
        [tempView setTag: i];
        [mainScrollView addSubview: tempView];
        ///复选框
        UIImageView *tempImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0.0f, 8.0f, TITLE_VALUE_HEIGHT - 16.0f, TITLE_VALUE_HEIGHT - 16.0f)];
        [tempImageView setContentMode: UIViewContentModeScaleAspectFit];
        if([selectedServiceTypeId longLongValue] == [[serviceType serviceTypeId] longLongValue]){
            [tempImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"selection_checked" ofType:@"png"]]];
            [tempImageView setTag: 1];
            lastSelectedImageView =  tempImageView;
        }
        else{
            [tempImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"selection_none" ofType:@"png"]]];
            [tempImageView setTag: 0];//默认都是0，表示没有被选中
        }
        [tempView addSubview: tempImageView];
        [typeImageViewArray addObject: tempImageView];
        ///名称
        origin_x = tempImageView.frame.size.width + tempImageView.frame.origin.x + 5.0f;
        XZJ_CustomLabel *nameLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x, 0.0f, size_w - origin_x, TITLE_VALUE_HEIGHT)];
        [nameLabel setText: [serviceType serviceTypeName]];
        [nameLabel setAdjustsFontSizeToFitWidth: YES];
        [nameLabel setFont: [UIFont systemFontOfSize: 12.0f]];
        [nameLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#5e5f60"]];
        [tempView addSubview: nameLabel];
    }
    
    ///5.虚线
    origin_y += ([serviceTypeDataArray count] / 3 + 1.0f) * TITLE_VALUE_HEIGHT + 10.0f;
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame: CGRectMake(titleLabel.frame.origin.x, origin_y, mainScrollView.frame.size.width - 2 * titleLabel.frame.origin.x, 1.0f)];
    [lineImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"pot_line" ofType: @"png"]]];
    [mainScrollView addSubview: lineImageView];
    ///6.人数选择
    origin_y += lineImageView.frame.size.height;
    titleLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(10.0f, origin_y, mainScrollView.frame.size.width - 20.0f, 2 * TITLE_LABEL_HEIGHT)];
    [titleLabel setText: @"可接待人数："];
    [titleLabel setFont: [UIFont boldSystemFontOfSize: 15.0f]];
    [mainScrollView addSubview: titleLabel];
    
    ///7.减号
    origin_x = mainScrollView.frame.size.width * 2.0f / 3.5f;
    origin_y += 10.0f;
    CGFloat size_h = 2 * TITLE_LABEL_HEIGHT - 20.0f;
    UIButton *reduceButton = [[UIButton alloc] initWithFrame: CGRectMake(origin_x, origin_y, size_h, size_h)];
    [reduceButton setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#ef5052"]];
    [reduceButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    [reduceButton setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"icon_reduce" ofType: @"png"]] forState: UIControlStateNormal];
    [reduceButton setImageEdgeInsets: UIEdgeInsetsMake(12.0f, 12.0f, 12.0f, 12.0f)];
    [reduceButton setTag: 0];
    [reduceButton addTarget: self action: @selector(operateNumberClick:) forControlEvents: UIControlEventTouchUpInside];
    [mainScrollView addSubview: reduceButton];
    
    ///8.人数
    origin_y = reduceButton.frame.origin.y;
    origin_x = reduceButton.frame.size.width + reduceButton.frame.origin.x;
    maxNumber = 3;
    [numberTextfiled setFrame: CGRectMake(origin_x, origin_y, 1.5f *size_h, size_h)];
    [numberTextfiled setTextAlignment: NSTextAlignmentCenter];
    [numberTextfiled setFont: [UIFont systemFontOfSize: 13.0f]];
    [numberTextfiled setTextColor: [applicationClass methodOfTurnToUIColor: @"#323437"]];
    [numberTextfiled.layer setBorderWidth: 0.5f];
    [numberTextfiled.layer setBorderColor: [applicationClass methodOfTurnToUIColor: @"#ef5052"].CGColor];
    [numberTextfiled setKeyboardType: UIKeyboardTypeNumberPad];
    [numberTextfiled setDelegate: self];
    [mainScrollView addSubview: numberTextfiled];
    
    ///9.加号
    origin_x = numberTextfiled.frame.size.width + numberTextfiled.frame.origin.x;
    UIButton *addButton = [[UIButton alloc] initWithFrame: CGRectMake(origin_x, origin_y , size_h, size_h)];
    [addButton setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#ef5052"]];
    [addButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    [addButton setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"icon_add" ofType: @"png"]] forState: UIControlStateNormal];
    [addButton setImageEdgeInsets: UIEdgeInsetsMake(12.0f, 12.0f, 12.0f, 12.0f)];
    [addButton setTag: 1];
    [addButton addTarget: self action: @selector(operateNumberClick:) forControlEvents: UIControlEventTouchUpInside];
    [mainScrollView addSubview: addButton];
    
    ///10.虚线
    origin_y = titleLabel.frame.size.height + titleLabel.frame.origin.y;
    lineImageView = [[UIImageView alloc] initWithFrame: CGRectMake(titleLabel.frame.origin.x, origin_y, mainScrollView.frame.size.width - 2 * titleLabel.frame.origin.x, 1.0f)];
    [lineImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"pot_line" ofType: @"png"]]];
    [mainScrollView addSubview: lineImageView];
    
    ///11.所在城市
    origin_y += lineImageView.frame.size.height;
    titleLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(10.0f, origin_y, mainScrollView.frame.size.width - 20.0f, 2 * TITLE_LABEL_HEIGHT)];
    [titleLabel setText: @"所在城市："];
    [titleLabel setFont: [UIFont boldSystemFontOfSize: 15.0f]];
    [mainScrollView addSubview: titleLabel];
    
    ////12.输入框背景
    UIView *inputBGView = [[UIView alloc] initWithFrame: CGRectMake(mainScrollView.frame.size.width / 2.0f,  origin_y + 10.0f, mainScrollView.frame.size.width / 2.0f - 20.0f, 2.0f * TITLE_LABEL_HEIGHT - 20.0f)];
    [inputBGView.layer setBorderWidth: 0.5f];
    [inputBGView.layer setBorderColor: [applicationClass methodOfTurnToUIColor: @"#ef5052"].CGColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(openPickerView)];
    [inputBGView setUserInteractionEnabled: YES];
    [inputBGView addGestureRecognizer: tap];
    [mainScrollView addSubview: inputBGView];
    
    ///13.选择国家
    cityTextfiled = [[UITextField alloc] initWithFrame: CGRectMake(0.0f, 0.0f, inputBGView.frame.size.width - inputBGView.frame.size.height, inputBGView.frame.size.height)];
    [cityTextfiled setTextAlignment: NSTextAlignmentCenter];
    [cityTextfiled setFont: [UIFont systemFontOfSize: 13.0f]];
    [cityTextfiled setTextColor: [applicationClass methodOfTurnToUIColor: @"#323437"]];
    [cityTextfiled setPlaceholder: @"-请选择国家-"];
    [cityTextfiled setEnabled: NO];
    [inputBGView addSubview: cityTextfiled];
    
    ///14.竖线
    origin_x = cityTextfiled.frame.size.width + cityTextfiled.frame.origin.x;
    UIView *lineView = [[UIView alloc] initWithFrame: CGRectMake(origin_x, 0.0f, 0.5f, cityTextfiled.frame.size.height)];
    [lineView setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#ef5052"]];
    [inputBGView addSubview: lineView];
    
    ///15.向下的箭头
    origin_x += lineView.frame.size.width;
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame: CGRectMake(origin_x, 15.0f, inputBGView.frame.size.width - origin_x, inputBGView.frame.size.height - 30.0f)];
    [arrowImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"down_arrow" ofType: @"png"]]];
    [arrowImageView setContentMode: UIViewContentModeScaleAspectFit];
    [inputBGView addSubview: arrowImageView];
    
    ///16.虚线
    origin_y = inputBGView.frame.size.height + inputBGView.frame.origin.y;
    lineImageView = [[UIImageView alloc] initWithFrame: CGRectMake(titleLabel.frame.origin.x, origin_y, mainScrollView.frame.size.width - 2 * titleLabel.frame.origin.x, 1.0f)];
    [lineImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"pot_line" ofType: @"png"]]];
    [mainScrollView addSubview: lineImageView];
    
    ///17.旅程时长
    origin_y += lineImageView.frame.size.height;
    titleLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(10.0f, origin_y, mainScrollView.frame.size.width - 20.0f, 2 * TITLE_LABEL_HEIGHT)];
    [titleLabel setText: @"旅程时长："];
    [titleLabel setFont: [UIFont boldSystemFontOfSize: 15.0f]];
    [mainScrollView addSubview: titleLabel];
    
    ////18.输入框
    inputBGView = [[UIView alloc] initWithFrame: CGRectMake(mainScrollView.frame.size.width / 2.0f,  origin_y + 10.0f, mainScrollView.frame.size.width / 2.0f - 20.0f, 2.0f * TITLE_LABEL_HEIGHT - 20.0f)];
    [inputBGView.layer setBorderWidth: 0.5f];
    [inputBGView.layer setBorderColor: [applicationClass methodOfTurnToUIColor: @"#ef5052"].CGColor];
    tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(openDatePickerView)];
    [inputBGView setUserInteractionEnabled: YES];
    [inputBGView addGestureRecognizer: tap];
    [mainScrollView addSubview: inputBGView];
    
    ///19.选择时长
    [timeSizeTextfiled setFrame: CGRectMake(0.0f, 0.0f, inputBGView.frame.size.width - inputBGView.frame.size.height, inputBGView.frame.size.height)];
    [timeSizeTextfiled setTextAlignment: NSTextAlignmentCenter];
    [timeSizeTextfiled setFont: [UIFont systemFontOfSize: 13.0f]];
    [timeSizeTextfiled setTextColor: [applicationClass methodOfTurnToUIColor: @"#323437"]];
    [timeSizeTextfiled setPlaceholder: @"-请选择旅程时长-"];
    [timeSizeTextfiled setEnabled: NO];
    [inputBGView addSubview: timeSizeTextfiled];
    
    ///20.竖线
    origin_x = cityTextfiled.frame.size.width + cityTextfiled.frame.origin.x;
    lineView = [[UIView alloc] initWithFrame: CGRectMake(origin_x, 0.0f, 0.5f, cityTextfiled.frame.size.height)];
    [lineView setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#ef5052"]];
    [inputBGView addSubview: lineView];
    
    ///21.向下的箭头
    origin_x += lineView.frame.size.width;
    arrowImageView = [[UIImageView alloc] initWithFrame: CGRectMake(origin_x, 15.0f, inputBGView.frame.size.width - origin_x, inputBGView.frame.size.height - 30.0f)];
    [arrowImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"down_arrow" ofType: @"png"]]];
    [arrowImageView setContentMode: UIViewContentModeScaleAspectFit];
    [inputBGView addSubview: arrowImageView];
    
    ///22.虚线
    origin_y = titleLabel.frame.size.height + titleLabel.frame.origin.y;
    lineImageView = [[UIImageView alloc] initWithFrame: CGRectMake(titleLabel.frame.origin.x, origin_y, mainScrollView.frame.size.width - 2 * titleLabel.frame.origin.x, 1.0f)];
    [lineImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"pot_line" ofType: @"png"]]];
    [mainScrollView addSubview: lineImageView];
    
    ///23.下一步按钮
    origin_y = lineImageView.frame.size.height + lineImageView.frame.origin.y + 30.0f;
    UIButton *nextStepButton = [[UIButton alloc] initWithFrame: CGRectMake((mainScrollView.frame.size.width - BUTTON_WIDTH) / 2.0F, origin_y , BUTTON_WIDTH, BUTTON_HEIGHT)];
    [nextStepButton setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#ef5052"]];
    [nextStepButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    [nextStepButton setTitle: @"下一步" forState: UIControlStateNormal];
    [nextStepButton.layer setCornerRadius: 3.0f];
    [nextStepButton.titleLabel setFont: [UIFont systemFontOfSize: 14.0f]];
    [nextStepButton addTarget: self action: @selector(nextStepButtonClick) forControlEvents: UIControlEventTouchUpInside];
    [mainScrollView addSubview: nextStepButton];
    
    ///24.调整滚动视图的contentSize
    size_h = nextStepButton.frame.size.height + nextStepButton.frame.origin.y + 20.0f;
    size_h = (size_h > curScreenSize.height ? size_h : curScreenSize.height + 20.0f);
    [mainScrollView setContentSize: CGSizeMake(curScreenSize.width, size_h)];
}

#pragma mark -
#pragma mark 单选框事件
- (void)onCheckedType:(UITapGestureRecognizer *)sender
{
    if(lastSelectedImageView){
        [lastSelectedImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"selection_none" ofType: @"png"]]];
        [lastSelectedImageView setTag: 0];
        selectedServiceTypeId = @"";
    }
    UIImageView *tempImageView = [typeImageViewArray objectAtIndex: [sender.view tag]];
    if(lastSelectedImageView != tempImageView){
        if([tempImageView tag] == 0){
            [tempImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"selection_checked" ofType: @"png"]]];
            [tempImageView setTag: 1];
            ServiceTypeClass *typeClass = [serviceTypeDataArray objectAtIndex: [sender.view tag]];
            selectedServiceTypeId = [typeClass serviceTypeId];
        }
        else{
            [tempImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"selection_none" ofType: @"png"]]];
            [tempImageView setTag: 0];
            selectedServiceTypeId = @"";
        }
        [typeImageViewArray setObject: tempImageView atIndexedSubscript: [sender.view tag]];
        lastSelectedImageView = tempImageView;
    }
}

#pragma mark -
#pragma mark 人数的操作事件
- (void)operateNumberClick:(UIButton *)sender
{
    NSInteger curNumber = [[numberTextfiled text] integerValue];
    switch ([sender tag]) {
        case 0:
        {
            if(curNumber > 1){
                [numberTextfiled setText: [[NSNumber numberWithInteger: --curNumber] stringValue]];
            }
            break;
        }
        case 1:
        {
            if(curNumber < maxNumber){
                [numberTextfiled setText: [[NSNumber numberWithInteger: ++curNumber] stringValue]];
            }
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark textField委托事件
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    curFirstResponser = textField;
    [self XZJ_CustomPicker_CancelClick: 0];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [curFirstResponser resignFirstResponder];
    NSInteger curNumber = [[textField text] integerValue];
    if(curNumber <= 0){
        [numberTextfiled setText: @"1"];
    }
    else if(curNumber > maxNumber){
        [numberTextfiled setText: [[NSNumber numberWithInteger: maxNumber] stringValue]];
    }
}

#pragma mark -
#pragma mark 打开选择器
- (void)openPickerView
{
    [curFirstResponser resignFirstResponder];
    [self XZJ_CustomPicker_CancelClick: 1];
    if(!mainPickerView)
    {
        NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity: [countryDataArray count]];
        for(CountryClass *country in countryDataArray){
            [dataArray addObject: [country countryName_CH]];
        }
        mainPickerView = [[XZJ_CustomPicker alloc] initWithFrame:CGRectMake(0.0f, curScreenSize.height, curScreenSize.width, curScreenSize.height/2.0f) dataArray: [NSArray arrayWithObject: dataArray]];
        [mainPickerView setDelegate: self];
        [mainPickerView setTag: 0];
        [self.view addSubview: mainPickerView];
    }
    NSString *rectString = NSStringFromCGRect(CGRectMake(0.0f, curScreenSize.height - curScreenSize.height/2.0f, curScreenSize.width, curScreenSize.height/2.0f));
    [applicationClass methodOfAnimationPopAndPush: [NSArray arrayWithObjects: mainPickerView, nil] frames:[NSArray arrayWithObjects: rectString, nil]];
}

- (void)XZJ_CustomPicker_CancelClick:(NSInteger)tag
{
    NSString *rectString = NSStringFromCGRect(CGRectMake(0.0f, curScreenSize.height, curScreenSize.width, curScreenSize.height/2.0f));
    [applicationClass methodOfAnimationPopAndPush: [NSArray arrayWithObjects: mainPickerView, nil] frames:[NSArray arrayWithObjects: rectString, nil]];
    [applicationClass methodOfAnimationPopAndPush: [NSArray arrayWithObjects: mainTimeSizePickerView, nil] frames:[NSArray arrayWithObjects: rectString, nil]];
}

- (void)XZJ_CustomPicker_EnsureClick:(NSInteger)tag data:(NSArray *)data selectIndexs:(NSArray *)indexs
{
    if(tag == 0){
        if([data count] > 0){
            CountryClass *country = [countryDataArray objectAtIndex: [[indexs objectAtIndex: 0] integerValue]];
            selectedCountryId = [country countryId];
            [cityTextfiled setText: [data objectAtIndex: 0]];
        }
    }
    else{
        ///旅程时长
        if([data count] > 0){
            [timeSizeTextfiled setText: [data objectAtIndex: 0]];
        }
    }
    [self XZJ_CustomPicker_CancelClick: tag];
}

#pragma mark -
#pragma mark 跳转到下一个页面
- (void)nextStepButtonClick
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName: @"PagerViewControllerGoToNext" object: nil];
//    PJStepTwoViewController *nextVC = [[PJStepTwoViewController alloc] init];
//    [self.navigationController pushViewController: nextVC animated: NO];
}

#pragma mark -
#pragma mark 打开旅程时长
- (void)openDatePickerView
{
    [curFirstResponser resignFirstResponder];
    [self XZJ_CustomPicker_CancelClick: 0];
    if(!mainTimeSizePickerView)
    {
        mainTimeSizePickerView = [[XZJ_CustomPicker alloc] initWithFrame:CGRectMake(0.0f, curScreenSize.height, curScreenSize.width, curScreenSize.height/2.0f) dataArray: [NSArray arrayWithObject: [NSArray arrayWithObjects: @"1小时",@"2小时",@"3小时",@"4小时",@"5小时",@"6小时",@"1天",@"2天", nil]]];
        [mainTimeSizePickerView setDelegate: self];
        [mainTimeSizePickerView setTag: 1];
        [self.view addSubview: mainTimeSizePickerView];
    }
    NSString *rectString = NSStringFromCGRect(CGRectMake(0.0f, curScreenSize.height - curScreenSize.height/2.0f, curScreenSize.width, curScreenSize.height/2.0f));
    [applicationClass methodOfAnimationPopAndPush: [NSArray arrayWithObjects: mainTimeSizePickerView, nil] frames:[NSArray arrayWithObjects: rectString, nil]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
