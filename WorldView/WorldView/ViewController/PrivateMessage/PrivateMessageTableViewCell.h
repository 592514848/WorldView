//
//  PrivateMessageTableViewCell.h
//  WorldView
//
//  Created by XZJ on 11/2/15.
//  Copyright © 2015 XZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZJ_ApplicationClass.h"

@interface PrivateMessageTableViewCell : UITableViewCell
{
    XZJ_ApplicationClass *applicationClass;
    UIImageView *photoImageView;
    UIView *readView;
}
@property(nonatomic, retain) XZJ_CustomLabel *nameLabel;
@property(nonatomic, retain) XZJ_CustomLabel *titleLabel;
@property(nonatomic, retain) XZJ_CustomLabel *contentLabel;
@property(nonatomic, retain) XZJ_CustomLabel *timeLabel;
/////
- (id)initWithStyle:(UITableViewCellStyle) style reuseIdentifier:(NSString *) reuseIdentifier size:(CGSize) _size;
- (void)setPhotoImage:(NSURL *)imageUrl sex:(NSString *)_sex;
- (void)setTimeSpan:(NSDate *) time;
- (void)setReadStatus:(BOOL) isRead;
@end
