//
//  LoginViewController.h
//  WorldView
//
//  Created by XZJ on 10/28/15.
//  Copyright © 2015 XZJ. All rights reserved.
//

#import "BaseViewController.h"
#import "MemberObject.h"
#import "WXApiManager.h"

@interface LoginViewController : BaseViewController<UITextFieldDelegate,MemberObjectDelegate>
{
    UITextField *accountTextField;
    UITextField *passwordTextField;
    UITextField *responserTextFiled;
}
@end
