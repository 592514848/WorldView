//
//  LanguageTableViewCell.h
//  WorldView
//
//  Created by WorldView on 15/11/21.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZJ_ApplicationClass.h"

@interface LanguageTableViewCell : UITableViewCell
{
    XZJ_ApplicationClass *applicationClass;
    UIImageView *selectImageView;
}
@property(nonatomic, retain) XZJ_CustomLabel *languageLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier size:(CGSize ) _size;
- (void)setSelectStatus;
- (void)setNotSelectStatus;
@end
