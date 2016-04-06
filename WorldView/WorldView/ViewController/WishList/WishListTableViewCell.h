//
//  WishListTableViewCell.h
//  WorldView
//
//  Created by XZJ on 11/2/15.
//  Copyright © 2015 XZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZJ_ApplicationClass.h"

@protocol WishListTableViewCellDelegate <NSObject>
- (void)wishListTableViewCell_DidButtonClick:(UIButton *)button tableViewCell:(UITableViewCell *) cell;
- (void)wishListTableViewCell_DidCollectionClick:(UITableViewCell *) cell;
@end

@interface WishListTableViewCell : UITableViewCell
{
    XZJ_ApplicationClass *applicationClass;
    UIImageView *photoImageView;
    NSMutableArray *starImageViewArray;
    UIView *starDisplayView;
    UIButton *appointButton;
    UIImageView *collectionImageView;
}
@property(nonatomic, retain) UIImageView *localImageView;
@property(nonatomic, retain) XZJ_CustomLabel *nameLabel;
@property(nonatomic, retain) XZJ_CustomLabel *titleLabel;
@property(nonatomic, retain) XZJ_CustomLabel *subTitleLabel;
@property(nonatomic, retain) XZJ_CustomLabel *appointNumberLabel;
@property(nonatomic, retain) XZJ_CustomLabel *priceLabel;
@property(nonatomic, retain) XZJ_CustomLabel *localLabel;
@property(nonatomic, retain) XZJ_CustomLabel *collectionNumberLabel;
@property(nonatomic, retain) id<WishListTableViewCellDelegate> xDelegate;

- (id)initWithStyle:(UITableViewCellStyle) style reuseIdentifier:(NSString *) reuseIdentifier size:(CGSize) _size;
- (void)setPhotoImage:(NSURL *)imageUrl sex:(NSInteger)_sex;
- (void)setAppointButtonThemeColorBySex:(NSInteger) _sex;
- (void)setStarLevel:(NSInteger)level;
- (void)setPricelText:(NSString *)price;
- (void)setIsCollection:(BOOL) isCollection;
@end
