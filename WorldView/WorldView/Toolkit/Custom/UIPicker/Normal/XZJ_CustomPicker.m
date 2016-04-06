//
//  XZJ_Picker_One.m
//  GRDApplication
//
//  Created by 6602 on 14-2-25.
//  Copyright (c) 2014年 Xiong. All rights reserved.
//

#import "XZJ_CustomPicker.h"
#import "XZJ_ApplicationClass.h"

@implementation XZJ_CustomPicker
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame dataArray:(NSArray *) _dataArray
{
    self = [super initWithFrame:frame];
    if (self) {
        dataArray = _dataArray;
        selectIndexs = [[NSMutableArray alloc] initWithCapacity: [dataArray count]];
        for(NSInteger i = 0; i < [dataArray count]; i++)
            [selectIndexs insertObject: @"0" atIndex: i];
        [self initWithContorls: frame isDate: NO];
    }
    return self;
}

- (void)initWithContorls:(CGRect) frame isDate:(BOOL) _isdate
{
    isDatePicker = _isdate;
    //加载视图上的子视图
    [self setBackgroundColor: [UIColor whiteColor]];
    [self.layer setShadowOpacity: 0.2f];
    [self.layer setShadowOffset: CGSizeMake(0.0f, -3.0f)];
    XZJ_ApplicationClass *applicationClass = [XZJ_ApplicationClass commonApplication];
    ////分割线
    UIView *lineView = [[UIView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, frame.size.width, 1.0f)];
    [lineView setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#efefef"]];
    [self addSubview: lineView];
    
    /*---初始化操作按钮---*/
    UIButton *cancelButton = [[UIButton alloc] initWithFrame: CGRectMake(10.0f, 10.0f, 60.0f, 30.0f)];
    [cancelButton setTag: 0];
    [cancelButton setTitle: @"关闭" forState: UIControlStateNormal];
    [cancelButton setBackgroundColor: [UIColor clearColor]];
    [cancelButton.titleLabel setFont: [UIFont systemFontOfSize: 15.0f]];
    [cancelButton addTarget: self action:@selector(buttonClick:) forControlEvents: UIControlEventTouchUpInside];
    [self addSubview: cancelButton];
    
    UIButton *ensureButton = [[UIButton alloc] initWithFrame: CGRectMake(frame.size.width-70.0f, 10.0f, 60.0f, 30.0f)];
    [ensureButton setTag: 1];
    [ensureButton setTitle: @"确定" forState: UIControlStateNormal];
    [ensureButton setBackgroundColor: [UIColor clearColor]];
    [ensureButton.titleLabel setFont: [UIFont systemFontOfSize: 15.0f]];
    [ensureButton addTarget: self action:@selector(buttonClick:) forControlEvents: UIControlEventTouchUpInside];
    [self addSubview: ensureButton];
    
    //添加横线
    lineView = [[UIView alloc] initWithFrame: CGRectMake(0.0f, 50.0f, frame.size.width, 1.0f)];
    [lineView setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#efefef"]];
    [self addSubview: lineView];

    [cancelButton setTitleColor: [applicationClass methodOfTurnToUIColor: @"#d52c3d"] forState: UIControlStateNormal];
    [ensureButton setTitleColor: [applicationClass methodOfTurnToUIColor: @"#1da4e8"] forState: UIControlStateNormal];
    
    if(_isdate)
    {
        //时间选择器
        mainDatePickerView = [[UIDatePicker alloc] initWithFrame:  CGRectMake(0.0f, 51.0f, frame.size.width, frame.size.height-50.0f)];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier: @"zh_CN"];
        [mainDatePickerView setLocale: locale];
        [self addSubview: mainDatePickerView];
    }
    else
    {
        mainPickerView = [[UIPickerView alloc] initWithFrame: CGRectMake(0.0f, 51.0f, frame.size.width, frame.size.height-50.0f)];
        [mainPickerView setDataSource: self];
        [mainPickerView setDelegate: self];
        [mainPickerView setBackgroundColor: [UIColor whiteColor]];
        [mainPickerView setShowsSelectionIndicator: YES];
        [self addSubview: mainPickerView];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return [dataArray count];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *tmpArray = [dataArray objectAtIndex: component];
    for(NSInteger i = 0; i < component; i++)
    {
        NSInteger index = [[selectIndexs objectAtIndex: i] integerValue];
        if([tmpArray count] > index)
            tmpArray = [tmpArray objectAtIndex: index];
    }
    return [tmpArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray *tmpArray = [dataArray objectAtIndex: component];
    for(NSInteger i = 0; i < component; i++)
    {
        tmpArray = [tmpArray objectAtIndex: [[selectIndexs objectAtIndex: i] integerValue]];
    }
    if([tmpArray count] > row)
        return [tmpArray objectAtIndex: row];
    else
        return @"";
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        [pickerLabel setAdjustsFontSizeToFitWidth: YES];
        [pickerLabel setTextAlignment: NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    for(NSInteger i = component + 1; i < [dataArray count]; i++)
    {
        [selectIndexs setObject: @"0" atIndexedSubscript: i];
    }
    [selectIndexs setObject: [NSNumber numberWithInteger: row] atIndexedSubscript: component];
    NSInteger flag = component + 1;
    while (flag < [dataArray count]) {
        [pickerView reloadComponent: flag];
        [mainPickerView selectRow: [[selectIndexs objectAtIndex: flag] integerValue] inComponent: flag animated: YES];
        flag++;
    }
}

- (void)buttonClick:(UIButton *) sender
{
    switch ([sender tag]) {
        case 0:
            if([delegate respondsToSelector: @selector(XZJ_CustomPicker_CancelClick:)])
            {
                [delegate XZJ_CustomPicker_CancelClick:self.tag];
            }
            break;
        case 1:
            if(isDatePicker)
            {
                if([delegate respondsToSelector: @selector(XZJ_CustomPicker_EnsureClick:date:)])
                    [delegate XZJ_CustomPicker_EnsureClick: [self tag] date:[mainDatePickerView date]];
            }
            else
            {
                if([delegate respondsToSelector: @selector(XZJ_CustomPicker_EnsureClick:data:selectIndexs:)])
                {
                    NSMutableArray *selectValueArray = [[NSMutableArray alloc] initWithCapacity: [dataArray count]];
                    NSArray *tmpArray;
                    NSInteger index;
                    for(NSInteger i = 0; i < [dataArray count]; i++)
                    {
                        tmpArray = [dataArray objectAtIndex: i];
                        for(NSInteger j = 0; j < i; j++)
                            tmpArray = [tmpArray objectAtIndex: [[selectIndexs objectAtIndex: j] integerValue]];
                        index = [[selectIndexs objectAtIndex: i] integerValue];
                        if([tmpArray count] > index)
                            [selectValueArray addObject: [tmpArray objectAtIndex: index]];
                    }
                    [delegate XZJ_CustomPicker_EnsureClick: self.tag data: selectValueArray selectIndexs: selectIndexs];
                }
            }
            break;
        default:
            break;
    }
}

- (void)reloadData:(NSArray *) _dataArray
{
    dataArray = _dataArray;
    selectIndexs = [[NSMutableArray alloc] initWithCapacity: [dataArray count]];
    for(NSInteger i = 0; i < [dataArray count]; i++)
    {
        [selectIndexs insertObject: @"0" atIndex: i];
    }
    [mainPickerView reloadAllComponents];
    for(NSInteger i = 0; i < [dataArray count]; i++)
    {
        [mainPickerView selectRow: 0 inComponent: i animated: YES];
    }
}

/*
    时间选择器
*/
- (id)initDatePickerWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initWithContorls: frame isDate: YES];
    }
    return self;
}

- (void)setMinimumDate:(NSDate *)date
{
    [mainDatePickerView setMinimumDate: date];
}

- (void)setMaximumDate:(NSDate *)date
{
    [mainDatePickerView setMaximumDate: date];
}

- (void)setDatePickerMode:(UIDatePickerMode) dateMode
{
    [mainDatePickerView setDatePickerMode: dateMode];
}


@end
