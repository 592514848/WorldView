//
//  AppointMainView.h
//  WorldView
//
//  Created by WorldView on 15/11/24.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZJ_ApplicationClass.h"
#import "ServiceObject.h"

@interface AppointMainView : UIView<UITextFieldDelegate, UITextViewDelegate,ServiceObjectDelegate,XZJ_CustomPicker_Delegate,XZJ_CustomPicker_Delegate>
{
    ServiceObject *seviceObj;
    ServiceClass *mainService;
    NSArray *travelTimeArray;
    UIView *cardBottomView;
    UIButton *cardOperateButton;
    UIView *travelReasonView;
    UIView *orderProtocolView;
    UIView *infoCheckedView;
    UITextField *numberTextfiled;
    XZJ_CustomLabel *prePriceLabel;
    XZJ_ApplicationClass *mainApplication;
    XZJ_CustomPicker *mainPickerView;
    BOOL isEdit;
    id curResponser;
    XZJ_CustomLabel *travelTimeLabel;
    AppointClass *appointClass;
    UITextView *purposeTextView;
    UITextView *introduceTextView;
    UIButton *chechedButton;
}
- (id)initWithFrame:(CGRect)frame service:(ServiceClass *)_service;
- (void)show;
- (void)dismiss;
@end
