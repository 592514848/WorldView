//
//  MemberInfoViewController.h
//  WorldView
//
//  Created by WorldView on 15/11/14.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import "BaseViewController.h"
#import "MemberObject.h"
#import "LanguageListView.h"
#import "AboutMeViewController.h"

@interface MemberInfoViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UITextFieldDelegate, MemberObjectDelegate,XZJ_CustomPicker_Delegate, LanguageListView_Delegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
{
    id lastResponser;
    UIScrollView *mainScrollView;
    UIImageView *photoImageView;
    UIImageView *lastSelectedSexImageView;
    UIImageView *lastSelectedLanguageImageView;
    MemberObject *memberObj;
    NSArray *professoinList;
    NSArray *languageList;
    XZJ_CustomPicker *mainPickerView;
    LanguageListView *languageListView;
    XZJ_CustomLabel *languageLabel;
    UITextField *ch_NametextField;
    UITextField *en_NametextField;
    UITextField *weixinTextField;
    UITextField *mailTextFiled;
    UITextField *placeTextFiled;
    XZJ_CustomLabel *jobTextLabel;
    UITextField *phoneTextFiled;
    UITextView *signTextView;
    NSString *selectedSex;
    NSString *selectedLanguage;
    ProfessionClass *selectedProfession;
    NSString *memberPhotoImagePath;
    NSMutableArray *sexGestureArray;
    BOOL isHunter;
}
@end
