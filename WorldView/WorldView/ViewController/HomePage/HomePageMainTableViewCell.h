//
//  HomaPageMainTableViewCell.h
//  WorldView
//
//  Created by XZJ on 11/3/15.
//  Copyright © 2015 XZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZJ_ApplicationClass.h"

@interface HomePageMainTableViewCell : UITableViewCell
@property(nonatomic, retain) UIImageView *mainImageView;
@property(nonatomic, retain) XZJ_CustomLabel *ch_localNameLabel;
@property(nonatomic, retain) XZJ_CustomLabel *en_localNameLabel;
- (id)initWithStyle:(UITableViewCellStyle) style reuseIdentifier:(NSString *) reuseIdentifier size:(CGSize) _size;
@end
