//
//  FindPassword_StepTwo_VC.h
//  WorldView
//
//  Created by XZJ on 10/29/15.
//  Copyright © 2015 XZJ. All rights reserved.
//

#import "BaseViewController.h"
#import "MemberObject.h"

@interface FindPassword_StepTwo_VC : BaseViewController<UITextFieldDelegate, MemberObjectDelegate, UIAlertViewDelegate>
{
    UITextField *responserTextFiled;
    UITextField *passwordTextField;
    UITextField *validatePasswordTextField;
    MemberObject *memberObj;
}
@property(nonatomic, retain) NSString *memberAccount;
@end
