//
//  MemberObject.m
//  WorldView
//
//  Created by WorldView on 15/11/16.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import "MemberObject.h"

@implementation MemberObject
@synthesize xDelegate, memberAccount, memberPhone, memberPhoto,memberSex,memberPassword, memberId, memberSign, languageIds, profession,synopsis, nickName,memberMail,nickName_EN, weixinAccount, memberAddress, memberType, aboutMeImgDesc, aboutMeImgUrl;
- (id)init
{
    self = [super init];
    if(self){
    }
    return self;
}

#pragma mark 验证是否注册
- (void)validateIsRegister
{
    requestType = kValidateIsRegister_Rquest;
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: VALIDATEISREGISTER_METHOD_ID, @"methodId", memberAccount, @"account", nil]] param: nil showIndicator: YES];
}


#pragma mark 找回密码发送验证码
- (void)findPasswordSendCode
{
    requestType = kFindpwdSendCode_Rquest;
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: FINDPWDSENDCODE_METHOD_ID, @"methodId", memberAccount, @"account", nil]] param: nil showIndicator: YES];
}

#pragma mark 发送验证码
- (void)sendCode
{
    requestType = kSendCode_Request;
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: SENDCODE_METHOD_ID, @"methodId", memberAccount, @"account", nil]] param: nil showIndicator: YES];
}

#pragma mark 验证验证码
- (void)validateCode:(NSString *)code
{
    requestType = kValidateCode_Request;
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: VALIDATECODE_METHOD_ID, @"methodId", memberAccount, @"account",code, @"code", nil]] param: nil showIndicator: YES];
}

#pragma mark 注册接口
- (void)register
{
    requestType = kRegister_Request;
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: REGISTER_METHOD_ID, @"methodId", memberAccount, @"account", memberPassword, @"password", nil]] param: nil showIndicator: YES];
}

#pragma mark 登录接口
- (void)loginIn
{
    requestType = kLogin_Request;
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: LOGIN_METHOD_ID, @"methodId", memberAccount, @"account", memberPassword, @"password", nil]] param: nil showIndicator: YES];
}

#pragma mark 重置密码
- (void)resetPassword
{
    requestType = kResetPassword_Rquest;
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: RESETPASSWORD_METHOD_ID, @"methodId", memberAccount, @"account", memberPassword, @"password", nil]] param: nil showIndicator: YES];
}

#pragma mark 加载职业列表
- (void)getProfessionList
{
    requestType = kProfession_Rquest;
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: PROFESSIONLIST_METHOD_ID, @"methodId", nil]] param: nil showIndicator: YES];
}

#pragma mark 加载语言列表
- (void)getLanguaList
{
    requestType = kLanguaList_Rquest;
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: LANGUALIST_METHOD_ID, @"methodId", nil]] param: nil showIndicator: YES];
}

#pragma mark 上传文件
- (void)uploadFile:(NSData *) imageData fileName:(NSString *) fileName
{
    requestType = kUploadFile_Rquest;
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: UPLOADFILE_METHOD_ID, @"methodId", nil]]  fileData: imageData fileName: fileName showIndicator: YES];
}

#pragma mark 更新会员资料
- (void)updateMemberInfo
{
    requestType = kUpdateMember_Rquest;
    NSString *jsonStr = [NSString stringWithFormat: @"{\"id\":\"%@\",\"nickName\":\"%@\",\"mobile\":\"%@\",\"mail\":\"%@\",\"sex\":\"%@\",\"sign\":\"%@\",\"synopsis\":\"%@\",\"imgUrl\":\"%@\",\"professionId\":\"%@\",\"languageIds\":\"%@\",\"engNickName\":\"%@\",\"wechat\":\"%@\",\"addr\":\"%@\",\"aboutMeImgUrl\":\"%@\",\"aboutMeImgDesc\":\"%@\"}", memberId, nickName,memberPhone, memberMail, memberSex, memberSign, synopsis, memberPhoto, profession.professionId, languageIds, nickName_EN,weixinAccount,memberAddress, (aboutMeImgUrl != nil ? aboutMeImgUrl : @""), (aboutMeImgDesc != nil ? aboutMeImgDesc : @"")];
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: UPDATEMEMBERINFO_METHOD_ID, @"methodId", jsonStr, @"jsonStr", nil]] param: nil showIndicator: YES];
}

#pragma mark 获取会员详情
- (void)getMemberDetails
{
    requestType = kMemberDetails_Rquest;
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: USERDETAILS_METHOD_ID, @"methodId", [self memberId], @"userId", nil]] param: nil showIndicator: YES];
}

#pragma mark 上传证件
- (void)uploadCertificate:(CertificateClass *)certificate
{
    requestType = kUploadCertificate_Rquest;
    NSString *json;
    if([certificate certificateId]){
        json = [NSString stringWithFormat: @"{\"id\":\"%@\",\"userId\":\"%@\",\"type\":\"%@\",\"imgUrl\":\"%@\"}", [certificate certificateId], memberId, [certificate certificateType], [certificate imagePath]];
    }
    else{
        json = [NSString stringWithFormat: @"{\"userId\":\"%@\",\"type\":\"%@\",\"imgUrl\":\"%@\"}", memberId, [certificate certificateType], [certificate imagePath]];
    }
    [asyncRequestData startAsyncRequestData_POST: [applicationClass applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: UPLOADCERTIFICATE_METHOD_ID, @"methodId", json, @"jsonStr", nil]] param: nil showIndicator: YES];
}

#pragma mark 得到会员的类型（角色）
- (void)getMemberType:(NSString *) type
{
    if([type isEqualToString: @"REGISTER_USER"]){
        [self setMemberType: kRegister_User];
    }
    else if([type isEqualToString: @"HUNTER_USER"]){
        [self setMemberType: kHunter_User];
    }
}

#pragma mark -
#pragma mark XZJ_AsyncRequestData
- (void)XZJ_AsyncRequestDataReceiveData:(NSDictionary *)responseDictionary
{
    NSLog(@"%@",responseDictionary);
    NSLog(@"%@",[responseDictionary objectForKey: @"msg"]);
    switch (requestType) {
        case 0:
        {
            //发送验证码
            if([xDelegate respondsToSelector: @selector(MemberObject_DidSendCodeSuccess:)]){
                BOOL success = [[responseDictionary objectForKey: @"code"] integerValue] == INTERFACE_SUCEESS_RETURN_CODE ? YES : NO;
                [xDelegate MemberObject_DidSendCodeSuccess: success];
            }
            break;
        }
        case 1:
        {
            ///验证验证码
            if([xDelegate respondsToSelector: @selector(MemberObject_ValidateCode:)]){
                BOOL isPass = [[responseDictionary objectForKey: @"code"] integerValue] == INTERFACE_SUCEESS_RETURN_CODE ? YES : NO;
                [xDelegate MemberObject_ValidateCode: isPass];
            }
            break;
        }
        case 2:
        {
            //注册
            if([xDelegate respondsToSelector: @selector(MemberObject_DidRegisterSuccess:)]){
                BOOL isPass = [[responseDictionary objectForKey: @"code"] integerValue] == INTERFACE_SUCEESS_RETURN_CODE ? YES : NO;
                [xDelegate MemberObject_DidRegisterSuccess: isPass];
            }
            break;
        }
        case 3:
        {
            //登录
            if([xDelegate respondsToSelector: @selector(MemberObject_DidLoginInSuceess: data:)]){
                BOOL success = [[responseDictionary objectForKey: @"code"] integerValue] == INTERFACE_SUCEESS_RETURN_CODE ? YES : NO;
                [xDelegate MemberObject_DidLoginInSuceess: success data: [responseDictionary objectForKey: @"data"]];
            }
            break;
        }
        case 4:
        {
            //重置密码
            if([xDelegate respondsToSelector: @selector(MemberObject_DidResetPasswordSuccess:)]){
                BOOL success = [[responseDictionary objectForKey: @"code"] integerValue] == INTERFACE_SUCEESS_RETURN_CODE ? YES : NO;
                [xDelegate MemberObject_DidResetPasswordSuccess: success];
            }
            break;
        }
        case 5:
        {
            //职业列表
            if([xDelegate respondsToSelector: @selector(MemberObject_GetProfessionList:)]){
                NSArray *tempArray = [responseDictionary objectForKey: @"data"];
                if(!IsNSNULL(tempArray)){
                    NSMutableArray *listArray = [[NSMutableArray alloc] initWithCapacity: [tempArray count]];
                    for(NSDictionary *dictionary in tempArray){
                        ProfessionClass *tmpProfession = [[ProfessionClass alloc] init];
                        [tmpProfession setProfessionId: [dictionary objectForKey: @"id"]];
                        [tmpProfession setProfessionName: [dictionary objectForKey: @"profession"]];
                        [listArray addObject: tmpProfession];
                    }
                    if([xDelegate respondsToSelector: @selector(MemberObject_GetProfessionList:)]){
                        [xDelegate MemberObject_GetProfessionList: listArray];
                    }
                }
            }
            break;
        }
        case 6:{
            //语言列表
            if([xDelegate respondsToSelector: @selector(MemberObject_GetLanguaList:)]){
                NSArray *tempArray = [responseDictionary objectForKey: @"data"];
                if(!IsNSNULL(tempArray)){
                    NSMutableArray *listArray = [[NSMutableArray alloc] initWithCapacity: [tempArray count]];
                    for(NSDictionary *dictionary in tempArray){
                        LanguageClass *language = [[LanguageClass alloc] init];
                        [language setLanguageId: [dictionary objectForKey: @"id"]];
                        [language setLanguageName: [dictionary objectForKey: @"name"]];
                        [listArray addObject: language];
                    }
                    [xDelegate MemberObject_GetLanguaList: listArray];
                }
            }
            break;
        }
        case 7:{
            ///上传头像
            if([xDelegate respondsToSelector: @selector(MemberObject_UploadPhotoSuccess:imagePath:)]){
                BOOL success = [[responseDictionary objectForKey: @"code"] integerValue] == INTERFACE_SUCEESS_RETURN_CODE ? YES : NO;
                NSArray *tempArray = [responseDictionary objectForKey: @"data"];
                NSString *imagePath = @"";
                if (!IsNSNULL(tempArray)) {
                    imagePath = [[tempArray objectAtIndex: 0] objectForKey: @"url"];
                }
                [xDelegate MemberObject_UploadPhotoSuccess: success imagePath:  imagePath];
            }
            break;
        }
        case 8:{
            //更新会员资料
            if([xDelegate respondsToSelector: @selector(MemberObject_DidUpdateSuccess:)]){
                BOOL success = [[responseDictionary objectForKey: @"code"] integerValue] == INTERFACE_SUCEESS_RETURN_CODE ? YES : NO;
                [xDelegate MemberObject_DidUpdateSuccess: success];
            }
            ////更新本地用户信息
            NSMutableDictionary *localDictionary = [NSMutableDictionary dictionaryWithDictionary: (NSDictionary *)[applicationClass methodOfReadLocal: @"LOCALUSER"]];
            [localDictionary setObject: memberSex forKey: @"sex"];
            [localDictionary setObject: memberPhoto forKey: @"photo"];
            [localDictionary setObject: nickName forKey: @"ch_name"];
            [localDictionary setObject: nickName_EN forKey: @"en_name"];
            [localDictionary setObject: memberSign forKey: @"sign"];
            [applicationClass methodOfLocalStorage: localDictionary forKey: @"LOCALUSER"];
            break;
        }
        case 9:{
            //获取会员详情
            NSDictionary *tempDictioanry = [responseDictionary objectForKey: @"data"];
            if(tempDictioanry)
            {
                [self setMemberAccount: VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"account"])];
                [self setMemberPassword: VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"password"])];
                [self setNickName: VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"nickName"])];
                [self setNickName_EN: VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"engNickName"])];
                [self setWeixinAccount: VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"wechat"])];
                [self setMemberAddress: VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"addr"])];
                [self setMemberPhone: VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"mobile"])];
                [self setMemberMail: VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"mail"])];
                [self getMemberType: VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"userType"])];
                if(!IsNSNULL([tempDictioanry objectForKey: @"sex"]))
                    [self setMemberSex: ([[tempDictioanry objectForKey: @"sex"] integerValue] == 1 ? @"女" : @"男")];
                [self setSynopsis: VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"synopsis"])];
                [self setMemberSign: VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"sign"])];
                [self setMemberPhoto: VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"imgUrl"])];
                [self setProfession: VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"professionId"])];
                [self setLanguageIds: VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"languageIds"])];
                [self setAboutMeImgDesc: VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"aboutMeImgDesc"])];
                [self setAboutMeImgUrl: VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"aboutMeImgUrl"])];
                ///证件详情
                NSArray *hunterCertificateList = [tempDictioanry objectForKey: @"hunterCertificateList"];
                NSMutableArray *certifateList = [NSMutableArray arrayWithCapacity: [hunterCertificateList count]];
                for(NSDictionary *dictionary in hunterCertificateList){
                    CertificateClass *certificate = [[CertificateClass alloc] init];
                    [certificate setCertificateId: VALIDATE_VALUE_STRING([dictionary objectForKey: @"id"])];
                    [certificate setCertificateType: VALIDATE_VALUE_STRING([dictionary objectForKey: @"type"])];
                    [certificate setStatus: VALIDATE_VALUE_STRING([dictionary objectForKey: @"status"])];
                    [certificate setImagePath: VALIDATE_VALUE_STRING([dictionary objectForKey: @"imgUrl"])];
                    [certificate setAddTime: VALIDATE_VALUE_STRING([dictionary objectForKey: @"addTime"])];
                    [certifateList addObject: certificate];
                }
                [self setCertificates: certifateList];
                if([xDelegate respondsToSelector: @selector(MemberObject_GetMemberDetails: infoDictionarys:)]){
                    BOOL success = [[responseDictionary objectForKey: @"code"] integerValue] == INTERFACE_SUCEESS_RETURN_CODE ? YES : NO;
                    [xDelegate MemberObject_GetMemberDetails: success infoDictionarys: tempDictioanry];
                }
            }
            break;
        }
        case 10:
        {
            ///上传证件
            if([xDelegate respondsToSelector: @selector(MemberObject_DidUploadCertificate:certificate:)]){
                NSDictionary *tempDictioanry = [responseDictionary objectForKey: @"data"];
                CertificateClass *certificate = [[CertificateClass alloc] init];
                [certificate setCertificateId: VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"id"])];
                [certificate setCertificateType: VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"type"])];
                [certificate setAddTime: VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"addTime"])];
                [certificate setStatus: VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"status"])];
                [certificate setImagePath: VALIDATE_VALUE_STRING([tempDictioanry objectForKey: @"imgUrl"])];
                BOOL success = [[responseDictionary objectForKey: @"code"] integerValue] == INTERFACE_SUCEESS_RETURN_CODE ? YES : NO;
                [xDelegate MemberObject_DidUploadCertificate: success certificate: certificate];
            }
            break;
        }
        case 11:
        {
            ///验证账号是否注册
            if([xDelegate respondsToSelector: @selector(MemberObject_DidIsRegister:)]){
                BOOL isRegister = [[responseDictionary objectForKey: @"code"] integerValue] == INTERFACE_SUCEESS_RETURN_CODE ? NO : YES;
                [xDelegate MemberObject_DidIsRegister: isRegister];
            }
            break;
        }
        case 12:
        {
            ///找回密码发送验证码
            if([xDelegate respondsToSelector: @selector(MemberObject_DidFindPwdSendCode:)]){
                BOOL success = [[responseDictionary objectForKey: @"code"] integerValue] == INTERFACE_SUCEESS_RETURN_CODE ? YES : NO;
                [xDelegate MemberObject_DidFindPwdSendCode: success];
            }
            break;
        }
        default:
            break;
    }
}
- (void)XZJ_AsyncRequestDataUploadFinished:(BOOL)responseResult
{
    NSLog(@"%d", responseResult);
}
@end
