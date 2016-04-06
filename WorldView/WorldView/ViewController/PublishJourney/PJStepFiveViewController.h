//
//  PJStepFiveViewController.h
//  WorldView
//
//  Created by XZJ on 11/6/15.
//  Copyright © 2015 XZJ. All rights reserved.
//

#import "BaseViewController.h"
#import "ServiceClass.h"

@interface PJStepFiveViewController : BaseViewController<UITextViewDelegate, UITextFieldDelegate, UIScrollViewDelegate>
{
    XZJ_CustomLabel *fontNumberLabel;
    NSString *textViewText;
    id curFirstResponder;
}
@property(nonatomic) ServiceClass *mainService;
@property(nonatomic, retain) UITextField *unitPriceTextFiled;
@property(nonatomic, retain) UITextField *addOnePriceTextFiled;
@property(nonatomic, retain) UITextView *pricedescTextView;
@end
