//
//  PhoneRegisterViewController.h
//  WorldView
//
//  Created by XZJ on 10/29/15.
//  Copyright © 2015 XZJ. All rights reserved.
//

#import "BaseViewController.h"
#import "MemberObject.h"
@interface PhoneRegisterViewController : BaseViewController<UITextFieldDelegate, MemberObjectDelegate, UIAlertViewDelegate>
{
    UITextField *responserTextFiled;
    UITextField *phoneTextField;
    UITextField *codeTextFile;
    UITextField *passwordTextField;
    UIButton *sendCodeButton;
    MemberObject *memberObj;
    BOOL isReadProtocol;
    NSTimer *codeTimer;
}
@end
