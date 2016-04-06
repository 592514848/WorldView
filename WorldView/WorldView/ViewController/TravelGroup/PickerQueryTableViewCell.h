//
//  PickerQueryTableViewCell.h
//  WorldView
//
//  Created by XZJ on 11/9/15.
//  Copyright © 2015 XZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZJ_ApplicationClass.h"
@interface PickerQueryTableViewCell : UITableViewCell
{
    UIView *selectView;
    XZJ_ApplicationClass *applicationClass;
}
@property(nonatomic, retain) XZJ_CustomLabel *defaultLabel;
- (id)initWithStyle:(UITableViewCellStyle) style reuseIdentifier:(NSString *) reuseIdentifier size:(CGSize) _size;
- (void)setSelected: (BOOL) isSelected;
@end
