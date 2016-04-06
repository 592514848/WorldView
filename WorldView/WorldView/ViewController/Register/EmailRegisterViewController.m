//
//  EmailRegisterViewController.m
//  WorldView
//
//  Created by XZJ on 10/29/15.
//  Copyright © 2015 XZJ. All rights reserved.
//
#define BASE_HEIGHT 50.0f
#import "EmailRegisterViewController.h"
#import "PhoneRegisterViewController.h"

@implementation EmailRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadMainView];
    ///1.初始化会员对象
    memberObj = [[MemberObject alloc] init];
    [memberObj setXDelegate: self];
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
                [tempTextField setPlaceholder: @"电子邮箱"];
                mailTextField = tempTextField;
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
    ///3.手机号注册
    CGFloat origin_y = mainView.frame.size.height + mainView.frame.origin.y + 10.0f;
    XZJ_CustomLabel * registerLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(15.0f, origin_y, curScreenSize.width - 35.0f, 30.0f)];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString: @"通过手机号注册"];
    NSRange contentRange = {0, [attributeString length]};
    [attributeString addAttribute: NSUnderlineStyleAttributeName value: [NSNumber numberWithInteger: NSUnderlineStyleSingle] range: contentRange];
    [registerLabel setAttributedText: attributeString];
    [registerLabel setTextAlignment: NSTextAlignmentRight];
    [registerLabel setFont: [UIFont systemFontOfSize: 14.0f]];
    [registerLabel setTextColor: [applicationClass methodOfTurnToUIColor: @"#0093fb"]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(phoneRegisterClick)];
    [registerLabel addGestureRecognizer: tap];
    [registerLabel setUserInteractionEnabled: YES];
    [self.view addSubview: registerLabel];
    ///4.登录
    origin_y += registerLabel.frame.size.height + 10.0f;
    UIButton *registerButton = [[UIButton alloc] initWithFrame: CGRectMake(18.0f, origin_y, curScreenSize.width - 36.0f, BASE_HEIGHT)];
    [registerButton setTitle: @"注册" forState: UIControlStateNormal];
    [registerButton setTitleColor: [applicationClass methodOfTurnToUIColor: @"#ef6b6d"] forState: UIControlStateNormal];
    [registerButton.layer setBorderColor: [applicationClass methodOfTurnToUIColor: @"#ef6b6d"].CGColor];
    [registerButton setBackgroundColor: [UIColor clearColor]];
    [registerButton.layer setBorderWidth: 1.0f];
    [registerButton.layer setCornerRadius: 4.0f];
    [registerButton addTarget: self action: @selector(registerButtonClick) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview: registerButton];
    ///5.选择注册协议
    origin_y += registerButton.frame.size.height + 20.0f;
    UIButton *checkbutton = [[UIButton alloc] initWithFrame: CGRectMake(curScreenSize.width / 4.0f, origin_y, BASE_HEIGHT / 2.0f, BASE_HEIGHT / 2.0f)];
    [checkbutton setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"selection_none" ofType: @"png"]] forState: UIControlStateNormal];
    [checkbutton setImage: [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"selection_checked" ofType: @"png"]] forState: UIControlStateSelected];
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
#pragma mark 手机注册
- (void)phoneRegisterClick
{
    PhoneRegisterViewController *phoneRegisterVC = [[PhoneRegisterViewController alloc] init];
    [phoneRegisterVC setTopBarTitle: @"手机注册"];
    [phoneRegisterVC setXZJ_ControlMask: kMODALPushControlMask];
    [self.navigationController pushViewController: phoneRegisterVC animated: YES];
}

#pragma mark -
#pragma mark 注册按钮
- (void)registerButtonClick
{
    ////先验证验证码
    if(isReadProtocol)
    {
        ///1.验证电子邮箱
        if([[mailTextField text] length] == 0){
            [applicationClass methodOfShowAlert: @"请输入您注册的邮箱地址"];
            return;
        }
        if(![applicationClass methodOfValidateEmail: [mailTextField text]]){
            [applicationClass methodOfShowAlert: @"请输入正确的电子邮箱"];
            return;
        }
        if([[passwordTextField text] length] == 0){
            [applicationClass methodOfShowAlert: @"请输入您的密码"];
            return;
        }
        [responserTextFiled resignFirstResponder];
        ///2.验证电子邮箱是否注册过
        [memberObj setMemberAccount: [mailTextField text]];
        [memberObj validateIsRegister];
    }
    else{
        [applicationClass methodOfShowAlert: @"请先阅读注册协议，并同意该注册协议"];
    }
}

#pragma mark -
#pragma mark 会员对象的委托方法
- (void)MemberObject_DidIsRegister:(BOOL)isRegister
{
    if(!isRegister){
        [memberObj setMemberAccount: [mailTextField text]];
        [memberObj setMemberPassword: [applicationClass methodOfMD5Encryption: [passwordTextField text]]];
        [memberObj register];
    }
    else{
        [applicationClass methodOfAlterThenDisAppear: @"该邮箱已经注册过"];
    }
}
- (void)MemberObject_DidRegisterSuccess:(BOOL)success
{
    if(success){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"" message: @"注册邮件已经发送成功，请登录该邮箱进行验证（注：请留意邮箱中的垃圾邮件）" delegate: self cancelButtonTitle: @"去登录" otherButtonTitles: nil];
        [alertView  show];
    }
    else{
        [applicationClass methodOfShowAlert: @"注册失败,请稍候重试"];
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
