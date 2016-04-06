//
//  MemberObject.h
//  WorldView
//
//  Created by WorldView on 15/11/16.
//  Copyright © 2015年 XZJ. All rights reserved.
//
#define REGISTER_METHOD_ID @"m0003"
#define LOGIN_METHOD_ID @"m0004"
#define SENDCODE_METHOD_ID @"m0014"
#define VALIDATECODE_METHOD_ID @"m0002"
#define RESETPASSWORD_METHOD_ID @"m0005"
#define PROFESSIONLIST_METHOD_ID @"m0031"
#define LANGUALIST_METHOD_ID @"m0032"
#define UPLOADFILE_METHOD_ID @"m0001"
#define UPDATEMEMBERINFO_METHOD_ID @"m0015"
#define USERDETAILS_METHOD_ID @"m0060"
#define UPLOADCERTIFICATE_METHOD_ID @"m0030"
#define VALIDATEISREGISTER_METHOD_ID @"m0017"
#define FINDPWDSENDCODE_METHOD_ID @"m0018"


#import <Foundation/Foundation.h>
#import "ModelObject.h"
#import "ProfessionClass.h"
#import "LanguageClass.h"
#import "CertificateClass.h"
typedef enum {
    kSendCode_Request = 0,
    kValidateCode_Request = 1,
    kRegister_Request = 2,
    kLogin_Request = 3,
    kResetPassword_Rquest = 4,
    kProfession_Rquest = 5,
    kLanguaList_Rquest = 6,
    kUploadFile_Rquest = 7,
    kUpdateMember_Rquest = 8,
    kMemberDetails_Rquest = 9,
    kUploadCertificate_Rquest = 10,
    kValidateIsRegister_Rquest = 11,
    kFindpwdSendCode_Rquest = 12
}Member_Request_Type;

typedef enum {
    kRegister_User = 0,
    kHunter_User = 1
}Member_Type;

@protocol MemberObjectDelegate <NSObject>
@optional
- (void)MemberObject_DidSendCodeSuccess:(BOOL) success;
- (void)MemberObject_ValidateCode:(BOOL) isPass;
- (void)MemberObject_DidRegisterSuccess:(BOOL) success;
- (void)MemberObject_DidLoginInSuceess:(BOOL) success data:(NSDictionary *) dictionary;
- (void)MemberObject_DidResetPasswordSuccess:(BOOL) success;
- (void)MemberObject_GetProfessionList:(NSArray *) dataArray;
- (void)MemberObject_GetLanguaList:(NSArray *) dataArray;
- (void)MemberObject_UploadPhotoSuccess:(BOOL) success imagePath:(NSString *) imagePath;
- (void)MemberObject_DidUpdateSuccess:(BOOL) success;
- (void)MemberObject_GetMemberDetails:(BOOL) success infoDictionarys:(NSDictionary *) infoDictionary;
- (void)MemberObject_DidUploadCertificate:(BOOL) success certificate:(CertificateClass *)_certificate;
- (void)MemberObject_DidIsRegister:(BOOL) isRegister;
- (void)MemberObject_DidFindPwdSendCode:(BOOL) success;
@end

@interface MemberObject : ModelObject
{
    Member_Request_Type requestType;
}
@property(nonatomic, retain)id<MemberObjectDelegate> xDelegate;//委托对象
@property(nonatomic, retain)NSString *memberId; //会员编号
@property(nonatomic, retain)NSString *memberAccount; //会员账号
@property(nonatomic, retain)NSString *memberPassword; //会员密码
@property(nonatomic, retain)NSString *memberPhoto; //会员头像
@property(nonatomic, retain)NSString *memberPhone; // 会员手机号码
@property(nonatomic, retain)NSString *memberSex; // 会员性别
@property(nonatomic, retain)NSString *nickName;//昵称
@property(nonatomic, retain)NSString *nickName_EN;//英文昵称
@property(nonatomic, retain)NSString *memberMail;//邮箱
@property(nonatomic, retain)NSString *addTime;//新增时间
@property(nonatomic, retain)ProfessionClass *profession;//职业
@property(nonatomic, retain)NSString *memberSign;//签名
@property(nonatomic, retain)NSString *synopsis;//个人简介
@property(nonatomic, retain)NSString *languageIds;///语言
@property(nonatomic) Member_Type memberType; ///用户类型
@property(nonatomic, retain)NSString *weixinAccount;///微信账号
@property(nonatomic, retain)NSString *memberAddress;///会员所在地
@property(nonatomic, retain)NSArray *certificates;///证件
@property(nonatomic, retain)NSString *aboutMeImgUrl;///关于我的图片，用逗号分割
@property(nonatomic, retain)NSString *aboutMeImgDesc;///关于我的文字描述


- (void)validateIsRegister;
- (void)sendCode;
- (void)findPasswordSendCode;
- (void)validateCode:(NSString *)code;
- (void)register;
- (void)loginIn;
- (void)resetPassword;
- (void)getProfessionList;
- (void)getLanguaList;
- (void)uploadFile:(NSData *) imageData fileName:(NSString *) fileName;
- (void)updateMemberInfo;
- (void)getMemberType:(NSString *) type;
- (void)getMemberDetails;
- (void)uploadCertificate:(CertificateClass *)certificate;
@end
