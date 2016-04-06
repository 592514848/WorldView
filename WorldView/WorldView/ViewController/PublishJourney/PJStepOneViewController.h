//
//  PJStepOneViewController.h
//  WorldView
//
//  Created by XZJ on 11/4/15.
//  Copyright © 2015 XZJ. All rights reserved.
//

#import "BaseViewController.h"
#import "CountryObject.h"
#import "ServiceObject.h"

@interface PJStepOneViewController : BaseViewController<UITextFieldDelegate,XZJ_CustomPicker_Delegate, CountryObjectDelegate, ServiceObjectDelegate>
{
    ServiceObject *serviceObj;
    CountryObject *countryObj;
    NSMutableArray *typeImageViewArray;
    NSInteger maxNumber; //最大人数限制
    XZJ_CustomPicker *mainPickerView;
    NSArray *countryDataArray;
    NSArray *serviceTypeDataArray;
    UITextField *cityTextfiled;
    UIImageView *lastSelectedImageView;
    id curFirstResponser;
    XZJ_CustomPicker *mainTimeSizePickerView;
    
}
@property(nonatomic, retain) UITextField *numberTextfiled;
@property(nonatomic, retain) NSString *selectedServiceTypeId;
@property(nonatomic, retain) NSString *selectedCountryId;
@property(nonatomic, retain) UITextField *timeSizeTextfiled;
@end
