//
//  PickerQueryView.h
//  WorldView
//
//  Created by XZJ on 11/9/15.
//  Copyright © 2015 XZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZJ_ApplicationClass.h"
#import "PickerQueryTableViewCell.h"
#import "HP_Locaction_TableViewCell.h"
#import "CountryObject.h"
#import "ServiceObject.h"

@protocol PickerQueryViewDelegate <NSObject>
- (void)pickerQueryViewDelegate_DidCancelButton;
- (void)pickerQueryViewDelegate_DidEnsureButton:(NSString *)countryOrCityId isCountry:(BOOL) isCountry sortType:(Service_Sort_Type)sort;
@end

@interface PickerQueryView : UIView<UITableViewDataSource, UITableViewDelegate, UITableViewDataSource, UITableViewDelegate, CountryObjectDelegate>
{
    UIView *lineView;
    NSTimer *timer;
    UIView *contentView;
    UIView *cityContentVeiw;
    XZJ_ApplicationClass *applicationClass;
    id<PickerQueryViewDelegate> xDelegate;
    CGFloat cellHeight;
    PickerQueryTableViewCell *lastSelectedCell;
    UIButton *lastSequeensButton;
    CGFloat selfAlpha;
    CountryObject *countryObj;
    NSArray *cityArray;
    NSArray *countryArray;
    UITableView *cityTableView;
    BOOL isCountry;
    Service_Sort_Type sortType;
    NSString *countryOrCityId;
    XZJ_CustomLabel *titleLabel;
    UITableView *countryTableView;
}
- (id)initWithFrame:(CGRect)frame buttonRect:(CGRect) buttonFrame delegate:(id<PickerQueryViewDelegate>) _delegate country:(CountryClass *) _country;
- (void)show;
- (void)dismiss;
@end
