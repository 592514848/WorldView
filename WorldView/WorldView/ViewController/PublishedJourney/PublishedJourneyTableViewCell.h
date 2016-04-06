//
//  PublishedJourneyTableViewCell.h
//  WorldView
//
//  Created by XZJ on 11/3/15.
//  Copyright © 2015 XZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZJ_ApplicationClass.h"

@protocol PublishedJourneyTableViewCellDelegate <NSObject>
- (void)PublishedJourneyTableViewCell_DidShelOffbuttonClick:(UITableViewCell *) cell;
- (void)PublishedJourneyTableViewCell_DidEditbuttonClick:(UITableViewCell *) cell;
@end

@interface PublishedJourneyTableViewCell : UITableViewCell
{
    XZJ_ApplicationClass *applicationClass;
    UIView *mainView;
    UIImageView *photoImageView;
    NSMutableArray *starImageViewArray;
    UIView *starDisplayView;
    UIButton *offShelfButton;
    UIButton *editButton;
}
@property(nonatomic, retain) id<PublishedJourneyTableViewCellDelegate> xDelegate;
@property(nonatomic, retain) UIImageView *localImageView;
@property(nonatomic, retain) XZJ_CustomLabel *nameLabel;
@property(nonatomic, retain) XZJ_CustomLabel *titleLabel;
@property(nonatomic, retain) XZJ_CustomLabel *appointNumberLabel;
@property(nonatomic, retain) XZJ_CustomLabel *localLabel;
@property(nonatomic, retain) XZJ_CustomLabel *collectionNumberLabel;

- (id)initWithStyle:(UITableViewCellStyle) style reuseIdentifier:(NSString *) reuseIdentifier size:(CGSize) _size;
- (void)displayForStatus:(NSString *)status;
- (void)setPhotoImage:(NSURL *)imageUrl sex:(NSString *)_sex;
- (void)setStarLevel:(NSInteger)level;
@end
