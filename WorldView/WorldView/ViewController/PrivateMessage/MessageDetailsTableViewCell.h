//
//  MessageDetailsTableViewCell.h
//  WorldView
//
//  Created by WorldView on 15/11/14.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZJ_ApplicationClass.h"

@interface MessageDetailsTableViewCell : UITableViewCell
{
    XZJ_ApplicationClass *applicationClass;
    UIImageView *photoImageView;
    UIImageView *messageImageView;
    XZJ_CustomLabel *contentLabel;
}
- (id)initWithStyle:(UITableViewCellStyle) style reuseIdentifier:(NSString *) reuseIdentifier size:(CGSize) _size;
- (void)setLeaveMessageContent:(NSString *) message;
- (void)setPhotoImage:(NSURL *)imageUrl sex:(NSString *)_sex;
- (void)setReplyMessageContent:(NSString *) message;
@end
