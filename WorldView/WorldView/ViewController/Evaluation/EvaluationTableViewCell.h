//
//  EvaluationTableViewCell.h
//  WorldView
//
//  Created by WorldView on 15/11/16.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZJ_ApplicationClass.h"

@interface EvaluationTableViewCell : UITableViewCell
{
    XZJ_ApplicationClass *applicationClass;
    NSMutableArray *starImageViewArray;
    UIImageView *photoImageView;
}
@property(nonatomic, retain) XZJ_CustomLabel *nameLabel;
@property(nonatomic, retain) XZJ_CustomLabel *contentLabel;
@property(nonatomic, retain) XZJ_CustomLabel *timeLabel;
- (id)initWithStyle:(UITableViewCellStyle) style reuseIdentifier:(NSString *) reuseIdentifier size:(CGSize) _size;
- (void)setStarLevel:(NSInteger)level;
- (void)setPhotoImage:(NSURL *)imageUrl sex:(NSString *)_sex;
@end
