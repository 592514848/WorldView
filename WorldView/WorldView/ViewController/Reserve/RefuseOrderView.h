//
//  RefuseOrderView.h
//  WorldView
//
//  Created by WorldView on 15/12/8.
//  Copyright © 2015年 XZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZJ_CommonClass.h"

@protocol RefuseOrderViewDelegate <NSObject>
- (void)RefuseOrderView_DidOperateButtonClick:(UIButton *)sender cell:(UITableViewCell *)cell;
@end

@interface RefuseOrderView : UIView<UITextViewDelegate>
{
    NSTimer *timer;
    UIView *operateView;
    CGRect operateFrame;
    CGFloat alpha;
}
@property(nonatomic, retain) id<RefuseOrderViewDelegate> xDelegate;
@property(nonatomic, retain) UITableViewCell *operateCell;
@property(nonatomic, retain) UITextView *refusetextView;
- (void)show;
- (void)dismiss;
@end
