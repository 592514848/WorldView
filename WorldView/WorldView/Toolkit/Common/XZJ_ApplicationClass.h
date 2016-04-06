//
//  XZJ_ApplicationClass.h
//  GRDApplication
//
//  Created by 6602 on 13-12-17.
//  Copyright (c) 2013年 Xiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XZJ_CommonClass.h"
#import <netinet/in.h>
#import "sys/utsname.h"
#import <CommonCrypto/CommonDigest.h>
#import "MRProgress.h"

typedef enum
{
    kShareAction = 0, ///分享
    kAlipayAction = 1, ///支付宝支付
    kWeiXinPayAction = 2 ///微信支付
}LeaveApplicationAction;

#define SERVER_ADDRESS @"http://123.57.54.221:8080/worldview/app/baseurl.do"
#define SERVER_FILE_ADDRESS @"http://123.57.54.221:8080/worldview"
#define IMAGE_URL(path) [NSURL URLWithString: [NSString stringWithFormat: @"%@%@",SERVER_FILE_ADDRESS,path]]

@interface XZJ_ApplicationClass : NSObject
{
    UIViewController *responser;
}
@property(nonatomic,retain) MRActivityIndicatorView *activityIndicatorView;
@property(nonatomic,readonly) UIColor *themeColor;
@property(nonatomic,retain) NSString *deviceToken;//设备token
@property(nonatomic,readonly) CGFloat systemVersion;
@property(nonatomic) LeaveApplicationAction leaveAction; //离开应用的动作
@property(nonatomic, retain) NSDictionary *appInfoDictionary; //app信息

////////////////////////支付宝支付的相关数据/////////////////////////////////
@property(nonatomic,retain) NSString *orderID; //当前付款的订单编号，用于调回应用后，更新订单状态
@property(nonatomic,readonly) NSString *alipayNotifyURL; //支付宝支付的通知页地址
@property(nonatomic, readonly) NSString *PartnerID;
@property(nonatomic, readonly) NSString *PartnerPrivKey_PKCS8;
@property(nonatomic, readonly) NSString *SellerID;

//////////////////////////////////////////
+(id)commonApplication;
- (NSString *)applicationInterfaceParamNameAndValue: (NSDictionary *)paramDictionary;
- (void)showActivityIndicatorView;
- (void)hiddenActivityIndicatorView;
- (void)methodOfShowAlert:(NSString *)msg;
- (BOOL)methodOfLocalStorage:(id)saveData forKey:(NSString *)key;
- (id)methodOfReadLocal:(NSString *) key;
- (BOOL)methodOfExistLocal:(NSString *) key;
-(UIColor*)methodOfTurnToUIColor:(NSString*)colorString;
- (void)methodOfAnimationPopAndPush:(NSArray *)views frames:(NSArray *)frames;
- (BOOL)methodOfValidatePhoneNumber:(NSString *)mobileNum;
- (void)methodOfResizeView:(CGFloat) height target:(UIView *) target isNavigation:(BOOL) isNavigation;
- (void)methodOfAlterThenDisAppear:(NSString *) msg;
- (void) methodOfShowTipInView: (UIView *) view text:(NSString *) text;
- (void) methodOfHideTipInView;
- (BOOL)methodOfRemoveFromLocal:(NSString *) key;
- (void)methodOfCall:(NSString *)phoneNumber superView:(UIView *) superView;
-(UIImage*) methodOfAdjustImage:(UIImage *)image scaleToSize:(CGSize)size;
- (NSString *)methodOfMD5Encryption:(NSString *)str;
//-(void) methodOfSetZBarOverlayView:(ZBarReaderViewController *) reader barTitle:(NSString *) barTitle responser:(UIViewController *) _responser;
-(BOOL)methodOfValidateEmail:(NSString *) email;
-(BOOL)methodOfValidateIDCard:(NSString *) identityCard;
-(NSInteger)methodOfCompareWithYMD: (NSDate *) date1 compare:(NSDate *) date2;
- (CGSize)methodOfGetLabelSize:(UILabel *)label;
@end
