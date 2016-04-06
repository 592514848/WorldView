//
//  TravelListTableViewCell.h
//  WorldView
//
//  Created by XZJ on 10/31/15.
//  Copyright © 2015 XZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZJ_ApplicationClass.h"

@protocol TravelListTableViewCell_Delegate <NSObject>
- (void)TravelListTableViewCell_DidOperateButtonClick: (UITableViewCell *)cell buttontag: (NSInteger) buttonTag;
@end

@interface TravelListTableViewCell : UITableViewCell
{
    XZJ_ApplicationClass *applicationClass;
    UIImageView *statusImageView;
    UIImageView *photoImageView;
    NSMutableArray *starImageViewArray;
    UIButton *operateButton;
    UIView *starDisplayView;
    XZJ_CustomLabel *timeLabel;
}
@property(nonatomic, retain) XZJ_CustomLabel *nameLabel;
@property(nonatomic, retain) XZJ_CustomLabel *titleLabel;
@property(nonatomic, retain) XZJ_CustomLabel *subTitleLabel;
@property(nonatomic, retain) XZJ_CustomLabel *priceLabel;
@property(nonatomic, retain) id<TravelListTableViewCell_Delegate> xDelegate;

- (id)initWithStyle:(UITableViewCellStyle) style reuseIdentifier:(NSString *) reuseIdentifier size:(CGSize) _size;
- (void)displayForStatus:(NSInteger) status;
- (void)setPhotoImage:(NSURL *)imageUrl sex:(NSInteger)_sex;
- (void)setStarLevel:(NSInteger)level;
- (void)setPricelText:(NSString *)price;
- (void)setSurplusTime:(NSDate *)time;
@end
