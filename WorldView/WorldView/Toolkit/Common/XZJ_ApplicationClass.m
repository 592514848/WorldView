//
//  XZJ_ApplicationClass.m
//  GRDApplication
//
//  Created by 6602 on 13-12-17.
//  Copyright (c) 2013年 Xiong. All rights reserved.
//

#define INDICATORSIZE 60.0f
#import "XZJ_ApplicationClass.h"
#import <AVFoundation/AVFoundation.h>

@interface  XZJ_ApplicationClass()
{
    UIAlertView *alertView;
    UILabel *tipLabel;
}
@end

static XZJ_ApplicationClass *myCommonApplication = nil;
@implementation XZJ_ApplicationClass
@synthesize themeColor,deviceToken, activityIndicatorView,systemVersion, leaveAction;
@synthesize orderID, alipayNotifyURL, PartnerID, PartnerPrivKey_PKCS8, SellerID, appInfoDictionary;
+(id)commonApplication
{
    @synchronized(self)
    {
        if(myCommonApplication == nil)
        {
            myCommonApplication = [[XZJ_ApplicationClass alloc] init];
        }
    }
    return myCommonApplication;
}

-(id)init
{
    if(self = [super init])
    {
        themeColor = [self methodOfTurnToUIColor: @"#e11133"];
        systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
        ///指示器
        activityIndicatorView = [[MRActivityIndicatorView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, INDICATORSIZE, INDICATORSIZE)];
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        [activityIndicatorView setCenter: CGPointMake(screenSize.width / 2.0f, screenSize.height / 2.0f)];
        [[[UIApplication sharedApplication] keyWindow] addSubview: activityIndicatorView];
        [activityIndicatorView setTintColor: [self methodOfTurnToUIColor: @"#3c3a7f"]];
        [activityIndicatorView setHidden: YES];
//        //////////////////高德云支付宝相关信息///////////////////
//        alipayNotifyURL = @"http://www.mc127.com/Interface/Alipay/notify.aspx";
//        PartnerID = @"2088411851746562";
//        SellerID = @"2088411851746562";
//        PartnerPrivKey_PKCS8 = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBANy0Hzfg0meW7vT34Tx+vkxErdO9s1uXCPCePHoAHCv+RDqLgQpkQA0X9XAVvTOGP2dAA+57/QzdICsz4guskib9QtAbM3MOSokRPuqxmxe27hElwdxl7T7TXTzhOFS325lUrQ0JA95dFg4KuVWBqX0m9OoTKeT2zPAtarsd+9+LAgMBAAECgYBTmeNNblslJDZGEvN9z+DT0RwrXetn4VFgm//6kroZLAq6RofN4OWmUBIHsCRoNQ0lVklm+A6F5ek+lDunAmqlqCFfQYUJtNq3XD+0JfIoPVS014bhfeP/5wsgyK6pg8N5jL2Ny+J5w0MF4YwYoEK3VuQu4SSXT4koP9ri/aoLuQJBAPK1tjLMbqPVfeDozetEfmM0I54rf6WKvshrDtR+cHU1HNZX8NzAK6OjxZAtJKaaMyG3Njovf1PxqBhcBe4Fmu8CQQDoye3F1TtHHOyCqw9iAgQ317pwz4MixKyfNDiMqjHIcNQqW/jxJFJhX0wCiN5YH1QmrZTwR19v7h/IOE8HdzUlAkEA4DJOXVpOEXTSVIF4RYz9mrG8/Qx9WvNxDD0oc81gIESxoKWXTrMNHJnZkzbAFk12UfylUNYzLd2aQvYuXBI9bQJAMtKDGsHm4yupZw25mggeq6Jpjd+AHcMafNeF0RAHNl+LsoPJ4buwUJnhmlwPTuXoFVmoPp0WdPVj8u54MoUQEQJABLUh3n3ru+F6tSNUm4YNULZ/dfDpK4U+OWtBRvSSjY8G0G5h/CgfbMO9K2IhYjKQQrgMkRneYP4IVnCGn/+6cA==";
        //////////////////米层支付宝相关信息///////////////////
        alipayNotifyURL = @"http://www.mc127.com/Interface/Alipay/notify.aspx";
        PartnerID = @"2088911825355733";
        SellerID = @"2088911825355733";
        PartnerPrivKey_PKCS8 = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBALb57StMf6Z4/v0LVwxgpfBqPLLtmGJx61mQw1Q+mEBIWEK4n1Wycp9ppyg4rJ7y+JSpAp9S2gDH9Toj9Kzb5BJMBMoPrKJ1Hn+Wr4Tp8fVP9cWnyJ71RcACeZxc2fkWWZfoyb1eHVGUvM2o81iQjITKsikZACxvMH84xnyOtCX1AgMBAAECgYA+wIACNX4hzaVFizoTWKIQTZ77jliQipk4Ylla7wywHx+F4mNitIxy930IYkdxS8rM0RnBIlz5n5oOkn47Oj6BIm+EQGuuTGh9ucJswY7FuwcOp6xBfUzC/tI9TODWWnDpx/XT+laiEjGg+TA0StxG3FB9WsoXDMR2Y+MLQx1VAQJBAPNeejyH1H/Ih5YJBLtL1TAAOjqEAC34j+sZuR8pSn4RA8MO4ce4r1kGa0holQzLP6CfNGgrg3tzBgLZHWVt78UCQQDAeQpY0RSTKx5K6TePbFF9tknhgNZApZ2qyq2gk3EBoDupFT+5zw55RFuaKWLBqgPe3MQtiLDke7HiCRTrfRBxAkB2u/NbMNHF/inYU1IRpu+92X6PKfOEei6M/yHISDblxptVQR96d2plPrJ8wzlk4oyKauIAqKofQoD+RrsGz1oZAkEArJHZ/Rg5YlpeprvD3Qw5ZIV0aIOjlgLoAqIGWtrXj6Wi2E78/BPx3ji0CNzidtGA9ujp3Ama0ME3FHsgDqPrgQJBAO91LfH5D5i+SWr6HDMSzuFkOrnj52MQdQYuy/ua9p0VSB+a1tkFU6WmhXz7zeHkm7KaZ56SRkLUoN8RkSUViIw=";
    }
    return self;
}

#pragma mark -
#pragma mark 显示指示器
- (void)showActivityIndicatorView
{
    [activityIndicatorView setHidden: NO];
    [activityIndicatorView startAnimating];
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront: activityIndicatorView];
}

#pragma mark -
#pragma mark 隐藏指示器
- (void)hiddenActivityIndicatorView
{
    [activityIndicatorView setHidden: YES];
    [activityIndicatorView stopAnimating];
}

#pragma mark -
#pragma mark 拼接接口方法
/*!
 @method
 @abstract 拼接接口方法
 @discussion --
 @param paramDictionary: 把接口需要的参数拼接成dictionary传过来。
 @result 返回拼接成功的接口URL
 */
- (NSString *)applicationInterfaceParamNameAndValue: (NSDictionary *)paramDictionary
{
    NSMutableString *interfaceURL = [NSMutableString stringWithFormat: @"%@",SERVER_ADDRESS];
    if(paramDictionary != nil)
    {
        [interfaceURL appendString: @"?"];
        for(int i = 0; i < paramDictionary.count;i++)
        {
            NSString *dictionaryKey = [paramDictionary.allKeys objectAtIndex:i];
            NSString *urlString;
            if(i == paramDictionary.count-1)
            {
                 urlString = [NSString stringWithFormat:@"%@=%@",dictionaryKey,[paramDictionary objectForKey: dictionaryKey]];
            }
            else
            {
                urlString = [NSString stringWithFormat:@"%@=%@&",dictionaryKey,[paramDictionary objectForKey: dictionaryKey]];
            }
            [interfaceURL appendString:urlString];
        }
    }
    NSString *urlString = [interfaceURL stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    return urlString;
}

//#pragma mark -
//#pragma mark 返回服务器上的图片URL
//- (NSURL *)applicationServerPictureURL:(NSString *)picturePath
//{
//    return [NSURL URLWithString: [NSString stringWithFormat: @"%@%@", serverAddress, picturePath]];
//}

#pragma mark -
#pragma mark 判断网络是否可用
- (BOOL)methodOfIsConnectionAvailable
{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityFlags flags;
    SCNetworkReachabilityRef reachAbilityRef = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr*)&zeroAddress);
    BOOL result = SCNetworkReachabilityGetFlags(reachAbilityRef, &flags);
    CFRelease(reachAbilityRef);
    if(!result || (flags == 0))
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

#pragma mark -
#pragma mark 本地存储
- (BOOL)methodOfLocalStorage:(id)saveData forKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject: saveData forKey: key];
    [userDefaults synchronize];
    return YES;
}

#pragma mark -
#pragma mark 读取本地存储的数据
- (id)methodOfReadLocal:(NSString *) key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey: key];
}

#pragma mark -
#pragma mark 从本地存储中移除指定key
- (BOOL)methodOfRemoveFromLocal:(NSString *) key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey: key];
    [userDefaults synchronize];
    return YES;
}

#pragma mark -
#pragma mark 判断是否在本地存储中
- (BOOL)methodOfExistLocal:(NSString *) key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    id saveData = [userDefaults objectForKey: key];
    if(!saveData)
    {
        return NO;
    }
    return YES;
}

#pragma mark -
#pragma mark 显示提示信息
- (void)methodOfShowAlert:(NSString *)msg
{
    if(!alertView)
    {
        alertView = [[UIAlertView alloc] init];
        [alertView addButtonWithTitle: @"确定"];
        [alertView setTitle: @""];
    }
    [alertView setMessage: msg];
    [alertView show];
}
#pragma mark -
#pragma mark 呼叫功能(拨打电话)
- (UIWebView *)methodOfCall:(NSString *)phoneNumber
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [[NSString stringWithCString: systemInfo.machine encoding: NSUTF8StringEncoding] lowercaseString];
    if([deviceString hasPrefix: @"iphone"])
    {
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString: @"(" withString: @""];
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString: @")" withString: @""];
        UIWebView *callWebView = [[UIWebView alloc] init];
        [callWebView loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"tel://%@",phoneNumber]]]];
        return callWebView;
    }
    else
    {
        [self methodOfShowAlert: [ NSString stringWithFormat: @"对不起，您的设备不支持呼叫功能,请使用其它设备拨打电话：%@", phoneNumber]];
        return nil;
    }
    return nil;
}


#pragma mark -
#pragma mark 提示后自动消失
- (void)methodOfAlterThenDisAppear:(NSString *) msg
{
    CGSize curScreenSize = [[UIScreen mainScreen] bounds].size;
    UILabel *alterLabel = [[UILabel alloc] initWithFrame: CGRectMake(0.0f, 0.0f, 200.0f, 40.0f)];
    [alterLabel setText: msg];
    [alterLabel setBackgroundColor: [[UIColor alloc] initWithWhite: 0.08f alpha: 0.7f]];
    [alterLabel setFont: [UIFont systemFontOfSize: 15.0f]];
    [alterLabel setTextColor: [UIColor whiteColor]];
    [alterLabel setTextAlignment: NSTextAlignmentCenter];
    [alterLabel setCenter: CGPointMake( curScreenSize.width/2.0f, curScreenSize.height/2.0f)];
    [alterLabel.layer setCornerRadius: 5.0f];
    [alterLabel.layer setMasksToBounds: YES];
    [alterLabel setAdjustsFontSizeToFitWidth: YES];
    [self performSelector:@selector(autoDisppear:) withObject: alterLabel afterDelay: 1.8f];
    [[[UIApplication sharedApplication] keyWindow] addSubview: alterLabel];
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront: alterLabel];
}

- (void)autoDisppear:(UIView *) view
{
    [view removeFromSuperview];
    view = nil;
}

#pragma mark -
#pragma mark 将16进制颜色转UIColor
-(UIColor*)methodOfTurnToUIColor:(NSString*)colorString
{
    NSInteger starIndex = 0, colorLength = [colorString length];
    if([colorString hasPrefix: @"#"])
    {
        starIndex = 1;
        colorLength -= 1;
    }
    CGFloat red = 0.0f,green = 0.0f,blue = 0.0f;
    //alpha=[self colorComponentFrom:colorString start:starIndex length:2];
    if(colorLength >= 2)
        red=[self colorComponentFrom:colorString start:starIndex length:2];
    if(colorLength >= 4)
        green=[self colorComponentFrom:colorString start:starIndex+2 length:2];
    if(colorLength >= 6)
        blue=[self colorComponentFrom:colorString start:starIndex+4 length:2];
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

#pragma mark -
#pragma mark 将16进制颜色转UIColor 并设置透明度
-(UIColor*)methodOfTurnToUIColor:(NSString*)colorString alpha:(CGFloat) alpha
{
    NSInteger starIndex = 0, colorLength = [colorString length];
    if([colorString hasPrefix: @"#"])
    {
        starIndex = 1;
        colorLength -= 1;
    }
    CGFloat red = 0.0f,green = 0.0f,blue = 0.0f;
    //alpha=[self colorComponentFrom:colorString start:starIndex length:2];
    if(colorLength >= 2)
        red=[self colorComponentFrom:colorString start:starIndex length:2];
    if(colorLength >= 4)
        green=[self colorComponentFrom:colorString start:starIndex+2 length:2];
    if(colorLength >= 6)
        blue=[self colorComponentFrom:colorString start:starIndex+4 length:2];
    
    return [UIColor colorWithRed:red green:green blue:blue alpha: alpha];
}

- (CGFloat) colorComponentFrom:(NSString*)string start:(NSUInteger)start length:(NSUInteger)length
{
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

#pragma mark -
#pragma mark UIColor 转UIImage
- (UIImage*)methodOfCreateImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark -
#pragma mark 在指定View上显示提示信息
- (void) methodOfShowTipInView: (UIView *) view text:(NSString *) text
{
    CGSize curScreenSize = [[UIScreen mainScreen] bounds].size;
    if(!tipLabel)
        tipLabel = [[XZJ_CustomLabel alloc] initWithFrame: CGRectMake(0.0, 0.0f, curScreenSize.width, 40.0f)];
    [tipLabel setCenter: CGPointMake(view.frame.size.width / 2.0f, view.frame.size.height / 2.0f)];
    [tipLabel setText: text];
    [tipLabel setTextAlignment: NSTextAlignmentCenter];
    [tipLabel setTextColor: [UIColor lightGrayColor]];
    [tipLabel setFont: [UIFont systemFontOfSize: 15.0f]];
    [tipLabel setHidden: NO];
    [view addSubview: tipLabel];
}

#pragma mark -
#pragma mark 在指定View上隐藏提示信息
- (void) methodOfHideTipInView
{
    if(tipLabel)
        [tipLabel setHidden: YES];
}

#pragma mark -
#pragma mark 慢慢出现和消失的动画
- (void)methodOfAnimationPopAndPush:(NSArray *)views frames:(NSArray *)frames
{
    if([views count] == [frames count])
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.6f];//动画时间长度，单位秒，浮点数
        for(NSInteger i = 0; i < [views count]; i++)
        {
            CGRect frame = CGRectFromString([frames objectAtIndex: i]);
            [[views objectAtIndex: i] setFrame: frame];
        }
        [UIView setAnimationDelegate:self];
        // 动画完毕后调用animationFinished
        [UIView commitAnimations];
    }
}

#pragma mark -
#pragma 验证手机号码
- (BOOL)methodOfValidatePhoneNumber:(NSString *)mobileNum
{
    /*** 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[0235-9]|4[0-9])\\d{8}$";
    /*** 中国移动：China Mobile
     * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /*** 中国联通：China Unicom
     * 130,131,132,152,155,156,185,186
     */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /*** 中国电信：China Telecom
     * 133,1349,153,180,189
     */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /** * 大陆地区固话及小灵通
     * 区号：010,020,021,022,023,024,025,027,028,029
     * 号码：七位或八位
     */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark -
#pragma mark 重新调整view的位置
- (void)methodOfResizeView:(CGFloat) height target:(UIView *) target isNavigation:(BOOL) isNavigation
{
    /**
     *isNavigation 是否有导航栏
     **/
    CGRect viewFrame = target.frame;
    if(height == 0.0f)
    {
        if(isNavigation)
        {
            if([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0f)
                viewFrame.origin.y = 0.0f;
            else
                viewFrame.origin.y = 64.0f;
        }
        else{
            if([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0f)
                viewFrame.origin.y = 20.0f;
            else
                viewFrame.origin.y = 0.0f;
        }
    }
    else
    {
        viewFrame.origin.y = -height;
    }
    [UIView animateWithDuration: 0.3f animations: ^{
        [target setFrame: viewFrame];
    }];
}

#pragma mark -
#pragma mark 呼叫功能(拨打电话)
- (void)methodOfCall:(NSString *)phoneNumber superView:(UIView *) superView
{
    //方法2（更加准确）
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [[NSString stringWithCString: systemInfo.machine encoding: NSUTF8StringEncoding] lowercaseString];
    if([deviceString hasPrefix: @"iphone"])
    {
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString: @"(" withString: @""];
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString: @")" withString: @""];
        UIWebView *callWebView = [[UIWebView alloc] init];
        [callWebView loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"tel://%@",phoneNumber]]]];
        [superView addSubview: callWebView];
    }
    else
        [self methodOfShowAlert: [ NSString stringWithFormat: @"对不起，您的设备不支持呼叫功能,请使用其它设备拨打电话：%@", phoneNumber]];
}

#pragma mark -
#pragma mark 调整图片大小
-(UIImage*) methodOfAdjustImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;   //返回的就是已经改变的图片
}


#pragma mark -
#pragma mark MD5加密
- (NSString *)methodOfMD5Encryption:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    NSString *tmpStr =  [NSString stringWithFormat:
                         @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                         result[0], result[1], result[2], result[3],
                         result[4], result[5], result[6], result[7],
                         result[8], result[9], result[10], result[11],
                         result[12], result[13], result[14], result[15]
                         ];
    return [tmpStr uppercaseString];
}

#pragma mark -
#pragma mark 验证是否是合法邮箱
-(BOOL)methodOfValidateEmail:(NSString *) email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark -
#pragma mark 验证是否是合法身份证
-(BOOL)methodOfValidateIDCard:(NSString *) identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

#pragma mark -
#pragma mark 比较年月日
-(NSInteger)methodOfCompareWithYMD: (NSDate *) date1 compare:(NSDate *) date2
{
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSDateComponents *compents1 = [[NSCalendar currentCalendar] components: unitFlags fromDate: date1];
    NSDateComponents *compents2 = [[NSCalendar currentCalendar] components: unitFlags fromDate: date2];
    if([compents1 year] > [compents2 year])
        return NSOrderedDescending;
    else if([compents1 year] < [compents2 year])
        return NSOrderedAscending;
    else
    {
        if([compents1 month] > [compents2 month])
            return NSOrderedDescending;
        else if([compents1 month] < [compents2 month])
            return NSOrderedAscending;
        else
        {
            if([compents1 day] > [compents2 day])
                return NSOrderedDescending;
            else if([compents1 day] < [compents2 day])
                return NSOrderedAscending;
            else
                return NSOrderedSame;
        }
    }
}

#pragma mark 动态得到Lable的大小
- (CGSize)methodOfGetLabelSize:(UILabel *)label
{
    if([label.text respondsToSelector: @selector(boundingRectWithSize:options:attributes:context:)]){
        CGRect tmpRect = [label.text boundingRectWithSize:CGSizeMake(label.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:label.font,NSFontAttributeName, nil] context:nil];
        return tmpRect.size;
    }
//    else if([label.text respondsToSelector: @selector(sizeWithFont:constrainedToSize:lineBreakMode:)]){
//        CGSize linesSz = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(label.frame.size.width, MAXFLOAT) lineBreakMode: label.lineBreakMode];
//        return linesSz;
//    }
    else{
        return label.frame.size;
    }
}
@end
