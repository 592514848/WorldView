//
//  XZJ_DefaultCell.h
//  GRDApplication
//
//  Created by 6602 on 14-8-16.
//  Copyright (c) 2014年 Xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZJ_CustomLabel.h"

@interface XZJ_DefaultCell : UITableViewCell
@property (nonatomic, retain) UIImageView *defaultImageView;
@property (nonatomic, retain) XZJ_CustomLabel *defaultTitleLabel;
@property (nonatomic, retain) XZJ_CustomLabel *defaultDetailLabel;

- (id)initWithFrame: (CGRect)frame style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
