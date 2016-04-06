//
//  XZJ_Picker_One.h
//  GRDApplication
//
//  Created by 6602 on 14-2-25.
//  Copyright (c) 2014年 Xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XZJ_CustomPicker_Delegate <NSObject>
@optional
-(void)XZJ_CustomPicker_CancelClick:(NSInteger) tag;
-(void)XZJ_CustomPicker_EnsureClick:(NSInteger) tag data: (NSArray *) data selectIndexs:(NSArray *) indexs;
-(void)XZJ_CustomPicker_EnsureClick:(NSInteger) tag date:(NSDate *) date;
@end

@interface XZJ_CustomPicker : UIView <UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSArray * dataArray;
    UIPickerView *mainPickerView;
    NSMutableArray *selectIndexs;
    UIDatePicker *mainDatePickerView;
    BOOL isDatePicker;
}
@property(nonatomic, retain) id<XZJ_CustomPicker_Delegate> delegate;
- (id)initWithFrame:(CGRect)frame dataArray:(NSArray *) _dataArray;
- (void)reloadData:(NSArray *) _dataArray;
- (id)initDatePickerWithFrame:(CGRect)frame;
- (void) setMaximumDate:(NSDate *)date;
- (void)setDatePickerMode:(UIDatePickerMode) dateMode;
- (void)setMinimumDate:(NSDate *)date;
@end
