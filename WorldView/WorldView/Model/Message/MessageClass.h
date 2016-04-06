//
//  MessageClass.h
//  WorldView
//
//  Created by WorldView on 15/11/20.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MemberObject.h"

@interface MessageClass : NSObject
@property(nonatomic,retain) NSString *messageId;
@property(nonatomic,retain) NSString *serviceId;
@property(nonatomic,retain) NSString *messageTitle;
@property(nonatomic, retain) NSString *messageContent;
@property(nonatomic, retain) NSDate *addTime;
@property(nonatomic, retain) MemberObject *sendMember;
@property(nonatomic, retain) MemberObject *receiveMember;
@property(nonatomic) BOOL isRead;  /// 0 -未读  ，1 -已读
@end
