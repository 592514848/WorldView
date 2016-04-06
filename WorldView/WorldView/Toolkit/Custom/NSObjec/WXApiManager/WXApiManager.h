//
//  WXApiManager.h
//  WorldView
//
//  Created by 阿商信息技术有限公司 on 3/28/16.
//  Copyright © 2016 XZJ. All rights reserved.
//

#define WX_APP_ID @"wxbecb350aa6221db3"
#define WX_AppSecret @"89d4cd9a59f0d086fe2e221fa317483c"
#define WXLOGIN_METHOD_ID @"m0071"


#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "XZJ_ApplicationClass.h"

typedef enum {
    kGetAccessToken = 0,
    krefreshAccessToken = 1,
    kGetUserInfo = 2,
    kWxLogin = 3
}WXOperate;

@protocol WXApiManagerDelegate <NSObject>
- (void)WXApiManager_weChatLogin:(BOOL) isSuccess;
@end

@interface WXApiManager : NSObject<WXApiDelegate,XZJ_AsyncRequestDataDelegate>
{
    WXOperate curOperate;
}
@property(nonatomic, retain) XZJ_AsyncRequestData *asyncRequestData;


+ (id)shareManager;
- (void)sendLoginReq;
- (void)weChatPay;
@end
