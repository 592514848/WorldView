//
//  FindPassword_StepOne_VC.h
//  WorldView
//
//  Created by XZJ on 10/29/15.
//  Copyright © 2015 XZJ. All rights reserved.
//

#import "BaseViewController.h"
#import "MemberObject.h"
@interface FindPassword_StepOne_VC : BaseViewController<UITextFieldDelegate, MemberObjectDelegate>
{
    UITextField *responserTextFiled;
    UIButton *sendCodeButton;
    UITextField *accountTextField;
    UITextField *codeTextField;
    MemberObject *memberObj;
    NSTimer *codeTimer;
}
@end
