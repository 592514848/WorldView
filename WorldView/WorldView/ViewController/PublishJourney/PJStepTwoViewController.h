//
//  PJStepTwoViewController.h
//  WorldView
//
//  Created by XZJ on 11/5/15.
//  Copyright © 2015 XZJ. All rights reserved.
//

#import "BaseViewController.h"

@interface PJStepTwoViewController : BaseViewController<UITextViewDelegate, UITextFieldDelegate, UIScrollViewDelegate>
{
    XZJ_CustomLabel *fontNumberLabel;
    NSString *textViewText;
    id curFirstResponder;
}
@property(nonatomic, retain) UITextField *titleTextField;
@property(nonatomic, retain) UITextField *subTitleTextField;
@property(nonatomic, retain) UITextView *descriptionTextView;
@end

