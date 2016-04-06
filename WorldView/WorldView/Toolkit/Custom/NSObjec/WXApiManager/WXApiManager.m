//
//  WXApiManager.m
//  WorldView
//
//  Created by 阿商信息技术有限公司 on 3/28/16.
//  Copyright © 2016 XZJ. All rights reserved.
//

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
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"1" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
    //                SendAuthReq* req = [[SendAuthReq alloc] init];
    //                //    req.scope = scope; // @"post_timeline,sns"
    //                //    req.state = state;
    //                //    req.openID = openID;
    //                req.scope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact";
    //                req.state = @"1";
    //                req.openID = @"0c806938e2413ce73eef92cc3";
    //                [WXApi sendAuthReq:req
    //                           viewController: weakSelf
    //                                 delegate: weakSelf];
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
            [self.asyncRequestData startAsyncRequestData_GET: urlStr isOutUrl: YES showIndicator: YES];
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
                [userDefailts synchronize];
            }
            NSString *refreshToken = [userDefailts objectForKey: @"WX_Refresh_Token"];
            NSString *urlStr = [NSString stringWithFormat: @"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@", WX_APP_ID, refreshToken];
            curOperate = krefreshAccessToken;
            [self.asyncRequestData startAsyncRequestData_GET: urlStr isOutUrl: YES showIndicator: YES];
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
            [self.asyncRequestData startAsyncRequestData_GET: urlStr isOutUrl: YES showIndicator: YES];
            break;
        }
        case 2:{
            /**
             *  得到用户信息
             */
            
            break;
        }
        default:
            break;
    }
}
@end
