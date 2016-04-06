//
//  TravelHunterView.h
//  WorldView
//
//  Created by XZJ on 11/3/15.
//  Copyright © 2015 XZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZJ_ApplicationClass.h"

@interface TravelHunterView : UIView
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

- (void)setPhotoImage:(NSURL *)imageUrl sex:(NSString *)_sex;
- (void)setAppointButtonThemeColorBySex:(NSString *)_sex;
- (void)setStarLevel:(NSInteger)level;
- (void)setPricelText:(NSString *)price;
- (void)setIsCollection:(BOOL) isCollection;
@end
