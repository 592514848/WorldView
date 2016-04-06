//
//  ThemeTravelTableViewCell.h
//  WorldView
//
//  Created by XZJ on 11/3/15.
//  Copyright © 2015 XZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZJ_ApplicationClass.h"
#import "MemberObject.h"
#import "ServiceClass.h"

@interface ThemeTravelTableViewCell : UITableViewCell
{
    UIScrollView *mainScrollView;
    UIView *displayView;
    XZJ_ApplicationClass *applicationClass;
}
@property(nonatomic, retain) UIImageView *mainImageView;
@property(nonatomic, retain) XZJ_CustomLabel *ch_localNameLabel;
@property(nonatomic, retain) XZJ_CustomLabel *en_localNameLabel;
- (id)initWithStyle:(UITableViewCellStyle) style reuseIdentifier:(NSString *) reuseIdentifier size:(CGSize) _size;
- (void)updateDisplayView:(NSArray *) _array;
- (void)updateMainScrollView:(NSArray *) _array;
@end
