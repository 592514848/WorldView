//
//  EmailRegisterViewController.h
//  WorldView
//
//  Created by XZJ on 10/29/15.
//  Copyright © 2015 XZJ. All rights reserved.
//

#import "BaseViewController.h"
#import "MemberObject.h"

@interface EmailRegisterViewController : BaseViewController<UITextFieldDelegate, MemberObjectDelegate, UIAlertViewDelegate>
{
    UITextField *responserTextFiled;
    UITextField *mailTextField;
    UITextField *passwordTextField;
    MemberObject *memberObj;
    BOOL isReadProtocol;
}
@end
