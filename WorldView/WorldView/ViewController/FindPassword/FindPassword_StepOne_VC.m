//
//  FindPassword_StepOne_VC.m
//  WorldView
//
//  Created by XZJ on 10/29/15.
//  Copyright © 2015 XZJ. All rights reserved.
//
#define BASE_HEIGHT 50.0f
#import "FindPassword_StepOne_VC.h"
#import "FindPassword_StepTwo_VC.h"

@implementation FindPassword_StepOne_VC
- (void)viewDidLoad {
    [super viewDidLoad];
    ////
    memberObj = [[MemberObject alloc] init];
    [memberObj setXDelegate: self];
    ////
    [self loadMainView];
}

- (void)loadMainView
{
    ///1.主视图
    [self.view setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#f0f0f0"]];
    UIView *mainView = [[UIView alloc] initWithFrame: CGRectMake(20.0f, self.point_y + 20.0f, curScreenSize.width - 40.0f, BASE_HEIGHT * 4 + 2.0f)];
    [mainView setBackgroundColor: [UIColor whiteColor]];
    [mainView.layer setShadowOpacity: 0.2f];
    [mainView.layer setShadowOffset: CGSizeMake(0.0f, 3.0f)];
    [self.view addSubview: mainView];
    ///2.提示框
    XZJ_CustomLabel *tipLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(10.0f, 0.0f, mainView.frame.size.width - 20.0f, 2 * BASE_HEIGHT)];
    [tipLabel setText: @"请 输 入 与 您 帐 号 相 关 联 的 电 子 邮 箱 地 址 或 者 手 机 号 码，以 便 我 们 将 给 您 发 送 验 证 信 息。"];
    [tipLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#020202"]];
    [tipLabel setNumberOfLines: 3];
    [tipLabel setLineBreakMode: NSLineBreakByCharWrapping];
    [tipLabel setFont: [UIFont systemFontOfSize: 16.0f]];
    [mainView addSubview: tipLabel];
    ///3.输入框
    CGFloat origin_y = tipLabel.frame.size.height + tipLabel.frame.origin.y;
    for(NSInteger i = 0; i < 2; i++){
        UIView *lineView = [[UIView alloc] initWithFrame: CGRectMake(10.0f, origin_y + i * (BASE_HEIGHT + 1.0f), mainView.frame.size.width - 20.0f, 1.0f)];
        [lineView setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#d4d4d4"]]
        ;
        [mainView addSubview: lineView];
        
        UITextField *textFiled = [[UITextField alloc] initWithFrame: CGRectMake(10.0f, i * BASE_HEIGHT + origin_y + 1.0f, mainView.frame.size.width - 20.0f, BASE_HEIGHT)];
        [textFiled setFont: [UIFont systemFontOfSize: 13.0f]];
        [textFiled setDelegate: self];
        switch (i) {
            case 0:
            {
                accountTextField = textFiled;
                [textFiled setFrame:  CGRectMake(10.0f, i * BASE_HEIGHT + origin_y + 1.0f, mainView.frame.size.width - 140.0f, BASE_HEIGHT)];
                [textFiled setPlaceholder: @"邮箱地址／手机号码"];
                [textFiled setKeyboardType: UIKeyboardTypeAlphabet];
                //发送验证码按钮
                CGFloat origin_x = textFiled.frame.size.width + textFiled.frame.origin.x + 5.0f;
                sendCodeButton = [[UIButton alloc] initWithFrame: CGRectMake(origin_x, textFiled.frame.origin.y + 8.0f, mainView.frame.size.width - origin_x - 15.0f, BASE_HEIGHT - 16.0f)];
                [sendCodeButton setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#d4d4d4"]];
                [sendCodeButton setTitle: @"获取验证码" forState: UIControlStateNormal];
                [sendCodeButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
                [sendCodeButton.titleLabel setFont: [UIFont systemFontOfSize: 13.0f]];
                [sendCodeButton.layer setCornerRadius: 3.0f];
                [sendCodeButton setTag: 60];
                [sendCodeButton addTarget: self action: @selector(sendCodeButtonClick) forControlEvents: UIControlEventTouchUpInside];
                [sendCodeButton setEnabled: NO];
                [mainView addSubview: sendCodeButton];
                break;
            }
            case 1:
            {
                codeTextField = textFiled;
                [textFiled setPlaceholder: @"输入验证码"];
                [textFiled setKeyboardType: UIKeyboardTypeNumberPad];
                break;
            }
            default:
                break;
        }
        [textFiled setTag: i];
        [mainView addSubview: textFiled];
    }
    ///4.登录
    origin_y = mainView.frame.size.height + mainView.frame.origin.y + 30.0f;
    UIButton *findPasswordButton = [[UIButton alloc] initWithFrame: CGRectMake(18.0f, origin_y, curScreenSize.width - 36.0f, BASE_HEIGHT)];
    [findPasswordButton setTitle: @"找回密码" forState: UIControlStateNormal];
    [findPasswordButton setTitleColor: [applicationClass methodOfTurnToUIColor: @"#ef6b6d"] forState: UIControlStateNormal];
    [findPasswordButton.layer setBorderColor: [applicationClass methodOfTurnToUIColor: @"#ef6b6d"].CGColor];
    [findPasswordButton addTarget: self action: @selector(findPasswordClick) forControlEvents: UIControlEventTouchUpInside];
    [findPasswordButton setBackgroundColor: [UIColor clearColor]];
    [findPasswordButton.layer setBorderWidth: 1.0f];
    [findPasswordButton.layer setCornerRadius: 4.0f];
    [self.view addSubview: findPasswordButton];
}

#pragma mark -
#pragma mark 发送验证码
- (void)sendCodeButtonClick
{
    if([[accountTextField text] length] == 0){
        [applicationClass methodOfShowAlert: @"请输入您注册的邮箱或者手机号"];
        return;
    }
    BOOL isSend = NO;
    ///验证输入的是否是邮箱或者手机号
    if([applicationClass methodOfValidateEmail:[accountTextField text]] || [applicationClass methodOfValidatePhoneNumber: [accountTextField text]]){
        ///邮箱找回
        isSend = YES;
    }
    else{
        isSend = NO;
        [applicationClass methodOfShowAlert: @"请输入正确的邮箱地址和手机号码"];
        return;
    }
    if(isSend){
        ///开始倒计时
        [sendCodeButton setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#d4d4d4"]];
        [sendCodeButton setEnabled: NO];
        [accountTextField setEnabled: NO];
        [sendCodeButton setTitle: [NSString stringWithFormat: @"%lds后获取验证码", (long)[sendCodeButton tag]] forState: UIControlStateNormal];
        codeTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0f target: self selector: @selector(updateSendCodeButtonStatus) userInfo: nil repeats: YES];
        ///发送验证码
        [memberObj setMemberAccount: [accountTextField text]];
        [memberObj findPasswordSendCode];
    }
}

#pragma mark 更新验证码状态
- (void)updateSendCodeButtonStatus
{
    if([sendCodeButton tag] != 0)
    {
        [sendCodeButton setTag: [sendCodeButton tag] - 1];
        [sendCodeButton setTitle: [NSString stringWithFormat: @"%lds后获取验证码", (long)[sendCodeButton tag]] forState: UIControlStateNormal];
    }
    else{
        [accountTextField setEnabled: YES];
        [sendCodeButton setTag: 60];
        [codeTimer setFireDate: [NSDate distantFuture]];
        [sendCodeButton setEnabled: YES];
        [sendCodeButton setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#36cbf6"]];
        [sendCodeButton setTitle: @"获取验证码" forState: UIControlStateNormal];
    }
}

#pragma mark -
#pragma mark textfiled委托
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    responserTextFiled = textField;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([textField tag] == 0)
    {
        if([string isEqualToString: @""] && [[textField text] length] == 1){
            [sendCodeButton setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#d4d4d4"]];
            [sendCodeButton setEnabled: NO];
        }
        else{
            [sendCodeButton setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#36cbf6"]];
            [sendCodeButton setEnabled: YES];
        }
    }
    return YES;
}

#pragma mark -
#pragma mark 空白处点击事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [responserTextFiled resignFirstResponder];
}

#pragma mark -
#pragma mark 找回密码点击事件
- (void)findPasswordClick
{
    if([[accountTextField text] length] == 0){
        [applicationClass methodOfShowAlert: @"请输入您注册的电子邮箱或者手机号"];
        return;
    }
    if([[codeTextField text] length] == 0){
        [applicationClass methodOfShowAlert: @"请输入您收到的验证码"];
        return;
    }
    ////先验证验证码
    [memberObj setMemberAccount: [accountTextField text]];
    [memberObj validateCode: [codeTextField text]];
}

#pragma mark -
#pragma mark MemberObject委托
- (void)MemberObject_DidFindPwdSendCode:(BOOL)success
{
    if(success){
        [applicationClass methodOfAlterThenDisAppear: @"验证码发送成功"];
    }
    else{
        [applicationClass methodOfAlterThenDisAppear: @"验证码发送失败，请稍候重试"];
    }
}

- (void)MemberObject_ValidateCode:(BOOL)isPass
{
    if(isPass){
        FindPassword_StepTwo_VC *findPassWordVC = [[FindPassword_StepTwo_VC alloc] init];
        [findPassWordVC setTopBarTitle: @"找回密码"];
        [findPassWordVC setMemberAccount: [memberObj memberAccount]];
        [self.navigationController pushViewController: findPassWordVC animated: YES];
    }
    else{
        [applicationClass methodOfShowAlert: @"验证码错误"];
    }
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
