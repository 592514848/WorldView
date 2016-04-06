//
//  XZJ_AsyncRequestData.m
//  XZJ_GetAsyncData
//
//  Created by 6602 on 13-12-9.
//  Copyright (c) 2013年 Xiong. All rights reserved.
//

#import "XZJ_AsyncRequestData.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPSessionManager.h"
#import "jsonkit.h"

@implementation XZJ_AsyncRequestData
@synthesize delegate;

#pragma mark -
#pragma mark [XZJ_AsyncRequestData初始化函数]
- (id)init
{
    if(self = [super init])
    {
    }
    return self;
}

#pragma mark -
#pragma mark 版本2.0 (采用AFNetworking库实现同步、异步的GET、POST请求)
#pragma mark -
#pragma mark [XZJ_AsyncRequestData便利初始化函数]
- (id)initWithDelegate:(id<XZJ_AsyncRequestDataDelegate>) _delegate
{
    if(self = [super init])
    {
        delegate = _delegate;
    }
    return self;
}

#pragma mark -
#pragma mark 使用GET方式开始异步请求
/*!
 @method
 @abstract 使用GET方式开始异步请求
 @discussion 本方法通过XZJ_AsyncRequestData对象来调用本方法，注意_requestURL这个参数为NSString类型，不需要NSURL类型。
 @param _requestURL:调用接口的URL（NSString类型）。
 @param isShow:是否显示加载数据时的活动指示器。
 @result 无返回结果
 */
- (void)startAsyncRequestData_GET:(NSString *) _requestURL showIndicator:(BOOL) isShow
{
    [self startAsyncRequestData_GET: _requestURL isOutUrl: NO showIndicator: isShow];
}

#pragma mark -
#pragma mark 使用GET方式开始异步请求
/*!
 @method
 @abstract 使用GET方式开始异步请求
 @discussion 本方法通过XZJ_AsyncRequestData对象来调用本方法，注意_requestURL这个参数为NSString类型，不需要NSURL类型。
 @param _requestURL:调用接口的URL（NSString类型）。
 @param isShow:是否显示加载数据时的活动指示器。
 @result 无返回结果
 */
- (void)startAsyncRequestData_GET:(NSString *) _requestURL isOutUrl:(BOOL) isOutUrl showIndicator:(BOOL) isShow
{
    [[(UIViewController *)delegate view] setUserInteractionEnabled: NO];
    if(isShow)
    {
        [[XZJ_ApplicationClass commonApplication] showActivityIndicatorView];
    }
    AFHTTPRequestOperationManager *operateManager = [AFHTTPRequestOperationManager manager];
    [operateManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObject: [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"textml", nil]]];
    [operateManager GET: _requestURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[XZJ_ApplicationClass commonApplication] hiddenActivityIndicatorView];
        if(isOutUrl){
            if([delegate respondsToSelector: @selector(XZJ_AsyncRequestDataReceiveData:)])
                [delegate XZJ_AsyncRequestDataReceiveData: responseObject];
        }
        else{
            if([[responseObject objectForKey: @"result"] isEqualToString: @"0x00"])
            {
                if([delegate respondsToSelector: @selector(XZJ_AsyncRequestDataReceiveData:)])
                    [delegate XZJ_AsyncRequestDataReceiveData: responseObject];
            }
            else
                [[XZJ_ApplicationClass commonApplication] methodOfShowAlert: @"数据请求错误,请稍后再试"];
        }
        [[(UIViewController *)delegate view] setUserInteractionEnabled: YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[XZJ_ApplicationClass commonApplication] hiddenActivityIndicatorView];
        [[(UIViewController *)delegate view] setUserInteractionEnabled: YES];
        [[XZJ_ApplicationClass commonApplication] methodOfShowAlert: @"网络开小差，请稍后再试"];
    }];
}

#pragma mark -
#pragma mark 使用GET方式开始同步请求
/*!
 @method
 @abstract 使用GET方式开始同步请求
 @discussion 本方法通过XZJ_AsyncRequestData对象来调用本方法，注意_requestURL这个参数为NSString类型，不需要NSURL类型。
 @param _requestURL:调用接口的URL（NSString类型）。
 @param isShow:是否显示加载数据时的活动指示器。
 @result 返回的是将从服务器上获取的数据转成的NSDictioanry类型的数据
 */
- (NSDictionary *)startSyncRequestData_GET:(NSString *) _requestURL showIndicator:(BOOL) isShow
{
    if(isShow)
    {
        [[XZJ_ApplicationClass commonApplication] showActivityIndicatorView];
    }
    NSMutableURLRequest *synchronousRequest = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: _requestURL]];
    [synchronousRequest setHTTPMethod: @"GET"];
    NSError *error;
    NSData *returnData = [NSURLConnection sendSynchronousRequest: synchronousRequest returningResponse:nil error:&error];
    if(!error)
    {
        NSString *responsedString = [[NSString alloc] initWithData: returnData encoding:NSUTF8StringEncoding];
        responsedString = [responsedString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSDictionary *responesedDictionary = [responsedString objectFromJSONStringWithParseOptions: JKParseOptionLooseUnicode];
        [[XZJ_ApplicationClass commonApplication] hiddenActivityIndicatorView];
        if([[responesedDictionary objectForKey: @"result"] isEqualToString: @"0x00"])
        {
            return responesedDictionary;
        }
        else
        {
            [[XZJ_ApplicationClass commonApplication] methodOfShowAlert: @"服务器异常，是否退出程序？"];
            return nil;
        }
    }
    else
    {
        NSLog(@"%@", [error description]);
        return nil;
    }
}

#pragma mark -
#pragma mark 使用POST方式开始异步请求
/*!
 @method
 @abstract 使用POST方式开始异步请求
 @discussion 本方法通过XZJ_AsyncRequestData对象来调用本方法，注意_requestURL这个参数为NSString类型，不需要NSURL类型。
 @param _requestURL:调用接口的URL（NSString类型）。
 @param _param:需要上传的数据。
 @param isShow:是否显示加载数据时的活动指示器。
 @result 无返回结果
 */
- (void)startAsyncRequestData_POST:(NSString *) _requestURL param:(NSString *) _param showIndicator:(BOOL) isShow
{
    NSLog(@"%@", _requestURL);
    if(isShow)
    {
        [[XZJ_ApplicationClass commonApplication] showActivityIndicatorView];
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: _requestURL]];
    [request setTimeoutInterval:30.0f];
    [request setHTTPMethod:@"POST"];
    [request setValue: [NSString stringWithFormat: @"%ld", (long)[_param length]] forHTTPHeaderField:@"Content-Length"];
    [request setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSData *httpData = [_param dataUsingEncoding: NSUTF8StringEncoding];
    [request setHTTPBody: httpData];
    
    AFHTTPRequestOperation *operation =[[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [[XZJ_ApplicationClass commonApplication] hiddenActivityIndicatorView];
         NSString *responsedString = [[NSString alloc] initWithData: responseObject encoding:NSUTF8StringEncoding];
         responsedString = [responsedString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
         NSDictionary *responesedDictionary = [responsedString objectFromJSONStringWithParseOptions: JKParseOptionLooseUnicode];
         if(responesedDictionary)
         {
             if([delegate respondsToSelector: @selector(XZJ_AsyncRequestDataReceiveData:)])
                 [delegate XZJ_AsyncRequestDataReceiveData:responesedDictionary];
         }
         else
         {
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"温馨提示" message: @"抱歉，数据访问出错，请稍候再试" delegate: nil cancelButtonTitle: @"确定" otherButtonTitles: nil];
             [alertView show];
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [[XZJ_ApplicationClass commonApplication] hiddenActivityIndicatorView];
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"温馨提示" message: @"网络开小差，请稍后再试" delegate: nil cancelButtonTitle: @"确定" otherButtonTitles: nil];
         [alertView show];
     }];
    [operation start];
}

#pragma mark -
#pragma mark 使用POST方式开始同步请求
/*!
 @method
 @abstract 使用POST方式开始异步请求
 @discussion 本方法通过XZJ_AsyncRequestData对象来调用本方法，注意_requestURL这个参数为NSString类型，不需要NSURL类型。
 @param _requestURL:调用接口的URL（NSString类型）。
 @param _param:需要上传的数据。
 @param isShow:是否显示加载数据时的活动指示器。
 @result 无返回结果
 */
- (NSDictionary *)startSyncRequestData_POST:(NSString *) _requestURL param:(NSString *) _param showIndicator:(BOOL) isShow
{
    if(isShow)
    {
        [[XZJ_ApplicationClass commonApplication] showActivityIndicatorView];
    }
    
    NSURL *url = [NSURL URLWithString: _requestURL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    NSData *httpData = [_param dataUsingEncoding: NSUTF8StringEncoding];
    [request setHTTPBody: httpData];
    NSData *receivedString = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];

    //对数据进行处理
   [[XZJ_ApplicationClass commonApplication] hiddenActivityIndicatorView];
    NSString *responsedString = [[NSString alloc] initWithData: receivedString encoding:NSUTF8StringEncoding];
    responsedString = [responsedString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSDictionary *responesedDictionary = [responsedString objectFromJSONStringWithParseOptions: JKParseOptionLooseUnicode];
    if([[responesedDictionary objectForKey: @"result"] isEqualToString: @"0x00"])
    {
        return responesedDictionary;
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"温馨提示" message: @"网络开小差，请稍后再试" delegate: nil cancelButtonTitle: @"确定" otherButtonTitles: nil];
        [alertView show];
        return nil;
    }
}

#pragma mark -
#pragma mark 使用POST方式开始异步请求
/*!
 @method
 @abstract 使用POST方式开始异步请求
 @discussion 本方法通过XZJ_AsyncRequestData对象来调用本方法，注意_requestURL这个参数为NSString类型，不需要NSURL类型。
 @param _requestURL:调用接口的URL（NSString类型）。
 @param fileData:需要上传二进制文件数据。
 @param _fileName:二进制文件的名称。
 @param isShow:是否显示加载数据时的活动指示器。
 @result 无返回结果
 */
- (void)startAsyncRequestData_POST:(NSString *) _requestURL fileData:(NSData *)_fileData fileName:(NSString *)_fileName showIndicator:(BOOL) isShow
{
    if(isShow)
    {
        UIView *indicatorView = [[[UIApplication sharedApplication] keyWindow] viewWithTag: 1024];
        [indicatorView setHidden: NO];
        [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront: indicatorView];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = //[NSSet setWithObjects: @"textml", nil];
    [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"textml", nil];
    [manager POST: _requestURL parameters: nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:_fileData //图片转成data
                                    name:_fileName fileName:@"image.png"
                                mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //成功后的处理
        UIView *indicatorView = [[[UIApplication sharedApplication] keyWindow] viewWithTag: 1024];
        [indicatorView setHidden: YES];
        if(responseObject){
            if([delegate respondsToSelector: @selector(XZJ_AsyncRequestDataReceiveData:)])
                [delegate XZJ_AsyncRequestDataReceiveData: responseObject];
        }
        else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"温馨提示" message: @"数据获取错误，我们将尽快处理" delegate: nil cancelButtonTitle: @"确定" otherButtonTitles: nil];
            [alertView show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIView *indicatorView = [[[UIApplication sharedApplication] keyWindow] viewWithTag: 1024];
        [indicatorView setHidden: YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"温馨提示" message: @"十分抱歉，加载错误，请稍后再试" delegate: nil cancelButtonTitle: @"确定" otherButtonTitles: nil];
        [alertView show];
    }];
}
@end
