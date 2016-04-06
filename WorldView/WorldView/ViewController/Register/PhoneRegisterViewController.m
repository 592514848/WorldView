//
//  PhoneRegisterViewController.m
//  WorldView
//
//  Created by XZJ on 10/29/15.
//  Copyright © 2015 XZJ. All rights reserved.
//
#define BASE_HEIGHT 50.0f
#import "PhoneRegisterViewController.h"
#import "EmailRegisterViewController.h"

@implementation PhoneRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ///1.初始化会员对象
    memberObj = [[MemberObject alloc] init];
    [memberObj setXDelegate: self];
    
    ///2.加载主视图
    [self loadMainView];
}

- (void)loadMainView
{
    ///1.主视图
    [self.view setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#f0f0f0"]];
    UIView *mainView = [[UIView alloc] initWithFrame: CGRectMake(15.0f, self.point_y + 20.0f, curScreenSize.width - 30.0f, 3 * BASE_HEIGHT + 2.0f)];
    [mainView.layer setShadowOpacity: 0.15f];
    [mainView.layer setShadowOffset: CGSizeMake(0.0f, 3.0f)];
    [mainView setBackgroundColor: [UIColor whiteColor]];
    [self.view addSubview: mainView];
    ///2.输入框
    for(NSInteger i = 0; i < 3; i++){
        UITextField *tempTextField = [[UITextField alloc] initWithFrame: CGRectMake(10.0f, i * (BASE_HEIGHT + 1.0f), mainView.frame.size.width - 20.0f, BASE_HEIGHT)];
        [tempTextField setBackgroundColor: [UIColor clearColor]];
        [tempTextField setFont: [UIFont systemFontOfSize: 15.0f]];
        [tempTextField setDelegate: self];
        [mainView addSubview: tempTextField];
        switch (i) {
            case 0:{
                UIView *linView = [[UIView alloc] initWithFrame: CGRectMake(10.0f, BASE_HEIGHT, mainView.frame.size.width - 20.0f, 1.0f)];
                [linView setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#e5e5e5"]];
                [mainView addSubview: linView];
                [tempTextField setKeyboardType: UIKeyboardTypeNumberPad];
                [tempTextField setPlaceholder: @"手机号"];
                phoneTextField = tempTextField;
                //发送验证码按钮
                [tempTextField setFrame:  CGRectMake(10.0f, i * (BASE_HEIGHT + 1.0f), mainView.frame.size.width - 140.0f, BASE_HEIGHT)];
                CGFloat origin_x = tempTextField.frame.size.width + tempTextField.frame.origin.x + 5.0f;
                sendCodeButton = [[UIButton alloc] initWithFrame: CGRectMake(origin_x, tempTextField.frame.origin.y + 8.0f, mainView.frame.size.width - origin_x - 15.0f, BASE_HEIGHT - 16.0f)];
                [sendCodeButton setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#d4d4d4"]];
                [sendCodeButton setTitle: @"获取验证码" forState: UIControlStateNormal];
                [sendCodeButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
                [sendCodeButton.titleLabel setFont: [UIFont systemFontOfSize: 13.0f]];
                [sendCodeButton setEnabled: NO];
                [sendCodeButton.layer setCornerRadius: 3.0f];
                [sendCodeButton addTarget: self action: @selector(sendCodeButtonClick) forControlEvents: UIControlEventTouchUpInside];
                [sendCodeButton setTag: 60];
                [mainView addSubview: sendCodeButton];
                break;
            }
            case 1:{
                UIView *linView = [[UIView alloc] initWithFrame: CGRectMake(10.0f, tempTextField.frame.origin.y+BASE_HEIGHT, mainView.frame.size.width - 20.0f, 1.0f)];
                [linView setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#e5e5e5"]];
                [mainView addSubview: linView];
                [tempTextField setKeyboardType: UIKeyboardTypeNumberPad];
                [tempTextField setPlaceholder: @"验证码"];
                codeTextFile = tempTextField;
                break;
            }
            case 2:
                [tempTextField setPlaceholder: @"密码"];
                [tempTextField setSecureTextEntry: YES];
                passwordTextField = tempTextField;
                break;
            default:
                break;
        }
        [tempTextField setDelegate: self];
        [tempTextField setTag: i];
        [mainView addSubview: tempTextField];
    }
    ///3.邮箱注册
    CGFloat origin_y = mainView.frame.size.height + mainView.frame.origin.y + 10.0f;
    XZJ_CustomLabel * registerLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(15.0f, origin_y, curScreenSize.width - 35.0f, 30.0f)];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString: @"通过电子邮箱注册"];
    NSRange contentRange = {0, [attributeString length]};
    [attributeString addAttribute: NSUnderlineStyleAttributeName value: [NSNumber numberWithInteger: NSUnderlineStyleSingle] range: contentRange];
    [registerLabel setAttributedText: attributeString];
    [registerLabel setTextAlignment: NSTextAlignmentRight];
    [registerLabel setFont: [UIFont systemFontOfSize: 14.0f]];
    [registerLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#0093fb"]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(emailRegisterClick)];
    [registerLabel addGestureRecognizer: tap];
    [registerLabel setUserInteractionEnabled: YES];
    [self.view addSubview: registerLabel];
    ///4.注册
    origin_y += registerLabel.frame.size.height + 10.0f;
    UIButton *registerButton = [[UIButton alloc] initWithFrame: CGRectMake(18.0f, origin_y, curScreenSize.width - 36.0f, BASE_HEIGHT)];
    [registerButton setTitle: @"注册" forState: UIControlStateNormal];
    [registerButton setTitleColor: [applicationClass methodOfTurnToUIColor: @"#ef6b6d"] forState: UIControlStateNormal];
    [registerButton.layer setBorderColor: [applicationClass methodOfTurnToUIColor: @"#ef6b6d"].CGColor];
    [registerButton setBackgroundColor: [UIColor clearColor]];
    [registerButton.layer setBorderWidth: 1.0f];
    [registerButton addTarget: self action: @selector(registerButtonClick) forControlEvents: UIControlEventTouchUpInside];
    [registerButton.layer setCornerRadius: 4.0f];
    [self.view addSubview: registerButton];
    ///5.选择注册协议
    origin_y += registerButton.frame.size.height + 20.0f;
    UIButton *checkbutton = [[UIButton alloc] initWithFrame: CGRectMake(curScreenSize.width / 4.0f, origin_y, BASE_HEIGHT / 2.0f, BASE_HEIGHT / 2.0f)];
    [checkbutton setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"selection_none" ofType: @"png"]] forState: UIControlStateNormal];
    [checkbutton setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"selection_checked" ofType: @"png"]] forState: UIControlStateSelected];
    isReadProtocol = NO;
    [checkbutton addTarget: self action: @selector(checkButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: checkbutton];
    ///6.查看注册协议
    CGFloat origin_x = checkbutton.frame.size.width + checkbutton.frame.origin.x;
    XZJ_CustomLabel *protocolLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(origin_x, origin_y, curScreenSize.width / 2.0f, BASE_HEIGHT / 2.0f)];
    attributeString = [[NSMutableAttributedString alloc] initWithString: @"我 已 阅 读 并 同 意 用 户 协 议"];
    [attributeString addAttribute: NSForegroundColorAttributeName value: [applicationClass methodOfTurnToUIColor: @"#8f8f8f"] range: NSMakeRange(0, 14)];
    [attributeString addAttribute: NSForegroundColorAttributeName value: [applicationClass methodOfTurnToUIColor: @"#0093fb"] range: NSMakeRange(14, 7)];
    [protocolLabel setAttributedText: attributeString];
    [protocolLabel setFont: [UIFont systemFontOfSize: 13.0f]];
    [protocolLabel setTextAlignment: NSTextAlignmentCenter];
    [self.view addSubview: protocolLabel];
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
#pragma mark 注册协议选择按钮
- (void)checkButtonClick:(UIButton *)sender
{
    isReadProtocol = ![sender isSelected];
    [sender setSelected: ![sender isSelected]];
}

#pragma mark -
#pragma mark 跳转至邮箱注册
- (void)emailRegisterClick
{
    EmailRegisterViewController *emailRegisterVC = [[EmailRegisterViewController alloc] init];
    [emailRegisterVC setTopBarTitle: @"邮箱注册"];
    [emailRegisterVC setXZJ_ControlMask: kMODALPushControlMask];
    [self.navigationController pushViewController: emailRegisterVC animated: YES];
}

#pragma mark -
#pragma mark 发送验证码
- (void)sendCodeButtonClick
{
    if(isReadProtocol)
    {
        ///1.验证手机号
        if([[phoneTextField text] length] == 0){
            [applicationClass methodOfShowAlert: @"请输入您注册的手机号"];
            return;
        }
        if(![applicationClass methodOfValidatePhoneNumber: [phoneTextField text]]){
            [applicationClass methodOfShowAlert: @"请输入正确的手机号码"];
            return;
        }
        ///2.判断该手机号是否注册
        [memberObj setMemberAccount: [phoneTextField text]];
        [memberObj validateIsRegister];
    }
    else{
        [applicationClass methodOfShowAlert: @"请先阅读注册协议，并同意该注册协议"];
    }
}

- (void)MemberObject_DidIsRegister:(BOOL)isRegister
{
    if(!isRegister){
        ///开始倒计时
        [sendCodeButton setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#d4d4d4"]];
        [sendCodeButton setEnabled: NO];
        [phoneTextField setEnabled: NO];
        [sendCodeButton setTitle: [NSString stringWithFormat: @"%lds后获取验证码", (long)[sendCodeButton tag]] forState: UIControlStateNormal];
        codeTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0f target: self selector: @selector(updateSendCodeButtonStatus) userInfo: nil repeats: YES];
        ///开始发送验证码
        [memberObj setMemberAccount: [phoneTextField text]];
        [memberObj sendCode];
    }
    else{
        [applicationClass methodOfAlterThenDisAppear: @"该账号已经注册过"];
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
        [phoneTextField setEnabled: YES];
        [sendCodeButton setTag: 60];
        [codeTimer setFireDate: [NSDate distantFuture]];
        [sendCodeButton setEnabled: YES];
        [sendCodeButton setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#36cbf6"]];
        [sendCodeButton setTitle: @"获取验证码" forState: UIControlStateNormal];
    }
}

#pragma mark -
#pragma mark 注册按钮
- (void)registerButtonClick
{
    if(isReadProtocol)
    {
        ///验证手机号
        if([[phoneTextField text] length] == 0){
            [applicationClass methodOfShowAlert: @"请输入您注册的手机号"];
            return;
        }
        if(![applicationClass methodOfValidatePhoneNumber: [phoneTextField text]]){
            [applicationClass methodOfShowAlert: @"请输入正确的手机号码"];
            return;
        }
        ///判断验证码
        if([[codeTextFile text] length] == 0){
            [applicationClass methodOfShowAlert: @"请输入您收到的验证码"];
            return;
        }
        ///验证密码
        if([[passwordTextField text] length] == 0){
            [applicationClass methodOfShowAlert: @"请输入您设置的登录密码"];
            return;
        }
        ////先验证验证码
        [memberObj setMemberAccount: [phoneTextField text]];
        [memberObj validateCode: [codeTextFile text]];
    }
    else{
        [applicationClass methodOfShowAlert: @"请先阅读注册协议，并同意该注册协议"];
    }
}

#pragma mark -
#pragma mark 会员对象的委托方法
- (void)MemberObject_DidSendCodeSuccess:(BOOL)success
{
    if(!success){
        [applicationClass methodOfShowAlert: @"验证码发送失败"];
    }
    else{
        [applicationClass methodOfShowAlert: @"验证码发送成功,请注意查收"];
    }
}

- (void)MemberObject_ValidateCode:(BOOL)isPass
{
    if(isPass){
        ////请求注册接口
        [memberObj setMemberAccount: [phoneTextField text]];
        [memberObj setMemberPassword: [applicationClass methodOfMD5Encryption: [passwordTextField text]]];
        [memberObj register];
    }
    else{
        [applicationClass methodOfShowAlert: @"验证码无效"];
    }
}

- (void)MemberObject_DidRegisterSuccess:(BOOL)success
{
    if(success){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"" message: @"恭喜您，注册成功" delegate: self cancelButtonTitle: @"去登录" otherButtonTitles: nil];
        [alertView  show];
    }
    else{
        [applicationClass methodOfAlterThenDisAppear: @"注册失败，请重试"];
    }
}

#pragma mark -
#pragma mark alertView
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
