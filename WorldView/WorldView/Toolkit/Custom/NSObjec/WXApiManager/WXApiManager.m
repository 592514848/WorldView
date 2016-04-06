//
//  WXApiManager.m
//  WorldView
//
//  Created by 阿商信息技术有限公司 on 3/28/16.
//  Copyright © 2016 XZJ. All rights reserved.
//

#define VALIDATE_VALUE_STRING(obj) ([obj isEqual: [NSNull null]] ? @"" : obj)
#define VALIDATE_VALUE_DOUBLE(obj) ([obj isEqual: [NSNull null]] ? 0 : [obj doubleValue])
#define VALIDATE_VALUE_LONG(obj) ([obj isEqual: [NSNull null]] ? 0 : [obj longValue])
#define LONG_PASER_TOSTRING(VALUE) [NSString stringWithFormat: @"%lld", [VALUE longLongValue]]
#import "WXApiManager.h"

@implementation WXApiManager
#pragma mark - setters and getters
- (XZJ_AsyncRequestData *)asyncRequestData{
    if(!_asyncRequestData){
        _asyncRequestData = [[XZJ_AsyncRequestData alloc] initWithDelegate: self];
    }
    return _asyncRequestData;
}

#pragma mark - init
+ (id)shareManager{
    static WXApiManager *manager = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        manager = [WXApiManager alloc];
    });
    return manager;
}

#pragma mark - 微信登录
- (void)sendLoginReq{
    NSUserDefaults *userDefailts = [NSUserDefaults standardUserDefaults];
    NSString *WX_Open_ID = [userDefailts objectForKey: @"WX_Open_ID"];
    NSString *nickName = [userDefailts objectForKey: @"WX_Nick_Name"];
    if([WX_Open_ID length] > 0 && [nickName length] > 0){
        curOperate = kWxLogin;
        [self.asyncRequestData startAsyncRequestData_POST: [[XZJ_ApplicationClass commonApplication] applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: WXLOGIN_METHOD_ID, @"methodId", (WX_Open_ID ? WX_Open_ID : @""), @"openId", (nickName ? nickName : @""), @"nickName", nil]] param: nil showIndicator: YES];
    }
    else{
        //构造SendAuthReq结构体
        SendAuthReq* req =[[SendAuthReq alloc ] init];
        req.scope = @"snsapi_userinfo" ;
        req.state = @"1" ;
        //第三方向微信终端发送一个SendAuthReq消息结构
        [WXApi sendReq:req];
    }
}

#pragma mark 微信支付
- (void)weChatPay{
    //调起微信支付
//    NSDictionary *payDictionary = [data objectForKey: @"extendParams"];
    PayReq* req = [[PayReq alloc] init];
//    req.partnerId = [payDictionary objectForKey:@"partnerId"];
//    req.prepayId = [payDictionary objectForKey:@"prepayId"];
//    req.nonceStr = [payDictionary objectForKey:@"nonceStr"];
//    req.timeStamp = (int)[[payDictionary objectForKey: @"timeStamp"] longLongValue];
//    req.package = [payDictionary objectForKey:@"packageValue"];
//    req.sign = [payDictionary objectForKey:@"sign"];
    [WXApi sendReq:req];
}

#pragma mark - 微信delegate
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        
    }
    else if ([resp isKindOfClass:[SendAuthResp class]]) {
        /**
         *  获取code,然后获取access_token(https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code)
         */
        NSUserDefaults *userDefailts = [NSUserDefaults standardUserDefaults];
        if([[(SendAuthResp *)resp code] length] > 0){
            [userDefailts setObject: [(SendAuthResp *)resp code] forKey: @"WX_Auth_Code"];
            [userDefailts synchronize];
        }
        NSString *authCode = [userDefailts objectForKey: @"WX_Auth_Code"];
        if([authCode length] > 0){
            NSString *urlStr = [NSString stringWithFormat: @"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", WX_APP_ID, WX_AppSecret, authCode];
            curOperate = kGetAccessToken;
//            [self.asyncRequestData startAsyncRequestData_GET: urlStr isOutUrl: YES showIndicator: YES];
            [self.asyncRequestData startAsyncRequestData_POST: urlStr param:nil showIndicator: YES isOutUrl: YES];
        }
    }
    else if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]]) {
        
        
    }
}

- (void)onReq:(BaseReq *)req {
    if ([req isKindOfClass:[GetMessageFromWXReq class]]) {
    }
    else if ([req isKindOfClass:[ShowMessageFromWXReq class]]) {
    }
    else if ([req isKindOfClass:[LaunchFromWXReq class]]) {
    }
}

#pragma mark - XZJ_AsyncRequestDataDelegate
- (void)XZJ_AsyncRequestDataReceiveData:(NSDictionary *)responseDictionary{
    NSLog(@"%@", responseDictionary);
    switch (curOperate) {
        case 0:{
            /**
             *  刷新token https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=APPID&grant_type=refresh_token&refresh_token=REFRESH_TOKEN
             */
            NSUserDefaults *userDefailts = [NSUserDefaults standardUserDefaults];
            if(responseDictionary){
                [userDefailts setObject: [responseDictionary objectForKey: @"access_token"] forKey: @"WX_Access_Token"];
                [userDefailts setObject: [responseDictionary objectForKey: @"refresh_token"] forKey: @"WX_Refresh_Token"];
                [userDefailts setObject: [responseDictionary objectForKey: @"oa3BVwyOXw2XptKbLETy90BMvRlQ"] forKey: @"WX_Open_ID"];
                [userDefailts synchronize];
            }
            NSString *refreshToken = [userDefailts objectForKey: @"WX_Refresh_Token"];
            NSString *urlStr = [NSString stringWithFormat: @"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@", WX_APP_ID, refreshToken];
            curOperate = krefreshAccessToken;
            [self.asyncRequestData startAsyncRequestData_POST: urlStr param:nil showIndicator: YES isOutUrl: YES];
            break;
        }
        case 1:{
            /**
             *  获取用户信息 https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID
             */
            NSUserDefaults *userDefailts = [NSUserDefaults standardUserDefaults];
            if(responseDictionary){
                [userDefailts setObject: [responseDictionary objectForKey: @"openid"] forKey: @"WX_Open_ID"];
                [userDefailts synchronize];
            }
            NSString *urlStr = [NSString stringWithFormat: @"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@", [responseDictionary objectForKey: @"access_token"], [responseDictionary objectForKey: @"openid"]];
            curOperate = kGetUserInfo;
            [self.asyncRequestData startAsyncRequestData_POST: urlStr param:nil showIndicator: YES isOutUrl: YES];
            break;
        }
        case 2:{
            /**
             *  得到用户信息
             */
            NSUserDefaults *userDefailts = [NSUserDefaults standardUserDefaults];
            if(responseDictionary){
                [userDefailts setObject: [responseDictionary objectForKey: @"nickname"] forKey: @"WX_Nick_Name"];
            }
            NSString *WX_Open_ID = [userDefailts objectForKey: @"WX_Open_ID"];
            NSString *nickName = [userDefailts objectForKey: @"WX_Nick_Name"];
            curOperate = kWxLogin;
            [self.asyncRequestData startAsyncRequestData_POST: [[XZJ_ApplicationClass commonApplication] applicationInterfaceParamNameAndValue: [NSDictionary dictionaryWithObjectsAndKeys: WXLOGIN_METHOD_ID, @"methodId", (WX_Open_ID ? WX_Open_ID : @""), @"openId", (nickName ? nickName : @""), @"nickName", nil]] param: nil showIndicator: YES];
            break;
        }
        case 3:{
            if(responseDictionary){
                NSDictionary *dictionary = [responseDictionary objectForKey: @"data"];
                NSString *sex = @"0";
                if(![[dictionary objectForKey: @"sex"] isEqual: [NSNull null]]){
                    sex = LONG_PASER_TOSTRING([dictionary objectForKey: @"sex"]);
                }
                NSDictionary *tempDictionary = [NSDictionary dictionaryWithObjectsAndKeys: VALIDATE_VALUE_STRING([dictionary objectForKey: @"account"]) ,@"account", LONG_PASER_TOSTRING([dictionary objectForKey: @"id"]), @"id", VALIDATE_VALUE_STRING([dictionary objectForKey: @"userType"]), @"userType", sex,@"sex", VALIDATE_VALUE_STRING([dictionary objectForKey: @"imgUrl"]), @"photo", VALIDATE_VALUE_STRING([dictionary objectForKey: @"nickName"]), @"ch_name",VALIDATE_VALUE_STRING([dictionary objectForKey: @"engNickName"]), @"en_name",VALIDATE_VALUE_STRING([dictionary objectForKey: @"sign"]), @"sign", nil];
                [[XZJ_ApplicationClass commonApplication] methodOfLocalStorage: tempDictionary forKey: @"LOCALUSER"];
                [[XZJ_ApplicationClass commonApplication] methodOfAlterThenDisAppear: @"登录成功"];
//                if([_delegate respondsToSelector: @selector(WXApiManager_weChatLogin:)]){
//                    [_delegate WXApiManager_weChatLogin: YES];
//                }
                [[NSNotificationCenter defaultCenter] postNotificationName: @"WXApiManager_weChatLogin" object: nil userInfo: nil];
            }
        }
        default:
            break;
    }
}
@end
