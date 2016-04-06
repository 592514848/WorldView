//
//  FindPassword_StepTwo_VC.m
//  WorldView
//
//  Created by XZJ on 10/29/15.
//  Copyright © 2015 XZJ. All rights reserved.
//
#define BASE_HEIGHT 50.0f
#import "FindPassword_StepTwo_VC.h"
@implementation FindPassword_StepTwo_VC
@synthesize memberAccount;
- (void)viewDidLoad {
    [super viewDidLoad];
    ///
    memberObj = [[MemberObject alloc] init];
    [memberObj setXDelegate: self];
    [memberObj setMemberAccount: memberAccount];
    ///
    [self loadMainView];
}

- (void)loadMainView
{
    ///1.主视图
    [self.view setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#f0f0f0"]];
    UIView *mainView = [[UIView alloc] initWithFrame: CGRectMake(15.0f, self.point_y + 20.0f, curScreenSize.width - 30.0f, 2 * BASE_HEIGHT + 1.0f)];
    [mainView.layer setShadowOpacity: 0.15f];
    [mainView.layer setShadowOffset: CGSizeMake(0.0f, 3.0f)];
    [mainView setBackgroundColor: [UIColor whiteColor]];
    [self.view addSubview: mainView];
    ///2.输入框
    for(NSInteger i = 0; i < 2; i++){
        UITextField *tempTextField = [[UITextField alloc] initWithFrame: CGRectMake(10.0f, i * (BASE_HEIGHT + 1.0f), mainView.frame.size.width - 20.0f, BASE_HEIGHT)];
        [tempTextField setBackgroundColor: [UIColor clearColor]];
        [tempTextField setFont: [UIFont systemFontOfSize: 15.0f]];
        [tempTextField setDelegate: self];
        [tempTextField setKeyboardType: UIKeyboardTypeAlphabet];
        [mainView addSubview: tempTextField];
        [tempTextField setSecureTextEntry: YES];
        switch (i) {
            case 0:{
                UIView *linView = [[UIView alloc] initWithFrame: CGRectMake(10.0f, BASE_HEIGHT, mainView.frame.size.width - 20.0f, 1.0f)];
                [linView setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#e5e5e5"]];
                [mainView addSubview: linView];
                [tempTextField setPlaceholder: @"输入新密码"];
                passwordTextField = tempTextField;
                break;
            }
            case 1:
                [tempTextField setPlaceholder: @"确认新密码"];
                validatePasswordTextField = tempTextField;
                break;
            default:
                break;
        }
        [mainView addSubview: tempTextField];
    }
    ///3.登录
    CGFloat origin_y = mainView.frame.size.height + mainView.frame.origin.y + 30.0f;
    UIButton *confirmButton = [[UIButton alloc] initWithFrame: CGRectMake(18.0f, origin_y, curScreenSize.width - 36.0f, BASE_HEIGHT)];
    [confirmButton setTitle: @"确认" forState: UIControlStateNormal];
    [confirmButton setTitleColor: [applicationClass methodOfTurnToUIColor: @"#ef6b6d"] forState: UIControlStateNormal];
    [confirmButton.layer setBorderColor: [applicationClass methodOfTurnToUIColor: @"#ef6b6d"].CGColor];
    [confirmButton setBackgroundColor: [UIColor clearColor]];
    [confirmButton.layer setBorderWidth: 1.0f];
    [confirmButton.layer setCornerRadius: 4.0f];
    [confirmButton addTarget: self action: @selector(confirmButtonClick) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview: confirmButton];
}

#pragma mark -
#pragma mark textfiled委托
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    responserTextFiled = textField;
}

#pragma mark -
#pragma mark 空白处点击事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [responserTextFiled resignFirstResponder];
}

#pragma mark -
#pragma mark 确认按钮点击事件
- (void)confirmButtonClick
{
    if([[passwordTextField text] length] == 0){
        [applicationClass methodOfShowAlert: @"请输入密码"];
        return;
    }
    if(![[passwordTextField text] isEqualToString: [validatePasswordTextField text]]){
        [applicationClass methodOfShowAlert: @"2次输入密码不一致，请重新输入"];
        return;
    }
    ///重置密码
    [memberObj setMemberPassword: [applicationClass methodOfMD5Encryption: [passwordTextField text]]];
    [memberObj resetPassword];
}

#pragma mark -
#pragma mark MemberObject
- (void)MemberObject_DidResetPasswordSuccess:(BOOL)success
{
    if(success){
        UIAlertView *alertView= [[UIAlertView alloc] initWithTitle: @"" message: @"密码重置成功,请前去登录" delegate: self cancelButtonTitle: @"去登录" otherButtonTitles: nil];
        [alertView show];
    }
    else{
        [applicationClass methodOfShowAlert: @"密码重置失败,请稍候再试"];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
