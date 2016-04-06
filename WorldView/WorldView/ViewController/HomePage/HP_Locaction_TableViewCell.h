//
//  HP_Locaction_TableViewCell.h
//  WorldView
//
//  Created by XZJ on 10/30/15.
//  Copyright © 2015 XZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZJ_CustomLabel.h"

@interface HP_Locaction_TableViewCell : UITableViewCell
@property(nonatomic, retain) UIImageView *defaultImageView;
@property(nonatomic, retain) XZJ_CustomLabel *defaultLabel;

- (id)initWithStyle:(UITableViewCellStyle) style reuseIdentifier:(NSString *) reuseIdentifier size:(CGSize) _size;
@end
