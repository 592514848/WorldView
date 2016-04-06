//
//  XZJ_AsyncRequestData.h
//  XZJ_GetAsyncData
//
//  Created by 6602 on 13-12-9.
//  Copyright (c) 2013年 Xiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XZJ_ApplicationClass.h"

@protocol XZJ_AsyncRequestDataDelegate;
@interface XZJ_AsyncRequestData : NSObject <NSURLConnectionDataDelegate>

/*!
 @property delegate
 @abstract 委托对象
 */
@property(nonatomic) id<XZJ_AsyncRequestDataDelegate> delegate;
- (id)initWithDelegate:(id<XZJ_AsyncRequestDataDelegate>) _delegate;
- (void)startAsyncRequestData_GET:(NSString *) _requestURL showIndicator:(BOOL) isShow;
- (void)startAsyncRequestData_POST:(NSString *) _requestURL param:(NSString *) _param showIndicator:(BOOL) isShow;
- (void)startAsyncRequestData_POST:(NSString *) _requestURL param:(NSString *) _param showIndicator:(BOOL) isShow isOutUrl:(BOOL) isOutUrl;
- (NSDictionary *)startSyncRequestData_POST:(NSString *) _requestURL param:(NSString *) _param showIndicator:(BOOL) isShow;
- (NSDictionary *)startSyncRequestData_GET:(NSString *) _requestURL showIndicator:(BOOL) isShow;
- (void)startAsyncRequestData_POST:(NSString *) _requestURL fileData:(NSData *)_fileData fileName:(NSString *)_fileName showIndicator:(BOOL) isShow;
- (void)startAsyncRequestData_GET:(NSString *) _requestURL isOutUrl:(BOOL) isOutUrl showIndicator:(BOOL) isShow;
@end

@protocol XZJ_AsyncRequestDataDelegate <NSObject>
@optional
- (void)XZJ_AsyncRequestDataReceiveData:(NSDictionary *) responseDictionary;
@end
