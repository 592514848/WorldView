//
//  LoginViewController.m
//  WorldView
//
//  Created by XZJ on 10/28/15.
//  Copyright © 2015 XZJ. All rights reserved.
//
#define BASE_HEIGHT 50.0f
#import "LoginViewController.h"
#import "FindPasswordNavaigationController.h"
#import "PhoneRegisternavigationController.h"

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
        switch (i) {
            case 0:{
                UIView *linView = [[UIView alloc] initWithFrame: CGRectMake(10.0f, BASE_HEIGHT, mainView.frame.size.width - 20.0f, 1.0f)];
                [linView setBackgroundColor: [applicationClass methodOfTurnToUIColor: @"#e5e5e5"]];
                [mainView addSubview: linView];
                [tempTextField setPlaceholder: @"邮箱帐号／手机号码"];
                accountTextField = tempTextField;
                break;
            }
            case 1:
                [tempTextField setPlaceholder: @"密码"];
                [tempTextField setSecureTextEntry: YES];
                passwordTextField = tempTextField;
                break;
            default:
                break;
        }
        [mainView addSubview: tempTextField];
    }
    ///3.忘记密码
    CGFloat origin_y = mainView.frame.size.height + mainView.frame.origin.y + 10.0f;
    XZJ_CustomLabel * passwordLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(15.0f, origin_y, curScreenSize.width - 35.0f, 30.0f)];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString: @"忘记密码?"];
    NSRange contentRange = {0, [attributeString length]};
    [attributeString addAttribute: NSUnderlineStyleAttributeName value: [NSNumber numberWithInteger: NSUnderlineStyleSingle] range: contentRange];
    [passwordLabel setAttributedText: attributeString];
    [passwordLabel setTextAlignment: NSTextAlignmentRight];
    [passwordLabel setFont: [UIFont systemFontOfSize: 14.0f]];
    [passwordLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#0093fb"]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(findPasswordClick)];
    [passwordLabel addGestureRecognizer: tap];
    [passwordLabel setUserInteractionEnabled: YES];
    [self.view addSubview: passwordLabel];
    ///4.登录
    origin_y += passwordLabel.frame.size.height + 10.0f;
    UIButton *loginButton = [[UIButton alloc] initWithFrame: CGRectMake(18.0f, origin_y, curScreenSize.width - 36.0f, BASE_HEIGHT)];
    [loginButton setTitle: @"登录" forState: UIControlStateNormal];
    [loginButton setTitleColor: [applicationClass methodOfTurnToUIColor: @"#ef6b6d"] forState: UIControlStateNormal];
    [loginButton.layer setBorderColor: [applicationClass methodOfTurnToUIColor: @"#ef6b6d"].CGColor];
    [loginButton setBackgroundColor: [UIColor clearColor]];
    [loginButton.layer setBorderWidth: 1.0f];
    [loginButton.layer setCornerRadius: 4.0f];
    [loginButton addTarget: self action: @selector(loginButtonClick) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview: loginButton];
    ///5.注册
    origin_y += loginButton.frame.size.height + 20.0f;
    XZJ_CustomLabel *registerLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(0.0f, origin_y, curScreenSize.width, 30.0f)];
    attributeString = [[NSMutableAttributedString alloc] initWithString: @"还没有帐号？注册"];
    [attributeString addAttribute: NSForegroundColorAttributeName value: [applicationClass methodOfTurnToUIColor: @"#8f8f8f"] range: NSMakeRange(0, 6)];
    [attributeString addAttribute: NSForegroundColorAttributeName value: [applicationClass methodOfTurnToUIColor: @"#0093fb"] range: NSMakeRange(6, 2)];
    [registerLabel setAttributedText: attributeString];
    [registerLabel setFont: [UIFont systemFontOfSize: 13.0f]];
    [registerLabel setTextAlignment: NSTextAlignmentCenter];
    tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(registerLabelClick)];
    [registerLabel setUserInteractionEnabled: YES];
    [registerLabel addGestureRecognizer: tap];
    [self.view addSubview: registerLabel];
    ///6.微信登录
    UIImageView *weixinImageView = [[UIImageView alloc] initWithFrame: CGRectMake(curScreenSize.width * 3 / 8.0f, curScreenSize.height - 80.0f, curScreenSize.width / 4.0f, 30.0f)];
    [weixinImageView setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"weixin_login2" ofType: @"png"]]];
    [weixinImageView setContentMode: UIViewContentModeScaleAspectFit];
    [self.view addSubview: weixinImageView];
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
#pragma mark 找回密码
- (void)findPasswordClick
{
    FindPasswordNavaigationController *findPasswordVC = [[FindPasswordNavaigationController alloc] init];
    [self presentViewController: findPasswordVC animated: YES completion: nil];
}

#pragma mark -
#pragma mark 注册
- (void)registerLabelClick
{
    PhoneRegisternavigationController *findPasswordVC = [[PhoneRegisternavigationController alloc] init];
    [self presentViewController: findPasswordVC animated: YES completion: nil];
}

#pragma mark -
#pragma mark 会员登录
- (void)loginButtonClick
{
    if([[accountTextField text] length] == 0)
    {
        [applicationClass methodOfShowAlert: @"请输入您的帐号"];
        return;
    }
    if([[passwordTextField text] length] == 0)
    {
        [applicationClass methodOfShowAlert: @"请输入您的密码"];
        return;
    }
    [responserTextFiled resignFirstResponder];
    MemberObject *member = [[MemberObject alloc] init];
    [member setXDelegate: self];
    [member setMemberAccount: [accountTextField text]];
    [member setMemberPassword: [applicationClass methodOfMD5Encryption: [passwordTextField text]]];
    [member loginIn];
}

#pragma mark -
#pragma mark 
- (void)MemberObject_DidLoginInSuceess:(BOOL)success data:(NSDictionary *)dictionary
{
    if(success){
        NSDictionary *tempDictionary = [NSDictionary dictionaryWithObjectsAndKeys: [dictionary objectForKey: @"account"],@"account", LONG_PASER_TOSTRING([dictionary objectForKey: @"id"]), @"id", [dictionary objectForKey: @"userType"], @"userType",  LONG_PASER_TOSTRING([dictionary objectForKey: @"sex"]),@"sex", [dictionary objectForKey: @"imgUrl"], @"photo", [dictionary objectForKey: @"nickName"], @"ch_name",[dictionary objectForKey: @"engNickName"], @"en_name",[dictionary objectForKey: @"sign"], @"sign", nil];
        [applicationClass methodOfLocalStorage: tempDictionary forKey: @"LOCALUSER"];
        [applicationClass methodOfAlterThenDisAppear: @"登录成功"];
        [self dismissViewControllerAnimated: YES completion: nil];
    }
    else{
        [applicationClass methodOfAlterThenDisAppear: @"帐号或密码错误，请重新登录"];
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
