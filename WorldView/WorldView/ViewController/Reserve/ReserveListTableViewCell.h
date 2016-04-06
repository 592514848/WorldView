//
//  ReserveListTableViewCell.h
//  WorldView
//
//  Created by XZJ on 11/2/15.
//  Copyright © 2015 XZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZJ_ApplicationClass.h"

@protocol ReserveListTableViewCellDelegate <NSObject>
- (void)ReserveListTableViewCell_DidRejectButtonClick:(UITableViewCell *)cell;
- (void)ReserveListTableViewCell_DidOperateButtonClick:(UITableViewCell *)cell index:(NSInteger) index;
@end

@interface ReserveListTableViewCell : UITableViewCell
{
    XZJ_ApplicationClass *applicationClass;
    UIImageView *photoImageView;
    UIButton *operateButton;
    UIButton *rejectButton;
    XZJ_CustomLabel *timeSpanLabel;
}
@property(nonatomic, retain) XZJ_CustomLabel *nameLabel;
@property(nonatomic, retain) XZJ_CustomLabel *titleLabel;
@property(nonatomic, retain) XZJ_CustomLabel *timeLabel;
@property(nonatomic, retain) XZJ_CustomLabel *placeLabel;
@property(nonatomic, retain) XZJ_CustomLabel *numberLabel;
@property(nonatomic, retain) XZJ_CustomLabel *contentLabel;
@property(nonatomic, retain) XZJ_CustomLabel *descriptLabel;
@property(nonatomic, retain) id <ReserveListTableViewCellDelegate> xDelegate;

- (id)initWithStyle:(UITableViewCellStyle) style reuseIdentifier:(NSString *) reuseIdentifier size:(CGSize) _size;
- (void)displayForStatus:(NSInteger) status;
- (void)setPhotoImage:(NSURL *) imageUrl sex:(NSString *) _sex;
- (void)setSurplusTime:(NSDate *)time;
@end
