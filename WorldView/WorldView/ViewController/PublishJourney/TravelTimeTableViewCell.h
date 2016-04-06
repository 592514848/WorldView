//
//  TravelTimeTableViewCell.h
//  WorldView
//
//  Created by WorldView on 15/11/28.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZJ_CommonClass.h"

@protocol TravelTimeTableViewCellDelegate <NSObject>
- (void)travelTimeTableViewCell_DidDeleteButton:(UITableViewCell *) cell;
@end

@interface TravelTimeTableViewCell : UITableViewCell
@property(nonatomic, retain) id<TravelTimeTableViewCellDelegate> xDelegate;
@property(nonatomic, retain) XZJ_CustomLabel *dateLabel;
@property(nonatomic, retain) XZJ_CustomLabel *timeLabel;
- (id)initWithStyle:(UITableViewCellStyle) style reuseIdentifier:(NSString *) reuseIdentifier size:(CGSize) _size;
@end
